const status=document.getElementById('status'),select=document.getElementById('champion'),button=document.getElementById('play');
const resumeButton=document.getElementById('resume'),abandonButton=document.getElementById('abandon');
const joinButton=document.getElementById('join');
let rosterReady=false,launchPending=false,statusPending=false,statusSerial=0,launchError='';
function disableActions(){button.disabled=true;if(joinButton)joinButton.disabled=true;resumeButton.disabled=true;abandonButton.disabled=true;}
disableActions();
async function refreshSession(){
  if(statusPending||launchPending)return;
  statusPending=true;
  const serial=++statusSerial;
  try{
    const session=await window.__TAURI__.core.invoke('session_status');
    if(serial!==statusSerial)return;
    button.disabled=!rosterReady||launchPending||session.can_play!==true;
    if(joinButton)joinButton.disabled=!rosterReady||launchPending||session.can_join!==true;
    resumeButton.disabled=launchPending||session.can_resume!==true;
    abandonButton.disabled=launchPending||session.can_abandon!==true;
    status.textContent=launchError?launchError+' — '+session.message:session.message;
  }catch(error){
    if(serial!==statusSerial)return;
    disableActions();
    status.textContent=(launchError?launchError+' — ':'')+'Suivi de la session indisponible : '+String(error);
  }finally{statusPending=false;}
}
async function boot(){
  try{
    const rows=await window.__TAURI__.core.invoke('roster');
    for(const row of rows){const option=document.createElement('option');option.value=row.id;option.textContent=row.name;select.append(option);}
    select.value='garen';rosterReady=true;
    await refreshSession();
  }catch(error){status.textContent=String(error);disableActions();}
}
async function action(command,payload){
  if(launchPending)return;
  launchPending=true;++statusSerial;disableActions();launchError='';
  status.textContent='Demande en cours…';
  try{status.textContent=await window.__TAURI__.core.invoke(command,payload);}
  catch(error){launchError=String(error);status.textContent=launchError;}
  finally{launchPending=false;await refreshSession();}
}
button.addEventListener('click',async()=>{
  if(button.disabled)return;
  await action('play',{champion:select.value,summoners:[document.getElementById('summoner-d').value||null,document.getElementById('summoner-f').value||null]});
});
if(joinButton)joinButton.addEventListener('click',async()=>{
  if(joinButton.disabled)return;
  await action('join_local',{champion:select.value,summoners:[document.getElementById('summoner-d').value||null,document.getElementById('summoner-f').value||null]});
});
resumeButton.addEventListener('click',async()=>{if(!resumeButton.disabled)await action('resume_session');});
abandonButton.addEventListener('click',async()=>{if(!abandonButton.disabled)await action('abandon_session');});
setInterval(()=>{if(rosterReady)void refreshSession();},500);
void boot();
