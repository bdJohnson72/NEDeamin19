#!/bin/bash


#A Simple Script to look for leads with duplicate emails
#Author Brooks Johnson

#go to desktop and create directory if one is not already there
cd ~/Desktop
echo changing to Desktop
mkdir  -p "Duplicate Email Reports"
cd "Duplicate Email Reports"/

#ask user for values

date=$(date)

read  -p "what is the name of the devhub?" devhub
if [[ ! $devhub ]]; 
then
	echo "Must supply  devhub name"
	exit 1
fi
 
read -p "Enter l to query leads or c to query contacts" sobject
if [[ ! $sobject ]]; 
then
	echo "must supply SObject for query"
	exit 1
fi


#set report name
#if [[ $sobject = [lL] ]];
#then report = "Duplicate Lead Emails {DATE}"
#fi

report=${sobject}duplicate-emails.csv

echo "Getting duplicate emails  from" $devhub $sobject

if [[ $sobject = [lL] ]];
then
	sfdx force:data:soql:query -q 'SELECT  email FROM Lead' -u "$devhub" -r csv |tail -n +2 \
	| sort -t ','  | uniq -i -d > $report

        echo "Total duplicate email addresses found"
	cat $report | wc -l
	echo report completed, the following duplicate email addresses were found. 
	echo "You can view the results at " "$report"
	cat $report | head -n 20
fi

if [[ $sobject = [cC] ]];
then
	sfdx force:data:soql:query -q 'SELECT email FROM Contact' -u "$devhub" -r csv | tail -n +2  \
	| sort -t ',' | uniq -i -d > $report  

	echo "Total duplicate email addresses found"
	cat $report | wc -l
	echo "report completed, the following duplicate email addresses were found."
	echo "you can view the results in" "$report"
	cat $report | head -n 20
fi






