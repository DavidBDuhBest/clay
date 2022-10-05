#!/bin/bash

cd $(dirname "${0}")

source ../_common.sh

dnf_install lsb-core-noarch

rpm_install atom https://atom-installer.github.com/v1.60.0/atom.x86_64.rpm