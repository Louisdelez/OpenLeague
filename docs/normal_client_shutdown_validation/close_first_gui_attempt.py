"""Close only the exact client window created by the first, timed-out observer."""
import importlib.util, ctypes as C, json, time, hashlib
from ctypes import wintypes as W
from pathlib import Path
here=Path(__file__).parent
spec=importlib.util.spec_from_file_location('observer',Path(r'E:\mapslol3v3\client_shutdown_refresh\gui_qualification\qualify_gui_shutdown.py'))
m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
prior=json.loads((here/'gui/qualification.json').read_text(encoding='utf-8'))
assert prior['pid']==13368 and prior['process_still_running'] and not prior['wm_close_posted']
api=m.Win32(); h=api.kernel.OpenProcess(0x101000,False,13368)
assert h
try:
    assert api.image(h)==Path(prior['executable'])
    assert m.digest(api.image(h))==prior['executable_sha256']
    window=api.window(854050,13368)
    assert window and window['title']==m.TITLE
    response=api.responsive(window['hwnd']);assert response['ok']
    assert api.user.PostMessageW(window['hwnd'],0x10,0,0)
    api.kernel.WaitForSingleObject.argtypes=[W.HANDLE,W.DWORD];api.kernel.WaitForSingleObject.restype=W.DWORD
    wait=int(api.kernel.WaitForSingleObject(h,30000))
    api.kernel.GetExitCodeProcess.argtypes=[W.HANDLE,C.POINTER(W.DWORD)];api.kernel.GetExitCodeProcess.restype=W.BOOL
    code=W.DWORD();assert api.kernel.GetExitCodeProcess(h,C.byref(code))
    report={'pid':13368,'window':window,'response':response,'wm_close_posted':True,
            'wait_result':wait,'exit_code':code.value,'forced_termination':False,
            'purpose':'retire first observer attempt; initial timeout remains preserved'}
    (here/'gui/recovery-close.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(report))
    assert wait==0 and code.value==0
finally:
    assert api.kernel.CloseHandle(h)
