Mon Dec  4 11:55:30 PST 2017

I've said that it's crazy to use a small chunk size and loop through each
row of the file. But how ineffecient is it? To find out I'm experimenting
with different chunk sizes. Probably best to just run it locally and
extrapolate the actual time required based on this.

When I run it on one station with different buffer sizes I see all kinds of
different run times:

- 1 million lines in the buffer takes takes 1.24 seconds
- 10,000 lines takes 3.4 seconds.
- 1,000 lines takes 18 seconds.
- 100 lines takes 3 minutes.
- 1 line takes more than 3 hours (Got tired of waiting)

There are a few reasons for why it takes this long:

- It allocates memory `O(N / B)` times, where `N` is the size of
  the original data (about 800 K) and `B` is the size of the buffer
- Much more time is spent in the R code versus the underlying C library
  functions.

It's also worth noting that there's no speedup for going larger than a
million lines, because this test case only has `N`. 
