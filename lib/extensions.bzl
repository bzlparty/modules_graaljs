"Utils for extensions"

load(":vendor.bzl", "DEFAULT_GRAALJS_VERSION")

def collect_toolchains_to_register(module_ctx, default_repo_name):
    """Collect all modules from the dependencies

    Args:
      module_ctx: Module context
      default_repo_name: Default name for the repository

    Returns:
      A dict with the toolchain name as a key and all properties in a `struct`
      as its value.
    """

    # The following code is adapted from the toolchains in `@aspect_bazel_lib`.
    registrations = {}
    for mod in module_ctx.modules:
        for toolchain in mod.tags.toolchain:
            if toolchain.name != default_repo_name and not mod.is_root:
                fail("Only the root module may provide a name for the node toolchain.")

            if toolchain.name in registrations.keys():
                if toolchain.name == default_repo_name:
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

    return registrations

def toolchain_tag_class(default_repo_name):
    return tag_class(attrs = {
        "name": attr.string(
            doc = "Base name for generated repositories",
            default = default_repo_name,
        ),
        "graaljs_version": attr.string(
            doc = "Version of the graaljs interpreter",
            default = DEFAULT_GRAALJS_VERSION,
        ),
    })
