BASENAME=historie_copyrightu
DOCBOOK_ROOT=/usr/share/xml/docbook/stylesheet/nwalsh/current

all:	$(BASENAME).html $(BASENAME).pdf


$(BASENAME).xml:	uvod.xml historie.xml soucasnost.xml slovnik.xml vsechno.xml\
	budoucnost.xml zaver.xml historie_copyrightu.xsl
	xsltproc --xinclude --output $@ historie_copyrightu.xsl vsechno.xml


$(BASENAME).fo:	$(BASENAME).xml
	xsltproc --output $@ $(DOCBOOK_ROOT)/fo/docbook.xsl $(BASENAME).xml


$(BASENAME).html:	$(BASENAME).xml
	xsltproc --output $@ $(DOCBOOK_ROOT)/html/docbook.xsl $(BASENAME).xml


# fop i docbook2pdf maji problem s kodovanim.
#$(BASENAME).pdf:	$(BASENAME).fo
#	fop -fo $(BASENAME).fo -pdf $@

$(BASENAME).tex:	$(BASENAME).xml
# sed  "s/\(\s\)\([kosvzKOSVZ]\)\( \|$\)/\1\2~/g"
	xsltproc --xinclude tex.xsl vsechno.xml | sed -e 's/ \+/ /g' | sed -f tilde.sed  > historie_copyrightu.tex

$(BASENAME).pdf:	$(BASENAME).tex
	pdfcsplain $(BASENAME).tex

slovnik.html:		slovnik.xml
	xsltproc --output slovnik.html slovnik.xsl slovnik.xml

clean:
	rm -rf $(BASENAME).xml $(BASENAME).fo $(BASENAME).html $(BASENAME).pdf\
		$(BASENAME).tex $(BASENAME).dvi $(BASENAME).log $(BASENAME).pdf\
		slovnik.html
