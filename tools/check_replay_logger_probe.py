import json
from pathlib import Path
p=json.loads(Path('E:/mapslol3v3/replay_logger_format_probe.json').read_text())
for i,c in enumerate(p['cases']):
 out=b'2014-11-20T23-59-58: '+bytes.fromhex(c['message_hex']).split(b'\0')[0]
 if c['source_hex'] is not None:
  n=c['number'];n=n-2**32 if n>=2**31 else n
  out+=b'. Line: '+str(n).encode()+b', file: '+bytes.fromhex(c['source_hex']).split(b'\0')[0]
 out=(out+b'\n')[:2559]+b'\0';expected=out+bytes([c['fill']])*(2560-len(out))
 expected=expected[:-1]+b'\0';observed=bytes.fromhex(c['buffer_hex'])
 assert expected==observed,(i,next((j for j,(a,b) in enumerate(zip(expected,observed)) if a!=b),None))
 assert [x['entry'] for x in c['calls']]==['0x993860','0xc9b551','0x993860','0xc9b551','0x5cce30','0x573fa0']
print('Exact buffer and native formatter/callback trace matches:',len(p['cases']))
