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
cp -p "$APP_DIR/preload-soname0" "$PREFIX_DIR/bin"
mkdir "$PREFIX_DIR/lttng"

plan_tests 17 || true

# Start sessiond
lttng-sessiond -b >"$STDOUT" 2>"$STDERR"
ok $? "Start sessiond"

# Create session
lttng create phase1 >"$STDOUT" 2>"$STDERR"
ok $? "Create session"

lttng enable-event --userspace 'preload:tptest' >"$STDOUT" 2>"$STDERR"
ok $? "Enable event 'preload:tptest'"

lttng enable-event --userspace 'lttng_ust_libc:*' >"$STDOUT" 2>"$STDERR"
ok $? "Enable event 'lttng_ust_libc:*'"


## Test 1: app without preload

# Start session
lttng start >"$STDOUT" 2>"$STDERR"
ok $? "Start session"

# Run test app
preload-soname0 >"$STDOUT" 2>"$STDERR"
ok $? "Run test app"

# Stop session
lttng stop >"$STDOUT" 2>"$STDERR"
ok $? "Stop session"

# Check for events
result=$(lttng view | grep -c 'preload:tptest:')
test "$result" = 2
ok $? "Found app events without preload"

result=$(lttng view | grep -c 'lttng_ust_libc:' || true)
test "$result" = 0
ok $? "Found no preload events without preload"

# Delete trace
lttng clear >"$STDOUT" 2>"$STDERR"
ok $? "Clear session"


## Test 2: app with preload

# Start session
lttng start >"$STDOUT" 2>"$STDERR"
ok $? "Start session"

# Run test app
export LD_PRELOAD="liblttng-ust-libc-wrapper.so.1"
preload-soname0 >"$STDOUT" 2>"$STDERR"
ok $? "Run test app"
unset LD_PRELOAD

# Stop session
lttng stop >"$STDOUT" 2>"$STDERR"
ok $? "Stop session"

# Check for events
result=$(lttng view | grep -c 'preload:tptest:')
test "$result" = 2
ok $? "Found app events with preload"

result=$(lttng view | grep -c 'lttng_ust_libc:malloc:.*size = 42')
test "$result" = 1
ok $? "Found single preload malloc() event with preload"

# Delete trace
lttng clear >"$STDOUT" 2>"$STDERR"
ok $? "Clear session"


# Destroy session
lttng destroy phase1 >"$STDOUT" 2>"$STDERR"
ok $? "Destroy session"

# Stop sessiond
pkill lttng-sessiond
