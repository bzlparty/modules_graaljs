"graalnodejs Extension"

load("//lib:extensions.bzl", "collect_toolchains_to_register", "toolchain_tag_class")
load(":repositories.bzl", "graalnodejs_register_toolchains")

DEFAULT_GRAALNODEJS_REPOSITORY = "graalnodejs"

def _graalnodejs_extension_impl(module_ctx):
    registrations = collect_toolchains_to_register(module_ctx, DEFAULT_GRAALNODEJS_REPOSITORY)

    for k, v in registrations.items():
        graalnodejs_register_toolchains(
            name = k,
            graaljs_version = v.graaljs_version,
        )

graalnodejs = module_extension(
    _graalnodejs_extension_impl,
    tag_classes = {
        "toolchain": toolchain_tag_class(DEFAULT_GRAALNODEJS_REPOSITORY),
    },
)
