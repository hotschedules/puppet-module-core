#!/bin/bash
#
# Generate/Update Puppet Documentation
#
BASEDIR=$(dirname $0)

puppet doc -m rdoc --outputdir "${BASEDIR}/../doc" --manifestdir "${BASEDIR}/../manifests"


