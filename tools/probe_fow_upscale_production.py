from pathlib import Path
r=Path('E:/OpenLeague')
s=(r/'tools/probe_fow_upscale_complete.py').read_text(encoding='utf-8')
needle="s=s.replace(\"0x6b5208,count=100000\",\"0x6b52aa,count=1000000\").replace(\"==0x6b5208\",\"==0x6b52aa\")"
replacement="""s=s.replace("source=heap+0x8000; output=heap+0x12000", "source=0x40000000; output=0x40010000")
s=s.replace("table=bytes(u.mem_read", "u.mem_map(0x40000000,0x100000)\\ntable=bytes(u.mem_read")
s=s.replace("[(2,p,128,129) for p in range(16)]+[(d,p,0,255) for d in [3,8] for p in [0,1,2,3]]", "[(128,p,0,255) for p in [0,1,2,3]]")
s=s.replace("0x6b5208,count=100000","0x6b52aa,count=10000000").replace("==0x6b5208","==0x6b52aa")"""
assert needle in s;s=s.replace(needle,replacement)
s=s.replace("exec(compile(s,'complete native upscale','exec'))", """s=s.replace("cases.append({'dimension':dim", """+repr("runs=[]\n for value in actual:\n  if runs and runs[-1][0]==value:runs[-1][1]+=1\n  else:runs.append([value,1])\n cases.append({'dimension':dim")+""" )
s=s.replace("'output':list(actual)","'output_runs':runs")
s=s.replace("'source':list(values)","'source_pattern':'full0/full255/alternating-x/alternating-y'")
s=s.replace('fow_upscale_complete_contract.json','fow_upscale_production_contract.json')
exec(compile(s,'production native upscale','exec'))""")
exec(compile(s,'production probe builder','exec'))
