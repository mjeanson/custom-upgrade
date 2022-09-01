# SPDX-FileCopyrightText: 2022 EfficiOS Inc.
#
# SPDX-License-Identifier: MIT

all: build-apps

# Requires sudo access
install-deps:
	./scripts/install-deps.sh

# Get all sources from git
src/upstream/.clone-stamp:
	./scripts/clone-sources.sh

clone-sources: src/upstream/.clone-stamp

# Build userspace-rcu
build/.urcu-stamp: src/upstream/.clone-stamp
	./scripts/build-urcu.sh

build-urcu: build/.urcu-stamp

build/.babeltrace-stamp: src/upstream/.clone-stamp
	./scripts/build-babeltrace.sh

# Build babeltrace
build-babeltrace: build/.babeltrace-stamp

# Build lttng-ust
build/.ust-stamp: build/.urcu-stamp
	./scripts/build-ust.sh

build-ust: build/.ust-stamp

# Build lttng-tools
build/.tools-stamp: build/.ust-stamp build/.babeltrace-stamp
	./scripts/build-tools.sh

build-tools: build/.tools-stamp

# Assemble the sysroots for all test phases
sysroots/.sysroots-stamp: build/.tools-stamp
	./scripts/assemble-sysroots.sh

assemble-sysroots: sysroots/.sysroots-stamp

# Build the test apps
apps/.apps-stamp: sysroots/.sysroots-stamp
	./scripts/build-apps.sh

build-apps: apps/.apps-stamp

# Run the tests
tap:
	@mkdir tap

test-phase1-A: apps/.apps-stamp tap
	@./tests/phase1-A.sh | tee tap/phase1-A.log

test-phase1-B: apps/.apps-stamp tap
	@./tests/phase1-B.sh | tee tap/phase1-B.log

test-phase1-C: apps/.apps-stamp tap
	@./tests/phase1-C.sh | tee tap/phase1-C.log

test-phase1-D: apps/.apps-stamp tap
	@./tests/phase1-D.sh | tee tap/phase1-D.log

test-phase1-E: apps/.apps-stamp tap
	@./tests/phase1-E.sh | tee tap/phase1-E.log

tests-phase1: test-phase1-A test-phase1-B test-phase1-C test-phase1-D test-phase1-E

test-phase2-A: apps/.apps-stamp tap
	@./tests/phase2-A.sh | tee tap/phase2-A.log

test-phase2-B: apps/.apps-stamp tap
	@./tests/phase2-B.sh | tee tap/phase2-B.log

test-phase2-C: apps/.apps-stamp tap
	@./tests/phase2-C.sh | tee tap/phase2-C.log

tests-phase2: test-phase2-A test-phase2-B test-phase2-C

tests: tests-phase1 tests-phase2

clean:
	rm -rf src/upstream build apps sysroots install tap

.PHONY: install-deps clone-sources build-urcu build-ust build-tools build-apps assemble-sysroots tests clean
