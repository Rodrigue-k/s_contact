# 🤝 Contributing to S-Contact

Thank you for your interest in contributing to S-Contact! This document provides guidelines and information for contributors.

## 📋 Table of Contents

- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Code Style](#code-style)
- [Testing](#testing)
- [Documentation](#documentation)
- [Pull Request Process](#pull-request-process)
- [Issue Reporting](#issue-reporting)

---

## 🚀 Getting Started

### 1. Fork the Repository

Click the "Fork" button in the top right corner of the repository page.

### 2. Clone Your Fork

```bash
git clone https://github.com/Rodrigue-k/s_contact.git
cd s_contact
```

### 3. Add Upstream Remote

```bash
git remote add upstream https://github.com/Rodrigue-k/s_contact.git
```

### 4. Install Dependencies

```bash
flutter pub get
```

### 5. Run the App

```bash
flutter run
```

---

## 🛠️ Development Workflow

### Creating a Feature Branch

Always create a new branch for your work:

```bash
git checkout -b feature/your-feature-name
# or for bug fixes
git checkout -b bugfix/issue-description
# or for documentation
git checkout -b docs/update-readme
```

### Making Changes

1. **Follow the existing architecture** - Maintain the current structure and patterns
2. **Write clean code** - Follow Dart best practices
3. **Add tests** - Include tests for new functionality
4. **Update documentation** - Keep README and code comments up to date

### Testing Your Changes

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Check code formatting
flutter format .

# Analyze code
flutter analyze
```

---

## 📝 Code Style

### General Guidelines

- **Use meaningful variable names** - Avoid abbreviations unless commonly understood
- **Add comments** - Explain complex logic and business rules
- **Follow Flutter conventions** - Use standard Flutter patterns and widgets
- **Keep it simple** - Prefer simple solutions over complex ones

### File Organization

```
lib/
├── core/           # Themes, constants, utilities
├── models/         # Data models (immutable)
├── providers/      # Riverpod state management
├── pages/          # Screen widgets
├── widgets/        # Reusable UI components
└── data/           # Data sources and repositories
```

---

## 🧪 Testing

We encourage writing tests for all new features and bug fixes.

### Test Structure

```
test/
├── models/         # Model tests
├── providers/      # Provider tests
├── widgets/        # Widget tests
└── integration/    # Integration tests
```

### Writing Tests

```dart
// Example unit test
test('ContactModel should format display name correctly', () {
  final contact = ContactModel(
    firstName: 'John',
    lastName: 'Doe',
    company: 'Tech Corp'
  );

  expect(contact.getDisplayName(), 'John Doe');
});

// Example widget test
testWidgets('ContactForm should show validation error', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: ContactForm(),
    ),
  );

  // Test validation logic
});
```

---

## 📚 Documentation

### Code Documentation

Add documentation comments for:
- Public classes and methods
- Complex business logic
- Configuration parameters

```dart
/// Creates a new contact with the provided information
///
/// [firstName] The contact's first name
/// [lastName] The contact's last name
/// [email] Optional email address
class ContactModel {
  // ...
}
```

### README Updates

When adding new features:
- Update the README.md
- Add screenshots if applicable
- Update feature lists
- Add setup instructions if needed

---

## 🔄 Pull Request Process

### Before Submitting

1. **Test your changes** - Ensure all tests pass
2. **Format your code** - Run `flutter format .`
3. **Analyze your code** - Run `flutter analyze`
4. **Update documentation** - Update README and comments
5. **Rebase your branch** - Keep your branch up to date with main

### Submitting a PR

1. **Create a descriptive title** - What does your PR do?
2. **Write a clear description** - Explain what you changed and why
3. **Add screenshots** - For UI changes
4. **Reference issues** - Link to related issues
5. **Fill the PR template** - Use the provided template

### PR Template

```markdown
## Description
[Brief description of changes]

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Code refactoring

## Testing
- [ ] Added unit tests
- [ ] Added widget tests
- [ ] Tested on physical device
- [ ] Tested on multiple platforms

## Screenshots
[Add screenshots for UI changes]

## Related Issues
Closes #123
```

---

## 🐛 Issue Reporting

### Bug Reports

Use the GitHub issue tracker for bug reports. Include:

- **Clear description** - What went wrong?
- **Steps to reproduce** - How can we reproduce it?
- **Expected behavior** - What should happen?
- **Actual behavior** - What actually happens?
- **Environment details** - OS, Flutter version, device

### Feature Requests

We're always open to new ideas! For feature requests:

- **Explain the use case** - Why is this feature needed?
- **Provide examples** - How would it work?
- **Suggest implementation** - Any ideas on how to implement it?

---

## 🏷️ Labels

We use the following labels to categorize issues and PRs:

- **`bug`** - Bug reports
- **`enhancement`** - Feature requests
- **`documentation`** - Documentation updates
- **`good first issue`** - Perfect for beginners
- **`help wanted`** - Looking for contributors
- **`hacktoberfest`** - Hacktoberfest-related issues
- **`question`** - Questions and discussions

---

## 🎯 Hacktoberfest

This project is Hacktoberfest-friendly! Here's how you can participate:

1. **Look for labeled issues** - Check for `hacktoberfest`, `good first issue`, `help wanted`
2. **Start small** - Bug fixes and documentation are great starting points
3. **Ask questions** - Don't hesitate to ask for help
4. **Follow guidelines** - Make sure your PRs meet quality standards

---

## 🤝 Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](https://www.contributor-covenant.org/version/2/0/code_of_conduct.html).

---

## 📞 Getting Help

- **GitHub Issues** - For bug reports and feature requests
- **Discussions** - For general questions and discussions
- **Email** - For private communications

---

Thank you for contributing to S-Contact! 🎉
