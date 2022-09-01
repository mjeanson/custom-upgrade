/*
 * SPDX-FileCopyrightText: 2022 EfficiOS Inc.
 *
 * SPDX-License-Identifier: MIT
 *
 */

#undef TRACEPOINT_PROVIDER
#define TRACEPOINT_PROVIDER libzero

#if !defined(_TRACEPOINT_TP_H) || defined(TRACEPOINT_HEADER_MULTI_READ)
#define _TRACEPOINT_TP_H

#include <lttng/tracepoint.h>
#include <sys/types.h>

TRACEPOINT_EVENT(libzero, tptest,
	TP_ARGS(int, anint),
	TP_FIELDS(
		ctf_integer(int, intfield, anint)
	)
)

TRACEPOINT_EVENT(libzero, before_fork,
	TP_ARGS(pid_t, pid),
	TP_FIELDS(
		ctf_integer(pid_t, pid, pid)
	)
)

TRACEPOINT_EVENT(libzero, after_fork_child,
	TP_ARGS(pid_t, pid),
	TP_FIELDS(
		ctf_integer(pid_t, pid, pid)
	)
)

TRACEPOINT_EVENT(libzero, after_fork_parent,
	TP_ARGS(pid_t, pid),
	TP_FIELDS(
		ctf_integer(pid_t, pid, pid)
	)
)

TRACEPOINT_EVENT(libzero, after_exec,
	TP_ARGS(pid_t, pid),
	TP_FIELDS(
		ctf_integer(pid_t, pid, pid)
	)
)

TRACEPOINT_EVENT(libzero, before_close,
	TP_ARGS(int, anint),
	TP_FIELDS(
		ctf_integer(int, intfield, anint)
	)
)

TRACEPOINT_EVENT(libzero, after_close,
	TP_ARGS(int, anint),
	TP_FIELDS(
		ctf_integer(int, intfield, anint)
	)
)

#endif /* _TRACEPOINT_TP_H */

#undef TRACEPOINT_INCLUDE
#define TRACEPOINT_INCLUDE "./tp-libzero.h"

/* This part must be outside ifdef protection */
#include <lttng/tracepoint-event.h>
