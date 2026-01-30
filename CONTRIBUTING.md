# Contributing to SxnnyUI

Thank you for your interest in contributing to SxnnyUI. This document provides guidelines and instructions for contributing to the project.

## Getting Started

### Prerequisites

- Xcode 15.0 or later
- Swift 6.0 or later
- macOS 13.0 or later for development

### Supported Platforms

SxnnyUI supports the following platforms:

- iOS 15.0+
- macOS 12.0+
- tvOS 15.0+
- watchOS 8.0+
- visionOS 1.0+

### Setting Up the Development Environment

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/SxnnyUI.git
   cd SxnnyUI
   ```

2. Open the package in Xcode:
   ```bash
   open Package.swift
   ```

3. Build the project to verify your setup:
   ```bash
   swift build
   ```

4. Run tests:
   ```bash
   swift test
   ```

## Project Structure

The project follows a standard Swift Package structure:

- `Sources/SxnnyUI/` - Main library code
  - `Components/` - Reusable UI components (buttons, labels, text fields)
  - `Extensions/` - Swift and SwiftUI extensions
  - `Layout/` - Layout containers and utilities
  - `Manager/` - Service managers (alerts, keychain)
  - `Modifiers/` - Custom view modifiers
  - `Theme/` - Theming system
  - `Utilities/` - Helper utilities and formatters
- `Tests/SxnnyUITests/` - Unit and integration tests

## Coding Standards

### Swift API Design Guidelines

Follow the [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/) for all code contributions.

Key principles:

- **Clarity at the point of use** is the most important goal
- Use clear, descriptive names
- Omit needless words
- Name according to roles, not types
- Compensate for weak type information
- Strive for fluent usage

### SwiftUI Conventions

- Prefix custom components with `Sxnny` to avoid namespace collisions
- Use view modifiers for styling and behavior
- Keep views small and composable
- Prefer `@State` and `@Binding` for local state management
- Use `@Environment` for shared configuration

### Code Style

- Use 4 spaces for indentation
- Maximum line length of 120 characters
- Use Swift's modern concurrency features where appropriate
- Mark types as `public`, `internal`, or `private` explicitly
- Document public APIs with doc comments

### Documentation

All public APIs must include documentation comments:

```swift
/// A brief description of what the type or function does.
///
/// A more detailed explanation if needed, including usage examples.
///
/// - Parameters:
///   - parameter1: Description of parameter1
///   - parameter2: Description of parameter2
/// - Returns: Description of the return value
public func exampleFunction(parameter1: String, parameter2: Int) -> Bool {
    // implementation
}
```

## Commit Message Guidelines

Write clear, concise commit messages following these conventions:

### Format

```
<type>: <subject>

<body>

<footer>
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, missing semicolons, etc.)
- `refactor`: Code refactoring without changing functionality
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `chore`: Maintenance tasks, dependency updates

### Examples

```
feat: add SxnnyCard component with shadow support

Implement a card component with customizable shadow, corner radius,
and padding. Supports both light and dark mode.

Closes #42
```

```
fix: resolve layout issue in SxnnyGrid on iPad

The grid was not properly calculating column widths on iPad in
landscape orientation. Updated the layout logic to use available
width correctly.
```

## Pull Request Process

### Before Submitting

1. Ensure your code builds without warnings
2. Run all tests and verify they pass
3. Update documentation for any API changes
4. Add tests for new features or bug fixes
5. Verify your changes work on all supported platforms where applicable

### Submitting a Pull Request

1. Fork the repository and create a new branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes following the coding standards

3. Commit your changes with clear commit messages

4. Push to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

5. Open a pull request with:
   - Clear title describing the change
   - Detailed description of what changed and why
   - Reference to any related issues
   - Screenshots or examples for UI changes

### Pull Request Title Format

Use the same format as commit messages:

```
feat: add new component
fix: resolve issue with existing component
docs: update contributing guidelines
```

## Review Process

### What to Expect

- Maintainers will review your PR within 5 business days
- You may be asked to make changes or provide clarification
- Once approved, a maintainer will merge your PR
- Your contribution will be included in the next release

### Review Criteria

Pull requests are evaluated on:

- Code quality and adherence to Swift conventions
- Test coverage and quality
- Documentation completeness
- API design and consistency with existing code
- Performance implications
- Cross-platform compatibility

## Testing

### Writing Tests

- Write unit tests for new functionality
- Update existing tests when modifying behavior
- Use descriptive test names that explain what is being tested
- Follow the Arrange-Act-Assert pattern

Example:

```swift
func testButtonTriggerActionOnTap() {
    // Arrange
    var actionTriggered = false
    let button = RoundedButton(title: "Test") {
        actionTriggered = true
    }
    
    // Act
    button.action()
    
    // Assert
    XCTAssertTrue(actionTriggered)
}
```

### Running Tests

Run all tests:
```bash
swift test
```

Run tests for a specific platform:
```bash
xcodebuild test -scheme SxnnyUI -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Reporting Issues

When reporting issues, include:

- Clear description of the problem
- Steps to reproduce
- Expected behavior
- Actual behavior
- Platform and version information
- Code samples or screenshots if applicable

Use the appropriate issue template for bug reports or feature requests.

## Questions

If you have questions about contributing, feel free to:

- Open a discussion on GitHub
- Ask in an issue or pull request
- Contact the maintainers at houjouzetaalpha@gmail.com

## License

By contributing to SxnnyUI, you agree that your contributions will be licensed under the same license as the project.
