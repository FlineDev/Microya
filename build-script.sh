#!/bin/bash
set -euxo pipefail

sourcery --sources Tests/MicroyaTests --templates .sourcery/LinuxMain.stencil --output Tests/LinuxMain.swift
swift-format --recursive Sources/Microya Tests --in-place
swift-format lint --recursive Sources/Microya Tests
