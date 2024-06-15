"graaljs Extension"

load("//lib:extensions.bzl", "collect_toolchains_to_register", "toolchain_tag_class")
load(":repositories.bzl", "graaljs_register_toolchains")

DEFAULT_GRAALJS_REPOSITORY = "graaljs"

def _graaljs_extension_impl(module_ctx):
    registrations = collect_toolchains_to_register(module_ctx, DEFAULT_GRAALJS_REPOSITORY)

    for k, v in registrations.items():
        graaljs_register_toolchains(
            name = k,
            graaljs_version = v.graaljs_version,
        )

graaljs = module_extension(
    _graaljs_extension_impl,
    tag_classes = {
        "toolchain": toolchain_tag_class(DEFAULT_GRAALJS_REPOSITORY),
    },
)
