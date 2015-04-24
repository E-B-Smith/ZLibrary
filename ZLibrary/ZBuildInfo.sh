#!/bin/bash
target="${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"
echo "Updating date '`date`' in '$target'."
(/usr/libexec/PlistBuddy -c "delete :ZBuildInfoDate" "${target}" || true)
 /usr/libexec/PlistBuddy -c "add :ZBuildInfoDate date `date`" "${target}"
