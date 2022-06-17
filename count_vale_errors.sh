#!/bin/sh
#
# Copyright (c) 2021 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#
# `$ chmod u+rx scriptname` https://tldp.org/LDP/abs/html/abs-guide.html#SHA-BANG > 2.1. Invoking the script

set -e
# already covered in get_vale_styles.sh

vale -v
# https://docs.errata.ai/vale/cli#--version

echo "= Breakdown of vale infringements per module"
# https://www.gnu.org/software/coreutils/manual/html_node/echo-invocation.html
# https://www.gnu.org/software/coreutils/manual/html_node/printf-invocation.html
for module in modules/*
# We have the following directories in the https://github.com/eclipse-che/che-docs/tree/main/modules directory:
#   administration-guide
#   end-user-guide
#   extensions
#   glossary
#   hosted-che
#   overview
# https://raw.githubusercontent.com/max-cx/bash-pd/main/bash_manual.txt
# 'reserved word'
#    A 'word' that has a special meaning to the shell.  Most reserved
#    words introduce shell flow control constructs, such as 'for' and
#    'while'.
# 3.2.1 Reserved Words
# Reserved words are words that have special meaning to the shell.  They
# are used to begin and end the shell's compound commands.
# The following words are recognized as reserved when unquoted and the
# first word of a command (see below for exceptions):
# 'if'    'then'  'elif'  'else'  'fi'      'time'
# 'for'   'in'    'until' 'while' 'do'      'done'
# 'case'  'esac'  'coproc''select''function'
# '{'     '}'     '[['    ']]'    '!'
#
# 'for'
#    The syntax of the 'for' command is:
#         for NAME [ [in [WORDS ...] ] ; ] do COMMANDS; done
#    Expand WORDS (*note Shell Expansions::), and execute COMMANDS once
#    for each member in the resultant list, with NAME bound to the
#    current member.  If 'in WORDS' is not present, the 'for' command
#    executes the COMMANDS once for each positional parameter that is
#    set, as if 'in "$@"' had been specified (*note Special
#    Parameters::).
#    The return status is the exit status of the last command that
#    executes.  If there are no items in the expansion of WORDS, no
#    commands are executed, and the return status is zero.
#    An alternate form of the 'for' command is also supported:
#          for (( EXPR1 ; EXPR2 ; EXPR3 )) ; do COMMANDS ; done
#    First, the arithmetic expression EXPR1 is evaluated according to
#    the rules described below (*note Shell Arithmetic::).  The
#    arithmetic expression EXPR2 is then evaluated repeatedly until it
#    evaluates to zero.  Each time EXPR2 evaluates to a non-zero value,
#    COMMANDS are executed and the arithmetic expression EXPR3 is
#    evaluated.  If any expression is omitted, it behaves as if it
#    evaluates to 1.  The return value is the exit status of the last
#    command in COMMANDS that is executed, or false if any of the
#    expressions is invalid.
     
    do
#    bash_manual.txt
#    see description of 'for' above
#    3.2.1 Reserved Words
#    'in' and 'do' are recognized as reserved
#    words if they are the third word in a 'for' command.
#    (repeating from above) The syntax of the 'for' command is:
#      for NAME [ [in [WORDS ...] ] ; ] do COMMANDS; done
#    (repeating from above) An alternate form of the 'for' command is also supported:
#      for (( EXPR1 ; EXPR2 ; EXPR3 )) ; do COMMANDS ; done
    printf "== %s\n" "$module"
#    'printf'
#         printf [-v VAR] FORMAT [ARGUMENTS]
#    Write the formatted ARGUMENTS to the standard output under the
#    control of the FORMAT.  The '-v' option causes the output to be
#    assigned to the variable VAR rather than being printed to the
#    standard output.
#    see more info about it on the lines that follow in  4.2 Bash Builtin Commands:#    ...
#    'printf' is a shell builtin, and
#    therefore is not subject to the kernel's limit on the number of
#    arguments to a program.
#   * The 'printf' builtin is available to display formatted output
#    (*note Bash Builtins::).
#   "== %s\n" means the following:
#    FORMAT (see description of 'printf' above: printf [-v VAR] FORMAT [ARGUMENTS])
#    When the '==' and '!=' operators are used, the string to the right
#    of the operator is considered a pattern and matched according to
#    the rules described below in *note Pattern Matching::, as if the
#    'extglob' shell option were enabled.  The '=' operator is identical
#    to '=='.
#    3.1.2.1 Escape Character
#    A non-quoted backslash '\' is the Bash escape character.  It preserves
#    the literal value of the next character that follows, with the exception
#    of 'newline'.  If a '\newline' pair appears, and the backslash itself is
#    not quoted, the '\newline' is treated as a line continuation (that is,
#    it is removed from the input stream and effectively ignored).
#    3.1.2.4 ANSI-C Quoting
#    '\n'
#    newline
#    3.1.2.3 Double Quotes
#    Enclosing characters in double quotes ('"') preserves the literal value
#    of all characters within the quotes, with the exception of '$', '`',
#    '\', and, when history expansion is enabled, '!'.  When the shell is in
#    POSIX mode (*note Bash POSIX Mode::), the '!' has no special meaning
#    within double quotes, even when history expansion is enabled.  The
#    characters '$' and '`' retain their special meaning within double quotes
#    (*note Shell Expansions::).  The backslash retains its special meaning
#    only when followed by one of the following characters: '$', '`', '"',
#    '\', or 'newline'.  Within double quotes, backslashes that are followed
#    by one of these characters are removed.  Backslashes preceding
#    characters without a special meaning are left unmodified.  A double
#    quote may be quoted within double quotes by preceding it with a
#    backslash.
#    
#   "$module" means the following:
#    [ARGUMENTS] (see description of 'printf' above: printf [-v VAR] FORMAT [ARGUMENTS])
#   We have the https://github.com/eclipse-che/che-docs/tree/main/modules directory.
#   3.5.3 Shell Parameter Expansion
#   The '$' character introduces parameter expansion, command substitution,
#   or arithmetic expansion.  The parameter name or symbol to be expanded
#   may be enclosed in braces, which are optional but serve to protect the
#   variable to be expanded from characters immediately following it which
#   could be interpreted as part of the name.
#   The basic form of parameter expansion is ${PARAMETER}.  The value of
#   PARAMETER is substituted.  The PARAMETER is a shell parameter as
#   described above (*note Shell Parameters::) or an array reference (*note
#   Arrays::).  The braces are required when PARAMETER is a positional
#   parameter with more than one digit, or when PARAMETER is followed by a
#   character that is not to be interpreted as part of its name.

    
    report=".cache/vale-report-${module#modules/}.json"
#   Review the .json file, and, if this is still unclear, ask Fabrice to explan you this line.
    vale --minAlertLevel=suggestion --output=JSON --no-exit "$module" > "$report"
#   "$module"/"$report" syntax: ask Fabrice!
    printf "=== Severity\n"
#   prints "=== Severity" on a new line
    jq .[][].Severity "$report" | sort | uniq -c | sort -nr
#   Reading the CLI output from `jq --help`:
#     jq is a tool for processing JSON inputs, applying the given filter to
#     its JSON text inputs and producing the filter's results as JSON on
#     standard output.
#     ...    
#     See the manpage for more options.
#   Reading the CLI output from `sort --help`:
#     Write sorted concatenation of all FILE(s) to standard output.
#   Reading the CLI output from `uniq --help`:
#     Filter adjacent matching lines from INPUT (or standard input),
#     writing to OUTPUT (or standard output).
#     With no options, matching lines are merged to the first occurrence.
#     -c, --count           prefix lines by the number of occurrences
#       Note to self: test and observe the script to understand why this option is used here.
#     Note: 'uniq' does not detect repeated lines unless they are adjacent.
#     Full documentation at: <https://www.gnu.org/software/coreutils/uniq>   
#   Reading the CLI output from `sort --help` again, this time for the options:
#     -n, --numeric-sort          compare according to string numerical value
#       Note to self: test and observe the script to understand why this option is used here.
#       If no luck understanding it myself, then ask Fabrice:
#         What's the purpose of using this option in this particular use case?
#         And why is this command repeated?    
#     -r, --reverse               reverse the result of comparisons
#       If no luck understanding it myself, then ask Fabrice:
#         What's the purpose of using this option in this particular use case?
#         And why is this command repeated?
    printf "=== Check\n"
#   prints "=== Check" on a new line
    jq .[][].Check "$report" | sort | uniq -c | sort -nr
#   same as for the previous jq line, except that
#   ...    
done
