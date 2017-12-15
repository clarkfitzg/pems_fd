# PEMS stations fundamental diagrams

Clark Fitzgerald (Statistics), Professor Michael Zhang (Civil Engineering)

UC Davis

Nov 2017

This is a brief set of working notes for a project analyzing highway
traffic sensor data. 

This map shows traffic sensors colored based on the shape of their
fundamental diagram. Zoom and click the points for more information.

<div id="mapid" style="width: 1000px; height: 800px;"></div>

<script type="text/javascript" src="maps.js"></script>

The capacity is the highest point on the fundamental diagram, the point
where the left and mid lines meet. It's in units of vehicles per hour.

## Fundamental Diagrams

The image below shows the medoid (average) shapes of the clusters. A few
notes:

- Steeper slopes on the right hand side mean that traffic clears out faster
- The green line is concave while the orange one is not.
- Some regions are mostly orange, such as I 680 around San Ramon
- Other regions are mixed, such as the Bay Bridge connecting San
  Francisco and Oakland

![Representative Fundamental Diagrams](cluster_fd.svg)

## Clustering

I used a kernel based method to cluster the stations. The kernel is based
on the [inner product between
functions](https://en.wikipedia.org/wiki/Dot_product#Functions) over the
interval (0, 1).

## Computation

Computation currently consists of the following steps:

- Download 10 months of 30 second sensor data for the Bay Area from the
[CalTrans Performance Measurement System](http://pems.dot.ca.gov/) (PEMS)
into Hadoop
- Use [Hive with R](http://clarkfitzg.github.io/2017/10/31/3-billion-rows-with-R/) to group data by station and fit the fundamental diagrams for each station
- Compute the kernel matrix between all fundamental diagrams using
  numerical integration (just for fun, it also has an analytic form)

Thu Nov 30 14:24:25 PST 2017

Beginning to write paper now.

