#!/bin/bash
#
# SPDX-License-Identifier: MIT
#
# SPDX-FileCopyrightText: 2022 EfficiOS Inc.
#

set -eu

# shellcheck source=scripts/utils.sh
source "$(dirname "$0")/utils.sh"

plan_no_plan

test -d "$SRC_DIR" && rm -rf "$SRC_DIR"
mkdir "$SRC_DIR"

test -d "$URCU_SRC_DIR" || mkdir "$URCU_SRC_DIR"

diag " Clone userspace-rcu 0.9 for ust-2.12"
git clone "$VANILLA_URCU_REPO_URL" -b "stable-0.9" "$URCU_SRC_DIR/stable-0.9"
(cd "$URCU_SRC_DIR/stable-0.9" && ./bootstrap)

diag "Clone userspace-rcu 0.12 for ust-2.13 and tools-2.13"
git clone "$VANILLA_URCU_REPO_URL" -b "stable-0.12" "$URCU_SRC_DIR/stable-0.12"
(cd "$URCU_SRC_DIR/stable-0.12" && ./bootstrap)

test -d "$BABELTRACE_SRC_DIR" || mkdir "$BABELTRACE_SRC_DIR"

diag "Clone babeltrace 2.0"
git clone "$VANILLA_BABELTRACE_REPO_URL" -b "stable-2.0" "$BABELTRACE_SRC_DIR/stable-2.0"
(cd "$BABELTRACE_SRC_DIR/stable-2.0" && ./bootstrap)

test -d "$UST_SRC_DIR" || mkdir "$UST_SRC_DIR"

diag "Clone lttng-ust 2.12 and patch it to use userspace-rcu 0.9"
git clone "$VANILLA_UST_REPO_URL" -b "stable-2.12" "$UST_SRC_DIR/stable-2.12"
GIT_COMMITTER_NAME="Michael Jeanson" GIT_COMMITTER_EMAIL="mjeanson@efficios.com" git -C "$UST_SRC_DIR/stable-2.12" am < patches/decrease-liburcu-dependency-to-0.9.patch
(cd "$UST_SRC_DIR/stable-2.12" && ./bootstrap)

diag "Clone lttng-ust 2.13 custom upgrade branch"
git clone "$CUSTOM_UST_REPO_URL" -b "$CUSTOM_UST_BRANCH" "$UST_SRC_DIR/stable-2.13"
(cd "$UST_SRC_DIR/stable-2.13" && ./bootstrap)

diag "Clone lttng-tools 2.13 custom upgrade branch"
git clone "$CUSTOM_TOOLS_REPO_URL" -b "$CUSTOM_TOOLS_BRANCH" "$TOOLS_SRC_DIR/stable-2.13"
(cd "$TOOLS_SRC_DIR/stable-2.13" && ./bootstrap)

touch "$SRC_DIR/.clone-stamp"
