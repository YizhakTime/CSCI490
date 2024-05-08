#!/bin/bash
cocolabels="yolov8n_saved_model/metadata.yaml"
cp $cocolabels "labels.txt"

ex "labels.txt" <<EOEX
  :1,13d
  ::%s/  \d\+: //g
  :x
EOEX
