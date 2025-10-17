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
      <dct:created>2025-09-04T16:13:54.308017181Z</dct:created>
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
                        <dct:created>2025-09-04T16:13:54.308017181Z</dct:created>
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
                                    name="schematron-constraint-only_1_ODD_source-5"
                                    id="schematron-constraint-only_1_ODD_source-5">
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
                                    name="schematron-constraint-att-measurement-unitRef-6"
                                    id="schematron-constraint-att-measurement-unitRef-6">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e93">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-targetLang-7"
                                    id="schematron-constraint-targetLang-7">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e104">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-spanTo-points-to-following-8"
                                    id="schematron-constraint-spanTo-points-to-following-8">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e117">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-schemeVersionRequiresScheme-9"
                                    id="schematron-constraint-schemeVersionRequiresScheme-9">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e126">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-subtypeTyped-10"
                                    id="schematron-constraint-subtypeTyped-10">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e137">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-calendar_attr_on_empty_element-11"
                                    id="schematron-constraint-calendar_attr_on_empty_element-11">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e148">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-abstractModel-structure-p-in-ab-or-p-12"
                                    id="schematron-constraint-abstractModel-structure-p-in-ab-or-p-12">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e158">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-abstractModel-structure-p-in-l-13"
                                    id="schematron-constraint-abstractModel-structure-p-in-l-13">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e167">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-deprecationInfo-only-in-deprecated-14"
                                    id="schematron-constraint-deprecationInfo-only-in-deprecated-14">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e176">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-rt-target-not-span-15"
                                    id="schematron-constraint-rt-target-not-span-15">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e185">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-rt-from-16"
                                    id="schematron-constraint-rt-from-16">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e196">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-rt-to-17"
                                    id="schematron-constraint-rt-to-17">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e207">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-ptrAtts-18"
                                    id="schematron-constraint-ptrAtts-18">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e219">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-refAtts-19"
                                    id="schematron-constraint-refAtts-19">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e230">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-gloss-list-must-have-labels-20"
                                    id="schematron-constraint-gloss-list-must-have-labels-20">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e239">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-targetorcontent1-21"
                                    id="schematron-constraint-targetorcontent1-21">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e253">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-abstractModel-structure-l-in-l-22"
                                    id="schematron-constraint-abstractModel-structure-l-in-l-22">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e262">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-atleast1oflggapl-23"
                                    id="schematron-constraint-atleast1oflggapl-23">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e271">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-abstractModel-structure-lg-in-l-24"
                                    id="schematron-constraint-abstractModel-structure-lg-in-l-24">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e281">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-quotationContents-25"
                                    id="schematron-constraint-quotationContents-25">
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
                                    name="schematron-constraint-citestructure-outer-match-26"
                                    id="schematron-constraint-citestructure-outer-match-26">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e303">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-citestructure-inner-match-27"
                                    id="schematron-constraint-citestructure-inner-match-27">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e314">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-linkTargets3-28"
                                    id="schematron-constraint-linkTargets3-28">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e325">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-abstractModel-structure-ab-in-l-29"
                                    id="schematron-constraint-abstractModel-structure-ab-in-l-29">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e334">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-joinTargets3-30"
                                    id="schematron-constraint-joinTargets3-30">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e346">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-nested_standOff_should_be_typed-31"
                                    id="schematron-constraint-nested_standOff_should_be_typed-31">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e359">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-abstractModel-structure-div-in-l-32"
                                    id="schematron-constraint-abstractModel-structure-div-in-l-32">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e368">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-abstractModel-structure-div-in-ab-or-p-33"
                                    id="schematron-constraint-abstractModel-structure-div-in-ab-or-p-33">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e377">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-ref-or-key-or-name-34"
                                    id="schematron-constraint-ref-or-key-or-name-34">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e386">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-active-mutual-35"
                                    id="schematron-constraint-active-mutual-35">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e395">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-active-passive-36"
                                    id="schematron-constraint-active-passive-36">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e405">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-no_facsimile_text_nodes-37"
                                    id="schematron-constraint-no_facsimile_text_nodes-37">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e414">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-pathmustnotbeclosed-38"
                                    id="schematron-constraint-pathmustnotbeclosed-38">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e436">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-addSpan-requires-spanTo-39"
                                    id="schematron-constraint-addSpan-requires-spanTo-39">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e447">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-damageSpan-requires-spanTo-41"
                                    id="schematron-constraint-damageSpan-requires-spanTo-41">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e458">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-delSpan-requires-spanTo-43"
                                    id="schematron-constraint-delSpan-requires-spanTo-43">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e469">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-substContents1-45"
                                    id="schematron-constraint-substContents1-45">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e481">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-one_ms_singleton_max-46"
                                    id="schematron-constraint-one_ms_singleton_max-46">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e496">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-catchword_in_msDesc-47"
                                    id="schematron-constraint-catchword_in_msDesc-47">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e507">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-duplicateDim-48"
                                    id="schematron-constraint-duplicateDim-48">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e528">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-secFol_in_msDesc-49"
                                    id="schematron-constraint-secFol_in_msDesc-49">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e539">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-signatures_in_msDesc-50"
                                    id="schematron-constraint-signatures_in_msDesc-50">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e550">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-msId_minimal-51"
                                    id="schematron-constraint-msId_minimal-51">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <xsl:apply-templates mode="d12e32" select="root()"/>
      </schxslt:document>
   </xsl:template>
   <xsl:template match="tei:*[@generatedBy]" priority="47" mode="d12e32">
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
   <xsl:template match="tei:*[@when]" priority="46" mode="d12e32">
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
   <xsl:template match="tei:*[@from]" priority="45" mode="d12e32">
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
   <xsl:template match="tei:*[@to]" priority="44" mode="d12e32">
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
   <xsl:template match="tei:*[@source]" priority="43" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="srcs" select="tokenize( normalize-space(@source),' ')"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e68']">
            <schxslt:rule pattern="d12e68">
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
            <schxslt:rule pattern="d12e68">
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
                               select="($schxslt:patterns-matched, 'd12e68')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:*[@unitRef]" priority="42" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e83']">
            <schxslt:rule pattern="d12e83">
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
            <schxslt:rule pattern="d12e83">
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
                               select="($schxslt:patterns-matched, 'd12e83')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:*[not(self::tei:schemaSpec)][@targetLang]"
                 priority="41"
                 mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e93']">
            <schxslt:rule pattern="d12e93">
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
            <schxslt:rule pattern="d12e93">
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
                               select="($schxslt:patterns-matched, 'd12e93')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:*[ starts-with( @spanTo, '#') ]"
                 priority="40"
                 mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e104']">
            <schxslt:rule pattern="d12e104">
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
            <schxslt:rule pattern="d12e104">
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
                               select="($schxslt:patterns-matched, 'd12e104')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:*[@schemeVersion]" priority="39" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e117']">
            <schxslt:rule pattern="d12e117">
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
            <schxslt:rule pattern="d12e117">
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
                               select="($schxslt:patterns-matched, 'd12e117')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:*[@subtype]" priority="38" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e126']">
            <schxslt:rule pattern="d12e126">
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
            <schxslt:rule pattern="d12e126">
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
                               select="($schxslt:patterns-matched, 'd12e126')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:*[@calendar]" priority="37" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e137']">
            <schxslt:rule pattern="d12e137">
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
            <schxslt:rule pattern="d12e137">
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
                               select="($schxslt:patterns-matched, 'd12e137')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:p" priority="36" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e148']">
            <schxslt:rule pattern="d12e148">
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
            <schxslt:rule pattern="d12e148">
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
                               select="($schxslt:patterns-matched, 'd12e148')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:l//tei:p" priority="35" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e158']">
            <schxslt:rule pattern="d12e158">
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
            <schxslt:rule pattern="d12e158">
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
                               select="($schxslt:patterns-matched, 'd12e158')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:desc[ @type eq 'deprecationInfo']"
                 priority="34"
                 mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e167']">
            <schxslt:rule pattern="d12e167">
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
            <schxslt:rule pattern="d12e167">
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
                               select="($schxslt:patterns-matched, 'd12e167')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:rt/@target" priority="33" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e176']">
            <schxslt:rule pattern="d12e176">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:rt/@target" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:rt/@target</xsl:attribute>
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
            <schxslt:rule pattern="d12e176">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:rt/@target</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="../@from | ../@to">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">../@from | ../@to</xsl:attribute>
                     <svrl:text>When target= is present, neither from= nor to= should be.</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e176')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:rt/@from" priority="32" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e185']">
            <schxslt:rule pattern="d12e185">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:rt/@from" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:rt/@from</xsl:attribute>
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
            <schxslt:rule pattern="d12e185">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:rt/@from</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(../@to)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">../@to</xsl:attribute>
                     <svrl:text>When from= is present, the to= attribute of <xsl:value-of select="name()"/> is required.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e185')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:rt/@to" priority="31" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e196']">
            <schxslt:rule pattern="d12e196">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:rt/@to" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:rt/@to</xsl:attribute>
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
            <schxslt:rule pattern="d12e196">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:rt/@to</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(../@from)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">../@from</xsl:attribute>
                     <svrl:text>When to= is present, the from= attribute of <xsl:value-of select="name()"/> is required.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e196')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:ptr" priority="30" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e207']">
            <schxslt:rule pattern="d12e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:ptr" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:ptr</xsl:attribute>
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
            <schxslt:rule pattern="d12e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:ptr</xsl:attribute>
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
                               select="($schxslt:patterns-matched, 'd12e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:ref" priority="29" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e219']">
            <schxslt:rule pattern="d12e219">
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
            <schxslt:rule pattern="d12e219">
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
                               select="($schxslt:patterns-matched, 'd12e219')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:list[@type='gloss']" priority="28" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e230']">
            <schxslt:rule pattern="d12e230">
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
            <schxslt:rule pattern="d12e230">
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
                               select="($schxslt:patterns-matched, 'd12e230')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:relatedItem" priority="27" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e239']">
            <schxslt:rule pattern="d12e239">
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
            <schxslt:rule pattern="d12e239">
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
                               select="($schxslt:patterns-matched, 'd12e239')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:l" priority="26" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e253']">
            <schxslt:rule pattern="d12e253">
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
            <schxslt:rule pattern="d12e253">
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
                               select="($schxslt:patterns-matched, 'd12e253')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:lg" priority="25" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e262']">
            <schxslt:rule pattern="d12e262">
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
            <schxslt:rule pattern="d12e262">
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
                               select="($schxslt:patterns-matched, 'd12e262')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:lg" priority="24" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e271']">
            <schxslt:rule pattern="d12e271">
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
            <schxslt:rule pattern="d12e271">
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
                               select="($schxslt:patterns-matched, 'd12e271')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:quotation" priority="23" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e281']">
            <schxslt:rule pattern="d12e281">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:quotation" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:quotation</xsl:attribute>
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
            <schxslt:rule pattern="d12e281">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:quotation</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not( @marks )  and  not( tei:p )">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">not( @marks )  and  not( tei:p )</xsl:attribute>
                     <svrl:text> On <xsl:value-of select="name()"/>, either the @marks attribute should be used, or a paragraph of description provided</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e281')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:citeStructure[not(parent::tei:citeStructure)]"
                 priority="22"
                 mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e292']">
            <schxslt:rule pattern="d12e292">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:citeStructure[not(parent::tei:citeStructure)]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:citeStructure[not(parent::tei:citeStructure)]</xsl:attribute>
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
                  <xsl:attribute name="context">tei:citeStructure[not(parent::tei:citeStructure)]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(starts-with(@match,'/'))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">starts-with(@match,'/')</xsl:attribute>
                     <svrl:text>An XPath in @match on the outer <xsl:value-of select="name()"/> must start with '/'.</svrl:text>
                  </svrl:failed-assert>
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
   <xsl:template match="tei:citeStructure[parent::tei:citeStructure]"
                 priority="21"
                 mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e303']">
            <schxslt:rule pattern="d12e303">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:citeStructure[parent::tei:citeStructure]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:citeStructure[parent::tei:citeStructure]</xsl:attribute>
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
            <schxslt:rule pattern="d12e303">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:citeStructure[parent::tei:citeStructure]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(not(starts-with(@match,'/')))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">not(starts-with(@match,'/'))</xsl:attribute>
                     <svrl:text>An XPath in @match must not start with '/' except on the outer <xsl:value-of select="name()"/>.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e303')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:link" priority="20" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e314']">
            <schxslt:rule pattern="d12e314">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:link" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:link</xsl:attribute>
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
            <schxslt:rule pattern="d12e314">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:link</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(contains(normalize-space(@target),' '))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">contains(normalize-space(@target),' ')</xsl:attribute>
                     <svrl:text>You must supply at least two values for @target or on <xsl:value-of select="name()"/>
                     </svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e314')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:l//tei:ab" priority="19" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e325']">
            <schxslt:rule pattern="d12e325">
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
            <schxslt:rule pattern="d12e325">
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
                               select="($schxslt:patterns-matched, 'd12e325')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:join" priority="18" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e334']">
            <schxslt:rule pattern="d12e334">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:join" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:join</xsl:attribute>
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
            <schxslt:rule pattern="d12e334">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:join</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(contains( normalize-space( @target ),' '))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">contains( normalize-space( @target ),' ')</xsl:attribute>
                     <svrl:text> You must supply at least two values for @target on <xsl:value-of select="name()"/>
                     </svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e334')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:standOff" priority="17" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e346']">
            <schxslt:rule pattern="d12e346">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:standOff" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:standOff</xsl:attribute>
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
            <schxslt:rule pattern="d12e346">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:standOff</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@type or not(ancestor::tei:standOff))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@type or not(ancestor::tei:standOff)</xsl:attribute>
                     <svrl:text>This <xsl:value-of select="name()"/> element must have a @type attribute, since it is nested inside a <xsl:value-of select="name()"/>
                     </svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e346')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:l//tei:div" priority="16" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e359']">
            <schxslt:rule pattern="d12e359">
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
            <schxslt:rule pattern="d12e359">
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
                               select="($schxslt:patterns-matched, 'd12e359')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:div" priority="15" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e368']">
            <schxslt:rule pattern="d12e368">
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
            <schxslt:rule pattern="d12e368">
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
                               select="($schxslt:patterns-matched, 'd12e368')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:relation" priority="14" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e377']">
            <schxslt:rule pattern="d12e377">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:relation" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:relation</xsl:attribute>
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
            <schxslt:rule pattern="d12e377">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:relation</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@ref or @key or @name)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@ref or @key or @name</xsl:attribute>
                     <svrl:text>One of the attributes @name, @ref or @key must be supplied</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e377')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:relation" priority="13" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e386']">
            <schxslt:rule pattern="d12e386">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:relation" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:relation</xsl:attribute>
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
            <schxslt:rule pattern="d12e386">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:relation</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="@active and @mutual">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@active and @mutual</xsl:attribute>
                     <svrl:text>Only one of the attributes @active and @mutual may be supplied</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e386')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:relation" priority="12" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e395']">
            <schxslt:rule pattern="d12e395">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:relation" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:relation</xsl:attribute>
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
            <schxslt:rule pattern="d12e395">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:relation</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="@passive and not(@active)">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@passive and not(@active)</xsl:attribute>
                     <svrl:text>the attribute @passive may be supplied only if the attribute @active is supplied</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e395')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:facsimile//tei:line | tei:facsimile//tei:zone"
                 priority="11"
                 mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e405']">
            <schxslt:rule pattern="d12e405">
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
            <schxslt:rule pattern="d12e405">
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
                               select="($schxslt:patterns-matched, 'd12e405')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:path[@points]" priority="10" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="firstPair" select="tokenize( normalize-space( @points ), ' ')[1]"/>
      <xsl:variable name="lastPair"
                    select="tokenize( normalize-space( @points ), ' ')[last()]"/>
      <xsl:variable name="firstX" select="xs:float( substring-before( $firstPair, ',') )"/>
      <xsl:variable name="firstY" select="xs:float( substring-after( $firstPair, ',') )"/>
      <xsl:variable name="lastX" select="xs:float( substring-before( $lastPair, ',') )"/>
      <xsl:variable name="lastY" select="xs:float( substring-after( $lastPair, ',') )"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e414']">
            <schxslt:rule pattern="d12e414">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:path[@points]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:path[@points]</xsl:attribute>
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
            <schxslt:rule pattern="d12e414">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:path[@points]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="$firstX eq $lastX and $firstY eq $lastY">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">$firstX eq $lastX and $firstY eq $lastY</xsl:attribute>
                     <svrl:text>The first and last elements of this path are the same. To specify a closed polygon, use the zone element rather than the path element.</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e414')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:addSpan" priority="9" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e436']">
            <schxslt:rule pattern="d12e436">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:addSpan" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:addSpan</xsl:attribute>
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
            <schxslt:rule pattern="d12e436">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:addSpan</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@spanTo)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@spanTo</xsl:attribute>
                     <svrl:text>The @spanTo attribute of <xsl:value-of select="name()"/> is required.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e436')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:damageSpan" priority="8" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e447']">
            <schxslt:rule pattern="d12e447">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:damageSpan" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:damageSpan</xsl:attribute>
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
            <schxslt:rule pattern="d12e447">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:damageSpan</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@spanTo)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@spanTo</xsl:attribute>
                     <svrl:text>The @spanTo attribute of <xsl:value-of select="name()"/> is required.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e447')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:delSpan" priority="7" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e458']">
            <schxslt:rule pattern="d12e458">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:delSpan" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:delSpan</xsl:attribute>
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
            <schxslt:rule pattern="d12e458">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:delSpan</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@spanTo)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@spanTo</xsl:attribute>
                     <svrl:text>The @spanTo attribute of <xsl:value-of select="name()"/> is required.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e458')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:subst" priority="6" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e469']">
            <schxslt:rule pattern="d12e469">
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
            <schxslt:rule pattern="d12e469">
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
                               select="($schxslt:patterns-matched, 'd12e469')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:msContents|tei:physDesc|tei:history|tei:additional"
                 priority="5"
                 mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="gi" select="name(.)"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e481']">
            <schxslt:rule pattern="d12e481">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:msContents|tei:physDesc|tei:history|tei:additional" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:msContents|tei:physDesc|tei:history|tei:additional</xsl:attribute>
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
            <schxslt:rule pattern="d12e481">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:msContents|tei:physDesc|tei:history|tei:additional</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="preceding-sibling::*[ name(.) eq $gi ]                           and                           not( following-sibling::*[ name(.) eq $gi ] )">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">preceding-sibling::*[ name(.) eq $gi ]                           and                           not( following-sibling::*[ name(.) eq $gi ] )</xsl:attribute>
                     <svrl:text> Only one <xsl:value-of select="name()"/> is allowed as a child of <xsl:value-of select="name(..)"/>.</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e481')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:catchwords" priority="4" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e496']">
            <schxslt:rule pattern="d12e496">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:catchwords" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:catchwords</xsl:attribute>
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
            <schxslt:rule pattern="d12e496">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:catchwords</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(ancestor::tei:msDesc or ancestor::tei:egXML)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">ancestor::tei:msDesc or ancestor::tei:egXML</xsl:attribute>
                     <svrl:text>The <xsl:value-of select="name()"/> element should not be used outside of msDesc.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e496')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:dimensions" priority="3" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e507']">
            <schxslt:rule pattern="d12e507">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:dimensions" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:dimensions</xsl:attribute>
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
            <schxslt:rule pattern="d12e507">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:dimensions</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="count(tei:width) gt 1">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">count(tei:width) gt 1</xsl:attribute>
                     <svrl:text> The element <xsl:value-of select="name()"/> may appear once only</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
               <xsl:if test="count(tei:height) gt 1">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">count(tei:height) gt 1</xsl:attribute>
                     <svrl:text> The element <xsl:value-of select="name()"/> may appear once only</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
               <xsl:if test="count(tei:depth) gt 1">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">count(tei:depth) gt 1</xsl:attribute>
                     <svrl:text> The element <xsl:value-of select="name()"/> may appear once only</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e507')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:secFol" priority="2" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e528']">
            <schxslt:rule pattern="d12e528">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:secFol" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:secFol</xsl:attribute>
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
            <schxslt:rule pattern="d12e528">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:secFol</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(ancestor::tei:msDesc or ancestor::tei:egXML)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">ancestor::tei:msDesc or ancestor::tei:egXML</xsl:attribute>
                     <svrl:text>The <xsl:value-of select="name()"/> element should not be used outside of msDesc.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e528')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:signatures" priority="1" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e539']">
            <schxslt:rule pattern="d12e539">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:signatures" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:signatures</xsl:attribute>
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
            <schxslt:rule pattern="d12e539">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:signatures</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(ancestor::tei:msDesc or ancestor::tei:egXML)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">ancestor::tei:msDesc or ancestor::tei:egXML</xsl:attribute>
                     <svrl:text>The <xsl:value-of select="name()"/> element should not be used outside of msDesc.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e539')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:msIdentifier" priority="0" mode="d12e32">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e550']">
            <schxslt:rule pattern="d12e550">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:msIdentifier" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:msIdentifier</xsl:attribute>
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
            <schxslt:rule pattern="d12e550">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:msIdentifier</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not( parent::tei:msPart )                           and                           ( child::*[1]/self::idno  or  child::*[1]/self::altIdentifier  or  normalize-space(.) eq '')">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">not( parent::tei:msPart )                           and                           ( child::*[1]/self::idno  or  child::*[1]/self::altIdentifier  or  normalize-space(.) eq '')</xsl:attribute>
                     <svrl:text>An msIdentifier must contain either a repository or location.</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e550')"/>
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
