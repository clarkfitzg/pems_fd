# Name of the report
REPORT = index

# Navigate web browser to localhost:8000
view: $(REPORT).html 
	python3 -m http.server 8000

# $< references the first prerequisite
$(REPORT).html : $(REPORT).md maps.js
	pandoc $< -s -o $@ --from markdown_strict -H header.html

# $< references the first prerequisite
paper.pdf : paper.md
	pandoc --biblatex --bibliography=citations.bib $< -s -o $@


clean:
	rm $(REPORT).html 
