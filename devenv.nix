{ pkgs, ... }:

{
  # https://devenv.sh/packages/
  packages = [ pkgs.git pkgs.compiledb ];

  # https://devenv.sh/languages/
  languages.c.enable = true;

  # https://devenv.sh/tasks/
  tasks = {
    "compiledb:run".exec = "compiledb -n make tablet";
    "lint:run".exec = ''
      git ls-files --cached --others --exclude-standard '*.c' '*.h' | xargs clang-format -i
       clang-tidy tablet.c src/include/syscall.h -- -Isrc -Isrc/include -DTARGET_ARCH_X86_64
       git ls-files --cached --others --exclude-standard 'Makefile'
       mdformat README.md
       git ls-files --cached --others --exclude-standard '*.nix' | xargs nixfmt'';
  };

  # https://devenv.sh/git-hooks/
  git-hooks.excludes = [ ".devenv" ];
  git-hooks.hooks = {
    checkmake.enable = true;
    clang-format.enable = true;
    #clang-tidy.enable = true;
    mdformat.enable = true;
    nixfmt-classic.enable = true;
    trim-trailing-whitespace.enable = true;
  };

  # See full reference at https://devenv.sh/reference/options/
}
