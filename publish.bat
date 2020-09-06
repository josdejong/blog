# clear old data
rm -rf docs

# build the site 
hugo

# create a copy of the RSS feed for backward compatibility
cp docs/index.xml docs/atom.xml

# add all changed pages
git add docs

# commit and publish the changes
git commit -m "Publish website"
git push

echo "Website published"
