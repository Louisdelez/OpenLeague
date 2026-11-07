"""Identify client build and available server configuration as read-only evidence."""
import argparse,hashlib,json,pathlib,re,xml.etree.ElementTree as ET
from reference_client import load_reference,validate as validate_client,extract_client
from frontend_builds import digest,safe_source

CONTRACT='docs/reference_game_server_4_20.json'
class ConfigEvidenceError(ValueError):pass
GAME_FLAGS=['MANACOSTS_ENABLED','COOLDOWNS_ENABLED','CHEATS_ENABLED','MINION_SPAWNS_ENABLED','IS_DAMAGE_TEXT_GLOBAL',
            'TRAINING_MODE','TRAINING_START_LEVEL','TRAINING_START_GOLD','TRAINING_GOD_MODE']
SETTINGS_NAMES={'GameInfo.json','GameInfo.json.template','GameServerSettings.json','GameServerSettings.json.template','MasterRegistry.json'}

def jsonc(text):
    """Read Json.NET-style comments/trailing commas without changing strings."""
    chars=list(text.lstrip('\ufeff'));i=0;quoted=False;escape=False
    while i<len(chars):
        c=chars[i]
        if quoted:
            if escape:escape=False
            elif c=='\\':escape=True
            elif c=='"':quoted=False
            i+=1;continue
        if c=='"':quoted=True;i+=1;continue
        if c=='/' and i+1<len(chars) and chars[i+1] in ['/', '*']:
            block=chars[i+1]=='*';start=i;i+=2
            if block:
                while i+1<len(chars) and ''.join(chars[i:i+2])!='*/':i+=1
                if i+1>=len(chars):raise ConfigEvidenceError('Commentaire JSON non terminé.')
                i+=2
            else:
                while i<len(chars) and chars[i] not in '\r\n':i+=1
            for j in range(start,i):
                if chars[j] not in '\r\n':chars[j]=' '
            continue
        i+=1
    # Remove only a structural trailing comma, not a comma inside a string.
    quoted=False;escape=False
    for i,c in enumerate(chars):
        if quoted:
            if escape:escape=False
            elif c=='\\':escape=True
            elif c=='"':quoted=False
        elif c=='"':quoted=True
        elif c==',':
            j=i+1
            while j<len(chars) and chars[j].isspace():j+=1
            if j<len(chars) and chars[j] in '}]':chars[i]=' '
    try:
        def unique(pairs):
            d={}
            for k,v in pairs:
                if k in d:raise ConfigEvidenceError('Clé JSON dupliquée.')
                d[k]=v
            return d
        return json.loads(''.join(chars),object_pairs_hook=unique)
    except json.JSONDecodeError as e:raise ConfigEvidenceError('Configuration JSON illisible.') from e

def summarize_settings(path):
    p=pathlib.Path(path);d=jsonc(p.read_text(encoding='utf-8-sig'))
    if not isinstance(d,dict):raise ConfigEvidenceError('Objet de configuration attendu.')
    if p.name.startswith('GameInfo'):
        game=d.get('game');players=d.get('players');info=d.get('gameInfo')
        if not isinstance(game,dict) or not isinstance(players,list) or not isinstance(info,dict):raise ConfigEvidenceError('Structure GameInfo manquante.')
        if type(game.get('map')) is not int or not isinstance(game.get('gameMode'),str):raise ConfigEvidenceError('Carte/mode non identifiés.')
        flags={k:info[k] for k in GAME_FLAGS if k in info}
        return {'kind':'community_game_profile','format':'Json.NET JSON with comments supported',
                'game':{k:game[k] for k in ['map','gameMode','dataPackage'] if k in game},'game_flags':flags,
                'players_count':len(players),'teams':sorted({str(x.get('team','unknown')).upper() for x in players}),
                'forced_start_seconds_literal':d.get('forcedStart'),
                'sensitive_player_fields_omitted':True,'player_values_exported':False}
    if p.name.startswith('GameServerSettings'):
        return {'kind':'community_debug_client_autostart','auto_start_client':d.get('autoStartClient'),
                'client_location_present':bool(d.get('clientLocation')),'effective_only_in_debug_block':True}
    if p.name=='MasterRegistry.json':
        url=d.get('MasterUrl','')
        return {'kind':'community_master_registry','master_url_configured':bool(url),
                'master_is_loopback':bool(re.match(r'^https?://(?:127\.0\.0\.1|localhost)(?::|/|$)',url)),
                'public':d.get('Public'),'heartbeat_interval_seconds':d.get('HeartbeatIntervalSeconds'),
                'private_or_user_fields_omitted':True}
    raise ConfigEvidenceError('Type de configuration non répertorié.')

