# AGENTS.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Repository overview

This repository is primarily documentation and an Android binary artifact for a rooted 2021 Motorola Stylus G 5G (XT-2131-1, "Denver-Global") device. There is no application source code or conventional build system here.

Top-level contents:
- `README.md`: brief personal introduction and context about the project.
- `Readme`: detailed instructions and notes on rooting the specified Motorola device with Magisk, including prerequisites and step-by-step installation guidance.
- `Magisk-v29.0 (1).apk`: Magisk Manager APK used in the rooting process.

## Development and tooling

Because this repository does not contain source code, package manifests, or build configuration files (no `package.json`, `pyproject.toml`, `Makefile`, Gradle files, etc.), there are no canonical build, lint, or test commands defined within the repo itself.

When working in this repository:
- Do not assume the presence of an Android Studio/Gradle project or any other build system.
- Treat the APK as an external artifact; if deeper analysis is needed (e.g., reverse engineering or inspection), coordinate with the user about which external Android tooling (such as APK inspection or decompilation tools) to use and how they wish those tools to be invoked.

## Key documentation for future agents

- The `Readme` file is the authoritative reference for the device, its variant (Denver-Global), and the high-level rooting workflow (TWRP, Motorola bootloader unlock, original firmware source, Magisk installation steps, and post-root notes).
- The `README.md` provides author identity and motivation; check it if you need contextual wording or to understand the intent behind sharing this repository.

Given the lack of source code or build configuration, most work here will involve:
- Clarifying or editing the written instructions.
- Helping the user reason about or adjust the described rooting process.
- Potentially guiding the user on how to organize or extend this repository if they decide to add source code or additional automation in the future.
