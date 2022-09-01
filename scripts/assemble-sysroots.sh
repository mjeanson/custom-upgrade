#!/bin/bash
#
# SPDX-License-Identifier: MIT
#
# SPDX-FileCopyrightText: 2022 EfficiOS Inc.
#

set -eu

# shellcheck source=scripts/utils.sh
source "$(dirname "$0")/utils.sh"

copy_bin() {
	local src_dir=$1
	local dest_dir=$2

	mkdir -p "$dest_dir/bin"

	cp -dp "$src_dir/bin/"* "$dest_dir/bin"
}

copy_lib() {
	local src_dir=$1
	local dest_dir=$2

	mkdir -p "$dest_dir/lib"

	cp -dp "$src_dir/lib/"*.so.* "$dest_dir/lib/"
}

copy_devel() {
	local src_dir=$1
	local dest_dir=$2

	copy_lib "$src_dir" "$dest_dir"

	mkdir -p "$dest_dir/include"
	mkdir -p "$dest_dir/lib/pkgconfig"

	cp -dp "$src_dir/lib/"*.so "$dest_dir/lib/"
	cp -dpr "$src_dir/include/"* "$dest_dir/include/"
	cp -dp "$src_dir/lib/pkgconfig/"* "$dest_dir/lib/pkgconfig/"
}

copy_tools() {
	local src_dir=$1
	local dest_dir=$2

	copy_lib "$src_dir" "$dest_dir"
	copy_bin "$src_dir" "$dest_dir"

	mkdir -p "$dest_dir/share/xml/lttng"
	cp -dp "$src_dir/share/xml/lttng/session.xsd" "$dest_dir/share/xml/lttng/"

	mkdir -p "$dest_dir/lib/lttng/libexec"
	cp -dp "$src_dir/lib/lttng/libexec/lttng-consumerd" "$dest_dir/lib/lttng/libexec/"
}

plan_no_plan

# Phase0:
#  - urcu 0.9
#  - ust-2.12
rm -rf "$SYSROOT_DIR/phase0"
copy_devel "$URCU_INSTALL_DIR/stable-0.9/$PREFIX_DIR" "$SYSROOT_DIR/phase0"
copy_devel "$UST_INSTALL_DIR/stable-2.12/$PREFIX_DIR" "$SYSROOT_DIR/phase0"


# Phase 1:
#  - urcu 0.9 (runtime lib only)
#  - ust-2.12 (runtime lib only)
#  - urcu 0.12
#  - ust-2.13 (phase1)
#  - tools-2.13 (phase1)
rm -rf "$SYSROOT_DIR/phase1"
copy_lib "$URCU_INSTALL_DIR/stable-0.9/$PREFIX_DIR" "$SYSROOT_DIR/phase1"
copy_lib "$UST_INSTALL_DIR/stable-2.12/$PREFIX_DIR" "$SYSROOT_DIR/phase1"

copy_devel "$URCU_INSTALL_DIR/stable-0.12/$PREFIX_DIR" "$SYSROOT_DIR/phase1"
copy_devel "$UST_INSTALL_DIR/stable-2.13-phase1/$PREFIX_DIR" "$SYSROOT_DIR/phase1"

copy_tools "$TOOLS_INSTALL_DIR/stable-2.13-phase1/$PREFIX_DIR" "$SYSROOT_DIR/phase1"


# Phase 2:
#  - urcu 0.9 (runtime lib only)
#  - ust-2.12 (runtime lib only)
#  - urcu 0.12
#  - ust-2.13 (phase2)
#  - tools-2.13 (phase2)
rm -rf "$SYSROOT_DIR/phase2"
copy_lib "$URCU_INSTALL_DIR/stable-0.9/$PREFIX_DIR" "$SYSROOT_DIR/phase2"
copy_lib "$UST_INSTALL_DIR/stable-2.12/$PREFIX_DIR" "$SYSROOT_DIR/phase2"

copy_devel "$URCU_INSTALL_DIR/stable-0.12/$PREFIX_DIR" "$SYSROOT_DIR/phase2"
copy_devel "$UST_INSTALL_DIR/stable-2.13-phase2/$PREFIX_DIR" "$SYSROOT_DIR/phase2"

copy_tools "$TOOLS_INSTALL_DIR/stable-2.13-phase2/$PREFIX_DIR" "$SYSROOT_DIR/phase2"

touch "$SYSROOT_DIR/.sysroots-stamp"
