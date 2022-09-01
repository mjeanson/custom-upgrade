/*
 * SPDX-FileCopyrightText: 2022 EfficiOS Inc.
 *
 * SPDX-License-Identifier: MIT
 *
 */

#include <stdio.h>
#include <stdlib.h>

#define TRACEPOINT_DEFINE
#include "tp.h"

int main(void) {
	fprintf(stderr, "Tracing... ");
	tracepoint(basic, tptest, 1);
	tracepoint(basic, tptest, 2);
	tracepoint(basic, tptest, 3);
	fprintf(stderr, " done.\n");

	return EXIT_SUCCESS;
}
