/*
 * SPDX-FileCopyrightText: 2022 EfficiOS Inc.
 *
 * SPDX-License-Identifier: MIT
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>

#include "../libzero/libzero.h"
#include "../libone/libone.h"

int main(void) {
	fprintf(stderr, "After exec\n");

	trace_libzero_after_exec(getpid());
	trace_libone_after_exec(getpid());

	return EXIT_SUCCESS;
}
