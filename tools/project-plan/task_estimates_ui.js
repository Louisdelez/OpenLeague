/* Research-backed model roles; durations are explicit IA-agent planning scenarios. */
globalThis.OpenLeagueEstimates=(()=>{
 'use strict';
 const data=JSON.parse(document.getElementById('task-estimate-data').textContent);
 const esc=x=>String(x??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
 function signature(t){let h=2166136261;const s=[t.id,t.title,t.kind,t.source_status??t.status??''].join('\x1f');for(let i=0;i<s.length;i++)h=Math.imul(h^s.charCodeAt(i),16777619)>>>0;return h;}
 function forTask(t){
  const r=Object.hasOwn(data.tasks,t.id)?data.tasks[t.id]:null;if(!r||r[0]!==signature(t))return null;
  const [lo,hi,difficulty,model,confidence,mask,scope,cyclesLo,cyclesHi,tools]=data.profiles[r[1]];
  const [modelId,modelFull,modelShort,effortId,effort,modelReason]=data.models[model];
  const time=lo>=60&&lo%60===0&&hi%60===0?`${lo/60}–${hi/60} h`:`${lo}–${hi} min`;
  // Visual mapping of the four existing AI difficulty classes. This does not
  // claim a new benchmark or change the underlying task assessment.
  const difficultyStars=[1,2.5,3.5,5][difficulty];
  return {time,minutesLow:lo,minutesHigh:hi,difficulty:data.difficulties[difficulty],difficultyLevel:difficulty,difficultyStars,
   modelId,modelFull,modelShort,effortId,effort,modelReason,confidence,scope,cyclesLo,cyclesHi,
   toolset:data.toolsets[tools],date:data.date,openQuestions:r[2],dependencies:r[3],
   reasons:data.reasons.filter((_,i)=>mask&(1<<i))};
 }
 function timeCaption(a){return a.scope==='first_pass'?'Premier lot de recherche IA. Durée totale encore ouverte.':a.scope==='review'?'Préparation de la revue par l’IA, hors validation humaine.':'Agent IA et outils, avec les prérequis disponibles.';}
 function starsHTML(a){
  const star='<svg viewBox="0 0 24 24" aria-hidden="true"><path d="m12 3 2.8 5.7 6.3.9-4.6 4.5 1.1 6.3-5.6-3-5.6 3 1.1-6.3L2.9 9.6l6.3-.9Z"/></svg>';
  return `<span class="task-flag flag-difficulty-${a.difficultyLevel}" role="img" aria-label="Difficulté : ${String(a.difficultyStars).replace('.',',')} sur 5"><span class="difficulty-stars" aria-hidden="true"><span class="stars-outline">${star.repeat(5)}</span><span class="stars-fill stars-fill-${a.difficultyStars*2}">${star.repeat(5)}</span></span></span>`;
 }
 function flagsHTML(a){return a?`<span class="task-flag flag-time">~ ${esc(a.time)}</span>${starsHTML(a)}<span class="task-flag flag-model${a.modelId==='gpt-6-astra'?' astra':''}">${esc(a.modelShort)} · ${esc(a.effort)}</span>`:'<span class="task-flag flag-unavailable">À estimer</span><span class="task-flag flag-unavailable">À qualifier</span><span class="task-flag flag-unavailable">À recommander</span>';}
 function cardHTML(a){
  if(!a)return '<p class="hover-empty">Cette tâche a changé depuis l’analyse. Son estimation doit être actualisée.</p>';
  return `<div class="estimate-card-row"><span class="estimate-dot time-dot" aria-hidden="true"></span><div><div class="estimate-row-heading"><span>Temps agent IA</span><span class="task-flag flag-time">~ ${esc(a.time)}</span></div><p>${esc(timeCaption(a))}</p></div></div>
   <div class="estimate-card-row"><span class="estimate-dot difficulty-dot-${a.difficultyLevel}" aria-hidden="true"></span><div><div class="estimate-row-heading"><span>Difficulté pour l’IA</span>${starsHTML(a)}</div><p>${esc(a.reasons.find(r=>!r.startsWith('Des questions'))||a.reasons[0]||'Vérification nécessaire.')}</p></div></div>
   <div class="estimate-card-row"><span class="estimate-dot model-dot" aria-hidden="true"></span><div><div class="estimate-row-heading"><span>Modèle recommandé</span><span class="task-flag flag-model${a.modelId==='gpt-6-astra'?' astra':''}">${esc(a.modelFull)} · ${esc(a.effort)}</span></div><p>${esc(a.modelReason)}</p></div></div>
   <div class="estimate-card-foot"><span>Fourchette indicative${a.confidence==='faible'?' · incertitude élevée':''}</span>${a.openQuestions?`<span>${a.openQuestions} question${a.openQuestions>1?'s':''} ouverte${a.openQuestions>1?'s':''}</span>`:''}</div>`;
 }
 function attachHover(getTask){
  const tip=document.getElementById('estimate-hover');let anchor=null,openTimer=null,closeTimer=null,suppressed=null;
  function visible(){return tip.hasAttribute('data-visible');}
  function hide(){clearTimeout(openTimer);clearTimeout(closeTimer);if(anchor)anchor.removeAttribute('aria-describedby');if(typeof tip.hidePopover==='function'&&tip.matches(':popover-open'))tip.hidePopover();tip.removeAttribute('data-visible');tip.hidden=true;anchor=null;}
  function place(){
   if(!anchor||!visible())return;const b=anchor.getBoundingClientRect(),p=tip.getBoundingClientRect();const gap=9,edge=12;
   const x=Math.min(Math.max(edge,b.right-p.width),Math.max(edge,innerWidth-p.width-edge));
   let y=b.bottom+gap;if(y+p.height>innerHeight-edge)y=b.top-p.height-gap;
   y=Math.min(Math.max(edge,y),Math.max(edge,innerHeight-p.height-edge));
   tip.style.left=Math.round(x)+'px';tip.style.top=Math.round(y)+'px';
  }
  function show(button){
   if(!button.isConnected||suppressed===button)return;const t=getTask(button.dataset.estimate);if(!t)return;
   hide();anchor=button;tip.innerHTML='<div class="estimate-hover-heading">Estimation IA</div>'+cardHTML(forTask(t));
   tip.hidden=false;tip.setAttribute('data-visible','');
   if(typeof tip.showPopover==='function')tip.showPopover();else (document.querySelector('dialog[open]')||document.body).appendChild(tip);
   button.setAttribute('aria-describedby',tip.id);place();
  }
  function schedule(button,keyboard=false){clearTimeout(closeTimer);clearTimeout(openTimer);if(anchor===button&&visible())return;openTimer=setTimeout(()=>show(button),keyboard?0:230);}
  function deferHide(){clearTimeout(openTimer);clearTimeout(closeTimer);closeTimer=setTimeout(()=>{if(!tip.matches(':hover')&&!anchor?.matches(':hover')&&!anchor?.matches(':focus-visible'))hide();},180);}
  document.addEventListener('pointerover',e=>{const b=e.target.closest('.task-flags');if(!b||b.contains(e.relatedTarget))return;suppressed=null;schedule(b);});
  document.addEventListener('pointerout',e=>{const b=e.target.closest('.task-flags');if(b&&!b.contains(e.relatedTarget)){suppressed=null;deferHide();}});
  document.addEventListener('focusin',e=>{const b=e.target.closest('.task-flags');if(b?.matches(':focus-visible')){suppressed=null;schedule(b,true);}});
  document.addEventListener('focusout',e=>{if(e.target.closest('.task-flags'))deferHide();});
  tip.addEventListener('pointerenter',()=>{clearTimeout(closeTimer);clearTimeout(openTimer);});
  tip.addEventListener('pointerleave',deferHide);
  document.addEventListener('keydown',e=>{if(e.key==='Escape'&&visible()){suppressed=anchor;hide();e.preventDefault();e.stopPropagation();}},true);
  // Layout changes must not cancel a pending first hover while the browser is
  // scrolling its trigger into view. Scrolling inside the card stays possible.
  window.addEventListener('resize',()=>{if(visible())hide();});
  document.addEventListener('scroll',e=>{if(visible()&&!tip.contains(e.target))hide();},true);
  document.addEventListener('pointerdown',e=>{if(visible()&&!tip.contains(e.target)&&!e.target.closest('.task-flags'))hide();},true);
  return Object.freeze({hide});
 }
 return Object.freeze({forTask,signature,flagsHTML,cardHTML,timeCaption,attachHover,date:data.date,count:Object.keys(data.tasks).length});
})();
