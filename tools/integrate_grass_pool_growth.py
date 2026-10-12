from pathlib import Path
import shutil
r=Path('E:/OpenLeague');p=r/'crates/client/src/grass_pool.rs';s=p.read_text(encoding='utf-8');assert 'pub fn next_capacity(' not in s
s=s.replace('AllocateNode(usize)}','AllocateNode(usize),ReservePool(usize)}',1)
at=s.index('pub fn destroy(')
s=s[:at]+'''/// Native vector policy uses a 1.5 growth candidate, at least one extra slot.
pub fn next_capacity(len:usize,capacity:usize)->Result<usize,&'static str> {
    let limit=0x3fffffffusize;
    if len>capacity||capacity>limit||len>=limit{return Err("native spatial pool capacity exceeded");}
    if len<capacity{return Ok(capacity);}
    let grown=capacity.checked_add(capacity/2).filter(|v|*v<=limit).unwrap_or(0);
    Ok(grown.max(len+1))
}
fn push(pool:&mut Vec<usize>,capacity:&mut usize,index:usize,mut apply:impl FnMut(Event))->Result<(),&'static str> {
    let next=next_capacity(pool.len(),*capacity)?;
    if next!=*capacity {
        pool.try_reserve_exact(next.saturating_sub(pool.len())).map_err(|_|"spatial pool allocation failed")?;
        apply(Event::ReservePool(next));*capacity=next;
    }
    pool.push(index);Ok(())
}
'''+s[at:]
s=s.replace('fn run(tree:&mut Tree,index:usize,apply:&mut impl FnMut(Event)) {','fn run(tree:&mut Tree,index:usize,apply:&mut impl FnMut(Event))->Result<(),&\'static str> {',1)
s=s.replace('for child in tree.nodes[index].children.into_iter().flatten(){run(tree,child,apply);}','for child in tree.nodes[index].children.into_iter().flatten(){run(tree,child,apply)?;}',1)
s=s.replace('tree.nodes[index].members.clear();tree.nodes[index].detached=true;tree.pool.push(index);','tree.nodes[index].members.clear();tree.nodes[index].detached=true;push(&mut tree.pool,&mut tree.pool_capacity,index,apply)',1)
s=s.replace('run(tree,index,&mut apply);Ok(())','run(tree,index,&mut apply)',1)
s=s.replace('let queue=&mut tree.queue;let pool=&mut tree.pool;let queued=&tree.queued;','let queue=&mut tree.queue;let pool=&mut tree.pool;let queued=&tree.queued;let capacity=&mut tree.pool_capacity;let mut pool_error=None;',1)
s=s.replace('            pool.push(index);','            if let Err(error)=push(pool,capacity,index,|_|{}) {pool_error=Some(error);}',1)
s=s.replace('    if outcome==crate::grass_parent::Outcome::NeedsInsertion {','    if let Some(error)=pool_error{return Err(error);}\n    if outcome==crate::grass_parent::Outcome::NeedsInsertion {',1)
s=s.replace('Event::AllocateNode(node)=>serde_json::json!({"kind":"allocate_node","node":node})','Event::AllocateNode(node)=>serde_json::json!({"kind":"allocate_node","node":node}),Event::ReservePool(capacity)=>serde_json::json!({"kind":"reserve_pool","capacity":capacity})',1)
s=s.replace('pool:Vec::new(),max_depth:0','pool:Vec::new(),pool_capacity:32,max_depth:0')
s=s.replace('collect(),max_depth:0};','collect(),pool_capacity:32,max_depth:0};')
a=s.index(' #[test] fn queued_recursive_destruction_pool_order_and_constructor_reuse_match_original()');t=s[a:s.rfind('\n}')]
t=t.replace('queued_recursive_destruction_pool_order_and_constructor_reuse_match_original','original_capacity_growth_copy_and_reuse_match_all_native_reservations').replace('grass_pool_contract.json','grass_pool_growth_contract.json').replace('pool_capacity:32','pool_capacity:c["initial_pool_capacity"].as_u64().unwrap() as usize')
t=t.replace('        events.clear();let mut reused=Vec::new();','        assert_eq!(tree.pool_capacity,c["after_destroy"]["pool_capacity"].as_u64().unwrap() as usize);\n        events.clear();let mut reused=Vec::new();',1)
s=s[:s.rfind('\n}')]+t+s[s.rfind('\n}'):];p.write_text(s,encoding='utf-8')
sub=r/'crates/client/src/grass_subdivision.rs';s=sub.read_text(encoding='utf-8');s=s.replace('pub pool:Vec<usize>}', 'pub pool:Vec<usize>,pub pool_capacity:usize}',1).replace('pool:Vec::new(),max_depth:', 'pool:Vec::new(),pool_capacity:0,max_depth:');sub.write_text(s,encoding='utf-8')
for name in ['probe_native_grass_pool_growth.py','integrate_grass_pool_growth.py']:shutil.copy2(Path('E:/mapslol3v3')/name,r/'tools'/name)
print('Native pool growth policy connected')
