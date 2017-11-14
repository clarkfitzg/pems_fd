# Name of the report
REPORT = index

# Navigate web browser to localhost:8000
view: $(REPORT).html 
	python3 -m http.server 8000

# $< references the first prerequisite
$(REPORT).html : $(REPORT).md
	pandoc $< -s -o $@ --from markdown_strict -H header.html

clean:
	rm $(REPORT).html 
