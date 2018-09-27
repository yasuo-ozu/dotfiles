#!/bin/sh

set -e

git submodule init
git submodule update
bin/setup
if [ `whoami` = "root" ]; then
	bin/mitamae local $@ lib/recipe.rb
else
	sudo -E bin/mitamae local $@ lib/recipe.rb
fi
