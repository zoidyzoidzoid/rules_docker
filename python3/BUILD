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
    name = "image_bzl",
    srcs = ["image.bzl"],
    visibility = ["//visibility:private"],
)

bzl_library(
    name = "python3_bzl",
    srcs = ["python3.bzl"],
    visibility = ["//visibility:private"],
)

bzl_library(
    name = "bzl",
    srcs = glob(["**/*.bzl"]) + [
        "@bazel_tools//tools/python:private/defs.bzl",
        "@bazel_tools//tools/python:srcs_version.bzl",
        "@bazel_tools//tools/python:toolchain.bzl",
        "@bazel_tools//tools/python:utils.bzl",
    ],
    deps = [
        "@io_bazel_skydoc//stardoc:stardoc.bzl",
        "@rules_python//docs:defs",
    ],
)

stardoc(
    name = "python3_image_doc",
    out = "python3_image.api",
    input = ":image.bzl",
    tags = ["fix-windows"],
    deps = [
        "//:bzl",
        ":bzl",
        "//container:container",
        "//lang:image",
    ],
)
