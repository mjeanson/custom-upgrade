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
        int result;

	fprintf(stderr, "Starting app...\n");

        fprintf(stdout, "parent_pid %d\n", getpid());

	trace_libzero_before_fork(getpid());
	trace_libone_before_fork(getpid());

        result = fork();
        if (result == -1) {
                perror("fork");
                return 1;
        }

        if (result == 0) {
                char *args[] = { (char *) "afterfork-linked-both", NULL };

		trace_libzero_after_fork_child(getpid());
		trace_libone_after_fork_child(getpid());

		result = execvp("afterfork-linked-both", args);
		if (result == -1) {
			perror("execvp");
			result = 1;
			goto end;
		}
        } else {
                fprintf(stdout, "child_pid %d\n", result);

		trace_libzero_after_fork_parent(getpid());
		trace_libone_after_fork_parent(getpid());

                if (waitpid(result, NULL, 0) < 0) {
                        perror("waitpid");
                        result = 1;
                        goto end;
                }
        }
        result = 0;
end:
	fprintf(stderr, "App done\n");
        return result;

}
