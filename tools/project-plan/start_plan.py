import argparse,json,pathlib,subprocess,sys,time,urllib.request,webbrowser
APP=pathlib.Path(__file__).resolve().parent
URL='http://127.0.0.1:10427/'
def health():
    try:
        with urllib.request.urlopen(URL+'api/health',timeout=1) as r:data=json.load(r)
        return data.get('app')=='openleague-plan-local/v1' and data.get('ready') is True
    except Exception:return False
def main():
    p=argparse.ArgumentParser();p.add_argument('--no-browser',action='store_true');args=p.parse_args()
    root=pathlib.Path('E:/OpenLeague');data=root/'runtime/project-plan';data.mkdir(parents=True,exist_ok=True)
    proc=None
    if not health():
        with (data/'server.log').open('ab') as log:
            proc=subprocess.Popen([sys.executable,'-E','-u','-B',str(APP/'server.py'),'--root',str(root),'--port','10427'],
              cwd=APP,stdout=log,stderr=subprocess.STDOUT,stdin=subprocess.DEVNULL,
              creationflags=getattr(subprocess,'CREATE_NO_WINDOW',0))
        for _ in range(120):
            if health():break
            if proc.poll() is not None:raise RuntimeError('Le service local n’a pas démarré. Consulter '+str(data/'server.log'))
            time.sleep(.5)
        else:raise RuntimeError('Le plan ne répond pas encore. Consulter '+str(data/'server.log'))
        (data/'server_process.json').write_text(json.dumps({'pid':proc.pid,'url':URL,'application':'openleague-plan-local/v1'},indent=2)+'\n',encoding='utf-8')
    if not args.no_browser:webbrowser.open(URL)
    print(json.dumps({'url':URL,'ready':True,'database':str(data/'plan.sqlite3'),'new_process':None if proc is None else proc.pid}),flush=True)
if __name__=='__main__':main()
