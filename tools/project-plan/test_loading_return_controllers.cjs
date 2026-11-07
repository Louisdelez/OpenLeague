'use strict';
// Execute only the reviewed, type-erased method bodies. All host APIs are adapters.
const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const root = process.env.OPENLEAGUE_LIFECYCLE_SNAPSHOT || 'E:/OpenLeague';
const data = JSON.parse(fs.readFileSync(path.join(root, 'docs/reference_loading_return_sources/vm-methods.json'), 'utf8'));
const methods = Object.fromEntries(data.methods.map(m => [m.id,m]));
const constants = Object.fromEntries(data.constant_sets.map(g => [g.source.slice(4),Object.fromEntries(g.entries.map(e=>[e.name,e.value]))]));
const exercised = new Set();
function invoke(id, receiver, args=[], globals={}) {
  const row = methods[id]; assert.ok(row,id); exercised.add(id);
  const context = vm.createContext({...constants,...globals, receiver, args}, {codeGeneration:{strings:false,wasm:false}});
  new vm.Script('result = ('+row.javascript+').apply(receiver,args)').runInContext(context,{timeout:1000});
  return context.result;
}
const G=constants.GameViewState, I=constants.InGameController, E=constants.EndOfGameStatsController;
function preload(overrides={}) {
  const calls=[];
  const obj={_shouldPreload:true,_maestroStarted:true,_readyToPlay:false,_receivedMinimizeEvent:false,_currentlyPreloading:true,
    _maestro:{playPreloadedGame(){calls.push('play');},killGameClientProcess(){calls.push('kill-adapter');}},
    removeCrashHandlers(){calls.push('remove');},...overrides};
  obj.getPreloadingReady=()=>invoke('preload_ready',obj);
  obj.playPreloadedGame=()=>invoke('preload_play',obj);
  return {obj,calls};
}
test('preload availability requires every original predicate',()=>{
  assert.equal(invoke('preload_ready',preload().obj),true);
  for(const overrides of [{_shouldPreload:false},{_maestro:null},{_maestroStarted:false}])
    assert.equal(Boolean(invoke('preload_ready',preload(overrides).obj)),false);
});
test('ready-before-minimize and minimize-before-ready issue one adapted play',()=>{
  for(const order of [['preload_complete','preload_minimize'],['preload_minimize','preload_complete']]){
    const {obj,calls}=preload(); invoke(order[0],obj,[{}]); assert.equal(calls.length,0);
    invoke(order[1],obj,[{}]); assert.deepEqual(calls,['play','remove']);
    assert.equal(obj._readyToPlay,false); assert.equal(obj._currentlyPreloading,false);
  }
  const {obj,calls}=preload({_shouldPreload:false});
  invoke('preload_complete',obj); invoke('preload_minimize',obj,[{}]); assert.deepEqual(calls,[]);
});
test('crash disables preload; halt has the active/ready guard and only calls an adapter',()=>{
  let {obj,calls}=preload();invoke('preload_crash',obj,[{}]);
  assert.equal(obj._shouldPreload,false);assert.equal(obj._currentlyPreloading,false);
  invoke('preload_halt',obj);assert.deepEqual(calls,['remove']);
  ({obj,calls}=preload());invoke('preload_halt',obj);assert.deepEqual(calls,['remove','kill-adapter']);
  ({obj,calls}=preload({_currentlyPreloading:false}));invoke('preload_halt',obj);assert.deepEqual(calls,[]);
});
test('all three champion-selection DTOs map to CHAMP_SELECT, not START_REQUESTED',()=>{
  const GameState={...constants.GameState};
  GameState.isInChampionSelectionState=value=>invoke('dto_champion_selection',{},[value]);
  const globals={GameState,isInChampionSelectionState:GameState.isInChampionSelectionState};
  for(const name of ['PRE_CHAMPION_SELECTION','CHAMPION_SELECTION','POST_CHAMPION_SELECTION'])
    assert.equal(invoke('dto_map',{},[GameState[name]],globals),G.CHAMPION_SELECTION);
  for(const value of [GameState.START_REQUESTED,GameState.TERMINATED,'UNKNOWN'])
    assert.equal(invoke('dto_map',{},[value],globals),value);
});
test('successful game completion changes only the two permitted AIR states',()=>{
  for(const currentState of Object.values(G)){
    const receiver={currentState};invoke('game_completed',receiver);
    assert.equal(receiver.currentState,[G.PLAYING_GAME,G.IN_PROGRESS].includes(currentState)?G.GAME_OVER:currentState);
  }
});
function airEnvironment(replay=false){
  const calls=[];const AppConfig={instance:{minimized:true,currentAppState:'unchanged'}};
  const receiver={masterGameController:{currentState:G.PLAYING_GAME,gameCompleted(){calls.push('complete');}},viewMediator:{maximizeClient(){calls.push('maximize');}}};
  return {receiver,calls,AppConfig,globals:{AppConfig,WatchTabProviderProxy:{instance:{isEnabled:()=>true,isReplayMode:()=>replay}}}};
}
test('AIR normal completion restores window; replay leaves lifecycle and window untouched',()=>{
  for(const replay of [false,true]){
    const env=airEnvironment(replay);invoke('air_game_completed',env.receiver,[{type:'completed'}],env.globals);
    assert.deepEqual(env.calls,replay?[]:['complete','maximize']);assert.equal(env.AppConfig.instance.minimized,replay);
  }
});
test('AIR crash returns to lobby only outside a live match; replay is excluded',()=>{
  for(const state of [G.NO_GAME,G.GAME_OVER,G.PLAYING_GAME,G.IN_PROGRESS]){
    const env=airEnvironment();env.receiver.masterGameController.currentState=state;
    invoke('air_crash',env.receiver,[{type:'crashed'}],env.globals);
    assert.equal(env.AppConfig.instance.currentAppState,[G.NO_GAME,G.GAME_OVER].includes(state)?constants.IAppControllerConstants.LOBBY:constants.IAppControllerConstants.RECONNECT);
  }
  const env=airEnvironment(true);invoke('air_crash',env.receiver,[{type:'crashed'}],env.globals);
  assert.deepEqual(env.calls,[]);assert.equal(env.AppConfig.instance.currentAppState,'unchanged');
});
test('early termination separates tutorial, spectator, crash and abandonment',()=>{
  for(const [tutorial,spectating,type,expected] of [
    [true,false,'other','cancel'],[false,true,'other',I.PLAYING_SPECTATOR_DISCONNECT],
    [false,false,constants.GameCrashedEvent.CRASHED_EVENT_FROM_GAME,I.PLAYING_CRASHED],
    [false,false,'abandoned',I.PLAYING_DISCONNECTED]]){
    const r={masterGameController:{isLastPlayedGameTypeTutorial:tutorial,isSpectating:spectating},currentState:'old',cancelGameFlow(){this.currentState='cancel';}};
    invoke('ingame_early',r,[{type}],I);assert.equal(r.currentState,expected);
  }
});
test('original deactivate comparison does not assign connected, and removes listeners',()=>{
  const removed=[];const r={currentState:I.PLAYING_CRASHED,isBusy:true,proxiedOnError:()=>{},shellDispatcher:{removeEventListener(...a){removed.push(a);}}};
  invoke('ingame_deactivate',r);assert.equal(r.currentState,I.PLAYING_CRASHED);assert.equal(r.isBusy,false);assert.equal(r.proxiedOnError,null);assert.equal(removed.length,3);
});
function results(overrides={}){
  const calls=[];const r={endOfGameStats:null,currrentGameId:7,gameType:constants.GameType.NORMAL_GAME,
    createTutorialGameController:{isBasicTutorial:false},clientConfig:{advancedTutorialEnabled:false},
    showStatsIfApplicable(){calls.push('show');},resetReports(){calls.push('reset');},
    lcdsHeartBeatController:{validatePlatformConnection(){calls.push('validate');}},
    _currentStateUpdated:{dispatch(){calls.push('state');}},gameFlowComplete:{dispatch(){calls.push('complete');}},
    _tutorialGameComplete:{dispatch(v){calls.push(['tutorial',v]);}},initializeEoGTutorial(){calls.push('init-tutorial');},
    ...overrides};r.setCurrentEndOfGameState=s=>invoke('results_state',r,[s]);return {r,calls};
}
test('results use only same-game cache, otherwise wait for platform validation',()=>{
  for(const stats of [null,{gameId:6},{gameId:7}]){
    const {r,calls}=results({endOfGameStats:stats});invoke('results_activate',r);
    assert.equal(r.isActive,true);
    assert.deepEqual(calls,stats?.gameId===7?['show','reset']:['state','validate','reset']);
    if(stats?.gameId!==7)assert.equal(r.currentEndOfGameState,E.WAITING_FOR_STATS);
  }
});
test('normal and every tutorial results branch retain their original states',()=>{
  const normal=results();invoke('results_choose',normal.r,[],E);assert.equal(normal.r.currentEndOfGameState,E.SHOW_STATS);
  for(const basic of [false,true])for(const advanced of [false,true]){
    const {r,calls}=results({gameType:constants.GameType.TUTORIAL_GAME,createTutorialGameController:{isBasicTutorial:basic},clientConfig:{advancedTutorialEnabled:advanced}});
    invoke('results_choose',r,[],E);
    if(basic&&!advanced){assert.ok(calls.includes('complete'));assert.equal(r.currentEndOfGameState,undefined);}
    else assert.equal(r.currentEndOfGameState,basic?E.TUTORIAL_GAME_WRAPUP:E.SHOW_STATS);
    assert.ok(calls.some(c=>Array.isArray(c)&&c[0]==='tutorial'&&c[1]===basic));
  }
});
test('return cleans gifts and tutorial queue; normal flow completes once',()=>{
  for(const tutorial of [false,true])for(const advanced of [false,true]){
    const {r,calls}=results({currentEndOfGameState:E.SHOW_STATS,gameType:tutorial?constants.GameType.TUTORIAL_GAME:constants.GameType.NORMAL_GAME,
      clientConfig:{advancedTutorialEnabled:advanced},_endOfGameGiftEnabled:true,_endOfGameGiftController:{cleanSessionData(){calls.push('gift');}},tutorialEventQueue:{clear(){calls.push('clear');}}});
    invoke('results_return',r,[],E);assert.equal(calls[0],'gift');
    if(tutorial)assert.ok(calls.includes('clear'));
    if(tutorial&&advanced)assert.equal(r.currentEndOfGameState,E.TUTORIAL_GAME_WRAPUP);
    else assert.equal(calls.filter(x=>x==='complete').length,1);
  }
});
class Message {setType(v){this.type=v;}getType(){return this.type;}setPayloadSize(v){this.size=v;}getPayloadSize(){return this.size;}getPayloadString(){return '';}}
Object.assign(Message,constants.MaestroMessage);
function maestroGlobals(events){
  function Event(type){this.type=type;}
  function GameCrashedEvent(payload){this.type=constants.GameCrashedEvent.CRASHED_EVENT_FROM_GAME;this.payload=payload;}
  return {...constants.MaestroServiceImpl,MaestroMessage:Message,Event,GameCrashedEvent,dispatchEvent:event=>events.push(event),ServiceLogger:{responseMaestro(){}}};
}
test('Maestro messages 1,2,7,8,9,10,33 differ and initial preload30 is no-op',()=>{
  const expected=new Map([[1,constants.MaestroConstants.GAMECLIENTSTOPPED_EVENT],[2,constants.GameCrashedEvent.CRASHED_EVENT_FROM_GAME],
    [7,constants.MaestroConstants.GAME_CLIENT_ABANDONED],[8,constants.MaestroConstants.GAME_CLIENT_LAUNCHED],
    [9,constants.MaestroConstants.GAME_CLIENT_VERSION_MISMATCH],[10,constants.MaestroConstants.GAME_CLIENT_CONNECTED_TO_SERVER],
    [33,constants.MaestroConstants.GAME_LOADING_COMPLETE]]);
  for(const [type,event] of expected){const events=[];const m=new Message();m.setType(type);invoke('maestro_dispatch',{},[m],maestroGlobals(events));assert.equal(events.length,1);assert.equal(events[0].type,event);}
  const events=[];const m=new Message();m.setType(30);invoke('maestro_dispatch',{},[m],maestroGlobals(events));assert.deepEqual(events,[]);
  m.setType(40);assert.throws(()=>invoke('maestro_dispatch',{},[m],maestroGlobals(events)),/Invalid message/);
});
function header(values,available=16){
  const events=[];const globals=maestroGlobals(events);let index=0;
  const r={socket:{bytesAvailable:available,readInt(){return values[index++];}},fireMaestroMessage(m){invoke('maestro_dispatch',r,[m],globals);}};
  return {r,events,globals,read:()=>index};
}
test('Maestro header waits for16 bytes, validates size/version and preserves payload branch',()=>{
  let h=header([16,1,33,0],15);assert.equal(invoke('maestro_header',h.r,[],h.globals),false);assert.equal(h.read(),0);
  h=header([16,1,33,0]);assert.equal(invoke('maestro_header',h.r,[],h.globals),true);assert.equal(h.events.length,1);
  h=header([16,1,2,10]);invoke('maestro_header',h.r,[],h.globals);assert.equal(h.r.currentMessage.size,10);assert.deepEqual(h.events,[]);
  for(const [values,error] of [[[20,1,33,0],/Unexpected message size/],[[16,2,33,0],/Unexpected message version/],[[16,1,41,0],/Invalid message/]]){
    h=header(values);assert.throws(()=>invoke('maestro_header',h.r,[],h.globals),error);assert.deepEqual(h.events,[]);
  }
  h=header([16,1,-1,-1]);invoke('maestro_header',h.r,[],h.globals);assert.equal(h.r.currentMessage.type,-1);assert.equal(h.r.currentMessage.size,-1);
});
function gfxEnvironment(){
  const calls=[];let isGfx=true;
  const globals={fscommand:(...a)=>calls.push(['fscommand',...a]),trace:(...a)=>calls.push(['trace',...a]),DDW:{Managers:{GameManager:{getInstance:()=>({isGfx})}},Communication:{Comm:{}}}};
  globals.DDW.Communication.Comm.send=(...a)=>invoke('gfx_send',{},a,globals);
  return {calls,globals,setMode:v=>{isGfx=v;}};
}
test('GFx send preserves Press_Continue and rejects empty rollover/release messages',()=>{
  const env=gfxEnvironment();invoke('gfx_send',{},['Press_Continue'],env.globals);assert.deepEqual(env.calls,[['fscommand','Press_Continue','']]);
  for(const value of [null,'Release_','RollOver_','RollOut_'])invoke('gfx_send',{},[value],env.globals);
  assert.equal(env.calls.length,1);invoke('gfx_send',{},['Press_Continue#payload'],env.globals);assert.deepEqual(env.calls[1],['fscommand','Press_Continue','payload']);
  env.setMode(false);invoke('gfx_send',{},['Press_Continue'],env.globals);assert.equal(env.calls.at(-1)[0],'trace');
});
test('Continue release requires active cursor, parent, enabled communication and no drag',()=>{
  for(const overrides of [{},{commEnabled:false},{_wasDragging:true},{parent:null},{isCursorActive:()=>false}]){
    const env=gfxEnvironment();const r={pressPrefix:'Press_',pressMsg:'Continue',commEnabled:true,_wasDragging:false,parent:{},isCursorActive:()=>true,totalFrames:2,isTransformHover:false,isDown:true,gotoAndStop(){},...overrides};
    r.sendClickMessage=()=>invoke('gfx_click',r,[],env.globals);invoke('gfx_release',r,[],env.globals);
    assert.equal(env.calls.length,Object.keys(overrides).length?0:1);
  }
});
test.after(()=>assert.deepEqual([...exercised].sort(),Object.keys(methods).sort(),'Every reviewed method must be exercised; no native host was available.'));
