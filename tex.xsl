<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	exclude-result-prefixes="xsl">
  <xsl:output
	method="text"
	encoding="UTF-8"
	doctype-system="http://docbook.org/xml/4.2/docbookx.dtd"
	doctype-public="-//OASIS//DTD DocBook XML V4.2//EN"/>

  <xsl:template match="/">
    <xsl:text>\newdimen\quotWidth
\newdimen\quotMargin

\quotWidth5in
\quotMargin\hsize
\advance\quotMargin-\quotWidth
\divide\quotMargin 2

\def\vodorovnaCara{\hbox{\hfil\hskip\quotMargin\hfil\vrule height.2pt width \quotWidth\hfil\hskip\quotMargin}}

\font\normalni=csr10
\font\nadpis=csbx12 at 16pt
\font\autor=csbx12
    </xsl:text>

    <article>
      <xsl:apply-templates/>
    </article>
    <xsl:text>\end</xsl:text>
  </xsl:template>

  <!-- Zkopirovani odstavcu z jednoho souboru. -->
  <xsl:template name="copy-part">
    <!--
	Vodorovnou carku nedelat pred prvnim tagem 'part'. (Lepsi hack jsem nevymyslel.)
	. -->
     <xsl:if test="name(..)='article' and count(preceding-sibling::node()[name()='part']) > 0">
       <xsl:text>\vodorovnaCara</xsl:text>
     </xsl:if>

    <xsl:for-each select="node()">
      <xsl:choose>
	<xsl:when test="name(.)='para'">
	  <xsl:call-template name="templ-copy-para"/>
	</xsl:when>
	<xsl:otherwise/>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="/article">
    <xsl:text>\noindent\nadpis
    </xsl:text>
    <xsl:value-of select="title"/>
    <xsl:text>
      \par
      \vskip\baselineskip
    </xsl:text>

    <xsl:text>\noindent\autor
    </xsl:text>
    <xsl:value-of select="articleinfo/author/firstname"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="articleinfo/author/surname"/>
    <xsl:text>
      \par
      \vskip\baselineskip
    </xsl:text>

    <xsl:text>
      \normalni
    </xsl:text>
    <xsl:for-each select="node()">
      <xsl:choose>
	<xsl:when test="name(.)='part'">
	  <xsl:call-template name="copy-part"/>
	</xsl:when>

	<!-- Slovnik do vstupniho dokumentu pro TeX nepatri. -->
	<xsl:when test="name(.)='slovnik'"/>

	<xsl:otherwise/>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="templ-copy-para">
    <!-- Pokud tag 'para' obsahuje 'blockquote', nemel by (v tomto dokumentu,
         asi ne obecne) obsahovat nic jineho. V 'blockquote' bude vnoreny
         dalsi tag 'para' ...-->
    <xsl:if test="count(blockquote) = 0">
      <xsl:text>\vskip0.5em</xsl:text>
      <xsl:text>\noindent</xsl:text>
    </xsl:if>

    <!--
	Vnoreny tag 'para', viz predchozi komentar.
    -->
    <xsl:if test="name(..)='blockquote'">
      <xsl:text>
\parshape 1 \quotMargin \quotWidth{\sl </xsl:text>
    </xsl:if>

    <xsl:for-each select="node()">
      <xsl:choose>
	<xsl:when test="name(.)='preklad'">
	  <xsl:variable name="id" select="@id"/>
	  <xsl:variable name="pad" select="@pad"/>
	  <xsl:variable name="preklad"
			select="/article/slovnik/termin[@id=$id]/preklad[@pad=$pad]/text()"/>

	  <xsl:text>{\sl </xsl:text>
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
	  <xsl:text>}</xsl:text>
	</xsl:when>

	<!-- "preklad" muze byt i vnoreny... -->
	<xsl:when test="name(.)='blockquote'">
	  <xsl:call-template name="copy-part"/>
	</xsl:when>

	<xsl:when test="name(.)='emphasis'">
	  <xsl:text>{\sl </xsl:text>
	  <xsl:value-of select="."/>
	  <xsl:text>}</xsl:text>
	</xsl:when>

	<xsl:when test="name(.)='footnote'"/>

	<xsl:otherwise>
	  <xsl:copy-of select="."/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>

    <xsl:if test="name(..)='blockquote'">
      <xsl:text>}</xsl:text>
    </xsl:if>

    <xsl:if test="count(blockquote) = 0">
      <xsl:text>\par</xsl:text>
    </xsl:if>

  </xsl:template>

</xsl:stylesheet>
