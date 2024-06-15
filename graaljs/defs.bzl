"GraalJS Public API"

_DOC = """\
This rule runs a script on GraalJs.

Example
```starlark
load("@bzlparty_rules_graaljs//graaljs:defs.bzl", "graaljs_binary")

graaljs_binary(
    name = "example",
    entry_point = "main.js",
    deps = [":lib"],
)
```
"""

_ATTRS = {
    "deps": attr.label_list(
        default = [],
        allow_files = True,
    ),
    "entry_point": attr.label(
        mandatory = True,
        allow_single_file = True,
    ),
    "log_level": attr.string(
        values = [
            "OFF",
            "SEVERE",
            "WARNING",
            "INFO",
            "CONFIG",
            "FINE",
            "FINER",
            "FINEST",
            "ALL",
        ],
        default = "ALL",
    ),
    "ecmascript_version": attr.string(
        default = "latest",
        values = [
            "5",
            "2015",
            "6",
            "2016",
            "7",
            "2017",
            "8",
            "2018",
            "9",
            "2019",
            "10",
            "2020",
            "11",
            "2021",
            "12",
            "2022",
            "13",
            "2023",
            "14",
            "latest",
            "staging",
        ],
    ),
}

def _graaljs_binary_impl(ctx):
    toolchain = ctx.toolchains["@bzlparty_modules_graaljs//graaljs:toolchain_type"].graaljs_info
    graaljs_bin = toolchain.graaljs_bin
    entry_point = ctx.files.entry_point[0]
    launcher = ctx.actions.declare_file("%s.sh" % ctx.attr.name)
    args = []

    args.append("--log.js.level=%s" % ctx.attr.log_level)
    args.append("--js.ecmascript-version=%s" % ctx.attr.ecmascript_version)

    if entry_point.basename.endswith(".mjs"):
        args.append("--module")
    else:
        args.append("--file")

    ctx.actions.write(
        output = launcher,
        content = """
{graaljs_bin} {args} {entry_point} -- $@
      """.format(
            args = " ".join(args),
            graaljs_bin = graaljs_bin.path,
            entry_point = entry_point.path,
        ),
        is_executable = True,
    )

    runfiles = ctx.runfiles(
        files = [graaljs_bin, entry_point] + toolchain.files + ctx.files.deps,
    )

    return [
        DefaultInfo(
            runfiles = runfiles,
            executable = launcher,
        ),
    ]

graaljs_binary = rule(
    _graaljs_binary_impl,
    attrs = _ATTRS,
    doc = _DOC,
    executable = True,
    toolchains = [
        "@bzlparty_modules_graaljs//graaljs:toolchain_type",
    ],
)
