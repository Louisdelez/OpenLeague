package com.greensock.loading
{
   import com.greensock.events.LoaderEvent;
   import com.greensock.loading.core.LoaderCore;
   import com.greensock.loading.core.LoaderItem;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import flash.utils.Dictionary;
   
   [Event(name="securityError",type="com.greensock.events.LoaderEvent")]
   [Event(name="ioError",type="com.greensock.events.LoaderEvent")]
   [Event(name="httpStatus",type="com.greensock.events.LoaderEvent")]
   [Event(name="scriptAccessDenied",type="com.greensock.events.LoaderEvent")]
   [Event(name="childCancel",type="com.greensock.events.LoaderEvent")]
   [Event(name="childFail",type="com.greensock.events.LoaderEvent")]
   [Event(name="childComplete",type="com.greensock.events.LoaderEvent")]
   [Event(name="childProgress",type="com.greensock.events.LoaderEvent")]
   [Event(name="childOpen",type="com.greensock.events.LoaderEvent")]
   public class LoaderMax extends LoaderCore
   {
      
      public static var defaultContext:LoaderContext;
      
      public static var contentDisplayClass:Class;
      
      public static const version:Number = 1.898;
      
      public static var defaultEstimatedBytes:uint = 20000;
      
      public static var defaultAuditSize:Boolean = true;
      
      protected var _loaders:Array;
      
      public var skipPaused:Boolean;
      
      public var maxConnections:uint;
      
      protected var _activeLoaders:Dictionary;
      
      public var skipFailed:Boolean;
      
      public var autoLoad:Boolean;
      
      public function LoaderMax(vars:Object = null)
      {
         var i:int = 0;
         super(vars);
         _type = "LoaderMax";
         _loaders = [];
         _activeLoaders = new Dictionary();
         this.skipFailed = Boolean(this.vars.skipFailed != false);
         this.skipPaused = Boolean(this.vars.skipPaused != false);
         this.autoLoad = Boolean(this.vars.autoLoad == true);
         this.maxConnections = "maxConnections" in this.vars ? uint(this.vars.maxConnections) : 2;
         if(this.vars.loaders is Array)
         {
            for(i = 0; i < this.vars.loaders.length; i++)
            {
               insert(this.vars.loaders[i],i);
            }
         }
      }
      
      public static function getContent(nameOrURL:String) : *
      {
         return _globalRootLoader != null ? _globalRootLoader.getContent(nameOrURL) : null;
      }
      
      public static function getLoader(nameOrURL:String) : *
      {
         return _globalRootLoader != null ? _globalRootLoader.getLoader(nameOrURL) : null;
      }
      
      public static function parse(data:*, vars:Object = null, childrenVars:Object = null) : *
      {
         var queue:LoaderMax = null;
         var l:int = 0;
         var i:int = 0;
         var s:String = null;
         if(data is Array)
         {
            queue = new LoaderMax(vars);
            l = int(data.length);
            for(i = 0; i < l; i++)
            {
               queue.append(LoaderMax.parse(data[i],childrenVars));
            }
            return queue;
         }
         if(data is String || data is URLRequest)
         {
            s = data is String ? data : URLRequest(data).url;
            s = s.toLowerCase().split("?")[0];
            s = s.substr(s.lastIndexOf(".") + 1);
            if(s in _extensions)
            {
               return new _extensions[s](data,vars);
            }
         }
         else if(data is LoaderCore)
         {
            return data as LoaderCore;
         }
         throw new Error("LoaderMax could not parse " + data + ". Don\'t forget to use LoaderMax.activate() to activate the necessary types of loaders.");
      }
      
      public static function registerFileType(extensions:String, loaderClass:Class) : void
      {
         _activateClass("",loaderClass,extensions);
      }
      
      public static function activate(loaderClasses:Array) : void
      {
      }
      
      public static function prioritize(nameOrURL:String, loadNow:Boolean = true) : LoaderCore
      {
         var loader:LoaderCore = getLoader(nameOrURL);
         if(loader != null)
         {
            loader.prioritize(loadNow);
         }
         return loader;
      }
      
      public function getChildAt(index:int) : *
      {
         return _loaders[index];
      }
      
      public function getContent(nameOrURL:String) : *
      {
         var loader:LoaderCore = this.getLoader(nameOrURL);
         return loader != null ? loader.content : null;
      }
      
      public function remove(loader:LoaderCore) : void
      {
         _removeLoader(loader,true);
      }
      
      override protected function _load() : void
      {
         _loadNext(null);
      }
      
      protected function _cancelActiveLoaders() : void
      {
         var loader:LoaderCore = null;
         var i:int = int(_loaders.length);
         while(--i > -1)
         {
            loader = _loaders[i];
            if(loader.status == LoaderStatus.LOADING)
            {
               delete _activeLoaders[loader];
               _removeLoaderListeners(loader,false);
               loader.cancel();
            }
         }
      }
      
      protected function _removeLoaderListeners(loader:LoaderCore, all:Boolean) : void
      {
         var p:String = null;
         loader.removeEventListener(LoaderEvent.COMPLETE,_loadNext);
         loader.removeEventListener(LoaderEvent.CANCEL,_loadNext);
         if(all)
         {
            loader.removeEventListener(LoaderEvent.PROGRESS,_progressHandler);
            loader.removeEventListener("prioritize",_prioritizeHandler);
            loader.removeEventListener("dispose",_disposeHandler);
            for(p in _listenerTypes)
            {
               if(p != "onProgress" && p != "onInit")
               {
                  loader.removeEventListener(_listenerTypes[p],_passThroughEvent);
               }
            }
         }
      }
      
      protected function _disposeHandler(event:Event) : void
      {
         _removeLoader(LoaderCore(event.target),false);
      }
      
      override public function auditSize() : void
      {
         if(!this.auditedSize)
         {
            _auditSize(null);
         }
      }
      
      public function getChildIndex(loader:LoaderCore) : uint
      {
         var i:int = int(_loaders.length);
         while(--i > -1)
         {
            if(_loaders[i] == loader)
            {
               return i;
            }
         }
         return 999999999;
      }
      
      public function prepend(loader:LoaderCore) : LoaderCore
      {
         return insert(loader,0);
      }
      
      public function getLoader(nameOrURL:String) : *
      {
         var loader:LoaderCore = null;
         var i:int = int(_loaders.length);
         while(--i > -1)
         {
            loader = _loaders[i];
            if(loader.name == nameOrURL || loader is LoaderItem && (loader as LoaderItem).url == nameOrURL)
            {
               return loader;
            }
            if(loader.hasOwnProperty("getLoader"))
            {
               loader = (loader as Object).getLoader(nameOrURL) as LoaderCore;
               if(loader != null)
               {
                  return loader;
               }
            }
         }
         return null;
      }
      
      public function prependURLs(prependText:String, includeNested:Boolean = false) : void
      {
         var loaders:Array = getChildren(includeNested,true);
         var i:int = int(loaders.length);
         while(--i > -1)
         {
            LoaderItem(loaders[i]).url = prependText + LoaderItem(loaders[i]).url;
         }
      }
      
      override protected function _dump(scrubLevel:int = 0, newStatus:int = 0, suppressEvents:Boolean = false) : void
      {
         var i:int = 0;
         if(newStatus == LoaderStatus.DISPOSED)
         {
            _status = LoaderStatus.DISPOSED;
            empty(true,Boolean(scrubLevel == 3));
            if(this.vars.requireWithRoot is DisplayObject)
            {
               delete _rootLookup[this.vars.requireWithRoot];
            }
            _activeLoaders = null;
         }
         if(scrubLevel <= 1)
         {
            _cancelActiveLoaders();
         }
         if(scrubLevel == 1)
         {
            i = int(_loaders.length);
            while(--i > -1)
            {
               LoaderCore(_loaders[i]).unload();
            }
         }
         super._dump(scrubLevel,newStatus,suppressEvents);
         _cacheIsDirty = true;
      }
      
      public function empty(disposeChildren:Boolean = true, unloadAllContent:Boolean = false) : void
      {
         var i:int = int(_loaders.length);
         while(--i > -1)
         {
            if(disposeChildren)
            {
               LoaderCore(_loaders[i]).dispose(unloadAllContent);
            }
            else if(unloadAllContent)
            {
               LoaderCore(_loaders[i]).unload();
            }
            else
            {
               _removeLoader(_loaders[i],true);
            }
         }
      }
      
      protected function _removeLoader(loader:LoaderCore, rootLoaderAppend:Boolean) : void
      {
         if(loader == null)
         {
            return;
         }
         if(rootLoaderAppend && this != loader.rootLoader)
         {
            loader.rootLoader.append(loader);
         }
         _removeLoaderListeners(loader,true);
         _loaders.splice(getChildIndex(loader),1);
         if(loader in _activeLoaders)
         {
            delete _activeLoaders[loader];
            loader.cancel();
            if(_status == LoaderStatus.LOADING)
            {
               _loadNext(null);
            }
         }
         _cacheIsDirty = true;
         _progressHandler(null);
      }
      
      public function get rawProgress() : Number
      {
         var status:int = 0;
         var loaded:Number = 0;
         var total:uint = 0;
         var i:int = int(_loaders.length);
         while(--i > -1)
         {
            status = LoaderCore(_loaders[i]).status;
            if(status != LoaderStatus.DISPOSED && !(status == LoaderStatus.PAUSED && this.skipPaused) && !(status == LoaderStatus.FAILED && this.skipFailed))
            {
               total++;
               loaded += _loaders[i] is LoaderMax ? LoaderMax(_loaders[i]).rawProgress : LoaderCore(_loaders[i]).progress;
            }
         }
         return total == 0 ? 0 : loaded / total;
      }
      
      protected function _loadNext(event:Event = null) : void
      {
         var audit:Boolean = false;
         var loader:LoaderCore = null;
         var loaders:Array = null;
         var l:int = 0;
         var activeCount:uint = 0;
         var i:int = 0;
         if(event != null && _activeLoaders != null)
         {
            delete _activeLoaders[event.target];
            _removeLoaderListeners(LoaderCore(event.target),false);
         }
         if(_status == LoaderStatus.LOADING)
         {
            audit = "auditSize" in this.vars ? Boolean(this.vars.auditSize) : LoaderMax.defaultAuditSize;
            if(audit && !this.auditedSize)
            {
               _auditSize(null);
               return;
            }
            loaders = _loaders.concat();
            l = int(loaders.length);
            activeCount = 0;
            _calculateProgress();
            for(i = 0; i < l; i++)
            {
               loader = loaders[i];
               if(!this.skipPaused && loader.status == LoaderStatus.PAUSED)
               {
                  super._failHandler(new LoaderEvent(LoaderEvent.FAIL,this,"Did not complete LoaderMax because skipPaused was false and " + loader.toString() + " was paused."),false);
                  return;
               }
               if(!this.skipFailed && loader.status == LoaderStatus.FAILED)
               {
                  super._failHandler(new LoaderEvent(LoaderEvent.FAIL,this,"Did not complete LoaderMax because skipFailed was false and " + loader.toString() + " failed."),false);
                  return;
               }
               if(loader.status <= LoaderStatus.LOADING)
               {
                  activeCount++;
                  if(!(loader in _activeLoaders))
                  {
                     _activeLoaders[loader] = true;
                     loader.addEventListener(LoaderEvent.COMPLETE,_loadNext,false,-100,true);
                     loader.addEventListener(LoaderEvent.CANCEL,_loadNext,false,-100,true);
                     loader.load(false);
                  }
                  if(activeCount == this.maxConnections)
                  {
                     break;
                  }
               }
            }
            if(activeCount == 0 && _cachedBytesLoaded == _cachedBytesTotal)
            {
               _completeHandler(null);
            }
         }
      }
      
      public function append(loader:LoaderCore) : LoaderCore
      {
         return insert(loader,_loaders.length);
      }
      
      override protected function _progressHandler(event:Event) : void
      {
         var bl:uint = 0;
         var bt:uint = 0;
         if(_dispatchChildProgress && event != null)
         {
            dispatchEvent(new LoaderEvent(LoaderEvent.CHILD_PROGRESS,event.target));
         }
         if(_dispatchProgress && _status != LoaderStatus.DISPOSED)
         {
            bl = _cachedBytesLoaded;
            bt = _cachedBytesTotal;
            _calculateProgress();
            if(!(bl == 0 && _cachedBytesLoaded == 0))
            {
               if((_cachedBytesLoaded != _cachedBytesTotal || _status != LoaderStatus.LOADING) && (bl != _cachedBytesLoaded || bt != _cachedBytesTotal))
               {
                  dispatchEvent(new LoaderEvent(LoaderEvent.PROGRESS,this));
               }
            }
         }
         else
         {
            _cacheIsDirty = true;
         }
      }
      
      protected function _prioritizeHandler(event:Event) : void
      {
         var prevMaxConnections:uint = 0;
         var loader:LoaderCore = event.target as LoaderCore;
         _loaders.splice(getChildIndex(loader),1);
         _loaders.unshift(loader);
         if(_status == LoaderStatus.LOADING && loader.status <= LoaderStatus.LOADING && !(loader in _activeLoaders))
         {
            _cancelActiveLoaders();
            prevMaxConnections = this.maxConnections;
            this.maxConnections = 1;
            _loadNext(null);
            this.maxConnections = prevMaxConnections;
         }
      }
      
      public function get numChildren() : uint
      {
         return _loaders.length;
      }
      
      override public function get content() : *
      {
         var a:Array = [];
         var i:int = int(_loaders.length);
         while(--i > -1)
         {
            a[i] = LoaderCore(_loaders[i]).content;
         }
         return a;
      }
      
      public function replaceURLText(fromText:String, toText:String, includeNested:Boolean = false) : void
      {
         var loader:LoaderItem = null;
         var loaders:Array = getChildren(includeNested,true);
         var i:int = int(loaders.length);
         while(--i > -1)
         {
            loader = loaders[i];
            loader.url = loader.url.split(fromText).join(toText);
            if("alternateURL" in loader.vars)
            {
               loader.vars.alternateURL = loader.vars.alternateURL.split(fromText).join(toText);
            }
         }
      }
      
      override public function get auditedSize() : Boolean
      {
         var maxStatus:int = this.skipPaused ? LoaderStatus.COMPLETED : LoaderStatus.PAUSED;
         var i:int = int(_loaders.length);
         while(--i > -1)
         {
            if(!LoaderCore(_loaders[i]).auditedSize && LoaderCore(_loaders[i]).status <= maxStatus)
            {
               return false;
            }
         }
         return true;
      }
      
      override public function get status() : int
      {
         var statusCounts:Array = null;
         var i:int = 0;
         if(_status == LoaderStatus.COMPLETED)
         {
            statusCounts = [0,0,0,0,0,0];
            i = int(_loaders.length);
            while(--i > -1)
            {
               ++statusCounts[LoaderCore(_loaders[i]).status];
            }
            if(!this.skipFailed && statusCounts[4] != 0 || !this.skipPaused && statusCounts[3] != 0)
            {
               _status = LoaderStatus.FAILED;
            }
            else if(statusCounts[0] + statusCounts[1] != 0)
            {
               _status = LoaderStatus.READY;
               _cacheIsDirty = true;
            }
         }
         return _status;
      }
      
      override protected function _calculateProgress() : void
      {
         var loader:LoaderCore = null;
         var s:int = 0;
         _cachedBytesLoaded = 0;
         _cachedBytesTotal = 0;
         var i:int = int(_loaders.length);
         while(--i > -1)
         {
            loader = _loaders[i];
            s = loader.status;
            if(s <= LoaderStatus.COMPLETED || !this.skipPaused && s == LoaderStatus.PAUSED || !this.skipFailed && s == LoaderStatus.FAILED)
            {
               _cachedBytesLoaded += loader.bytesLoaded;
               _cachedBytesTotal += loader.bytesTotal;
            }
         }
         _cacheIsDirty = false;
      }
      
      public function insert(loader:LoaderCore, index:uint = 999999999) : LoaderCore
      {
         var p:String = null;
         if(loader == null || loader == this || _status == LoaderStatus.DISPOSED)
         {
            return null;
         }
         if(this != loader.rootLoader)
         {
            _removeLoader(loader,false);
         }
         if(loader.rootLoader == _globalRootLoader)
         {
            loader.rootLoader.remove(loader);
         }
         if(index > _loaders.length)
         {
            index = _loaders.length;
         }
         _loaders.splice(index,0,loader);
         if(this != _globalRootLoader)
         {
            for(p in _listenerTypes)
            {
               if(p != "onProgress" && p != "onInit")
               {
                  loader.addEventListener(_listenerTypes[p],_passThroughEvent,false,-100,true);
               }
            }
            loader.addEventListener(LoaderEvent.PROGRESS,_progressHandler,false,-100,true);
            loader.addEventListener("prioritize",_prioritizeHandler,false,-100,true);
         }
         loader.addEventListener("dispose",_disposeHandler,false,-100,true);
         _cacheIsDirty = true;
         if(_status != LoaderStatus.LOADING)
         {
            if(_status != LoaderStatus.PAUSED)
            {
               _status = LoaderStatus.READY;
            }
            else if(_prePauseStatus == LoaderStatus.COMPLETED)
            {
               _prePauseStatus = LoaderStatus.READY;
            }
         }
         if(this.autoLoad && loader.status == LoaderStatus.READY)
         {
            if(_status != LoaderStatus.LOADING)
            {
               this.load(false);
            }
            else
            {
               _loadNext(null);
            }
         }
         return loader;
      }
      
      public function getChildren(includeNested:Boolean = false, omitLoaderMaxes:Boolean = false) : Array
      {
         var a:Array = [];
         var l:int = int(_loaders.length);
         for(var i:int = 0; i < l; i++)
         {
            if(!omitLoaderMaxes || !(_loaders[i] is LoaderMax))
            {
               a.push(_loaders[i]);
            }
            if(includeNested && Boolean(_loaders[i].hasOwnProperty("getChildren")))
            {
               a = a.concat(_loaders[i].getChildren(true,omitLoaderMaxes));
            }
         }
         return a;
      }
      
      protected function _auditSize(event:Event = null) : void
      {
         var loader:LoaderCore = null;
         var found:Boolean = false;
         if(event != null)
         {
            event.target.removeEventListener("auditedSize",_auditSize);
            event.target.removeEventListener(LoaderEvent.FAIL,_auditSize);
         }
         var l:uint = _loaders.length;
         var maxStatus:int = this.skipPaused ? LoaderStatus.COMPLETED : LoaderStatus.PAUSED;
         for(var i:int = 0; i < l; i++)
         {
            loader = _loaders[i];
            if(!loader.auditedSize && loader.status <= maxStatus)
            {
               if(!found)
               {
                  loader.addEventListener("auditedSize",_auditSize,false,-100,true);
                  loader.addEventListener(LoaderEvent.FAIL,_auditSize,false,-100,true);
               }
               found = true;
               loader.auditSize();
            }
         }
         if(!found)
         {
            if(_status == LoaderStatus.LOADING)
            {
               _loadNext(null);
            }
            dispatchEvent(new Event("auditedSize"));
         }
      }
      
      public function getChildrenByStatus(status:int, includeNested:Boolean = false) : Array
      {
         var a:Array = [];
         var loaders:Array = getChildren(includeNested,false);
         var l:int = int(loaders.length);
         for(var i:int = 0; i < l; i++)
         {
            if(LoaderCore(loaders[i]).status == status)
            {
               a.push(loaders[i]);
            }
         }
         return a;
      }
   }
}

