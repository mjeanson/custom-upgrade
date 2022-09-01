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
cp -dpr "$SYSROOT_DIR/phase1" "$PREFIX_DIR"
cp -p "$APP_DIR/closefd" "$PREFIX_DIR/bin"
cp -p "$APP_DIR/libzero.so" "$PREFIX_DIR/lib"
cp -p "$APP_DIR/libone.so" "$PREFIX_DIR/lib"
mkdir "$PREFIX_DIR/lttng"

plan_tests 13 || true

diag "Test liblttng-ust-fd.so interposition for closefd"

# Start sessiond
lttng-sessiond -b >"$STDOUT" 2>"$STDERR"
ok $? "Start sessiond"

# Create session
lttng create phase1 >"$STDOUT" 2>"$STDERR"
ok $? "Create session"

lttng enable-event --userspace 'libzero:*' >"$STDOUT" 2>"$STDERR"
ok $? "Enable event 'libzero:*'"

lttng enable-event --userspace 'libone:*' >"$STDOUT" 2>"$STDERR"
ok $? "Enable event 'libone:*'"


## Test 1: soname0

# Start session
lttng start >"$STDOUT" 2>"$STDERR"
ok $? "Start session"

# Run test app
export LD_PRELOAD="liblttng-ust-fd.so.1"
closefd >"$STDOUT" 2>"$STDERR"
ok $? "Run test app"
unset LD_PRELOAD

# Stop session
lttng stop >"$STDOUT" 2>"$STDERR"
ok $? "Stop session"

# Check for events
result=$(lttng view | grep -c 'libzero:before_close:')
test "$result" = 1
ok $? "Found before_close event for SONAME 0"

result=$(lttng view | grep -c 'libzero:after_close:')
test "$result" = 1
ok $? "Found after_close event for SONAME 0"

result=$(lttng view | grep -c 'libone:before_close:')
test "$result" = 1
ok $? "Found before_close event for SONAME 1"

result=$(lttng view | grep -c 'libone:after_close:')
test "$result" = 1
ok $? "Found after_close event for SONAME 1"

# Delete trace
lttng clear >"$STDOUT" 2>"$STDERR"
ok $? "Clear session"


# Destroy session
lttng destroy phase1 >"$STDOUT" 2>"$STDERR"
ok $? "Destroy session"

# Stop sessiond
pkill lttng-sessiond
