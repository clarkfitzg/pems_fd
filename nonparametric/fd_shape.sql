-- 2017-11-21 08:46:20
-- Automatically generated from R by RHive version 0.0.1

add FILE fd_shape.R
;


DROP TABLE fd_shape 
;

CREATE TABLE fd_shape (
  station INT
  , right_end_occ DOUBLE
  , mean_flow DOUBLE
  , sd_flow DOUBLE
  , number_observed INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
;

INSERT OVERWRITE TABLE fd_shape 
SELECT
TRANSFORM (station,flow2,occupancy2)
USING "Rscript fd_shape.R"
AS (
    station,right_end_occ,mean_flow,sd_flow,number_observed
)
FROM (
    SELECT station,flow2,occupancy2
    FROM pems
    CLUSTER BY station
) AS tmp
;