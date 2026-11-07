package com.greensock.loading.core
{
   import com.greensock.events.LoaderEvent;
   import com.greensock.loading.LoaderMax;
   import com.greensock.loading.LoaderStatus;
   import com.greensock.loading.display.ContentDisplay;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import flash.net.LocalConnection;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.Capabilities;
   import flash.system.LoaderContext;
   import flash.system.Security;
   import flash.system.SecurityDomain;
   
   public class DisplayObjectLoader extends LoaderItem
   {
      
      protected static var _gcDispatcher:Sprite;
      
      public static var defaultAutoForceGC:Boolean = true;
      
      protected static var _gcCycles:uint = 0;
      
      protected var _initted:Boolean;
      
      protected var _stealthMode:Boolean;
      
      protected var _fallbackAudit:Loader;
      
      protected var _sprite:Sprite;
      
      protected var _context:LoaderContext;
      
      protected var _loader:Loader;
      
      public function DisplayObjectLoader(urlOrRequest:*, vars:Object = null)
      {
         super(urlOrRequest,vars);
         _refreshLoader(false);
         if(LoaderMax.contentDisplayClass is Class)
         {
            _sprite = new LoaderMax.contentDisplayClass(this);
            if(!_sprite.hasOwnProperty("rawContent"))
            {
               throw new Error("LoaderMax.contentDisplayClass must be set to a class with a \'rawContent\' property, like com.greensock.loading.display.ContentDisplay");
            }
         }
         else
         {
            _sprite = new ContentDisplay(this);
         }
      }
      
      protected static function _forceGCHandler(event:Event) : void
      {
         if(--_gcCycles <= 0)
         {
            _gcDispatcher.removeEventListener(Event.ENTER_FRAME,_forceGCHandler);
            _gcDispatcher = null;
         }
         try
         {
            new LocalConnection().connect("FORCE_GC");
            new LocalConnection().connect("FORCE_GC");
         }
         catch(error:Error)
         {
         }
      }
      
      public static function forceGC(cycles:uint = 1) : void
      {
         if(_gcCycles < cycles)
         {
            _gcCycles = cycles;
            if(_gcDispatcher == null)
            {
               _gcDispatcher = new Sprite();
               _gcDispatcher.addEventListener(Event.ENTER_FRAME,_forceGCHandler,false,0,true);
            }
         }
      }
      
      protected function _determineScriptAccess() : void
      {
         if(!_scriptAccessDenied)
         {
            if(!_loader.contentLoaderInfo.childAllowsParent)
            {
               _scriptAccessDenied = true;
               dispatchEvent(new LoaderEvent(LoaderEvent.SCRIPT_ACCESS_DENIED,this,"Error #2123: Security sandbox violation: " + this + ". No policy files granted access."));
            }
         }
      }
      
      override protected function _load() : void
      {
         _prepRequest();
         if(this.vars.context is LoaderContext)
         {
            _context = this.vars.context;
         }
         else if(_context == null)
         {
            if(LoaderMax.defaultContext != null)
            {
               _context = LoaderMax.defaultContext;
               if(_isLocal)
               {
                  _context.securityDomain = null;
               }
            }
            else if(!_isLocal)
            {
               _context = new LoaderContext(true,new ApplicationDomain(ApplicationDomain.currentDomain),SecurityDomain.currentDomain);
            }
         }
         if(Capabilities.playerType != "Desktop")
         {
            Security.allowDomain(_url);
         }
         _loader.load(_request,_context);
      }
      
      public function setContentDisplay(contentDisplay:Sprite) : void
      {
         _sprite = contentDisplay;
      }
      
      override protected function _dump(scrubLevel:int = 0, newStatus:int = 0, suppressEvents:Boolean = false) : void
      {
         if(!_stealthMode)
         {
            _refreshLoader(Boolean(scrubLevel != 2));
         }
         if(scrubLevel == 1)
         {
            (_sprite as Object).rawContent = null;
         }
         else if(scrubLevel == 2)
         {
            (_sprite as Object).loader = null;
         }
         else if(scrubLevel == 3)
         {
            (_sprite as Object).dispose(false,false);
         }
         super._dump(scrubLevel,newStatus,suppressEvents);
      }
      
      protected function _refreshLoader(unloadContent:Boolean = true) : void
      {
         if(_loader != null)
         {
            if(_status == LoaderStatus.LOADING)
            {
               try
               {
                  _loader.close();
               }
               catch(error:Error)
               {
               }
            }
            _loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,_progressHandler);
            _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,_completeHandler);
            _loader.contentLoaderInfo.removeEventListener("ioError",_failHandler);
            _loader.contentLoaderInfo.removeEventListener("securityError",_securityErrorHandler);
            _loader.contentLoaderInfo.removeEventListener("httpStatus",_httpStatusHandler);
            _loader.contentLoaderInfo.removeEventListener(Event.INIT,_initHandler);
            if(_loader.hasOwnProperty("uncaughtErrorEvents"))
            {
               Object(_loader).uncaughtErrorEvents.removeEventListener("uncaughtError",_errorHandler);
            }
            if(unloadContent)
            {
               try
               {
                  if(_loader.parent == null && _sprite != null)
                  {
                     _sprite.addChild(_loader);
                  }
                  if(_loader.hasOwnProperty("unloadAndStop"))
                  {
                     (_loader as Object).unloadAndStop();
                  }
                  else
                  {
                     _loader.unload();
                  }
               }
               catch(error:Error)
               {
               }
               if(Boolean(_loader.parent))
               {
                  _loader.parent.removeChild(_loader);
               }
               if("autoForceGC" in this.vars ? Boolean(this.vars.autoForceGC) : defaultAutoForceGC)
               {
                  forceGC(this.hasOwnProperty("getClass") ? 3 : 1);
               }
            }
         }
         _initted = false;
         _loader = new Loader();
         _loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,_progressHandler,false,0,true);
         _loader.contentLoaderInfo.addEventListener(Event.COMPLETE,_completeHandler,false,0,true);
         _loader.contentLoaderInfo.addEventListener("ioError",_failHandler,false,0,true);
         _loader.contentLoaderInfo.addEventListener("securityError",_securityErrorHandler,false,0,true);
         _loader.contentLoaderInfo.addEventListener("httpStatus",_httpStatusHandler,false,0,true);
         _loader.contentLoaderInfo.addEventListener(Event.INIT,_initHandler,false,0,true);
         if(_loader.hasOwnProperty("uncaughtErrorEvents"))
         {
            Object(_loader).uncaughtErrorEvents.addEventListener("uncaughtError",_errorHandler,false,0,true);
         }
      }
      
      override protected function _closeStream() : void
      {
         _closeFallbackAudit();
         super._closeStream();
      }
      
      protected function _initHandler(event:Event) : void
      {
         if(!_initted)
         {
            _initted = true;
            if(_content == null)
            {
               _content = _scriptAccessDenied ? _loader : _loader.content;
            }
            (_sprite as Object).rawContent = _content as DisplayObject;
            dispatchEvent(new LoaderEvent(LoaderEvent.INIT,this));
         }
      }
      
      protected function _securityErrorHandler(event:ErrorEvent) : void
      {
         if(_context != null && _context.checkPolicyFile && !(this.vars.context is LoaderContext))
         {
            _context = new LoaderContext(false);
            _scriptAccessDenied = true;
            dispatchEvent(new LoaderEvent(LoaderEvent.SCRIPT_ACCESS_DENIED,this,event.text));
            _errorHandler(event);
            _load();
         }
         else
         {
            _failHandler(event);
         }
      }
      
      protected function _closeFallbackAudit() : void
      {
         if(_fallbackAudit != null)
         {
            _fallbackAudit.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,_auditStreamHandler,false,0,true);
            _fallbackAudit.contentLoaderInfo.addEventListener(Event.COMPLETE,_auditStreamHandler,false,0,true);
            _fallbackAudit.contentLoaderInfo.addEventListener("ioError",_auditStreamHandler,false,0,true);
            _fallbackAudit.contentLoaderInfo.addEventListener("securityError",_auditStreamHandler,false,0,true);
            try
            {
               _fallbackAudit.close();
            }
            catch(error:Error)
            {
            }
            _fallbackAudit = null;
         }
      }
      
      override protected function _auditStreamHandler(event:Event) : void
      {
         var request:URLRequest = null;
         if(event.type == "securityError")
         {
            if(_fallbackAudit == null)
            {
               _context = new LoaderContext(false);
               _scriptAccessDenied = true;
               dispatchEvent(new LoaderEvent(LoaderEvent.SCRIPT_ACCESS_DENIED,this,ErrorEvent(event).text));
               _errorHandler(event);
               _fallbackAudit = new Loader();
               _fallbackAudit.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,_auditStreamHandler,false,0,true);
               _fallbackAudit.contentLoaderInfo.addEventListener(Event.COMPLETE,_auditStreamHandler,false,0,true);
               _fallbackAudit.contentLoaderInfo.addEventListener("ioError",_auditStreamHandler,false,0,true);
               _fallbackAudit.contentLoaderInfo.addEventListener("securityError",_auditStreamHandler,false,0,true);
               request = new URLRequest();
               request.data = _request.data;
               request.method = _request.method;
               _setRequestURL(request,_url,!_isLocal || _url.substr(0,4) == "http" ? "gsCacheBusterID=" + _cacheID++ + "&purpose=audit" : "");
               if(Capabilities.playerType != "Desktop")
               {
                  Security.allowDomain(_url);
               }
               _fallbackAudit.load(request,_context);
               return;
            }
            _closeFallbackAudit();
         }
         super._auditStreamHandler(event);
      }
      
      public function get rawContent() : *
      {
         return _content;
      }
      
      override public function get content() : *
      {
         return _sprite;
      }
      
      override public function auditSize() : void
      {
         if(Capabilities.playerType != "Desktop")
         {
            Security.allowDomain(_url);
         }
         super.auditSize();
      }
   }
}

