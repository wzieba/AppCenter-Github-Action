#!/bin/bash -e
RELEASE_NOTES=""
isFirst=true
releaseId=""
export IFS=";"
params=()
[ "${INPUT_NOTIFYTESTERS}" != true ] && params+=(--silent)
[ "${INPUT_DEBUG}" == true ] && params+=(--debug)
if [ -n "${INPUT_RELEASENOTES}" ]; then
  RELEASE_NOTES=${INPUT_RELEASENOTES}
elif [ $INPUT_GITRELEASENOTES ]; then
  RELEASE_NOTES="$(git log -1 --pretty=short)"
fi

if [ -n "${INPUT_BUILDVERSION}" ]; then
    params+=(--build-version "$INPUT_BUILDVERSION")
fi

if [ -n "${INPUT_BUILDNUMBER}" ]; then
    params+=(--build-number "$INPUT_BUILDNUMBER")
fi

for group in $INPUT_GROUP; do
  if ${isFirst}; then
    isFirst=false
    appcenter distribute release --token "$INPUT_TOKEN" --app "$INPUT_APPNAME" --group $group --file "$INPUT_FILE" --release-notes "$RELEASE_NOTES" "${params[@]}"
    releaseId=$(appcenter distribute releases list --token "$INPUT_TOKEN" --app "$INPUT_APPNAME" | grep ID | tr -s ' ' | cut -f2 -d ' ' | sort -n -r | head -1)
  else
    appcenter distribute releases add-destination --token "$INPUT_TOKEN" -d $group -t group -r $releaseId --app "$INPUT_APPNAME" "${params[@]}"
  fi
done

crashUploadParams=()
[ "${INPUT_DEBUG}" == true ] && crashUploadParams+=(--debug)

if [ "$INPUT_MAPPINGS" ]; then
  APP_VERSION_NAME=$(/usr/local/bin/aapt2 dump badging "$INPUT_FILE" | grep "versionName=" | sed -e "s/.*versionName='//" -e "s/' .*//")
  APP_VERSION_CODE=$(/usr/local/bin/aapt2 dump badging "$INPUT_FILE" | grep "versionCode=" | sed -e "s/.*versionCode='//" -e "s/' .*//")
  if ($INPUT_DEBUG); then
    echo "Upload mappings $INPUT_MAPPINGS -> $APP_VERSION_NAME -> $APP_VERSION_CODE"
  fi

  appcenter crashes upload-mappings --token "$INPUT_TOKEN" --app "$INPUT_APPNAME" --mapping "$INPUT_MAPPINGS" --version-name "$APP_VERSION_NAME" --version-code "$APP_VERSION_CODE" "${crashUploadParams[@]}"
fi

if [ "$INPUT_SYMBOLS" ]; then
  if ($INPUT_DEBUG); then
    echo "Upload symbols $INPUT_SYMBOLS"
  fi
  appcenter crashes upload-symbols --token "$INPUT_TOKEN" --app "$INPUT_APPNAME" --symbol "$INPUT_SYMBOLS" "${crashUploadParams[@]}"
fi
