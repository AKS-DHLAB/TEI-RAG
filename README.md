# TEI-RAG

TEI-RAG는 TEI XML 자료를 구조(Element/Entity) 그래프로 Neo4j에 적재하고, Element 수준 임베딩을 생성해 FAISS 인덱스로 검색하는 RAG( Retrieval-Augmented Generation ) 파이프라인입니다. 로컬 LLM(또는 원격 모델)과 통합한 Streamlit UI를 통해 질문을 입력하고, 구조적/시맨틱 검색 결과를 검토하며 LLM 응답을 생성할 수 있습니다.

이 README는 로컬 개발 환경(macOS 기준)에서 프로젝트를 설정하고 실행하는 방법, 주요 스크립트와 파일의 역할, 자주 발생하는 문제 및 해결 방법을 정리합니다.

## 주요 구성 요소

- `scripts/tei_to_neo4j.py` — TEI/XML 파일을 파싱해 `:Element`, `:Entity` 노드와 `:ELEMENT_CHILD`, `:CONTAINS`, `:CONTAINS_ENTITY` 관계를 Neo4j에 생성합니다. Element 임베딩을 계산하고 Neo4j의 `e.embedding` 속성으로 저장할 수 있습니다. 또한 Element 임베딩으로 FAISS 인덱스를 재구성합니다.
- `scripts/rag_integration.py` — Neo4j 구조 검색과 FAISS 기반 의미 검색을 결합하는 RAG 오케스트레이션 유틸리티입니다. (검색/재정렬/프롬프트 빌더 관련 함수 포함)
- `scripts/ui_streamlit.py` — Streamlit 기반 UI. FAISS 인덱스와 Neo4j를 사용해 질의/검색/LLM 생성 워크플로를 제공합니다.
- `scripts/utils.py` — 중앙 설정, Neo4j 자격 로더, 임베더 캐시와 기본 임베딩 모델(`DEFAULT_EMBED_MODEL = "BAAI/bge-m3"`) 정의.
- `data/` — FAISS 인덱스 파일(`*.index`) 및 메타(`*.meta.json`)를 보관합니다.

## 요구사항

- Python 3.10+ (권장)
- 권장: 가상환경 (venv)
- 필수 라이브러리(일부는 선택적):
  - `neo4j` (Python driver)
  - `faiss-cpu`
  - `numpy`
  - `lxml` (TEI XML 파싱)
  - `sentence-transformers` 또는 `transformers` + `torch` (임베딩)
  - `streamlit` (UI)

간단 설치 예시 (venv 사용):

```bash
python -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt  # 또는 아래 패키지들
pip install neo4j faiss-cpu numpy lxml sentence-transformers torch transformers streamlit
```

참고: macOS Apple Silicon에서는 PyTorch MPS 관련 메모리 제약이 있으므로 임베딩 연산은 CPU 모드로 강제하거나 더 큰 메모리의 머신에서 실행하는 것을 권장합니다. (환경변수 `FORCE_EMBED_CPU=1` 사용)

## 설정 (Neo4j)

1. 로컬 Neo4j(또는 원격)를 실행하세요. 기본 설정은 `bolt://localhost:7687`입니다.
2. 자격은 환경변수 또는 `config/neo4j.ini`에 설정할 수 있습니다. 예:`NEO4J_USER`, `NEO4J_PASSWORD`, `NEO4J_URI`.

예시 `config/neo4j.ini`:

```ini
[neo4j]
NEO4J_URI=bolt://localhost:7687
NEO4J_USER=neo4j
NEO4J_PASSWORD=mysecret
```

## 사용법 요약

1. TEI 파일에서 Element/Entity 그래프 생성(및 Element 임베딩/FAISS 재생성 포함):

```bash
# 메타 파일: data/faiss_tei_meta.json (각 file path 와 chunk 메타 포함)
export NEO4J_PASSWORD=mysecret
.venv/bin/python scripts/tei_to_neo4j.py --meta-file data/faiss_tei_meta.json --extract-graph --element-embeddings --rebuild-faiss --faiss-out data/faiss_elements.index
```

