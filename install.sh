#!/bin/bash

set -e

if [ "$(dirname "$(realpath "$0")")" != "$(realpath "$PWD")" ]; then
  echo "Please run from the folder install.sh is in."
  exit 1
fi

if [ "$PREFIX" = "" ]; then
        PREFIX=$HOME
fi


rm -rf "$PREFIX"/banshy
mkdir -p "$PREFIX"/banshy
shopt -s extglob
cp -av --no-preserve=owner,context  -- !(test) "$PREFIX"/banshy/
mkdir -p "$PREFIX"/banshy/lib/gems
mkdir -p "$PREFIX"/.local/bin
ln -sf "$PREFIX"/banshy/banshy.sh "$PREFIX"/.local/bin/banshy
# fix a previous packaging issue where we created this as a file

GEM_PATH="${PREFIX}/banshy/lib/gems"
GEM_HOME="${PREFIX}/banshy/lib/gems"

echo "gem: --install-dir $GEM_PATH"
RUBY_PATH=$(which ruby)
export GEM_PATH
export GEM_HOME
export PATH=$PATH:$GEM_HOME'/bin'
gem install bundler
bundle install
bundle exec rake migrate:up

cat > $HOME/.local/share/applications/banshy.desktop <<EOF
[Desktop Entry]
Encoding=UTF-8
Version=0.1
Type=Application
Terminal=false
Exec=${PREFIX}/banshy/banshy.sh $RUBY_PATH
Name=Banshy!
Icon=${PREFIX}/banshy/resources/banshy_logo.png
EOF
