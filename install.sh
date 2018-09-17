#!/bin/sh

set -e

bin/setup
export ORIG_USER=`whoami`
sudo -E bin/mitamae local $@ lib/recipe.rb
