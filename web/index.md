# PEMS stations fundamental diagrams

Clark Fitzgerald

UC Davis

Nov 2017

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

The three separate lines come from fitting points in different regions:

- Left line comes from fitting in (0, 0.1)
- Center line comes from fitting in (0.2, 0.5)
- Right line comes from fitting in (0.5, 1)

I fit the lines using least squares subject to the constraints that the
fundamental diagram must pass through (0, 0) and (1, 0).
I ignored the points in the region (0.1, 0.2) because points vary widely
in this region as the traffic transitions to a congested state.

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
