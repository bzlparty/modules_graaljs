#!/usr/bin/env bash

NAME=$(echo "$GITHUB_REF_NAME" | awk -F- '{print $1}')
TAG=$(echo "$GITHUB_REF_NAME" | awk -F- '{print $2}')
VERSION=${TAG:1}
[[ "$NAME" == "graaljs" ]] && PROJECT_NAME="rules_graaljs" || PROJECT_NAME="toolchains_graalnodejs"
PREFIX="${PROJECT_NAME}-${VERSION}"
RULES_ARCHIVE="${PROJECT_NAME}-${TAG}.tar.gz"

build_file=$(mktemp)
echo "package(default_visibility = [\"//visibility:public\"])" > "$build_file"
TARGETS="$NAME lib LICENSE $build_file"
TAR_ARGS="--absolute-names --mode=644 --owner=build --group=build --transform="s,$build_file,BUILD.bazel," --transform="s,$NAME/MODULE.bazel,MODULE.bazel," --transform="s,^,$PREFIX/,""
if [[ "$NAME" == "graaljs" ]]; then
  repo_file=$(mktemp)
  sed "s/modules/rules/g" graaljs/repo.bzl > "$repo_file"
  TARGETS="$TARGETS $repo_file"
  TAR_ARGS="$TAR_ARGS --transform="s,$repo_file,graaljs/repo.bzl,""
fi

echo -n "build: Create Rules Archive"
tar cvf "$RULES_ARCHIVE" $TAR_ARGS $TARGETS
RULES_SHA=$(shasum -a 256 "$RULES_ARCHIVE" | awk '{print $1}')
echo " ... done ($RULES_ARCHIVE: $RULES_SHA)"

echo -n "build: Create Release Notes"
cat > release_notes.md <<EOF

## Installation

> [!IMPORTANT]  
> Installation is only supported via Bzlmod!

Choose from the options below and put as dependency in your \`MODULE.bazel\`.

### Install from BCR

\`\`\`starlark
bazel_dep(name = "bzlparty_${PROJECT_NAME}", version = "${VERSION}")
\`\`\`

### Install from Archive

\`\`\`starlark
bazel_dep(name = "bzlparty_${PROJECT_NAME}")

archive_override(
    module_name = "bzlparty_project_name",
    urls = "https://github.com/bzlparty/modules_graaljs/releases/download/${GITHUB_REF_NAME}/${RULES_ARCHIVE}",
    strip_prefix = "${PREFIX}",
    integrity = "sha256-${RULES_SHA}",
)
\`\`\`

## Checksums

**${RULES_ARCHIVE}** ${RULES_SHA}

EOF

echo " ... done"
