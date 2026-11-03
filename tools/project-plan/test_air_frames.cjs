// Original local AIR HTML scripts, with an explicit simulated host and no network.
const fs=require('node:fs');const vm=require('node:vm');
const test=require('node:test');const assert=require('node:assert/strict');
const root='E:/OpenLeague/docs/reference_air_sources/original/assets/htmlTemplates/';
function script(name){return [...fs.readFileSync(root+name,'utf8').matchAll(/<script\b[^>]*>([\s\S]*?)<\/script>/gi)].map(m=>m[1]).join('\n');}
function host(){
 const nodes=new Map(),timers=[],events=[],calls={show:0,hide:0};
 const body={appendChild(node){node.parentNode=this;nodes.set(node.attributes.id,node);},removeChild(node){nodes.delete(node.attributes.id);}};
 const document={getElementsByTagName(name){assert.equal(name,'body');return [body];},
  getElementById(id){return nodes.get(id);},createElement(tag){assert.equal(tag,'iframe');return {attributes:{},style:{},contentWindow:{childSandboxBridge:{dispatchEvent(t){events.push(t);}}},setAttribute(k,v){this.attributes[k]=v;}};}};
 const context=vm.createContext({document,setTimeout(fn,ms){timers.push({fn,ms});return timers.length;},clearTimeout(){}});
 vm.runInContext(script('frontpageFrame.html'),context,{timeout:1000});
 context.parentInterface.showFrontpage=()=>calls.show++;
 context.parentInterface.hideFrontpage=()=>calls.hide++;
 return {context,nodes,timers,events,calls};
}
test('original frontpage creates the bridged frame for the configured URL',()=>{
 const h=host();h.context.initializeFrontpage('https://example.invalid','https://example.invalid/news');
 const frame=h.nodes.get('sandbox');assert.equal(frame.attributes.src,'https://example.invalid/news');
 assert.equal(frame.attributes.sandboxRoot,'https://example.invalid/client-assets');
 assert.equal(frame.contentWindow.parentSandboxBridge,h.context.parentInterface);assert.equal(h.timers[0].ms,5000);
});
test('original timeout navigates to the local fallback when remote content never loads',()=>{
 const h=host();h.context.initializeFrontpage('https://example.invalid','https://example.invalid/news');h.timers[0].fn();
 assert.equal(h.nodes.get('sandbox').attributes.src,'app:/assets/htmlTemplates/frontpageFallbackFrame.html');
});
test('original loaded callback displays content and prevents a timeout fallback',()=>{
 const h=host();h.context.initializeFrontpage('https://example.invalid','https://example.invalid/news');h.context.parentInterface.loaded();h.timers[0].fn();
 assert.equal(h.nodes.get('sandbox').style.display,'block');assert.equal(h.calls.show,1);
 assert.equal(h.nodes.get('sandbox').attributes.src,'https://example.invalid/news');
});
test('original event bridge refuses non-string event types',()=>{
 const h=host();h.context.initializeFrontpage('https://example.invalid','https://example.invalid/news');h.context.parentInterface.loaded();
 h.context.dispatchFrontpageEvent({type:'invalid'});assert.deepEqual(h.events,[]);
 h.context.dispatchFrontpageEvent('refresh');assert.deepEqual(h.events,['refresh']);
});
test('original reload recreates the frame and preserves the configured destination',()=>{
 const h=host();h.context.initializeFrontpage('https://example.invalid','https://example.invalid/news');const before=h.nodes.get('sandbox');
 h.context.parentInterface.loaded();h.context.parentInterface.reload();assert.notEqual(h.nodes.get('sandbox'),before);
 assert.equal(h.calls.hide,1);assert.equal(h.nodes.get('sandbox').attributes.src,'https://example.invalid/news');
});
test('original store-unavailable template obtains its text from the AIR bridge',()=>{
 const element={innerHTML:''};const context=vm.createContext({window:{parentSandboxBridge:{storeUnavailableMessage:'Boutique indisponible'}},
  document:{getElementById(id){assert.equal(id,'storeUnavailableText');return element;}}});
 vm.runInContext(script('store/storeClosedTemplate.html'),context,{timeout:1000});context.window.onload();
 assert.equal(element.innerHTML,'Boutique indisponible');
});
