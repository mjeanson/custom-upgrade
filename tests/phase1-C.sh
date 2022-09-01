#!/bin/bash
#
# SPDX-License-Identifier: MIT
#
# SPDX-FileCopyrightText: 2022 EfficiOS Inc.
#

set -eu

#set -x

# shellcheck source=scripts/utils.sh
source "$(dirname "$0")/../scripts/utils.sh"

export PKG_CONFIG_PATH="$PREFIX_DIR/lib/pkgconfig"
export PATH="$PATH:$PREFIX_DIR/bin:$BABELTRACE_INSTALL_DIR/stable-2.0/bin"
export LD_LIBRARY_PATH="$PREFIX_DIR/lib"

export LTTNG_HOME="$PREFIX_DIR/lttng"

# Assemble sysroot
rm -rf "$PREFIX_DIR"
cp -dpr "$SYSROOT_DIR/phase1" "$PREFIX_DIR"
cp -p "$APP_DIR/fork-linked-both" "$PREFIX_DIR/bin"
cp -p "$APP_DIR/afterfork-linked-both" "$PREFIX_DIR/bin"
cp -p "$APP_DIR/libzero.so" "$PREFIX_DIR/lib"
cp -p "$APP_DIR/libone.so" "$PREFIX_DIR/lib"
mkdir "$PREFIX_DIR/lttng"

plan_tests 16 || true

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

lttng add-context --userspace --type=vpid --type=procname >"$STDOUT" 2>"$STDERR"
ok $? "Enable 'vpid' and 'procname' contexts"


## Test 1: soname0

# Start session
lttng start >"$STDOUT" 2>"$STDERR"
ok $? "Start session"

# Run test app
export LD_PRELOAD="liblttng-ust-fork.so.1"
output=$(fork-linked-both 2>"$STDERR")
ok $? "Run app"
unset LD_PRELOAD

# Stop session
lttng stop >"$STDOUT" 2>"$STDERR"
ok $? "Stop session"


parent_pid=$(echo "$output" | sed -n 's/parent_pid \([0-9]*\)/\1/p')
child_pid=$(echo "$output" | sed -n 's/child_pid \([0-9]*\)/\1/p')

# Check for events
result=$(lttng view | grep -c "libzero:before_fork.*vpid = $parent_pid")
test "$result" = 1
ok $? "Found libzero before_fork parent pid"

result=$(lttng view | grep -c "libzero:after_fork_parent.*vpid = $parent_pid")
test "$result" = 1
ok $? "Found libzero after_fork_parent parent pid"

result=$(lttng view | grep -c "libzero:after_fork_child.*vpid = $child_pid")
test "$result" = 1
ok $? "Found libzero after_fork_child child pid"

result=$(lttng view | grep -c "libone:before_fork.*vpid = $parent_pid")
test "$result" = 1
ok $? "Found libone before_fork parent pid"

result=$(lttng view | grep -c "libone:after_fork_parent.*vpid = $parent_pid")
test "$result" = 1
ok $? "Found libone after_fork_parent parent pid"

result=$(lttng view | grep -c "libone:after_fork_child.*vpid = $child_pid")
test "$result" = 1
ok $? "Found libone after_fork_child child pid"

# Delete trace
lttng clear >"$STDOUT" 2>"$STDERR"
ok $? "Clear session"


# Destroy session
lttng destroy phase1 >"$STDOUT" 2>"$STDERR"
ok $? "Destroy session"

# Stop sessiond
pkill lttng-sessiond
