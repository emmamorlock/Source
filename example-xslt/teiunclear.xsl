<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: teiunclear.xsl 1256 2008-07-15 16:17:16Z gbodard $ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:template match="unclear">
    <xsl:param name="text-content">
      <xsl:choose>
        <xsl:when test="ancestor::orig[not(ancestor::choice)]">
          <xsl:value-of select="translate(., $all-grc, $grc-upper-strip)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    
    <xsl:choose>
      <xsl:when test="starts-with($leiden-style, 'edh')">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="$edition-type = 'diplomatic'">
        <!-- Calculates the number of middots to output -->
        <xsl:variable name="unclear-length">
          <!-- collects all children text together -->
          <xsl:variable name="un-len-text">
            <xsl:for-each select="text()">
              <xsl:value-of select="."/>
            </xsl:for-each>
          </xsl:variable>
          <!-- Outputs an 'a' per child <g> -->
          <xsl:variable name="un-len-g">
            <xsl:for-each select="g">
              <xsl:text>a</xsl:text>
            </xsl:for-each>
          </xsl:variable>
          <xsl:value-of select="string-length($un-len-text) + string-length($un-len-g)"/>
        </xsl:variable>
        
        <xsl:call-template name="middot">
          <xsl:with-param name="unc-len" select="$unclear-length"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="g">
            <xsl:apply-templates/>
            <!-- find some way to indicate the unclear status of this word -->
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="subpunct">
              <xsl:with-param name="unc-len" select="string-length($text-content)"/>
              <xsl:with-param name="abs-len" select="string-length($text-content)+1"/>
              <xsl:with-param name="text-content" select="$text-content"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="middot">
    <xsl:param name="unc-len"/>
    <xsl:variable name="dot-type">
      <xsl:choose>
        <xsl:when test="$leiden-style = 'ddbdp'">
            <xsl:text>&#xa0;&#x0323;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
      <xsl:text>&#xb7;</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      
    </xsl:variable>

    <xsl:if test="not($unc-len = 0)">
      <xsl:value-of select="$dot-type"/>
      <xsl:call-template name="middot">
        <xsl:with-param name="unc-len" select="$unc-len - 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="subpunct">
    <xsl:param name="abs-len"/>
    <xsl:param name="unc-len"/>
    <xsl:param name="text-content"/>
    <xsl:if test="$unc-len!=0">
      <xsl:value-of select="substring($text-content, number($abs-len - $unc-len),1)"/>
      <xsl:text>&#x0323;</xsl:text>
      <xsl:call-template name="subpunct">
        <xsl:with-param name="unc-len" select="$unc-len - 1"/>
        <xsl:with-param name="abs-len" select="string-length($text-content)+1"/>
        <xsl:with-param name="text-content" select="$text-content"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
