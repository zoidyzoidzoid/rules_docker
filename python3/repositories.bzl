# Copyright 2017 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""A rule for creating a Python container image.

The signature of this rule is compatible with py_binary.
"""

load("@rules_python//python:defs.bzl", "py_binary")
load(
    "//container:container.bzl",
    "container_pull",
)
load(
    "//lang:image.bzl",
    "app_layer",
)
load(
    "//repositories:go_repositories.bzl",
    _go_deps = "go_deps",
)

# Load the resolved digests.
load(":python3.bzl", "DIGESTS")

def repositories():
    """Import the dependencies of the py3_image rule.

    Call the core "go_deps" function to reduce boilerplate. This is
    idempotent if folks call it themselves.
    """
    _go_deps()

    # Register the default py_toolchain / platform for containerized execution
    native.register_toolchains(
        "@io_bazel_rules_docker//toolchains:container_py_toolchain",
    )
    native.register_execution_platforms(
        "@local_config_platform//:host",
        "@io_bazel_rules_docker//platforms:local_container_platform",
    )

    excludes = native.existing_rules().keys()
    if "py3_image_base" not in excludes:
        container_pull(
            name = "py3_image_base",
            registry = "gcr.io",
            repository = "distroless/python3",
            digest = DIGESTS["latest"],
        )
    if "py3_debug_image_base" not in excludes:
        container_pull(
            name = "py3_debug_image_base",
            registry = "gcr.io",
            repository = "distroless/python3",
            digest = DIGESTS["debug"],
        )

