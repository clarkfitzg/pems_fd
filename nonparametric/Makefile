run: fd_shape.sql fd_shape.R
	hive -f $<

fd_shape.R fd_shape.sql: builder.R dyncut.R
	Rscript $<
