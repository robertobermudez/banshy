#!/bin/bash

PREFIX=$HOME
GEM_PATH="${PREFIX}/banshy/lib/gems"
GEM_HOME="${PREFIX}/banshy/lib/gems"

echo "gem: --install-dir $GEM_PATH"

export GEM_PATH
export GEM_HOME
export PATH=$PATH:$GEM_HOME'/bin'

# gem pristine gdk_pixbuf2 --version 4.2.1
# gem pristine gio2 --version 4.2.1
# gem pristine glib2 --version 4.2.1
# gem pristine gobject-introspection --version 4.2.1
# gem pristine gstreamer --version 4.2.1
# gem pristine gtk3 --version 4.2.1
# gem pristine interception --version 0.5
# gem pristine json --version 2.7.1
# gem pristine pango --version 4.2.1
# gem pristine racc --version 1.7.3

ruby --version

$(ruby $PREFIX/banshy/banshy.rb)
