#!/bin/bash



PREFIX=$HOME
GEM_PATH="${PREFIX}/banshy/lib/gems"
GEM_HOME="${PREFIX}/banshy/lib/gems"

echo "gem: --install-dir $GEM_PATH"

export GEM_PATH
export GEM_HOME
export PATH=$PATH:$GEM_HOME'/bin'

ruby --version

RUBY_PATH="${1:-$(which ruby)}"

$($RUBY_PATH $PREFIX/banshy/banshy.rb)