2. 누락된 Element 임베딩만 채우고 FAISS 재생성(권장, CPU 강제):

```bash
export FORCE_EMBED_CPU=1
.venv/bin/python scripts/tei_to_neo4j.py --meta-file data/faiss_tei_meta.json --fill-missing-embeddings --rebuild-faiss --faiss-out data/faiss_elements.index
```

3. Streamlit UI 실행 (UI에서 FAISS/Neo4j를 통해 질의 및 LLM 테스트):

```bash
export PYTHONPATH=$(pwd)
export NEO4J_PASSWORD=mysecret
.venv/bin/python -m streamlit run scripts/ui_streamlit.py --server.port 8501
# 브라우저에서 http://localhost:8501 접속
```

UI 사이드바에서 `FAISS meta JSON` 및 `FAISS index file`을 `data/faiss_elements.meta.json` / `data/faiss_elements.index`로 바꾸면 Element 레벨 검색을 바로 테스트할 수 있습니다.

## 자주 발생하는 문제 및 해결

- Neo4j 인증 오류(Unsupported authentication token):
  - `NEO4J_PASSWORD`가 설정되어 있는지 확인하세요. `config/neo4j.ini`가 있다면 스크립트가 자동으로 불러오도록 되어 있습니다.
- Embedding 계산 중 메모리 부족(MPS 관련):
  - macOS MPS는 메모리 상한 또는 단편화로 인해 큰 모델에서 예기치 않게 실패할 수 있습니다. `FORCE_EMBED_CPU=1`를 사용해 CPU로 계산하거나 더 큰 리소스(GPU 서버)에서 실행하세요.
  - 배치 사이즈를 줄이거나 문장 길이를 제한해 메모리를 낮추는 것도 효과적입니다.
- FAISS 인덱스가 크거나 읽기 실패 시:
  - `faiss-cpu`가 설치되어 있는지 확인하세요. (macOS에서는 빌드가 필요할 수 있음)

## 개발 및 확장 아이디어

- 더 작은/빠른 검색을 위해 FAISS에 IVF/OPQ, HNSW 같은 근사 인덱스 사용을 고려하세요.
- Entity 정규화: 현재는 canonical hash를 사용해 엔티티를 만들고 있습니다. 유사도 기반 병합 또는 외부 표준(예: VIAF) 매칭을 추가할 수 있습니다.
- Streamlit UI에서 검색 결과의 시각화를 개선(트리 뷰, Element context 표시)하거나, 원클릭으로 인용된 Chunk를 LLM 프롬프트에 삽입하도록 할 수 있습니다.

## 파일 요약

- `scripts/tei_to_neo4j.py` — TEI 추출/Neo4j 쓰기/임베딩/FAISS 재생성
- `scripts/rag_integration.py` — 구조+시맨틱 검색 조합 유틸
- `scripts/ui_streamlit.py` — Streamlit UI
- `scripts/utils.py` — 설정, 임베더 로딩, 기본 모델
- `data/*.index`, `data/*.meta.json` — FAISS 인덱스 및 메타

## 지원
문제가 발생하면 실행 로그(터미널 출력), 사용한 커맨드, `config/neo4j.ini`의 존재 여부 정보를 알려주시면 빠르게 원인을 분석해 도와드리겠습니다.

---
마지막 업데이트: 2025-10-22

## 모델(Models)

이 프로젝트에서 기본으로 사용되는 모델과 권장 대체 모델, 그리고 임베더/LLM을 변경하는 방법을 정리합니다.

- 기본 임베더(Embedder): `BAAI/bge-m3`
  - 중앙 설정: `scripts/utils.py`의 `DEFAULT_EMBED_MODEL`에 정의되어 있습니다.
  - 임베딩 차원: 1024 (현재 환경에서 확인된 값)
  - 사용 이유: 고성능 중국어/다국어 대규모 벡터 모델로 높은 표현력을 제공합니다. 필요에 따라 더 빠른 모델(예: `all-MiniLM-L6-v2`)로 대체해 응답 시간을 줄일 수 있습니다.

