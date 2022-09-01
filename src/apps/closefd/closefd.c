/*
 * SPDX-FileCopyrightText: 2022 EfficiOS Inc.
 *
 * SPDX-License-Identifier: MIT
 *
 */

#include <stdio.h>
#include <stdlib.h>

#include "../libzero/libzero.h"
#include "../libone/libone.h"

int main(void) {
	fprintf(stderr, "Starting app...\n");

	trace_libzero_before_close();
	trace_libone_before_close();

	for (int i=3; i<65536; i++) {
		close(i);
	}

	trace_libzero_after_close();
	trace_libone_after_close();

	fprintf(stderr, "App done.\n");

	return EXIT_SUCCESS;
}
