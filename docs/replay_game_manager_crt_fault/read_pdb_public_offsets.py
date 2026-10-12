"""Read local MSF7 public symbols only, without loading a PDB DLL or symbol server."""
from pathlib import Path
import mmap, struct, pefile
p=Path('E:/OpenLeague/target/debug/openleague_client.pdb')
with p.open('rb') as f:
    m=mmap.mmap(f.fileno(),0,access=mmap.ACCESS_READ)
    assert m[:32].startswith(b'Microsoft C/C++ MSF 7.00\r\n')
    block,_,count,dsize,_,blockmap=struct.unpack_from('<6I',m,32)
    db=struct.unpack_from('<'+'I'*((dsize+block-1)//block),m,blockmap*block)
    directory=b''.join(m[b*block:(b+1)*block] for b in db)[:dsize]
    streams=struct.unpack_from('<I',directory)[0];sizes=struct.unpack_from('<'+'I'*streams,directory,4)
    offset=4+4*streams;blocks=[]
    for size in sizes:
        n=0 if size==0xffffffff else (size+block-1)//block
        blocks.append(struct.unpack_from('<'+'I'*n,directory,offset));offset+=n*4
    def stream(index):return b''.join(m[b*block:(b+1)*block] for b in blocks[index])[:sizes[index]]
    dbi=stream(3);symbols=struct.unpack_from('<H',dbi,20)[0]
    print('MSF blocks',block,'streams',streams,'symbol stream',symbols,'bytes',sizes[symbols])
    pe=pefile.PE('E:/OpenLeague/target/debug/openleague-client.exe',fast_load=True)
    targets=[0x85024c,0x50bd7e,0x74496d,0x4e11bf4,0x5b2260d]
    best={target:None for target in targets};data=stream(symbols);pos=0;found=0
    while pos+4<=len(data):
        length,kind=struct.unpack_from('<HH',data,pos)
        if length<2:break
        if kind==0x110e and length>=12:
            flags,off,seg=struct.unpack_from('<IIH',data,pos+4)
            if 1<=seg<=len(pe.sections):
                address=pe.sections[seg-1].VirtualAddress+off
                for target in targets:
                    if address<=target and (best[target] is None or address>best[target][0]):
                        best[target]=(address,data[pos+14:pos+length+2].split(b'\0')[0].decode(errors='replace'))
            found+=1
        pos+=length+2
    print('public records',found)
    for target,value in best.items():print(hex(target),hex(value[0]) if value else None,'delta',hex(target-value[0]) if value else None,value[1] if value else None)
