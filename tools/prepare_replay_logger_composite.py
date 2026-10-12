from pathlib import Path
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3')
t=(r/'crates/core/src/audio_replay_logger.rs').read_text(encoding='utf-8')
t=t.replace('    Callback(callback::Error),','    Callback(callback::Error),\n    Free(remove::Error),')
before=t[t.index('fn delete('):t.index('///8F9000')]
after='''pub const COMPOSITE_VTABLE:u32=0x10d5f64;
pub const COMPOSITE_DELETE:u32=0x901860;
pub const COMPOSITE_CLONE:u32=0x901750;
pub const COMPOSITE_INVOKE:u32=0x901840;
/// Native virtual callback deletion, including recursive composite children.
pub fn delete(b:&mut impl Boundary,p:u32)->Result<(),Error>{
    if p==0{return Ok(());}
    let vt=b.word(p)?;let method=b.word(vt)?;
    match method {
        callback::HANDLER_DELETE=>{callback::scalar_delete_callback(b,p,1)?;Ok(())},
        COMPOSITE_DELETE=>{delete_composite(b,p,1)?;Ok(())},
        _=>Err(Error::UnknownCallback(method)),
    }
}
pub fn delete_composite(b:&mut impl Boundary,p:u32,flags:u32)->Result<u32,Error>{
    let second=b.word(add(p,8)?)?;delete(b,second)?;
    let first=b.word(add(p,4)?)?;delete(b,first)?;
    Storage::write_word(b,p,0x1084ed4)?;
    if flags&1!=0{let route=b.deallocator().map_err(Error::Free)?;b.free(p,route).map_err(Error::Free)?;}
    Ok(p)
}
pub fn clone_callback(b:&mut impl Boundary,p:u32)->Result<u32,Error>{
    if p==0{return Ok(0);}
    let vt=b.word(p)?;let method=b.word(add(vt,4)?)?;
    if method==callback::HANDLER_CLONE{return Ok(callback::clone_callback(b,p)?);}
    if method!=COMPOSITE_CLONE{return Err(Error::UnknownCallback(method));}
    let q=b.allocate_callback_clone(12).map_err(Error::Boundary)?;
    if q==0{return Ok(0);}
    Storage::write_word(b,q,COMPOSITE_VTABLE)?;
    let first=b.word(add(p,4)?)?;let first=clone_callback(b,first)?;Storage::write_word(b,add(q,4)?,first)?;
    let second=b.word(add(p,8)?)?;let second=clone_callback(b,second)?;Storage::write_word(b,add(q,8)?,second)?;
    Ok(q)
}
///9016C0 clones two wrappers; inputs are addresses containing callback pointers.
pub fn construct_composite(b:&mut impl Boundary,p:u32,first:u32,second:u32)->Result<u32,Error>{
    Storage::write_word(b,p,COMPOSITE_VTABLE)?;
    let a=b.word(first)?;let a=clone_callback(b,a)?;Storage::write_word(b,add(p,4)?,a)?;
    let c=b.word(second)?;let c=clone_callback(b,c)?;Storage::write_word(b,add(p,8)?,c)?;
    Ok(p)
}
///9014F0 creates and clones a temporary composite, then deletes the temporary.
pub fn compose(b:&mut impl Boundary,out:u32,first:u32,second:u32)->Result<(),Error>{
    let p=b.allocate(12)?;
    if p!=0{construct_composite(b,p,first,second)?;}
    let q=clone_callback(b,p)?;Storage::write_word(b,out,q)?;delete(b,p)
}
///8F9380 consumes the incoming wrapper's callback and keeps a clone of the
/// composed chain. Scratch is one caller-owned word, not an engine allocation.
pub fn append_callback(b:&mut impl Boundary,logger:u32,incoming_slot:u32,scratch:u32)->Result<(),Error>{
    let field=add(logger,32)?;compose(b,scratch,field,incoming_slot)?;
    let temp=b.word(scratch)?;let cloned=clone_callback(b,temp)?;
    let old=b.word(field)?;Storage::write_word(b,field,0)?;Storage::write_word(b,field,cloned)?;
    delete(b,old)?;delete(b,temp)?;
    let incoming=b.word(incoming_slot)?;delete(b,incoming)
}
pub fn invoke_callback(b:&mut impl Output,p:u32,message:u32)->Result<u8,Error>{
    if p==0{return Err(Error::NullCallback);}
    let vt=b.word(p)?;let method=b.word(add(vt,8)?)?;
    if method==COMPOSITE_INVOKE{
        let a=b.word(add(p,4)?)?;let _=invoke_callback(b,a,message)?;
        let c=b.word(add(p,8)?)?;return invoke_callback(b,c,message);
    }
    if method!=INVOKE{return Err(Error::UnknownCallback(method));}
    let owner=b.word(add(p,4)?)?;let member=b.word(add(p,8)?)?;
    if member==DEFAULT_MEMBER{Ok(1)}else{b.invoke_member(owner,member,message).map_err(Error::Boundary)}
}
'''
t=t.replace(before,after)
a=t.index('    if p == 0 {',t.index('pub fn write_message('));z=t.index('    Ok(())\n}',a)
t=t[:a]+'    let _ = invoke_callback(b,p,BUFFER)?;\n'+t[z:]
(s/'audio_replay_logger.rs').write_text(t,encoding='utf-8')
print('Prepared polymorphic native logger callback chains')
