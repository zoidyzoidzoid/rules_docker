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
"""A rule for creating a Node.js container image.
The signature of this rule is compatible with nodejs_binary.
"""

load("@bazel_skylib//lib:dicts.bzl", "dicts")
load("@build_bazel_rules_nodejs//:index.bzl", "nodejs_binary")
load("@build_bazel_rules_nodejs//:providers.bzl", "NodeRuntimeDepsInfo", "NpmPackageInfo")
load(
    "//container:container.bzl",
    "container_pull",
)
load(
    "//lang:image.bzl",
    "app_layer",
    lang_image = "image",
)
load(
    "//repositories:go_repositories.bzl",
    _go_deps = "go_deps",
)

# Load the resolved digests.
load(":nodejs.bzl", "DIGESTS")

def repositories():
    """Import the dependencies of the nodejs_image rule.

    Call the core "go_deps" function to reduce boilerplate. This is
    idempotent if folks call it themselves.
    """
    _go_deps()

    excludes = native.existing_rules().keys()
    if "nodejs_image_base" not in excludes:
        container_pull(
            name = "nodejs_image_base",
            registry = "gcr.io",
            repository = "google-appengine/debian9",
            digest = DIGESTS["latest"],
        )
    if "nodejs_debug_image_base" not in excludes:
        container_pull(
            name = "nodejs_debug_image_base",
            registry = "gcr.io",
            repository = "google-appengine/debian9",
            digest = DIGESTS["debug"],
        )

