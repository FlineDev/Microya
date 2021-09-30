#!/bin/bash
set -euxo pipefail

swift-format --recursive Sources/Microya Tests --in-place
swift-format lint --recursive Sources/Microya Tests
