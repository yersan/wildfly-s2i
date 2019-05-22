VERSION=170
NAMESPACE=wildfly
PLATFORM=centos7
IMAGE_NAME=${NAMESPACE}/wildfly-${VERSION}-${PLATFORM}
RUNTIME_IMAGE_NAME=${NAMESPACE}/wildfly-runtime-${VERSION}-${PLATFORM}
# Include common Makefile code.
include make/common.mk
