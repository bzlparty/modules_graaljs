"graaljs Toolchain Repositories"

load("//lib:vendor.bzl", "DOWNLOAD_URL", "PLATFORMS", "PLATFORMS_COMPATIBILITY")
load(":assets.bzl", "ASSETS")
load(":repo.bzl", "REPO_NAME")

_BUILD_FILE_PARTIAL = """\
toolchain(
    name = "{name}_{platform}_toolchain",
    toolchain = "@{name}_{platform}//:graaljs_toolchain",
    exec_compatible_with = {compatible_with},
    toolchain_type = "@{repo_name}//graaljs:toolchain_type",
    visibility = ["//visibility:public"],
)
"""

_BUILD_FILE = """\
load("@{repo_name}//graaljs:toolchain.bzl", "graaljs_toolchain")

alias(name = "graaljs_bin", actual = "{graaljs_bin}")

filegroup(
  name = "lib",
  srcs = glob(["lib/**"]),
)

filegroup(
  name = "modules",
  srcs = glob(["modules/**"]),
)

graaljs_toolchain(
    name = "toolchain",
    graaljs_bin = ":graaljs_bin",
    files = [":lib", ":modules"],
)

alias(
    name = "graaljs_toolchain",
    actual = ":toolchain",
)
"""

# buildifier: disable=function-docstring
def graaljs_register_toolchains(name, graaljs_version):
    build_file_content = ""
    for (platform, config) in ASSETS[graaljs_version].items():
        graaljs_platform_toolchain_repo(
            name = "%s_%s" % (name, platform),
            asset = config.asset,
            platform = platform,
            version = graaljs_version,
            integrity = config.integrity,
        )
        build_file_content += _BUILD_FILE_PARTIAL.format(
            name = name,
            platform = platform,
            repo_name = REPO_NAME,
            compatible_with = PLATFORMS_COMPATIBILITY[platform],
        )

    graaljs_toolchains_repo(
        name = "%s_toolchains" % name,
        build_file_content = build_file_content,
    )

graaljs_toolchains_repo = repository_rule(
    lambda ctx: ctx.file("BUILD.bazel", ctx.attr.build_file_content),
    attrs = {
        "build_file_content": attr.string(mandatory = True),
    },
)

def _graaljs_platform_toolchain_repo_impl(ctx):
    ctx.download_and_extract(
        url = "%s/graal-%s/%s" % (DOWNLOAD_URL, ctx.attr.version, ctx.attr.asset),
        integrity = "sha384-%s" % ctx.attr.integrity,
        stripPrefix = "graaljs-%s-%s" % (ctx.attr.version, ctx.attr.platform),
    )

    is_windows = "windows" in ctx.attr.platform
    graaljs_bin = "bin/js" if not is_windows else "bin/js.exe"

    ctx.file("BUILD.bazel", _BUILD_FILE.format(
        graaljs_bin = graaljs_bin,
        repo_name = REPO_NAME,
    ))

graaljs_platform_toolchain_repo = repository_rule(
    _graaljs_platform_toolchain_repo_impl,
    attrs = {
        "asset": attr.string(mandatory = True),
        "integrity": attr.string(mandatory = True),
        "version": attr.string(mandatory = True, values = ASSETS.keys()),
        "platform": attr.string(mandatory = True, values = PLATFORMS),
    },
)
