import struct,pathlib,hashlib
def read_manifest(data):
    if len(data)<24 or data[:8]!=b'RLSM\x01\0\x01\0':raise ValueError('Manifeste RADS RLSM 1.1 attendu')
    project,release,nd=struct.unpack_from('<3I',data,8)
    pos=20
    if nd>10000 or pos+nd*20+4>len(data):raise ValueError('Table de répertoires hors limites')
    dirs=[struct.unpack_from('<5I',data,pos+i*20) for i in range(nd)];pos+=nd*20
    nf=struct.unpack_from('<I',data,pos)[0];pos+=4
    if nf>100000 or pos+nf*44+8>len(data):raise ValueError('Table de fichiers hors limites')
    raw=[data[pos+i*44:pos+(i+1)*44] for i in range(nf)];pos+=nf*44
    ns,sz=struct.unpack_from('<2I',data,pos);pos+=8
    if pos+sz!=len(data):raise ValueError('Table des chaînes hors limites')
    strings=data[pos:].split(b'\0')
    if strings[-1]!=b'' or len(strings)-1!=ns:raise ValueError('Chaînes RADS incohérentes')
    strings=[s.decode('utf-8') for s in strings[:-1]]
    if project>=ns:raise ValueError('Projet RADS invalide')
    result={};seen=set();seenfiles=set()
    def walk(i,parent):
        if i in seen or i>=nd:raise ValueError('Répertoire RADS cyclique/invalide')
        seen.add(i);name,firstsub,nsub,firstfile,nfiles=dirs[i]
        if name>=ns or firstsub+nsub>nd or firstfile+nfiles>nf:raise ValueError('Index RADS hors limites')
        path=parent+[strings[name]] if strings[name] else parent
        for j in range(firstfile,firstfile+nfiles):
            if j in seenfiles:raise ValueError('Fichier RADS dupliqué')
            seenfiles.add(j);r=raw[j];ident,version=struct.unpack_from('<2I',r)
            if ident>=ns:raise ValueError('Nom de fichier RADS invalide')
            name='/'.join(path+[strings[ident]]);p=pathlib.PurePosixPath(name)
            if p.is_absolute() or '..' in p.parts or '\\' in name or ':' in name or name in result:raise ValueError('Chemin RADS interdit')
            flags,size,compressed=struct.unpack_from('<3I',r,24)
            result[name]={'release':'.'.join(str((version>>n)&255) for n in [24,16,8,0]),'md5':r[8:24].hex(),'bytes':size,'compressed_bytes':compressed}
        for sub in range(firstsub,firstsub+nsub):walk(sub,path)
    walk(0,[])
    if len(seen)!=nd or len(seenfiles)!=nf:raise ValueError('Éléments RADS non visités')
    return {'project':strings[project],'release':'.'.join(str((release>>n)&255) for n in [24,16,8,0]),'files':result}


import pathlib,json,struct,hashlib
def read_load(data):
    if len(data)<80 or data[:8]!=b'r3d2load':raise ValueError('Invalid LOAD signature')
    version,total,start,table,count=struct.unpack_from('<5I',data,8)
    if version!=2 or total!=len(data) or table!=80 or start!=table+40*count or start>total:raise ValueError('Invalid LOAD header/bounds')
    files={};metadata=[]
    for i in range(count):
        p=table+i*40;kind,identifier,raw,length,flags,off,nameoff,namelen,relative,relname=struct.unpack_from('<10I',data,p)
        if flags!=0 or raw!=length:raise ValueError('Unsupported LOAD compression')
        if off!=p+32+relative or nameoff!=p+36+relname or off<start or nameoff!=((off+length+3)//4)*4+16 or nameoff+namelen>total:raise ValueError('Invalid LOAD entry offsets '+str((i,off,nameoff,length)))
        payload=data[off:off+length];name=data[nameoff:nameoff+namelen]
        if name[-1:]!=b'\0' or b'\0' in name[:-1]:raise ValueError('Invalid LOAD filename')
        name=name[:-1].decode('utf-8');path=pathlib.PurePosixPath(name)
        if path.is_absolute() or '..' in path.parts or '\\' in name or ':' in name or name in files:raise ValueError('Unsafe/duplicate LOAD filename')
        marker=data[off+length:nameoff]
        files[name]=payload;metadata.append({'path':name,'offset':off,'bytes':length,'opaque_marker16':marker.hex(),'sha256':hashlib.sha256(payload).hexdigest()})
    return files,metadata
