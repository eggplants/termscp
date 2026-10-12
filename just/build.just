# Build everything
[group('build')]
build_all: build_crates

# Build the Rust crate
[group('build')]
build_crates args="":
  cargo build --workspace {{ args }}

# Build all Rust crates in release mode
[group('build')]
build_crates_release:
  just build_crates "--release"

# Build a release binary for a target triple
[group('build')]
build_release target features="":
  cargo build --locked --release --target {{ target }} {{ features }}

# Build a static musl Linux release binary in a pinned Alpine container
[group('build')]
build_musl target:
  dist/release/build_musl.sh {{ target }}

# Build an Android release binary with cargo-ndk (requires ANDROID_NDK_HOME).
# SMB is left out: libsmbclient is not cross-compiled for Android.
[group('build')]
build_android target api="24":
  cargo ndk --target {{ target }} --platform {{ api }} build --locked --release --no-default-features --features keyring

# Package an already-built Linux release as a Debian package
[group('build')]
package_deb target:
  cargo deb --no-build --target {{ target }} --features smb-vendored

# Update Cargo.lock; pass cargo update arguments to scope the update.
[group('build')]
update_lock args="":
  cargo update {{ args }}

# Clean build artifacts
[group('build')]
[confirm("Are you sure you want to clean the build artifacts?")]
clean:
  cargo clean