- 대체 임베더 권장
  - 빠른(경량) 옵션: `sentence-transformers/all-MiniLM-L6-v2` (384-dim)
  - 저비용/로컬 CPU용: `paraphrase-multilingual-MiniLM-L12-v2`

- 기본 LLM(예시): `kakaocorp/kanana-nano-2.1b-base`
  - 이 저장소의 예제에서 LLM 기본값으로 사용된 모델입니다(가벼운 테스트용). 실제 워크로드에서는 더 큰 모델(지연/자원 고려)이나 원격 API를 사용할 수 있습니다.
  - LLM을 변경하려면 Streamlit 사이드바 또는 CLI 인자(`--llm-model`)로 모델명을 넘기면 됩니다. 로컬 HF 모델을 쓸 때는 `trust_remote_code` 옵션을 주의해서 사용하세요.

- 디바이스/메모리 팁
  - macOS Apple Silicon(MPS) 사용 시 메모리 부족 에러가 발생할 수 있습니다. 다음 중 하나를 권장합니다:
    - 임베딩은 CPU로 강제: `FORCE_EMBED_CPU=1` 환경변수 설정
    - 작은/경량 임베더 사용(예: MiniLM)
    - 임베딩을 미리 생성해 FAISS 인덱스를 보관하고, UI에서는 인덱스만 로드
  - LLM은 GPU(MPS 또는 CUDA)가 있는 환경에서 속도가 빠릅니다. 로컬 머신이 부족하면 원격 API(예: OpenAI, HF inference) 사용을 권장합니다.

- README에 있는 CLI 예제에서 `--embed-model` 또는 `--llm-model` 플래그로 모델을 오버라이드할 수 있습니다. 예:

```bash
# 임베더를 바꿔서 임베딩/FAISS 재생성
.venv/bin/python scripts/tei_to_neo4j.py --meta-file data/faiss_tei_meta.json --extract-graph --element-embeddings --rebuild-faiss --faiss-out data/faiss_elements.index --embed-model sentence-transformers/all-MiniLM-L6-v2

# rag_integration에 다른 LLM을 지정
python scripts/rag_integration.py --question "..." --call-llm --llm-model gpt2-medium
```

# dh-rag — Local RAG demo (TEI → FAISS → Neo4j → local LLM)

간단한 설명
----------------

목표
- 로컬에서 문서 검색(FAISS) → 지식 보강(Neo4j) → LLM 응답을 빠르게 실험
- macOS(M1/M2) 환경에서 MPS를 활용하거나 CPU로 동작하도록 안전한 폴백 제공

주요 스크립트
- `scripts/build_tei_faiss.py` — TEI를 청크화하고 FAISS 인덱스와 메타 JSON 생성
- `scripts/tei_to_neo4j.py` — 메타 JSON을 Neo4j에 적재 (Chunk.id 형식: `{path}::chunk::{index}`)
- `scripts/rag_integration.py` — FAISS 검색, Neo4j facts 병합, 프롬프트 빌드 및 (옵션) 로컬 LLM 호출
- `scripts/neo4j_helpers.py` — Neo4j 드라이버 및 검색 헬퍼
- `scripts/llm_local.py` — 로컬 Hugging Face 모델 로드 및 생성 유틸리티
- `scripts/generate_requirements.py` — 현재 환경에서 requirements.txt를 생성(도움용)
- `scripts/rag_index_and_query.py` — 문서 색인 생성 및 간단 쿼리(통합 테스트/예제)
- `scripts/reset_neo4j.cypher` — Neo4j 테스트/초기화용 Cypher 스크립트

빠른 시작
----------------

