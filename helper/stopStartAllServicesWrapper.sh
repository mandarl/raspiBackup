#!/bin/bash

#######################################################################################################################
#
# 	Sample script to wrap raspiBackup.sh in order
# 	to stop all running services before backup and restart them after backup
#
# 	Visit http://www.linux-tips-and-tricks.de/raspiBackup for details about raspiBackup
#
#######################################################################################################################
#
#   Copyright # (C) 2018 - framp at linux-tips-and-tricks dot de
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#	Kudos for ... I unfortunately don't remember where I found and who wrote the code for {shutdown|start}AllServices :-(
#
#######################################################################################################################

VERSION="v0.1"

trap startAllServices EXIT ERR

function shutdownAllServices () {
	[[ -z $SERVICE ]] && retrieveAllActiveServices
	for (( idx=${#SERVICES[@]}-1 ; idx>=0 ; idx-- )); do
		echo "service ${SERVICES[idx]} stop &>/dev/null"
	done
}

function startAllServices () {
	[[ -z $SERVICE ]] && retrieveAllActiveServices
	for SERVICE in ${SERVICES[@]}; do
		echo "service $SERVICE start &>/dev/null"
	done
}

function retrieveAllActiveServices() {
	RUNLEVEL=$(/sbin/runlevel | cut -d' ' -f2)
	for script in $(ls /etc/rc${RUNLEVEL}.d/S*); do
		SERVICES+=($(basename $script | sed 's~^S[0-9]*~~g'))
	done
}

declare -a SERVICES

shutdownAllServices
raspiBackup.sh -a : -o :
trap
startAllServices


