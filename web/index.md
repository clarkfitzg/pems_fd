# PEMS stations fundamental diagrams

Clark Fitzgerald

UC Davis

Nov 2017

This map shows traffic sensors colored based on the shape of their
fundamental diagram. Zoom and click the points for more information.

<div id="mapid" style="width: 1000px; height: 800px;"></div>

<script type="text/javascript" src="maps.js"></script>

The image below shows the medoid (average) shapes of the clusters. A few
notes:

- Steeper slopes on the right hand side mean that traffic clears out faster
- The green line is concave while the orange one is not.
- Some regions are mostly orange, such as I 680 around San Ramon
- Other regions are mixed, such as the Bay Bridge connecting San
  Francisco and Oakland

![Representative Fundamental Diagrams](cluster_fd.svg)


## Analysis

Analysis currently consists of the following steps:

First I downloaded 10 months of 30 second sensor data for the Bay Area from the
[CalTrans Performance Measurement System](http://pems.dot.ca.gov/) (PEMS).
I used 

  <li>Separate them into groups based on station. </li>
  <li>Fit a (naive) fundamental diagram to the second lane of the freeway
      by using two robust linear models for each station: One for data with
      occupancy less than 0.15 and one for greater. This approximates
      minimizing the L1 loss as in 
      <a href="http://trrjournalonline.trb.org/doi/abs/10.3141/2260-06">Li and Zhang's 2011 paper</a>.
  </li>
  <li>Throw out on/off ramp stations and those with problems such as no
      observations, excessive standard error, or positive congested slopes.
      This reduces the number of stations from 3720 to 1438.</li>
  <li>Then these 4 parameters: slope and intercept for congested and
      uncongested, were used as the inputs to a kmeans clustering. I didn't
  discover any reasonable clusters.</li>
</ol>

    <br>
    <br>
    The lines below come from the stations on I80 west of the Carquinez
    Bridge and northeast of Hercules.
    <
