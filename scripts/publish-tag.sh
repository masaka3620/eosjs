#!/bin/bash

. "./publish-utils.sh"

if [[ "$TRAVIS_TAG" == "" ]]; then
  echo "No tag specified, skipping...";
else
  echo "Running on branch/tag ${TRAVIS_TAG}":

  echo "Setting up git"
  setup_git

  echo "Creating new version"
  git checkout -- .

  git status

  npm version -no-git-tag-version $TRAVIS_TAG

  echo "Pushing to git"
  git commit -a -m "Publishing version ${TRAVIS_TAG} [skip ci]"

  git push origin HEAD:master-releases

  echo "Build and Publish to NPM"

  cp .npmrc.template $HOME/.npmrc 

  if [[ "$TRAVIS_TAG" == *"-beta"* ]]; then
    echo "Publishing with beta tag to npm (jk, it's commented out)"
    #npm publish --tag beta
  else
    echo "Publishing with latest tag to npm (jk it's commented out)"
    #npm publish
  fi
fi

