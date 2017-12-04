Mon Dec  4 11:55:30 PST 2017

I've said that it's crazy to use a small chunk size and loop through each
row of the file. But how ineffecient is it? To find out I'm experimenting
with different chunk sizes. Probably best to just run it locally and
extrapolate the actual time required based on this.

When I run it on one station with the default of 1 million lines in the buffer it
takes 1.24 seconds. 
