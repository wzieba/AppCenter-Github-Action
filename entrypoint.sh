#!/bin/sh
RELEASE_NOTES=""

if [ -n "${INPUT_RELEASENOTES}" ]; then
    RELEASE_NOTES=${INPUT_RELEASENOTES}
elif [ $INPUT_GITRELEASENOTES ]; then
    RELEASE_NOTES="$(git log -1 --pretty=short)"
fi

appcenter \
        distribute \
        release \
        --token "$INPUT_TOKEN" \
        --app "$INPUT_APPNAME" \
        --group "$INPUT_GROUP" \
        --file "$INPUT_FILE" \
        --release-notes "${RELEASE_NOTES}" \
        --debug
