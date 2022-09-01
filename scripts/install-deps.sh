#!/bin/bash
#
# SPDX-License-Identifier: MIT
#
# SPDX-FileCopyrightText: 2022 EfficiOS Inc.
#

sudo apt-get -y install git build-essential automake autoconf libtool pkg-config libnuma-dev libpopt-dev libxml2-dev bison flex libelf-dev libdw-dev
sudo apt-get -y --no-install-recommends install xmlto asciidoc
