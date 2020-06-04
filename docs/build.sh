#!/bin/sh

rm -rf docs
node_modules/gitbook-cli/bin/gitbook.js build
cp -r _book docs
