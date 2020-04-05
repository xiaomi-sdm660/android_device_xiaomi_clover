build_root=$(pwd) # vendorsetup.sh is sourced by build/envsetup.sh in root of android build tree. Hope that nobody can correctly source it not from root of android tree.

echo "Checking repos"
# prebuilts/clang/host/linux-x86 will report this each time, because of clang-r377782b 
LANG=C repo forall -c 'git diff-index --quiet HEAD -- || echo "$REPO_PATH have uncommited changes"; git ls-files --other --directory --exclude-standard | sed q1 >/dev/null || echo "$REPO_PATH have untracked files"; CHANGES=$(git log --oneline --reverse m/lineage-17.1..HEAD|wc -l); [ 0"$CHANGES" -gt 0 ] && echo "$REPO_PATH have $CHANGES new commits after last repo sync"' 2>/dev/null | grep -v 'prebuilts/clang/host/linux-x86 have untracked files'


echo "Generating manifest"
repo manifest -r -o "device/xiaomi/clover/rootdir/etc/build-manifest.xml" 2>/dev/null
echo "Generating manifest: done"

do_one_diff() {
  ts="$1"
  nextts="$2"
  version="$3"
  nextversion="$4"
  if [ -z "$nextts" ]; then
    echo "==================================="
    echo "Since $(LC_ALL=C date -u -d @"$ts") ($version)"
    echo "==================================="
    # shellcheck disable=SC2016
    repo forall -c 'L=$(git log --oneline --after "$ts" -n 1); if [ "n$L" != "n" ]; then echo; echo "   * $REPO_PATH"; git log --oneline --after "$ts"|tac; fi' 2>/dev/null
  else
    echo "==================================="
    echo "Since $(LC_ALL=C date -u -d @"$ts") and before $(LC_ALL=C date -u -d @"$nextts") ($version to $nextversion)"
    echo "==================================="
    # shellcheck disable=SC2016
    repo forall -c 'L=$(git log --oneline --after "$ts" --before "$nextts" -n 1); if [ "n$L" != "n" ]; then echo; echo "   * $REPO_PATH"; git log --oneline --after "$ts" --before "$nextts"|tac; fi' 2>/dev/null
  fi
  echo
}

build_changelog() {
  PREVIOUS_BUILDS_LIST="$1"
  export CHANGESPATH="$2"
  rm -f "$CHANGESPATH"
  touch "$CHANGESPATH"
  if ! [ -f "$PREVIOUS_BUILDS_LIST" ]; then
    echo "No previous build detected, skipping changelog building"
    echo "First build for this version" > "$CHANGESPATH"
    return
  fi
  export nextts=""
  export ts=""
  while read nextversion nextts; do
      if [ ! -z "$ts" ]; then
        echo "Processing $version from $(LANG=C date -u -d @"$ts")"
        do_one_diff "$ts" "$nextts" "$version" "$nextversion" > /tmp/current_changelog.txt
        mv "$CHANGESPATH" /tmp/temporary.txt
        cat /tmp/current_changelog.txt /tmp/temporary.txt > "$CHANGESPATH"
        rm /tmp/current_changelog.txt /tmp/temporary.txt
      fi
      export version="$nextversion"
      export ts="$nextts"
  done < "$PREVIOUS_BUILDS_LIST"

  tail -n1 "$PREVIOUS_BUILDS_LIST"|read version ts
  echo "Processing $version from $(LANG=C date -u -d @"$ts")"
  do_one_diff "$ts" "" "$version" "" > /tmp/current_changelog.txt
  mv "$CHANGESPATH" /tmp/temporary.txt
  cat /tmp/current_changelog.txt /tmp/temporary.txt > "$CHANGESPATH"
  rm /tmp/current_changelog.txt /tmp/temporary.txt
}

if [ -f "device/xiaomi/clover/previous_builds.txt" ]; then
	echo "Building changelog"
	build_changelog "device/xiaomi/clover/previous_builds.txt" "device/xiaomi/clover/rootdir/etc/CHANGES.txt"
	echo "Building changelog: done"
fi

echo "Applying patches"
patches_path="$build_root/device/xiaomi/clover/patches/"
pushd "$patches_path" > /dev/null
unset repos
for patch in `find -type f -name '*.patch'|cut -d / -f 2-|sort`; do
	# Strip patch title to get git commit title - git ignore [text] prefixes in beginning of patch title during git am
	title=$(sed -rn "s/Subject: (\[[^]]+] *)*//p" "$patch")
	absolute_patch_path="$patches_path/$patch"
	# Supported both path/to/repo_with_underlines/file.patch and path_to_repo+with+underlines/file.patch (both leads to path/to/repo_with_underlines)
	repo_to_patch="$(if dirname $patch|grep -q /; then dirname $patch; else dirname $patch |tr '_' '/'|tr '+' '_'; fi)"

	echo -n "Is $repo_to_patch patched for '$title' ?.. "

        if [ ! -d $build_root/$repo_to_patch ] ; then
                echo "$repo_to_patch NOT EXIST! Go away and check your manifests. Skipping this patch."
                continue
        fi

	pushd "$build_root/$repo_to_patch" > /dev/null
	if (git log |fgrep -qm1 "$title" ); then
		echo -n Yes
	  commit_hash=$(git log --oneline |fgrep -m1 "$title"|cut -d ' ' -f 1)
	  if [ q"$commit_hash" != "q" ]; then
		  commit_id=$(git format-patch -1 --stdout $commit_hash |git patch-id|cut -d ' ' -f 1)
		  patch_id=$(git patch-id < $absolute_patch_path|cut -d ' ' -f 1)
		  if [ "$commit_id" = "$patch_id" ]; then
			  echo ', patch matches'
		  else
			  echo ', PATCH MISMATCH!'
			  sed '0,/^$/d' $absolute_patch_path|head -n -3  > /tmp/patch
			  git show --stat $commit_hash -p --pretty=format:%b > /tmp/commit
			  diff -u /tmp/patch /tmp/commit
			  rm /tmp/patch /tmp/commit
			  echo ' Resetting branch!'
			  git checkout $commit_hash~1
			  git am $absolute_patch_path || git am --abort
		  fi
	else
		echo "Unable to get commit hash for '$title'! Something went wrong!"
		sleep 20
	fi
	else
		echo No
		echo "Trying to apply patch $(basename "$patch") to '$repo_to_patch'"
		if ! git am $absolute_patch_path; then
			echo "Failed, aborting git am"
			git am --abort
			sleep 60
		fi
	fi
	popd > /dev/null
done
popd > /dev/null
echo "Applying patches: done"
