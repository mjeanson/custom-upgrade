#!/bin/bash
#
# SPDX-License-Identifier: MIT
#
# SPDX-FileCopyrightText: 2022 EfficiOS Inc.
#

set -eu

# shellcheck source=config/config.sh
source "$(dirname "$0")/../config/config.sh"

# shellcheck source=scripts/tap.sh
source "$ROOT_DIR/scripts/tap.sh"

# We set the default lttng-sessiond path to /bin/true to prevent the spawning
# of a daemonized sessiond. This is necessary since 'lttng create' will spawn
# its own sessiond if none is running. It also ensures that 'lttng create'
# fails when no sessiond is running.
export LTTNG_SESSIOND_PATH="/bin/true"


trap_cleanup()
{
	# TODO
	true
}

trap trap_cleanup SIGINT SIGTERM
