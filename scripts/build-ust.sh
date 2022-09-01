#!/bin/bash
#
# SPDX-License-Identifier: MIT
#
# SPDX-FileCopyrightText: 2022 EfficiOS Inc.
#

set -eu

# shellcheck source=scripts/utils.sh
source "$(dirname "$0")/utils.sh"

build_ust() {
	local ust_branch=$1
	local urcu_branch=$2
	local install_dir=$3
	local conf_opt=$4

	test -d "$UST_BUILD_DIR/$ust_branch" && rm -rf "${UST_BUILD_DIR:?}/$ust_branch"

	mkdir -p "$UST_BUILD_DIR/$ust_branch"

	export CFLAGS="-I$URCU_INSTALL_DIR/$urcu_branch/$PREFIX_DIR/include"
	export CXXFLAGS="-I$URCU_INSTALL_DIR/$urcu_branch/$PREFIX_DIR/include"
	export LDFLAGS="-L$URCU_INSTALL_DIR/$urcu_branch/$PREFIX_DIR/lib"
	export LD_LIBRARY_PATH="$URCU_INSTALL_DIR/$urcu_branch/$PREFIX_DIR/lib"
	export PKG_CONFIG_PATH="$URCU_INSTALL_DIR/$urcu_branch/$PREFIX_DIR/lib/pkgconfig"

	if [ "$install_dir" = "stable-2.13-phase1" ]; then
		if [ -d "$PREFIX_DIR" ]; then
		       	rm -rf "$PREFIX_DIR"
		fi

		mkdir -p "$PREFIX_DIR/lib"

		cp -p "$UST_INSTALL_DIR/stable-2.12/$PREFIX_DIR/lib/"*.so.* "$PREFIX_DIR/lib"

		# stable-2.12 required to link the ld preload wrappers
		export LDFLAGS="$LDFLAGS -L$PREFIX_DIR/lib"
	fi

	cd "$UST_BUILD_DIR/$ust_branch"
	"$UST_SRC_DIR/$ust_branch/configure" --prefix="$PREFIX_DIR" $conf_opt

	make -j "$(nproc)"

	make check

	make install DESTDIR="$UST_INSTALL_DIR/$install_dir"

	find "$UST_INSTALL_DIR/$install_dir" -name '*.la' -delete

	if [ -d "$PREFIX_DIR" ]; then
	       	rm -rf "$PREFIX_DIR"
	fi
}

plan_no_plan

build_ust stable-2.12 stable-0.9 stable-2.12 ""
build_ust stable-2.13 stable-0.12 stable-2.13-phase1 ""
build_ust stable-2.13 stable-0.12 stable-2.13-phase2 "--enable-custom-upgrade-conflicting-symbols"

touch "$BUILD_DIR/.ust-stamp"
