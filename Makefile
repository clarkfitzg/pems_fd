serve: station.json
	python3 -m http.server 8000

data/station_cluster.csv: eda3.R
	Rscript $<

station.json: station_json.R data/station_cluster.csv
	Rscript $<

web/cluster_fd.svg: plots.R data/station_cluster.csv
	Rscript $<

link:
	cp -f ~/pems_fd/web/* ~/public_html/fd
