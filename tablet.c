#include "include/syscall.h"
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define MAX (sizeof(syscall_tbl) / sizeof(syscall_tbl[0]))

// Table printing
void print_border(void) {
  printf("+--------+--------+----------------------+----------------------+------------+----------+\n");
}

void print_header(void) {
  print_border();
  printf("| %-6s | %-6s | %-20s | %-20s | %-10s | %-8s |\n",
         "Number", "Abi", "Name", "Entry", "Compat", "Noreturn");
  print_border();
}

void print_syscall(const typeof(*syscall_tbl) *sc) {
  printf("| %-6d | %-6s | %-20s | %-20s | %-10s | %-8d |\n",
         sc->number, sc->abi, sc->name, sc->entry, sc->compat, sc->noreturn);
}

void print_footer(void) {
  print_border();
}

void phelp(const char *progname) {
  printf("Usage: %s [-h] [-e ENTRY] [-i INT] [-n NAME]\n", progname);
}

// Generic search function
typedef enum { SEARCH_ENTRY,
               SEARCH_NAME,
               SEARCH_NUMBER } search_type_t;

int search_syscall(search_type_t type, const char *key, int number, size_t *out_idx) {
  for (size_t i = 0; i < MAX; i++) {
    switch (type) {
    case SEARCH_ENTRY:
      if (strcmp(syscall_tbl[i].entry, key) == 0) {
        *out_idx = i;
        return 1;
      }
      break;
    case SEARCH_NAME:
      if (strcmp(syscall_tbl[i].name, key) == 0) {
        *out_idx = i;
        return 1;
      }
      break;
    case SEARCH_NUMBER:
      if (syscall_tbl[i].number == number) {
        *out_idx = i;
        return 1;
      }
      break;
    }
  }
  return 0;
}

int main(int argc, char *argv[]) {
  int opt;

  while ((opt = getopt(argc, argv, "he:i:n:")) != -1) {
    size_t idx;
    int found = 0;

    switch (opt) {
    case 'e':
      found = search_syscall(SEARCH_ENTRY, optarg, 0, &idx);
      if (found) {
        print_header();
        print_syscall(&syscall_tbl[idx]);
        print_footer();
      } else {
        printf("Entry '%s' not found\n", optarg);
      }
      return EXIT_SUCCESS;

    case 'i': {
      int n = atoi(optarg);
      found = search_syscall(SEARCH_NUMBER, NULL, n, &idx);
      if (found) {
        print_header();
        print_syscall(&syscall_tbl[idx]);
        print_footer();
      } else {
        printf("Int '%d' not found\n", n);
      }
      return EXIT_SUCCESS;
    }

    case 'n':
      found = search_syscall(SEARCH_NAME, optarg, 0, &idx);
      if (found) {
        print_header();
        print_syscall(&syscall_tbl[idx]);
        print_footer();
      } else {
        printf("Name '%s' not found\n", optarg);
      }
      return EXIT_SUCCESS;

    case 'h':
    default:
      phelp(argv[0]);
      return EXIT_SUCCESS;
    }
  }

  phelp(argv[0]);
  return EXIT_SUCCESS;
}
