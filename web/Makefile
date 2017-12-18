# Name of the report
REPORT = index
BIBFILE = citations.bib

# $< references the first prerequisite
paper.pdf : paper.md $(BIBFILE)
	pandoc -s $< -o $@ --filter pandoc-citeproc 

# Navigate web browser to localhost:8000
view: $(REPORT).html 
	python3 -m http.server 8000

# $< references the first prerequisite
$(REPORT).html : $(REPORT).md maps.js
	pandoc $< -s -o $@ --from markdown_strict -H header.html

clean:
	rm $(REPORT).html 
