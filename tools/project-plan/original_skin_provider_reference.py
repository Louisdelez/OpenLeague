"""Original resource-provider queries over explicitly supplied native tree state.

Package construction, host provider initialization and compiled cache remain
separate. This removes the boolean Contains adapter from the previous probe.
"""
import pathlib,struct
import sys
R=pathlib.Path('E:/OpenLeague');sys.path.insert(0,str(R/'tools/project-plan'))
from native_skin_loader_reference import OriginalSkinLoader
from unicorn.x86_const import *


class OriginalSkinProvider(OriginalSkinLoader):
    def __init__(self,binary):
        self.native_filename_mode=False
        self.native_registration_mode=False
        self.any_original_alias_registration=False
        self.any_original_queries=False
        self.native_scale_reader=None
        self.profiles=[]
        super().__init__(binary)
        self.original_ranges=[(self.base+s.VirtualAddress,self.base+s.VirtualAddress+max(s.Misc_VirtualSize,s.SizeOfRawData)) for s in self.pe.sections if s.Characteristics&0x20000000]

    def reset(self):
        self.current_original_alias_registration=False
        super().reset()

    def allocate_node(self):
        p=self.node_heap;self.node_heap+=0x80
        if self.node_heap>=self.work+0x18000:raise ValueError('Supplied native map arena exhausted')
        self.u.mem_write(p,bytes(0x80));return p

    def tree(self,at,items,nested=False):
        # MSVC32 tree: sentinel(left,parent,right,color,isnil), then key@10,
        # mapped value@28. Parent/children and order are explicit input state.
        head=self.allocate_node();self.w(at,head);self.w(at+4,len(items))
        self.u.mem_write(head+12,b'\x01\x01')
        ordered=sorted(items.items(),key=lambda x:x[0] if nested else x[0].lower())
        def build(values,parent):
            if not values:return head
            mid=len(values)//2;name,value=values[mid];node=self.allocate_node()
            self.w(node+4,parent);self.u.mem_write(node+12,b'\x01\x00');self.assign(node+0x10,name)
            if nested:self.tree(node+0x28,value)
            else:self.assign(node+0x28,value)
            self.w(node,build(values[:mid],node));self.w(node+8,build(values[mid+1:],node));return node
        root=build(ordered,head);self.w(head+4,root)
        left=right=root
        if root!=head:
            while self.rd(left)!=head:left=self.rd(left)
            while self.rd(right+8)!=head:right=self.rd(right+8)
        self.w(head,left);self.w(head+8,right)
        return head

    @staticmethod
    def validate_profiles(profiles):
        if not isinstance(profiles,list) or not 1<=len(profiles)<=16:raise ValueError('Explicit provider profile list required')
        names=[]
        for row in profiles:
            if set(row)!={'context','local','base'}:raise ValueError('Provider profile fields invalid')
            context=row['context']
            if not isinstance(context,str) or not context or len(context)>512 or not context.isascii() or '\0' in context:raise ValueError('Provider context invalid')
            names.append(context)
            for kind in ['local','base']:
                values=row[kind]
                if not isinstance(values,dict) or len(values)>100:raise ValueError('Bounded explicit file map required')
                keys=[]
                for name,path in values.items():
                    if not isinstance(name,str) or not name or len(name)>100 or not name.isascii() or '\0' in name or not isinstance(path,str) or not path or len(path)>512 or not path.isascii() or '\0' in path:raise ValueError('Provider file identity/path invalid')
                    keys.append(name.lower())
                if len(set(keys))!=len(keys):raise ValueError('Ambiguous case-insensitive native file keys')
        if len(set(names))!=len(names):raise ValueError('Duplicate provider context')

    def configure(self):
        self.node_heap=self.work+0x6000
        provider=self.work+0x1000;base=self.work+0x4500
        self.w(provider,0x10d64a8);self.w(provider+0x10,0);self.w(provider+0x14,base)
        self.tree(provider+8,{x['context']:x['local'] for x in self.profiles},True)
        self.tree(base+0x18,{x['context']:x['base'] for x in self.profiles},True)
        prior=0
        for row in reversed(self.profiles):
            p=self.allocate_node();self.w(p,prior);self.assign(p+4,row['context']);prior=p
        self.w(0x2d78f20,prior)
        # Preinitialized empty-string singletons: avoid process-level atexit
        # bootstrap unrelated to resource lookup, and report this boundary.
        self.w(0x2d8de80,1);self.assign(0x2d8de30,'')
        self.w(0x2d8de8c,1);self.assign(0x2d8de68,'')
        self.allowed=list(self.original_ranges)
        self.native_queries=[]

    def hook(self,uc,address,size,unused):
        if address==0xc975f5:
            if self.u.reg_read(UC_X86_REG_ECX)!=self.rd(0x1222ed0):raise ValueError('Original caller security-cookie value diverged')
            # The valid native cookie check preserves the caller's EAX/AL.
            # Numeric getters return their success flag before this epilogue.
            value=self.u.reg_read(UC_X86_REG_EAX)
            self.calls.append({'adapter':'security_cookie_check_preserving_eax','compared_original_cookie':True})
            self.leave(value);return
        if address==0x8b1f50 and self.native_scale_reader is not None:
            sp=self.u.reg_read(UC_X86_REG_ESP);section=self.cstring(self.rd(sp+8));field=self.cstring(self.rd(sp+12));default=struct.unpack('<f',self.u.mem_read(sp+16,4))[0]
            if field!='SkinScale' or self.rd(sp+4)!=self.work+0x3000 or self.rd(sp+20)!=0:raise ValueError('Unexpected compiled section lookup transfer')
            result=self.native_scale_reader.scalar_lookup(section,field,default)
            bits=bytes.fromhex(result['float32_hex'])
            self.u.mem_write(self.float_value,bits);self.calls.append({'adapter':'native_compiled_numeric_lookup_transfer','section':section,'field':field,'original_default':default,'getter':result,'selected_float32_hex':bits.hex()})
            self.u.reg_write(UC_X86_REG_EIP,self.float_stub);return
        if self.native_registration_mode:
            sp=self.u.reg_read(UC_X86_REG_ESP)
            if address==0x9933e0:
                count=self.rd(sp+4)
                if not 0<count<=0x10000:raise ValueError('Unqualified native allocation size')
                p=self.node_heap;self.node_heap+=(count+15)&~15
                if self.node_heap>=self.work+0x18000:raise ValueError('Isolated native allocation arena exhausted')
                self.u.mem_write(p,bytes(count));self.calls.append({'adapter':'native_allocation_boundary','bytes':count,'address':hex(p)})
                self.leave(p);return
            if address==0xc98528:
                p=self.rd(sp+4)
                if p and not self.work+0x6000<=p<self.work+0x30000:raise ValueError('Unqualified native free pointer')
                self.calls.append({'adapter':'isolated_arena_free','address':hex(p)});self.leave();return
            if address==0xca1ef0:
                out,source,count=[self.rd(sp+i) for i in [4,8,12]]
                if count>0x10000:raise ValueError('Unqualified native byte-copy length')
                self.u.mem_write(out,bytes(self.u.mem_read(source,count)));self.calls.append({'adapter':'byte_copy_boundary','bytes':count});self.leave(out);return
            if address in [0x90cdb0,0x5fadb0]:
                # Execute native map insertion / native value move, rather than
                # the earlier alias experiment's explicit map adapters.
                self.visited.add(address);self.case_visited.add(address);return
        if self.native_filename_mode and address==0x56e0d0:
            self.configure()
        if address==0x9041e0:
            self.any_original_queries=True
            sp=self.u.reg_read(UC_X86_REG_ESP)
            self.native_queries.append({'kind':'Contains','logical_name':self.string(self.rd(sp+4))})
        elif address==0x9042e9:
            self.native_queries[-1]['result']=bool(self.u.reg_read(UC_X86_REG_EAX)&255)
        elif address==0x903ee0:self.any_original_queries=True
        # String state is supplied, but comparison/tree traversal and provider
        # loops run in original code, including case folding at993780.
        super().hook(uc,address,size,unused)

    def invoke(self,entry,args=(),ecx=0,edx=0):
        stack=self.work+0x40000
        for i,v in enumerate([self.finish,*args]):self.w(stack+4*i,v)
        self.u.reg_write(UC_X86_REG_ESP,stack);self.u.reg_write(UC_X86_REG_ECX,ecx);self.u.reg_write(UC_X86_REG_EDX,edx)
        self.u.emu_start(entry,self.finish,count=1000000)
        if self.u.reg_read(UC_X86_REG_EIP)!=self.finish:raise ValueError('Original provider call did not return '+hex(entry))
        return self.u.reg_read(UC_X86_REG_EAX)

    def register_physical_files(self,physical_paths):
        if not isinstance(physical_paths,list) or not physical_paths or len(physical_paths)>50:raise ValueError('Explicit bounded physical file list required')
        self.reset();self.profiles=[{'context':'reference-DATA','local':{},'base':{}}];self.configure()
        outer_head=self.rd(self.work+0x1008);outer_node=self.rd(outer_head+4);inner=outer_node+0x28
        self.native_registration_mode=True
        try:
            sentinel=self.invoke(0x6542a0)
            self.w(inner,sentinel);self.w(inner+4,0)
            for physical in physical_paths:
                if not isinstance(physical,str) or not physical.isascii() or '\0' in physical or '..' in physical or '/' not in physical or len(physical)>512:raise ValueError('Unqualified physical reference path')
                parent,name=physical.rsplit('/',1)
                folder_arg=self.work+0x3000;name_arg=self.work+0x3500
                self.assign(folder_arg,parent);self.assign(name_arg,name)
                self.invoke(0x905090,[inner],folder_arg,name_arg)
            entries=self.tree_entries(inner)
            self.any_original_alias_registration=True
            self.current_original_alias_registration=True
            return {'entries':entries,'native_map_count':self.rd(inner+4),'adapter_calls':list(self.calls),
                    'original_addresses_exercised':len(self.case_visited),'original_alias_map_registration_executed':True,
                    'host_directory_enumeration_executed':False,'tree_invariants_verified':['parent_links','ordered_keys','size','red_black_colors_and_height']}
        finally:self.native_registration_mode=False

    def tree_entries(self,map_address):
        head=self.rd(map_address);seen=set();entries={}
        if self.u.mem_read(head+13,1)[0]!=1:raise ValueError('Original alias sentinel invariant failed')
        root=self.rd(head+4)
        if root!=head and self.u.mem_read(root+12,1)[0]!=1:raise ValueError('Original alias tree root color invariant failed')
        def walk(node,parent):
            if node==head:return 1
            if node in seen or len(seen)>200 or self.rd(node+4)!=parent or self.u.mem_read(node+13,1)[0]!=0:raise ValueError('Original alias tree link invariant failed')
            seen.add(node);left=self.rd(node);right=self.rd(node+8);color=self.u.mem_read(node+12,1)[0]
            if color not in [0,1] or (color==0 and any(child!=head and self.u.mem_read(child+12,1)[0]==0 for child in [left,right])):raise ValueError('Original alias tree color invariant failed')
            left_height=walk(left,node);name=self.string(node+0x10)
            if name in entries:raise ValueError('Duplicate original alias tree key')
            entries[name]=self.string(node+0x28);right_height=walk(right,node)
            if left_height!=right_height:raise ValueError('Original alias tree black-height invariant failed')
            return left_height+color
        walk(root,head)
        if len(entries)!=self.rd(map_address+4):raise ValueError('Original alias tree size invariant failed')
        if list(entries)!=sorted(entries,key=str.lower):raise ValueError('Original alias tree ordering invariant failed')
        return entries

    def filename_registered(self,champion,number):
        self.inputs(champion,number)
        if not self.current_original_alias_registration:raise ValueError('Register actual physical resources before querying')
        legacy=self.work+0x3800;out=self.work+0x1200;flag=self.work+0x1300
        self.u.mem_write(legacy,(champion+'.ini').encode('ascii')+b'\0');self.assign(out,'')
        self.native_queries=[]
        self.invoke(0x56e0d0,[legacy,number,out,flag,self.work+0x1000])
        return {'logical_name':self.string(out),'dedicated':bool(self.u.mem_read(flag,1)[0]),
                'provider_queries':list(self.native_queries),'original_resource_provider_executed':True,
                'original_alias_map_registration_executed':True,'original_directory_package_discovery_executed':False}

    def resolve_registered(self,logical_name):
        if not self.current_original_alias_registration:raise ValueError('Register actual physical resources before querying')
        if not isinstance(logical_name,str) or not logical_name or not logical_name.isascii() or '\0' in logical_name or len(logical_name)>100:raise ValueError('Invalid logical resource identity')
        arg=self.work+0x5000;self.assign(arg,logical_name)
        result=self.invoke(0x903ee0,[arg],self.work+0x1000)
        return {'logical_name':logical_name,'path':self.string(result),'original_resource_provider_executed':True,
                'original_alias_map_registration_executed':True,'original_directory_package_discovery_executed':False}

    def section_using_compiled_reader(self,champion,number,dedicated,reader):
        self.native_scale_reader=reader
        try:result=super().section(champion,number,dedicated,{})
        finally:self.native_scale_reader=None
        result['native_compiled_lookup_transfers']=[x for x in self.calls if x['adapter']=='native_compiled_numeric_lookup_transfer']
        result['python_inibin_lookup_used']=False
        return result

    def filename_native(self,champion,number,profiles):
        self.validate_profiles(profiles);self.profiles=profiles;self.native_filename_mode=True
        try:
            result=super().filename(champion,number,[])
        finally:self.native_filename_mode=False
        result['original_resource_provider_executed']=True
        result['provider_queries']=list(self.native_queries)
        result['supplied_package_maps']=profiles
        result['original_package_map_construction_executed']=False
        return result

    def resolve_path(self,logical_name,profiles):
        self.validate_profiles(profiles)
        if not isinstance(logical_name,str) or not logical_name or len(logical_name)>100 or not logical_name.isascii() or '\0' in logical_name:raise ValueError('Explicit logical name required')
        self.reset();self.profiles=profiles;self.configure()
        arg=self.work+0x5000;self.assign(arg,logical_name)
        stack=self.work+0x40000;self.w(stack,self.finish);self.w(stack+4,arg)
        self.u.reg_write(UC_X86_REG_ESP,stack);self.u.reg_write(UC_X86_REG_ECX,self.work+0x1000)
        self.u.emu_start(0x903ee0,self.finish,count=100000)
        if self.u.reg_read(UC_X86_REG_EIP)!=self.finish:raise ValueError('Original GetResolvedPath did not return')
        return {'logical_name':logical_name,'path':self.string(self.u.reg_read(UC_X86_REG_EAX)),
                'original_resource_provider_executed':True,'original_package_map_construction_executed':False,
                'original_addresses_exercised':len(self.case_visited),'adapter_calls':list(self.calls)}

    def evidence(self):
        result=super().evidence()
        result.update(original_resource_provider_executed=self.any_original_queries,original_package_map_construction_executed=False,
                      original_compiled_config_cache_executed=False,
                      original_alias_map_registration_executed=self.any_original_alias_registration)
        result['native_query_entries']={'Contains':'0x9041e0','GetResolvedPath':'0x903ee0',
            'file_tree_lower_bound':'0x90d1d0','context_tree_lower_bound':'0x5c2b70',
            'file_key_case_insensitive_compare':'0x993780','context_byte_compare':'0x5fa6b0'}
        result['adapters']=[x for x in result['adapters'] if not x.startswith('Provider Contains')]
        result['adapters']+=['Explicit native-layout sentinel/tree state and provider list are supplied from the declared local/base resource maps. Original query loops, tree traversals and comparisons execute; no Contains boolean or path-lookup adapter is used.',
            'When register_physical_files is used, the inner map sentinel constructor, alias registration, nodes, balancing/insertion and value moves execute in original code. Only allocation/free/copy boundaries and the documented string helpers are adapted; physical directory/package discovery and outer provider bootstrap remain supplied.',
            'Empty-string singletons are preinitialized to avoid unrelated process-level atexit registration. Original package constructor/host provider bootstrap and compiled cache are not executed.']
        result['limits']=['Queries qualify the explicitly supplied map/list state only; original map population, directory/package discovery, cache initialization, compiled payload opening and full process context remain unqualified.',
            'No current game skin dispatch, asset inheritance, renderer, ownership/availability or complete skin/game acceptance is proved.']
        return result
