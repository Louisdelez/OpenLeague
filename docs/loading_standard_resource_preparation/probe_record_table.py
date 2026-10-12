"""Actual57C930 table publication, then bounded57D77A selection.
Diagnostic packet rows are explicit inputs. No resource provider or texture is
substituted: continuation stops before first57C590 or before unrelated57D901.
"""
from pathlib import Path
exec(compile((Path(__file__).parent/'probe_resource.py').read_text().split('\ncases=[]')[0], 'native resource primitives', 'exec'))
SOURCE=H+0x9000; PACKET=H+0x7000; RECORD=H+0x5000; PROVIDER=H+0x6000; TABLE=0x14c7630
selection=None
def observe_selection(uc,pc,size,user):
    global selection
    if phase!='selection':return
    if pc in (0x57d7d4,0x57d901):
        visited.discard(pc)
        sp=u.reg_read(UC_X86_REG_ESP)
        selection={'stop':pc,'record_hex':bytes(u.mem_read(RECORD,120)).hex(),'borrowed_provider_saved':read32(sp+(0x20 if pc==0x57d7d4 else 0x1c)),'next_arguments':{'this_out24':u.reg_read(UC_X86_REG_ECX),'provider_edx':u.reg_read(UC_X86_REG_EDX),'identifier':read32(sp)} if pc==0x57d7d4 else None};u.emu_stop()
u.hook_add(unicorn.UC_HOOK_CODE,observe_selection)
cases=[]
try:
    for fill in [0,165]:
        for match in [-1,0,5,11]:
            poison=fill;phase='table_setup';u.mem_write(TABLE-16,bytes([0x8a])*(12*181+32));rows=bytearray()
            for index in range(12):
                row=bytearray(((i*13+index*5+fill)&255) for i in range(181))
                row[0:4]=(index+10).to_bytes(4,'little');row[4:8]=(0x80000000+index).to_bytes(4,'little');row[8:10]=(0xfff0+index).to_bytes(2,'little');row[10:14]=(0x12340000+index).to_bytes(4,'little')
                rank=[b'UNRANKED',b'BRONZE',b'GOLD',b'unranked',b'bronze',b'Bronzex'][index%6];row[0x97:]=rank+b'\0'+bytes(181-0x97-len(rank)-1);rows.extend(row)
            u.mem_write(SOURCE,bytes(rows));before=bytes(rows);phase='table_publish';call(0x57c930,SOURCE)
            wanted=bytearray(rows)
            for index in range(12):
                if index%6 in [0,1,3,4]:wanted[index*181+0x97]=0
            assert bytes(u.mem_read(TABLE,2172))==wanted and bytes(u.mem_read(SOURCE,2172))==before
            assert bytes(u.mem_read(TABLE-16,16))==bytes([0x8a])*16 and bytes(u.mem_read(TABLE+2172,16))==bytes([0x8a])*16
            low,high=(999,0xffffffff) if match<0 else (match+10,0x80000000+match)
            write32(PACKET+4,low);write32(PACKET+8,high);u.mem_write(RECORD,bytes([fill])*120);record_before=bytes(u.mem_read(RECORD,120));sp=STACK+0x1d000;u.mem_write(sp-4,bytes([fill])*0x200)
            u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ESI,PACKET);u.reg_write(UC_X86_REG_EBX,RECORD);u.reg_write(UC_X86_REG_EAX,PROVIDER)
            phase='selection';selection=None;u.emu_start(0x57d77a,END,count=100000);assert selection is not None
            expected=bytearray(record_before)
            if match>=0:
                expected[0x1c:0x20]=(TABLE+181*match).to_bytes(4,'little');expected[0x48:0x4c]=(0xfff0+match).to_bytes(4,'little')
                assert selection['stop']==0x57d7d4 and selection['next_arguments']=={'this_out24':sp+0x4c,'provider_edx':PROVIDER,'identifier':0x12340000+match}
            else:assert selection['stop']==0x57d901
            assert bytes(u.mem_read(RECORD,120))==expected and selection['borrowed_provider_saved']==PROVIDER
            assert bytes(u.mem_read(TABLE,2172))==wanted and not live
            cases.append({'fill':fill,'match':match,'input_rows_hex':before.hex(),'published_rows_hex':wanted.hex(),'key':[low,high],'selection':selection})
    proof={'passed':True,'complete':False,'source_sha256':digest,'cases':cases,'executed_instruction_addresses':sorted(visited),'limits':['Actual57C930 copies12 diagnostic rows of181 bytes and clears only first rank byte for UNRANKED or BRONZE, compared case-insensitively by actualC9CF31/C9CEF8 in the initial C locale. Outer58A51E packet producer and complete packet validation are not run.','Selection starts explicitly after provider return57D77A with opaque borrowed provider and packet/record preconditions. Match stops before57C590 body; no match stops before57D901 body. No nonempty UI completion, texture, INI reader, localization or renderer is claimed.']}
except Exception as e:
    traceback.print_exc();proof={'passed':False,'error':repr(e),'pc':hex(u.reg_read(UC_X86_REG_EIP)),'phase':phase,'cases':cases,'trail':list(trail)}
(OUT/'native_table_oracle.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps({'passed':proof['passed'],'cases':len(cases),'native_addresses':len(visited)}))
if not proof['passed']:sys.exit(1)
