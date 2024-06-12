"graaljs Extension"

load(":repositories.bzl", "graaljs_register_toolchains")

DEFAULT_GRAALJS_REPOSITORY = "graaljs"
DEFAULT_GRAALJS_VERSION = "24.0.1"

def _graaljs_extension_impl(module_ctx):
    # The following code is adapted from the toolchains in `@aspect_bazel_lib`.
    registrations = {}
    for mod in module_ctx.modules:
        for toolchain in mod.tags.toolchain:
            if toolchain.name != DEFAULT_GRAALJS_REPOSITORY and not mod.is_root:
                fail("Only the root module may provide a name for the node toolchain.")

            if toolchain.name in registrations.keys():
                if toolchain.name == DEFAULT_GRAALJS_REPOSITORY:
                    # Prioritize the root-most registration of the default node toolchain version and
                    # ignore any further registrations (modules are processed breadth-first)
                    continue
                if toolchain.graaljs_version == registrations[toolchain.name].graaljs_version:
                    # No problem to register a matching toolchain twice
                    continue
                fail("Multiple conflicting toolchains declared for name {} ({} and {})".format(
                    toolchain.name,
                    toolchain.graaljs_version,
                    registrations[toolchain.name],
                ))
            else:
                registrations[toolchain.name] = struct(
                    graaljs_version = toolchain.graaljs_version,
                )

    for k, v in registrations.items():
        graaljs_register_toolchains(
            name = k,
            graaljs_version = v.graaljs_version,
        )

graaljs = module_extension(
    _graaljs_extension_impl,
    tag_classes = {
        "toolchain": tag_class(attrs = {
            "name": attr.string(
                doc = "Base name for generated repositories",
                default = DEFAULT_GRAALJS_REPOSITORY,
            ),
            "graaljs_version": attr.string(
                doc = "Version of the graaljs interpreter",
                default = DEFAULT_GRAALJS_VERSION,
            ),
        }),
    },
)
