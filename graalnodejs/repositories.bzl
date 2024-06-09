"graalnodejs Toolchain Repositories"

load(":assets.bzl", "ASSETS")

_PLATFORMS = {
    "linux-amd64": ["@platforms//os:linux", "@platforms//cpu:x86_64"],
    "linux-aarch64": ["@platforms//os:linux", "@platforms//cpu:arm64"],
    "macos-amd64": ["@platforms//os:macos", "@platforms//cpu:x86_64"],
    "macos-aarch64": ["@platforms//os:macos", "@platforms//cpu:arm64"],
    "windows-amd64": ["@platforms//os:windows", "@platforms//cpu:x86_64"],
}

AVAILABLE_PLATFORMS = _PLATFORMS.keys()

_DOWNLOAD_URL = "https://github.com/oracle/graaljs/releases/download"

_BUILD_FILE_PARTIAL = """\
toolchain(
    name = "{name}_{platform}_toolchain",
    toolchain = "@{name}_{platform}//:graalnodejs_toolchain",
    exec_compatible_with = {compatible_with},
    toolchain_type = "@rules_nodejs//nodejs:toolchain_type",
    visibility = ["//visibility:public"],
)
"""

_BUILD_FILE = """\
load("@rules_nodejs//nodejs:toolchain.bzl", "nodejs_toolchain")

alias(name = "node_bin", actual = "{node_bin}")
alias(name = "npm_bin", actual = "{npm_bin}")
alias(name = "npx_bin", actual = "{npx_bin}")
alias(name = "node", actual = "{node_entry}")
alias(name = "npm", actual = "{npm_entry}")
alias(name = "npx", actual = "{npx_entry}")

cc_library(
  name = "headers",
  hdrs = glob(
    ["include/node/**"],
    allow_empty = True,
  ),
  includes = ["include/node"],
)

filegroup(
  name = "node_files",
  srcs = [":node", ":node_bin"],
)

filegroup(
  name = "npm_files",
  srcs = glob(["npm/**"], exclude = ["npm/docs/**", "npm/man/**", "npm/tap-snapshots/**"]) + [":node_files"],
)

nodejs_toolchain(
    name = "toolchain",
    node = ":node_bin",
    npm = ":npm",
    npm_srcs = [":npm_files"],
    headers = ":headers",
)

alias(
    name = "graalnodejs_toolchain",
    actual = ":toolchain",
)
"""

# buildifier: disable=function-docstring
def graalnodejs_register_toolchains(name, graaljs_version):
    build_file_content = ""
    for (platform, config) in ASSETS[graaljs_version].items():
        graalnodejs_platform_toolchain_repo(
            name = "%s_%s" % (name, platform),
            asset = config.asset,
            platform = platform,
            version = graaljs_version,
            integrity = config.integrity,
        )
        build_file_content += _BUILD_FILE_PARTIAL.format(
            name = name,
            platform = platform,
            compatible_with = _PLATFORMS[platform],
        )

    graalnodejs_toolchains_repo(
        name = "%s_toolchains" % name,
        build_file_content = build_file_content,
    )

graalnodejs_toolchains_repo = repository_rule(
    lambda ctx: ctx.file("BUILD.bazel", ctx.attr.build_file_content),
    attrs = {
        "build_file_content": attr.string(mandatory = True),
    },
)

def _graalnodejs_platform_toolchain_repo_impl(ctx):
    ctx.download_and_extract(
        url = "%s/graal-%s/%s" % (_DOWNLOAD_URL, ctx.attr.version, ctx.attr.asset),
        integrity = "sha384-%s" % ctx.attr.integrity,
        stripPrefix = "graalnodejs-%s-%s" % (ctx.attr.version, ctx.attr.platform),
    )

    is_windows = "windows" in ctx.attr.platform
    node_bin = "bin/node" if not is_windows else "bin/node.exe"
    npm_bin = "npm/bin/%s" % ("npm-cli.js" if not is_windows else "npm.cmd")
    npx_bin = "npm/bin/%s" % ("npx-cli.js" if not is_windows else "npx.cmd")

    node_entry = "bin/node" if not is_windows else "bin/node.exe"
    npm_entry = "bin/npm" if not is_windows else "bin/npm.cmd"
    npx_entry = "bin/npx" if not is_windows else "bin/npx.cmd"

    ctx.file("BUILD.bazel", _BUILD_FILE.format(
        node_bin = node_bin,
        npm_bin = npm_bin,
        npx_bin = npx_bin,
        node_entry = node_entry,
        npm_entry = npm_entry,
        npx_entry = npx_entry,
    ))

graalnodejs_platform_toolchain_repo = repository_rule(
    _graalnodejs_platform_toolchain_repo_impl,
    attrs = {
        "asset": attr.string(mandatory = True),
        "integrity": attr.string(mandatory = True),
        "version": attr.string(mandatory = True, values = ASSETS.keys()),
        "platform": attr.string(mandatory = True, values = AVAILABLE_PLATFORMS),
    },
)