```bash
# 1) 가상환경 생성 및 의존성 설치
python -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

2) (선택) FAISS 인덱스 생성

```bash
# 가상환경을 활성화한 뒤 실행
source .venv/bin/activate
python scripts/build_tei_faiss.py --input-dir tei/schema --output-index data/faiss_tei.index --output-meta data/faiss_tei_meta.json
```

3) Neo4j에 메타 적재 (실행 전 `config/neo4j.ini` 또는 환경변수 설정 필요)

```bash
# 환경변수 방식
export NEO4J_PASSWORD=your_password
source .venv/bin/activate
python scripts/tei_to_neo4j.py --meta-file data/faiss_tei_meta.json

# 또는 config/neo4j.ini 파일을 사용
source .venv/bin/activate
python scripts/tei_to_neo4j.py --meta-file data/faiss_tei_meta.json
```

Neo4j 설정 제안
----------------

```ini
NEO4J_URI=bolt://localhost:7687
NEO4J_USER=neo4j
NEO4J_PASSWORD=your_password_here
```

간단한 RAG 실행(프롬프트 미리보기)
----------------

```bash
python scripts/rag_integration.py --question "TEI에서 element 'text'의 용도는 무엇인가요?" --limit 3 --use-faiss
```

로컬 LLM을 호출하려면(예: kanana-nano로 스모크 테스트):

```bash
python scripts/rag_integration.py --question "TEI에서 element 'text'의 용도는 무엇인가요?" --limit 3 --use-faiss --call-llm --llm-model kakaocorp/kanana-nano-2.1b-base --force-json --max-new-tokens 128
```

kanana 모델 사용 안내
----------------

디버깅 및 로그
----------------
- Streamlit UI를 사용하는 경우 `logs/streamlit_background.log` (백그라운드 실행 시)에 서버 로그가 기록됩니다.

문제 해결 체크리스트
----------------
2. Neo4j 실행 확인 및 `NEO4J_PASSWORD` 설정
3. `logs/`의 관련 로그 확인

라이선스
----------------

더 필요한 것
----------------
- kanana 프롬프트 튜닝(응답을 안정적으로 JSON으로 얻기)
- Streamlit UI 개선 또는 모델 로드 분리(worker) 아키텍처 제안

샘플 질문 (예제)
----------------

- TEI/문서 관련
  - "TEI에서 element 'text'의 용도는 무엇인가요?"
  - "문서에서 'chapter'와 'section'의 차이점을 요약해 주세요."

- 사실 조회 / 인용 테스트
  - "이 문서에서 'king' 관련 문단을 찾아 요약해 주세요.  (limit 3)"
  - "다음 인용 형식으로 답변해 주세요: [JSON] {\"answer\": ..., \"citations\": [\"{path}::chunk::0\"] }"

- 일반 질의(샘플)
  - "이 프로젝트의 목적을 2문장으로 요약해 주세요."
  - "FAISS와 Neo4j를 결합한 RAG의 장점은 무엇인가요?"

예시 사용법:

```bash
# 프롬프트 미리보기
python scripts/rag_integration.py --question "TEI에서 element 'text'의 용도는 무엇인가요?" --limit 3 --use-faiss

# kanana 테스트(예시)
python scripts/rag_integration.py --question "문서에서 'chapter'와 'section'의 차이점을 요약해 주세요." --limit 3 --use-faiss --call-llm --llm-model kakaocorp/kanana-nano-2.1b-base --force-json --max-new-tokens 128
```


실행 방법 (How to run)
다음 섹션은 로컬에서 Neo4j와 Streamlit UI를 실행하고 CLI 스크립트를 테스트하는 구체적인 명령을 제공합니다. macOS/zsh 환경을 기준으로 작성했습니다.

1) Neo4j 시작(로컬 서비스 예시)

- Homebrew로 설치된 경우:

```bash
# Homebrew 서비스로 시작
brew services start neo4j
# 상태 확인
brew services list | grep neo4j
```

- 또는 neo4j CLI가 있는 경우:

```bash
neo4j console   # 포그라운드로 실행 (로그를 콘솔에서 확인)
neo4j start     # 백그라운드 시작
neo4j status
```

Neo4j가 시작되면 기본 Bolt 포트(7687)를 확인하세요. 간단한 연결 테스트(파이썬) :

```bash
source .venv/bin/activate
python - <<'PY'
from neo4j import GraphDatabase
import os
pw = os.environ.get('NEO4J_PASSWORD') or 'neo4j'
drv = GraphDatabase.driver(os.environ.get('NEO4J_URI','bolt://localhost:7687'), auth=(os.environ.get('NEO4J_USER','neo4j'), pw))
with drv.session() as s:
  print(s.run('RETURN 1 AS ok').single())
