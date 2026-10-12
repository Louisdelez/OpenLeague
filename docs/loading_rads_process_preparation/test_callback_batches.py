from pathlib import Path
import sys,json,hashlib
sys.dont_write_bytecode=True
from callback_batches import drain_one_batch
OUT=Path(__file__).resolve().parent;checks=[]
def check(name,condition):assert condition,name;checks.append(name)
q=[{'id':'a'},{'id':'b'}];bad=[];seen=[]
def reenter(e):
    seen.append(e['id'])
    if e['id']=='a':
        q.append({'id':'c'});drain_one_batch(q,bad,reenter)
drain_one_batch(q,bad,reenter)
check('reentrant callbacks each invoked once',seen==['a','c','b'])
check('successful reentrant batch leaves no owner',not q and not bad)
q=[{'id':'a'},{'id':'b'}];bad=[];seen=[]
def fail(e):
    seen.append(e['id']);q.append({'id':'c'});raise RuntimeError('primary fault')
try:drain_one_batch(q,bad,fail)
except RuntimeError as e:check('primary fault preserved',str(e)=='primary fault')
check('unstarted original and new entries preserved',q==[{'id':'b'},{'id':'c'}])
check('interrupted entry has unique recorded owner',len(bad)==1 and bad[0]['entry']=={'id':'a'} and seen==['a'])
drain_one_batch(q,bad,lambda e:seen.append(e['id']))
check('retry unstarted entries never retries interrupted body',seen==['a','b','c'] and not q and len(bad)==1)
q=[{'id':'a'},{'id':'b'}];bad=[];seen=[]
def nested_fault(e):
    seen.append(e['id'])
    if e['id']=='a':
        q.extend([{'id':'c'},{'id':'d'}]);drain_one_batch(q,bad,nested_fault)
    else:raise ValueError('nested fault')
try:drain_one_batch(q,bad,nested_fault)
except ValueError:pass
check('nested interrupted bodies recorded without duplicate execution',[v['entry']['id'] for v in bad]==['c','a'] and seen==['a','c'])
check('both levels retain unstarted owners',sorted(v['id'] for v in q)==['b','d'])
result={'passed':True,'check_count':len(checks),'checks':checks,'native_execution':False,
    'scope':'Python queue ownership fault injection, not native callback error parity.',
    'source_hashes':{p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in [Path(__file__),OUT/'callback_batches.py']}}
(OUT/'callback_batch_tests.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({'passed':True,'checks':len(checks)}))
