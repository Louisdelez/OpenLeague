from pathlib import Path
r=Path('E:/OpenLeague')
s=(r/'tools/probe_fow_upscale_tiles.py').read_text(encoding='utf-8')
s=s.replace("0x6b5208,count=100000","0x6b52aa,count=1000000").replace("==0x6b5208","==0x6b52aa")
s=s.replace(" assert actual==expected,(dim,pattern)",""" height=dim*4; width=height
 for y,sy in [(0,2),(1,2),(height-2,height-3),(height-1,height-3)]:
  expected[y*pitch:y*pitch+width]=expected[sy*pitch:sy*pitch+width]
 for y in range(2,height-2):
  expected[y*pitch]=expected[y*pitch+2];expected[y*pitch+1]=expected[y*pitch+2]
  expected[y*pitch+width-2]=expected[y*pitch+width-3];expected[y*pitch+width-1]=expected[y*pitch+width-3]
 assert actual==expected,(dim,pattern,[(i,a,expected[i]) for i,a in enumerate(actual) if a!=expected[i]][:8])""")
s=s.replace("'stop':'0x6b5208'","'stop':'0x6b52aa'").replace("fow_upscale_tiles_contract.json","fow_upscale_complete_contract.json")
s=s.replace('Original inner tile loop executed with supplied valid frame and buffer prerequisites.','Original tile loop, boundary row copies and boundary columns executed with supplied valid frame and buffers.')
s=s.replace('Texture lock/upload, four boundary-row copies and left/right boundary replication are not executed; full upscaler integration remains open.','Texture lock/upload and live visibility source are not executed. The four 2x2 corner blocks retain their previous bytes due row-copy-before-column order; do not replace this with generic edge clamping.')
exec(compile(s,'complete native upscale','exec'))
