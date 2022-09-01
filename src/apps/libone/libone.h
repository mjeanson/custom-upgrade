/*
 * SPDX-FileCopyrightText: 2022 EfficiOS Inc.
 *
 * SPDX-License-Identifier: MIT
 *
 */

#include <sys/types.h>

void trace_libone_tptest(void);
void trace_libone_before_fork(pid_t pid);
void trace_libone_after_fork_parent(pid_t pid);
void trace_libone_after_fork_child(pid_t pid);
void trace_libone_after_exec(pid_t pid);
void trace_libone_before_close(void);
void trace_libone_after_close(void);
