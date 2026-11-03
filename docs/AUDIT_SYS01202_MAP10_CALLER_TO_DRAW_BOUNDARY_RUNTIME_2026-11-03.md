# V1150 — Map10 type-3 caller to the pre-draw boundary

## Declared result

This bounded runtime unit proves one non-cached selector-0/type-3 call through the original path
`0x95AFC0 -> 0x95AD40 -> 0x95A730`, preserves the three exact V1149 owners at
`context+0x24/+0x28/+0x2c`, executes the current-host texture and sampler calls, records explicitly
qualified shader-constant/declaration/VB/IB adapters, and stops on the original instruction at
`0x95B112` before the backend draw call.

This unit does not search for historical mesh handles and does not execute Draw or Present.

## Reused evidence and exact ancestry

- V1148 parent probe:
  `E:\mapslol3v3\audit_map10_post_publication_20261103\probe_post_publication_runtime.py`
  - SHA-256: `244b77f66c886070e32917b90d042fabd5d9af0689ce6cbc94a6e81ca1ef64c3`
- V1150 static validation:
  `E:\mapslol3v3\audit_map10_draw_caller_static_20261103\map10_draw_caller_static_validation.json`
  - `passed=true`
  - SHA-256: `ad08b1c7e2ce946e4dc7a0d027b27c24b82896d0f230387100470c9f3e9498db`
- V1150 reuse validation:
  `E:\mapslol3v3\audit_map10_v1150_reuse_20261103\reuse_matrix_validation.json`
  - `passed=true`
  - SHA-256: `3fc8a4d7e223a786077a11e58f6ee2bbfd09fb3c3230a1c269252e75b0807a2a`
- Independent runtime-review matrix:
  `E:\mapslol3v3\audit_map10_v1150_runtime_review_20261103\runtime_review_matrix.json`
  - pinned SHA-256: `0c85d35b107847175f2d9e6f899b31e294ad3cd6ae6df053d6c1cd856134994b`

The runtime wrapper verifies the V1148 hash before compiling the transformed source in memory.
No product, Goal, Plan, UI, database, registry, or `F:` path was changed.

## Fixture and qualification

The batch is `<10I> = [0,0,0,0,3,0,1,0,0,0]`; argument 3 is `1`. The material type is `3`,
the selector is `0`, and all context caches at `+0x5c/+0x60/+0x64/+0x68/+0x6c` start at `-1`.

The exact registered owners are:

| Context field | V1149 owner source | Owner object | Raw current-host proxy |
|---|---|---:|---:|
| `+0x24` | `terrainHeightScale.dds` | `0x41800000` | `0x404004e0` |
| `+0x28` | `compositeColorMap.dds` | `0x41800200` | `0x40400500` |
| `+0x2c` | `fogLightingMap.dds` | `0x41800400` | `0x40400520` |

Before starting the nominal call, each run executes two harness preflight refusals derived from the
height owner produced in that same run:

| Case | Candidate derived from | Expected result |
|---|---|---|
| `owner_node_substituted` | `owner+0x88` node | rejected before `0x95AFC0` |
| `owner_wrapper_substituted` | `owner+0x8C` wrapper | rejected before `0x95AFC0` |

Both receipts record `native_continuation_attempted=false`, `original_entry_observed=false`,
`native_riot_behavior_claimed=false`, and the qualification `harness preflight only; not Riot
native behavior`. The exact owner is restored before the single nominal native call.

The complete SetTexture sequence for this call is `s0,s1,s2,s3,s4,s8,s9`.

- Only `s4/s8/s9` carry the exact-source continuity claim:
  `[heightScale, compositeColorMap, fogLightingMap]` with the same raw proxies listed above.
- `s0/s1/s2/s3` deliberately reuse `[heightScale, compositeColorMap, fogLightingMap, heightScale]`
  as a synthetic fixture. They are explicitly recorded with
  `historical_detail_texture_identity=false` and are **not** identified as the historical Map10
  detail textures.

The original backend slots `+0x68/+0x6c/+0x70` remain active for texture/shader/sampler behavior.
The following calls are deliberately adapted and every receipt records
`original_GPU_resource=false`:

- shader constants: registers 23 and 25, one register each, with the observed 16-byte payload hash;
- vertex declaration: fixture handle `0x41930000`;
- stream source: fixture VB `0x41930100`, offset 0, stride 36;
- index buffer: fixture IB `0x41930200`.

Their historical GPU-resource identities are not claimed. The selector adapter and matrix/profiling
helper adapter are also explicitly qualified in the execution receipt.

## Observed original order and boundary

Both runs observe exactly:

```text
0x95afc0
0x95b035
0x95ad40
0x95b046
0x95a730
0x95b063
0x95b0a4
0x95b0d2
0x95b112
```

At `0x95B112`:

