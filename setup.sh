#!/bin/bash

cd "$(cd -P -- "$(dirname -- "$0")" && pwd -P)"

mkdir -p ~/Library/LaunchAgents/

cp local.remap_right_alt.plist ~/Library/LaunchAgents/

if ! launchctl list local.remap_right_alt>/dev/null 2>&1
then
  launchctl load ~/Library/LaunchAgents/local.remap_right_alt.plist
fi

launchctl start local.local.remap_right_alt

mkdir -p ~/Library/KeyBindings/

cp DefaultKeyBinding.dict ~/Library/KeyBindings/DefaultKeyBinding.dict
