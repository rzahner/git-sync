#!/usr/bin/env bash

main() {
	case ${1} in 
	export)
		shift
		export ${@}
		;;
	import)
		shift
		import ${@}
		;;
	*)
		echo $"usage: ${0} (export|export) profile"
		exit 1
	esac
}

export() {
	local profile="${1}"
	local repositoryCatalog="${profile}.txt"
	local exportDirectory="${profile}.export"

	if [[ -z ${profile} || ! -e "${repositoryCatalog}" ]]; then
		echo "[ERROR] File for repository-catalog does not exist: ${repositoryCatalog}"
		exit 1
	fi

	[[ ! -d "${exportDirectory}" ]] && mkdir "${exportDirectory}"
	pushd ${exportDirectory} > /dev/null

	for repository in $(cat "../${repositoryCatalog}");
	do
		directory=$(basename ${repository})
		if [ ! -d "${directory}" ]; 
		then
			echo -e "\nClone Repository ${directory%.*}"
			git clone --mirror "${repository}"
		 else
			echo -e "\nUpdate Repository ${directory%.*}"
			pushd ${directory} > /dev/null
			git fetch --all 
			popd > /dev/null	
		fi
	done

	local exportFile="${profile}.$(date +%Y%m%d%H%M).tgz"
	echo -e "\nExport Repositories to ${exportFile}"
	tar czf "../${exportFile}" *.git
	popd > /dev/null
}

import() {
	local profile="${1}"
	if [[ -z ${profile} ]]; then
		echo $"[ERROR] Missing profile"
		exit 1
	fi

	local importFile="$(ls ${profile}.*.tgz | sort | tail -n1)"
	if [[ ! -f "${importFile}" ]]; then
		echo $"[ERROR] No import file for profile ${profile} found"
		exit 1
	fi

	local importDirectory="${profile}.import"
	[[ ! -d "${importDirectory}" ]] && mkdir "${importDirectory}"
	
	echo -e "\nImport Repositories from ${importFile}"
	tar xzf "${importFile}" -C "${importDirectory}"
}

main ${@}
