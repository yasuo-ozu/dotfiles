BASENAME := $(patsubst %.tex.files,%,$(notdir $(PWD)))
PDF_VIEWER := evince

.PHONY:	open clean

open:	$(BASENAME).pdf
	$(PDF_VIEWER) "$<" >& /dev/null &

$(BASENAME).pdf:	$(BASENAME).dvi
	dvipdfmx "$(basename $<)"
	qpdf --linearize $@ linearized_$@
	rm -f $@
	mv linearized_$@ $@

%.tex:
	cp "../$@" "$@"

header.tex:	$(BASENAME).tex
	echo "\\input{lib/std.tex}" > "$@"
	while read NAME; do \
		case "$$NAME" in; \
			*listings) ;\
				echo "\\input{lib/listings.tex}" >> "$@" ;; \
		esac ;\
	done < `cat "$(BASENAME).tex" | sed -e '/^%/d' |sed -e 's/\\/\n\\/g' | sed -ne '/^\\/p' | sed -e 's/^\\\([a-zA-Z0-9]+\).*$/\1/'`

clean:
	rm -rf *.log *.aux *.dvi *.fls *.d *.pdf *.bbl *.blg svg/*.png svg/*.eps svg/*.pdf data/*.tex data/*.png data/*.eps plt/*.png plt/*.eps plt/default.am data/m_*.txt

reference.bib:
	if [ ! -f "$@" ]; then touch "$@" ; fi

%.dvi:	%.tex %.d reference.bib Makefile
	platex --shell-escape -interaction=batchmode -halt-on-error $<
	if [ -s "reference.bib" ]; then pbibtex $(basename $<) ; fi
	if [ -s "reference.bib" ]; then platex --shell-escape -interaction=batchmode -halt-on-error $< ; fi
	for i in `seq 1 3`; do\
		if grep -F 'Rerun to get cross-references right.' $(basename $<).log; then\
			platex --shell-escape -interaction=batchmode -halt-on-error $<; else exit 0;\
		fi;\
	done
%.fls:	%.tex Makefile
	platex -interaction=nonstopmode --shell-escape -recorder $<
%.d:	%.tex $(wildcard *.tex) Makefile
	@/bin/echo 'FILES=( "$<" );'\
	'while [ "$${#FILES[@]}" -gt 0 ] ; do'\
	'	FILE="$${FILES[0]}";'\
	'	FILES=("$${FILES[@]:1}");'\
	'	cat "$$FILE" | sed -ne '\''/[A-Za-z0-9_\/]*\.\(png\|tex\|eps\|pdf\)/p'\'' | sed -e '\''s/^.*[^A-Za-z0-9_\/\.]\([A-Za-z0-9_\.\/]*\.\(png\|tex\|eps\|pdf\)\).*$$/$(basename $<).dvi: \1/'\'';'\
	'	while read LINE; do'\
	'		if [ -f "$$LINE" ]; then'\
	'			FILES=("$${FILES[@]}" "$$LINE");'\
	'		fi;'\
	'	done < <(cat "$$FILE" | sed -ne '\''/[A-Za-z0-9_\/]*\.tex/p'\'' | sed -e '\''s/^.*[^A-Za-z0-9_\/\.]\([A-Za-z0-9_\.\/]*\.tex\).*$$/\1/'\'');'\
	'done' | bash > $@

# Convert image
svg/%.png:	svg/%.svg
	convert -units PixelsPerInch -density 72x72 $< $@
#svg/%.eps:	svg/%.svg
#	convert -units PixelsPerInch -density 72x72 $< $@
svg/%.pdf:	svg/%.svg
	#convert -units PixelsPerInch -density 72x72 $< $@
	#convert $< $@
	inkscape -f $< -A $@

# Plot
data/%.png:	data/%.txt
	if [ `wc -l $< | cut -d " " -f 1` -ge 50 ]; then \
	/bin/echo 'set terminal pngcairo dashed size 800,600;\
	 set xlabel '`cat $<|head -n 1|cut -c 2- |cut -f 1`';\
	 set ylabel '`cat $<|head -n 1|cut -c 2- |cut -f 2`';unset key;\
	 plot "$<" using 1:2 w l lc black;\
	 set out "$@";replot'|gnuplot > /dev/null\
	 ; else \
	/bin/echo 'set terminal pngcairo dashed size 800,600;\
	 set xlabel '`cat $<|head -n 1|cut -c 2- |cut -f 1`';\
	 set ylabel '`cat $<|head -n 1|cut -c 2- |cut -f 2`';unset key;\
	 plot "$<" using 1:2 w p pt 7 lc rgbcolor "#FFFFFF" ps 2;\
	 replot "$<" using 1:2 w p pt 6 lc black ps 2;\
	 replot "$<" using 1:2 w p pt 7 lc black ps 0.5;\
	 set out "$@";replot'|gnuplot > /dev/null\
	 ; fi
#data/%.eps:	data/%.txt
#	@/bin/echo 'set terminal postscript eps enhanced color size 800,600;\
#	 set xlabel '`cat $<|head -n 1|cut -c 2- |cut -f 1`';\
#	 set ylabel '`cat $<|head -n 1|cut -c 2- |cut -f 2`';unset key;\
#	 plot "$<" using 1:2 w p pt 7 lc rgbcolor "#FFFFFF" ps 2;\
#	 replot "$<" using 1:2 w p pt 6 lc black ps 2;\
#	 replot "$<" using 1:2 w p pt 7 lc black ps 0.5;\
#	 set out "$@";replot'|gnuplot > /dev/null

data/m_%.txt:	math/%.math
	(echo 'FILE="$@"'; cat $<) | math

-include plt/default.am

plt/%.png:	plt/%.plt
	(echo 'TERM="pngcairo dashed";set terminal TERM size 800,600;FILE="data/$(basename $(notdir $<)).txt"'; cat $<; echo 'set out "$@";replot;') | gnuplot > /dev/null || rm -f $@
plt/%.eps:	plt/%.plt
	(echo 'TERM="postscript eps enhanced color";set terminal TERM size 800,600;FILE="data/$(basename $(notdir $<)).txt"'; cat $<; echo 'set out "$@";replot;') | gnuplot > /dev/null || rm -f $@

plt/%.d:	plt/%.plt
	cat $< | sed -ne '/[A-Za-z0-9_\/]*\.txt/p' | sed -e 's/^.*[^A-Za-z0-9_\/\.]\([A-Za-z0-9_\.\/]*\.txt\).*$$/$(basename $<).png: \1\n$(basename $<).eps: \1/'
plt/default.am:	plt
	find plt -name "*.plt"| sed -ne '/__/p' | sed -e 's/^\(.*\/\(.*\)__.*\)$$/plt\/\2_%.eps: data\/\2_%.txt \1\n'\
	'\t(echo "TERM=\\\"postscript eps enhanced color\\\";FILE=\\\"$$<\\\";set terminal TERM size 800,600;"; cat \"\1\"; echo "set out \\\"$$@\\\";replot;") | gnuplot > \/dev\/null || rm -f $$@\n'\
	'plt\/\2_%.png: data\/\2_%.txt \1\n'\
	'\t(echo "TERM=\\\"pngcairo dashed\\\";FILE=\\\"$$<\\\";set terminal TERM size 800,600;"; cat \"\1\"; echo "set out \\\"$$@\\\";replot;") | gnuplot > \/dev\/null || rm -f $$@\n/'> $@
	while read FNAME; do if grep FILE "$$FNAME" > /dev/null ; then echo "$$FNAME" | sed -e 's/^\(.*\/\([^\/]*\)\)\.plt$$/\1.png:	\0 data\/\2.txt\n\1.eps:	\0 data\/\2.txt/' >> $@ ; fi ; done <<< `find plt -name "*.plt"`
	
-include $(patsubst %,%.d,$(wildcard plt/*.plt))

# Table
data/%.tex:	data/%.txt
	echo $< | sed -e 's/^.*\/\([^\/]*\)$$/% \1/' > $@
	cat $< | tbltex >> $@

#-include $(patsubst %,%.d,$(REPORT_NAME))
-include $(patsubst %.tex,%.d,$(wildcard *.tex))




