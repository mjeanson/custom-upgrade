#!/bin/bash
#
# SPDX-License-Identifier: MIT
#
# SPDX-FileCopyrightText: 2022 EfficiOS Inc.
#

# shellcheck disable=SC2034

confdir="$(dirname "${BASH_SOURCE[0]}")"

STDOUT="/dev/null"
STDERR="/dev/null"

ROOT_DIR=$(readlink -f "$confdir/..")
SRC_DIR="$ROOT_DIR/src/upstream"
APPSRC_DIR="$ROOT_DIR/src/apps"
BUILD_DIR="$ROOT_DIR/build"
INSTALL_DIR="$ROOT_DIR/install"
SYSROOT_DIR="$ROOT_DIR/sysroots"
APP_DIR="$ROOT_DIR/apps"

PREFIX_DIR="/tmp/custom-upgrade"

VANILLA_URCU_REPO_URL="https://github.com/urcu/userspace-rcu.git"
URCU_SRC_DIR="$SRC_DIR/userspace-rcu"
URCU_BUILD_DIR="$BUILD_DIR/userspace-rcu"
URCU_INSTALL_DIR="$INSTALL_DIR/userspace-rcu"

VANILLA_BABELTRACE_REPO_URL="https://github.com/efficios/babeltrace.git"
BABELTRACE_SRC_DIR="$SRC_DIR/babeltrace"
BABELTRACE_BUILD_DIR="$BUILD_DIR/babeltrace"
BABELTRACE_INSTALL_DIR="$INSTALL_DIR/babeltrace"

VANILLA_UST_REPO_URL="https://github.com/lttng/lttng-ust.git"
CUSTOM_UST_REPO_URL="https://github.com/compudj/lttng-ust-dev.git"
CUSTOM_UST_BRANCH="2.13-custom-upgrade"
UST_SRC_DIR="$SRC_DIR/lttng-ust"
UST_BUILD_DIR="$BUILD_DIR/lttng-ust"
UST_INSTALL_DIR="$INSTALL_DIR/lttng-ust"

VANILLA_TOOLS_REPO_URL="https://github.com/lttng/lttng-tools.git"
CUSTOM_TOOLS_REPO_URL="https://github.com/mjeanson/lttng-tools.git"
CUSTOM_TOOLS_BRANCH="2.13-custom-upgrade"
TOOLS_SRC_DIR="$SRC_DIR/lttng-tools"
TOOLS_BUILD_DIR="$BUILD_DIR/lttng-tools"
TOOLS_INSTALL_DIR="$INSTALL_DIR/lttng-tools"
