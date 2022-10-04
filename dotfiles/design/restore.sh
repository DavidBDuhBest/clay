#!/bin/bash

cd $(dirname "${0}")

source ../_common.sh

#
# https://fosspost.org/survey-shows-60-of-vfx-designers-use-linux
# https://www.reddit.com/r/linuxmemes/comments/hswvfk/as_a_graphic_designer_i_only_use_linux_yeah_you
#

dnf_install \
	darktable \
	gimp \
	inkscape \
	#kdenlive \
	krita \
	openshot \
	scribus \
	shotcut

#
# https://www.makeuseof.com/install-figma-linux
#

rpm_install figma-linux https://github.com/Figma-Linux/figma-linux/releases/download/v0.10.0/figma-linux_0.10.0_linux_x86_64.rpm