drv.close()
PY
```

2) Streamlit UI 실행

- 권장(런처 사용): 리포지토리에 포함된 런처 스크립트는 Neo4j를 확인하고 Streamlit을 안전하게 백그라운드에서 띄우도록 설계되어 있습니다. (터미널에서 실행하면 `logs/streamlit_background.log`로 로그를 남깁니다.)

```bash
source .venv/bin/activate
python scripts/ui_streamlit.py
# 스크립트가 백그라운드로 Streamlit을 띄우면 로그 파일 경로가 출력됩니다.
```

- 직접 실행(개발/디버깅): Streamlit을 포그라운드로 직접 띄워 UI를 개발하려면

```bash
source .venv/bin/activate
streamlit run scripts/ui_streamlit.py
```

참고: Streamlit/모델 적재 관련 문제(예: native extension 충돌, 세마포어 누수, HF hub timeout)가 발생하면 모델 로드를 분리한 worker 프로세스로 돌리거나, Streamlit을 재시작하기 전에 시스템 세마포어를 정리(재부팅 포함)하는 것을 권장합니다.

3) 로그 확인

```bash
# Streamlit 백그라운드 로그
tail -n 500 logs/streamlit_background.log
tail -f logs/streamlit_background.log

# LLM 원문 출력 로그(예시)
ls -1 logs/llm_raw_* || true
tail -n 200 logs/llm_raw_<model>_<ts>.txt  # 실제 파일명으로 바꿔서 확인
```

4) CLI 예제(프롬프트/LLM 테스트)

프롬프트만 생성(LLM 호출 없음):

```bash
source .venv/bin/activate
python scripts/rag_integration.py --question "TEI에서 element 'text'의 용도는 무엇인가요?" --limit 3 --use-faiss
```

# 로컬 LLM 호출(간단한 스모크 테스트):

```bash
source .venv/bin/activate
python scripts/rag_integration.py --question "TEI에서 element 'text'의 용도는 무엇인가요?" --limit 3 --use-faiss --call-llm --llm-model kakaocorp/kanana-nano-2.1b-base --force-json --max-new-tokens 128
```

kanana 모델 예시(대규모 모델, 다운로드/로딩 시간 주의):

```bash
export NEO4J_PASSWORD=$(sed -n 's/^NEO4J_PASSWORD=\(.*\)/\1/p' config/neo4j.ini | head -n1)
source .venv/bin/activate
python scripts/rag_integration.py --question "TEI에서 element 'text'의 용도는 무엇인가요?" --limit 3 --use-faiss --call-llm --llm-model kakaocorp/kanana-nano-2.1b-base --force-json --trust-remote-code --max-new-tokens 256
```

추가 팁
- 브라우저에서 Streamlit이 로드되지 않으면 `http://127.0.0.1:8501`로 접속해 보세요. 확장 프로그램(AdBlock), 캐시, 또는 `localhost`와 `127.0.0.1` 차이가 원인일 수 있습니다.
- HF hub 다운로드 타임아웃이 잦으면 모델을 수동으로 캐시하거나 네트워크 환경을 확인하세요.

# dh-rag — Local RAG demo (macOS / MPS guidance)

이 저장소는 Hugging Face 모델을 사용한 간단한 로컬 RAG(Retriever-Augmented Generation) 데모를 포함합니다. 원래 nanochat 관련 실험을 진행했으나 macOS / Python 호환성 이슈로 간소화된 RAG 스크립트가 배치되어 있습니다.

