#!/bin/bash
#
#	From command line, type:
#	bash xmllint.sh filename.xml
#
#	Script will read in xml file name
#	parse that name for the output name
#	then run the xmllint command with
#	both file names

xmlFile="${BASH_ARGV[0]}"
echo "Xml File: " $xmlFile

xmlFileLen=${#xmlFile}
#echo $xmlFileLen

newFile=${xmlFile:0:xmlFileLen-4}"_INDENTED.xml"
echo "Indented File: " $newFile

echo "Indenting Xml file..."
xmllint -format $xmlFile > $newFile

echo "xmllint complete!"

#xmllint -format "${BASH_ARGV[0]}" > "text.xml"