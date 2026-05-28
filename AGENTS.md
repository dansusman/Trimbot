# Agent rules for Trimbot

## TDD by default

All code changes in this repo follow red → green TDD:

1. **Red** — write a failing test that pins down the new behavior, then run it and confirm it fails for the expected reason.
2. **Green** — make the smallest change that turns it green. Run the full suite (`swift test`), not just the new test.
3. **Refactor** — only after green, and only if it keeps the suite green.

This applies to bug fixes too: reproduce the bug as a failing test before touching the production code. No "fix first, test later." If a change is genuinely test-impossible (e.g. a build script tweak), say so explicitly.

Each cleanup stage in `Sources/TrimbotCore/` has a matching test suite in `Tests/TrimbotCoreTests/`. New stages or rules go in their corresponding suite (or a new one).
