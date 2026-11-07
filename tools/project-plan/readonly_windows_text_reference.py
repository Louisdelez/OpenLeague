"""Pure, bounded current-Windows text observations for isolated original code.

Only the explicit Kernel32 text whitelist below is callable. No original DLL
is loaded into Windows; these are runtime leaves, not historical CRT proof.
"""
import ctypes
import hashlib
import pathlib
import struct
import sys
from unicorn.x86_const import UC_X86_REG_EDX


class ReadonlyWindowsTextLeaf:
    SIGNATURES={
        'AreFileApisANSI':([],ctypes.c_int),
        'GetACP':([],ctypes.c_uint32),
        'GetOEMCP':([],ctypes.c_uint32),
        'GetUserDefaultLCID':([],ctypes.c_uint32),
        'VerSetConditionMask':([ctypes.c_uint64,ctypes.c_uint32,ctypes.c_uint8],ctypes.c_uint64),
        'VerifyVersionInfoA':([ctypes.c_void_p,ctypes.c_uint32,ctypes.c_uint64],ctypes.c_int),
        'VerifyVersionInfoW':([ctypes.c_void_p,ctypes.c_uint32,ctypes.c_uint64],ctypes.c_int),
        'GetVersionExA':([ctypes.c_void_p],ctypes.c_int),
        'GetVersionExW':([ctypes.c_void_p],ctypes.c_int),
        'GetCPInfo':([ctypes.c_uint32,ctypes.c_void_p],ctypes.c_int),
        'IsValidCodePage':([ctypes.c_uint32],ctypes.c_int),
        'GetStringTypeW':([ctypes.c_uint32,ctypes.c_void_p,ctypes.c_int,ctypes.c_void_p],ctypes.c_int),
        'GetStringTypeExA':([ctypes.c_uint32,ctypes.c_uint32,ctypes.c_void_p,ctypes.c_int,ctypes.c_void_p],ctypes.c_int),
        'MultiByteToWideChar':([ctypes.c_uint32,ctypes.c_uint32,ctypes.c_void_p,ctypes.c_int,ctypes.c_void_p,ctypes.c_int],ctypes.c_int),
        'WideCharToMultiByte':([ctypes.c_uint32,ctypes.c_uint32,ctypes.c_void_p,ctypes.c_int,ctypes.c_void_p,ctypes.c_int,ctypes.c_void_p,ctypes.c_void_p],ctypes.c_int),
        'GetLocaleInfoW':([ctypes.c_uint32,ctypes.c_uint32,ctypes.c_void_p,ctypes.c_int],ctypes.c_int),
        'GetLocaleInfoEx':([ctypes.c_wchar_p,ctypes.c_uint32,ctypes.c_void_p,ctypes.c_int],ctypes.c_int),
        'LCMapStringA':([ctypes.c_uint32,ctypes.c_uint32,ctypes.c_void_p,ctypes.c_int,ctypes.c_void_p,ctypes.c_int],ctypes.c_int),
        'LCMapStringW':([ctypes.c_uint32,ctypes.c_uint32,ctypes.c_void_p,ctypes.c_int,ctypes.c_void_p,ctypes.c_int],ctypes.c_int),
        'LCMapStringEx':([ctypes.c_wchar_p,ctypes.c_uint32,ctypes.c_void_p,ctypes.c_int,ctypes.c_void_p,ctypes.c_int,ctypes.c_void_p,ctypes.c_void_p,ctypes.c_size_t],ctypes.c_int),
        'IsValidLocale':([ctypes.c_uint32,ctypes.c_uint32],ctypes.c_int),
        'IsValidLocaleName':([ctypes.c_wchar_p],ctypes.c_int),
    }

    def __init__(self):
        self.kernel=ctypes.WinDLL('kernel32',use_last_error=True)
        for name,(args,result) in self.SIGNATURES.items():
            fn=getattr(self.kernel,name);fn.argtypes=args;fn.restype=result
        self.calls=[]
        self.kernel.GetACP.restype=ctypes.c_uint32
        self.observed_host_acp=self.kernel.GetACP()

    def raw_source(self,x,address,count,wide):
        signed=count if count<0x80000000 else count-0x100000000
        if signed!=-1 and not 0<signed<=0x10000:raise ValueError('Bounded text-leaf count required')
        width=2 if wide else 1
        if signed!=-1:return bytes(x.u.mem_read(address,signed*width)),signed
        raw=bytearray()
        for i in range(0x10000):
            part=bytes(x.u.mem_read(address+width*i,width));raw.extend(part)
            if part==bytes(width):return bytes(raw),-1
        raise ValueError('Unbounded text-leaf source refused')

    def handle(self,x,name,sp):
        if name not in self.SIGNATURES:return False
        fn=getattr(self.kernel,name);a=lambda n:x.rd(sp+4*n)
        input_sha=None;output=b''
        if name in ['GetUserDefaultLCID','AreFileApisANSI','GetACP','GetOEMCP']:value=fn();pop=0
        elif name=='VerSetConditionMask':
            value=fn(a(1)|(a(2)<<32),a(3),a(4)&255);pop=16
            x.u.reg_write(UC_X86_REG_EDX,value>>32)
        elif name in ['VerifyVersionInfoA','VerifyVersionInfoW','GetVersionExA','GetVersionExW']:
            length=x.rd(a(1))
            if length not in [148,156,276,284]:raise ValueError('Unqualified bounded version structure')
            buffer=ctypes.create_string_buffer(bytes(x.u.mem_read(a(1),length)))
            if name.startswith('Verify'):value=fn(buffer,a(2),a(3)|(a(4)<<32));pop=16
            else:
                value=fn(buffer);pop=4
                if value:output=buffer.raw[:length];x.u.mem_write(a(1),output)
        elif name=='IsValidCodePage':
            value=fn(a(1));pop=4
        elif name=='GetCPInfo':
            buffer=ctypes.create_string_buffer(20);value=fn(a(1),buffer);pop=8
            if value:output=buffer.raw;x.u.mem_write(a(2),output)
        elif name in ['IsValidLocale','IsValidLocaleName']:
            value=fn(a(1),a(2)) if name=='IsValidLocale' else fn(x.wstring(a(1)) if a(1) else None)
            pop=8 if name=='IsValidLocale' else 4
        elif name in ['GetStringTypeW','GetStringTypeExA']:
            wide=name=='GetStringTypeW'
            raw,count=self.raw_source(x,a(2 if wide else 3),a(3 if wide else 4),wide);source=ctypes.create_string_buffer(raw)
            chars=len(raw)//(2 if wide else 1);buffer=ctypes.create_string_buffer(chars*2)
            value=fn(a(1),source,count,buffer) if wide else fn(a(1),a(2),source,count,buffer)
            pop=16 if wide else 20;input_sha=hashlib.sha256(raw).hexdigest()
            if value:output=buffer.raw;x.u.mem_write(a(4 if wide else 5),output)
        elif name in ['GetLocaleInfoW','GetLocaleInfoEx']:
            capacity=a(4)
            if capacity>0x10000:raise ValueError('Oversized locale-leaf output')
            buffer=ctypes.create_string_buffer(max(1,capacity*2))
            locale=x.wstring(a(1)) if name.endswith('Ex') and a(1) else (None if name.endswith('Ex') else a(1))
            value=fn(locale,a(2),buffer if a(3) and capacity else None,capacity);pop=16
            if value and a(3) and capacity:output=buffer.raw[:value*2];x.u.mem_write(a(3),output)
        else:
            converting=name in ['MultiByteToWideChar','WideCharToMultiByte']
            wide_input=name in ['WideCharToMultiByte','LCMapStringW','LCMapStringEx']
            wide_output=name in ['MultiByteToWideChar','LCMapStringW','LCMapStringEx']
            raw,count=self.raw_source(x,a(3),a(4),wide_input);source=ctypes.create_string_buffer(raw)
            input_sha=hashlib.sha256(raw).hexdigest();out,capacity=a(5),a(6)
            if capacity>0x10000:raise ValueError('Oversized text-leaf output')
            if not converting and not a(2)&0x700:raise ValueError('Only bounded case/sort text mapping is qualified')
            if not converting and a(2)&0x400:wide_output=False
            prefix=[a(1),a(2),source,count]
            suffix=[];pop=24
            if name=='WideCharToMultiByte':
                default=ctypes.create_string_buffer(bytes(x.u.mem_read(a(7),2))) if a(7) else None
                used=ctypes.c_int(0);suffix=[default,ctypes.byref(used) if a(8) else None];pop=32
            elif name=='LCMapStringEx':
                if any(a(i) for i in [7,8,9]):raise ValueError('Unqualified version/reserved/sort context')
                prefix[0]=x.wstring(a(1)) if a(1) else None;suffix=[None,None,0];pop=36
            needed=fn(*prefix,None,0,*suffix)
            if needed>0x10000:raise ValueError('Text leaf result exceeds bound')
            value=needed
            if out and capacity:
                buffer=ctypes.create_string_buffer(max(1,capacity*(2 if wide_output else 1)))
                value=fn(*prefix,buffer,capacity,*suffix)
                if value:output=buffer.raw[:value*(2 if wide_output else 1)];x.u.mem_write(out,output)
            if name=='WideCharToMultiByte' and a(8):x.w(a(8),used.value)
        error=ctypes.get_last_error()
        if not value:x.dll_last_error=error
        self.calls.append({'function':name,'return_value':value,'input_sha256':input_sha,
            'output_bytes':len(output),'output_sha256':hashlib.sha256(output).hexdigest() if output else None,
            'current_host_observation':True,'historical_OS_NLS_state_qualified':False})
        x.leave(value,pop);return True

    def evidence(self):
        return {'scope':'Bounded pure Kernel32 text APIs only; native algorithms remain emulated original instructions.',
            'observed_current_host_acp':self.observed_host_acp,'host_pointer_bits':struct.calcsize('P')*8,
            'current_windows_version':list(sys.getwindowsversion()),'calls':self.calls,
            'historical_OS_NLS_state_qualified':False,'original_DLL_loaded_into_host':False}
