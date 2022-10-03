#!/bin/sh
#
# Copyright (c) 2021 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0

PROJECT=$1
# ? ^
WORKDIR="$(pwd)"
# 3.5.4 Command Substitution https://www.gnu.org/software/bash/manual/
# Command substitution allows the output of a command to replace the
# command itself.  Command substitution occurs when a command is enclosed
# as follows:
#     $(COMMAND)

setvars() {
# 3.3 Shell Functions https://www.gnu.org/software/bash/manual/
# Shell functions are a way to group commands for later execution using a
# single name for the group.  They are executed just like a "regular"
# command.  When the name of a shell function is used as a simple command
# name, the list of commands associated with that function name is
# executed.  Shell functions are executed in the current shell context; no
# new process is created to interpret them.
#   Functions are declared using this syntax:
#     FNAME () COMPOUND-COMMAND [ REDIRECTIONS ]
#   or
#     function FNAME [()] COMPOUND-COMMAND [ REDIRECTIONS ]
    # The BODY of the function is the compound command COMPOUND-COMMAND
    # (*note Compound Commands::).  That command is usually a LIST
    # enclosed between { and } ...
   case "$PROJECT" in
  "che")
    REPO=https://github.com/eclipse-che/che-devfile-registry.git
    DEVFILESDIR=devfiles/;;
  # 'devfiles/' is a path inside the previous repository
  # FYI https://github.com/eclipse-che/che-devfile-registry/tree/main/devfiles
  "devspaces")
    REPO=https://github.com/redhat-developer/devspaces.git
    DEVFILESDIR=dependencies/che-devfile-registry/devfiles/;;
  # 'dependencies/che-devfile-registry/devfiles/' is a path inside the previous repository
  # FYI https://github.com/redhat-developer/devspaces/tree/devspaces-3-rhel-8/dependencies/che-devfile-registry/devfiles
  *)
    echo "Use 'che' or 'devspaces' as the only parameter to this script."
    exit 1;;
esac
# source: line 773, https://www.gnu.org/software/bash/manual/
# 'case'
#     The syntax of the 'case' command is:
#         case WORD in
#              [ [(] PATTERN [| PATTERN]...) COMMAND-LIST ;;]...
#         esac
#     'case' will selectively execute the COMMAND-LIST corresponding to
#     the first PATTERN that matches WORD. 
}

getdata() {
TMPCLONE=$PROJECT-devfiles-shallow

if [ -d $TMPCLONE ]; then
    # 'test'
    # '['
    #      test EXPR
    # source: line 3056, https://www.gnu.org/software/bash/manual/
    # Evaluate a conditional expression EXPR and return a status of 0
    # (true) or 1 (false).  Each operator and operand must be a separate
    # argument.  Expressions are composed of the primaries described
    # below in *note Bash Conditional Expressions::.  'test' does not
    # accept any options, nor does it accept and ignore an argument of
    # '--' as signifying the end of options.
    # When the '[' form is used, the last argument to the command must be
    # a ']'.
    # 6.4 Bash Conditional Expressions https://www.gnu.org/software/bash/manual/
    # Conditional expressions are used by the '[[' compound command and the
    # 'test' and '[' builtin commands.  The 'test' and '[' commands determine
    # their behavior based on the number of arguments; see the descriptions of
    # those commands for any other command-specific actions.
    #    Unless otherwise specified, primaries that operate on files follow
    # symbolic links and operate on the target of the link, rather than the
    # link itself.
    # '-d FILE'
    # True if FILE exists and is a directory.
  echo "A working clone of $REPO exists; using."
  cd $TMPCLONE
  git fetch
else
  echo "Need a working clone of $REPO; cloning."
  git clone --depth=1 --filter=blob:none --sparse $REPO $TMPCLONE
  # git-clone - Clone a repository into a new directory (git clone --help)
  #   --depth <depth>
  #       Create a shallow clone with a history truncated to the specified number of commits. Implies
  #       --single-branch unless --no-single-branch is given to fetch the histories near the tips of
  #       all branches. If you want to clone submodules shallowly, also pass --shallow-submodules.
  #   --filter=<filter-spec>
  #       Use the partial clone feature and request that the server sends a subset of reachable
  #       objects according to a given object filter. When using --filter, the supplied <filter-spec>
  #       is used for the partial clone filter. For example, --filter=blob:none will filter out all
  #       blobs (file contents) until needed by Git. Also, --filter=blob:limit=<size> will filter out
  #       all blobs of size at least <size>. For more details on filter specifications, see the
  #       --filter option in git-rev-list(1).
  #   --sparse
  #       Initialize the sparse-checkout file so the working directory starts with only the files in
  #       the root of the repository. The sparse-checkout file can be modified to grow the working
  #       directory as needed.
  
  cd $TMPCLONE
  git sparse-checkout set $DEVFILESDIR
  # source: git sparse-checkout --help
  # git-sparse-checkout - Initialize and modify the sparse-checkout configuration, which reduces the
  # checkout to a set of paths given by a list of patterns.
  #  set
  #     Write a set of patterns to the sparse-checkout file, as given as a list of arguments
  #     following the set subcommand. Update the working directory to match the new patterns. Enable
  #     the core.sparseCheckout config setting if it is not already enabled.
fi
}
# 3.2.5.2 Conditional Constructs https://www.gnu.org/software/bash/manual/
# 'if'
#     The syntax of the 'if' command is:
#          if TEST-COMMANDS; then
#            CONSEQUENT-COMMANDS;
#          [elif MORE-TEST-COMMANDS; then
#            MORE-CONSEQUENTS;]
#          [else ALTERNATE-CONSEQUENTS;]
#          fi
#     The TEST-COMMANDS list is executed, and if its return status is
#     zero, the CONSEQUENT-COMMANDS list is executed.  If TEST-COMMANDS
#     returns a non-zero status, each 'elif' list is executed in turn,
#     and if its exit status is zero, the corresponding MORE-CONSEQUENTS
#     is executed and the command completes.  If 'else
#     ALTERNATE-CONSEQUENTS' is present, and the final command in the
#     final 'if' or 'elif' clause has a non-zero exit status, then
#     ALTERNATE-CONSEQUENTS is executed.  The return status is the exit
#     status of the last command executed, or zero if no condition tested
#     true.

