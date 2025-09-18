# Emerald Tablets

![image](https://symbolsage.com/wp-content/uploads/2021/04/emerald-tablet-of-toth-depiction-768x644.jpg)

## Table of content

- [Tree](https://github.com/MikeHorn-git/EmeraldTablets#tree)
- [Installation](https://github.com/MikeHorn-git/EmeraldTablets#installation)
- [Headers](https://github.com/MikeHorn-git/EmeraldTablets#headers)
- [Tablet](https://github.com/MikeHorn-git/EmeraldTablets#tablet)
- [Makefile](https://github.com/MikeHorn-git/EmeraldTablets#makefile)

## Tree

- **`src/`**

  - `src/include/syscall.h` - Main header
  - `src/arm/`, `src/arm64/`, `src/x86/` - Arch-specific syscall headers

- **`tbl/`** — **Kernel table files (`*.tbl`)**

  - `tbl/arm/syscall.tbl`
  - `tbl/arm64/syscall_32.tbl`, `syscall_64.tbl`
  - `tbl/x86/syscall_32.tbl`, `syscall_64.tbl`

## Installation

```bash
git clone https://github.com/MikeHorn-git/EmeraldTablets
cd EmeraldTablets/
```

## Headers

```bash
make all
```

### Format

> [!Note]
> Follow kernel [syscall.tbl](https://github.com/search?q=repo%3Atorvalds%2Flinux%20path%3Asyscall_64.tbl&type=code) files format.

`<number> <abi> <name> <entry point> [<compat entry point> [noreturn]]`

### Struct

```c
struct syscall_entry {
  int number;
  const char *abi;
  const char *name;
  const char *entry;
  const char *compat;
  int noreturn;
};
```

## Tablet

```bash
make tablet
```

Userland syscall table helper.

```bash
Usage: ./tablet [-h] [-e ENTRY] [-i INT] [-n NAME]
```

## Makefile

```bash
Usage: make <target>
Targets:
  help            Show this help message
  all             Builds all headers
  tablet          Build tablet sample
  arm             Build only arm headers
  arm64           Build only arm64 headers
  x86             Build only x86 headers
  clean           Delete generated headers
```
