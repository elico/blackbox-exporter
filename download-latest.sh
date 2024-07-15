#!/usr/bin/env bash

which curl
which jq

BLACKBOX_EXPORTER_RELEASES=$( curl -s 'https://api.github.com/repos/prometheus/blackbox_exporter/releases' )

BLACKBOX_EXPORTER_VERSION=$(echo "${BLACKBOX_EXPORTER_RELEASES}" |jq -r .[0].tag_name)
PLAIN_VERSION=$( echo "${BLACKBOX_EXPORTER_VERSION}" |sed -e"s@^v@@g" )

function downloadBlacboxExporter() {
	set -x
	OS="$1"
	ARCH="$2"
	FILENAME="blackbox_exporter-${PLAIN_VERSION}.${OS}-${ARCH}.tar.gz"

	stat "downloads/${FILENAME}" || \
		curl -SL "https://github.com/prometheus/blackbox_exporter/releases/download/${BLACKBOX_EXPORTER_VERSION}/${FILENAME}" \
		-o "downloads/${FILENAME}"

	mkdir -p build-dir

	tar xvf "downloads/${FILENAME}" -C build-dir
	case "${ARCH}" in
		amd64)
			mkdir -p build-dir/linux/amd64/
			cp -vf build-dir/blackbox_exporter-*.linux-amd64/blackbox_exporter build-dir/linux/amd64/
			rm -vf build-dir/blackbox_exporter-*.linux-amd64/*
			rmdir -v build-dir/blackbox_exporter-*.linux-amd64
		;;
		arm64)
                        mkdir -p build-dir/linux/arm64/
                        cp -vf build-dir/blackbox_exporter-*.linux-arm64/blackbox_exporter build-dir/linux/arm64/
                        rm -vf build-dir/blackbox_exporter-*.linux-arm64/*
			rmdir -v build-dir/blackbox_exporter-*.linux-arm64
		;;
		armv7)
                        mkdir -p build-dir/linux/arm/v7/
                        cp -vf build-dir/blackbox_exporter-*.linux-armv7/blackbox_exporter build-dir/linux/arm/v7/
                        rm -vf build-dir/blackbox_exporter-*.linux-armv7/*
			rmdir -v build-dir/blackbox_exporter-*.linux-armv7
		;;
		armv6)
                        mkdir -p build-dir/linux/arm/v6/
                        cp -vf build-dir/blackbox_exporter-*.linux-armv6/blackbox_exporter build-dir/linux/arm/v6/
                        rm -vf build-dir/blackbox_exporter-*.linux-armv6/*
			rmdir -v build-dir/blackbox_exporter-*.linux-armv6
		;;
	esac
	
	set +x
}

downloadBlacboxExporter "linux" "amd64"
downloadBlacboxExporter "linux" "arm64"
downloadBlacboxExporter "linux" "armv7"
downloadBlacboxExporter "linux" "armv6"


