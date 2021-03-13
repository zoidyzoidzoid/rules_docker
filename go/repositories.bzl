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
"""A rule for creating a Go container image.

The signature of this rule is compatible with go_binary.
"""

# It is expected that the Go rules have been properly
# initialized before loading this file to initialize
# go_image.
load(
    "//container:container.bzl",
    "container_pull",
)
load(
    "//repositories:go_repositories.bzl",
    _go_deps = "go_deps",
)

# Load the resolved digests.
load(":go.bzl", BASE_DIGESTS = "DIGESTS")
load(":static.bzl", STATIC_DIGESTS = "DIGESTS")

def repositories():
    """Import the dependencies of the go_image rule.

    Call the core "go_deps" function to reduce boilerplate. This is
    idempotent if folks call it themselves.
    """
    _go_deps()

    excludes = native.existing_rules().keys()
    if "go_image_base" not in excludes:
        container_pull(
            name = "go_image_base",
            registry = "gcr.io",
            repository = "distroless/base",
            digest = BASE_DIGESTS["latest"],
        )
    if "go_debug_image_base" not in excludes:
        container_pull(
            name = "go_debug_image_base",
            registry = "gcr.io",
            repository = "distroless/base",
            digest = BASE_DIGESTS["debug"],
        )
    if "go_image_static" not in excludes:
        container_pull(
            name = "go_image_static",
            registry = "gcr.io",
            repository = "distroless/static",
            digest = STATIC_DIGESTS["latest"],
        )
    if "go_debug_image_static" not in excludes:
        container_pull(
            name = "go_debug_image_static",
            registry = "gcr.io",
            repository = "distroless/static",
            digest = STATIC_DIGESTS["debug"],
        )

