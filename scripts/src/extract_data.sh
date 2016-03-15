#!/bin/bash
while read p; 
do
  while [ $(jobs | wc -l) -ge 50 ]
  do
    sleep 5
  done  
  /home/leonavas/projects/pers/preco/scripts/src/page_extrator.sh $p &
done < /home/leonavas/projects/pers/preco/scripts/src/ean.csv
