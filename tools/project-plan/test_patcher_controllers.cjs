const test=require('node:test');const assert=require('node:assert/strict');const fs=require('node:fs');const vm=require('node:vm');
const root='E:/OpenLeague/docs/reference_patcher_sources/review/bundle-chrome/src/js/app/';
function controller(file,scope){
 const calls=[],events=[],listeners={};let Controller;
 const bridge={hostCommand:(...args)=>calls.push(args)};
 const jquery=()=>({on(){}});jquery.event={trigger:event=>events.push(event)};
 const sandbox={define:(a,b)=>{Controller=(b||a)();},riot:{client:bridge},window:{riot:{client:bridge}},
  $:jquery,console:{log(){}},addEventListener:(name,cb)=>listeners[name]=cb,setTimeout(){},setInterval(){},
  document:{getElementById:()=>({play(){},volume:0,currentTime:0})}};
 vm.runInNewContext(fs.readFileSync(root+file,'utf8'),sandbox,{timeout:1000,filename:file});
 let closed=0;new Controller(scope,{deactivate:()=>closed++});
 return {calls,events,listeners,closed:()=>closed};
}
test('Agreement acceptance and rejection dispatch distinct responses, without native host',()=>{
 const scope={};const x=controller('displayAgreement/DisplayAgreementController.js',scope);
 scope.acceptClick();scope.rejectClick();assert.deepEqual(x.calls,[['SendAgreementResponse','1'],['SendAgreementResponse','0']]);
 assert.deepEqual(x.events.map(e=>e.message),['true','false']);scope.close();assert.equal(x.closed(),1);
});
test('Region save dispatches selected pair; cancel makes no native command',()=>{
 const scope={region:{current:'euw',regions:[{euw:['en_gb']}]},locale:{current:'en_gb',locales:['en_gb'],names:['English']},tra:{},$watch(){}};
 const x=controller('regionalSettings/RegionalSettingsController.js',scope);scope.close();assert.equal(x.calls.length,0);
 scope.save();assert.deepEqual(x.calls,[['SetRegionAndLocale','euw,en_gb']]);
});
test('Settings repair, logs and copyright use distinct commands',()=>{
 const scope={tra:{},sfxVolume:0.5,sfxMuted:false,currentP2P:'1'};const x=controller('settings/SettingsController.js',scope);
 scope.repair();scope.saveLogs();scope.displayCopyright();assert.deepEqual(x.calls,[['StartValidate'],['SaveLogs'],['ShowCopyright']]);
 assert.equal(scope.saveLogsDisabled,true);x.listeners.SaveLogs({detail:{savelogs:{enabled:true,status:'saved'}}});assert.equal(scope.saveLogsDisabled,false);
 x.listeners.SaveLogs({detail:{savelogs:{enabled:false,status:'saving'}}});assert.equal(scope.saveLogsDisabled,true);
});
test('P2P and sound settings preserve their actual parameters',()=>{
 const scope={tra:{},sfxVolume:0.5,sfxMuted:false,currentP2P:'1'};const x=controller('settings/SettingsController.js',scope);
 scope.chkP2P='0';scope.p2pChange();scope.sfxRange=37;scope.sfxChange();scope.sfxToggleMute();scope.sfxToggleMute();
 assert.deepEqual(x.calls,[['SetP2PEnabled','0'],['SfxVolume',37],['SfxMute','1'],['SfxMute','0']]);
});
test('Pando yes, no and never are distinct; no actual uninstall is executed',()=>{
 const scope={tra:{},pando_uninstall:'yes',locale:'en_gb',region:'euw',$watch(){}};const x=controller('pandoRemovalPopup/PandoRemovalPopupController.js',scope);
 scope.yesClick();scope.noClick();scope.neverClick();assert.deepEqual(x.calls,[['PandoRemove','yes'],['PandoRemove','no'],['PandoRemove','never']]);
});
test('Error log submission is separate from closing the modal',()=>{
 const scope={error:{title:'error',message:'test'}};const x=controller('errorMessage/ErrorMessageController.js',scope);
 scope.close();assert.equal(x.calls.length,0);scope.savelogsClick();assert.deepEqual(x.calls,[['SendLogs']]);
});
test('Actual play-button binding rejects pending or blocked states',()=>{
 const html=fs.readFileSync('E:/OpenLeague/docs/reference_patcher_sources/review/bundle-chrome/src/index.html','utf8');
 const expression=html.match(/id="play"[^>]+ng-disabled="([^"]+)"/)[1];
 for(const [bDisabled,bServerStatus,bUrf,expected] of [[false,false,true,false],[true,false,true,true],[false,true,true,true],[true,true,false,false]]){
  assert.equal(vm.runInNewContext(expression,{bDisabled,bServerStatus,bUrf},{timeout:1000}),expected);
 }
});
