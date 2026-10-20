"""Loopback-only HTML + SQLite project planner. Python standard library only."""
import argparse,http.server,json,pathlib,socketserver,sys,tempfile,urllib.parse
from store import Store,Invalid,Conflict

APP=pathlib.Path(__file__).resolve().parent
class Server(http.server.ThreadingHTTPServer):
    daemon_threads=True
    def __init__(self,address,store):self.store=store;super().__init__(address,Handler)
class Handler(http.server.BaseHTTPRequestHandler):
    server_version='OpenLeaguePlan/1.0'
    def log_message(self,fmt,*args):
        # No instructions or private notes in access logs.
        if self.path.startswith('/api/health'):return
        sys.stdout.write('%s %s\n'%(self.command,self.path.split('?')[0]));sys.stdout.flush()
    def permitted(self):
        host=self.headers.get('Host','')
        allowed={f'127.0.0.1:{self.server.server_port}',f'localhost:{self.server.server_port}'}
        if host not in allowed:return False
        origin=self.headers.get('Origin')
        return not origin or origin in {'http://'+h for h in allowed}
    def send_data(self,status,raw,mime='application/json; charset=utf-8',download=None):
        self.send_response(status);self.send_header('Content-Type',mime);self.send_header('Content-Length',str(len(raw)))
        self.send_header('Cache-Control','no-store');self.send_header('X-Content-Type-Options','nosniff')
        self.send_header('Referrer-Policy','no-referrer');self.send_header('X-Frame-Options','DENY')
        self.send_header('Content-Security-Policy',"default-src 'self'; style-src 'self' 'unsafe-inline'; script-src 'self' 'unsafe-inline'; img-src 'self' data:; connect-src 'self'; base-uri 'none'; frame-ancestors 'none'")
        if download:self.send_header('Content-Disposition',f'attachment; filename="{download}"')
        self.end_headers()
        try:self.wfile.write(raw)
        except (BrokenPipeError,ConnectionResetError):pass
    def send_json(self,data,status=200):self.send_data(status,json.dumps(data,ensure_ascii=False).encode('utf-8'))
    def do_GET(self):
        if not self.permitted():self.send_json({'error':'Origine locale requise.'},403);return
        u=urllib.parse.urlsplit(self.path);q=urllib.parse.parse_qs(u.query);one=lambda k,default='':q.get(k,[default])[0]
        try:
            if u.path in ['/','/index.html','/OpenLeague_PLAN_INTERACTIF.html']:
                self.send_data(200,(APP/'index.html').read_bytes(),'text/html; charset=utf-8')
            elif u.path=='/api/audit':
                self.send_data(200,(self.server.store.root/'docs/PLAN_AUDIT_2026-10-20.md').read_bytes(),'text/markdown; charset=utf-8',download='OpenLeague_AUDIT_DU_PLAN.md')
            elif u.path=='/api/health':self.send_json({'app':'openleague-plan-local/v1','ready':True,'port':self.server.server_port})
            elif u.path=='/api/bootstrap':self.send_json(self.server.store.summary())
            elif u.path=='/api/tasks':self.send_json(self.server.store.list_packages(one('phase'),one('q'),one('status','all'),int(one('page','1'))))
            elif u.path.startswith('/api/task/'):
                self.send_json(self.server.store.task(urllib.parse.unquote(u.path[len('/api/task/'):])) )
            elif u.path=='/api/copy':self.send_json(self.server.store.copy_text(one('kind'),one('id')))
            elif u.path=='/api/export':
                self.send_data(200,json.dumps(self.server.store.export(),ensure_ascii=False,indent=2).encode('utf-8'),download='OpenLeague_suivi.json')
            elif u.path=='/api/backup':
                with tempfile.TemporaryDirectory(prefix='plan-backup-',dir=self.server.store.data_dir) as temp:
                    p=pathlib.Path(temp)/'plan.sqlite3';self.server.store.backup(p)
                    self.send_data(200,p.read_bytes(),'application/vnd.sqlite3',download='OpenLeague_plan_sauvegarde.sqlite3')
            elif u.path=='/favicon.ico':self.send_data(204,b'','image/x-icon')
            else:self.send_json({'error':'Page introuvable.'},404)
        except Conflict as e:self.send_json({'error':str(e)},409)
        except (Invalid,ValueError,KeyError) as e:self.send_json({'error':str(e)},400)
        except Exception:
            self.send_json({'error':'Impossible de lire le plan local. Le serveur a conservé la base.'},500)
            import traceback;traceback.print_exc()
    def do_POST(self):
        if not self.permitted():self.send_json({'error':'Origine locale requise.'},403);return
        if self.headers.get_content_type()!='application/json':self.send_json({'error':'JSON requis.'},415);return
        try:
            size=int(self.headers.get('Content-Length','0'))
            if not 1<=size<=16*1024*1024:raise Invalid('Taille de requête invalide.')
            data=json.loads(self.rfile.read(size));path=urllib.parse.urlsplit(self.path).path
            if path=='/api/status':result=self.server.store.change(data.get('updates'))
            elif path=='/api/undo':result=self.server.store.undo(data.get('change_id'))
            elif path=='/api/import':result=self.server.store.import_progress(data)
            else:self.send_json({'error':'Action inconnue.'},404);return
            self.send_json(result)
        except Conflict as e:self.send_json({'error':str(e)},409)
        except (Invalid,ValueError,KeyError,TypeError,AttributeError) as e:self.send_json({'error':str(e)},400)
        except Exception:
            self.send_json({'error':'L’enregistrement a échoué. Réessaie après avoir actualisé la page.'},500)
            import traceback;traceback.print_exc()

def main():
    parser=argparse.ArgumentParser();parser.add_argument('--root',default='E:/OpenLeague');parser.add_argument('--data-dir');parser.add_argument('--port',type=int,default=10427)
    args=parser.parse_args();data=args.data_dir or str(pathlib.Path(args.root)/'runtime/project-plan')
    store=Store(args.root,data)
    server=Server(('127.0.0.1',args.port),store)
    print(json.dumps({'url':f'http://127.0.0.1:{server.server_port}/','database':str(store.path),'ready':True}),flush=True)
    try:server.serve_forever()
    except KeyboardInterrupt:pass
    finally:server.server_close()
if __name__=='__main__':main()
