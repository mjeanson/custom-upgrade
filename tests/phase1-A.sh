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
cp -p "$APP_DIR/basic-soname0" "$PREFIX_DIR/bin"
cp -p "$APP_DIR/basic-soname1" "$PREFIX_DIR/bin"
mkdir "$PREFIX_DIR/lttng"

plan_tests 20 || true

# Start sessiond
lttng-sessiond -b >"$STDOUT" 2>"$STDERR"
ok $? "Start sessiond"

# Create session
lttng create phase1 >"$STDOUT" 2>"$STDERR"
ok $? "Create session"

lttng enable-event --userspace 'basic:tptest' >"$STDOUT" 2>"$STDERR"
ok $? "Enable event 'basic:tptest'"


## Test 1: SONAME0

# Start session
lttng start >"$STDOUT" 2>"$STDERR"
ok $? "Start session"

# Run test app
basic-soname0 >"$STDOUT" 2>"$STDERR"
ok $? "Run test app with SONAME 0"

# Stop session
lttng stop >"$STDOUT" 2>"$STDERR"
ok $? "Stop session"

# Check for events
result=$(lttng view | grep -c 'basic:tptest:')
test "$result" = 3
ok $? "Found events for SONAME 0"

# Delete trace
lttng clear >"$STDOUT" 2>"$STDERR"
ok $? "Clear session"



## Test 2: SONAME1

# Start session
lttng start >"$STDOUT" 2>"$STDERR"
ok $? "Start session"

# Run test app
basic-soname1 >"$STDOUT" 2>"$STDERR"
ok $? "Run test app with SONAME 1"

# Stop session
lttng stop >"$STDOUT" 2>"$STDERR"
ok $? "Stop session"

# Check for events
result=$(lttng view | grep -c 'basic:tptest:')
test "$result" = 3
ok $? "Found events for SONAME 1"

# Delete trace
lttng clear >"$STDOUT" 2>"$STDERR"
ok $? "Clear session"


## Test 3: SONAME0 and SONAME1 in same session

# Start session
lttng start >"$STDOUT" 2>"$STDERR"
ok $? "Start session"

# Run test apps
basic-soname0 >"$STDOUT" 2>"$STDERR"
ok $? "Run test app with SONAME 0"
basic-soname1 >"$STDOUT" 2>"$STDERR"
ok $? "Run test app with SONAME 1"

# Stop session
lttng stop >"$STDOUT" 2>"$STDERR"
ok $? "Stop session"

# Check for events
result=$(lttng view | grep -c 'basic:tptest:')
test "$result" = 6
ok $? "Found events for SONAME 0/1"

# Delete trace
lttng clear >"$STDOUT" 2>"$STDERR"
ok $? "Clear session"


# Destroy session
lttng destroy phase1 >"$STDOUT" 2>"$STDERR"
ok $? "Destroy session"

# Stop sessiond
pkill lttng-sessiond
