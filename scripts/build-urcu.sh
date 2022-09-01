#!/bin/bash
#
# SPDX-License-Identifier: MIT
#
# SPDX-FileCopyrightText: 2022 EfficiOS Inc.
#

set -eu

# shellcheck source=scripts/utils.sh
source "$(dirname "$0")/utils.sh"

build_urcu() {
	local urcu_branch=$1

	test -d "$URCU_BUILD_DIR/$urcu_branch" && rm -rf "${URCU_BUILD_DIR:?}/$urcu_branch"

	mkdir -p "$URCU_BUILD_DIR/$urcu_branch"

	cd "$URCU_BUILD_DIR/$urcu_branch"
	"$URCU_SRC_DIR/$urcu_branch/configure" --prefix="$PREFIX_DIR"

	make -j "$(nproc)"

	make install DESTDIR="$URCU_INSTALL_DIR/$urcu_branch"

	find "$URCU_INSTALL_DIR/$urcu_branch" -name '*.la' -delete
}

plan_no_plan

build_urcu stable-0.9
build_urcu stable-0.12

touch "$BUILD_DIR/.urcu-stamp"
