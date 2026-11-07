package com.greensock.loading
{
   import com.greensock.events.LoaderEvent;
   import com.greensock.loading.core.LoaderCore;
   import flash.events.Event;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.system.SecurityDomain;
   import flash.utils.getTimer;
   
   [Event(name="securityError",type="com.greensock.events.LoaderEvent")]
   [Event(name="httpStatus",type="com.greensock.events.LoaderEvent")]
   [Event(name="scriptAccessDenied",type="com.greensock.events.LoaderEvent")]
   [Event(name="childCancel",type="com.greensock.events.LoaderEvent")]
   [Event(name="childFail",type="com.greensock.events.LoaderEvent")]
   [Event(name="childComplete",type="com.greensock.events.LoaderEvent")]
   [Event(name="childProgress",type="com.greensock.events.LoaderEvent")]
   [Event(name="childOpen",type="com.greensock.events.LoaderEvent")]
   [Event(name="init",type="com.greensock.events.LoaderEvent")]
   public class XMLLoader extends DataLoader
   {
      
      private static var _classActivated:Boolean = _activateClass("XMLLoader",XMLLoader,"xml,php,jsp,asp,cfm,cfml,aspx");
      
      protected static var _varTypes:Object = {
         "skipFailed":true,
         "skipPaused":true,
         "autoLoad":false,
         "paused":false,
         "load":false,
         "noCache":false,
         "maxConnections":2,
         "autoPlay":false,
         "autoDispose":false,
         "smoothing":false,
         "autoDetachNetStream":false,
         "estimatedBytes":1,
         "x":1,
         "y":1,
         "z":1,
         "rotationX":1,
         "rotationY":1,
         "rotationZ":1,
         "width":1,
         "height":1,
         "scaleX":1,
         "scaleY":1,
         "rotation":1,
         "alpha":1,
         "visible":true,
         "bgColor":0,
         "bgAlpha":0,
         "deblocking":1,
         "repeat":1,
         "checkPolicyFile":false,
         "centerRegistration":false,
         "bufferTime":5,
         "volume":1,
         "bufferMode":false,
         "estimatedDuration":200,
         "crop":false,
         "autoAdjustBuffer":true,
         "suppressInitReparentEvents":true
      };
      
      public static var RAW_LOAD:String = "rawLoad";
      
      protected var _initted:Boolean;
      
      protected var _parsed:LoaderMax;
      
      protected var _loadingQueue:LoaderMax;
      
      public function XMLLoader(urlOrRequest:*, vars:Object = null)
      {
         super(urlOrRequest,vars);
         _preferEstimatedBytesInAudit = true;
         _type = "XMLLoader";
         _loader.dataFormat = "text";
      }
      
      public static function parseLoaders(xml:XML, all:LoaderMax, toLoad:LoaderMax = null) : void
      {
         var node:XML = null;
         var queue:LoaderMax = null;
         var replaceText:Array = null;
         var i:int = 0;
         var loaderClass:Class = null;
         var parsedVars:Object = null;
         var loader:LoaderCore = null;
         var p:String = null;
         var nodeName:String = String(xml.name()).toLowerCase();
         if(nodeName == "loadermax")
         {
            queue = all.append(new LoaderMax(_parseVars(xml))) as LoaderMax;
            if(toLoad != null && Boolean(queue.vars.load))
            {
               toLoad.append(queue);
            }
            if(queue.vars.childrenVars != null && queue.vars.childrenVars.indexOf(":") != -1)
            {
               queue.vars.childrenVars = _parseVars(new XML("<childrenVars " + queue.vars.childrenVars.split(",").join("\" ").split(":").join("=\"") + "\" />"));
            }
            for each(node in xml.children())
            {
               parseLoaders(node,queue,toLoad);
            }
            if("replaceURLText" in queue.vars)
            {
               replaceText = queue.vars.replaceURLText.split(",");
               for(i = 0; i < replaceText.length; i += 2)
               {
                  queue.replaceURLText(replaceText[i],replaceText[i + 1],false);
               }
            }
            if("prependURLs" in queue.vars)
            {
               queue.prependURLs(queue.vars.prependURLs,false);
            }
         }
         else
         {
            if(nodeName in _types)
            {
               loaderClass = _types[nodeName];
               parsedVars = _parseVars(xml);
               if(typeof all.vars.childrenVars == "object")
               {
                  for(p in all.vars.childrenVars)
                  {
                     if(!(p in parsedVars))
                     {
                        parsedVars[p] = all.vars.childrenVars[p];
                     }
                  }
               }
               loader = all.append(new loaderClass(xml.@url,parsedVars));
               if(toLoad != null && Boolean(loader.vars.load))
               {
                  toLoad.append(loader);
               }
            }
            for each(node in xml.children())
            {
               parseLoaders(node,all,toLoad);
            }
         }
      }
      
      protected static function _parseVars(xml:XML) : Object
      {
         var s:String = null;
         var type:String = null;
         var value:String = null;
         var domain:ApplicationDomain = null;
         var attribute:XML = null;
         var v:Object = {"rawXML":xml};
         var list:XMLList = xml.attributes();
         for each(attribute in list)
         {
            s = attribute.name();
            value = attribute.toString();
            if(s != "url")
            {
               if(s == "context")
               {
                  v.context = new LoaderContext(true,value == "own" ? ApplicationDomain.currentDomain : (value == "separate" ? new ApplicationDomain() : new ApplicationDomain(ApplicationDomain.currentDomain)),!_isLocal ? SecurityDomain.currentDomain : null);
               }
               else
               {
                  type = typeof _varTypes[s];
                  if(type == "boolean")
                  {
                     v[s] = Boolean(value == "true" || value == "1");
                  }
                  else if(type == "number")
                  {
                     v[s] = Number(value);
                  }
                  else
                  {
                     v[s] = value;
                  }
               }
            }
         }
         return v;
      }
      
      public function getContent(nameOrURL:String) : *
      {
         if(nameOrURL == this.name || nameOrURL == _url)
         {
            return _content;
         }
         var loader:LoaderCore = this.getLoader(nameOrURL);
         return loader != null ? loader.content : null;
      }
      
      override protected function _load() : void
      {
         if(!_initted)
         {
            _prepRequest();
            _loader.load(_request);
         }
         else if(_loadingQueue != null)
         {
            _changeQueueListeners(true);
            _loadingQueue.load(false);
         }
      }
      
      override public function get progress() : Number
      {
         return this.bytesTotal != 0 ? _cachedBytesLoaded / _cachedBytesTotal : (_status == LoaderStatus.COMPLETED || _initted ? 1 : 0);
      }
      
      public function getLoader(nameOrURL:String) : *
      {
         return _parsed != null ? _parsed.getLoader(nameOrURL) : null;
      }
      
      override protected function _passThroughEvent(event:Event) : void
      {
         if(event.target != _loadingQueue)
         {
            super._passThroughEvent(event);
         }
      }
      
      override protected function _failHandler(event:Event, dispatchError:Boolean = true) : void
      {
         if(event.target == _loadingQueue)
         {
            _status = LoaderStatus.FAILED;
            _time = getTimer() - _time;
            dispatchEvent(new LoaderEvent(LoaderEvent.CANCEL,this));
            dispatchEvent(new LoaderEvent(LoaderEvent.FAIL,this,this.toString() + " > " + (event as Object).text));
         }
         else
         {
            super._failHandler(event,dispatchError);
         }
      }
      
      override protected function _completeHandler(event:Event = null) : void
      {
         _calculateProgress();
         if(this.progress == 1)
         {
            _changeQueueListeners(false);
            super._completeHandler(event);
         }
      }
      
      public function getChildren(includeNested:Boolean = false, omitLoaderMaxes:Boolean = false) : Array
      {
         return _parsed != null ? _parsed.getChildren(includeNested,omitLoaderMaxes) : [];
      }
      
      override protected function _dump(scrubLevel:int = 0, newStatus:int = 0, suppressEvents:Boolean = false) : void
      {
         if(_loadingQueue != null)
         {
            _changeQueueListeners(false);
            if(scrubLevel == 0)
            {
               _loadingQueue.cancel();
            }
            else
            {
               _loadingQueue.dispose(Boolean(scrubLevel == 3));
               _loadingQueue = null;
            }
         }
         if(scrubLevel >= 1)
         {
            if(_parsed != null)
            {
               _parsed.dispose(Boolean(scrubLevel == 3));
               _parsed = null;
            }
            _initted = false;
         }
         _cacheIsDirty = true;
         var content:* = _content;
         super._dump(scrubLevel,newStatus,suppressEvents);
         if(scrubLevel == 0)
         {
            _content = content;
         }
      }
      
      override protected function _calculateProgress() : void
      {
         _cachedBytesLoaded = _loader.bytesLoaded;
         if(_loader.bytesTotal != 0)
         {
            _cachedBytesTotal = _loader.bytesTotal;
         }
         if(_cachedBytesTotal < _cachedBytesLoaded || _initted)
         {
            _cachedBytesTotal = _cachedBytesLoaded;
         }
         var estimate:uint = uint(this.vars.estimatedBytes);
         if(this.vars.integrateProgress != false)
         {
            if(_loadingQueue != null && (uint(this.vars.estimatedBytes) < _cachedBytesLoaded || _loadingQueue.auditedSize))
            {
               if(_loadingQueue.status <= LoaderStatus.COMPLETED)
               {
                  _cachedBytesLoaded += _loadingQueue.bytesLoaded;
                  _cachedBytesTotal += _loadingQueue.bytesTotal;
               }
            }
            else if(uint(this.vars.estimatedBytes) > _cachedBytesLoaded && (!_initted || _loadingQueue != null && _loadingQueue.status <= LoaderStatus.COMPLETED && !_loadingQueue.auditedSize))
            {
               _cachedBytesTotal = uint(this.vars.estimatedBytes);
            }
         }
         if(!_initted && _cachedBytesLoaded == _cachedBytesTotal)
         {
            _cachedBytesLoaded = int(_cachedBytesLoaded * 0.99);
         }
         _cacheIsDirty = false;
      }
      
      override protected function _receiveDataHandler(event:Event) : void
      {
         var loaders:Array = null;
         var i:int = 0;
         try
         {
            _content = new XML(_loader.data);
         }
         catch(error:Error)
         {
            _content = _loader.data;
            _failHandler(new LoaderEvent(LoaderEvent.ERROR,this,error.message));
            return;
         }
         dispatchEvent(new LoaderEvent(RAW_LOAD,this,"",_content));
         _initted = true;
         _loadingQueue = new LoaderMax({
            "name":this.name + "_Queue",
            "maxConnections":uint(this.vars.maxConnections) || 2,
            "skipFailed":Boolean(this.vars.skipFailed != false),
            "skipPaused":Boolean(this.vars.skipPaused != false)
         });
         _parsed = new LoaderMax({
            "name":this.name + "_ParsedLoaders",
            "paused":true
         });
         parseLoaders(_content as XML,_parsed,_loadingQueue);
         if(_parsed.numChildren == 0)
         {
            _parsed.dispose(false);
            _parsed = null;
         }
         else if("recursivePrependURLs" in this.vars)
         {
            _parsed.prependURLs(this.vars.recursivePrependURLs,true);
            loaders = _parsed.getChildren(true,true);
            i = int(loaders.length);
            while(--i > -1)
            {
               if(loaders[i] is XMLLoader)
               {
                  loaders[i].vars.recursivePrependURLs = this.vars.recursivePrependURLs;
               }
            }
         }
         else if("prependURLs" in this.vars)
         {
            _parsed.prependURLs(this.vars.prependURLs,true);
         }
         if(_loadingQueue.getChildren(true,true).length == 0)
         {
            _loadingQueue.empty(false);
            _loadingQueue.dispose(false);
            _loadingQueue = null;
            dispatchEvent(new LoaderEvent(LoaderEvent.INIT,this,"",_content));
         }
         else
         {
            _cacheIsDirty = true;
            _changeQueueListeners(true);
            dispatchEvent(new LoaderEvent(LoaderEvent.INIT,this,"",_content));
            _loadingQueue.load(false);
         }
         if(_loadingQueue == null || this.vars.integrateProgress == false)
         {
            _completeHandler(event);
         }
      }
      
      protected function _changeQueueListeners(add:Boolean) : void
      {
         var p:String = null;
         if(_loadingQueue != null)
         {
            if(add && this.vars.integrateProgress != false)
            {
               for(p in _listenerTypes)
               {
                  if(p != "onProgress" && p != "onInit")
                  {
                     _loadingQueue.addEventListener(_listenerTypes[p],_passThroughEvent,false,-100,true);
                  }
               }
               _loadingQueue.addEventListener(LoaderEvent.COMPLETE,_completeHandler,false,-100,true);
               _loadingQueue.addEventListener(LoaderEvent.PROGRESS,_progressHandler,false,-100,true);
               _loadingQueue.addEventListener(LoaderEvent.FAIL,_failHandler,false,-100,true);
            }
            else
            {
               _loadingQueue.removeEventListener(LoaderEvent.COMPLETE,_completeHandler);
               _loadingQueue.removeEventListener(LoaderEvent.PROGRESS,_progressHandler);
               _loadingQueue.removeEventListener(LoaderEvent.FAIL,_failHandler);
               for(p in _listenerTypes)
               {
                  if(p != "onProgress" && p != "onInit")
                  {
                     _loadingQueue.removeEventListener(_listenerTypes[p],_passThroughEvent);
                  }
               }
            }
         }
      }
      
      override protected function _progressHandler(event:Event) : void
      {
         var bl:uint = 0;
         var bt:uint = 0;
         if(_dispatchProgress)
         {
            bl = _cachedBytesLoaded;
            bt = _cachedBytesTotal;
            _calculateProgress();
            if(_cachedBytesLoaded != _cachedBytesTotal && (bl != _cachedBytesLoaded || bt != _cachedBytesTotal))
            {
               dispatchEvent(new LoaderEvent(LoaderEvent.PROGRESS,this));
            }
         }
         else
         {
            _cacheIsDirty = true;
         }
      }
   }
}

