# Rust guidelines

- When adding dependencies to Rust projects, use `cargo add`.
- In code that uses `eyre` or `anyhow` `Result`s, consistently use
  `.context()` prior to every error-propagation with `?`. Context
  messages in `.context` should be simple present tense, such as to
  complete the sentence "while attempting to ...".
- Prefer `expect()` over `unwrap()`. The `expect` message should be very
  concise, and should explain why that expect call cannot fail.
- When designing `pub` or crate-wide Rust APIs, consult the checklist in
  <https://rust-lang.github.io/api-guidelines/checklist.html>.
- For ad-hoc debugging, create a temporary Rust example in `examples/`
  and run it with `cargo run --example <name>`. Remove the example after
  use.

### Useful Rust frameworks for testing
- **`quickcheck`**: Property-based testing for when you have an
  obviously-correct comparison you can test against.
- **`insta`**: Snapshot testing for regression prevention. Use `cargo
  insta test` as a stand-in for `cargo test` to run the snapshot tests.

### Writing compile_fail Tests

Use `compile_fail` doctests to verify when certain code should _not_
compile, such as for type-state patterns or trait-based enforcement.
Each `compile_fail` test should target a specific error condition since
the doctest only has a binary output of whether it fails to compile, not
the many reasons _why_. Make sure you clearly explain exactly WHY the
code should fail to compile.

If there is no obvious item to add the doctest to, create a new private
item with `#[allow(dead_code)]` that you add the compile-fail tests to.
Document that that's its purpose.

Before committing, create a temporary example file for each compile-fail
test and check the output of `cargo run --example <name>` to ensure it
fails for the correct reason. Remove the temporary example after.
