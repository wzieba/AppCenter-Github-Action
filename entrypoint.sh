#!/bin/sh
appcenter distribute release --token "$INPUT_TOKEN" --app "$INPUT_APPNAME" --group "$INPUT_GROUP" --file "$INPUT_FILE" --release-notes "$INPUT_RELEASENOTES" --debug