요약
- `scripts/rag_index_and_query.py` — 문서로부터 FAISS 인덱스를 만들고(또는 이미 만든 인덱스를 불러) 질의 시 관련 컨텍스트를 검색하여 HF causal LM으로 답변을 생성하는 간단한 스크립트입니다.
- `.venv` — RAG용 가상환경(부트스트랩 스크립트로 생성됨).
- `requirements-rag.txt` — RAG 환경에 필요한 패키지 목록.

중요: macOS(M1/M2 등 Apple Silicon) 특이사항
- macOS에서는 CUDA가 일반적으로 지원되지 않으므로 bitsandbytes의 8-bit 양자화는 동작하지 않습니다. 따라서 `--use-8bit` 옵션은 macOS에서 자동으로 비활성화되고, 스크립트는 가능한 경우 MPS(fp16)로 폴백합니다.
- Apple Silicon에서 PyTorch는 MPS(Apple Metal Performance Shaders)를 통해 GPU 가속을 제공합니다. 성능과 호환성은 PyTorch 버전 및 모델에 따라 달라질 수 있습니다.

빠른 시작

1) 가상환경 생성 및 설치 (부트스트랩이 이미 있는 경우 생략)

```bash
# 부트스트랩이 제공된 경우
```markdown
# dh-rag — Local RAG demo (TEI → FAISS → Neo4j → local LLM)

간단한 설명
- 이 리포지토리는 TEI/schema 문서를 청크화하여 FAISS 인덱스로 만들고, 검색된 텍스트 청크와 Neo4j의 그래프 사실을 결합해 로컬 Hugging Face 모델(예: `kakaocorp/kanana-nano-2.1b-base`)로 질의하는 RAG 파이프라인 예시를 제공합니다.

주요 스크립트
- `scripts/build_tei_faiss.py` — TEI 파일을 청크화하고 임베딩하여 FAISS 인덱스(`data/faiss_tei.index`)와 메타(`data/faiss_tei_meta.json`)를 생성합니다.
- `scripts/tei_to_neo4j.py` — 메타 JSON을 Neo4j에 File/Chunk 노드로 적재합니다. (Chunk.id는 `{path}::chunk::{index}` 형식으로 저장됩니다.)
- `scripts/rag_integration.py` — FAISS 검색, Neo4j 사실 조회, 프롬프트 조립, (옵션)로 로컬 LLM 호출 및 JSON 파싱/인용 확장을 수행하는 통합 스크립트입니다.
- `scripts/neo4j_helpers.py` — Neo4j 드라이버, fulltext 검색 및 id로 청크 조회 헬퍼.
- `scripts/llm_local.py` — Hugging Face 모델을 로컬에서 로드하고 생성하는 유틸리티(장치 자동 감지, 8-bit 지원 시도 포함).

빠른 시작

1) 가상환경 생성 및 의존성 설치

```bash
python -m venv .venv-rag
source .venv-rag/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

2) FAISS 인덱스(이미 생성되어 있다면 이 단계는 생략)

```bash
source .venv-rag/bin/activate
python scripts/build_tei_faiss.py --input-dir tei/schema --output-index data/faiss_tei.index --output-meta data/faiss_tei_meta.json
```

3) Neo4j에 메타 적재 (실제 실행 전 `config/neo4j.ini` 또는 환경변수 설정 필요)

```bash
# 환경변수 방식
export NEO4J_PASSWORD=your_password
python scripts/tei_to_neo4j.py --meta-file data/faiss_tei_meta.json

