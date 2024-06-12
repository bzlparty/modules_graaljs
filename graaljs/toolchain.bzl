"graaljs Toolchain to use per platform"

GraalJsToolchainInfo = provider(
    doc = "GraalJs Toolchain",
    fields = {
        "graaljs_bin": "Path to graaljs binary",
        "files": "Additional files",
    },
)

def _graaljs_toolchain_impl(ctx):
    graaljs_bin = ctx.file.graaljs_bin
    default = DefaultInfo(
        files = depset([graaljs_bin]),
        runfiles = ctx.runfiles(files = [graaljs_bin] + ctx.files.files),
    )
    graaljs_info = GraalJsToolchainInfo(
        graaljs_bin = graaljs_bin,
        files = ctx.files.files,
    )
    template_variables = platform_common.TemplateVariableInfo({
        "GRAALJS_BIN": graaljs_bin.path,
    })
    toolchain_info = platform_common.ToolchainInfo(
        graaljs_info = graaljs_info,
        template_variables = template_variables,
        default = default,
    )
    return [default, toolchain_info, template_variables]

graaljs_toolchain = rule(
    _graaljs_toolchain_impl,
    attrs = {
        "graaljs_bin": attr.label(mandatory = True, allow_single_file = True),
        "files": attr.label_list(allow_files = True),
    },
)
