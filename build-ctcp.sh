#!/usr/bin/env sh

# make xml
kramdown-rfc2629 draft-oakley-irc-ctcp-latest.mkd > dist/draft-oakley-irc-ctcp-latest.xml

# make txt
xml2rfc dist/draft-oakley-irc-ctcp-latest.xml -o dist/draft-oakley-irc-ctcp-latest.txt --text

# make html
xml2rfc dist/draft-oakley-irc-ctcp-latest.xml -o dist/draft-tmp.html --html

cat dist/draft-tmp.html | sed -f lib/addstyle.sed > dist/draft-oakley-irc-ctcp-latest.html
rm dist/draft-tmp.html