# 또는 config/neo4j.ini 파일 생성 후 (이미 프로젝트에 사용하는 예시 파일이 있습니다)
python scripts/tei_to_neo4j.py --meta-file data/faiss_tei_meta.json
```

Neo4j 구성
- 권장: `config/neo4j.ini`에 다음을 넣고 `.gitignore`에 추가해 로컬에 보관하세요:

```ini
NEO4J_URI=bolt://localhost:7687
NEO4J_USER=neo4j
NEO4J_PASSWORD=your_password_here
```

E2E 실행 (dry-run 및 LLM 콜)
- dry-run: 프롬프트만 생성하여 확인

```bash
python scripts/rag_integration.py --question "TEI에서 element 'text'의 용도는 무엇인가요?" --limit 3 --use-faiss
```

-- 로컬 LLM 호출(예: kanana-nano로 빠른 스모크 테스트)

```bash
python scripts/rag_integration.py --question "TEI에서 element 'text'의 용도는 무엇인가요?" --limit 3 --use-faiss --call-llm --llm-model kakaocorp/kanana-nano-2.1b-base --force-json --max-new-tokens 128
```

- kanana(사용자 환경에 따라 대형 모델; trust_remote_code 필요)

```bash
export NEO4J_PASSWORD=$(sed -n 's/^NEO4J_PASSWORD=\(.*\)/\1/p' config/neo4j.ini | head -n1)
python scripts/rag_integration.py --question "TEI에서 element 'text'의 용도는 무엇인가요?" --limit 3 --use-faiss --call-llm --llm-model kakaocorp/kanana-nano-2.1b-base --force-json --trust-remote-code --max-new-tokens 256
```

로그와 디버깅
- LLM의 원문 출력(raw outputs)은 `logs/` 폴더에 `llm_raw_<model>_<ts>.txt` 형식으로 저장됩니다. kanana 테스트를 실행하면 이 파일을 확인해 모델이 실제로 무엇을 출력했는지 분석할 수 있습니다.

kanana JSON 안정성 주의사항
- 경험적으로 kanana는 프롬프트에 포함된 '예제'를 그대로 반복하는 경향이 있었습니다. 이로 인해 예제가 그대로 응답에 포함되거나 경로가 축약된 형태("...")로 나타날 수 있습니다.
  - 권장 대응: README에 있는 예제 대신 템플릿/강제 문구(예: "Your response MUST START with <JSON>...")를 사용하고, 필요시 프롬프트에서 예제를 제거하여 재시도하세요.
  - 스크립트(`scripts/rag_integration.py`)는 여러 단계의 재시도(비샘플, 짧은 컨텍스트, 저온 샘플)를 포함하며, 마커 기반 추출과 휴리스틱 추출을 수행하도록 설계되어 있습니다.

추가 팁
- Neo4j 인용 확장: `tei_to_neo4j.py`는 Chunk.id를 `{path}::chunk::{chunk_index}`로 생성합니다. LLM에서 반환된 citation 문자열은 이 형식으로 정규화한 뒤 `get_chunks_by_ids`로 조회합니다.
- 성능: Apple Silicon(MPS)을 사용할 경우 `scripts/llm_local.py`가 자동으로 MPS 또는 CPU로 폴백합니다. CUDA가 있는 환경에서는 bitsandbytes 8-bit를 사용하도록 시도합니다.

문제 발생 시 체크리스트
1. `data/faiss_tei.index`와 `data/faiss_tei_meta.json`이 존재하는지 확인
2. Neo4j가 실행 중인지, `NEO4J_PASSWORD`가 설정되어 있는지 확인
3. `logs/`의 raw LLM 출력 파일을 확인해 모델이 어떤 문자열을 반환했는지 검토

개발자 노트
- `scripts/rag_integration.py`는 프롬프트 빌드, FAISS 검색, Neo4j facts 병합, LLM 호출, JSON 파싱(마커/균형중괄호/휴리스틱), citation 정규화 및 확장까지 포함합니다.

원하시면 다음을 도와드립니다
- kanana 출력이 안정적으로 JSON을 내보내도록 프롬프트 튜닝을 도와드리거나, 결과를 자동으로 리포트(HTML/JSON)하도록 추가 스크립트를 작성해 드립니다.

정리 및 복구(재생성) 가이드
----------------
중간 산물(가상환경, 인덱스, 로그 등)은 공개 저장소에 포함되지 않도록 관리해야 합니다. 가상환경은 로컬에서 새로 생성하시고, 필요한 경우 `requirements.txt`로 재설치해 주세요.
