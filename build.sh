#!/bin/bash

workdir=$PWD

# echo $workdir

# glob the star
shopt -s globstar

mkdir -p dist
rm -rf dist/*\

echo 'building sources...'
luacc notes.init -p 4 -o dist/notes.lua -i src $(for i in src/notes/lib/**/*.lua; do echo $i; done | sed 'y/\//./;s/^src.//;s/\.lua$//')

echo 'building vendors...'

cd $workdir/src/notes/vendor

# build vendor package
luacc init -p 5 -o $workdir/dist/vendor.lua -i . $(for i in **/*.lua; do echo $i; done | sed 'y/\//./;s/^src.vendor.//;s/\.lua$//' | awk '{ if ($1 != "init") { print } }')

# patch redrun function
# sed -i 's|\["redrun"\] = function()|["redrun"] = function(...)|g' $workdir/dist/vendor.lua

cd $workdir

echo 'squishing...'
mkdir -p dist/release
luamin -f dist/notes.lua > dist/release/tail.notes.min.lua
luamin -f dist/vendor.lua > dist/release/tail.vendor.min.lua

echo 'writing header...'
awk 'NR>=1 && NR<=4' dist/notes.lua > dist/release/notes.min.lua
cat dist/release/tail.notes.min.lua >> dist/release/notes.min.lua

awk 'NR>=1 && NR<=5' dist/vendor.lua > dist/release/vendor.min.lua
cat dist/release/tail.vendor.min.lua >> dist/release/vendor.min.lua

echo 'cleaning up...'
rm dist/release/tail.notes.min.lua dist/release/tail.vendor.min.lua