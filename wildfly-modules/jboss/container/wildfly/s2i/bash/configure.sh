#!/bin/sh
# Configure module
set -e

SCRIPT_DIR=$(dirname $0)
ARTIFACTS_DIR=${SCRIPT_DIR}/artifacts

chown -R 1001:0 $SCRIPT_DIR
chmod -R ug+rwX $SCRIPT_DIR
chmod ug+x ${ARTIFACTS_DIR}/opt/jboss/container/wildfly/s2i/*
chmod ug+x ${ARTIFACTS_DIR}/usr/libexec/s2i/*

pushd ${ARTIFACTS_DIR}
cp -pr * /
popd

mkdir $WILDFLY_S2I_OUTPUT_DIR && chown -R 1001:0 $WILDFLY_S2I_OUTPUT_DIR && chmod -R ug+rwX $WILDFLY_S2I_OUTPUT_DIR