def settings_inventory(root):
    root=pathlib.Path(root);out=[]
    for f in sorted((root/'GameServerConsole').rglob('*')):
        if f.is_file() and f.name in SETTINGS_NAMES and 'obj' not in f.relative_to(root).parts:
            out.append({'path':f.relative_to(root).as_posix(),**digest(f),'summary':summarize_settings(f)})
    return out

def client_config_inventory(root):
    root=pathlib.Path(root);out=[]
    for sub in ['Config','RADS/system','RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/cfg']:
        for f in sorted((root/sub).rglob('*')):
            if f.is_file() and f.suffix.lower() in ['.cfg','.ini','.json']:
                out.append({'path':f.relative_to(root).as_posix(),**digest(f),
                            'classification':'client/system or shipped defaults; not proof of a running Riot server'})
    return out

def shipped_defaults(root):
    folder=pathlib.Path(root)/'RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/cfg/defaults'
    out={}
    whitelist={'localaddr','NumClients','TeamID','batchPackets','NetworkTimeOutMin','NetworkTimeOutMax','ServerCompressionEnabled',
               'OverallServerFPSCap','NetworkMetrics','ServerIPLogging'}
    for name in ['Game.cfg','GamePermanent.cfg','GameFeatures.cfg']:
        section='';fields={}
        for line in (folder/name).read_text(encoding='utf-8-sig').splitlines():
            t=line.strip()
            if t.startswith('[') and t.endswith(']'):section=t[1:-1]
            elif '=' in t and not t.startswith((';','#')):
                k,v=t.split('=',1)
                if k.strip() in whitelist:fields[section+'.'+k.strip()]=v.strip()
        out[name]=fields
    return out

def source_contracts(roots):
    """Extract documented knobs from their real source consumers, not process env."""
    def read(role,rel):return safe_source(roots[role],rel).read_text(encoding='utf-8-sig')
    main=read('project','crates/server/src/main.rs');owner=read('project','crates/server/src/owned_session.rs')
    launcher=read('project','launcher/src-tauri/src/sessions.rs');core=read('project','crates/core/src/lib.rs')
    cs=read('community','GameServerConsole/Program.cs');config=read('community','GameServerLib/Config.cs')
    registry=read('community','GameServerLib/MasterRegistry.cs');master=read('legacy','master-server/src/main.rs')
    packet=read('community','GameServerLib/Packets/PacketServer.cs')
    def one(pattern,text,label):
        matches=re.findall(pattern,text)
        if len(matches)!=1:raise ConfigEvidenceError('Consommateur absent ou ambigu : '+label)
        return matches[0]
    bind=one(r'std::env::var\("OPENLEAGUE_SERVER"\)\.unwrap_or_else\(\|_\| "([^"\r\n]+)"\.into\(\)\)',main,'adresse Rust')
    address=one(r'pub const ADDRESS: &str = "([^"]+)";',launcher,'adresse launcher')
    tick=int(one(r'pub const TICK_RATE: u64 = (\d+);',core,'fréquence Rust'))
    if 'game.enable_map10()' not in main or 'UdpSocket::bind(&address)' not in main or 'serde_json::from_slice' not in main:raise ConfigEvidenceError('Chemin serveur Rust divergent.')
    if '"OPENLEAGUE_ALLOW_PAUSE").as_deref()==Ok("1")' not in main:raise ConfigEvidenceError('Règle pause divergente.')
    if '"OPENLEAGUE_OWNED_STDIN"' not in owner or 'must be absent or 1' not in owner:raise ConfigEvidenceError('Contrat ownership absent.')
    port=int(one(r'Option\("port", Default = \(ushort\)(\d+)\)',cs,'port LeagueSandbox'))
    client_version=one(r'VERSION_STRING = "Version ([0-9.]+) \[PUBLIC\]"',config,'version annoncée LeagueSandbox')
    if 'new Host(Version.Patch420, new Address(_serverHost, port)' not in packet or 'Address.Any' not in packet:raise ConfigEvidenceError('Transport communautaire non identifié.')
    config_path=one(r'Option\("config", Default = "([^"]+)"\)',cs,'GameInfo CLI')
    settings_path=one(r'Option\("config-gameserver", Default = "([^"]+)"\)',cs,'GameServerSettings CLI')
    for needle in ['!string.IsNullOrEmpty(currentJsonString)','File.Exists(filePath)','File.WriteAllText(filePath, defaultJsonString)','Resources.GameInfo']:
        if needle not in cs:raise ConfigEvidenceError('Priorité/ressource de configuration non identifiée.')
    master_env=sorted(set(re.findall(r'GetEnvironmentVariable\("(LOLSBX_[A-Z_]+)"\)',registry)))
    master_port=int(one(r'var\("LOLSBX_PORT"\)[\s\S]{0,140}?unwrap_or\((\d+)\)',master,'port master'))
    if 'SocketAddr::from(([0, 0, 0, 0], port))' not in master:raise ConfigEvidenceError('Adresse master non identifiée.')
    return {'openleague':{'source_origin':'local_rust_reconstruction','transport':'UDP, local JSON session protocol',
        'default_bind':bind,'launcher_forced_bind':address,'map_id_enabled_in_code':10,'tick_rate_hz':tick,
        'settings':{'OPENLEAGUE_SERVER':'bind address; default above','OPENLEAGUE_ALLOW_PAUSE':'enabled only by literal 1',
          'OPENLEAGUE_OWNED_STDIN':'absent = independent; 1 = launcher pipe ownership; other values refused'},
        'config_file_loader_for_server_settings':False},
        'community':{'source_origin':'LeagueSandbox modified community source; not Riot server source','declared_client_version':client_version,
          'transport':'ENet Patch420 with per-player Blowfish keys; source declaration only','bind_policy':'Address.Any with CLI port',
          'default_game_port':port,'game_info_path_relative_to_working_directory':config_path,'debug_client_settings_path':settings_path,
          'config_priority':['explicit --config-json','--config path if existing','embedded GameInfo template, written when missing'],
          'other_cli_options':['--config-gameserver','--config-gameserver-json','--port'],
          'master_config_priority':['LOLSBX_MASTER_URL with siblings when URL nonempty','Settings/MasterRegistry.json','defaults with empty MasterUrl'],
          'master_environment_names':master_env},
        'master':{'source_origin':'local community HTTP registry, not Riot platform','default_bind':'0.0.0.0:'+str(master_port),
          'environment_names':['LOLSBX_PORT','LOLSBX_DB'],'default_db_literal':'master.db','runtime_started':False}}

