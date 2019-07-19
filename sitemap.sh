#!/bin/bash

cp public_html/sitemap.xml public_html/tmpsitemap.xml

for file in $(while read line; do echo $line | grep "example.com" | cut -f4- -d/ | cut -f1 -d\<; done < public_html/tmpsitemap.xml); do
        DATE_FILE=$(ls -l --time-style=full-iso public_html/$(echo $file | sed 's/\/$/\/index/g').php | awk '{print $6}')
        DATE_FILE=$(echo ${DATE_FILE} | sed 's/\-/\\\-/g') && echo ${DATE_FILE}
        SITEMAP_DATE_A=$(cat public_html/tmpsitemap.xml | grep "example.com/${file}<"| sed 's/\//\\\//g' | sed 's/\./\\\./g' | sed 's/\-/\\\-/g')
        SITEMAP_DATE_B=$(cat public_html/tmpsitemap.xml | grep "example.com/${file}<" | sed "s/20[0-9]*-[0-9]*-[0-9]*/${DATE_FILE}/g" | sed 's/\//\\\//g' | sed 's/\./\\\./g' | sed 's/\-/\\\-/g')
        sed -i "s/${SITEMAP_DATE_A}/${SITEMAP_DATE_B}/g" public_html/tmpsitemap.xml && echo $file && echo "Old date: ${SITEMAP_DATE_A}" && echo "New date: ${SITEMAP_DATE_B}" && sleep 1
done

if [[ $(diff public_html/sitemap.xml public_html/tmpsitemap.xml) ]]; then
        mv public_html/tmpsitemap.xml public_html/sitemap.xml
else
        rm public_html/tmpsitemap.xml
fi

exit 0
