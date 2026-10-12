# Generic standard loading-prefix integration stage

Six complete Rust source files are staged here. Production and both earlier frozen preparations are unchanged. No Rust compiler or test has run for this integration stage.

## API shared with the Windows adapter

```rust
audio_loading_screen_packet::receive(
    backend, kind, recipient, payload25, scratch24
) -> Result<(), ReceiveFailure>

enum ReceiveFailure {
    Operation(audio_replay_metadata::Error),
    Owned(audio_loading_owned_string::Failure),
}
```

`Owned` preserves `primary`, `cleanup`, and `remaining: Option<Temporary>`. It is used for standard errors after the name provider has successfully transferred its output. Even when cleanup succeeds, a standard primary error is still `Owned` with `remaining=None`. Before that transfer, errors are `Operation`. The tutorial retains its previous qualified flow and maps its previous metadata errors into `Operation`; this variant is not a universal assertion that arbitrary tutorial/provider failure has no pending resources.

The consumer boundary now requires the explicit owned-string `release_owned` contract: a returned error releases nothing; success retires that allocation once. There is no blanket opt-in for arbitrary free backends.

```rust
fn initialize_standard_record(
    &mut self,
    recipient: u32,
    record: u32,
    payload: u32,
    retained_service: u32,
    name: &mut audio_loading_owned_string::Temporary,
) -> Result<(), audio_replay_metadata::Error>;

audio_loading_standard_prefix::prepare(
    backend, recipient, retained_service, payload, name, scratch8
) -> Result<Stop, audio_replay_metadata::Error>
```

`audio_loading_standard_prefix::Boundary` combines the existing real metadata provider boundary and the explicit owned-string boundary. The Windows adapter supplies its initializer by calling `prepare`, then returns `Error::Boundary(stop.unavailable())`. Neither `90AD00` nor `991E60` is simulated or reported as UI success.

The consumer retains the service value loaded before its first name lookup. The prefix reads its vtable+4C from that exact service, calls the real `service_extra`, stops before the negative diagnostic, or reads the actual `2D78F1C` package global before the recipient skin override. No second service-global lookup is added.

## Ownership and scratch

The standard branch creates a single `Temporary` only after successful `service_name`. It passes the guard to the initializer and calls `owned::finish` once on every standard post-provider result. Its old `drop_string` call is removed. Partial assignment publication leaves `Authority::Detached(new_pointer)` so cleanup never rereads a mixed descriptor or frees the former heap again.

The Windows caller must reserve an ownership-retirement slot before dispatch and retain its scratch lease alongside `Failure.remaining` before converting the error to text. A remaining `Authority::Descriptor` still needs the descriptor bytes; the scratch pool cannot reclaim that block. `pending` and descriptor ownership can survive independently. The host adapter is supplied separately by `replay_path_registry`; this generic stage does not by itself implement or qualify that ledger.

The tutorial still executes the original record float copies, clock boundary, standard deallocation and String24 reset in the same order. Its only change here is the outer `Operation` error wrapper. No global `audio_loading_metadata::assign` helper is renamed or modified.

## Source and fixture dependencies

Root must add library declarations for `audio_loading_owned_string` and `audio_loading_standard_prefix`, then install their test fixtures at:

- `data/4.20/loading_owned_string_probe.json`: take the 128-case derived fixture from `E:/mapslol3v3/loading_string24_ownership_repair`.
- `data/4.20/loading_standard_prefix_probe.json`: take the 128-case fixture with three source seed regions from `E:/mapslol3v3/loading_standard_prefix_port`.

The manifest records both exact paths and hashes. Existing record/tutorial/empty-name/x87 fixtures remain those already used by production. The image must contain the genuine four bytes at `2D78F1C` before the Windows prefix can read that global; a zero source value does not construct a resource manager.

These modules reuse existing metadata, String24 name provider, record-tree, object-index, control/pair, Storage and removal error contracts. The owned module is byte-identical to the frozen ownership proposal. It deliberately does not alter the old metadata helper's persistent-cache lifetime contract.

## Prepared verification, not yet executed

- Six existing consumer tests retain 1600 hot-record cases, 256 first tutorial cases, 26 physical x87 cases and 64 standard empty-name calls, plus explicit unsupported/provider/cleanup failures. Standard cleanup failure now checks the returned descriptor-authoritative guard and an explicit retry while scratch remains live.
- Four owned-string tests compare 128 focused native success/skip cases, exact descriptor/heap state at 16 write failures, combined primary+cleanup error, and failures before ownership transfer.
- Four prefix tests compare 128 full native stops, six changed-service-global cases, 16 publication failures through real `receive` plus name/index providers, and combined publication+cleanup failure returning a detached guard until retry.

The native fixture's post-stop cleanup is a separately captured source cleanup reentry; it is not evidence that an unimplemented UI call returned successfully. All 16 full-consumer write faults are deliberate host error injections; they do not establish an ordinary Windows failure with valid, exclusive storage.

The full UI/resource provider, negative diagnostic body, normal screen factories, actual normal service publication/lifecycle and visual fidelity remain outside this bounded integration.
