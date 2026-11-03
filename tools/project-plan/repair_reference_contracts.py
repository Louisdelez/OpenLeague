"""Bounded reference readers for repair provenance;not a runtime importer."""
import hashlib,json,math,struct

def require(v,m):
 if not v:raise ValueError(m)

def glb(b):
 require(len(b)>=28 and b[:4]==b'glTF','GLB header');require(struct.unpack_from('<II',b,4)==(2,len(b)),'GLB version/size');n,tag=struct.unpack_from('<II',b,12);require(tag==0x4e4f534a and 20+n+8<=len(b),'GLB JSON bounds');g=json.loads(b[20:20+n]);length,kind=struct.unpack_from('<II',b,20+n);require(kind==0x004e4942 and 28+n+length==len(b),'GLB BIN bounds');return g,b[28+n:]

def accessor(g,b,i):
 a=g['accessors'][i];v=g['bufferViews'][a['bufferView']];require(a['componentType']==5126 and not a.get('sparse') and not v.get('byteStride'),'Float accessor contract');dim={'SCALAR':1,'VEC2':2,'VEC3':3,'VEC4':4}[a['type']];start=v.get('byteOffset',0)+a.get('byteOffset',0);count=a['count'];require(start>=0 and start+count*dim*4<=len(b),'Accessor bounds');return [struct.unpack_from('<'+'f'*dim,b,start+j*dim*4) for j in range(count)]

def elf(name):
 h=0
 for x in name.lower().encode('ascii'):
  h=((h<<4)+x)&0xffffffff;high=h&0xf0000000
  if high:h^=high>>24
  h&=~high
 return h

def skl0_parents(b):
 require(len(b)>=64,'SKL header');size,magic,version=struct.unpack_from('<III',b,0);require(size==len(b) and magic==0x22fd4fc3 and version==0,'SKL0 format');count=struct.unpack_from('<H',b,14)[0];offset=struct.unpack_from('<i',b,20)[0];require(count>0 and offset>=64 and offset+count*100<=len(b),'SKL joints bounds');rows=[]
 for i in range(count):
  p=offset+i*100;flags,ident,parent,pad,h=struct.unpack_from('<HhhhI',b,p);nameoff=struct.unpack_from('<i',b,p+96)[0];start=p+96+nameoff;require(0<=start<len(b),'SKL name bounds');end=b.find(b'\0',start);require(end>=start,'SKL name terminator');name=b[start:end].decode('utf8');require(name and elf(name)==h,'SKL name hash');rows.append(dict(id=ident,parent=parent,name=name))
 ids={x['id']:x for x in rows};require(len(ids)==count and len({x['name'] for x in rows})==count,'SKL unique identities');require(all(x['parent']==-1 or x['parent'] in ids for x in rows),'SKL parent identity')
 for row in rows:
  seen=set();i=row['id']
  while i!=-1:require(i not in seen,'SKL hierarchy cycle');seen.add(i);i=ids[i]['parent']
 return {x['name']:None if x['parent']==-1 else ids[x['parent']]['name'] for x in rows}

def glb_parents(g):
 joints=set(g['skins'][0]['joints']);parents={c:i for i,n in enumerate(g['nodes']) for c in n.get('children',[])};return {g['nodes'][i]['name']:g['nodes'][parents[i]]['name'] if parents.get(i) in joints else None for i in joints}

def compare_endpoint(raw,g,blob,name):
 require(len(raw)>=64 and raw[:8]==b'r3d2anmd' and struct.unpack_from('<I',raw,8)[0]==4,'ANM4 header');tracks,frames,step=struct.unpack_from('<IIf',raw,28);vec,quat,frame_data=struct.unpack_from('<III',raw,52);require(frames>1 and tracks>0 and math.isfinite(step) and step>0,'ANM4 timing');require(12+frame_data+frames*tracks*12<=len(raw),'ANM4 frames bounds');samples={}
 for i in range(tracks):
  h,t,s,q,_=struct.unpack_from('<I4H',raw,12+frame_data+((frames-1)*tracks+i)*12);require(12+vec+max(t,s)*12+12<=len(raw) and 12+quat+q*16+16<=len(raw),'ANM4 sample bounds');rot=struct.unpack_from('<4f',raw,12+quat+q*16);norm=math.sqrt(sum(x*x for x in rot));require(math.isfinite(norm) and norm>1e-8,'ANM4 quaternion');require(h not in samples,'ANM4 unique track');samples[h]=dict(translation=struct.unpack_from('<3f',raw,12+vec+t*12),scale=struct.unpack_from('<3f',raw,12+vec+s*12),rotation=tuple(x/norm for x in rot))
 matches=[a for a in g['animations'] if a['name']==name];require(len(matches)==1,'Clip identity');a=matches[0];end=struct.unpack('<f',struct.pack('<f',(frames-1)*step))[0];errors=[]
 for c in a['channels']:
  sm=a['samplers'][c['sampler']];require(sm.get('interpolation','LINEAR')=='LINEAR','Clip interpolation');times=accessor(g,blob,sm['input']);out=accessor(g,blob,sm['output']);require(len(times)==len(out)==frames and abs(times[-1][0]-end)<1e-5,'Complete native endpoint');require(all(times[i][0]<=times[i+1][0] for i in range(len(times)-1)),'Clip time order');target=c['target'];expected=samples[elf(g['nodes'][target['node']]['name'])][target['path']];error=max(abs(x-y) for x,y in zip(out[-1],expected))
  if target['path']=='rotation':error=min(error,max(abs(x+y) for x,y in zip(out[-1],expected)))
  require(math.isfinite(error) and error<1e-4,'Native final sample mismatch');errors.append(error)
 require(len(errors)==tracks*3,'Complete native channel population');return dict(tracks=tracks,frames=frames,step=step,endpoint=end,channels=len(errors),maximum_error=max(errors),all_events_or_blends_qualified=False)

def bank_member(raw,source_id):
 cursor=0;chunks={}
 while cursor<len(raw):
  require(cursor+8<=len(raw),'BNK chunk header');tag,size=struct.unpack_from('<4sI',raw,cursor);start=cursor+8;require(start+size<=len(raw) and tag not in chunks,'BNK bounds/duplicate');chunks[tag]=raw[start:start+size];cursor=start+size
 require(b'DIDX' in chunks and b'DATA' in chunks and len(chunks[b'DIDX'])%12==0,'BNK media chunks');rows=[x for x in struct.iter_unpack('<III',chunks[b'DIDX']) if x[0]==source_id];require(len(rows)==1,'BNK media identity');_,off,size=rows[0];require(off+size<=len(chunks[b'DATA']),'BNK media bounds');return chunks[b'DATA'][off:off+size]
