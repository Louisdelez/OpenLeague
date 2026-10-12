fn main() {
    println!("cargo:rerun-if-changed=native/thread_name_seh.c");
    if std::env::var("CARGO_CFG_TARGET_OS").as_deref() == Ok("windows")
        && std::env::var("CARGO_CFG_TARGET_ENV").as_deref() == Ok("msvc")
    {
        cc::Build::new()
            .file("native/thread_name_seh.c")
            .compile("openleague_thread_name_seh");
    }
}
