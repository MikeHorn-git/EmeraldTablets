#ifndef SYSCALL_TABLE_H
#define SYSCALL_TABLE_H

#include <stddef.h>

struct syscall_entry { // NOLINT(clang-analyzer-optin.performance.Padding)
  int number;
  const char *abi;
  const char *name;
  const char *entry;
  const char *compat;
  int noreturn;
};

/* Architecture-specific syscall table */
#if defined(TARGET_ARCH_ARM)
#include "../arm/syscall.h"
#elif defined(TARGET_ARCH_ARM64_32)
#include "../arm64/syscall_32.h"
#elif defined(TARGET_ARCH_ARM64_64)
#include "../arm64/syscall_64.h"
#elif defined(TARGET_ARCH_X86_32)
#include "../x86/syscall_32.h"
#elif defined(TARGET_ARCH_X86_64)
#include "../x86/syscall_64.h"
#else
#error "Unknown target architecture"
#endif

#endif /* SYSCALL_TABLE_H */
