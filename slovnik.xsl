<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	exclude-result-prefixes="xsl">
  <xsl:output
	method="html"
	encoding="UTF-8"
	doctype-system="http://docbook.org/xml/4.2/docbookx.dtd"
	doctype-public="-//OASIS//DTD DocBook XML V4.2//EN"/>


  <xsl:template match="/slovnik">
    <html>
      <head/>
      <table border="1">
	<thead>
	  <td width="25%"><b>Anglicky</b></td>
	  <td width="20%"><b>Překlad</b></td>
	  <td><b>Komentář</b></td>
	</thead>
	<tbody>
	  <xsl:apply-templates/>
	</tbody>
      </table>
    </html>
  </xsl:template>

  <xsl:template match="termin">
    <tr>
      <td>
	<xsl:value-of select="puvodni"/>
      </td>
      <td>
	<xsl:value-of select="preklad[@pad = 1]"/>
      </td>
      <td>
	<xsl:value-of select="komentar"/>
      </td>
    </tr>
  </xsl:template>
</xsl:stylesheet>
