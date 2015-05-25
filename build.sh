#!/usr/bin/env sh
pandoc -t docbook -s src/back.md | xsltproc --nonet src/transform.xsl - > src/back.xml
pandoc -t docbook -s src/middle.md | xsltproc --nonet src/transform.xsl - > src/middle.xml

xml2rfc src/template.xml -o dist/draft.txt --text
xml2rfc src/template.xml -o dist/draft-tmp.html --html

cat dist/draft-tmp.html | sed -f lib/addstyle.sed > dist/draft.html
rm dist/draft-tmp.html
