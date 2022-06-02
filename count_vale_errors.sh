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
    printf "== %s\n" "$module"
    report=".cache/vale-report-${module#modules/}.json"
    vale --minAlertLevel=suggestion --output=JSON --no-exit "$module" > "$report"
    printf "=== Severity\n"
    jq .[][].Severity "$report" | sort | uniq -c | sort -nr 
    printf "=== Check\n"
    jq .[][].Check "$report" | sort | uniq -c | sort -nr
done
