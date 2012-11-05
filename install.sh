#!/bin/bash
#
# Copyright (c) 2012, Matthew Dutton <matt.dutton@mri>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. Neither the name of the project nor the
#    names of its contributors may be used to endorse or promote products
#    derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER ''AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

# This script installs git-hooks to /usr/local/bin

function fail()
{
	echo "$@" 1>&2
	exit 1
}

function cmd_exists()
{
	which "$1" > /dev/null 2> /dev/null
}

# Operate out of the script dir
cd "$( dirname "$0" )"

# Download
SRC="src/git-hooks/git-hooks"
if [ ! -f "$SRC" ]; then
	mkdir src
	echo "Downloading git-hooks..."
	git clone git://github.com/mdutton3/git-hooks.git src/git-hooks || fail "Could not clone git-hooks"
	[ -f "$SRC" ] || fail "Could not find git-hooks script"
fi

# Determine what su/sudo is installed
SUCMD=
if cmd_exists sudo; then
	SUCMD="sudo"
elif cmd_exists su; then
	SUCMD="su root -c"
fi

if [ -n "$SUCMD" ]; then
	echo "Using $SUCMD to access super-user"
	$SUCMD true || fail "Could not gain SU privledges"
else
	echo "No super-user command found. Assuming super-user permissions"
fi

# Where to install
DEST=/usr/local/bin

# Install
[ -d "$DEST" ] || $SUCMD mkdir -p "$DEST"
$SUCMD cp "$SRC" "$DEST/git-hooks"
$SUCMD chmod ugo+rx "$DEST/git-hooks"
$SUCMD chmod go-w "$DEST/git-hooks"

