<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	exclude-result-prefixes="xsl">
  <xsl:output
	method="xml"
	version="1.0"
	encoding="UTF-8"
	doctype-system="http://docbook.org/xml/4.2/docbookx.dtd"
	doctype-public="-//OASIS//DTD DocBook XML V4.2//EN"/>

  <xsl:template match="/">
    <article>
      <xsl:apply-templates/>
    </article>
  </xsl:template>

  <!-- Zkopirovani odstavcu z jednoho souboru. -->
  <xsl:template name="copy-part">
    <xsl:for-each select="node()">
      <xsl:choose>
	<xsl:when test="name(.)='para'">
	  <xsl:call-template name="templ-copy-para"/>
	</xsl:when>

	<xsl:otherwise>
	  <!-- <xsl:copy-of select="."/> -->
	</xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="/article">
    <xsl:for-each select="node()">
      <xsl:choose>
	<xsl:when test="name(.)='part'">
	  <xsl:call-template name="copy-part"/>
	</xsl:when>

	<!-- Slovnik do vstupniho dokumentu pro DocBook nepatri. -->
	<xsl:when test="name(.)='slovnik'"/>

	<xsl:otherwise>
	  <!-- Napr. 'articleinfo' -->
	  <xsl:copy-of select="."/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="templ-copy-para">
    <para>
      <xsl:for-each select="node()">
	<xsl:choose>
	  <xsl:when test="name(.)='preklad'">
	    <xsl:variable name="id" select="@id"/>
	    <xsl:variable name="pad" select="@pad"/>
	    <xsl:variable name="preklad"
			  select="/article/slovnik/termin[@id=$id]/preklad[@pad=$pad]/text()"/>

	    <emphasis>
	    <!-- Prvni pismeno muze byt velke... -->
	    <xsl:choose>
	      <xsl:when test="@velke">
		<xsl:value-of select="substring(/article/slovnik/termin[@id=$id]/@velke, 1, 1)"/>
	      </xsl:when>

	      <xsl:otherwise>
		<xsl:value-of select="substring($preklad, 1, 1)"/>
	      </xsl:otherwise>
	    </xsl:choose>

	    <!-- Zbyvajici cast -->
	    <xsl:value-of select="substring($preklad, 2)"/>

	    </emphasis>
	  </xsl:when>

	  <!-- "preklad" muze byt i vnoreny... -->
	  <xsl:when test="name(.)='blockquote'">
	    <blockquote>
	      <xsl:call-template name="copy-part"/>
	    </blockquote>
	  </xsl:when>

	  <xsl:otherwise>
	    <xsl:copy-of select="."/>
	  </xsl:otherwise>
	</xsl:choose>

      </xsl:for-each>
    </para>
  </xsl:template>

</xsl:stylesheet>
