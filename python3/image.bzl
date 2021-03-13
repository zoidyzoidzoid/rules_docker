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
    "//lang:image.bzl",
    "app_layer",
)

DEFAULT_BASE = select({
    "@io_bazel_rules_docker//:debug": "@py3_debug_image_base//image",
    "@io_bazel_rules_docker//:fastbuild": "@py3_image_base//image",
    "@io_bazel_rules_docker//:optimized": "@py3_image_base//image",
    "//conditions:default": "@py3_image_base//image",
})

def py3_image(name, base = None, deps = [], layers = [], **kwargs):
    """Constructs a container image wrapping a py_binary target.

    Args:
      name: Name of the py3_image rule target.
      base: Base image to use for the py3_image.
      deps: Dependencies of the py3_image.
      layers: Augments "deps" with dependencies that should be put into
             their own layers.
      **kwargs: See py_binary.
    """
    binary_name = name + ".binary"

    if "main" not in kwargs:
        kwargs["main"] = name + ".py"

    # TODO(mattmoor): Consider using par_binary instead, so that
    # a single target can be used for all three.

    py_binary(
        name = binary_name,
        python_version = "PY3",
        deps = deps + layers,
        exec_compatible_with = ["@io_bazel_rules_docker//platforms:run_in_container"],
        **kwargs
    )

    # TODO(mattmoor): Consider making the directory into which the app
    # is placed configurable.
    base = base or DEFAULT_BASE
    for index, dep in enumerate(layers):
        base = app_layer(name = "%s.%d" % (name, index), base = base, dep = dep)
        base = app_layer(name = "%s.%d-symlinks" % (name, index), base = base, dep = dep, binary = binary_name)

    visibility = kwargs.get("visibility", None)
    tags = kwargs.get("tags", None)
    app_layer(
        name = name,
        base = base,
        entrypoint = ["/usr/bin/python"],
        binary = binary_name,
        visibility = visibility,
        tags = tags,
        args = kwargs.get("args"),
        data = kwargs.get("data"),
        testonly = kwargs.get("testonly"),
        # The targets of the symlinks in the symlink layers are relative to the
        # workspace directory under the app directory. Thus, create an empty
        # workspace directory to ensure the symlinks are valid. See
        # https://github.com/bazelbuild/rules_docker/issues/161 for details.
        create_empty_workspace_dir = True,
    )
