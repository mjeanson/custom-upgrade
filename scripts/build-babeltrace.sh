#!/bin/bash
#
# SPDX-License-Identifier: MIT
#
# SPDX-FileCopyrightText: 2022 EfficiOS Inc.
#

set -eu

# shellcheck source=scripts/utils.sh
source "$(dirname "$0")/utils.sh"

build_babeltrace() {
	local babeltrace_branch=$1

	test -d "$BABELTRACE_BUILD_DIR/$babeltrace_branch" && rm -rf "${BABELTRACE_BUILD_DIR:?}/$babeltrace_branch"

	mkdir -p "$BABELTRACE_BUILD_DIR/$babeltrace_branch"

	cd "$BABELTRACE_BUILD_DIR/$babeltrace_branch"
	"$BABELTRACE_SRC_DIR/$babeltrace_branch/configure" --prefix="$BABELTRACE_INSTALL_DIR/$babeltrace_branch"

	make -j "$(nproc)"

	make install

	find "$BABELTRACE_INSTALL_DIR/$babeltrace_branch" -name '*.la' -delete
}

plan_no_plan

build_babeltrace stable-2.0

touch "$BUILD_DIR/.babeltrace-stamp"
