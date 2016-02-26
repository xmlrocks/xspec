<?xml version="1.0" encoding="UTF-8"?>
<!--
# =============================================================================
# Copyright © 2013 Typéfi Systems. All rights reserved.
#
# Unless required by applicable law or agreed to in writing, software
# is distributed on an "as is" basis, without warranties or conditions of any
# kind, either express or implied.
# =============================================================================
-->
<!-- Translates xspec XML reports to JUnit 4 reports, compatible with Jenkins. -->
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:x="http://www.jenitennison.com/xslt/xspec"
                xmlns:f="http://www.typefi.com/xslt-functions"
                exclude-result-prefixes="xs x f">


    <xsl:output indent="yes"/>


    <xsl:param name="suite" as="xs:string" required="yes"/>


    <xsl:template match="x:report" priority="10">
        <testsuite name="{$suite}"
                   errors="0"
                   failures="{count(x:test[@successful eq 'false'])}"
                   skipped="{count(x:scenario[@pending eq 'yes'])}"
                   tests="{count(x:scenario)}"
                   time="0.0"
                   timestamp="{@date}">
            <xsl:apply-templates select="x:scenario"/>
        </testsuite>
    </xsl:template>


    <xsl:template match="x:scenario" priority="10">
        <testcase name="{x:label}">
          <xsl:apply-templates select="@pending[. eq 'yes'], x:test"/>
        </testcase>
    </xsl:template>


    <xsl:template match="x:scenario/@pending[. eq 'yes']" priority="10">
        <skipped/>
    </xsl:template>


    <xsl:template match="x:test[@successful eq 'false']" priority="10">
        <failure>
            <xsl:apply-templates select="x:label"/>
            <xsl:apply-templates select="x:expect"/>
        </failure>
    </xsl:template>


    <xsl:template match="x:test/x:label" priority="10">
        <xsl:attribute name="message">
            <xsl:apply-templates/>
        </xsl:attribute>
    </xsl:template>


    <xsl:template match="x:expect" priority="10">
        <xsl:text>Result doesn't match the expectation: </xsl:text>
        <xsl:copy-of select="node()" copy-namespaces="no"/>
    </xsl:template>


    <xsl:template match="text()" priority="10">
        <xsl:value-of select="."/>
    </xsl:template>


    <xsl:template match="node()"/>

</xsl:stylesheet>
