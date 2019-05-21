build = make/build.sh

script_env = \
	IMAGE_NAME=$(IMAGE_NAME)

.PHONY: build
build:
	$(script_env) $(build)

.PHONY: test
test:
	$(script_env) TEST_MODE=true $(build)
