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

	trace_libzero_tptest();
	trace_libone_tptest();

	fprintf(stderr, "App done.\n");

	return EXIT_SUCCESS;
}
