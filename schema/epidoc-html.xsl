<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:teix="http://www.tei-c.org/ns/Examples"
    xmlns:s="http://www.ascc.net/xml/schematron" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:t="http://www.thaiopensource.com/ns/annotations"
    xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
    xmlns:rng="http://relaxng.org/ns/structure/1.0"
    exclude-result-prefixes="tei t a rng s teix" 
    version="2.0">
  
  <xsl:import href="/usr/share/xml/tei/stylesheet/odds2/odd2html.xsl"/>
  
  <xsl:output encoding="utf-8" method="xml" doctype-public="-//W3C//DTD XHTML 1.1//EN"/>
  <xsl:param name="STDOUT">true</xsl:param>
  <xsl:param name="splitLevel">-1</xsl:param>
  <xsl:param name="autoToc">true</xsl:param>
  <xsl:param name="cssFile">epidoc.css</xsl:param>
  <xsl:param name="cssSecondaryFile">epidoc-odd.css</xsl:param>
  <xsl:param name="TEIC">true</xsl:param>
  <xsl:param name="forceWrap">false</xsl:param>

</xsl:stylesheet>



