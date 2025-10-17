<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform xmlns:error="https://doi.org/10.5281/zenodo.1495494#error"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
               xmlns:rna="http://relaxng.org/ns/compatibility/annotations/1.0"
               xmlns:rng="http://relaxng.org/ns/structure/1.0"
               xmlns:sch="http://purl.oclc.org/dsdl/schematron"
               xmlns:sch1x="http://www.ascc.net/xml/schematron"
               xmlns:schxslt="https://doi.org/10.5281/zenodo.1495494"
               xmlns:schxslt-api="https://doi.org/10.5281/zenodo.1495494#api"
               xmlns:tei="http://www.tei-c.org/ns/1.0"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               version="2.0">
   <rdf:Description xmlns:dc="http://purl.org/dc/elements/1.1/"
                    xmlns:dct="http://purl.org/dc/terms/"
                    xmlns:skos="http://www.w3.org/2004/02/skos/core#">
      <dct:creator>
         <dct:Agent>
            <skos:prefLabel>SchXslt/1.10.1 SAXON/HE 10.3</skos:prefLabel>
            <schxslt.compile.typed-variables xmlns="https://doi.org/10.5281/zenodo.1495494#">true</schxslt.compile.typed-variables>
         </dct:Agent>
      </dct:creator>
      <dct:created>2025-09-04T16:14:49.585097427Z</dct:created>
   </rdf:Description>
   <xsl:output indent="yes"/>
   <xsl:param name="schxslt.validate.initial-document-uri" as="xs:string?"/>
   <xsl:template name="schxslt.validate">
      <xsl:apply-templates select="document($schxslt.validate.initial-document-uri)"/>
   </xsl:template>
   <xsl:template match="root()">
      <xsl:param name="schxslt.validate.recursive-call"
                 as="xs:boolean"
                 select="false()"/>
      <xsl:choose>
         <xsl:when test="not($schxslt.validate.recursive-call) and (normalize-space($schxslt.validate.initial-document-uri) != '')">
            <xsl:apply-templates select="document($schxslt.validate.initial-document-uri)">
               <xsl:with-param name="schxslt.validate.recursive-call"
                               as="xs:boolean"
                               select="true()"/>
            </xsl:apply-templates>
         </xsl:when>
         <xsl:otherwise>
            <xsl:variable name="metadata" as="element()?">
               <svrl:metadata xmlns:dct="http://purl.org/dc/terms/"
                              xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                              xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <dct:creator>
                     <dct:Agent>
                        <skos:prefLabel>
                           <xsl:value-of separator="/"
                                         select="(system-property('xsl:product-name'), system-property('xsl:product-version'))"/>
                        </skos:prefLabel>
                     </dct:Agent>
                  </dct:creator>
                  <dct:created>
                     <xsl:value-of select="current-dateTime()"/>
                  </dct:created>
                  <dct:source>
                     <rdf:Description xmlns:dc="http://purl.org/dc/elements/1.1/">
                        <dct:creator>
                           <dct:Agent>
                              <skos:prefLabel>SchXslt/1.10.1 SAXON/HE 10.3</skos:prefLabel>
                              <schxslt.compile.typed-variables xmlns="https://doi.org/10.5281/zenodo.1495494#">true</schxslt.compile.typed-variables>
                           </dct:Agent>
                        </dct:creator>
                        <dct:created>2025-09-04T16:14:49.585097427Z</dct:created>
                     </rdf:Description>
                  </dct:source>
               </svrl:metadata>
            </xsl:variable>
            <xsl:variable name="report" as="element(schxslt:report)">
               <schxslt:report>
                  <xsl:call-template name="d12e32"/>
               </schxslt:report>
            </xsl:variable>
            <xsl:variable name="schxslt:report" as="node()*">
               <xsl:sequence select="$metadata"/>
               <xsl:for-each select="$report/schxslt:document">
                  <xsl:for-each select="schxslt:pattern">
                     <xsl:sequence select="node()"/>
                     <xsl:sequence select="../schxslt:rule[@pattern = current()/@id]/node()"/>
                  </xsl:for-each>
               </xsl:for-each>
            </xsl:variable>
            <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" title="ISO Schematron rules">
               <svrl:ns-prefix-in-attribute-values prefix="tei" uri="http://www.tei-c.org/ns/1.0"/>
               <svrl:ns-prefix-in-attribute-values prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
               <svrl:ns-prefix-in-attribute-values prefix="rng" uri="http://relaxng.org/ns/structure/1.0"/>
               <svrl:ns-prefix-in-attribute-values prefix="rna" uri="http://relaxng.org/ns/compatibility/annotations/1.0"/>
               <svrl:ns-prefix-in-attribute-values prefix="sch" uri="http://purl.oclc.org/dsdl/schematron"/>
               <svrl:ns-prefix-in-attribute-values prefix="sch1x" uri="http://www.ascc.net/xml/schematron"/>
               <xsl:sequence select="$schxslt:report"/>
            </svrl:schematron-output>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="text() | @*" mode="#all" priority="-10"/>
   <xsl:template match="/" mode="#all" priority="-10">
      <xsl:apply-templates mode="#current" select="node()"/>
   </xsl:template>
   <xsl:template match="*" mode="#all" priority="-10">
      <xsl:apply-templates mode="#current" select="@*"/>
      <xsl:apply-templates mode="#current" select="node()"/>
   </xsl:template>
   <xsl:template name="d12e32">
      <schxslt:document>
         <schxslt:pattern id="d12e32">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-CMC_generatedBy_within_post-1"
                                    id="schematron-constraint-CMC_generatedBy_within_post-1">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e41">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-att-datable-w3c-when-2"
                                    id="schematron-constraint-att-datable-w3c-when-2">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e50">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-att-datable-w3c-from-3"
                                    id="schematron-constraint-att-datable-w3c-from-3">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e59">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-att-datable-w3c-to-4"
                                    id="schematron-constraint-att-datable-w3c-to-4">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e68">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-renditionpointer-5"
                                    id="schematron-constraint-renditionpointer-5">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e83">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-corresppointer-6"
                                    id="schematron-constraint-corresppointer-6">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e99">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-only_1_ODD_source-7"
                                    id="schematron-constraint-only_1_ODD_source-7">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e114">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-att-measurement-unitRef-8"
                                    id="schematron-constraint-att-measurement-unitRef-8">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e123">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-targetLang-9"
                                    id="schematron-constraint-targetLang-9">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e134">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-targetLang-10"
                                    id="schematron-constraint-targetLang-10">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e145">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-validtarget-11"
                                    id="schematron-constraint-validtarget-11">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e160">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-spanTo-points-to-following-12"
                                    id="schematron-constraint-spanTo-points-to-following-12">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e174">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-schemeVersionRequiresScheme-13"
                                    id="schematron-constraint-schemeVersionRequiresScheme-13">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e183">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-subtypeTyped-14"
                                    id="schematron-constraint-subtypeTyped-14">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e194">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-calendar_attr_on_empty_element-15"
                                    id="schematron-constraint-calendar_attr_on_empty_element-15">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e205">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-abstractModel-structure-ab-in-l-16"
                                    id="schematron-constraint-abstractModel-structure-ab-in-l-16">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e214">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-noEmptyBibl-17"
                                    id="schematron-constraint-noEmptyBibl-17">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e225">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-choiceContent-18"
                                    id="schematron-constraint-choiceContent-18">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e237">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-deprecationInfo-only-in-deprecated-19"
                                    id="schematron-constraint-deprecationInfo-only-in-deprecated-19">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e246">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-abstractModel-structure-div-in-l-20"
                                    id="schematron-constraint-abstractModel-structure-div-in-l-20">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e255">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-abstractModel-structure-div-in-ab-or-p-21"
                                    id="schematron-constraint-abstractModel-structure-div-in-ab-or-p-21">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e264">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-no_facsimile_text_nodes-22"
                                    id="schematron-constraint-no_facsimile_text_nodes-22">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e273">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-abstractModel-structure-l-in-l-23"
                                    id="schematron-constraint-abstractModel-structure-l-in-l-23">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e282">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-atleast1oflggapl-24"
                                    id="schematron-constraint-atleast1oflggapl-24">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e292">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-abstractModel-structure-lg-in-l-25"
                                    id="schematron-constraint-abstractModel-structure-lg-in-l-25">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e301">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-gloss-list-must-have-labels-26"
                                    id="schematron-constraint-gloss-list-must-have-labels-26">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e310">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-abstractModel-structure-p-in-ab-or-p-27"
                                    id="schematron-constraint-abstractModel-structure-p-in-ab-or-p-27">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e319">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-abstractModel-structure-p-in-l-28"
                                    id="schematron-constraint-abstractModel-structure-p-in-l-28">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e328">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-refAtts-29"
                                    id="schematron-constraint-refAtts-29">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e339">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-targetorcontent1-30"
                                    id="schematron-constraint-targetorcontent1-30">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e354">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-noNestedS-31"
                                    id="schematron-constraint-noNestedS-31">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e363">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-substContents1-32"
                                    id="schematron-constraint-substContents1-32">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e374">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-headeronlyelement-33"
                                    id="schematron-constraint-headeronlyelement-33">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <xsl:apply-templates mode="d12e32" select="root()"/>
      </schxslt:document>
   </xsl:template>
   <xsl:template match="tei:*[@generatedBy]" priority="32" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e32']">
            <schxslt:rule pattern="d12e32">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:*[@generatedBy]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[@generatedBy]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d12e32">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[@generatedBy]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(ancestor-or-self::tei:post)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">ancestor-or-self::tei:post</xsl:attribute>
                     <svrl:text>The @generatedBy attribute is for use within a &lt;post&gt; element.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e32')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:*[@when]" priority="31" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e41']">
            <schxslt:rule pattern="d12e41">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:*[@when]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[@when]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d12e41">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[@when]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="@notBefore|@notAfter|@from|@to">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}"
                                          role="nonfatal">
                     <xsl:attribute name="test">@notBefore|@notAfter|@from|@to</xsl:attribute>
                     <svrl:text>The @when attribute cannot be used with any other att.datable.w3c attributes.</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e41')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:*[@from]" priority="30" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e50']">
            <schxslt:rule pattern="d12e50">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:*[@from]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[@from]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d12e50">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[@from]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="@notBefore">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}"
                                          role="nonfatal">
                     <xsl:attribute name="test">@notBefore</xsl:attribute>
                     <svrl:text>The @from and @notBefore attributes cannot be used together.</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e50')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:*[@to]" priority="29" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e59']">
            <schxslt:rule pattern="d12e59">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:*[@to]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[@to]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d12e59">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[@to]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="@notAfter">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}"
                                          role="nonfatal">
                     <xsl:attribute name="test">@notAfter</xsl:attribute>
                     <svrl:text>The @to and @notAfter attributes cannot be used together.</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e59')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:*[@rendition]" priority="28" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="results"
                    select="for $val in tokenize(normalize-space(@rendition),'\s+') return starts-with($val,'simple:')                              or                              (starts-with($val,'#')                              and                              //tei:rendition[@xml:id=substring($val,2)])"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e68']">
            <schxslt:rule pattern="d12e68">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:*[@rendition]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[@rendition]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d12e68">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[@rendition]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(every $x in $results satisfies $x)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $x in $results satisfies $x</xsl:attribute>
                     <svrl:text> Error: Each of the rendition values in "<xsl:value-of select="@rendition"/>" must point to a local ID or to a token in the Simple scheme (<xsl:value-of select="$results"/>)</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e68')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:*[@corresp]" priority="27" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="results"
                    select="for $t in tokenize(normalize-space(@corresp),'\s+') return starts-with($t,'#') and not(id(substring($t,2)))"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e83']">
            <schxslt:rule pattern="d12e83">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:*[@corresp]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[@corresp]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d12e83">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[@corresp]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="some $x in $results  satisfies $x">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">some $x in $results  satisfies $x</xsl:attribute>
                     <svrl:text> Error: Every local pointer in "<xsl:value-of select="@corresp"/>" must point to an ID in this document (<xsl:value-of select="$results"/>)</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e83')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:*[@source]" priority="26" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="srcs" select="tokenize( normalize-space(@source),' ')"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e99']">
            <schxslt:rule pattern="d12e99">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:*[@source]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[@source]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d12e99">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[@source]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="(   self::tei:classRef                                 | self::tei:dataRef                                 | self::tei:elementRef                                 | self::tei:macroRef                                 | self::tei:moduleRef                                 | self::tei:schemaSpec )                                   and                                   $srcs[2]">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">(   self::tei:classRef                                 | self::tei:dataRef                                 | self::tei:elementRef                                 | self::tei:macroRef                                 | self::tei:moduleRef                                 | self::tei:schemaSpec )                                   and                                   $srcs[2]</xsl:attribute>
                     <svrl:text> When used on a schema description element (like <xsl:value-of select="name(.)"/>), the @source attribute should have only 1 value. (This one has <xsl:value-of select="count($srcs)"/>.)</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e99')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:*[@unitRef]" priority="25" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e114']">
            <schxslt:rule pattern="d12e114">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:*[@unitRef]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[@unitRef]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d12e114">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[@unitRef]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="@unit">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}"
                                          role="info">
                     <xsl:attribute name="test">@unit</xsl:attribute>
                     <svrl:text>The @unit attribute may be unnecessary when @unitRef is present.</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e114')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:*[not(self::tei:schemaSpec)][@targetLang]"
                 priority="24"
                 mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e123']">
            <schxslt:rule pattern="d12e123">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:*[not(self::tei:schemaSpec)][@targetLang]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[not(self::tei:schemaSpec)][@targetLang]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d12e123">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[not(self::tei:schemaSpec)][@targetLang]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@target)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@target</xsl:attribute>
                     <svrl:text>@targetLang should only be used on <xsl:value-of select="name()"/> if @target is specified.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e123')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:*[not(self::tei:schemaSpec)][@targetLang]"
                 priority="23"
                 mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e134']">
            <schxslt:rule pattern="d12e134">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:*[not(self::tei:schemaSpec)][@targetLang]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[not(self::tei:schemaSpec)][@targetLang]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d12e134">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[not(self::tei:schemaSpec)][@targetLang]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@target)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@target</xsl:attribute>
                     <svrl:text>@targetLang should only be used on <xsl:value-of select="name()"/> if @target is specified.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e134')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:*[@target]" priority="22" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="results"
                    select="for $t in tokenize(normalize-space(@target),'\s+') return starts-with($t,'#') and not(id(substring($t,2)))"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e145']">
            <schxslt:rule pattern="d12e145">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:*[@target]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[@target]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d12e145">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[@target]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="some $x in $results satisfies $x">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">some $x in $results satisfies $x</xsl:attribute>
                     <svrl:text> Error: Every local pointer in "<xsl:value-of select="@target"/>" must point to an ID in this document (<xsl:value-of select="$results"/>)</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e145')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:*[ starts-with( @spanTo, '#') ]"
                 priority="21"
                 mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e160']">
            <schxslt:rule pattern="d12e160">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:*[ starts-with( @spanTo, '#') ]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[ starts-with( @spanTo, '#') ]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d12e160">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[ starts-with( @spanTo, '#') ]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(id( substring( @spanTo, 2 ) ) &gt;&gt; .)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">id( substring( @spanTo, 2 ) ) &gt;&gt; .</xsl:attribute>
                     <svrl:text> The element indicated by @spanTo (<xsl:value-of select="@spanTo"/>) must follow the current <xsl:value-of select="name()"/> element</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e160')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:*[@schemeVersion]" priority="20" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e174']">
            <schxslt:rule pattern="d12e174">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:*[@schemeVersion]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[@schemeVersion]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d12e174">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[@schemeVersion]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@scheme and not(@scheme = 'free'))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@scheme and not(@scheme = 'free')</xsl:attribute>
                     <svrl:text> @schemeVersion can only be used if @scheme is specified.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e174')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:*[@subtype]" priority="19" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e183']">
            <schxslt:rule pattern="d12e183">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:*[@subtype]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[@subtype]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d12e183">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[@subtype]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@type)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@type</xsl:attribute>
                     <svrl:text>The <xsl:value-of select="name()"/> element should not be categorized in detail with @subtype unless also categorized in general with @type</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e183')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:*[@calendar]" priority="18" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e194']">
            <schxslt:rule pattern="d12e194">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:*[@calendar]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[@calendar]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d12e194">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[@calendar]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(string-length( normalize-space(.) ) gt 0)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">string-length( normalize-space(.) ) gt 0</xsl:attribute>
                     <svrl:text> @calendar indicates one or more systems or calendars to which the date represented by the content of this element belongs, but this <xsl:value-of select="name()"/> element has no textual content.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e194')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:l//tei:ab" priority="17" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e205']">
            <schxslt:rule pattern="d12e205">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:l//tei:ab" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:l//tei:ab</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d12e205">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:l//tei:ab</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(ancestor::tei:floatingText | parent::tei:figure | parent::tei:note)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">ancestor::tei:floatingText | parent::tei:figure | parent::tei:note</xsl:attribute>
                     <svrl:text> Abstract model violation: Metrical lines may not contain higher-level divisions such as p or ab, unless ab is a child of figure or note, or is a descendant of floatingText.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e205')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:bibl" priority="16" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e214']">
            <schxslt:rule pattern="d12e214">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:bibl" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:bibl</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d12e214">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:bibl</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(child::* or child::text()[normalize-space()])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      role="ERROR">
                     <xsl:attribute name="test">child::* or child::text()[normalize-space()]</xsl:attribute>
                     <svrl:text> Element "<xsl:value-of select="name()"/>" may not be empty.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e214')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:choice" priority="15" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e225']">
            <schxslt:rule pattern="d12e225">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:choice" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:choice</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d12e225">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:choice</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(( tei:corr and tei:sic )                                       or                                       ( tei:expan and tei:abbr )                                       or                                       ( tei:reg and tei:orig ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      role="ERROR">
                     <xsl:attribute name="test">( tei:corr and tei:sic )                                       or                                       ( tei:expan and tei:abbr )                                       or                                       ( tei:reg and tei:orig )</xsl:attribute>
                     <svrl:text> Element "<xsl:value-of select="name()"/>" must have corresponding corr/sic, expand/abbr, reg/orig</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e225')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:desc[ @type eq 'deprecationInfo']"
                 priority="14"
                 mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e237']">
            <schxslt:rule pattern="d12e237">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:desc[ @type eq 'deprecationInfo']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:desc[ @type eq 'deprecationInfo']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d12e237">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:desc[ @type eq 'deprecationInfo']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(../@validUntil)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">../@validUntil</xsl:attribute>
                     <svrl:text>Information about a deprecation should only be present in a specification element that is being deprecated: that is, only an element that has a @validUntil attribute should have a child &lt;desc type="deprecationInfo"&gt;.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e237')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:l//tei:div" priority="13" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e246']">
            <schxslt:rule pattern="d12e246">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:l//tei:div" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:l//tei:div</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d12e246">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:l//tei:div</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(ancestor::tei:floatingText)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">ancestor::tei:floatingText</xsl:attribute>
                     <svrl:text> Abstract model violation: Metrical lines may not contain higher-level structural elements such as div, unless div is a descendant of floatingText.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e246')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:div" priority="12" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e255']">
            <schxslt:rule pattern="d12e255">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:div" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:div</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d12e255">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:div</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="(ancestor::tei:p or ancestor::tei:ab) and not(ancestor::tei:floatingText)">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">(ancestor::tei:p or ancestor::tei:ab) and not(ancestor::tei:floatingText)</xsl:attribute>
                     <svrl:text> Abstract model violation: p and ab may not contain higher-level structural elements such as div, unless div is a descendant of floatingText.</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e255')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:facsimile//tei:line | tei:facsimile//tei:zone"
                 priority="11"
                 mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e264']">
            <schxslt:rule pattern="d12e264">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:facsimile//tei:line | tei:facsimile//tei:zone" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:facsimile//tei:line | tei:facsimile//tei:zone</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d12e264">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:facsimile//tei:line | tei:facsimile//tei:zone</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="child::text()[ normalize-space(.) ne '']">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">child::text()[ normalize-space(.) ne '']</xsl:attribute>
                     <svrl:text> A facsimile element represents a text with images, thus transcribed text should not be present within it.</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e264')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:l" priority="10" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e273']">
            <schxslt:rule pattern="d12e273">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:l" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:l</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d12e273">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:l</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="ancestor::tei:l[not(.//tei:note//tei:l[. = current()])]">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">ancestor::tei:l[not(.//tei:note//tei:l[. = current()])]</xsl:attribute>
                     <svrl:text>Abstract model violation: Lines may not contain lines or lg elements.</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e273')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:lg" priority="9" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e282']">
            <schxslt:rule pattern="d12e282">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:lg" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:lg</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d12e282">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:lg</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(count(descendant::tei:lg|descendant::tei:l|descendant::tei:gap) &gt; 0)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">count(descendant::tei:lg|descendant::tei:l|descendant::tei:gap) &gt; 0</xsl:attribute>
                     <svrl:text>An lg element must contain at least one child l, lg, or gap element.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e282')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:lg" priority="8" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e292']">
            <schxslt:rule pattern="d12e292">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:lg" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:lg</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d12e292">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:lg</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="ancestor::tei:l[not(.//tei:note//tei:lg[. = current()])]">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">ancestor::tei:l[not(.//tei:note//tei:lg[. = current()])]</xsl:attribute>
                     <svrl:text>Abstract model violation: Lines may not contain line groups.</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e292')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:list[@type='gloss']" priority="7" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e301']">
            <schxslt:rule pattern="d12e301">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:list[@type='gloss']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:list[@type='gloss']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d12e301">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:list[@type='gloss']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(tei:label)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">tei:label</xsl:attribute>
                     <svrl:text>The content of a "gloss" list should include a sequence of one or more pairs of a label element followed by an item element</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e301')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:p" priority="6" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e310']">
            <schxslt:rule pattern="d12e310">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:p" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:p</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d12e310">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:p</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="(ancestor::tei:ab or ancestor::tei:p) and                        not( ancestor::tei:floatingText                           | parent::tei:exemplum                           | parent::tei:item                           | parent::tei:note                           | parent::tei:q                           | parent::tei:quote                           | parent::tei:remarks                           | parent::tei:said                           | parent::tei:sp                           | parent::tei:stage                           | parent::tei:cell                           | parent::tei:figure )">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">(ancestor::tei:ab or ancestor::tei:p) and                        not( ancestor::tei:floatingText                           | parent::tei:exemplum                           | parent::tei:item                           | parent::tei:note                           | parent::tei:q                           | parent::tei:quote                           | parent::tei:remarks                           | parent::tei:said                           | parent::tei:sp                           | parent::tei:stage                           | parent::tei:cell                           | parent::tei:figure )</xsl:attribute>
                     <svrl:text> Abstract model violation: Paragraphs may not occur inside other paragraphs or ab elements.</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e310')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:l//tei:p" priority="5" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e319']">
            <schxslt:rule pattern="d12e319">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:l//tei:p" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:l//tei:p</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d12e319">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:l//tei:p</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(ancestor::tei:floatingText | parent::tei:figure | parent::tei:note)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">ancestor::tei:floatingText | parent::tei:figure | parent::tei:note</xsl:attribute>
                     <svrl:text> Abstract model violation: Metrical lines may not contain higher-level structural elements such as div, p, or ab, unless p is a child of figure or note, or is a descendant of floatingText.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e319')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:ref" priority="4" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e328']">
            <schxslt:rule pattern="d12e328">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:ref" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:ref</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d12e328">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:ref</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="@target and @cRef">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@target and @cRef</xsl:attribute>
                     <svrl:text>Only one of the attributes @target and @cRef may be supplied on <xsl:value-of select="name()"/>.</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e328')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:relatedItem" priority="3" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e339']">
            <schxslt:rule pattern="d12e339">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:relatedItem" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:relatedItem</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d12e339">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:relatedItem</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="@target and count( child::* ) &gt; 0">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@target and count( child::* ) &gt; 0</xsl:attribute>
                     <svrl:text>If the @target attribute on <xsl:value-of select="name()"/> is used, the relatedItem element must be empty</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
               <xsl:if test="not(@target or child::*)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@target or child::*</xsl:attribute>
                     <svrl:text>A relatedItem element should have either a @target attribute or a child element to indicate the related bibliographic item</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e339')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:s" priority="2" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e354']">
            <schxslt:rule pattern="d12e354">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:s" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:s</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d12e354">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:s</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="tei:s">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">tei:s</xsl:attribute>
                     <svrl:text>You may not nest one s element within another: use seg instead</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e354')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:subst" priority="1" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e363']">
            <schxslt:rule pattern="d12e363">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:subst" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:subst</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d12e363">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:subst</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(child::tei:add and (child::tei:del or child::tei:surplus))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">child::tei:add and (child::tei:del or child::tei:surplus)</xsl:attribute>
                     <svrl:text>
                        <xsl:value-of select="name()"/> must have at least one child add and at least one child del or surplus</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e363')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:term | tei:biblFull" priority="0" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e374']">
            <schxslt:rule pattern="d12e374">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:term | tei:biblFull" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:term | tei:biblFull</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d12e374">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:term | tei:biblFull</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="ancestor::tei:text">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">ancestor::tei:text</xsl:attribute>
                     <svrl:text>Error: The element <xsl:value-of select="name()"/> is not permitted outside the header</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e374')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:function name="schxslt:location" as="xs:string">
      <xsl:param name="node" as="node()"/>
      <xsl:variable name="segments" as="xs:string*">
         <xsl:for-each select="($node/ancestor-or-self::node())">
            <xsl:variable name="position">
               <xsl:number level="single"/>
            </xsl:variable>
            <xsl:choose>
               <xsl:when test=". instance of element()">
                  <xsl:value-of select="concat('Q{', namespace-uri(.), '}', local-name(.), '[', $position, ']')"/>
               </xsl:when>
               <xsl:when test=". instance of attribute()">
                  <xsl:value-of select="concat('@Q{', namespace-uri(.), '}', local-name(.))"/>
               </xsl:when>
               <xsl:when test=". instance of processing-instruction()">
                  <xsl:value-of select="concat('processing-instruction(&#34;', name(.), '&#34;)[', $position, ']')"/>
               </xsl:when>
               <xsl:when test=". instance of comment()">
                  <xsl:value-of select="concat('comment()[', $position, ']')"/>
               </xsl:when>
               <xsl:when test=". instance of text()">
                  <xsl:value-of select="concat('text()[', $position, ']')"/>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="concat('/', string-join($segments, '/'))"/>
   </xsl:function>
</xsl:transform>
