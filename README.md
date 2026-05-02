# Trimbot

A lightweight macOS menu-bar utility that auto-cleans agent and terminal output on your clipboard. Inspired by [Trimmy](https://github.com/steipete/Trimmy) and [PasteClear](https://pasteclear.com).

Trimbot watches the system pasteboard. When you copy text, it strips terminal artifacts and agent-output noise, then writes the cleaned version back to the clipboard — so clipboard managers like [Maccy](https://maccy.app) record the *clean* version, and you paste clean text everywhere by default.

## What it cleans

The pipeline runs in this order. Each stage has its own unit tests.

1. **ANSI escape codes** — colors, cursor moves, OSC hyperlinks
2. **Invisible / AI-watermark characters** — ZWSP, ZWJ, ZWNJ, BOM, word joiner, soft hyphen; NBSP and narrow NBSP are converted to regular spaces
3. **Sidebar markers** — Claude Code-style `▎`, `│`, `┃` gutters with their trailing space, preserving paragraph breaks
4. **Box drawing** — every codepoint in U+2500–U+257F (lines, corners, tees, double/heavy variants)
5. **Shell prompts** — leading `$`, `%`, `#` followed by a space (Markdown headings like `# Release Notes` are detected and left alone; `>` is left alone for Markdown blockquotes)
6. **Wrapped URLs** — rejoins `http://` / `https://` URLs that were split across terminal line wraps
7. **Indent normalization** — strips common leading whitespace; if there's no shared prefix, falls back to per-line flatten *unless* Markdown structure is detected (lists, blockquotes, fenced code, tables), in which case indentation is preserved
8. **Trailing whitespace** — trimmed per line

## Why a separate tool from Trimmy?

[Trimmy](https://github.com/steipete/Trimmy) targets shell snippets — flattening multi-line commands so they paste-and-run. Trimbot targets the *other* common clipboard noise: agent output. When Claude Code, terminal captures, or LLM responses end up on your clipboard, they bring along leading indentation, sidebar gutters, ANSI codes, invisible AI watermark chars, and wrapped URLs. Trimbot scrubs those.

## Install

Build a `.app` bundle:

```sh
git clone https://github.com/dansusman/Trimbot.git
cd Trimbot
./Scripts/package_app.sh release
open Trimbot.app
```

The packager produces `Trimbot.app` at the repo root with `LSUIElement=true` (no Dock icon). Launch via `open`, drag it to `/Applications`, or add it to **System Settings → General → Login Items** for auto-start at login.

To launch detached so it survives terminal quit:

```sh
open ~/Trimbot/Trimbot.app
```

## Usage

Once running, the menu-bar item shows `✄`. Click it for:

- **Auto-clean: ON / OFF** — toggle clipboard watching
- **Quit Trimbot**

That's it. v0 is intentionally simple — no aggressiveness levels, no per-stage toggles. Copy something, and the next clipboard read sees the cleaned version.

A re-write loop is avoided by tagging Trimbot's own pasteboard writes with a marker pasteboard type (`com.dansusman.trimbot.marker`); the watcher skips any change it produced itself.

## CLI

A `trimbot` binary is also built:

```sh
swift build -c release
echo "    ▎ \033[1mhello\033[0m  " | .build/release/trimbot
# → hello
```

Or via `swift run`:

```sh
pbpaste | swift run trimbot
```

## Project layout

```
Sources/
  TrimbotCore/         pure cleanup library, no UI deps
    AnsiStripper.swift
    InvisibleStripper.swift
    SidebarStripper.swift
    BoxDrawingStripper.swift
    PromptStripper.swift
    UrlRewrapper.swift
    IndentNormalizer.swift
    TrailingTrimmer.swift
    Cleaner.swift      pipeline + CleanResult
  TrimbotCLI/          stdin → stdout binary
  TrimbotApp/          NSStatusItem menu-bar daemon
Tests/TrimbotCoreTests/
Scripts/package_app.sh
```

## Develop

Built with Swift 6, targets macOS 15+.

```sh
swift build
swift test       # 74 tests across 10 suites
```

TDD throughout: each cleanup stage was written red → green with its own test suite. There's also a `Markdown preservation` suite that pins down what *shouldn't* change (bold, italics, inline code, nested lists, task checkboxes, blockquotes, headings, fenced code, links, horizontal rules, tables, mixed-marker deeply-nested lists).

## Tradeoffs / known limitations

- **Markdown detection is heuristic.** A line counts as Markdown structure if it starts with a list marker (`-`, `*`, `+`, `1.`), a fence (` ``` `, `~~~`), `>`, or `|`. Mixed input that isn't quite either will pick one mode.
- **Aggressive flatten loses code indent** in unfenced code snippets that share the buffer with unindented prose. Wrap code in fences (` ``` `) to preserve.
- **Claude `⏺` bullets** are intentionally *not* treated as Markdown list markers, since the lines beneath them are usually wrap-continuations that should flatten.
- **No notarization or Sparkle yet.** Build locally, run unsigned (the packager applies an ad-hoc signature so it launches without Gatekeeper warnings on your own machine).

## License

[MIT](LICENSE)
