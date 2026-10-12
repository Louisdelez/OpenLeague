import json, struct, sys
from pathlib import Path
import pefile, capstone
binary = Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe')
pe = pefile.PE(str(binary))
decoder = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
base = pe.OPTIONAL_HEADER.ImageBase
targets = [int(value, 16) for value in sys.argv[1:]] or [0x6e9da0, 0x6e9e00, 0x661410]
records = []
for section in pe.sections:
    blob = section.get_data()
    if not section.Characteristics & 0x20000000:
        continue
    origin = base + section.VirtualAddress
    hits = []
    for target in targets:
        pattern = struct.pack('<I', target)
        offset = 0
        while True:
            offset = blob.find(pattern, offset)
            if offset < 0: break
            hits.append((offset - 1, target, 'absolute operand'))
            offset += 1
    for opcode in [b'\xe8', b'\xe9']:
        offset = 0
        while True:
            offset = blob.find(opcode, offset)
            if offset < 0 or offset + 5 > len(blob): break
            target = origin + offset + 5 + struct.unpack_from('<i', blob, offset+1)[0]
            if target in targets: hits.append((offset, target, 'relative branch'))
            offset += 1
    for offset, target, kind in sorted(hits):
        start = blob.rfind(b'\xcc', max(0, offset-160), offset)
        start = start + 1 if start >= 0 else offset
        instructions = list(decoder.disasm(blob[start:offset+100], origin+start))
        records.append({'address': hex(origin+offset), 'target': hex(target), 'kind': kind, 'context': [f'{item.address:08x} {item.mnemonic} {item.op_str}' for item in instructions]})
print(json.dumps(records, indent=2))
