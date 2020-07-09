#!/bin/bash

# input validation
if [[ -z "${TAG}" ]]; then
   echo "No tag name supplied"
   exit 1
fi

if [[ -z "${GITHUB_TOKEN}" ]]; then
   echo "No github token supplied"
   exit 1
fi

# get GitHub API endpoints prefix
git_refs_url=$(jq .repository.git_refs_url $GITHUB_EVENT_PATH | tr -d '"' | sed 's/{\/sha}//g')

# check if tag already exists in the cloned repo
tag_exists="false"
if [ $(git tag -l "$TAG") ]; then
    tag_exists="true"
else
  # check if tag exists in the remote repo
  getReferenceStatus=$(curl "$git_refs_url/tags/$TAG" \
  -H "Authorization: token $GITHUB_TOKEN" \
  --write-out "%{http_code}" -s -o /dev/null)

  if [ "$getReferenceStatus" = '200' ]; then
    tag_exists="true"
  fi
fi

echo "**pushing tag $TAG to repo $GITHUB_REPOSITORY"

if $tag_exists
then
  # update tag
  curl -s -X PATCH "$git_refs_url/tags/$TAG" \
  -H "Authorization: token $GITHUB_TOKEN" \
  -d @- << EOF

  {
    "sha": "$GITHUB_SHA",
    "force": true
  }
EOF
else
  # create new tag
  curl -s -X POST "$git_refs_url" \
  -H "Authorization: token $GITHUB_TOKEN" \
  -d @- << EOF

  {
    "ref": "refs/tags/$TAG",
    "sha": "$GITHUB_SHA"
  }
EOF
fi
