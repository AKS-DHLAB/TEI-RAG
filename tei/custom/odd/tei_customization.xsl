<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform xmlns:error="https://doi.org/10.5281/zenodo.1495494#error"
               xmlns:esp-d2e72273="http://www.example.org/cannot/really/use/XInclude"
               xmlns:esp-d2e72325="http://www.example.org/cannot/really/use/XInclude"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
               xmlns:rna="http://relaxng.org/ns/compatibility/annotations/1.0"
               xmlns:rng="http://relaxng.org/ns/structure/1.0"
               xmlns:sch="http://purl.oclc.org/dsdl/schematron"
               xmlns:sch1x="http://www.ascc.net/xml/schematron"
               xmlns:schxslt="https://doi.org/10.5281/zenodo.1495494"
               xmlns:schxslt-api="https://doi.org/10.5281/zenodo.1495494#api"
               xmlns:tei="http://www.tei-c.org/ns/1.0"
               xmlns:teix="http://www.tei-c.org/ns/Examples"
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
      <dct:created>2025-09-04T16:15:52.647834846Z</dct:created>
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
                        <dct:created>2025-09-04T16:15:52.647834846Z</dct:created>
                     </rdf:Description>
                  </dct:source>
               </svrl:metadata>
            </xsl:variable>
            <xsl:variable name="report" as="element(schxslt:report)">
               <schxslt:report>
                  <xsl:call-template name="d12e47"/>
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
               <svrl:ns-prefix-in-attribute-values prefix="teix" uri="http://www.tei-c.org/ns/Examples"/>
               <svrl:ns-prefix-in-attribute-values prefix="tei" uri="http://www.tei-c.org/ns/1.0"/>
               <svrl:ns-prefix-in-attribute-values prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
               <svrl:ns-prefix-in-attribute-values prefix="rng" uri="http://relaxng.org/ns/structure/1.0"/>
               <svrl:ns-prefix-in-attribute-values prefix="rna" uri="http://relaxng.org/ns/compatibility/annotations/1.0"/>
               <svrl:ns-prefix-in-attribute-values prefix="sch" uri="http://purl.oclc.org/dsdl/schematron"/>
               <svrl:ns-prefix-in-attribute-values prefix="sch1x" uri="http://www.ascc.net/xml/schematron"/>
               <svrl:ns-prefix-in-attribute-values prefix="teix" uri="http://www.tei-c.org/ns/Examples"/>
               <svrl:ns-prefix-in-attribute-values prefix="esp-d2e72273"
                                                   uri="http://www.example.org/cannot/really/use/XInclude"/>
               <svrl:ns-prefix-in-attribute-values prefix="esp-d2e72325"
                                                   uri="http://www.example.org/cannot/really/use/XInclude"/>
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
   <xsl:template name="d12e47">
      <schxslt:document>
         <schxslt:pattern id="d12e47">
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
         <schxslt:pattern id="d12e56">
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
         <schxslt:pattern id="d12e66">
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
         <schxslt:pattern id="d12e75">
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
         <schxslt:pattern id="d12e84">
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
         <schxslt:pattern id="d12e99">
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
         <schxslt:pattern id="d12e108">
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
         <schxslt:pattern id="d12e119">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-schemeVersionRequiresScheme-8"
                                    id="schematron-constraint-schemeVersionRequiresScheme-8">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e129">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-subtypeTyped-9"
                                    id="schematron-constraint-subtypeTyped-9">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e140">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-unique_xmlIDs-10"
                                    id="schematron-constraint-unique_xmlIDs-10">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e155">
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
         <schxslt:pattern id="d12e166">
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
         <schxslt:pattern id="d12e175">
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
         <schxslt:pattern id="d12e184">
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
         <schxslt:pattern id="d12e194">
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
         <schxslt:pattern id="d12e203">
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
         <schxslt:pattern id="d12e214">
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
         <schxslt:pattern id="d12e225">
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
         <schxslt:pattern id="d12e236">
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
         <schxslt:pattern id="d12e247">
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
         <schxslt:pattern id="d12e257">
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
         <schxslt:pattern id="d12e271">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-citestructure-outer-match-22"
                                    id="schematron-constraint-citestructure-outer-match-22">
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
                                    name="schematron-constraint-citestructure-inner-match-23"
                                    id="schematron-constraint-citestructure-inner-match-23">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e293">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-abstractModel-structure-div-in-l-24"
                                    id="schematron-constraint-abstractModel-structure-div-in-l-24">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e302">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-abstractModel-structure-div-in-ab-or-p-25"
                                    id="schematron-constraint-abstractModel-structure-div-in-ab-or-p-25">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e311">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-MINandMAXoccurs-26"
                                    id="schematron-constraint-MINandMAXoccurs-26">
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
                                    name="schematron-constraint-MINandMAXoccurs-27"
                                    id="schematron-constraint-MINandMAXoccurs-27">
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
                                    name="schematron-constraint-spec-in-module-28"
                                    id="schematron-constraint-spec-in-module-28">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e347">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-deprecation-two-month-warning-29"
                                    id="schematron-constraint-deprecation-two-month-warning-29">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e367">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-deprecation-should-be-explained-30"
                                    id="schematron-constraint-deprecation-should-be-explained-30">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e378">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-only_sensible_attrs-11"
                                    id="schematron-constraint-only_sensible_attrs-11">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e393">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-if-url-then-prefix-33"
                                    id="schematron-constraint-if-url-then-prefix-33">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e403">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-no-duplicate-modules-34"
                                    id="schematron-constraint-no-duplicate-modules-34">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e416">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-need-required-35"
                                    id="schematron-constraint-need-required-35">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e446">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-include-required-36"
                                    id="schematron-constraint-include-required-36">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e457">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-include-required-37"
                                    id="schematron-constraint-include-required-37">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e468">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-include-required-38"
                                    id="schematron-constraint-include-required-38">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e479">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-include-required-39"
                                    id="schematron-constraint-include-required-39">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e491">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-include-required-40"
                                    id="schematron-constraint-include-required-40">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e502">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-include-required-41"
                                    id="schematron-constraint-include-required-41">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e513">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-include-required-42"
                                    id="schematron-constraint-include-required-42">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e524">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-element-is-in-module-43"
                                    id="schematron-constraint-element-is-in-module-43">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e544">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-element-is-in-module-44"
                                    id="schematron-constraint-element-is-in-module-44">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e564">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-element-is-in-module-45"
                                    id="schematron-constraint-element-is-in-module-45">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e585">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-element-is-in-module-46"
                                    id="schematron-constraint-element-is-in-module-46">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e605">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-element-is-in-module-47"
                                    id="schematron-constraint-element-is-in-module-47">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e625">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-element-is-in-module-48"
                                    id="schematron-constraint-element-is-in-module-48">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e645">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-element-is-in-module-49"
                                    id="schematron-constraint-element-is-in-module-49">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e665">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-element-is-in-module-50"
                                    id="schematron-constraint-element-is-in-module-50">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e685">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-element-is-in-module-51"
                                    id="schematron-constraint-element-is-in-module-51">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e706">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-element-is-in-module-52"
                                    id="schematron-constraint-element-is-in-module-52">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e726">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-element-is-in-module-53"
                                    id="schematron-constraint-element-is-in-module-53">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e746">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-element-is-in-module-54"
                                    id="schematron-constraint-element-is-in-module-54">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e766">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-element-is-in-module-55"
                                    id="schematron-constraint-element-is-in-module-55">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e786">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-element-is-in-module-56"
                                    id="schematron-constraint-element-is-in-module-56">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e806">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-element-is-in-module-57"
                                    id="schematron-constraint-element-is-in-module-57">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e827">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-element-is-in-module-58"
                                    id="schematron-constraint-element-is-in-module-58">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e847">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-element-is-in-module-59"
                                    id="schematron-constraint-element-is-in-module-59">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e867">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-element-is-in-module-60"
                                    id="schematron-constraint-element-is-in-module-60">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e887">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-element-is-in-module-61"
                                    id="schematron-constraint-element-is-in-module-61">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e907">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-element-is-in-module-62"
                                    id="schematron-constraint-element-is-in-module-62">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e927">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-element-is-in-module-63"
                                    id="schematron-constraint-element-is-in-module-63">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e948">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-modref-64"
                                    id="schematron-constraint-modref-64">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e959">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-not-same-prefix-65"
                                    id="schematron-constraint-not-same-prefix-65">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e970">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-not-except-and-include-66"
                                    id="schematron-constraint-not-except-and-include-66">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e979">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-not-same-prefix-67"
                                    id="schematron-constraint-not-same-prefix-67">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e990">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-not-except-and-include-68"
                                    id="schematron-constraint-not-except-and-include-68">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e999">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-required-modules-69"
                                    id="schematron-constraint-required-modules-69">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1009">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-no-outside-specs-70"
                                    id="schematron-constraint-no-outside-specs-70">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1020">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-only-one-schemaSpec-71"
                                    id="schematron-constraint-only-one-schemaSpec-71">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1032">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-module-except-when-add-72"
                                    id="schematron-constraint-module-except-when-add-72">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1044">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-only-1-per-73"
                                    id="schematron-constraint-only-1-per-73">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1053">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-dont-delete-required-74"
                                    id="schematron-constraint-dont-delete-required-74">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1081">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-content_when_adding-75"
                                    id="schematron-constraint-content_when_adding-75">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1091">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-empty_when_deleting-76"
                                    id="schematron-constraint-empty_when_deleting-76">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1100">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-add_implies_ns-77"
                                    id="schematron-constraint-add_implies_ns-77">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1109">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-child-constraint-based-on-mode-78"
                                    id="schematron-constraint-child-constraint-based-on-mode-78">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1118">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-child-constraint-based-on-mode-79"
                                    id="schematron-constraint-child-constraint-based-on-mode-79">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1129">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-no_elements_in_data_content-80"
                                    id="schematron-constraint-no_elements_in_data_content-80">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1138">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-TagDocsNestinglistRef-81"
                                    id="schematron-constraint-TagDocsNestinglistRef-81">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1148">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-TagDocslistRefChildren-82"
                                    id="schematron-constraint-TagDocslistRefChildren-82">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1157">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-no_dup_default_models-83"
                                    id="schematron-constraint-no_dup_default_models-83">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1172">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-no_dup_models-84"
                                    id="schematron-constraint-no_dup_models-84">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1189">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-no_outputs_nor_predicates_4_my_kids-85"
                                    id="schematron-constraint-no_outputs_nor_predicates_4_my_kids-85">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1198">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-sequencechilden-86"
                                    id="schematron-constraint-sequencechilden-86">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1207">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-alternatechilden-87"
                                    id="schematron-constraint-alternatechilden-87">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1217">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-one-constraintDecl-per-scheme-88"
                                    id="schematron-constraint-one-constraintDecl-per-scheme-88">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1230">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-empty-based-on-mode-90"
                                    id="schematron-constraint-empty-based-on-mode-90">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1239">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-empty-based-on-mode-91"
                                    id="schematron-constraint-empty-based-on-mode-91">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1248">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-empty-based-on-mode-92"
                                    id="schematron-constraint-empty-based-on-mode-92">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1259">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-sch_no_more-93"
                                    id="schematron-constraint-sch_no_more-93">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1268">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-isosch-94"
                                    id="schematron-constraint-isosch-94">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1278">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-context-required-95"
                                    id="schematron-constraint-context-required-95">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1293">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-unique-constraintSpec-ident-96"
                                    id="schematron-constraint-unique-constraintSpec-ident-96">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1306">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-usage_based_on_mode-97"
                                    id="schematron-constraint-usage_based_on_mode-97">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1319">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-attDefContents-100"
                                    id="schematron-constraint-attDefContents-100">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1336">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-noDefault4Required-101"
                                    id="schematron-constraint-noDefault4Required-101">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1349">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-defaultIsInClosedList-twoOrMore-102"
                                    id="schematron-constraint-defaultIsInClosedList-twoOrMore-102">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1365">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-defaultIsInClosedList-one-103"
                                    id="schematron-constraint-defaultIsInClosedList-one-103">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1380">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-restrictDataFacet-104"
                                    id="schematron-constraint-restrictDataFacet-104">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1392">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-restrictAttResctrictionName-105"
                                    id="schematron-constraint-restrictAttResctrictionName-105">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1401">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-mode-child-sanity-106"
                                    id="schematron-constraint-mode-child-sanity-106">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1412">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-mode-child-sanity-107"
                                    id="schematron-constraint-mode-child-sanity-107">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1425">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="schematron-constraint-tei-source-108"
                                    id="schematron-constraint-tei-source-108">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1443">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="teipm-model-paramList-1"
                                    id="teipm-model-paramList-1">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1456">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="teipm-model-paramList-2"
                                    id="teipm-model-paramList-2">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1469">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="teipm-model-paramList-3"
                                    id="teipm-model-paramList-3">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1482">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="teipm-model-paramList-4"
                                    id="teipm-model-paramList-4">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1495">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="teipm-model-paramList-5"
                                    id="teipm-model-paramList-5">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1508">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="teipm-model-paramList-6"
                                    id="teipm-model-paramList-6">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1522">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="teipm-model-paramList-7"
                                    id="teipm-model-paramList-7">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1535">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="teipm-model-paramList-8"
                                    id="teipm-model-paramList-8">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1548">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="teipm-model-paramList-9"
                                    id="teipm-model-paramList-9">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1561">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="teipm-model-paramList-10"
                                    id="teipm-model-paramList-10">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1574">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="teipm-model-paramList-11"
                                    id="teipm-model-paramList-11">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1587">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="teipm-model-paramList-12"
                                    id="teipm-model-paramList-12">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1601">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="teipm-model-paramList-13"
                                    id="teipm-model-paramList-13">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1614">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="teipm-model-paramList-14"
                                    id="teipm-model-paramList-14">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1627">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="teipm-model-paramList-15"
                                    id="teipm-model-paramList-15">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1640">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="teipm-model-paramList-16"
                                    id="teipm-model-paramList-16">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1653">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="teipm-model-paramList-17"
                                    id="teipm-model-paramList-17">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1666">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="teipm-model-paramList-18"
                                    id="teipm-model-paramList-18">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1680">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="teipm-model-paramList-19"
                                    id="teipm-model-paramList-19">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1693">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="teipm-model-paramList-20"
                                    id="teipm-model-paramList-20">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1706">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="teipm-model-paramList-21"
                                    id="teipm-model-paramList-21">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1719">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="teipm-model-paramList-22"
                                    id="teipm-model-paramList-22">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1732">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="teipm-model-paramList-23"
                                    id="teipm-model-paramList-23">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1745">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="teipm-model-paramList-24"
                                    id="teipm-model-paramList-24">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d12e1759">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    name="teipm-model-paramList-25"
                                    id="teipm-model-paramList-25">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <xsl:apply-templates mode="d12e47" select="root()"/>
      </schxslt:document>
   </xsl:template>
   <xsl:template match="tei:*[@generatedBy]" priority="129" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e47']">
            <schxslt:rule pattern="d12e47">
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
            <schxslt:rule pattern="d12e47">
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
                               select="($schxslt:patterns-matched, 'd12e47')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:*[@when]" priority="128" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e56']">
            <schxslt:rule pattern="d12e56">
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
            <schxslt:rule pattern="d12e56">
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
                               select="($schxslt:patterns-matched, 'd12e56')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:*[@from]" priority="127" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e66']">
            <schxslt:rule pattern="d12e66">
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
            <schxslt:rule pattern="d12e66">
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
                               select="($schxslt:patterns-matched, 'd12e66')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:*[@to]" priority="126" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e75']">
            <schxslt:rule pattern="d12e75">
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
            <schxslt:rule pattern="d12e75">
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
                               select="($schxslt:patterns-matched, 'd12e75')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:*[@source]" priority="125" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="srcs" select="tokenize( normalize-space(@source),' ')"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e84']">
            <schxslt:rule pattern="d12e84">
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
            <schxslt:rule pattern="d12e84">
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
                               select="($schxslt:patterns-matched, 'd12e84')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:*[@unitRef]" priority="124" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e99']">
            <schxslt:rule pattern="d12e99">
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
            <schxslt:rule pattern="d12e99">
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
                               select="($schxslt:patterns-matched, 'd12e99')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:*[not(self::tei:schemaSpec)][@targetLang]"
                 priority="123"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e108']">
            <schxslt:rule pattern="d12e108">
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
            <schxslt:rule pattern="d12e108">
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
                               select="($schxslt:patterns-matched, 'd12e108')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:*[@schemeVersion]" priority="122" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e119']">
            <schxslt:rule pattern="d12e119">
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
            <schxslt:rule pattern="d12e119">
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
                               select="($schxslt:patterns-matched, 'd12e119')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:*[@subtype]" priority="121" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e129']">
            <schxslt:rule pattern="d12e129">
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
            <schxslt:rule pattern="d12e129">
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
                               select="($schxslt:patterns-matched, 'd12e129')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="@xml:id" priority="120" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="myID" select="normalize-space(.)"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e140']">
            <schxslt:rule pattern="d12e140">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "@xml:id" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">@xml:id</xsl:attribute>
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
            <schxslt:rule pattern="d12e140">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">@xml:id</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="../(ancestor::*|preceding::*)/@xml:id[ normalize-space(.) eq $myID ]">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">../(ancestor::*|preceding::*)/@xml:id[ normalize-space(.) eq $myID ]</xsl:attribute>
                     <svrl:text>The @xml:id "<xsl:value-of select="."/>" on ＜<xsl:value-of select="name(..)"/>＞ duplicates an @xml:id found earlier in the document</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e140')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:*[@calendar]" priority="119" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e155']">
            <schxslt:rule pattern="d12e155">
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
            <schxslt:rule pattern="d12e155">
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
                               select="($schxslt:patterns-matched, 'd12e155')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:p" priority="118" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e166']">
            <schxslt:rule pattern="d12e166">
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
            <schxslt:rule pattern="d12e166">
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
                               select="($schxslt:patterns-matched, 'd12e166')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:l//tei:p" priority="117" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e175']">
            <schxslt:rule pattern="d12e175">
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
            <schxslt:rule pattern="d12e175">
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
                               select="($schxslt:patterns-matched, 'd12e175')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:desc[ @type eq 'deprecationInfo']"
                 priority="116"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e184']">
            <schxslt:rule pattern="d12e184">
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
            <schxslt:rule pattern="d12e184">
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
                               select="($schxslt:patterns-matched, 'd12e184')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:rt/@target" priority="115" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e194']">
            <schxslt:rule pattern="d12e194">
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
            <schxslt:rule pattern="d12e194">
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
                               select="($schxslt:patterns-matched, 'd12e194')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:rt/@from" priority="114" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e203']">
            <schxslt:rule pattern="d12e203">
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
            <schxslt:rule pattern="d12e203">
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
                               select="($schxslt:patterns-matched, 'd12e203')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:rt/@to" priority="113" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e214']">
            <schxslt:rule pattern="d12e214">
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
            <schxslt:rule pattern="d12e214">
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
                               select="($schxslt:patterns-matched, 'd12e214')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:ptr" priority="112" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e225']">
            <schxslt:rule pattern="d12e225">
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
            <schxslt:rule pattern="d12e225">
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
                               select="($schxslt:patterns-matched, 'd12e225')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:ref" priority="111" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e236']">
            <schxslt:rule pattern="d12e236">
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
            <schxslt:rule pattern="d12e236">
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
                               select="($schxslt:patterns-matched, 'd12e236')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:list[@type='gloss']" priority="110" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e247']">
            <schxslt:rule pattern="d12e247">
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
            <schxslt:rule pattern="d12e247">
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
                               select="($schxslt:patterns-matched, 'd12e247')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:relatedItem" priority="109" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e257']">
            <schxslt:rule pattern="d12e257">
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
            <schxslt:rule pattern="d12e257">
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
                               select="($schxslt:patterns-matched, 'd12e257')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:citeStructure[not(parent::tei:citeStructure)]"
                 priority="108"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e271']">
            <schxslt:rule pattern="d12e271">
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
            <schxslt:rule pattern="d12e271">
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
                               select="($schxslt:patterns-matched, 'd12e271')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:citeStructure[parent::tei:citeStructure]"
                 priority="107"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e282']">
            <schxslt:rule pattern="d12e282">
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
            <schxslt:rule pattern="d12e282">
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
                               select="($schxslt:patterns-matched, 'd12e282')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:l//tei:div" priority="106" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e293']">
            <schxslt:rule pattern="d12e293">
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
            <schxslt:rule pattern="d12e293">
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
                               select="($schxslt:patterns-matched, 'd12e293')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:div" priority="105" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e302']">
            <schxslt:rule pattern="d12e302">
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
            <schxslt:rule pattern="d12e302">
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
                               select="($schxslt:patterns-matched, 'd12e302')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:*[ @minOccurs and @maxOccurs ]"
                 priority="104"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="min" select="@minOccurs cast as xs:integer"/>
      <xsl:variable name="max"
                    select="if ( normalize-space( @maxOccurs ) eq 'unbounded') then -1 else @maxOccurs cast as xs:integer"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e311']">
            <schxslt:rule pattern="d12e311">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:*[ @minOccurs and @maxOccurs ]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[ @minOccurs and @maxOccurs ]</xsl:attribute>
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
            <schxslt:rule pattern="d12e311">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[ @minOccurs and @maxOccurs ]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not($max eq -1 or $max ge $min)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">$max eq -1 or $max ge $min</xsl:attribute>
                     <svrl:text>@maxOccurs should be greater than or equal to @minOccurs</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e311')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:*[ @minOccurs and not( @maxOccurs ) ]"
                 priority="103"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e325']">
            <schxslt:rule pattern="d12e325">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:*[ @minOccurs and not( @maxOccurs ) ]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[ @minOccurs and not( @maxOccurs ) ]</xsl:attribute>
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
                  <xsl:attribute name="context">tei:*[ @minOccurs and not( @maxOccurs ) ]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@minOccurs cast as xs:integer lt 2)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@minOccurs cast as xs:integer lt 2</xsl:attribute>
                     <svrl:text>When @maxOccurs is not specified, @minOccurs must be 0 or 1</svrl:text>
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
   <xsl:template match="tei:elementSpec[@module]|tei:classSpec[@module]|tei:macroSpec[@module]"
                 priority="102"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e334']">
            <schxslt:rule pattern="d12e334">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:elementSpec[@module]|tei:classSpec[@module]|tei:macroSpec[@module]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:elementSpec[@module]|tei:classSpec[@module]|tei:macroSpec[@module]</xsl:attribute>
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
                  <xsl:attribute name="context">tei:elementSpec[@module]|tei:classSpec[@module]|tei:macroSpec[@module]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not((not(ancestor::tei:schemaSpec | ancestor::tei:TEI | ancestor::tei:teiCorpus)) or (not(@module) or (not(//tei:moduleSpec) and not(//tei:moduleRef)) or (//tei:moduleSpec[@ident = current()/@module]) or (//tei:moduleRef[@key = current()/@module])))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">(not(ancestor::tei:schemaSpec | ancestor::tei:TEI | ancestor::tei:teiCorpus)) or (not(@module) or (not(//tei:moduleSpec) and not(//tei:moduleRef)) or (//tei:moduleSpec[@ident = current()/@module]) or (//tei:moduleRef[@key = current()/@module]))</xsl:attribute>
                     <svrl:text> Specification <xsl:value-of select="@ident"/>: the value of the module attribute ("<xsl:value-of select="@module"/>") should correspond to an existing module, via a moduleSpec or moduleRef</svrl:text>
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
   <xsl:template match="tei:*[@validUntil]" priority="101" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="advance_warning_period"
                    select="current-date() + xs:dayTimeDuration('P60D')"/>
      <xsl:variable name="me_phrase"
                    select="if (@ident) then concat('The ', @ident ) else concat('This ', local-name(.), ' of ', ancestor::tei:*[@ident][1]/@ident )"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e347']">
            <schxslt:rule pattern="d12e347">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:*[@validUntil]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[@validUntil]</xsl:attribute>
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
            <schxslt:rule pattern="d12e347">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[@validUntil]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@validUntil cast as xs:date ge current-date())">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@validUntil cast as xs:date ge current-date()</xsl:attribute>
                     <svrl:text>
                        <xsl:value-of select="concat( $me_phrase, ' construct is outdated (as of ', @validUntil, '); ODD processors may ignore it, and its use is no longer supported' )"/>
                     </svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(@validUntil cast as xs:date ge $advance_warning_period)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      role="warning">
                     <xsl:attribute name="test">@validUntil cast as xs:date ge $advance_warning_period</xsl:attribute>
                     <svrl:text>
                        <xsl:value-of select="concat( $me_phrase, ' construct becomes outdated on ', @validUntil )"/>
                     </svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e347')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:*[@validUntil][ not( self::tei:valDesc | self::tei:valList | self::tei:defaultVal | self::tei:remarks )]"
                 priority="100"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e367']">
            <schxslt:rule pattern="d12e367">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:*[@validUntil][ not( self::tei:valDesc | self::tei:valList | self::tei:defaultVal | self::tei:remarks )]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[@validUntil][ not( self::tei:valDesc | self::tei:valList | self::tei:defaultVal | self::tei:remarks )]</xsl:attribute>
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
            <schxslt:rule pattern="d12e367">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:*[@validUntil][ not( self::tei:valDesc | self::tei:valList | self::tei:defaultVal | self::tei:remarks )]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(child::tei:desc[ @type eq 'deprecationInfo'])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">child::tei:desc[ @type eq 'deprecationInfo']</xsl:attribute>
                     <svrl:text> A deprecated construct should include, whenever possible, an explanation, but this <xsl:value-of select="name(.)"/> does not have a child &lt;desc type="deprecationInfo"&gt;</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e367')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:elementRef[ parent::tei:schemaSpec | parent::tei:specGrp ]"
                 priority="99"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e378']">
            <schxslt:rule pattern="d12e378">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:elementRef[ parent::tei:schemaSpec | parent::tei:specGrp ]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:elementRef[ parent::tei:schemaSpec | parent::tei:specGrp ]</xsl:attribute>
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
            <schxslt:rule pattern="d12e378">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:elementRef[ parent::tei:schemaSpec | parent::tei:specGrp ]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="@minOccurs | @maxOccurs">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}"
                                          role="error">
                     <xsl:attribute name="test">@minOccurs | @maxOccurs</xsl:attribute>
                     <svrl:text>An element reference is not repeatable when part of a schema specification (and thus this &lt;elementRef&gt; should not have @minOccurs or @maxOccurs).</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e378')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:content//tei:elementRef" priority="98" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e378']">
            <schxslt:rule pattern="d12e378">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:content//tei:elementRef" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:content//tei:elementRef</xsl:attribute>
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
            <schxslt:rule pattern="d12e378">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:content//tei:elementRef</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="@source">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}"
                                          role="error">
                     <xsl:attribute name="test">@source</xsl:attribute>
                     <svrl:text>An element reference within a content model must refer to a locally defined element specification (and thus this &lt;elementRef&gt; should not have @source).</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e378')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef[ @url ]" priority="97" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e393']">
            <schxslt:rule pattern="d12e393">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef[ @url ]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[ @url ]</xsl:attribute>
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
            <schxslt:rule pattern="d12e393">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[ @url ]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@prefix)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@prefix</xsl:attribute>
                     <svrl:text> a ＜moduleRef＞ that uses the url= attribute should have a prefix= attribute, too</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e393')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef[ @key ]" priority="96" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="mykey" select="@key"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e403']">
            <schxslt:rule pattern="d12e403">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef[ @key ]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[ @key ]</xsl:attribute>
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
            <schxslt:rule pattern="d12e403">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[ @key ]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="preceding-sibling::tei:moduleRef[ @key eq $mykey ]">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">preceding-sibling::tei:moduleRef[ @key eq $mykey ]</xsl:attribute>
                     <svrl:text>The '<xsl:value-of select="@key"/>' module is included (by reference) more than once</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e403')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef[ @except ]" priority="95" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="exceptions" select="tokenize( @except, '\s+' )"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e416']">
            <schxslt:rule pattern="d12e416">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef[ @except ]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[ @except ]</xsl:attribute>
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
            <schxslt:rule pattern="d12e416">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[ @except ]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="'TEI'=$exceptions">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">'TEI'=$exceptions</xsl:attribute>
                     <svrl:text>Removing ＜TEI＞ from your schema guarantees it is not TEI conformant, and will will likely be outright invalid</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
               <xsl:if test="'teiHeader'=$exceptions">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">'teiHeader'=$exceptions</xsl:attribute>
                     <svrl:text>Removing ＜teiHeader＞ from your schema guarantees it is not TEI conformant</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
               <xsl:if test="'fileDesc'=$exceptions">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">'fileDesc'=$exceptions</xsl:attribute>
                     <svrl:text>Removing ＜fileDesc＞ from your schema guarantees it is not TEI conformant</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
               <xsl:if test="'titleStmt'=$exceptions">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">'titleStmt'=$exceptions</xsl:attribute>
                     <svrl:text>Removing ＜titleStmt＞ from your schema guarantees it is not TEI conformant</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
               <xsl:if test="'title'=$exceptions">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">'title'=$exceptions</xsl:attribute>
                     <svrl:text>Removing ＜title＞ from your schema guarantees it is not TEI conformant</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
               <xsl:if test="'publicationStmt'=$exceptions">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">'publicationStmt'=$exceptions</xsl:attribute>
                     <svrl:text>Removing ＜publicationStmt＞ from your schema guarantees it is not TEI conformant</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
               <xsl:if test="'sourceDesc'=$exceptions">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">'sourceDesc'=$exceptions</xsl:attribute>
                     <svrl:text>Removing ＜sourceDesc＞ from your schema guarantees it is not TEI conformant</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e416')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef[ @key eq 'textstructure' and @include ]"
                 priority="94"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="inclusions" select="tokenize( @include, '\s+' )"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e446']">
            <schxslt:rule pattern="d12e446">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef[ @key eq 'textstructure' and @include ]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[ @key eq 'textstructure' and @include ]</xsl:attribute>
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
            <schxslt:rule pattern="d12e446">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[ @key eq 'textstructure' and @include ]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not('TEI'=$inclusions)">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">not('TEI'=$inclusions)</xsl:attribute>
                     <svrl:text>Not including ＜TEI＞ in your schema guarantees it is not TEI conformant, and will likely be outright invalid</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e446')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef[ @key eq 'header' and @include ]"
                 priority="93"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="inclusions" select="tokenize( @include, '\s+' )"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e457']">
            <schxslt:rule pattern="d12e457">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef[ @key eq 'header' and @include ]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[ @key eq 'header' and @include ]</xsl:attribute>
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
            <schxslt:rule pattern="d12e457">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[ @key eq 'header' and @include ]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not('teiHeader'=$inclusions)">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">not('teiHeader'=$inclusions)</xsl:attribute>
                     <svrl:text>Not including ＜teiHeader＞ in your schema guarantees it is not TEI conformant</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e457')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef[ @key eq 'header' and @include ]"
                 priority="92"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="inclusions" select="tokenize( @include, '\s+' )"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e468']">
            <schxslt:rule pattern="d12e468">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef[ @key eq 'header' and @include ]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[ @key eq 'header' and @include ]</xsl:attribute>
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
            <schxslt:rule pattern="d12e468">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[ @key eq 'header' and @include ]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not('fileDesc'=$inclusions)">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">not('fileDesc'=$inclusions)</xsl:attribute>
                     <svrl:text>Not including ＜fileDesc＞ in your schema guarantees it is not TEI conformant</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e468')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef[ @key eq 'header' and @include ]"
                 priority="91"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="inclusions" select="tokenize( @include, '\s+' )"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e479']">
            <schxslt:rule pattern="d12e479">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef[ @key eq 'header' and @include ]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[ @key eq 'header' and @include ]</xsl:attribute>
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
            <schxslt:rule pattern="d12e479">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[ @key eq 'header' and @include ]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not('titleStmt'=$inclusions)">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">not('titleStmt'=$inclusions)</xsl:attribute>
                     <svrl:text>Not including ＜titleStmt＞ in your schema guarantees it is not TEI conformant</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e479')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef[ @key eq 'header' and @include ]"
                 priority="90"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="inclusions" select="tokenize( @include, '\s+' )"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e491']">
            <schxslt:rule pattern="d12e491">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef[ @key eq 'header' and @include ]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[ @key eq 'header' and @include ]</xsl:attribute>
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
            <schxslt:rule pattern="d12e491">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[ @key eq 'header' and @include ]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not('publicationStmt'=$inclusions)">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">not('publicationStmt'=$inclusions)</xsl:attribute>
                     <svrl:text>Not including ＜publicationStmt＞ in your schema guarantees it is not TEI conformant</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e491')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef[ @key eq 'header' and @include ]"
                 priority="89"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="inclusions" select="tokenize( @include, '\s+' )"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e502']">
            <schxslt:rule pattern="d12e502">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef[ @key eq 'header' and @include ]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[ @key eq 'header' and @include ]</xsl:attribute>
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
            <schxslt:rule pattern="d12e502">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[ @key eq 'header' and @include ]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not('sourceDesc'=$inclusions)">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">not('sourceDesc'=$inclusions)</xsl:attribute>
                     <svrl:text>Not including ＜sourceDesc＞ in your schema guarantees it is not TEI conformant</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e502')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef[ @key eq 'core' and @include ]"
                 priority="88"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="inclusions" select="tokenize( @include, '\s+' )"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e513']">
            <schxslt:rule pattern="d12e513">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef[ @key eq 'core' and @include ]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[ @key eq 'core' and @include ]</xsl:attribute>
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
            <schxslt:rule pattern="d12e513">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[ @key eq 'core' and @include ]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not('title'=$inclusions)">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">not('title'=$inclusions)</xsl:attribute>
                     <svrl:text>Not including ＜title＞ in your schema guarantees it is not TEI conformant</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e513')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef[@key eq 'header']" priority="87" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e524']">
            <schxslt:rule pattern="d12e524">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef[@key eq 'header']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'header']</xsl:attribute>
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
            <schxslt:rule pattern="d12e524">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'header']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(every $gi in $include satisfies $gi = ( 'teiHeader', 'fileDesc', 'titleStmt', 'sponsor', 'funder', 'principal', 'editionStmt', 'edition', 'extent', 'publicationStmt', 'distributor', 'authority', 'idno', 'availability', 'licence', 'seriesStmt', 'notesStmt', 'sourceDesc', 'biblFull', 'encodingDesc', 'schemaRef', 'projectDesc', 'samplingDecl', 'editorialDecl', 'correction', 'normalization', 'quotation', 'hyphenation', 'segmentation', 'stdVals', 'interpretation', 'punctuation', 'tagsDecl', 'tagUsage', 'namespace', 'rendition', 'styleDefDecl', 'refsDecl', 'citeStructure', 'citeData', 'cRefPattern', 'prefixDef', 'listPrefixDef', 'refState', 'classDecl', 'taxonomy', 'category', 'catDesc', 'geoDecl', 'unitDecl', 'unitDef', 'conversion', 'appInfo', 'application', 'profileDesc', 'handNote', 'abstract', 'creation', 'langUsage', 'language', 'textClass', 'keywords', 'classCode', 'catRef', 'calendarDesc', 'calendar', 'correspDesc', 'correspAction', 'correspContext', 'xenoData', 'revisionDesc', 'change', 'scriptNote', 'listChange' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $include satisfies $gi = ( 'teiHeader', 'fileDesc', 'titleStmt', 'sponsor', 'funder', 'principal', 'editionStmt', 'edition', 'extent', 'publicationStmt', 'distributor', 'authority', 'idno', 'availability', 'licence', 'seriesStmt', 'notesStmt', 'sourceDesc', 'biblFull', 'encodingDesc', 'schemaRef', 'projectDesc', 'samplingDecl', 'editorialDecl', 'correction', 'normalization', 'quotation', 'hyphenation', 'segmentation', 'stdVals', 'interpretation', 'punctuation', 'tagsDecl', 'tagUsage', 'namespace', 'rendition', 'styleDefDecl', 'refsDecl', 'citeStructure', 'citeData', 'cRefPattern', 'prefixDef', 'listPrefixDef', 'refState', 'classDecl', 'taxonomy', 'category', 'catDesc', 'geoDecl', 'unitDecl', 'unitDef', 'conversion', 'appInfo', 'application', 'profileDesc', 'handNote', 'abstract', 'creation', 'langUsage', 'language', 'textClass', 'keywords', 'classCode', 'catRef', 'calendarDesc', 'calendar', 'correspDesc', 'correspAction', 'correspContext', 'xenoData', 'revisionDesc', 'change', 'scriptNote', 'listChange' )</xsl:attribute>
                     <svrl:text>One or more of the elements included on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(every $gi in $except  satisfies $gi = ( 'teiHeader', 'fileDesc', 'titleStmt', 'sponsor', 'funder', 'principal', 'editionStmt', 'edition', 'extent', 'publicationStmt', 'distributor', 'authority', 'idno', 'availability', 'licence', 'seriesStmt', 'notesStmt', 'sourceDesc', 'biblFull', 'encodingDesc', 'schemaRef', 'projectDesc', 'samplingDecl', 'editorialDecl', 'correction', 'normalization', 'quotation', 'hyphenation', 'segmentation', 'stdVals', 'interpretation', 'punctuation', 'tagsDecl', 'tagUsage', 'namespace', 'rendition', 'styleDefDecl', 'refsDecl', 'citeStructure', 'citeData', 'cRefPattern', 'prefixDef', 'listPrefixDef', 'refState', 'classDecl', 'taxonomy', 'category', 'catDesc', 'geoDecl', 'unitDecl', 'unitDef', 'conversion', 'appInfo', 'application', 'profileDesc', 'handNote', 'abstract', 'creation', 'langUsage', 'language', 'textClass', 'keywords', 'classCode', 'catRef', 'calendarDesc', 'calendar', 'correspDesc', 'correspAction', 'correspContext', 'xenoData', 'revisionDesc', 'change', 'scriptNote', 'listChange' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $except  satisfies $gi = ( 'teiHeader', 'fileDesc', 'titleStmt', 'sponsor', 'funder', 'principal', 'editionStmt', 'edition', 'extent', 'publicationStmt', 'distributor', 'authority', 'idno', 'availability', 'licence', 'seriesStmt', 'notesStmt', 'sourceDesc', 'biblFull', 'encodingDesc', 'schemaRef', 'projectDesc', 'samplingDecl', 'editorialDecl', 'correction', 'normalization', 'quotation', 'hyphenation', 'segmentation', 'stdVals', 'interpretation', 'punctuation', 'tagsDecl', 'tagUsage', 'namespace', 'rendition', 'styleDefDecl', 'refsDecl', 'citeStructure', 'citeData', 'cRefPattern', 'prefixDef', 'listPrefixDef', 'refState', 'classDecl', 'taxonomy', 'category', 'catDesc', 'geoDecl', 'unitDecl', 'unitDef', 'conversion', 'appInfo', 'application', 'profileDesc', 'handNote', 'abstract', 'creation', 'langUsage', 'language', 'textClass', 'keywords', 'classCode', 'catRef', 'calendarDesc', 'calendar', 'correspDesc', 'correspAction', 'correspContext', 'xenoData', 'revisionDesc', 'change', 'scriptNote', 'listChange' )</xsl:attribute>
                     <svrl:text>One or more of the elements excepted on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e524')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef[@key eq 'core']" priority="86" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e544']">
            <schxslt:rule pattern="d12e544">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef[@key eq 'core']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'core']</xsl:attribute>
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
            <schxslt:rule pattern="d12e544">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'core']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(every $gi in $include satisfies $gi = ( 'p', 'foreign', 'emph', 'hi', 'distinct', 'said', 'quote', 'q', 'cit', 'mentioned', 'soCalled', 'desc', 'gloss', 'term', 'ruby', 'rb', 'rt', 'sic', 'corr', 'choice', 'reg', 'orig', 'gap', 'ellipsis', 'add', 'del', 'unclear', 'name', 'rs', 'email', 'address', 'addrLine', 'street', 'postCode', 'postBox', 'num', 'measure', 'measureGrp', 'unit', 'date', 'time', 'abbr', 'expan', 'ptr', 'ref', 'list', 'item', 'label', 'head', 'headLabel', 'headItem', 'note', 'noteGrp', 'index', 'media', 'graphic', 'binaryObject', 'milestone', 'gb', 'pb', 'lb', 'cb', 'analytic', 'monogr', 'series', 'author', 'editor', 'respStmt', 'resp', 'title', 'meeting', 'imprint', 'publisher', 'biblScope', 'citedRange', 'pubPlace', 'bibl', 'biblStruct', 'listBibl', 'relatedItem', 'l', 'lg', 'sp', 'speaker', 'stage', 'teiCorpus', 'divGen', 'textLang' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $include satisfies $gi = ( 'p', 'foreign', 'emph', 'hi', 'distinct', 'said', 'quote', 'q', 'cit', 'mentioned', 'soCalled', 'desc', 'gloss', 'term', 'ruby', 'rb', 'rt', 'sic', 'corr', 'choice', 'reg', 'orig', 'gap', 'ellipsis', 'add', 'del', 'unclear', 'name', 'rs', 'email', 'address', 'addrLine', 'street', 'postCode', 'postBox', 'num', 'measure', 'measureGrp', 'unit', 'date', 'time', 'abbr', 'expan', 'ptr', 'ref', 'list', 'item', 'label', 'head', 'headLabel', 'headItem', 'note', 'noteGrp', 'index', 'media', 'graphic', 'binaryObject', 'milestone', 'gb', 'pb', 'lb', 'cb', 'analytic', 'monogr', 'series', 'author', 'editor', 'respStmt', 'resp', 'title', 'meeting', 'imprint', 'publisher', 'biblScope', 'citedRange', 'pubPlace', 'bibl', 'biblStruct', 'listBibl', 'relatedItem', 'l', 'lg', 'sp', 'speaker', 'stage', 'teiCorpus', 'divGen', 'textLang' )</xsl:attribute>
                     <svrl:text>One or more of the elements included on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(every $gi in $except  satisfies $gi = ( 'p', 'foreign', 'emph', 'hi', 'distinct', 'said', 'quote', 'q', 'cit', 'mentioned', 'soCalled', 'desc', 'gloss', 'term', 'ruby', 'rb', 'rt', 'sic', 'corr', 'choice', 'reg', 'orig', 'gap', 'ellipsis', 'add', 'del', 'unclear', 'name', 'rs', 'email', 'address', 'addrLine', 'street', 'postCode', 'postBox', 'num', 'measure', 'measureGrp', 'unit', 'date', 'time', 'abbr', 'expan', 'ptr', 'ref', 'list', 'item', 'label', 'head', 'headLabel', 'headItem', 'note', 'noteGrp', 'index', 'media', 'graphic', 'binaryObject', 'milestone', 'gb', 'pb', 'lb', 'cb', 'analytic', 'monogr', 'series', 'author', 'editor', 'respStmt', 'resp', 'title', 'meeting', 'imprint', 'publisher', 'biblScope', 'citedRange', 'pubPlace', 'bibl', 'biblStruct', 'listBibl', 'relatedItem', 'l', 'lg', 'sp', 'speaker', 'stage', 'teiCorpus', 'divGen', 'textLang' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $except  satisfies $gi = ( 'p', 'foreign', 'emph', 'hi', 'distinct', 'said', 'quote', 'q', 'cit', 'mentioned', 'soCalled', 'desc', 'gloss', 'term', 'ruby', 'rb', 'rt', 'sic', 'corr', 'choice', 'reg', 'orig', 'gap', 'ellipsis', 'add', 'del', 'unclear', 'name', 'rs', 'email', 'address', 'addrLine', 'street', 'postCode', 'postBox', 'num', 'measure', 'measureGrp', 'unit', 'date', 'time', 'abbr', 'expan', 'ptr', 'ref', 'list', 'item', 'label', 'head', 'headLabel', 'headItem', 'note', 'noteGrp', 'index', 'media', 'graphic', 'binaryObject', 'milestone', 'gb', 'pb', 'lb', 'cb', 'analytic', 'monogr', 'series', 'author', 'editor', 'respStmt', 'resp', 'title', 'meeting', 'imprint', 'publisher', 'biblScope', 'citedRange', 'pubPlace', 'bibl', 'biblStruct', 'listBibl', 'relatedItem', 'l', 'lg', 'sp', 'speaker', 'stage', 'teiCorpus', 'divGen', 'textLang' )</xsl:attribute>
                     <svrl:text>One or more of the elements excepted on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e544')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef[@key eq 'textstructure']"
                 priority="85"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e564']">
            <schxslt:rule pattern="d12e564">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef[@key eq 'textstructure']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'textstructure']</xsl:attribute>
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
            <schxslt:rule pattern="d12e564">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'textstructure']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(every $gi in $include satisfies $gi = ( 'TEI', 'text', 'body', 'group', 'floatingText', 'div', 'div1', 'div2', 'div3', 'div4', 'div5', 'div6', 'div7', 'trailer', 'byline', 'dateline', 'argument', 'epigraph', 'opener', 'closer', 'salute', 'signed', 'postscript', 'titlePage', 'docTitle', 'titlePart', 'docAuthor', 'imprimatur', 'docEdition', 'docImprint', 'docDate', 'front', 'back' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $include satisfies $gi = ( 'TEI', 'text', 'body', 'group', 'floatingText', 'div', 'div1', 'div2', 'div3', 'div4', 'div5', 'div6', 'div7', 'trailer', 'byline', 'dateline', 'argument', 'epigraph', 'opener', 'closer', 'salute', 'signed', 'postscript', 'titlePage', 'docTitle', 'titlePart', 'docAuthor', 'imprimatur', 'docEdition', 'docImprint', 'docDate', 'front', 'back' )</xsl:attribute>
                     <svrl:text>One or more of the elements included on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(every $gi in $except  satisfies $gi = ( 'TEI', 'text', 'body', 'group', 'floatingText', 'div', 'div1', 'div2', 'div3', 'div4', 'div5', 'div6', 'div7', 'trailer', 'byline', 'dateline', 'argument', 'epigraph', 'opener', 'closer', 'salute', 'signed', 'postscript', 'titlePage', 'docTitle', 'titlePart', 'docAuthor', 'imprimatur', 'docEdition', 'docImprint', 'docDate', 'front', 'back' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $except  satisfies $gi = ( 'TEI', 'text', 'body', 'group', 'floatingText', 'div', 'div1', 'div2', 'div3', 'div4', 'div5', 'div6', 'div7', 'trailer', 'byline', 'dateline', 'argument', 'epigraph', 'opener', 'closer', 'salute', 'signed', 'postscript', 'titlePage', 'docTitle', 'titlePart', 'docAuthor', 'imprimatur', 'docEdition', 'docImprint', 'docDate', 'front', 'back' )</xsl:attribute>
                     <svrl:text>One or more of the elements excepted on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e564')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef[@key eq 'gaiji']" priority="84" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e585']">
            <schxslt:rule pattern="d12e585">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef[@key eq 'gaiji']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'gaiji']</xsl:attribute>
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
            <schxslt:rule pattern="d12e585">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'gaiji']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(every $gi in $include satisfies $gi = ( 'g', 'charDecl', 'char', 'glyph', 'localProp', 'mapping', 'unihanProp', 'unicodeProp' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $include satisfies $gi = ( 'g', 'charDecl', 'char', 'glyph', 'localProp', 'mapping', 'unihanProp', 'unicodeProp' )</xsl:attribute>
                     <svrl:text>One or more of the elements included on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(every $gi in $except  satisfies $gi = ( 'g', 'charDecl', 'char', 'glyph', 'localProp', 'mapping', 'unihanProp', 'unicodeProp' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $except  satisfies $gi = ( 'g', 'charDecl', 'char', 'glyph', 'localProp', 'mapping', 'unihanProp', 'unicodeProp' )</xsl:attribute>
                     <svrl:text>One or more of the elements excepted on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e585')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef[@key eq 'verse']" priority="83" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e605']">
            <schxslt:rule pattern="d12e605">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef[@key eq 'verse']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'verse']</xsl:attribute>
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
            <schxslt:rule pattern="d12e605">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'verse']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(every $gi in $include satisfies $gi = ( 'metDecl', 'metSym', 'caesura', 'rhyme' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $include satisfies $gi = ( 'metDecl', 'metSym', 'caesura', 'rhyme' )</xsl:attribute>
                     <svrl:text>One or more of the elements included on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(every $gi in $except  satisfies $gi = ( 'metDecl', 'metSym', 'caesura', 'rhyme' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $except  satisfies $gi = ( 'metDecl', 'metSym', 'caesura', 'rhyme' )</xsl:attribute>
                     <svrl:text>One or more of the elements excepted on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e605')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef[@key eq 'drama']" priority="82" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e625']">
            <schxslt:rule pattern="d12e625">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef[@key eq 'drama']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'drama']</xsl:attribute>
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
            <schxslt:rule pattern="d12e625">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'drama']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(every $gi in $include satisfies $gi = ( 'set', 'prologue', 'epilogue', 'performance', 'castList', 'castGroup', 'castItem', 'role', 'roleDesc', 'actor', 'spGrp', 'move', 'view', 'camera', 'sound', 'caption', 'tech' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $include satisfies $gi = ( 'set', 'prologue', 'epilogue', 'performance', 'castList', 'castGroup', 'castItem', 'role', 'roleDesc', 'actor', 'spGrp', 'move', 'view', 'camera', 'sound', 'caption', 'tech' )</xsl:attribute>
                     <svrl:text>One or more of the elements included on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(every $gi in $except  satisfies $gi = ( 'set', 'prologue', 'epilogue', 'performance', 'castList', 'castGroup', 'castItem', 'role', 'roleDesc', 'actor', 'spGrp', 'move', 'view', 'camera', 'sound', 'caption', 'tech' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $except  satisfies $gi = ( 'set', 'prologue', 'epilogue', 'performance', 'castList', 'castGroup', 'castItem', 'role', 'roleDesc', 'actor', 'spGrp', 'move', 'view', 'camera', 'sound', 'caption', 'tech' )</xsl:attribute>
                     <svrl:text>One or more of the elements excepted on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e625')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef[@key eq 'spoken']" priority="81" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e645']">
            <schxslt:rule pattern="d12e645">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef[@key eq 'spoken']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'spoken']</xsl:attribute>
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
            <schxslt:rule pattern="d12e645">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'spoken']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(every $gi in $include satisfies $gi = ( 'scriptStmt', 'recordingStmt', 'recording', 'equipment', 'broadcast', 'transcriptionDesc', 'u', 'pause', 'vocal', 'kinesic', 'incident', 'writing', 'shift', 'annotationBlock' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $include satisfies $gi = ( 'scriptStmt', 'recordingStmt', 'recording', 'equipment', 'broadcast', 'transcriptionDesc', 'u', 'pause', 'vocal', 'kinesic', 'incident', 'writing', 'shift', 'annotationBlock' )</xsl:attribute>
                     <svrl:text>One or more of the elements included on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(every $gi in $except  satisfies $gi = ( 'scriptStmt', 'recordingStmt', 'recording', 'equipment', 'broadcast', 'transcriptionDesc', 'u', 'pause', 'vocal', 'kinesic', 'incident', 'writing', 'shift', 'annotationBlock' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $except  satisfies $gi = ( 'scriptStmt', 'recordingStmt', 'recording', 'equipment', 'broadcast', 'transcriptionDesc', 'u', 'pause', 'vocal', 'kinesic', 'incident', 'writing', 'shift', 'annotationBlock' )</xsl:attribute>
                     <svrl:text>One or more of the elements excepted on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e645')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef[@key eq 'cmc']" priority="80" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e665']">
            <schxslt:rule pattern="d12e665">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef[@key eq 'cmc']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'cmc']</xsl:attribute>
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
            <schxslt:rule pattern="d12e665">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'cmc']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(every $gi in $include satisfies $gi = ( 'post' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $include satisfies $gi = ( 'post' )</xsl:attribute>
                     <svrl:text>One or more of the elements included on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(every $gi in $except  satisfies $gi = ( 'post' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $except  satisfies $gi = ( 'post' )</xsl:attribute>
                     <svrl:text>One or more of the elements excepted on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e665')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef[@key eq 'dictionaries']"
                 priority="79"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e685']">
            <schxslt:rule pattern="d12e685">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef[@key eq 'dictionaries']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'dictionaries']</xsl:attribute>
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
            <schxslt:rule pattern="d12e685">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'dictionaries']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(every $gi in $include satisfies $gi = ( 'superEntry', 'entry', 'entryFree', 'hom', 'sense', 'dictScrap', 'form', 'orth', 'pron', 'hyph', 'syll', 'stress', 'gram', 'gen', 'number', 'case', 'per', 'tns', 'mood', 'iType', 'gramGrp', 'pos', 'subc', 'colloc', 'def', 'etym', 'lang', 'usg', 'lbl', 'xr', 're', 'oRef', 'pRef' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $include satisfies $gi = ( 'superEntry', 'entry', 'entryFree', 'hom', 'sense', 'dictScrap', 'form', 'orth', 'pron', 'hyph', 'syll', 'stress', 'gram', 'gen', 'number', 'case', 'per', 'tns', 'mood', 'iType', 'gramGrp', 'pos', 'subc', 'colloc', 'def', 'etym', 'lang', 'usg', 'lbl', 'xr', 're', 'oRef', 'pRef' )</xsl:attribute>
                     <svrl:text>One or more of the elements included on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(every $gi in $except  satisfies $gi = ( 'superEntry', 'entry', 'entryFree', 'hom', 'sense', 'dictScrap', 'form', 'orth', 'pron', 'hyph', 'syll', 'stress', 'gram', 'gen', 'number', 'case', 'per', 'tns', 'mood', 'iType', 'gramGrp', 'pos', 'subc', 'colloc', 'def', 'etym', 'lang', 'usg', 'lbl', 'xr', 're', 'oRef', 'pRef' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $except  satisfies $gi = ( 'superEntry', 'entry', 'entryFree', 'hom', 'sense', 'dictScrap', 'form', 'orth', 'pron', 'hyph', 'syll', 'stress', 'gram', 'gen', 'number', 'case', 'per', 'tns', 'mood', 'iType', 'gramGrp', 'pos', 'subc', 'colloc', 'def', 'etym', 'lang', 'usg', 'lbl', 'xr', 're', 'oRef', 'pRef' )</xsl:attribute>
                     <svrl:text>One or more of the elements excepted on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e685')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef[@key eq 'msdescription']"
                 priority="78"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e706']">
            <schxslt:rule pattern="d12e706">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef[@key eq 'msdescription']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'msdescription']</xsl:attribute>
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
            <schxslt:rule pattern="d12e706">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'msdescription']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(every $gi in $include satisfies $gi = ( 'msDesc', 'catchwords', 'dimensions', 'dim', 'height', 'depth', 'width', 'heraldry', 'locus', 'locusGrp', 'material', 'objectType', 'origDate', 'origPlace', 'secFol', 'signatures', 'stamp', 'watermark', 'msIdentifier', 'institution', 'repository', 'collection', 'altIdentifier', 'msName', 'colophon', 'explicit', 'filiation', 'finalRubric', 'incipit', 'msContents', 'msItem', 'msItemStruct', 'rubric', 'summary', 'physDesc', 'objectDesc', 'supportDesc', 'support', 'collation', 'foliation', 'condition', 'layoutDesc', 'layout', 'handDesc', 'typeDesc', 'typeNote', 'scriptDesc', 'musicNotation', 'decoDesc', 'decoNote', 'additions', 'bindingDesc', 'binding', 'sealDesc', 'seal', 'accMat', 'history', 'origin', 'provenance', 'acquisition', 'additional', 'adminInfo', 'recordHist', 'source', 'custodialHist', 'custEvent', 'surrogates', 'msPart', 'msFrag' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $include satisfies $gi = ( 'msDesc', 'catchwords', 'dimensions', 'dim', 'height', 'depth', 'width', 'heraldry', 'locus', 'locusGrp', 'material', 'objectType', 'origDate', 'origPlace', 'secFol', 'signatures', 'stamp', 'watermark', 'msIdentifier', 'institution', 'repository', 'collection', 'altIdentifier', 'msName', 'colophon', 'explicit', 'filiation', 'finalRubric', 'incipit', 'msContents', 'msItem', 'msItemStruct', 'rubric', 'summary', 'physDesc', 'objectDesc', 'supportDesc', 'support', 'collation', 'foliation', 'condition', 'layoutDesc', 'layout', 'handDesc', 'typeDesc', 'typeNote', 'scriptDesc', 'musicNotation', 'decoDesc', 'decoNote', 'additions', 'bindingDesc', 'binding', 'sealDesc', 'seal', 'accMat', 'history', 'origin', 'provenance', 'acquisition', 'additional', 'adminInfo', 'recordHist', 'source', 'custodialHist', 'custEvent', 'surrogates', 'msPart', 'msFrag' )</xsl:attribute>
                     <svrl:text>One or more of the elements included on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(every $gi in $except  satisfies $gi = ( 'msDesc', 'catchwords', 'dimensions', 'dim', 'height', 'depth', 'width', 'heraldry', 'locus', 'locusGrp', 'material', 'objectType', 'origDate', 'origPlace', 'secFol', 'signatures', 'stamp', 'watermark', 'msIdentifier', 'institution', 'repository', 'collection', 'altIdentifier', 'msName', 'colophon', 'explicit', 'filiation', 'finalRubric', 'incipit', 'msContents', 'msItem', 'msItemStruct', 'rubric', 'summary', 'physDesc', 'objectDesc', 'supportDesc', 'support', 'collation', 'foliation', 'condition', 'layoutDesc', 'layout', 'handDesc', 'typeDesc', 'typeNote', 'scriptDesc', 'musicNotation', 'decoDesc', 'decoNote', 'additions', 'bindingDesc', 'binding', 'sealDesc', 'seal', 'accMat', 'history', 'origin', 'provenance', 'acquisition', 'additional', 'adminInfo', 'recordHist', 'source', 'custodialHist', 'custEvent', 'surrogates', 'msPart', 'msFrag' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $except  satisfies $gi = ( 'msDesc', 'catchwords', 'dimensions', 'dim', 'height', 'depth', 'width', 'heraldry', 'locus', 'locusGrp', 'material', 'objectType', 'origDate', 'origPlace', 'secFol', 'signatures', 'stamp', 'watermark', 'msIdentifier', 'institution', 'repository', 'collection', 'altIdentifier', 'msName', 'colophon', 'explicit', 'filiation', 'finalRubric', 'incipit', 'msContents', 'msItem', 'msItemStruct', 'rubric', 'summary', 'physDesc', 'objectDesc', 'supportDesc', 'support', 'collation', 'foliation', 'condition', 'layoutDesc', 'layout', 'handDesc', 'typeDesc', 'typeNote', 'scriptDesc', 'musicNotation', 'decoDesc', 'decoNote', 'additions', 'bindingDesc', 'binding', 'sealDesc', 'seal', 'accMat', 'history', 'origin', 'provenance', 'acquisition', 'additional', 'adminInfo', 'recordHist', 'source', 'custodialHist', 'custEvent', 'surrogates', 'msPart', 'msFrag' )</xsl:attribute>
                     <svrl:text>One or more of the elements excepted on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e706')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef[@key eq 'transcr']"
                 priority="77"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e726']">
            <schxslt:rule pattern="d12e726">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef[@key eq 'transcr']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'transcr']</xsl:attribute>
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
            <schxslt:rule pattern="d12e726">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'transcr']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(every $gi in $include satisfies $gi = ( 'facsimile', 'sourceDoc', 'surface', 'surfaceGrp', 'zone', 'path', 'addSpan', 'damage', 'damageSpan', 'delSpan', 'ex', 'fw', 'handNotes', 'handShift', 'am', 'restore', 'space', 'subst', 'substJoin', 'supplied', 'surplus', 'secl', 'line', 'listTranspose', 'metamark', 'mod', 'redo', 'retrace', 'transpose', 'undo' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $include satisfies $gi = ( 'facsimile', 'sourceDoc', 'surface', 'surfaceGrp', 'zone', 'path', 'addSpan', 'damage', 'damageSpan', 'delSpan', 'ex', 'fw', 'handNotes', 'handShift', 'am', 'restore', 'space', 'subst', 'substJoin', 'supplied', 'surplus', 'secl', 'line', 'listTranspose', 'metamark', 'mod', 'redo', 'retrace', 'transpose', 'undo' )</xsl:attribute>
                     <svrl:text>One or more of the elements included on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(every $gi in $except  satisfies $gi = ( 'facsimile', 'sourceDoc', 'surface', 'surfaceGrp', 'zone', 'path', 'addSpan', 'damage', 'damageSpan', 'delSpan', 'ex', 'fw', 'handNotes', 'handShift', 'am', 'restore', 'space', 'subst', 'substJoin', 'supplied', 'surplus', 'secl', 'line', 'listTranspose', 'metamark', 'mod', 'redo', 'retrace', 'transpose', 'undo' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $except  satisfies $gi = ( 'facsimile', 'sourceDoc', 'surface', 'surfaceGrp', 'zone', 'path', 'addSpan', 'damage', 'damageSpan', 'delSpan', 'ex', 'fw', 'handNotes', 'handShift', 'am', 'restore', 'space', 'subst', 'substJoin', 'supplied', 'surplus', 'secl', 'line', 'listTranspose', 'metamark', 'mod', 'redo', 'retrace', 'transpose', 'undo' )</xsl:attribute>
                     <svrl:text>One or more of the elements excepted on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e726')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef[@key eq 'textcrit']"
                 priority="76"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e746']">
            <schxslt:rule pattern="d12e746">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef[@key eq 'textcrit']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'textcrit']</xsl:attribute>
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
            <schxslt:rule pattern="d12e746">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'textcrit']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(every $gi in $include satisfies $gi = ( 'app', 'listApp', 'lem', 'rdg', 'rdgGrp', 'witDetail', 'wit', 'listWit', 'witness', 'witStart', 'witEnd', 'lacunaStart', 'lacunaEnd', 'variantEncoding' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $include satisfies $gi = ( 'app', 'listApp', 'lem', 'rdg', 'rdgGrp', 'witDetail', 'wit', 'listWit', 'witness', 'witStart', 'witEnd', 'lacunaStart', 'lacunaEnd', 'variantEncoding' )</xsl:attribute>
                     <svrl:text>One or more of the elements included on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(every $gi in $except  satisfies $gi = ( 'app', 'listApp', 'lem', 'rdg', 'rdgGrp', 'witDetail', 'wit', 'listWit', 'witness', 'witStart', 'witEnd', 'lacunaStart', 'lacunaEnd', 'variantEncoding' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $except  satisfies $gi = ( 'app', 'listApp', 'lem', 'rdg', 'rdgGrp', 'witDetail', 'wit', 'listWit', 'witness', 'witStart', 'witEnd', 'lacunaStart', 'lacunaEnd', 'variantEncoding' )</xsl:attribute>
                     <svrl:text>One or more of the elements excepted on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e746')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef[@key eq 'namesdates']"
                 priority="75"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e766']">
            <schxslt:rule pattern="d12e766">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef[@key eq 'namesdates']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'namesdates']</xsl:attribute>
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
            <schxslt:rule pattern="d12e766">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'namesdates']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(every $gi in $include satisfies $gi = ( 'orgName', 'persName', 'surname', 'forename', 'genName', 'nameLink', 'addName', 'roleName', 'placeName', 'bloc', 'country', 'region', 'settlement', 'district', 'offset', 'geogName', 'geogFeat', 'eventName', 'affiliation', 'age', 'birth', 'climate', 'death', 'education', 'event', 'faith', 'floruit', 'gender', 'geo', 'langKnowledge', 'langKnown', 'listOrg', 'listEvent', 'listPerson', 'listPlace', 'listRelation', 'location', 'nationality', 'occupation', 'org', 'person', 'persona', 'personGrp', 'persPronouns', 'place', 'population', 'relation', 'residence', 'sex', 'socecStatus', 'state', 'terrain', 'trait', 'objectName', 'object', 'listObject', 'objectIdentifier', 'nym', 'listNym' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $include satisfies $gi = ( 'orgName', 'persName', 'surname', 'forename', 'genName', 'nameLink', 'addName', 'roleName', 'placeName', 'bloc', 'country', 'region', 'settlement', 'district', 'offset', 'geogName', 'geogFeat', 'eventName', 'affiliation', 'age', 'birth', 'climate', 'death', 'education', 'event', 'faith', 'floruit', 'gender', 'geo', 'langKnowledge', 'langKnown', 'listOrg', 'listEvent', 'listPerson', 'listPlace', 'listRelation', 'location', 'nationality', 'occupation', 'org', 'person', 'persona', 'personGrp', 'persPronouns', 'place', 'population', 'relation', 'residence', 'sex', 'socecStatus', 'state', 'terrain', 'trait', 'objectName', 'object', 'listObject', 'objectIdentifier', 'nym', 'listNym' )</xsl:attribute>
                     <svrl:text>One or more of the elements included on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(every $gi in $except  satisfies $gi = ( 'orgName', 'persName', 'surname', 'forename', 'genName', 'nameLink', 'addName', 'roleName', 'placeName', 'bloc', 'country', 'region', 'settlement', 'district', 'offset', 'geogName', 'geogFeat', 'eventName', 'affiliation', 'age', 'birth', 'climate', 'death', 'education', 'event', 'faith', 'floruit', 'gender', 'geo', 'langKnowledge', 'langKnown', 'listOrg', 'listEvent', 'listPerson', 'listPlace', 'listRelation', 'location', 'nationality', 'occupation', 'org', 'person', 'persona', 'personGrp', 'persPronouns', 'place', 'population', 'relation', 'residence', 'sex', 'socecStatus', 'state', 'terrain', 'trait', 'objectName', 'object', 'listObject', 'objectIdentifier', 'nym', 'listNym' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $except  satisfies $gi = ( 'orgName', 'persName', 'surname', 'forename', 'genName', 'nameLink', 'addName', 'roleName', 'placeName', 'bloc', 'country', 'region', 'settlement', 'district', 'offset', 'geogName', 'geogFeat', 'eventName', 'affiliation', 'age', 'birth', 'climate', 'death', 'education', 'event', 'faith', 'floruit', 'gender', 'geo', 'langKnowledge', 'langKnown', 'listOrg', 'listEvent', 'listPerson', 'listPlace', 'listRelation', 'location', 'nationality', 'occupation', 'org', 'person', 'persona', 'personGrp', 'persPronouns', 'place', 'population', 'relation', 'residence', 'sex', 'socecStatus', 'state', 'terrain', 'trait', 'objectName', 'object', 'listObject', 'objectIdentifier', 'nym', 'listNym' )</xsl:attribute>
                     <svrl:text>One or more of the elements excepted on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e766')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef[@key eq 'figures']"
                 priority="74"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e786']">
            <schxslt:rule pattern="d12e786">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef[@key eq 'figures']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'figures']</xsl:attribute>
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
            <schxslt:rule pattern="d12e786">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'figures']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(every $gi in $include satisfies $gi = ( 'table', 'row', 'cell', 'formula', 'notatedMusic', 'figure', 'figDesc' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $include satisfies $gi = ( 'table', 'row', 'cell', 'formula', 'notatedMusic', 'figure', 'figDesc' )</xsl:attribute>
                     <svrl:text>One or more of the elements included on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(every $gi in $except  satisfies $gi = ( 'table', 'row', 'cell', 'formula', 'notatedMusic', 'figure', 'figDesc' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $except  satisfies $gi = ( 'table', 'row', 'cell', 'formula', 'notatedMusic', 'figure', 'figDesc' )</xsl:attribute>
                     <svrl:text>One or more of the elements excepted on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e786')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef[@key eq 'corpus']" priority="73" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e806']">
            <schxslt:rule pattern="d12e806">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef[@key eq 'corpus']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'corpus']</xsl:attribute>
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
            <schxslt:rule pattern="d12e806">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'corpus']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(every $gi in $include satisfies $gi = ( 'textDesc', 'particDesc', 'settingDesc', 'channel', 'constitution', 'derivation', 'domain', 'factuality', 'interaction', 'preparedness', 'purpose', 'setting', 'locale', 'activity' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $include satisfies $gi = ( 'textDesc', 'particDesc', 'settingDesc', 'channel', 'constitution', 'derivation', 'domain', 'factuality', 'interaction', 'preparedness', 'purpose', 'setting', 'locale', 'activity' )</xsl:attribute>
                     <svrl:text>One or more of the elements included on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(every $gi in $except  satisfies $gi = ( 'textDesc', 'particDesc', 'settingDesc', 'channel', 'constitution', 'derivation', 'domain', 'factuality', 'interaction', 'preparedness', 'purpose', 'setting', 'locale', 'activity' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $except  satisfies $gi = ( 'textDesc', 'particDesc', 'settingDesc', 'channel', 'constitution', 'derivation', 'domain', 'factuality', 'interaction', 'preparedness', 'purpose', 'setting', 'locale', 'activity' )</xsl:attribute>
                     <svrl:text>One or more of the elements excepted on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e806')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef[@key eq 'linking']"
                 priority="72"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e827']">
            <schxslt:rule pattern="d12e827">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef[@key eq 'linking']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'linking']</xsl:attribute>
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
            <schxslt:rule pattern="d12e827">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'linking']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(every $gi in $include satisfies $gi = ( 'link', 'linkGrp', 'ab', 'anchor', 'seg', 'when', 'timeline', 'join', 'joinGrp', 'alt', 'altGrp', 'standOff', 'listAnnotation', 'annotation' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $include satisfies $gi = ( 'link', 'linkGrp', 'ab', 'anchor', 'seg', 'when', 'timeline', 'join', 'joinGrp', 'alt', 'altGrp', 'standOff', 'listAnnotation', 'annotation' )</xsl:attribute>
                     <svrl:text>One or more of the elements included on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(every $gi in $except  satisfies $gi = ( 'link', 'linkGrp', 'ab', 'anchor', 'seg', 'when', 'timeline', 'join', 'joinGrp', 'alt', 'altGrp', 'standOff', 'listAnnotation', 'annotation' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $except  satisfies $gi = ( 'link', 'linkGrp', 'ab', 'anchor', 'seg', 'when', 'timeline', 'join', 'joinGrp', 'alt', 'altGrp', 'standOff', 'listAnnotation', 'annotation' )</xsl:attribute>
                     <svrl:text>One or more of the elements excepted on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e827')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef[@key eq 'analysis']"
                 priority="71"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e847']">
            <schxslt:rule pattern="d12e847">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef[@key eq 'analysis']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'analysis']</xsl:attribute>
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
            <schxslt:rule pattern="d12e847">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'analysis']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(every $gi in $include satisfies $gi = ( 's', 'cl', 'phr', 'w', 'm', 'c', 'pc', 'span', 'spanGrp', 'interp', 'interpGrp' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $include satisfies $gi = ( 's', 'cl', 'phr', 'w', 'm', 'c', 'pc', 'span', 'spanGrp', 'interp', 'interpGrp' )</xsl:attribute>
                     <svrl:text>One or more of the elements included on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(every $gi in $except  satisfies $gi = ( 's', 'cl', 'phr', 'w', 'm', 'c', 'pc', 'span', 'spanGrp', 'interp', 'interpGrp' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $except  satisfies $gi = ( 's', 'cl', 'phr', 'w', 'm', 'c', 'pc', 'span', 'spanGrp', 'interp', 'interpGrp' )</xsl:attribute>
                     <svrl:text>One or more of the elements excepted on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e847')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef[@key eq 'iso-fs']" priority="70" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e867']">
            <schxslt:rule pattern="d12e867">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef[@key eq 'iso-fs']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'iso-fs']</xsl:attribute>
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
            <schxslt:rule pattern="d12e867">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'iso-fs']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(every $gi in $include satisfies $gi = ( 'fsdDecl', 'fsDecl', 'fsDescr', 'fsdLink', 'fDecl', 'fDescr', 'vRange', 'vDefault', 'if', 'then', 'fsConstraints', 'cond', 'bicond', 'iff', 'fs', 'f', 'binary', 'symbol', 'numeric', 'string', 'vLabel', 'vColl', 'default', 'vAlt', 'vNot', 'vMerge', 'fLib', 'fvLib' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $include satisfies $gi = ( 'fsdDecl', 'fsDecl', 'fsDescr', 'fsdLink', 'fDecl', 'fDescr', 'vRange', 'vDefault', 'if', 'then', 'fsConstraints', 'cond', 'bicond', 'iff', 'fs', 'f', 'binary', 'symbol', 'numeric', 'string', 'vLabel', 'vColl', 'default', 'vAlt', 'vNot', 'vMerge', 'fLib', 'fvLib' )</xsl:attribute>
                     <svrl:text>One or more of the elements included on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(every $gi in $except  satisfies $gi = ( 'fsdDecl', 'fsDecl', 'fsDescr', 'fsdLink', 'fDecl', 'fDescr', 'vRange', 'vDefault', 'if', 'then', 'fsConstraints', 'cond', 'bicond', 'iff', 'fs', 'f', 'binary', 'symbol', 'numeric', 'string', 'vLabel', 'vColl', 'default', 'vAlt', 'vNot', 'vMerge', 'fLib', 'fvLib' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $except  satisfies $gi = ( 'fsdDecl', 'fsDecl', 'fsDescr', 'fsdLink', 'fDecl', 'fDescr', 'vRange', 'vDefault', 'if', 'then', 'fsConstraints', 'cond', 'bicond', 'iff', 'fs', 'f', 'binary', 'symbol', 'numeric', 'string', 'vLabel', 'vColl', 'default', 'vAlt', 'vNot', 'vMerge', 'fLib', 'fvLib' )</xsl:attribute>
                     <svrl:text>One or more of the elements excepted on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e867')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef[@key eq 'nets']" priority="69" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e887']">
            <schxslt:rule pattern="d12e887">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef[@key eq 'nets']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'nets']</xsl:attribute>
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
            <schxslt:rule pattern="d12e887">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'nets']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(every $gi in $include satisfies $gi = ( 'graph', 'node', 'arc', 'tree', 'root', 'iNode', 'leaf', 'eTree', 'triangle', 'eLeaf', 'forest', 'listForest' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $include satisfies $gi = ( 'graph', 'node', 'arc', 'tree', 'root', 'iNode', 'leaf', 'eTree', 'triangle', 'eLeaf', 'forest', 'listForest' )</xsl:attribute>
                     <svrl:text>One or more of the elements included on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(every $gi in $except  satisfies $gi = ( 'graph', 'node', 'arc', 'tree', 'root', 'iNode', 'leaf', 'eTree', 'triangle', 'eLeaf', 'forest', 'listForest' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $except  satisfies $gi = ( 'graph', 'node', 'arc', 'tree', 'root', 'iNode', 'leaf', 'eTree', 'triangle', 'eLeaf', 'forest', 'listForest' )</xsl:attribute>
                     <svrl:text>One or more of the elements excepted on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e887')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef[@key eq 'certainty']"
                 priority="68"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e907']">
            <schxslt:rule pattern="d12e907">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef[@key eq 'certainty']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'certainty']</xsl:attribute>
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
            <schxslt:rule pattern="d12e907">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'certainty']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(every $gi in $include satisfies $gi = ( 'precision', 'certainty', 'respons' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $include satisfies $gi = ( 'precision', 'certainty', 'respons' )</xsl:attribute>
                     <svrl:text>One or more of the elements included on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(every $gi in $except  satisfies $gi = ( 'precision', 'certainty', 'respons' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $except  satisfies $gi = ( 'precision', 'certainty', 'respons' )</xsl:attribute>
                     <svrl:text>One or more of the elements excepted on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e907')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef[@key eq 'tagdocs']"
                 priority="67"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="include" select="tokenize( normalize-space(@include),' ')"/>
      <xsl:variable name="except" select="tokenize( normalize-space(@except), ' ')"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e927']">
            <schxslt:rule pattern="d12e927">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef[@key eq 'tagdocs']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'tagdocs']</xsl:attribute>
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
            <schxslt:rule pattern="d12e927">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef[@key eq 'tagdocs']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(every $gi in $include satisfies $gi = ( 'att', 'code', 'eg', 'egXML', 'gi', 'ident', 'tag', 'val', 'specList', 'specDesc', 'classRef', 'elementRef', 'macroRef', 'moduleRef', 'moduleSpec', 'schemaSpec', 'specGrp', 'specGrpRef', 'elementSpec', 'classSpec', 'dataSpec', 'macroSpec', 'remarks', 'listRef', 'exemplum', 'classes', 'memberOf', 'equiv', 'altIdent', 'model', 'modelSequence', 'modelGrp', 'outputRendition', 'paramList', 'paramSpec', 'param', 'content', 'sequence', 'alternate', 'constraintDecl', 'constraint', 'constraintSpec', 'attList', 'attDef', 'attRef', 'datatype', 'dataRef', 'dataFacet', 'defaultVal', 'valDesc', 'valItem', 'valList', 'textNode', 'anyElement', 'empty' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $include satisfies $gi = ( 'att', 'code', 'eg', 'egXML', 'gi', 'ident', 'tag', 'val', 'specList', 'specDesc', 'classRef', 'elementRef', 'macroRef', 'moduleRef', 'moduleSpec', 'schemaSpec', 'specGrp', 'specGrpRef', 'elementSpec', 'classSpec', 'dataSpec', 'macroSpec', 'remarks', 'listRef', 'exemplum', 'classes', 'memberOf', 'equiv', 'altIdent', 'model', 'modelSequence', 'modelGrp', 'outputRendition', 'paramList', 'paramSpec', 'param', 'content', 'sequence', 'alternate', 'constraintDecl', 'constraint', 'constraintSpec', 'attList', 'attDef', 'attRef', 'datatype', 'dataRef', 'dataFacet', 'defaultVal', 'valDesc', 'valItem', 'valList', 'textNode', 'anyElement', 'empty' )</xsl:attribute>
                     <svrl:text>One or more of the elements included on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(every $gi in $except  satisfies $gi = ( 'att', 'code', 'eg', 'egXML', 'gi', 'ident', 'tag', 'val', 'specList', 'specDesc', 'classRef', 'elementRef', 'macroRef', 'moduleRef', 'moduleSpec', 'schemaSpec', 'specGrp', 'specGrpRef', 'elementSpec', 'classSpec', 'dataSpec', 'macroSpec', 'remarks', 'listRef', 'exemplum', 'classes', 'memberOf', 'equiv', 'altIdent', 'model', 'modelSequence', 'modelGrp', 'outputRendition', 'paramList', 'paramSpec', 'param', 'content', 'sequence', 'alternate', 'constraintDecl', 'constraint', 'constraintSpec', 'attList', 'attDef', 'attRef', 'datatype', 'dataRef', 'dataFacet', 'defaultVal', 'valDesc', 'valItem', 'valList', 'textNode', 'anyElement', 'empty' ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">every $gi in $except  satisfies $gi = ( 'att', 'code', 'eg', 'egXML', 'gi', 'ident', 'tag', 'val', 'specList', 'specDesc', 'classRef', 'elementRef', 'macroRef', 'moduleRef', 'moduleSpec', 'schemaSpec', 'specGrp', 'specGrpRef', 'elementSpec', 'classSpec', 'dataSpec', 'macroSpec', 'remarks', 'listRef', 'exemplum', 'classes', 'memberOf', 'equiv', 'altIdent', 'model', 'modelSequence', 'modelGrp', 'outputRendition', 'paramList', 'paramSpec', 'param', 'content', 'sequence', 'alternate', 'constraintDecl', 'constraint', 'constraintSpec', 'attList', 'attDef', 'attRef', 'datatype', 'dataRef', 'dataFacet', 'defaultVal', 'valDesc', 'valItem', 'valList', 'textNode', 'anyElement', 'empty' )</xsl:attribute>
                     <svrl:text>One or more of the elements excepted on the '<xsl:value-of select="@key"/>' ＜moduleRef＞ are not actually available in that module</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e927')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef" priority="66" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e948']">
            <schxslt:rule pattern="d12e948">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef</xsl:attribute>
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
            <schxslt:rule pattern="d12e948">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="* and @key">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">* and @key</xsl:attribute>
                     <svrl:text> Child elements of <xsl:value-of select="name()"/> are only allowed when an external module is being loaded</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e948')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef" priority="65" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e959']">
            <schxslt:rule pattern="d12e959">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef</xsl:attribute>
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
            <schxslt:rule pattern="d12e959">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="//*[ not( generate-id(.) eq generate-id( current() ) ) ]/@prefix = @prefix">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">//*[ not( generate-id(.) eq generate-id( current() ) ) ]/@prefix = @prefix</xsl:attribute>
                     <svrl:text>The prefix attribute of <xsl:value-of select="name()"/> should not match that of any other element (it would defeat the purpose)</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e959')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef" priority="64" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e970']">
            <schxslt:rule pattern="d12e970">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef</xsl:attribute>
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
            <schxslt:rule pattern="d12e970">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="@except and @include">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@except and @include</xsl:attribute>
                     <svrl:text>It is an error to supply both the @include and @except attributes</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e970')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef" priority="63" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e979']">
            <schxslt:rule pattern="d12e979">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef</xsl:attribute>
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
            <schxslt:rule pattern="d12e979">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="//*[ not( generate-id(.) eq generate-id( current() ) ) ]/@prefix = @prefix">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">//*[ not( generate-id(.) eq generate-id( current() ) ) ]/@prefix = @prefix</xsl:attribute>
                     <svrl:text>The prefix attribute of <xsl:value-of select="name()"/> should not match that of any other element (it would defeat the purpose)</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e979')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:moduleRef" priority="62" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e990']">
            <schxslt:rule pattern="d12e990">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:moduleRef" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef</xsl:attribute>
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
            <schxslt:rule pattern="d12e990">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:moduleRef</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="@except and @include">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@except and @include</xsl:attribute>
                     <svrl:text>It is an error to supply both the @include and @except attributes</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e990')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:schemaSpec" priority="61" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e999']">
            <schxslt:rule pattern="d12e999">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:schemaSpec" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:schemaSpec</xsl:attribute>
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
            <schxslt:rule pattern="d12e999">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:schemaSpec</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(                         ( tei:moduleRef[ @key eq 'tei']                           or                           tei:specGrpRef[ id( substring-after( normalize-space( @target ), '#') )/tei:moduleRef[ @key eq 'tei'] ] )                                               and                           ( tei:moduleRef[ @key eq 'core']                           or                           tei:specGrpRef[ id( substring-after( normalize-space( @target ), '#') )/tei:moduleRef[ @key eq 'core'] ] )                                               and                           ( tei:moduleRef[ @key eq 'header']                           or                           tei:specGrpRef[ id( substring-after( normalize-space( @target ), '#') )/tei:moduleRef[ @key eq 'header'] ] )                                               and                           ( tei:moduleRef[ @key eq 'textstructure']                           or                           tei:specGrpRef[ id( substring-after( normalize-space( @target ), '#') )/tei:moduleRef[ @key eq 'textstructure'] ] )                                             )">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">                         ( tei:moduleRef[ @key eq 'tei']                           or                           tei:specGrpRef[ id( substring-after( normalize-space( @target ), '#') )/tei:moduleRef[ @key eq 'tei'] ] )                                               and                           ( tei:moduleRef[ @key eq 'core']                           or                           tei:specGrpRef[ id( substring-after( normalize-space( @target ), '#') )/tei:moduleRef[ @key eq 'core'] ] )                                               and                           ( tei:moduleRef[ @key eq 'header']                           or                           tei:specGrpRef[ id( substring-after( normalize-space( @target ), '#') )/tei:moduleRef[ @key eq 'header'] ] )                                               and                           ( tei:moduleRef[ @key eq 'textstructure']                           or                           tei:specGrpRef[ id( substring-after( normalize-space( @target ), '#') )/tei:moduleRef[ @key eq 'textstructure'] ] )                                             </xsl:attribute>
                     <svrl:text> missing one or more of the required modules (tei, core, header, textstructure).</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e999')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:classSpec[ not( ancestor::tei:schemaSpec ) ]                                      | tei:elementSpec[ not( ancestor::tei:schemaSpec ) ]                                      | tei:macroSpec[ not( ancestor::tei:schemaSpec ) ]"
                 priority="60"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1009']">
            <schxslt:rule pattern="d12e1009">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:classSpec[ not( ancestor::tei:schemaSpec ) ] | tei:elementSpec[ not( ancestor::tei:schemaSpec ) ] | tei:macroSpec[ not( ancestor::tei:schemaSpec ) ]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:classSpec[ not( ancestor::tei:schemaSpec ) ]                                      | tei:elementSpec[ not( ancestor::tei:schemaSpec ) ]                                      | tei:macroSpec[ not( ancestor::tei:schemaSpec ) ]</xsl:attribute>
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
            <schxslt:rule pattern="d12e1009">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:classSpec[ not( ancestor::tei:schemaSpec ) ]                                      | tei:elementSpec[ not( ancestor::tei:schemaSpec ) ]                                      | tei:macroSpec[ not( ancestor::tei:schemaSpec ) ]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(//tei:schemaSpec//tei:specGrpRef                                         [ substring-after( normalize-space( @target ), '#')                                            eq                                           current()/ancestor::tei:specGrp/@xml:id ])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">//tei:schemaSpec//tei:specGrpRef                                         [ substring-after( normalize-space( @target ), '#')                                            eq                                           current()/ancestor::tei:specGrp/@xml:id ]</xsl:attribute>
                     <svrl:text>＜<xsl:value-of select="name()"/>＞ should be in ＜schemaSpec＞ or referred to from within ＜schemaSpec＞</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1009')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/" priority="59" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1020']">
            <schxslt:rule pattern="d12e1020">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/</xsl:attribute>
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
            <schxslt:rule pattern="d12e1020">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="count( //tei:schemaSpec ) eq 0">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">count( //tei:schemaSpec ) eq 0</xsl:attribute>
                     <svrl:text>There's no ＜schemaSpec＞, so this isn't much of a TEI customization</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
               <xsl:if test="count( //tei:schemaSpec ) gt 1">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">count( //tei:schemaSpec ) gt 1</xsl:attribute>
                     <svrl:text>You have more than one ＜schemaSpec＞; current ODD processors will only look at the first one</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1020')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:elementSpec" priority="58" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1032']">
            <schxslt:rule pattern="d12e1032">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:elementSpec" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:elementSpec</xsl:attribute>
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
            <schxslt:rule pattern="d12e1032">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:elementSpec</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@mode)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@mode</xsl:attribute>
                     <svrl:text> in a customization ODD, the mode= attribute of ＜elementSpec＞ should be specified</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not( @module )  and  not( @mode='add')">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">not( @module )  and  not( @mode='add')</xsl:attribute>
                     <svrl:text> the module= attribute of ＜elementSpec＞ must be specified anytime the mode= is not 'add'</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1032')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:elementSpec" priority="57" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1044']">
            <schxslt:rule pattern="d12e1044">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:elementSpec" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:elementSpec</xsl:attribute>
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
            <schxslt:rule pattern="d12e1044">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:elementSpec</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="//tei:elementSpec[ @ident eq current()/@ident  and  not( . is current() ) ]">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">//tei:elementSpec[ @ident eq current()/@ident  and  not( . is current() ) ]</xsl:attribute>
                     <svrl:text>Current ODD processors will not correctly handle more than one ＜elementSpec＞ with the same @ident</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1044')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:elementSpec" priority="56" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1053']">
            <schxslt:rule pattern="d12e1053">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:elementSpec" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:elementSpec</xsl:attribute>
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
            <schxslt:rule pattern="d12e1053">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:elementSpec</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="@mode='delete' and @ident='TEI'">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@mode='delete' and @ident='TEI'</xsl:attribute>
                     <svrl:text>Removing ＜TEI＞ from your schema guarantees it is not TEI conformant</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
               <xsl:if test="@mode='delete' and @ident='teiHeader'">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@mode='delete' and @ident='teiHeader'</xsl:attribute>
                     <svrl:text>Removing ＜teiHeader＞ from your schema guarantees it is not TEI conformant</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
               <xsl:if test="@mode='delete' and @ident='fileDesc'">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@mode='delete' and @ident='fileDesc'</xsl:attribute>
                     <svrl:text>Removing ＜fileDesc＞ from your schema guarantees it is not TEI conformant</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
               <xsl:if test="@mode='delete' and @ident='titleStmt'">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@mode='delete' and @ident='titleStmt'</xsl:attribute>
                     <svrl:text>Removing ＜titleStmt＞ from your schema guarantees it is not TEI conformant</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
               <xsl:if test="@mode='delete' and @ident='title'">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@mode='delete' and @ident='title'</xsl:attribute>
                     <svrl:text>Removing ＜title＞ from your schema guarantees it is not TEI conformant</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
               <xsl:if test="@mode='delete' and @ident='publicationStmt'">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@mode='delete' and @ident='publicationStmt'</xsl:attribute>
                     <svrl:text>Removing ＜publicationStmt＞ from your schema guarantees it is not TEI conformant</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
               <xsl:if test="@mode='delete' and @ident='sourceDesc'">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@mode='delete' and @ident='sourceDesc'</xsl:attribute>
                     <svrl:text>Removing ＜sourceDesc＞ from your schema guarantees it is not TEI conformant</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1053')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:elementSpec[ @mode = ('add','replace') ]"
                 priority="55"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1081']">
            <schxslt:rule pattern="d12e1081">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:elementSpec[ @mode = ('add','replace') ]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:elementSpec[ @mode = ('add','replace') ]</xsl:attribute>
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
            <schxslt:rule pattern="d12e1081">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:elementSpec[ @mode = ('add','replace') ]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(tei:content)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">tei:content</xsl:attribute>
                     <svrl:text>When adding a new element (whether replacing an old one or not), a content model must be specified; but this ＜elementSpec＞ does not have a ＜content＞ child.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1081')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:elementSpec[ @mode eq 'delete']"
                 priority="54"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1091']">
            <schxslt:rule pattern="d12e1091">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:elementSpec[ @mode eq 'delete']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:elementSpec[ @mode eq 'delete']</xsl:attribute>
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
            <schxslt:rule pattern="d12e1091">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:elementSpec[ @mode eq 'delete']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="*">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">*</xsl:attribute>
                     <svrl:text>When used to delete an element from your schema, the ＜elementSpec＞ should be empty</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1091')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:elementSpec[ @mode eq 'add'  or  not( @mode ) ]"
                 priority="53"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1100']">
            <schxslt:rule pattern="d12e1100">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:elementSpec[ @mode eq 'add' or not( @mode ) ]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:elementSpec[ @mode eq 'add'  or  not( @mode ) ]</xsl:attribute>
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
            <schxslt:rule pattern="d12e1100">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:elementSpec[ @mode eq 'add'  or  not( @mode ) ]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(ancestor-or-self::*/@ns)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">ancestor-or-self::*/@ns</xsl:attribute>
                     <svrl:text>When used to add an element, ＜elementSpec＞ (or its ancestor ＜schemaSpec＞) should have an @ns attribute.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1100')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:elementSpec[ @mode eq 'delete' ]"
                 priority="52"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1109']">
            <schxslt:rule pattern="d12e1109">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:elementSpec[ @mode eq 'delete' ]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:elementSpec[ @mode eq 'delete' ]</xsl:attribute>
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
            <schxslt:rule pattern="d12e1109">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:elementSpec[ @mode eq 'delete' ]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="child::*">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">child::*</xsl:attribute>
                     <svrl:text>This elementSpec element has a mode= of "delete" even though it has child elements. Change the mode= to "add", "change", or "replace", or remove the child elements.</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1109')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:elementSpec[ @mode = ('add','change','replace') ]"
                 priority="51"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1118']">
            <schxslt:rule pattern="d12e1118">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:elementSpec[ @mode = ('add','change','replace') ]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:elementSpec[ @mode = ('add','change','replace') ]</xsl:attribute>
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
            <schxslt:rule pattern="d12e1118">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:elementSpec[ @mode = ('add','change','replace') ]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(child::* | (@* except (@mode, @ident)))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">child::* | (@* except (@mode, @ident))</xsl:attribute>
                     <svrl:text>This elementSpec element has a mode= of "<xsl:value-of select="@mode"/>", but does not have any child elements or schema-changing attributes. Specify child elements, use validUntil=, predeclare=, ns=, or prefix=, or change the mode= to "delete".</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1118')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:dataSpec/tei:content" priority="50" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1129']">
            <schxslt:rule pattern="d12e1129">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:dataSpec/tei:content" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" role="warn">
                  <xsl:attribute name="context">tei:dataSpec/tei:content</xsl:attribute>
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
            <schxslt:rule pattern="d12e1129">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" role="warn">
                  <xsl:attribute name="context">tei:dataSpec/tei:content</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test=".//tei:anyElement | .//tei:classRef | .//tei:elementRef">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">.//tei:anyElement | .//tei:classRef | .//tei:elementRef</xsl:attribute>
                     <svrl:text> A datatype specification should not refer to an element or a class.</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1129')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="( tei:classSpec | tei:dataSpec | tei:elementSpec | tei:macroSpec | tei:moduleSpec | tei:schemaSpec | tei:specGrp )/tei:listRef"
                 priority="49"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1138']">
            <schxslt:rule pattern="d12e1138">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "( tei:classSpec | tei:dataSpec | tei:elementSpec | tei:macroSpec | tei:moduleSpec | tei:schemaSpec | tei:specGrp )/tei:listRef" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">( tei:classSpec | tei:dataSpec | tei:elementSpec | tei:macroSpec | tei:moduleSpec | tei:schemaSpec | tei:specGrp )/tei:listRef</xsl:attribute>
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
            <schxslt:rule pattern="d12e1138">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">( tei:classSpec | tei:dataSpec | tei:elementSpec | tei:macroSpec | tei:moduleSpec | tei:schemaSpec | tei:specGrp )/tei:listRef</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="tei:listRef">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">tei:listRef</xsl:attribute>
                     <svrl:text>In the context of tagset documentation, the listRef element must not self-nest.</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1138')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="( tei:classSpec | tei:dataSpec | tei:elementSpec | tei:macroSpec | tei:moduleSpec | tei:schemaSpec | tei:specGrp )/tei:listRef/tei:ptr | ( tei:classSpec | tei:dataSpec | tei:elementSpec | tei:macroSpec | tei:moduleSpec | tei:schemaSpec | tei:specGrp )/tei:listRef/tei:ref"
                 priority="48"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1148']">
            <schxslt:rule pattern="d12e1148">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "( tei:classSpec | tei:dataSpec | tei:elementSpec | tei:macroSpec | tei:moduleSpec | tei:schemaSpec | tei:specGrp )/tei:listRef/tei:ptr | ( tei:classSpec | tei:dataSpec | tei:elementSpec | tei:macroSpec | tei:moduleSpec | tei:schemaSpec | tei:specGrp )/tei:listRef/tei:ref" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">( tei:classSpec | tei:dataSpec | tei:elementSpec | tei:macroSpec | tei:moduleSpec | tei:schemaSpec | tei:specGrp )/tei:listRef/tei:ptr | ( tei:classSpec | tei:dataSpec | tei:elementSpec | tei:macroSpec | tei:moduleSpec | tei:schemaSpec | tei:specGrp )/tei:listRef/tei:ref</xsl:attribute>
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
            <schxslt:rule pattern="d12e1148">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">( tei:classSpec | tei:dataSpec | tei:elementSpec | tei:macroSpec | tei:moduleSpec | tei:schemaSpec | tei:specGrp )/tei:listRef/tei:ptr | ( tei:classSpec | tei:dataSpec | tei:elementSpec | tei:macroSpec | tei:moduleSpec | tei:schemaSpec | tei:specGrp )/tei:listRef/tei:ref</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@target and not( matches( @target,'\s') ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@target and not( matches( @target,'\s') )</xsl:attribute>
                     <svrl:text>In the context of tagset documentation, each ptr or ref element inside a listRef must have a target attribute with only 1 pointer as its value.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1148')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:model[ not( parent::tei:modelSequence ) ][ not( @predicate ) ]"
                 priority="47"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="output" select="normalize-space( @output )"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1157']">
            <schxslt:rule pattern="d12e1157">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:model[ not( parent::tei:modelSequence ) ][ not( @predicate ) ]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:model[ not( parent::tei:modelSequence ) ][ not( @predicate ) ]</xsl:attribute>
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
            <schxslt:rule pattern="d12e1157">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:model[ not( parent::tei:modelSequence ) ][ not( @predicate ) ]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="following-sibling::tei:model [ not( @predicate )] [ normalize-space( @output ) eq $output ]">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">following-sibling::tei:model [ not( @predicate )] [ normalize-space( @output ) eq $output ]</xsl:attribute>
                     <svrl:text> There are 2 (or more) 'model' elements in this '<xsl:value-of select="local-name(..)"/>' that have no predicate, but are targeted to the same output ("<xsl:value-of select="( $output, parent::modelGrp/@output, 'all')[1]"/>")</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1157')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:model[ not( parent::tei:modelSequence ) ][ @predicate ]"
                 priority="46"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="predicate" select="normalize-space( @predicate )"/>
      <xsl:variable name="output" select="normalize-space( @output )"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1172']">
            <schxslt:rule pattern="d12e1172">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:model[ not( parent::tei:modelSequence ) ][ @predicate ]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:model[ not( parent::tei:modelSequence ) ][ @predicate ]</xsl:attribute>
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
            <schxslt:rule pattern="d12e1172">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:model[ not( parent::tei:modelSequence ) ][ @predicate ]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="following-sibling::tei:model [ normalize-space( @predicate ) eq $predicate ] [ normalize-space( @output ) eq $output ]">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">following-sibling::tei:model [ normalize-space( @predicate ) eq $predicate ] [ normalize-space( @output ) eq $output ]</xsl:attribute>
                     <svrl:text> There are 2 (or more) 'model' elements in this '<xsl:value-of select="local-name(..)"/>' that have the same predicate, and are targeted to the same output ("<xsl:value-of select="( $output, parent::modelGrp/@output, 'all')[1]"/>")</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1172')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:modelSequence" priority="45" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1189']">
            <schxslt:rule pattern="d12e1189">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:modelSequence" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:modelSequence</xsl:attribute>
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
            <schxslt:rule pattern="d12e1189">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:modelSequence</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="tei:model[@output]">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}"
                                          role="warning">
                     <xsl:attribute name="test">tei:model[@output]</xsl:attribute>
                     <svrl:text>The 'model' children of a 'modelSequence' element inherit the @output attribute of the parent 'modelSequence', and thus should not have their own</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1189')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:sequence" priority="44" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1198']">
            <schxslt:rule pattern="d12e1198">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:sequence" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:sequence</xsl:attribute>
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
            <schxslt:rule pattern="d12e1198">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:sequence</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(count(*) gt 1)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">count(*) gt 1</xsl:attribute>
                     <svrl:text>The sequence element must have at least two child elements</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1198')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:alternate" priority="43" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1207']">
            <schxslt:rule pattern="d12e1207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:alternate" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:alternate</xsl:attribute>
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
            <schxslt:rule pattern="d12e1207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:alternate</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(count(*) gt 1)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">count(*) gt 1</xsl:attribute>
                     <svrl:text>The alternate element must have at least two child elements</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/*[ count( //tei:constraintDecl ) gt 1 ]"
                 priority="42"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="schemes"
                    select="//tei:constraintDecl[ not(ancestor::*[local-name(.) eq 'egXML'] ) ]/@scheme"/>
      <xsl:variable name="disctinct_schemes" select="distinct-values( $schemes )"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1217']">
            <schxslt:rule pattern="d12e1217">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/*[ count( //tei:constraintDecl ) gt 1 ]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/*[ count( //tei:constraintDecl ) gt 1 ]</xsl:attribute>
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
            <schxslt:rule pattern="d12e1217">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/*[ count( //tei:constraintDecl ) gt 1 ]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(count( $schemes ) eq count( $disctinct_schemes ))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">count( $schemes ) eq count( $disctinct_schemes )</xsl:attribute>
                     <svrl:text> Each &lt;constraintDecl&gt; element should have a @scheme attribute that is distinct from that of all the other &lt;constraintDecl&gt;s.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1217')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:constraintSpec[ @mode eq 'delete']"
                 priority="41"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1230']">
            <schxslt:rule pattern="d12e1230">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:constraintSpec[ @mode eq 'delete']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:constraintSpec[ @mode eq 'delete']</xsl:attribute>
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
            <schxslt:rule pattern="d12e1230">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:constraintSpec[ @mode eq 'delete']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="child::*">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">child::*</xsl:attribute>
                     <svrl:text>This constraintSpec element has a mode= of "delete" even though it has child elements. Change the mode= to "add", "change", or "replace", or remove the child elements.</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1230')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:constraintSpec[ @mode eq 'change']"
                 priority="40"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1239']">
            <schxslt:rule pattern="d12e1239">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:constraintSpec[ @mode eq 'change']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:constraintSpec[ @mode eq 'change']</xsl:attribute>
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
            <schxslt:rule pattern="d12e1239">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:constraintSpec[ @mode eq 'change']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(child::*)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">child::*</xsl:attribute>
                     <svrl:text>This constraintSpec element has a mode= of "change", but does not have any child elements. Specify child elements, or change the mode= to "delete".</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1239')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:constraintSpec[ @mode = ('add','replace') ]"
                 priority="39"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1248']">
            <schxslt:rule pattern="d12e1248">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:constraintSpec[ @mode = ('add','replace') ]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:constraintSpec[ @mode = ('add','replace') ]</xsl:attribute>
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
            <schxslt:rule pattern="d12e1248">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:constraintSpec[ @mode = ('add','replace') ]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(child::tei:constraint)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">child::tei:constraint</xsl:attribute>
                     <svrl:text>This constraintSpec element has a mode= of "<xsl:value-of select="@mode"/>", but does not have a child 'constraint' element. Use a child 'constraint' element or change the mode= to "delete" or "change".</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1248')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:constraintSpec" priority="38" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1259']">
            <schxslt:rule pattern="d12e1259">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:constraintSpec" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:constraintSpec</xsl:attribute>
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
            <schxslt:rule pattern="d12e1259">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:constraintSpec</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="tei:constraint/sch1x:* and @scheme = ('isoschematron','schematron')">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">tei:constraint/sch1x:* and @scheme = ('isoschematron','schematron')</xsl:attribute>
                     <svrl:text>Rules in the Schematron 1.* language must be inside a constraintSpec with a value other than 'schematron' or 'isoschematron' on the scheme attribute</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1259')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:constraintSpec[ @mode = ('add','replace') or not( @mode ) ]"
                 priority="37"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1268']">
            <schxslt:rule pattern="d12e1268">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:constraintSpec[ @mode = ('add','replace') or not( @mode ) ]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:constraintSpec[ @mode = ('add','replace') or not( @mode ) ]</xsl:attribute>
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
            <schxslt:rule pattern="d12e1268">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:constraintSpec[ @mode = ('add','replace') or not( @mode ) ]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="tei:constraint/sch:* and not( @scheme eq 'schematron')">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">tei:constraint/sch:* and not( @scheme eq 'schematron')</xsl:attribute>
                     <svrl:text>Rules in the ISO Schematron language must be inside a constraintSpec with the value 'schematron' on the scheme attribute</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1268')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="(tei:constraintSpec|tei:constraintDecl)[ @scheme eq 'schematron'][ .//sch:assert | .//sch:report ]"
                 priority="36"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="assertsHaveContext"
                    select="for $a in .//sch:assert return exists( $a/ancestor::sch:rule/@context )"/>
      <xsl:variable name="reportsHaveContext"
                    select="for $r in .//sch:report return exists( $r/ancestor::sch:rule/@context )"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1278']">
            <schxslt:rule pattern="d12e1278">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "(tei:constraintSpec|tei:constraintDecl)[ @scheme eq 'schematron'][ .//sch:assert | .//sch:report ]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">(tei:constraintSpec|tei:constraintDecl)[ @scheme eq 'schematron'][ .//sch:assert | .//sch:report ]</xsl:attribute>
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
            <schxslt:rule pattern="d12e1278">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">(tei:constraintSpec|tei:constraintDecl)[ @scheme eq 'schematron'][ .//sch:assert | .//sch:report ]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="( $assertsHaveContext, $reportsHaveContext ) = false()">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">( $assertsHaveContext, $reportsHaveContext ) = false()</xsl:attribute>
                     <svrl:text>An &lt;sch:assert&gt; or &lt;sch:report&gt; element must be a descendant of an &lt;sch:rule&gt; that has a @context; one or more inside this <xsl:value-of select="local-name(.)"/> are not.</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1278')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:constraintSpec[ @mode eq 'add' or not( @mode ) ]"
                 priority="35"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:variable name="myIdent" select="normalize-space(@ident)"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1293']">
            <schxslt:rule pattern="d12e1293">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:constraintSpec[ @mode eq 'add' or not( @mode ) ]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:constraintSpec[ @mode eq 'add' or not( @mode ) ]</xsl:attribute>
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
            <schxslt:rule pattern="d12e1293">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:constraintSpec[ @mode eq 'add' or not( @mode ) ]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="preceding::tei:constraintSpec[ normalize-space(@ident) eq $myIdent ]">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">preceding::tei:constraintSpec[ normalize-space(@ident) eq $myIdent ]</xsl:attribute>
                     <svrl:text> The @ident of 'constraintSpec' should be unique; this one (<xsl:value-of select="$myIdent"/>) is the same as that of a previous 'constraintSpec'.</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1293')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:constraintSpec[ @mode = ('add','replace')  or  not( @mode ) ]"
                 priority="34"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1306']">
            <schxslt:rule pattern="d12e1306">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:constraintSpec[ @mode = ('add','replace') or not( @mode ) ]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:constraintSpec[ @mode = ('add','replace')  or  not( @mode ) ]</xsl:attribute>
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
            <schxslt:rule pattern="d12e1306">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:constraintSpec[ @mode = ('add','replace')  or  not( @mode ) ]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@scheme)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">@scheme</xsl:attribute>
                     <svrl:text>The @scheme attribute of &lt;constraintSpec&gt; is required when the @mode is <xsl:value-of select="if (@mode) then concat('&#34;',@mode,'&#34;') else 'not specified'"/> (here on "<xsl:value-of select="@ident"/>")</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1306')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:attDef" priority="33" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1319']">
            <schxslt:rule pattern="d12e1319">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:attDef" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:attDef</xsl:attribute>
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
            <schxslt:rule pattern="d12e1319">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:attDef</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(ancestor::teix:egXML[ @valid eq 'feasible']                        or @mode eq 'change'                        or @mode eq 'delete'                        or tei:datatype                        or tei:valList[ @type eq 'closed'])">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">ancestor::teix:egXML[ @valid eq 'feasible']                        or @mode eq 'change'                        or @mode eq 'delete'                        or tei:datatype                        or tei:valList[ @type eq 'closed']</xsl:attribute>
                     <svrl:text> Attribute: the definition of the @<xsl:value-of select="@ident"/> attribute in the <xsl:value-of select="ancestor::*[@ident][1]/@ident"/>
                        <xsl:value-of select="' '"/>
                        <xsl:value-of select="local-name(ancestor::*[@ident][1])"/> should have a closed valList or a datatype</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1319')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:attDef[@usage eq 'req']" priority="32" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1336']">
            <schxslt:rule pattern="d12e1336">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:attDef[@usage eq 'req']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:attDef[@usage eq 'req']</xsl:attribute>
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
            <schxslt:rule pattern="d12e1336">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:attDef[@usage eq 'req']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="tei:defaultVal">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">tei:defaultVal</xsl:attribute>
                     <svrl:text>Since the @<xsl:value-of select="@ident"/> attribute is required, it will always be specified. Thus the default value (of "<xsl:value-of select="normalize-space(tei:defaultVal)"/>") will never be used. Either change the definition of the attribute so it is not required ("rec" or "opt"), or remove the defaultVal element.</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1336')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:attDef[     tei:defaultVal                                      and tei:valList[ @type eq 'closed']                                      and tei:datatype[ @maxOccurs &gt; 1  or  @minOccurs &gt; 1  or  @maxOccurs eq 'unbounded']                                    ]"
                 priority="31"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1349']">
            <schxslt:rule pattern="d12e1349">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:attDef[ tei:defaultVal and tei:valList[ @type eq 'closed'] and tei:datatype[ @maxOccurs &gt; 1 or @minOccurs &gt; 1 or @maxOccurs eq 'unbounded'] ]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:attDef[     tei:defaultVal                                      and tei:valList[ @type eq 'closed']                                      and tei:datatype[ @maxOccurs &gt; 1  or  @minOccurs &gt; 1  or  @maxOccurs eq 'unbounded']                                    ]</xsl:attribute>
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
            <schxslt:rule pattern="d12e1349">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:attDef[     tei:defaultVal                                      and tei:valList[ @type eq 'closed']                                      and tei:datatype[ @maxOccurs &gt; 1  or  @minOccurs &gt; 1  or  @maxOccurs eq 'unbounded']                                    ]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(tokenize(normalize-space(tei:defaultVal),' ') = tei:valList/tei:valItem/@ident)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">tokenize(normalize-space(tei:defaultVal),' ') = tei:valList/tei:valItem/@ident</xsl:attribute>
                     <svrl:text>In the <xsl:value-of select="local-name(ancestor::*[@ident][1])"/> defining <xsl:value-of select="ancestor::*[@ident][1]/@ident"/> the default value of the @<xsl:value-of select="@ident"/> attribute is not among the closed list of possible values</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1349')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:attDef[     tei:defaultVal                                      and tei:valList[ @type eq 'closed']                                      and tei:datatype[                                             not(@maxOccurs)                                         or  ( if ( @maxOccurs castable as xs:integer ) then ( @maxOccurs cast as xs:integer eq 1 ) else false() )                                                      ]                                    ]"
                 priority="30"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1365']">
            <schxslt:rule pattern="d12e1365">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:attDef[ tei:defaultVal and tei:valList[ @type eq 'closed'] and tei:datatype[ not(@maxOccurs) or ( if ( @maxOccurs castable as xs:integer ) then ( @maxOccurs cast as xs:integer eq 1 ) else false() ) ] ]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:attDef[     tei:defaultVal                                      and tei:valList[ @type eq 'closed']                                      and tei:datatype[                                             not(@maxOccurs)                                         or  ( if ( @maxOccurs castable as xs:integer ) then ( @maxOccurs cast as xs:integer eq 1 ) else false() )                                                      ]                                    ]</xsl:attribute>
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
            <schxslt:rule pattern="d12e1365">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:attDef[     tei:defaultVal                                      and tei:valList[ @type eq 'closed']                                      and tei:datatype[                                             not(@maxOccurs)                                         or  ( if ( @maxOccurs castable as xs:integer ) then ( @maxOccurs cast as xs:integer eq 1 ) else false() )                                                      ]                                    ]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(string(tei:defaultVal) = tei:valList/tei:valItem/@ident)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">string(tei:defaultVal) = tei:valList/tei:valItem/@ident</xsl:attribute>
                     <svrl:text>In the <xsl:value-of select="local-name(ancestor::*[@ident][1])"/> defining <xsl:value-of select="ancestor::*[@ident][1]/@ident"/> the default value of the @<xsl:value-of select="@ident"/> attribute is not among the closed list of possible values</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1365')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:dataRef[tei:dataFacet]" priority="29" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1380']">
            <schxslt:rule pattern="d12e1380">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:dataRef[tei:dataFacet]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:dataRef[tei:dataFacet]</xsl:attribute>
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
            <schxslt:rule pattern="d12e1380">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:dataRef[tei:dataFacet]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@name)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      role="nonfatal">
                     <xsl:attribute name="test">@name</xsl:attribute>
                     <svrl:text>Data facets can only be specified for references to datatypes specified by XML Schema Part 2: Datatypes Second Edition — that is, for there to be a 'dataFacet' child there must be a @name attribute.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="@restriction">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}"
                                          role="nonfatal">
                     <xsl:attribute name="test">@restriction</xsl:attribute>
                     <svrl:text>Data facets and restrictions cannot both be expressed on the same data reference — that is, the @restriction attribute cannot be used when a 'dataFacet' element is present.</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1380')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:dataRef[@restriction]" priority="28" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1392']">
            <schxslt:rule pattern="d12e1392">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:dataRef[@restriction]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:dataRef[@restriction]</xsl:attribute>
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
            <schxslt:rule pattern="d12e1392">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:dataRef[@restriction]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@name)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      role="nonfatal">
                     <xsl:attribute name="test">@name</xsl:attribute>
                     <svrl:text>Restrictions can only be specified for references to datatypes specified by XML Schema Part 2: Datatypes Second Edition — that is, for there to be a @restriction attribute there must be a @name attribute, too.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1392')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="*[ @mode eq 'delete' ]" priority="27" mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1401']">
            <schxslt:rule pattern="d12e1401">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "*[ @mode eq 'delete' ]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">*[ @mode eq 'delete' ]</xsl:attribute>
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
            <schxslt:rule pattern="d12e1401">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">*[ @mode eq 'delete' ]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="child::*">
                  <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                          location="{schxslt:location(.)}">
                     <xsl:attribute name="test">child::*</xsl:attribute>
                     <svrl:text>The specification element ＜<xsl:value-of select="name()"/>＞ has both a mode= of "delete" and child elements, which is incongruous</svrl:text>
                  </svrl:successful-report>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1401')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="                       tei:valList[ @mode = ('add','change','replace') ]                     | tei:moduleSpec[ @mode = ('add','change','replace') ]                     | tei:schemaSpec[ @mode = ('add','change','replace') ]                     | tei:elementSpec[ @mode = ('add','change','replace') ]                     | tei:classSpec[ @mode = ('add','change','replace') ]                     | tei:macroSpec[ @mode = ('add','change','replace') ]                     | tei:constraintSpec[ @mode = ('add','change','replace') ]                     | tei:attDef[ @mode = ('add','change','replace') ]                     | tei:classes[ @mode = ('add','change','replace') ]"
                 priority="26"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1412']">
            <schxslt:rule pattern="d12e1412">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context " tei:valList[ @mode = ('add','change','replace') ] | tei:moduleSpec[ @mode = ('add','change','replace') ] | tei:schemaSpec[ @mode = ('add','change','replace') ] | tei:elementSpec[ @mode = ('add','change','replace') ] | tei:classSpec[ @mode = ('add','change','replace') ] | tei:macroSpec[ @mode = ('add','change','replace') ] | tei:constraintSpec[ @mode = ('add','change','replace') ] | tei:attDef[ @mode = ('add','change','replace') ] | tei:classes[ @mode = ('add','change','replace') ]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">                       tei:valList[ @mode = ('add','change','replace') ]                     | tei:moduleSpec[ @mode = ('add','change','replace') ]                     | tei:schemaSpec[ @mode = ('add','change','replace') ]                     | tei:elementSpec[ @mode = ('add','change','replace') ]                     | tei:classSpec[ @mode = ('add','change','replace') ]                     | tei:macroSpec[ @mode = ('add','change','replace') ]                     | tei:constraintSpec[ @mode = ('add','change','replace') ]                     | tei:attDef[ @mode = ('add','change','replace') ]                     | tei:classes[ @mode = ('add','change','replace') ]</xsl:attribute>
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
            <schxslt:rule pattern="d12e1412">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">                       tei:valList[ @mode = ('add','change','replace') ]                     | tei:moduleSpec[ @mode = ('add','change','replace') ]                     | tei:schemaSpec[ @mode = ('add','change','replace') ]                     | tei:elementSpec[ @mode = ('add','change','replace') ]                     | tei:classSpec[ @mode = ('add','change','replace') ]                     | tei:macroSpec[ @mode = ('add','change','replace') ]                     | tei:constraintSpec[ @mode = ('add','change','replace') ]                     | tei:attDef[ @mode = ('add','change','replace') ]                     | tei:classes[ @mode = ('add','change','replace') ]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(child::* | (@* except (@mode, @ident)))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">child::* | (@* except (@mode, @ident))</xsl:attribute>
                     <svrl:text>The specification element ＜<xsl:value-of select="name()"/>＞ has a mode= of "<xsl:value-of select="@mode"/>", but does not have any child elements or schema-changing attributes, which is incongruous</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1412')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match=" tei:classRef[@source]                                      |tei:dataRef[@source]                                      |tei:elementRef[@source]                                      |tei:macroRef[@source]                                      |tei:moduleRef[@source]                                      |tei:schemaSpec[@source]"
                 priority="25"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1425']">
            <schxslt:rule pattern="d12e1425">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context " tei:classRef[@source] |tei:dataRef[@source] |tei:elementRef[@source] |tei:macroRef[@source] |tei:moduleRef[@source] |tei:schemaSpec[@source]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context"> tei:classRef[@source]                                      |tei:dataRef[@source]                                      |tei:elementRef[@source]                                      |tei:macroRef[@source]                                      |tei:moduleRef[@source]                                      |tei:schemaSpec[@source]</xsl:attribute>
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
            <schxslt:rule pattern="d12e1425">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context"> tei:classRef[@source]                                      |tei:dataRef[@source]                                      |tei:elementRef[@source]                                      |tei:macroRef[@source]                                      |tei:moduleRef[@source]                                      |tei:schemaSpec[@source]</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(matches(normalize-space(@source), '^tei:([0-9]+\.[0-9]+\.[0-9]+|current)$'))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      role="information">
                     <xsl:attribute name="test">matches(normalize-space(@source), '^tei:([0-9]+\.[0-9]+\.[0-9]+|current)$')</xsl:attribute>
                     <svrl:text>The @source attribute of ＜<xsl:value-of select="name()"/>＞ is not in the recommended format, which is either "tei:current" or "tei:x.y.z", where x.y.z is a version number.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1425')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:param[parent::tei:model/@behaviour='alternate']"
                 priority="24"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1443']">
            <schxslt:rule pattern="d12e1443">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:param[parent::tei:model/@behaviour='alternate']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='alternate']</xsl:attribute>
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
            <schxslt:rule pattern="d12e1443">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='alternate']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@name='default'   or  @name='alternate')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      role="error">
                     <xsl:attribute name="test">@name='default'   or  @name='alternate'</xsl:attribute>
                     <svrl:text>
          Parameter name '<xsl:value-of select="@name"/>'  (on <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>) not allowed.
          Must  be  drawn from the list: default, alternate</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1443')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:param[parent::tei:model/@behaviour='anchor']"
                 priority="23"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1456']">
            <schxslt:rule pattern="d12e1456">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:param[parent::tei:model/@behaviour='anchor']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='anchor']</xsl:attribute>
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
            <schxslt:rule pattern="d12e1456">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='anchor']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@name='id')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      role="error">
                     <xsl:attribute name="test">@name='id'</xsl:attribute>
                     <svrl:text>
          Parameter name '<xsl:value-of select="@name"/>'  (on <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>) not allowed.
          Must  be  drawn from the list: id</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1456')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:param[parent::tei:model/@behaviour='block']"
                 priority="22"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1469']">
            <schxslt:rule pattern="d12e1469">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:param[parent::tei:model/@behaviour='block']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='block']</xsl:attribute>
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
            <schxslt:rule pattern="d12e1469">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='block']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@name='content')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      role="error">
                     <xsl:attribute name="test">@name='content'</xsl:attribute>
                     <svrl:text>
          Parameter name '<xsl:value-of select="@name"/>'  (on <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>) not allowed.
          Must  be  drawn from the list: content</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1469')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:param[parent::tei:model/@behaviour='body']"
                 priority="21"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1482']">
            <schxslt:rule pattern="d12e1482">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:param[parent::tei:model/@behaviour='body']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='body']</xsl:attribute>
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
            <schxslt:rule pattern="d12e1482">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='body']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@name='content')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      role="error">
                     <xsl:attribute name="test">@name='content'</xsl:attribute>
                     <svrl:text>
          Parameter name '<xsl:value-of select="@name"/>'  (on <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>) not allowed.
          Must  be  drawn from the list: content</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1482')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:param[parent::tei:model/@behaviour='break']"
                 priority="20"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1495']">
            <schxslt:rule pattern="d12e1495">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:param[parent::tei:model/@behaviour='break']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='break']</xsl:attribute>
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
            <schxslt:rule pattern="d12e1495">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='break']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@name='type'   or  @name='label')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      role="error">
                     <xsl:attribute name="test">@name='type'   or  @name='label'</xsl:attribute>
                     <svrl:text>
          Parameter name '<xsl:value-of select="@name"/>'  (on <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>) not allowed.
          Must  be  drawn from the list: type, label</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1495')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:param[parent::tei:model/@behaviour='cell']"
                 priority="19"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1508']">
            <schxslt:rule pattern="d12e1508">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:param[parent::tei:model/@behaviour='cell']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='cell']</xsl:attribute>
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
            <schxslt:rule pattern="d12e1508">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='cell']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@name='content')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      role="error">
                     <xsl:attribute name="test">@name='content'</xsl:attribute>
                     <svrl:text>
          Parameter name '<xsl:value-of select="@name"/>'  (on <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>) not allowed.
          Must  be  drawn from the list: content</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1508')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:param[parent::tei:model/@behaviour='cit']"
                 priority="18"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1522']">
            <schxslt:rule pattern="d12e1522">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:param[parent::tei:model/@behaviour='cit']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='cit']</xsl:attribute>
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
            <schxslt:rule pattern="d12e1522">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='cit']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@name='content'   or  @name='source')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      role="error">
                     <xsl:attribute name="test">@name='content'   or  @name='source'</xsl:attribute>
                     <svrl:text>
          Parameter name '<xsl:value-of select="@name"/>'  (on <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>) not allowed.
          Must  be  drawn from the list: content, source</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1522')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:param[parent::tei:model/@behaviour='document']"
                 priority="17"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1535']">
            <schxslt:rule pattern="d12e1535">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:param[parent::tei:model/@behaviour='document']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='document']</xsl:attribute>
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
            <schxslt:rule pattern="d12e1535">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='document']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@name='content')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      role="error">
                     <xsl:attribute name="test">@name='content'</xsl:attribute>
                     <svrl:text>
          Parameter name '<xsl:value-of select="@name"/>'  (on <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>) not allowed.
          Must  be  drawn from the list: content</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1535')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:param[parent::tei:model/@behaviour='figure']"
                 priority="16"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1548']">
            <schxslt:rule pattern="d12e1548">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:param[parent::tei:model/@behaviour='figure']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='figure']</xsl:attribute>
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
            <schxslt:rule pattern="d12e1548">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='figure']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@name='title')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      role="error">
                     <xsl:attribute name="test">@name='title'</xsl:attribute>
                     <svrl:text>
          Parameter name '<xsl:value-of select="@name"/>'  (on <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>) not allowed.
          Must  be  drawn from the list: title</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1548')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:param[parent::tei:model/@behaviour='glyph']"
                 priority="15"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1561']">
            <schxslt:rule pattern="d12e1561">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:param[parent::tei:model/@behaviour='glyph']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='glyph']</xsl:attribute>
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
            <schxslt:rule pattern="d12e1561">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='glyph']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@name='uri')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      role="error">
                     <xsl:attribute name="test">@name='uri'</xsl:attribute>
                     <svrl:text>
          Parameter name '<xsl:value-of select="@name"/>'  (on <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>) not allowed.
          Must  be  drawn from the list: uri</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1561')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:param[parent::tei:model/@behaviour='graphic']"
                 priority="14"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1574']">
            <schxslt:rule pattern="d12e1574">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:param[parent::tei:model/@behaviour='graphic']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='graphic']</xsl:attribute>
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
            <schxslt:rule pattern="d12e1574">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='graphic']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@name='url'   or  @name='width'   or  @name='height'   or  @name='scale'   or  @name='title')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      role="error">
                     <xsl:attribute name="test">@name='url'   or  @name='width'   or  @name='height'   or  @name='scale'   or  @name='title'</xsl:attribute>
                     <svrl:text>
          Parameter name '<xsl:value-of select="@name"/>'  (on <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>) not allowed.
          Must  be  drawn from the list: url, width, height, scale, title</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1574')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:param[parent::tei:model/@behaviour='heading']"
                 priority="13"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1587']">
            <schxslt:rule pattern="d12e1587">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:param[parent::tei:model/@behaviour='heading']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='heading']</xsl:attribute>
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
            <schxslt:rule pattern="d12e1587">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='heading']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@name='content'   or  @name='level')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      role="error">
                     <xsl:attribute name="test">@name='content'   or  @name='level'</xsl:attribute>
                     <svrl:text>
          Parameter name '<xsl:value-of select="@name"/>'  (on <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>) not allowed.
          Must  be  drawn from the list: content, level</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1587')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:param[parent::tei:model/@behaviour='index']"
                 priority="12"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1601']">
            <schxslt:rule pattern="d12e1601">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:param[parent::tei:model/@behaviour='index']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='index']</xsl:attribute>
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
            <schxslt:rule pattern="d12e1601">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='index']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@name='type')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      role="error">
                     <xsl:attribute name="test">@name='type'</xsl:attribute>
                     <svrl:text>
          Parameter name '<xsl:value-of select="@name"/>'  (on <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>) not allowed.
          Must  be  drawn from the list: type</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1601')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:param[parent::tei:model/@behaviour='inline']"
                 priority="11"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1614']">
            <schxslt:rule pattern="d12e1614">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:param[parent::tei:model/@behaviour='inline']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='inline']</xsl:attribute>
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
            <schxslt:rule pattern="d12e1614">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='inline']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@name='content'   or  @name='label')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      role="error">
                     <xsl:attribute name="test">@name='content'   or  @name='label'</xsl:attribute>
                     <svrl:text>
          Parameter name '<xsl:value-of select="@name"/>'  (on <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>) not allowed.
          Must  be  drawn from the list: content, label</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1614')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:param[parent::tei:model/@behaviour='link']"
                 priority="10"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1627']">
            <schxslt:rule pattern="d12e1627">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:param[parent::tei:model/@behaviour='link']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='link']</xsl:attribute>
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
            <schxslt:rule pattern="d12e1627">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='link']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@name='content'   or  @name='uri')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      role="error">
                     <xsl:attribute name="test">@name='content'   or  @name='uri'</xsl:attribute>
                     <svrl:text>
          Parameter name '<xsl:value-of select="@name"/>'  (on <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>) not allowed.
          Must  be  drawn from the list: content, uri</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1627')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:param[parent::tei:model/@behaviour='list']"
                 priority="9"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1640']">
            <schxslt:rule pattern="d12e1640">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:param[parent::tei:model/@behaviour='list']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='list']</xsl:attribute>
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
            <schxslt:rule pattern="d12e1640">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='list']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@name='content')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      role="error">
                     <xsl:attribute name="test">@name='content'</xsl:attribute>
                     <svrl:text>
          Parameter name '<xsl:value-of select="@name"/>'  (on <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>) not allowed.
          Must  be  drawn from the list: content</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1640')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:param[parent::tei:model/@behaviour='listItem']"
                 priority="8"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1653']">
            <schxslt:rule pattern="d12e1653">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:param[parent::tei:model/@behaviour='listItem']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='listItem']</xsl:attribute>
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
            <schxslt:rule pattern="d12e1653">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='listItem']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@name='content')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      role="error">
                     <xsl:attribute name="test">@name='content'</xsl:attribute>
                     <svrl:text>
          Parameter name '<xsl:value-of select="@name"/>'  (on <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>) not allowed.
          Must  be  drawn from the list: content</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1653')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:param[parent::tei:model/@behaviour='metadata']"
                 priority="7"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1666']">
            <schxslt:rule pattern="d12e1666">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:param[parent::tei:model/@behaviour='metadata']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='metadata']</xsl:attribute>
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
            <schxslt:rule pattern="d12e1666">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='metadata']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@name='content')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      role="error">
                     <xsl:attribute name="test">@name='content'</xsl:attribute>
                     <svrl:text>
          Parameter name '<xsl:value-of select="@name"/>'  (on <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>) not allowed.
          Must  be  drawn from the list: content</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1666')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:param[parent::tei:model/@behaviour='note']"
                 priority="6"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1680']">
            <schxslt:rule pattern="d12e1680">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:param[parent::tei:model/@behaviour='note']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='note']</xsl:attribute>
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
            <schxslt:rule pattern="d12e1680">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='note']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@name='content'   or  @name='place'   or  @name='label')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      role="error">
                     <xsl:attribute name="test">@name='content'   or  @name='place'   or  @name='label'</xsl:attribute>
                     <svrl:text>
          Parameter name '<xsl:value-of select="@name"/>'  (on <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>) not allowed.
          Must  be  drawn from the list: content, place, label</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1680')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:param[parent::tei:model/@behaviour='paragraph']"
                 priority="5"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1693']">
            <schxslt:rule pattern="d12e1693">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:param[parent::tei:model/@behaviour='paragraph']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='paragraph']</xsl:attribute>
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
            <schxslt:rule pattern="d12e1693">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='paragraph']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@name='content')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      role="error">
                     <xsl:attribute name="test">@name='content'</xsl:attribute>
                     <svrl:text>
          Parameter name '<xsl:value-of select="@name"/>'  (on <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>) not allowed.
          Must  be  drawn from the list: content</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1693')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:param[parent::tei:model/@behaviour='row']"
                 priority="4"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1706']">
            <schxslt:rule pattern="d12e1706">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:param[parent::tei:model/@behaviour='row']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='row']</xsl:attribute>
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
            <schxslt:rule pattern="d12e1706">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='row']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@name='content')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      role="error">
                     <xsl:attribute name="test">@name='content'</xsl:attribute>
                     <svrl:text>
          Parameter name '<xsl:value-of select="@name"/>'  (on <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>) not allowed.
          Must  be  drawn from the list: content</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1706')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:param[parent::tei:model/@behaviour='section']"
                 priority="3"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1719']">
            <schxslt:rule pattern="d12e1719">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:param[parent::tei:model/@behaviour='section']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='section']</xsl:attribute>
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
            <schxslt:rule pattern="d12e1719">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='section']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@name='content')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      role="error">
                     <xsl:attribute name="test">@name='content'</xsl:attribute>
                     <svrl:text>
          Parameter name '<xsl:value-of select="@name"/>'  (on <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>) not allowed.
          Must  be  drawn from the list: content</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1719')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:param[parent::tei:model/@behaviour='table']"
                 priority="2"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1732']">
            <schxslt:rule pattern="d12e1732">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:param[parent::tei:model/@behaviour='table']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='table']</xsl:attribute>
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
            <schxslt:rule pattern="d12e1732">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='table']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@name='content')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      role="error">
                     <xsl:attribute name="test">@name='content'</xsl:attribute>
                     <svrl:text>
          Parameter name '<xsl:value-of select="@name"/>'  (on <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>) not allowed.
          Must  be  drawn from the list: content</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1732')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:param[parent::tei:model/@behaviour='text']"
                 priority="1"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1745']">
            <schxslt:rule pattern="d12e1745">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:param[parent::tei:model/@behaviour='text']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='text']</xsl:attribute>
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
            <schxslt:rule pattern="d12e1745">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='text']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@name='content')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      role="error">
                     <xsl:attribute name="test">@name='content'</xsl:attribute>
                     <svrl:text>
          Parameter name '<xsl:value-of select="@name"/>'  (on <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>) not allowed.
          Must  be  drawn from the list: content</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1745')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="tei:param[parent::tei:model/@behaviour='title']"
                 priority="0"
                 mode="d12e47">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd12e1759']">
            <schxslt:rule pattern="d12e1759">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "tei:param[parent::tei:model/@behaviour='title']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='title']</xsl:attribute>
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
            <schxslt:rule pattern="d12e1759">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">tei:param[parent::tei:model/@behaviour='title']</xsl:attribute>
                  <xsl:variable name="documentUri" as="xs:anyURI?" select="document-uri()"/>
                  <xsl:if test="exists($documentUri)">
                     <xsl:attribute name="document" select="$documentUri"/>
                  </xsl:if>
               </svrl:fired-rule>
               <xsl:if test="not(@name='content')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      location="{schxslt:location(.)}"
                                      role="error">
                     <xsl:attribute name="test">@name='content'</xsl:attribute>
                     <svrl:text>
          Parameter name '<xsl:value-of select="@name"/>'  (on <xsl:value-of select="ancestor::tei:elementSpec/@ident"/>) not allowed.
          Must  be  drawn from the list: content</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                               as="xs:string*"
                               select="($schxslt:patterns-matched, 'd12e1759')"/>
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
