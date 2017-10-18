#!/bin/bash

# Bash script to lint the content of playgrounds
# Heavily based on RxSwift's
# https://github.com/ReactiveX/RxSwift/blob/master/scripts/validate-playgrounds.sh

if [ -z "$BUILD_DIRECTORY" ]; then
    echo "\$BUILD_DIRECTORY is not set. Are you trying to run \`validate-playgrounds.sh\` without building Logician first?\n"
    echo "To validate the playground, run \`script/build\`."
    exit 1
fi

if [ -z "$XCODE_PLAYGROUND" ]; then
    echo "\$XCODE_PLAYGROUND is not set."
    exit 1
fi

PAGES_PATH=${BUILD_DIRECTORY}/Build/Products/${CONFIGURATION}/all-playground-pages.swift

cat ${XCODE_PLAYGROUND}/Sources/*.swift ${XCODE_PLAYGROUND}.playground/Pages/**/*.swift > ${PAGES_PATH}

swift -v -target "x86_64-apple-macosx10.10" -D NOT_IN_PLAYGROUND -F ${BUILD_DIRECTORY}/Build/Products/${CONFIGURATION} ${PAGES_PATH} > /dev/null
result=$?

# Cleanup
rm -Rf $BUILD_DIRECTORY

exit $result
