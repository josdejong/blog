#!/bin/bash

# clear old data
rm -rf docs

# build the site 
hugo

# add all changed pages
git add docs

# commit and publish the changes
git commit -m "Publish website"
git push

echo "Website published"
