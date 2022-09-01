/*
 * SPDX-FileCopyrightText: 2022 EfficiOS Inc.
 *
 * SPDX-License-Identifier: MIT
 *
 */

#include <stdio.h>
#include <stdlib.h>

#include "libone.h"

#define TRACEPOINT_DEFINE
#include "tp-libone.h"

void trace_libone_tptest(void) {
	fprintf(stderr, "Tracing tptest libone... ");
	tracepoint(libone, tptest, 1);
	tracepoint(libone, tptest, 2);
	tracepoint(libone, tptest, 3);
	fprintf(stderr, " done.\n");
}

void trace_libone_before_fork(pid_t pid) {
	fprintf(stderr, "Tracing before_fork libone... ");
	tracepoint(libone, before_fork, pid);
	fprintf(stderr, " done.\n");
}

void trace_libone_after_fork_parent(int pid) {
	fprintf(stderr, "Tracing after_fork_parent libone... ");
	tracepoint(libone, after_fork_parent, pid);
	fprintf(stderr, " done.\n");
}

void trace_libone_after_fork_child(int pid) {
	fprintf(stderr, "Tracing after_fork_child libone... ");
	tracepoint(libone, after_fork_child, pid);
	fprintf(stderr, " done.\n");
}

void trace_libone_after_exec(int pid) {
	fprintf(stderr, "Tracing after_exec libone... ");
	tracepoint(libone, after_exec, pid);
	fprintf(stderr, " done.\n");
}

void trace_libone_before_close(void) {
	fprintf(stderr, "Tracing before_clone libone... ");
	tracepoint(libone, before_close, 1);
	fprintf(stderr, " done.\n");
}

void trace_libone_after_close(void) {
	fprintf(stderr, "Tracing after_clone libone... ");
	tracepoint(libone, after_close, 1);
	fprintf(stderr, " done.\n");
}