parsedevfiles() {
cd $DEVFILESDIR

sed '/^displayName:\|^description:\|^tags: \[.*Tech-Preview.*\]/!d;
    s/^displayName: \(.*\)/\1::/;
    s/^description: \(.*\)/\1/;
    s/^tags: \[.*Tech-Preview.*\]/(Technology Preview)/;
    s/\"//g' */meta.yaml | \
    sed '/::$/N;
        s/::\n/:: /;' > "$WORKDIR"/snip_$PROJECT-supported-languages.adoc
}
# source: `$ man sed`
# https://www.gnu.org/software/sed/manual/sed.html
# Sed  is  a  stream  editor.  A stream editor is used to perform basic text transformations on an
# input stream (a file or input from a pipeline).  While in some ways similar to an  editor  which
# permits scripted edits (such as ed), sed works by making only one pass over the input(s), and is
# consequently more efficient.  But it is sed's ability to filter text in a pipeline which partic‐
# ularly distinguishes it from other types of editors.
# # d      Delete pattern space.  Start next cycle.
#   s/regexp/replacement/
#     Attempt to match regexp against the pattern space.  If successful, replace  that  portion
#     matched  with  replacement.  The replacement may contain the special character & to refer
#     to that portion of the pattern space which matched, and the special escapes \1 through \9
#     to refer to the corresponding matching sub-expressions in the regexp.
#   /regexp/
#     Match lines matching the regular expression regexp.
# The character ^ (caret) in a regular expression matches the beginning of the line.
#   *
#     Matches a sequence of zero or more instances of matches for the preceding regular expression,
#     which must be an ordinary character, a special character preceded by \, a ., a grouped regexp
#     (see below), or a bracket expression.
# The character . (dot) matches any single character.
#  '/\1::/' adds the AsciiDoc syntax element '::'
#     back-references are regular expression commands which refer to a previous part of the matched
#     regular expression. Back-references are specified with backslash and a single digit (e.g. ‘\1’).#     The part of the regular expression they refer to is called a subexpression, and is designated
#     with parentheses.
#   \digit
#     Matches the digit-th \(…\) parenthesized subexpression in the regular expression.
#     This is called a back reference. Subexpressions are implicitly numbered by
#     counting occurrences of \( left-to-right.
#  ‘[.’
#     represents the open collating symbol.

setvars
getdata
parsedevfiles
