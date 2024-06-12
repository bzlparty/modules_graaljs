"Vendor related constants"

PLATFORMS_COMPATIBILITY = {
    "linux-amd64": ["@platforms//os:linux", "@platforms//cpu:x86_64"],
    "linux-aarch64": ["@platforms//os:linux", "@platforms//cpu:arm64"],
    "macos-amd64": ["@platforms//os:macos", "@platforms//cpu:x86_64"],
    "macos-aarch64": ["@platforms//os:macos", "@platforms//cpu:arm64"],
    "windows-amd64": ["@platforms//os:windows", "@platforms//cpu:x86_64"],
}

PLATFORMS = PLATFORMS_COMPATIBILITY.keys()

DOWNLOAD_URL = "https://github.com/oracle/graaljs/releases/download"

DEFAULT_GRAALJS_VERSION = "24.0.1"
