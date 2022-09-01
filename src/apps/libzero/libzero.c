/*
 * SPDX-FileCopyrightText: 2022 EfficiOS Inc.
 *
 * SPDX-License-Identifier: MIT
 *
 */

#include <stdio.h>
#include <stdlib.h>

#include "libzero.h"

#define TRACEPOINT_DEFINE
#include "tp-libzero.h"

void trace_libzero_tptest(void) {
	fprintf(stderr, "Tracing tptest libzero... ");
	tracepoint(libzero, tptest, 1);
	tracepoint(libzero, tptest, 2);
	tracepoint(libzero, tptest, 3);
	fprintf(stderr, " done.\n");
}

void trace_libzero_before_fork(pid_t pid) {
	fprintf(stderr, "Tracing before_fork libzero... ");
	tracepoint(libzero, before_fork, pid);
	fprintf(stderr, " done.\n");
}

void trace_libzero_after_fork_parent(int pid) {
	fprintf(stderr, "Tracing after_fork_parent libzero... ");
	tracepoint(libzero, after_fork_parent, pid);
	fprintf(stderr, " done.\n");
}

void trace_libzero_after_fork_child(int pid) {
	fprintf(stderr, "Tracing after_fork_child libzero... ");
	tracepoint(libzero, after_fork_child, pid);
	fprintf(stderr, " done.\n");
}

void trace_libzero_after_exec(int pid) {
	fprintf(stderr, "Tracing after_exec libzero... ");
	tracepoint(libzero, after_exec, pid);
	fprintf(stderr, " done.\n");
}

void trace_libzero_before_close(void) {
	fprintf(stderr, "Tracing before_clone libzero... ");
	tracepoint(libzero, before_close, 1);
	fprintf(stderr, " done.\n");
}

void trace_libzero_after_close(void) {
	fprintf(stderr, "Tracing after_clone libzero... ");
	tracepoint(libzero, after_close, 1);
	fprintf(stderr, " done.\n");
}
