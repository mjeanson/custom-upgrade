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
cp -p "$APP_DIR/basic-phase2" "$PREFIX_DIR/bin"
mkdir "$PREFIX_DIR/lttng"

plan_tests 9 || true

# Start sessiond
lttng-sessiond -b >"$STDOUT" 2>"$STDERR"
ok $? "Start sessiond"

# Create session
lttng create phase2 >"$STDOUT" 2>"$STDERR"
ok $? "Create session"

lttng enable-event --userspace 'basic:tptest' >"$STDOUT" 2>"$STDERR"
ok $? "Enable event 'basic:tptest'"

# Start session
lttng start >"$STDOUT" 2>"$STDERR"
ok $? "Start session"

# Run test app
basic-phase2 >"$STDOUT" 2>"$STDERR"
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

# Destroy session
lttng destroy phase2 >"$STDOUT" 2>"$STDERR"
ok $? "Destroy session"

# Stop sessiond
pkill lttng-sessiond
