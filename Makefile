.PHONY: build test format format-check lint dead-code check clean docs install-hooks

# Build the package in debug configuration.
build:
	swift build

# Run the full test suite.
test:
	swift test

# Rewrite source files in place using swift-format (bundled with the Swift 6 toolchain).
format:
	swift format --in-place --recursive Sources Tests Package.swift

# Verify formatting without modifying files (used in CI).
format-check:
	swift format lint --strict --recursive Sources Tests Package.swift

# Diagnose style issues without rewriting files.
lint:
	swift format lint --recursive Sources Tests Package.swift

# Detect unused (dead) public/internal declarations with Periphery.
# Install once via `brew install periphery`; config lives in .periphery.yml.
dead-code:
	@command -v periphery >/dev/null 2>&1 || { \
		echo "periphery not installed — run: brew install periphery"; exit 1; \
	}
	periphery scan --config .periphery.yml --disable-update-check

# Everything CI checks: formatting, build, tests, dead-code.
check: format-check build test dead-code

# Remove local build artifacts.
clean:
	swift package clean
	rm -rf .build

# Generate DocC documentation locally.
docs:
	swift package generate-documentation

# Point git at the repository's tracked hooks (commit-msg + pre-commit).
install-hooks:
	git config core.hooksPath .githooks
	@echo "Git hooks installed (commit-msg, pre-commit) via .githooks/"
