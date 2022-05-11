#!/usr/bin/env sh
#
# Copyright (c) 2021 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#

# Fail on errors
set -e
# source: https://www.gnu.org/software/bash/manual/bash.txt
# 'set' allows you to change the values of shell options and set the positional parameters, or to display the names and values of shell variables.
# When options are supplied, they set or unset shell attributes. Options, if specified, have the following meanings:
# '-e'
          # Exit immediately if a pipeline (*note Pipelines::), which may
          # consist of a single simple command (*note Simple Commands::),
          # a list (*note Lists::), or a compound command (*note Compound
          # Commands::) returns a non-zero status.  The shell does not
          # exit if the command that fails is part of the command list
          # immediately following a 'while' or 'until' keyword, part of
          # the test in an 'if' statement, part of any command executed in
          # a '&&' or '||' list except the command following the final
          #'&&' or '||', any command in a pipeline but the last, or if
          # the command's return status is being inverted with '!'.  If a
          # compound command other than a subshell returns a non-zero
          # status because a command failed while '-e' was being ignored,
          # the shell does not exit.  A trap on 'ERR', if set, is executed
          # before the shell exits.
          # This option applies to the shell environment and each subshell
          # environment separately (*note Command Execution
          # Environment::), and may cause subshells to exit before
          # executing all the commands in the subshell.
          # If a compound command or shell function executes in a context
          # where '-e' is being ignored, none of the commands executed
          # within the compound command or function body will be affected
          # by the '-e' setting, even if '-e' is set and a command returns
          # a failure status.  If a compound command or shell function
          # sets '-e' while executing in a context where '-e' is ignored,
          # that setting will not have any effect until the compound
          # command or the command containing the function call completes.

# Get fresh Vale styles
cd .vale/styles || exit
# 4.1 Bourne Shell Builtins
# ...
# 'cd'
#         cd [-L|[-P [-e]] [-@] [DIRECTORY]
#    Change the current working directory to DIRECTORY.  If DIRECTORY is
#    not supplied, the value of the 'HOME' shell variable is used. Any
#    additional arguments following DIRECTORY are ignored. ...
#    The return status is zero if the directory is successfully changed,
#    non-zero otherwise.
#    ...
# 'control operator'
# A 'token' that performs a control function.  It is a 'newline' or
# one of the following: '||', '&&', '&', ';', ';;', ';&', ';;&', '|',
# '|&', '(', or ')'.
# ...
#    An OR list has the form
#    COMMAND1 || COMMAND2
# COMMAND2 is executed if, and only if, COMMAND1 returns a non-zero exit
# status.
# The return status of AND and OR lists is the exit status of the last
# command executed in the list.
# ...
# 'exit'
#         exit [N]
#    Exit the shell, returning a status of N to the shell's parent.  If
#    N is omitted, the exit status is that of the last command executed.
#    Any trap on 'EXIT' is executed before the shell terminates.

rm -rf RedHat CheDocs 

wget -qO- https://github.com/redhat-documentation/vale-at-red-hat/releases/latest/download/RedHat.zip | unzip -q -
wget -qO- https://github.com/eclipse-che/che-docs-vale-style/releases/latest/download/CheDocs.zip | unzip -q -