def verify(doc,project_root,roots=None):
    if doc.get('schema')!='openleague_game_server_reference/v1' or doc.get('task')!='SYS-01.1-03':raise ConfigEvidenceError('Contrat de référence invalide.')
    roots=roots or doc['source_roots'];ref=load_reference(project_root);validate_client(ref,roots['native'],True)
    if digest(pathlib.Path(project_root)/'docs/reference_client_4_20.json')['sha256']!=doc['client_reference_sha256']:raise ConfigEvidenceError('Référence datée modifiée.')
    actual=extract_client(safe_source(roots['native'],ref['client']['binary']))
    if actual!=doc['game_client']['extracted_identity']:raise ConfigEvidenceError('Identité du client de partie divergente.')
    ids=set()
    for s in doc['sources']:
        if s['id'] in ids:raise ConfigEvidenceError('Identifiant de source dupliqué.')
        ids.add(s['id']);p=safe_source(roots[s['root']],s['path'])
        if not p.is_file():raise ConfigEvidenceError('Source absente : '+s['id'])
        if digest(p)!={k:s[k] for k in ['bytes','sha256']}:raise ConfigEvidenceError('Source modifiée : '+s['id'])
    if settings_inventory(roots['community'])!=doc['community_settings']:raise ConfigEvidenceError('Inventaire des configurations disponible divergent.')
    if client_config_inventory(roots['native'])!=doc['native_client_configs']:raise ConfigEvidenceError('Inventaire des configurations client divergent.')
    if shipped_defaults(roots['native'])!=doc['shipped_client_defaults']:raise ConfigEvidenceError('Défauts livrés divergents.')
    if source_contracts(roots)!=doc['consumer_contracts']:raise ConfigEvidenceError('Consommateur réel divergent.')
    for a in doc['availability']:
        p=safe_source(roots[a['root']],a['path'])
        if p.exists()!=a['present']:raise ConfigEvidenceError('Disponibilité changée : '+a['id'])
    if doc['server_origin']['riot_server_configuration_recovered'] is not False:raise ConfigEvidenceError('Origine serveur Riot non établie.')
    if doc['server_origin']['native_client_connects_to_openleague_rust'] is not None:raise ConfigEvidenceError('Compatibilité protocolaire non établie.')
    return {'task':doc['task'],'facts_verified':True,'client_version':actual['version'],'source_files_verified':len(ids),
            'community_configs':len(doc['community_settings']),'native_client_configs':len(doc['native_client_configs']),
            'consumer_contracts':doc['consumer_contracts'],'native_or_server_executed':False,'human_acceptance':'not_given','manual_state_mutated':False}

def main():
    p=argparse.ArgumentParser();p.add_argument('--root',default='E:/OpenLeague');p.add_argument('--output');args=p.parse_args()
    try:r=verify(json.loads((pathlib.Path(args.root)/CONTRACT).read_bytes()),args.root)
    except (ConfigEvidenceError,OSError,ValueError,KeyError,TypeError) as e:
        print(json.dumps({'facts_verified':False,'error':str(e)},ensure_ascii=False));return 1
    text=json.dumps(r,ensure_ascii=False,indent=2)
    if args.output:pathlib.Path(args.output).write_text(text,encoding='utf-8')
    print(text);return 0
if __name__=='__main__':raise SystemExit(main())
