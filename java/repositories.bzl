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
"""A rule for creating a Java container image.

The signature of java_image is compatible with java_binary.

The signature of war_image is compatible with java_library.
"""

load("@bazel_skylib//lib:dicts.bzl", "dicts")
load("@bazel_tools//tools/build_defs/repo:jvm.bzl", "jvm_maven_import_external")
load(
    "//container:container.bzl",
    "container_pull",
    _container = "container",
)
load(
    "//lang:image.bzl",
    "layer_file_path",
    lang_image = "image",
)
load(
    "//repositories:go_repositories.bzl",
    _go_deps = "go_deps",
)

# Load the resolved digests.
load(
    ":java.bzl",
    _JAVA_DIGESTS = "DIGESTS",
)
load(
    ":jetty.bzl",
    _JETTY_DIGESTS = "DIGESTS",
)

def repositories():
    """Import the dependencies of the java_image rule.

    Call the core "go_deps" function to reduce boilerplate. This is
    idempotent if folks call it themselves.
    """
    _go_deps()

    excludes = native.existing_rules().keys()
    if "java_image_base" not in excludes:
        container_pull(
            name = "java_image_base",
            registry = "gcr.io",
            repository = "distroless/java",
            digest = _JAVA_DIGESTS["latest"],
        )
    if "java_debug_image_base" not in excludes:
        container_pull(
            name = "java_debug_image_base",
            registry = "gcr.io",
            repository = "distroless/java",
            digest = _JAVA_DIGESTS["debug"],
        )
    if "jetty_image_base" not in excludes:
        container_pull(
            name = "jetty_image_base",
            registry = "gcr.io",
            repository = "distroless/java/jetty",
            digest = _JETTY_DIGESTS["latest"],
        )
    if "jetty_debug_image_base" not in excludes:
        container_pull(
            name = "jetty_debug_image_base",
            registry = "gcr.io",
            repository = "distroless/java/jetty",
            digest = _JETTY_DIGESTS["debug"],
        )
    if "javax_servlet_api" not in excludes:
        jvm_maven_import_external(
            name = "javax_servlet_api",
            artifact = "javax.servlet:javax.servlet-api:3.0.1",
            artifact_sha256 = "377d8bde87ac6bc7f83f27df8e02456d5870bb78c832dac656ceacc28b016e56",
            server_urls = ["https://repo1.maven.org/maven2"],
            licenses = ["notice"],  # Apache 2.0
        )

