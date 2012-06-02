#!/bin/bash

set -xe

VERSION=0.19.4

mkdir -p build
cd build
rm -fr elasticsearch

# TODO: Get elasticsearch tag as zip
wget --no-check-certificate https://github.com/elasticsearch/elasticsearch/zipball/v$VERSION -O es-$VERSION.zip

# unzip
unzip es-$VERSION.zip
mv elasticsearch-elasticsearch-* elasticsearch
cd elasticsearch

# Apply patch
patch -p1 -i ../../patches/es-grouping-$VERSION.patch

# Build zip
mkdir -p ../dist
if [[ $VERSION == 0.18.* ]] || [[ $VERSION == 0.17.* ]] ;
then
    gradle clean zip

    cp build/elasticsearch/build/distributions/*.zip ../dist/
    cp build/elasticsearch/build/distributions/exploded/lib/elasticsearch*.jar ../dist/
else
    mvn package -DskipTests

    cp ./target/elasticsearch*.jar ../dist/
    cp ./target/releases/elasticsearch*.zip ../dist/
fi

