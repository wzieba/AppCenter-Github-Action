#!/bin/sh
RELEASE_NOTES=""
isFirst=true
releaseId=""
export IFS=";"
if [ -n "${INPUT_RELEASENOTES}" ]; then
    RELEASE_NOTES=${INPUT_RELEASENOTES}
elif [ $INPUT_GITRELEASENOTES ]; then
    RELEASE_NOTES="$(git log -1 --pretty=short)"
fi
for group in $INPUT_GROUP; do
    if ${isFirst} ; then
        isFirst=false
        appcenter distribute release --token "$INPUT_TOKEN" --app "$INPUT_APPNAME" --group $group --file "$INPUT_FILE" --release-notes "$INPUT_RELEASENOTES" --silent
        releaseId=$(appcenter distribute releases list --token "$INPUT_TOKEN"  --app "$INPUT_APPNAME" | grep ID | head -1 | tr -s ' ' | cut -f2 -d ' ')
    else
        appcenter distribute releases add-destination --token "$INPUT_TOKEN" -d $group -t group -r $releaseId -s --app "$INPUT_APPNAME"
    fi
done
