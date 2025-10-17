# RAG + Neo4j Best Practices

이 문서는 로컬 RAG(FAISS)에서 검색된 텍스트 청크와 Neo4j 그래프 메타데이터를 결합하여 LLM에 안전하게 공급하는 모범 사례를 정리합니다. 구현 예시는 `scripts/rag_prompt_builder.py`, `scripts/neo4j_helpers.py`, `scripts/rag_integration.py`를 참조하세요.

## 계약 (입력 / 출력)
- 입력:
  - question: 사용자 질의 (string)
  - retrieved_chunks: 리스트(dict) — 각 항목은 최소 `id`, `path`, `chunk_index`, `excerpt`를 포함해야 함
  - neo4j_facts: 리스트(dict) — Neo4j에서 추출한 fact 또는 노드 요약; 각 항목은 `id`와 `summary`(또는 관련 속성)를 포함할 수 있음
- 출력:
  - LLM에 전달할 단일 문자열 프롬프트(behavior instructions + context + graph facts + user question + response place)

## 토큰 / 문맥 제한
- LLM 모델별로 토큰 한계가 다릅니다. 안전한 기본값으로 전체 컨텍스트(텍스트 청크 합계 + 그래프 요약 + 지시문)가 4,000자(문자 기준) 미만이 되도록 샘플 코드에서 `max_context_chars=4000`을 사용합니다.
- 권장 플로우:
  1. FAISS(또는 유사 벡터 DB)에서 상위 K개의 청크를 가져온다.
  2. 청크 텍스트 길이로 정렬하거나 score 기반 상위 K를 선택한다.
  3. 필요 시 요약(문장 추출 또는 모델 기반 요약)을 통해 각 청크 길이를 줄인다.

## 청크 선택 가이드라인
- 중복 제거: 청크들이 동일한 텍스트를 많이 포함하면 중복 제거(예: 동일한 `path`에서 인접한 chunk들 병합) 권장.
- 신뢰도/점수 우선: FAISS score와 Neo4j에서 얻은 관련성(예: 동일 파일에 다수의 일치)으로 우선순위 결정.
- 최대 청크 수: 기본 5~10개 권장(모델의 토큰 한계에 따라 조정).

## 인용 규칙 (LLM에게 지시할 내용)
- 모든 사실 진술은 최소한 하나 이상의 소스 태그를 인라인 인용으로 포함해야 한다.
  - 텍스트 청크: [source:<id>] (예: [source:tei/schema/relaxng/tei.rng::chunk::12])
  - 그래프(Neo4j) 요약: [graph:<id>] (예: [graph:tei/schema/relaxng/tei.rng::chunk::12])
- 동일 사실을 여러 소스가 뒷받침하면 쉼표로 연결: [source:id1, source:id2]
- 출처는 가능한 한 구체적으로: 파일 경로 + chunk index 형태의 `id`를 권장

## 안전성 규칙
- 절대 금지: LLM이 주어진 소스에 근거하지 않은 추측(환상, hallucination)을 하지 않도록 지시한다. 출처로 증명할 수 없는 질문은 "I don't know based on the provided sources."로 응답하도록 강제.
- 요약이나 축약을 수행할 경우 원문이 변경되었음을 명시하도록 지시.

## 통합 예시
- 프롬프트 빌드(로컬 dry-run):

```bash
. .venv/bin/activate
NEO4J_PASSWORD=your_pw python scripts/rag_integration.py --question "relaxng의 주요 구조와 정의 파일을 알려줘" --limit 5
```

- 실제 FAISS 연동(개요): `scripts/rag_integration.py`의 `simulate_retrieval`을 실제 FAISS 검색으로 교체하면 됩니다. 예:

1. FAISS에서 (query_embedding) -> 상위 N 개 항목(아이디 + score)을 얻는다.
2. 해당 ids로 `neo4j_helpers.get_chunks_by_ids` 호출해 메타/원문을 보강한다.
3. `build_prompt(question, retrieved_chunks, graph_facts)`로 프롬프트 생성.

## 확장 제안
- 요약 파이프라인: 길이가 큰 청크는 LLM을 이용한 요약 단계로 줄여서 토큰 사용량을 절약.
- 점수 병합: FAISS score와 Neo4j 관련성 점수를 결합해 최종 우선순위를 계산하는 로직 추가.
- 출력 포맷: LLM 응답을 JSON으로 강제하여 downstream 처리(예: cite list, answer, uncertainty)를 쉽게 만들기.

## FAQ
- Q: Neo4j에서 어떤 속성을 인용해야 하나요?
  - A: `Chunk.id`(예: path::chunk::<index>) 를 기본 키로 사용하면 좋습니다. 필요하면 `File` 노드의 `path`나 `title` 등 추가 속성도 포함하세요.

## 마무리
이 문서는 로컬 RAG + Neo4j를 안전하게 결합해 LLM에 공급하는 기본 가이드입니다. 필요하면 조직/도메인 특화 규칙(예: 인용 템플릿, 민감정보 처리 정책)을 추가해 드리겠습니다.
