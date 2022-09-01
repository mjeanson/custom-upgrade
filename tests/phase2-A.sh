#!/bin/bash
#
# SPDX-License-Identifier: MIT
#
# SPDX-FileCopyrightText: 2022 EfficiOS Inc.
#

set -eu

# shellcheck source=scripts/utils.sh
source "$(dirname "$0")/../scripts/utils.sh"


export PKG_CONFIG_PATH="$PREFIX_DIR/lib/pkgconfig"
export PATH="$PATH:$PREFIX_DIR/bin:$BABELTRACE_INSTALL_DIR/stable-2.0/bin"
export LD_LIBRARY_PATH="$PREFIX_DIR/lib"

export LTTNG_HOME="$PREFIX_DIR/lttng"

# Assemble sysroot
rm -rf "$PREFIX_DIR"
cp -dpr "$SYSROOT_DIR/phase2" "$PREFIX_DIR"
cp -p "$APP_DIR/linked-both" "$PREFIX_DIR/bin"
cp -p "$APP_DIR/libzero.so" "$PREFIX_DIR/lib"
cp -p "$APP_DIR/libone.so" "$PREFIX_DIR/lib"
mkdir "$PREFIX_DIR/lttng"

export LTTNG_UST_ABORT_ON_CRITICAL=1

plan_tests 9 || true

# Start sessiond
lttng-sessiond -b >"$STDOUT" 2>"$STDERR"
ok $? "Start sessiond"

# Create session
lttng create phase2 >"$STDOUT" 2>"$STDERR"
ok $? "Create session"

lttng enable-event --userspace 'libzero:tptest' >"$STDOUT" 2>"$STDERR"
ok $? "Enable event 'libzero:tptest'"

lttng enable-event --userspace 'libone:tptest' >"$STDOUT" 2>"$STDERR"
ok $? "Enable event 'libone:tptest'"


## Test 1: soname0

# Start session
lttng start >"$STDOUT" 2>"$STDERR"
ok $? "Start session"

set +e

# Run test app
diag "Test app abort is expected"
linked-both >"$STDOUT" 2>"$STDERR"
test "$?" = 134
ok $? "Run test app"

set -e

# Stop session
lttng stop >"$STDOUT" 2>"$STDERR"
ok $? "Stop session"

# Delete trace
lttng clear >"$STDOUT" 2>"$STDERR"
ok $? "Clear session"


# Destroy session
lttng destroy phase2 >"$STDOUT" 2>"$STDERR"
ok $? "Destroy session"

# Stop sessiond
pkill lttng-sessiond
