from pathlib import Path
r=Path('E:/OpenLeague')
for file in ['verify_native_fog_render.py','verify_terrain_render.py']:
 p=r/'tools'/file;s=p.read_text();s=s.replace("'VEC4':4}[a['type']]", "'VEC4':4,'MAT4':16}[a['type']]")
 s=s.replace("root_matrix=np.diag([.05,.05,-.05,1.]);root_matrix[2,3]=15398.6719/20", """root_matrix=np.diag([.05,.05,-.05,1.]);root_matrix[2,3]=15398.6719/20
node_world={}
def collect_world(index,parent):
 node=d['nodes'][index];world=parent@transform(node);node_world[index]=world
 for child in node.get('children',[]):collect_world(child,world)
for index in d['scenes'][0]['nodes']:collect_world(index,root_matrix)
skinned_nodes=[]
""")
 s=s.replace("points=(np.column_stack([pos,np.ones(len(pos))])@world.T)[:,:3]", """points=(np.column_stack([pos,np.ones(len(pos))])@world.T)[:,:3]
   if 'skin' in node:
    skin=d['skins'][node['skin']];inverse=accessor(skin['inverseBindMatrices']).reshape(-1,4,4).transpose(0,2,1);joints=accessor(p['attributes']['JOINTS_0']).astype(int);weights=accessor(p['attributes']['WEIGHTS_0']).astype(float)
    assert not d['accessors'][p['attributes']['WEIGHTS_0']].get('normalized',False),'Implement normalized weights before qualification'
    matrices=np.array([node_world[j]@inverse[k] for k,j in enumerate(skin['joints'])]);weighted=np.einsum('nq,nqij->nij',weights,matrices[joints]);points=np.einsum('nij,nj->ni',weighted,np.column_stack([pos,np.ones(len(pos))]))[:,:3];skinned_nodes.append(node.get('name',''))""")
 s=s.replace("'samples':checks", "'static_skinned_nodes_modeled':skinned_nodes,'samples':checks")
 s=s.replace("'samples':qualified", "'static_skinned_nodes_modeled':skinned_nodes,'samples':qualified")
 p.write_text(s)
