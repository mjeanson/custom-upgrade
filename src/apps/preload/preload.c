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
	int ret = EXIT_SUCCESS;
	void *ptr = NULL;

	fprintf(stderr, "Tracing... ");
	tracepoint(preload, tptest, 1);

	ptr = malloc(42);

	if (ptr == NULL) {
		ret = EXIT_FAILURE;
		goto end;
	} else {
		free(ptr);
	}

	tracepoint(preload, tptest, 2);
	fprintf(stderr, " done.\n");

end:
	return ret;
}
