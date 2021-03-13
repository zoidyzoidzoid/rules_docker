# Copyright 2017 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
load("@bazel_skylib//:bzl_library.bzl", "bzl_library")
load("//tools/stardoc:index.bzl", "stardoc")

package(default_visibility = ["//visibility:public"])

licenses(["notice"])  # Apache 2.0

bzl_library(
    name = "bzl",
    srcs = glob(["**/*.bzl"]) + [
        "@build_bazel_rules_nodejs//:index.bzl",
        # "@build_bazel_rules_nodejs//:index.for_docs.bzl",
        "@build_bazel_rules_nodejs//:bzl",
        "@build_bazel_rules_nodejs//:version.bzl",
        "@build_bazel_rules_nodejs//internal/common:bzl",
        "@build_bazel_rules_nodejs//internal/node:bzl",
    ],
    deps = [
        "@build_bazel_rules_nodejs//internal/generated_file_test:bzl",
        # "@build_bazel_rules_nodejs//internal/js_library:bzl",
        "@build_bazel_rules_nodejs//internal/linker:bzl",
        # "@build_bazel_rules_nodejs//internal/pkg_npm:bzl",
        # "@build_bazel_rules_nodejs//internal/pkg_web:bzl",
        # "@build_bazel_rules_nodejs//internal/providers:bzl",
        # "@build_bazel_rules_nodejs//toolchains/node:bzl",
    ],
)

stardoc(
    name = "nodejs_image_doc",
    out = "nodejs_image.api",
    input = ":image.bzl",
    tags = ["fix-windows"],
    deps = [
        "//:bzl",
        ":bzl",
        "//container:container",
        "//lang:image",
    ],
)
