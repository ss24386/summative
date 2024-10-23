#!/bin/bash

echo -e "\n retrieve data using curl from PubMed on the IDs of articles relating to COVID"

curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=%22long%20covid%22&retmax=10000" > ../data/original/pmids.xml 

echo -e "\n what does  this data look like?"
head ../data/original/pmids.xml

echo -e "\n so there should be 6331 row, and en extra for the header"

echo -e "\n edit dataset so that I just have a  list of IDs, save as csv and check the top of csv file"
tail +5 ../data/original/pmids.xml | head -n-4 | sed 's/<Id>//g' | sed 's|[</Id>]||g' > ../data/derived/pmids.csv
head  ../data/derived/pmids.csv
rows=$(wc -l ../data/derived/pmids.csv | awk '{print $1}')
echo -e "\n there are $rows rows in the csv, one of which is a header"



#use a for loop and the csv file to loop through and extract a file for each pmid


for i in $(  eval echo "{1..$rows}")
do
	pmid= $(sed '$ip'  ../data/derived/pmids.csv)
	curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=${pmid}" > ../data/original/article-data-$pmid.xml
	echo  "extracted file number $i of $rows for article $pmid"
	sleep 1
done
