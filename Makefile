SHELL := /bin/bash

MAP_SRCS := $(wildcard *.svg)
PNGS := $(MAP_SRCS:.svg=.png) 
PDF_SRCS := example/example-maps.sla
PDFS := $(PDF_SRCS:.sla=.pdf)

alt_fill_a := \#952e2a
alt_fill_b := \#3e6159
alt_stroke := black
default_stroke := \#5d4c2e

all: $(PDFS)

%.pdf: %.sla $(PNGS)
	scribus -g -ns -py <(echo  '\
	  import scribus;           \
	  scribus.openDoc("$(<)");  \
	  pdf=scribus.PDFfile();    \
	  pdf.file="$(@)";\
	  pdf.save()                \
	')

%.png: %.svg
	inkscape -e $(@) -z -d 300 -y 0 $(<)
	sed -e "s/\([.#]dz-a\s*{\)[^}]*/\1fill:$(alt_fill_a);/g" \
	  -e "s/\(#dz-b\s*{\)[^}]*/\1fill:$(alt_fill_b);/g" \
	  -e "s/$(default_stroke)/$(alt_stroke);/g" \
	  $(<) \
	  | inkscape -e $(<:.svg=_alt.png) -z -d 300 -y 0 -

clean:
	rm -rf *.png example/*.pdf *.zip

hh-deployment-maps_v0.1.zip: $(PDFS)
	zip hh-deployment-maps_v0.1.zip $(PDFS) $(PNGS) $(PNGS:.png=_alt.png) $(MAP_SRCS)

dist: hh-deployment-maps_v0.1.zip

.PRECIOUS: $(PNGS)

