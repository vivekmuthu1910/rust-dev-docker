echo "Building Common rust cli tools"
cargo install nu --features=extra
cargo install bat bottom cargo-cache cargo-edit cargo-watch exa fd-find hyperfine procs ripgrep sd starship tokei
echo "Done!"