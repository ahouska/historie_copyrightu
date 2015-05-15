BASENAME=historie_copyrightu
DOCBOOK_ROOT=/usr/share/xml/docbook/stylesheet/nwalsh/current

all:	$(BASENAME).html
#all:	$(BASENAME).html $(BASENAME).pdf


$(BASENAME).xml:	uvod.xml historie.xml soucasnost.xml slovnik.xml vsechno.xml\
	budoucnost.xml historie_copyrightu.xsl
	xsltproc --xinclude --output $@ historie_copyrightu.xsl vsechno.xml


$(BASENAME).fo:	$(BASENAME).xml
	xsltproc --output $@ $(DOCBOOK_ROOT)/fo/docbook.xsl $(BASENAME).xml


$(BASENAME).html:	$(BASENAME).xml
	xsltproc --output $@ $(DOCBOOK_ROOT)/html/docbook.xsl $(BASENAME).xml


$(BASENAME).pdf:	$(BASENAME).fo
	fop -fo $(BASENAME).fo -pdf $@


clean:
	rm -rf $(BASENAME).xml $(BASENAME).fo $(BASENAME).html $(BASENAME).pdf
