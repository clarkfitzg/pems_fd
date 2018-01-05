# Name of the report
REPORT = index

# $< references the first prerequisite
$(REPORT).html : $(REPORT).md maps.js
	pandoc $< -s -o $@ --from markdown_strict -H header.html

# Navigate web browser to localhost:8000
view: $(REPORT).html 
	python3 -m http.server 8000

clean:
	rm $(REPORT).html 
