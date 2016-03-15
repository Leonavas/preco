#!/bin/bash

#name of downloaded file
INFILE=$1

HOME_DIR=/home/leonavas/projects/pers/preco/scripts/src


if [ $# -lt 0 ];then
    echo -e "Usage: ./page_extractor <INFILE> <CONFIG FILE>"
    exit 1
else
    CONF=$2
fi

CONF=/home/leonavas/projects/pers/preco/scripts/src/config/page_extractor.properties.cfg
LOG4SH_PROPERTIES=$(cat $CONF | grep log4sh_properties | awk '{ if ($1 == "log4sh_properties") print $2}' FS=\=)

# load log4sh
if [ -r $HOME_DIR/config/log4sh/log4sh ]; then
  LOG4SH_CONFIGURATION=$LOG4SH_PROPERTIES . $HOME_DIR/config/log4sh/log4sh
else
  echo "ERROR: could not load (log4sh)" >&2
  exit 1
fi

# change the default message level from ERROR to INFO
logger_setLevel ERROR

OUTFILE=/home/leonavas/Desktop/data.csv

ean=$1
url="http://cosmos.bluesoft.com.br/pesquisar?q="$ean
filename=$(basename "$url")
wget "$url" 1> /dev/null 2> /dev/null

logger_info "Started extracting data from page "$url

#gets ean from dowloaded file
#ean=$(cut -d "-" -f 1 <<< $filename)

found=$(cat $filename | grep "Resultados da Busca" | wc -l)

if [[ $found -lt 1 ]]; then
  #NAME
  name=$(cat $filename | grep -A1 -m1 "<h1 class='page-header'>" | tail -1)

  #BRAND
  #brand=$(cat $INFILE | grep -A3 -m2 "Marca:" | tail -1 | cut -d ">" -f2)
  brand=$(cat $filename | grep -A3 -m2 "Marca:" | tail -1 | cut -d ">" -f2 | cut -d "<" -f1)

  #CATEGORY
  #category=$(cat $INFILE | grep -A3 -m1 "Categoria (GPC):" | tail -1 | cut -d ">" -f2)
  category=$(cat $filename | grep -A1 "gpc-name" | tail -1 | cut -d ">" -f2 | cut -d "<" -f1)

  #PESO BRUTO
  #gross_weight=$(cat $INFILE | grep -A3 -m1 "Peso Bruto:" | tail -1 | cut -d ">" -f2)

  #PESO LIQUIDO
  #net_weight=$(cat $INFILE | grep -A3 -m1 "Peso Líquido:" | tail -1 | cut -d ">" -f2)

  #PREÇO MÉDIO
  #medium_price=$(cat $INFILE | grep -A3 -m1 "o Médio:" | tail -1 | cut -d ">" -f2)

  #IMG
  #img=$(cat $INFILE | grep "id=\"main-thumbnail\"" | cut -d "=" -f7 | cut -d "\"" -f2)
  img=$(cat $filename | grep "img alt" | head -1 | cut -d "=" -f5 | tr -d '"' | cut -d' ' -f1)
  if [[ $img == *"product-placeholder"* ]]; then
    unset img
  fi

  #ncm=$(cat $filename | grep -m1 "NCM:" | cut -d ":" -f3 | cut -c2- | cut -d "'" -f1)
  ncm=$(cat $filename | grep -A2 "label-figura-fiscal" | cut -d ">" -f2 | cut -d "<" -f1 | tr '\n' ' ' | cut -c 2-)

  #echo $ean";"$name";"$category";"$medium_price";"$brand";"$gross_weight";"$net_weight";"$img
  #echo $ean";"$name";"$brand";"$category";"$img";"$ncm >> $OUTFILE
  echo $ean";"$name";"$brand";"$category";"$img";"$ncm
else
  logger_error "ean didnt return outputs: "$ean
fi
rm $filename

