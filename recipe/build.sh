#!/bin/bash

set -ex

mkdir -p _build
pushd _build

# conda-forge/conda-forge.github.io#621
find ${PREFIX} -name "*.la" -delete

# only link libraries we actually use
export GSL_LIBS="-L${PREFIX}/lib -lgsl"
export GSTLAL_LIBS="-L${PREFIX}/lib -lgstlal -lgstlaltags -lgstlaltypes"
export framecpp_CFLAGS=" "
export LAL_LIBS="-L${PREFIX}/lib -llal"

# configure
${SRC_DIR}/configure \
  --enable-gtk-doc=no \
  --enable-gtk-doc-html=no \
  --enable-gtk-doc-pdf=no \
  --enable-introspection \
  --prefix=${PREFIX} \
  --with-doxygen=no \
  --with-framecpp=yes \
  --with-gds=no \
  --with-nds=yes \
;

# build
make -j ${CPU_COUNT} V=1 VERBOSE=1

# install
make -j ${CPU_COUNT} V=1 VERBOSE=1 install

# test
if [ "$(uname)" == "Linux" ]; then
  make -j ${CPU_COUNT} V=1 VERBOSE=1 check
fi
