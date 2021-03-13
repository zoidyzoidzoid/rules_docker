#!/usr/bin/env bash
bazel build //docs && cp -f bazel-bin/docs/*.md docs

