#!/bin/bash

BUILD=x64.release

for i in "$@"; do
  case $i in
    -d) BUILD=x64.debug ;;
    *) COMMIT=$i ;;
  esac
done

apt update
apt install -y curl

if [ ! -d depot_tools ]; then
  git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
fi

export PATH=$PATH:$(pwd)/depot_tools

if [ ! -d v8 ]; then
  fetch v8
fi

if [ -n "$COMMIT" ]; then
  git -C v8 checkout $COMMIT
  export DEPOT_TOOLS_UPDATE=0
  git -C depot_tools checkout $(git -C depot_tools rev-list -n 1 --before="$(git -C v8 show -s -n 1 --format=%ci)" main)
  git -C v8 clean -ffd
  git -C depot_tools clean -ffd

  GCLIENT_OPTS=-D --force --reset
fi


pushd v8
  gclient sync $GCLIENT_OPTS

  apt install -y lsb-release sudo file

  until build/install-build-deps.sh; do
    echo "Run install-build-deps.sh again"
  done

  tools/dev/v8gen.py $BUILD
  ninja -C out.gn/$BUILD d8
  ninja -C out.gn/$BUILD -t compdb cxx cc > compile_commands.json
popd
