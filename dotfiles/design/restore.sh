#!/bin/bash

cd $(dirname "${0}")

source ../_common.sh

#
# https://www.reddit.com/r/linuxmemes/comments/hswvfk/as_a_graphic_designer_i_only_use_linux_yeah_you
#

dnf_install \
	darktable \
	gimp \
	inkscape \
	kdenlive \
	krita \
	scribus