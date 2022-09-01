#!/bin/bash
#
# SPDX-License-Identifier: MIT
#
# SPDX-FileCopyrightText: 2022 EfficiOS Inc.
#

set -eu

# shellcheck source=scripts/utils.sh
source "$(dirname "$0")/utils.sh"

export PKG_CONFIG_PATH="$PREFIX_DIR/lib/pkgconfig"

mkdir -p "$APP_DIR"

build_app() {
	local sysroot=$1
	local app_name=$2
	local out_name=$3

	rm -rf "$PREFIX_DIR"
	cp -dpr "$SYSROOT_DIR/$sysroot" "$PREFIX_DIR"

	if [[ $out_name = *soname0 ]]; then
		EXTRA_LIBS="-lurcu-bp"
	fi

	make -C "$APPSRC_DIR/$app_name" \
		LDLIBS="$(pkg-config --libs-only-l lttng-ust) $EXTRA_LIBS" \
		CPPFLAGS="-I. $(pkg-config --cflags-only-I lttng-ust)" \
		LDFLAGS="$(pkg-config --libs-only-L lttng-ust)" \
		>"$STDOUT" 2>"$STDERR"

	cp "$APPSRC_DIR/$app_name/$app_name" "$APP_DIR/$out_name"

	make -C "$APPSRC_DIR/$app_name" clean \
		>"$STDOUT" 2>"$STDERR"
}

build_linked_app() {
	local sysroot=$1
	local name=$2

	rm -rf "$PREFIX_DIR"
	cp -dpr "$SYSROOT_DIR/$sysroot" "$PREFIX_DIR"

	make -C "$APPSRC_DIR/$name" \
		LDFLAGS="-L$PREFIX_DIR/lib -L$APP_DIR" \
		LD_LIBRARY_PATH="$PREFIX_DIR/lib" \
		>"$STDOUT" 2>"$STDERR"

	cp "$APPSRC_DIR/$name/$name" "$APP_DIR/"

	make -C "$APPSRC_DIR/$name" clean \
		>"$STDOUT" 2>"$STDERR"
}

build_lib() {
	local sysroot=$1
	local name=$2

	rm -rf "$PREFIX_DIR"
	cp -dpr "$SYSROOT_DIR/$sysroot" "$PREFIX_DIR"

	if [ "$name" = "libzero" ]; then
		EXTRA_LIBS="-lurcu-bp"
	fi

	make -C "$APPSRC_DIR/$name" \
		LDLIBS="$(pkg-config --libs-only-l lttng-ust) $EXTRA_LIBS" \
		CPPFLAGS="-I. $(pkg-config --cflags-only-I lttng-ust)" \
		LDFLAGS="$(pkg-config --libs-only-L lttng-ust)" \
		>"$STDOUT" 2>"$STDERR"

	cp "$APPSRC_DIR/$name/$name.so" "$APP_DIR/"

	make -C "$APPSRC_DIR/$name" clean \
		>"$STDOUT" 2>"$STDERR"
}

plan_no_plan

diag "Build basic app with SONAME 0"
build_app phase0 basic basic-soname0

diag "Build basic app with SONAME 1"
build_app phase1 basic basic-soname1

diag "Build lib with SONAME 0"
build_lib phase0 libzero

diag "Build preload app with SONAME 0"
build_app phase0 preload preload-soname0

diag "Build lib with SONAME 1"
build_lib phase1 libone

diag "Build app linked with both"
build_linked_app phase1 linked-both

diag "Build fork app linked with both"
build_linked_app phase1 fork-linked-both

diag "Build afterfork app linked with both"
build_linked_app phase1 afterfork-linked-both

diag "Build closefd app linked with both"
build_linked_app phase1 closefd

diag "Build basic app for phase2"
build_app phase2 basic basic-phase2

touch "$APP_DIR/.apps-stamp"
