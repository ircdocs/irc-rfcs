#!/usr/bin/env sh
pandoc -t docbook -s src/back.md | xsltproc --nonet src/transform.xsl - > src/back.xml
pandoc -t docbook -s src/middle.md | xsltproc --nonet src/transform.xsl - > src/middle.xml

xml2rfc src/template.xml -o dist/id-oakley-ircv3-latest.txt --text
xml2rfc src/template.xml -o dist/draft-tmp.html --html

cat dist/draft-tmp.html | sed -f lib/addstyle.sed > dist/id-oakley-ircv3-latest.html
rm dist/draft-tmp.html
