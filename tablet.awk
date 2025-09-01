#!/usr/bin/env awk -f
#
# Usage: awk -f tablet.awk file.tbl

BEGIN {
    print "/* Auto-generated from syscall.tbl */"
    print "/* <number> <abi> <name> <entry point> [<compat entry point> [noreturn]] */"
    print ""
    print "#include \"include/syscall.h\""
    print ""
    print "static const struct syscall_entry syscall_tbl[] = {"
}

# Skip comments and empty lines
/^[ \t]*#/ || NF == 0 { next }

{
    # Determine compat field: NULL if missing or "-"
    compat = (NF >= 5 && $5 != "-" ? "\"" $5 "\"" : "NULL")
    # Determine noreturn: 1 if 6th field exists, else 0
    noreturn = (NF >= 6 ? "1" : "0")
    printf("    {%d, \"%s\", \"%s\", \"%s\", %s, %s},\n", $1, $2, $3, $4, compat, noreturn)
}

END {
    print "};"
}
