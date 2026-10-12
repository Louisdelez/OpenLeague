from pathlib import Path
import json, struct, itertools, shutil
root = Path('E:/OpenLeague')
bootstrap_path = root / 'tools/qualify_native_audio_legacy_paths.py'
__file__ = str(bootstrap_path)
source = bootstrap_path.read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)', '')
exec(compile(source, __file__, 'exec'))
context = heap + 0x1000
destination = heap + 0x2000
local = heap + 0x3000
vtable = heap + 0x4000
getter = end + 0x500
storage = heap + 0x5000
input_pointer = heap + 0x6000
output_pointer = heap + 0x7000
write32(context + 8, destination)
write32(local + 0x128, vtable)
write32(vtable + 4, getter)
u.mem_write(input_pointer, b'src actor@\0')
calls = []
getters = []
def capture(uc, address, size, user):
    sp = u.reg_read(UC_X86_REG_ESP)
    if address in [0x6e9da0, 0x6e9e00]:
        calls.append({'wrapper': hex(address), 'key': read32(sp+4), 'input': u.reg_read(UC_X86_REG_ECX), 'output': u.reg_read(UC_X86_REG_EDX)})
        finish(eax=output_pointer)
    elif address == getter:
        getters.append({'this': u.reg_read(UC_X86_REG_ECX), 'storage': read32(sp+4)})
        write32(read32(sp+4), read32(storage))
        finish(4, read32(sp+4))
u.hook_add(unicorn.UC_HOOK_CODE, capture)
cases = []
callbacks = [(0x6e7970, 'source', 0x6e9da0), (0x6e7990, 'destination', 0x6e9da0), (0x6e79c0, 'local', 0x6e9da0), (0x6e7a10, 'source', 0x6e9e00), (0x6e7a30, 'destination', 0x6e9e00)]
for (entry, role, wrapper), key, has_local in itertools.product(callbacks, [0, 42, 999, 0xffffffff], [False, True]):
    calls.clear(); getters.clear()
    write32(context+4, key)
    write32(destination, (key+1)&0xffffffff)
    write32(storage, (key+2)&0xffffffff)
    write32(0x2d77f48, local if has_local else 0)
    write32(0x2d5f4c8, (key+3)&0xffffffff)
    sp = stack + 0x8000
    u.mem_write(sp, struct.pack('<IIII', end, input_pointer, context, output_pointer))
    u.reg_write(UC_X86_REG_ESP, sp)
    u.emu_start(entry, end, count=5000)
    assert u.reg_read(UC_X86_REG_EIP) == end
    expected_key = key if role == 'source' else (key+1)&0xffffffff if role == 'destination' else (key+(2 if has_local else 3))&0xffffffff
    assert calls == [{'wrapper': hex(wrapper), 'key': expected_key, 'input': input_pointer, 'output': output_pointer}], calls
    assert len(getters) == int(role == 'local' and has_local)
    assert u.reg_read(UC_X86_REG_ESP) == sp+4
    cases.append({'entry': hex(entry), 'role': role, 'source_key': key, 'has_local': has_local, 'calls': list(calls), 'getter_calls': list(getters), 'stack_delta': 4})
proof = {'native_sha256': digest, 'passed': True, 'complete': False, 'cases': cases, 'limits': ['Actual five outer callback bodies execute. Nested actor wrapper is intercepted to observe raw ID, form and ABI; full wrapper/formatter separately qualified.', 'Local virtual ID getter and context pointers supplied. Registration map construction, ownership, exceptional getters and runtime playback remain incomplete.']}
(root / 'data/4.20/audio_announcer_outer_callbacks_contract.json').write_text(json.dumps(proof, indent=2)+'\n', encoding='utf-8')
print(json.dumps({'native_callback_cases':len(cases), 'passed':True}))
