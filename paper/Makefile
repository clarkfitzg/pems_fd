# Name of the report
REPORT = paper
BIBFILE = citations.bib

# $< references the first prerequisite
$(REPORT).pdf : $(REPORT).md $(BIBFILE)
	pandoc -s $< -o $@ --filter pandoc-citeproc 

# $< references the first prerequisite
$(REPORT).docx : $(REPORT).md $(BIBFILE)
	pandoc -s $< -o $@ --filter pandoc-citeproc 
