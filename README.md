# Structurizr DSL syntax for Sublime Text

Syntax highlighting for the [Structurizr DSL](https://docs.structurizr.com/dsl/language) — the text-based language for defining C4 software architecture models.

Highlights keywords, directives (`!include`, `!const`, …), the `->` / `-/>` relationship operators, comments (`//`, `#`, `/* */`), single- and triple-quoted strings with `${var}` interpolation, and hex colors.

## Install

### Via Package Control (recommended)

1. Open the command palette (`Ctrl+Shift+P` / `Cmd+Shift+P`)
2. Run **Package Control: Install Package**
3. Search for **Structurizr Syntax** and install

### Manual install

1. Download `Structurizr.sublime-syntax` from this repo
2. In Sublime Text: **Preferences → Browse Packages…**
3. Drop the file into the `User/` folder
4. Open any `.dsl` file — the syntax should auto-detect, or pick it via **View → Syntax → Structurizr DSL**

## File extensions

Auto-detects `.dsl` and `.structurizr`.

## Contributing

Issues and PRs welcome. If a snippet of valid DSL doesn't highlight as expected, please paste a minimal example in the issue.

## License

MIT — see [LICENSE](LICENSE).