- backend vtable: `0x10E2F30`;
- draw slot: `+0x20`;
- original target: `0x9C2400`;
- pending arguments: `[0,0,0,3,0,1]`;
- next instruction not executed: `true`;
- `DrawIndexedPrimitive` called: `false`;
- draw HRESULT observed: `false`;
- draw HRESULT: `null`.

There is no draw HRESULT because execution stops before the call. Both runs contain zero Draw or
Present events, zero invalid-memory events, `render_calls=0`, and complete current-host cleanup.
There is also no frame/backbuffer readback in the caller run. This statement does not deny the
three inherited independent readbacks that verify the content of the source textures before this
caller unit; those remain present and explicitly counted as `3`.

## Two-run determinism

The two raw execution JSON files are **not** claimed byte-identical. They differ at exactly seven
leaf values: one run timestamp, four `GetCurrentThreadId` values, and two matching single-thread
exchange `old` values. The validator classifies every differing path against those precise event
contracts; no event object or top-level section is excluded wholesale.

After only those declared volatile values are replaced, the two complete normalized execution
receipts are identical. A separate bounded acceptance projection also retains every relevant
source identity, original PC, same-run refusal, texture/sampler event, resource adapter, pending
draw argument, readback qualification and cleanup check.

- normalized semantic projection SHA-256:
  `cef75ab1c95d194b73a2540804ea44dd5926ae14438da551f0c57df68c06cd1c`
- normalized complete-execution SHA-256:
  `ce23f65450ffae0eaaa47fdb50d31cf3a3c2849a561e5e66f6fe0662ef86ac06`
- raw execution JSON byte identity: `false` (expected and fully classified)
- normalized complete execution equality: `true`
- run 1 projection equals run 2 projection: `true`
- run 1 native-byte receipt equals run 2 native-byte receipt: `true`
- native-byte receipt SHA-256:
  `350c9a5e86bfeac4df053fc57375bdeafefafce1964155f62c1479afc1cb009b`

Final execution receipts:

- run 1: `88a1eae7ad49c3c423f3eda877c6adaec517ad2fdbce96f12546cdcee4a781ce`
- run 2: `980fac91e556fbc834973dabd846c6a11bc7ec3c1d606ef979cc0fc167417bc3`

Independent validation result: `passed=true`, 13/13 aggregate checks, every per-run check true,
and assertion statuses `A11=true`, `A13=true`, `A14=true`.

## Controls actually executed

```text
python -m py_compile probe_map10_draw_boundary_runtime.py
python probe_map10_draw_boundary_runtime.py             # final run 1, exit 0
python probe_map10_draw_boundary_runtime.py             # final run 2, exit 0
python -m py_compile validate_map10_draw_boundary_runtime.py
python validate_map10_draw_boundary_runtime.py          # passed=true, exit 0
```

The final validator checks the exact V1148 parent hash, both V1150 upstream validations, the pinned
independent-review matrix, both run schemas, the two same-run harness refusals, exact original
order, exact owners, full `s0..s4,s8,s9` sequence, source-only `s4/s8/s9` claim, samplers,
adapters, pending draw arguments, absence of a draw HRESULT, absence of Draw/Present and caller
frame/backbuffer readback, inherited texture-content readbacks, zero invalid memory, cleanup,
strictly identical native receipts, exhaustive raw-JSON difference classification, identical
complete normalized executions, and identical bounded semantic projections.

## Deliverables

- `probe_map10_draw_boundary_runtime.py`
- `validate_map10_draw_boundary_runtime.py`
- `map10_draw_boundary_runtime_execution_run1.json`
- `map10_draw_boundary_runtime_execution_run2.json`
- `map10_draw_boundary_runtime_native_bytes_run1.json`
- `map10_draw_boundary_runtime_native_bytes_run2.json`
- `map10_draw_boundary_runtime_normalized_projection.json`
- `map10_draw_boundary_runtime_validation.json`
- `AUDIT_V1150_MAP10_DRAW_BOUNDARY_RUNTIME.md`

## Limits and next boundary

- This is a caller-to-pre-draw-boundary proof, not an executed draw.
- The node/wrapper refusals are harness preflight behavior, not native Riot behavior.
- The s0..s3 fixture bindings are not the historical Map10 detail textures.
- Shader constants, declaration, VB and IB are ABI adapters, not historical GPU resources.
- No draw HRESULT exists because the original call instruction is not executed.
- No caller frame/backbuffer readback occurs; the three inherited texture-content readbacks remain
  valid content checks and are not frame evidence.
- The raw execution JSON files are intentionally not described as byte-identical; only the native
  receipts are strictly byte-identical, while all raw JSON differences are classified before full
  normalization.
- No Present, frame pixel, visual-fidelity or completed terrain-render claim is made.
- Historical mesh handles and a Present path remain deliberately outside this unit.

