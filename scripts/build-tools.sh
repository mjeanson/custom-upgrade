#!/bin/bash
#
# SPDX-License-Identifier: MIT
#
# SPDX-FileCopyrightText: 2022 EfficiOS Inc.
#

set -eu

# shellcheck source=scripts/utils.sh
source "$(dirname "$0")/utils.sh"

build_tools() {
	local tools_branch=$1
	local ust_branch=$2
	local urcu_branch=$3
	local install_dir=$4

	test -d "$TOOLS_BUILD_DIR/$tools_branch" && rm -rf "${TOOLS_BUILD_DIR:?}/$tools_branch"

	mkdir -p "$TOOLS_BUILD_DIR/$tools_branch"

	export CFLAGS="-I$URCU_INSTALL_DIR/$urcu_branch/$PREFIX_DIR/include -I$UST_INSTALL_DIR/$ust_branch/$PREFIX_DIR/include"
	export CXXFLAGS="-I$URCU_INSTALL_DIR/$urcu_branch/$PREFIX_DIR/include -I$UST_INSTALL_DIR/$ust_branch/$PREFIX_DIR/include"
	export LDFLAGS="-L$URCU_INSTALL_DIR/$urcu_branch/$PREFIX_DIR/lib -L$UST_INSTALL_DIR/$ust_branch/$PREFIX_DIR/lib"
	export LD_LIBRARY_PATH="$URCU_INSTALL_DIR/$urcu_branch/$PREFIX_DIR/lib:$UST_INSTALL_DIR/$ust_branch/$PREFIX_DIR/lib"
	export PKG_CONFIG_PATH="$URCU_INSTALL_DIR/$urcu_branch/$PREFIX_DIR/lib/pkgconfig:$UST_INSTALL_DIR/$ust_branch/$PREFIX_DIR/lib/pkgconfig"

	cd "$TOOLS_BUILD_DIR/$tools_branch"
	"$TOOLS_SRC_DIR/$tools_branch/configure" --prefix="$PREFIX_DIR"

	make -j "$(nproc)"

	make install DESTDIR="$TOOLS_INSTALL_DIR/$install_dir"

	find "$TOOLS_INSTALL_DIR/$install_dir" -name '*.la' -delete
}

plan_no_plan

build_tools stable-2.13 stable-2.13-phase1 stable-0.12 stable-2.13-phase1
build_tools stable-2.13 stable-2.13-phase2 stable-0.12 stable-2.13-phase2

touch "$BUILD_DIR/.tools-stamp"
