../data/keep.csv: goodstations.R
	Rscript $<

local:
	hive -e "SELECT * FROM fd_shape" > ../data/fd_shape.csv

test.txt: fd_shape.R
	gunzip --stdout ~/data/two_stations/000014_0.gz | cut -f 2,6,7 | Rscript $< > $@

run: fd_shape.sql fd_shape.R
	hive -f $<

fd_shape.R fd_shape.sql: builder.R dyncut.R
	Rscript $<

fd_typical_unusual.pdf: eda2.R inners.R 
	Rscript $<
