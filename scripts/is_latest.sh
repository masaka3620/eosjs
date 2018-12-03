is_latest=false;

current_commit="$(git rev-parse HEAD)";
tags="$(git tag --sort=-creatordate)";

IFS='\n' read -ra arry <<< "$tags"

latest_tag="${arry[0]}"
tagged_branch=""

if [ "$latest_tag" == "" ]; then 
    latest_tag="v0.0.0";
else
    tagged_branch="$(git branch --contains tags/${latest_tag} | grep -E "\b${1}$" | awk '{ print $1}')"
    tag_commit="$(git rev-list -n 1 ${latest_tag})";
    if [ "$tag_commit" == "$current_commit" ]  && [ "$tagged_branch" == "$1" ]; then
        is_latest=true;
    fi
fi

echo "tag_commit: ${tag_commit}";
echo "current_commit: ${current_commit}";
echo "is_latest: ${is_latest}";
echo "tagged_branch: ${tagged_branch}";

export TRAVIS_IS_LATEST_TAG="$is_latest"