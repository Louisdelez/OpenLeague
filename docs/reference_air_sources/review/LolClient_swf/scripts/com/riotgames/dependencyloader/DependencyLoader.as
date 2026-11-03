package com.riotgames.dependencyloader
{
   import flash.display.Loader;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.UncaughtErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   
   public class DependencyLoader extends EventDispatcher
   {
      
      public static var defaultUncaughtExceptionHandler:Function;
      
      private var _context:LoaderContext;
      
      private var _loader:Loader;
      
      private var _urlLoader:URLLoader;
      
      private var _urlRequest:URLRequest;
      
      private var _dependencies:Vector.<DependencyLoader>;
      
      private var _dependants:Vector.<DependencyLoader> = new Vector.<DependencyLoader>();
      
      private var _invalidDependencies:Vector.<String>;
      
      private var _isLoading:Boolean;
      
      private var _isComplete:Boolean;
      
      private var _loadingIsComplete:Boolean;
      
      private var _errorEvent:ErrorEvent;
      
      private var bytes:ByteArray;
      
      public function DependencyLoader(param1:URLRequest, param2:Vector.<DependencyLoader>, param3:LoaderContext)
      {
         var _loc4_:DependencyLoader = null;
         super();
         this._context = param3;
         this._urlRequest = param1;
         this._dependencies = param2;
         for each(_loc4_ in this._dependencies)
         {
            _loc4_.addEventListener(Event.COMPLETE,this.dependencyCompleteHandler);
            _loc4_.addEventListener(IOErrorEvent.IO_ERROR,this.dependencyErredHandler);
            _loc4_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.dependencyErredHandler);
            _loc4_.addDependant(this);
         }
         this.setLoader(new Loader());
         this.setUrlLoader(new URLLoader());
      }
      
      private function setLoader(param1:Loader) : void
      {
         if(this._loader != null)
         {
            this._loader.contentLoaderInfo.uncaughtErrorEvents.removeEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,defaultUncaughtExceptionHandler);
            this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.loaderCompleteHandler);
         }
         this._loader = param1;
         if(this._loader != null)
         {
            if(defaultUncaughtExceptionHandler != null)
            {
               this._loader.contentLoaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,defaultUncaughtExceptionHandler);
            }
            this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.loaderCompleteHandler);
         }
      }
      
      private function setUrlLoader(param1:URLLoader) : void
      {
         if(this._urlLoader != null)
         {
            this._urlLoader.removeEventListener(Event.COMPLETE,this.dataLoadCompleteHandler);
            this._urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.dataLoadErrorHandler);
            this._urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.dataLoadErrorHandler);
            this._urlLoader.removeEventListener(ProgressEvent.PROGRESS,this.bubbleEvent);
         }
         this._urlLoader = param1;
         if(this._urlLoader != null)
         {
            this._urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
            this._urlLoader.addEventListener(Event.COMPLETE,this.dataLoadCompleteHandler);
            this._urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.dataLoadErrorHandler);
            this._urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.dataLoadErrorHandler);
            this._urlLoader.addEventListener(ProgressEvent.PROGRESS,this.bubbleEvent);
         }
      }
      
      private function loaderCompleteHandler(param1:Event) : void
      {
         this._isComplete = true;
         this.bubbleEvent(param1);
      }
      
      private function addDependant(param1:DependencyLoader) : void
      {
         this._dependants[this._dependants.length] = param1;
      }
      
      private function bubbleEvent(param1:Event) : void
      {
         dispatchEvent(param1.clone());
      }
      
      private function dependencyErredHandler(param1:ErrorEvent) : void
      {
         this._errorEvent = param1;
         this.bubbleEvent(param1);
      }
      
      public function getErrorEvent() : ErrorEvent
      {
         return this._errorEvent;
      }
      
      public function getIsLoading() : Boolean
      {
         return this._isLoading;
      }
      
      public function getIsComplete() : Boolean
      {
         return this._isComplete;
      }
      
      public function getLoadingIsComplete() : Boolean
      {
         return this._loadingIsComplete;
      }
      
      public function getContext() : LoaderContext
      {
         return this._context;
      }
      
      public function setContext(param1:LoaderContext) : void
      {
         this._context = param1;
      }
      
      public function getLoader() : Loader
      {
         return this._loader;
      }
      
      public function getUrlRequest() : URLRequest
      {
         return this._urlRequest;
      }
      
      public function getUrlLoader() : URLLoader
      {
         return this._urlLoader;
      }
      
      public function load(param1:Function = null, param2:Function = null, param3:Function = null) : void
      {
         var removeEventListeners:Function;
         var failHandler:Function = null;
         var completeHandler:Function = null;
         var progressHandler:Function = null;
         var dependencyLoader:DependencyLoader = null;
         var successCallback:Function = param1;
         var failCallback:Function = param2;
         var progressCallback:Function = param3;
         if(!this.getIsDormant())
         {
            return;
         }
         if(this._invalidDependencies != null)
         {
            throw new Error("Failed loading " + this._urlRequest.url + " due to invalid dependencies" + this._invalidDependencies.join(", ") + ".");
         }
         if(this._isComplete)
         {
            if(successCallback != null)
            {
               successCallback(this);
            }
            return;
         }
         if(this._errorEvent != null)
         {
            if(failCallback != null)
            {
               failCallback(this);
            }
            return;
         }
         removeEventListeners = function():void
         {
            removeEventListener(Event.COMPLETE,completeHandler);
            removeEventListener(IOErrorEvent.IO_ERROR,failHandler);
            removeEventListener(SecurityErrorEvent.SECURITY_ERROR,failHandler);
            removeEventListener(ProgressEvent.PROGRESS,progressHandler);
         };
         dependencyLoader = this;
         completeHandler = function(param1:Event):void
         {
            removeEventListeners();
            if(successCallback != null)
            {
               successCallback(dependencyLoader);
            }
         };
         failHandler = function(param1:ErrorEvent):void
         {
            removeEventListeners();
            _errorEvent = param1;
            if(failCallback != null)
            {
               failCallback(dependencyLoader);
            }
         };
         progressHandler = function(param1:ProgressEvent):void
         {
            if(progressCallback != null)
            {
               progressCallback(param1);
            }
         };
         addEventListener(Event.COMPLETE,completeHandler);
         addEventListener(IOErrorEvent.IO_ERROR,failHandler);
         addEventListener(SecurityErrorEvent.SECURITY_ERROR,failHandler);
         addEventListener(ProgressEvent.PROGRESS,progressHandler);
         this.beginLoading();
      }
      
      protected function beginLoading() : void
      {
         var _loc1_:DependencyLoader = null;
         if(!this.getIsDormant())
         {
            return;
         }
         this._isComplete = false;
         this._loadingIsComplete = false;
         this._isLoading = true;
         for each(_loc1_ in this._dependencies)
         {
            if(!_loc1_.getIsComplete())
            {
               _loc1_.beginLoading();
            }
         }
         this._urlLoader.load(this._urlRequest);
      }
      
      protected function loadBytes() : void
      {
         if(this.bytes == null || !this._loadingIsComplete || !this.getDependenciesLoaded())
         {
            return;
         }
         this._loader.loadBytes(this.bytes,this._context);
         this.bytes.clear();
         this.bytes = null;
      }
      
      private function getDependenciesLoaded() : Boolean
      {
         var _loc1_:DependencyLoader = null;
         for each(_loc1_ in this._dependencies)
         {
            if(!_loc1_.getIsComplete())
            {
               return false;
            }
         }
         return true;
      }
      
      public function unload() : void
      {
         var _loc1_:DependencyLoader = null;
         var _loc2_:DependencyLoader = null;
         if(this.getIsDormant())
         {
            return;
         }
         this.reset();
         for each(_loc1_ in this._dependencies)
         {
            if(_loc1_.getIsAnOrphan())
            {
               _loc1_.unload();
            }
         }
         for each(_loc2_ in this._dependants)
         {
            _loc2_.unload();
         }
         this._loader.unloadAndStop(true);
         this.setLoader(new Loader());
         this.setUrlLoader(new URLLoader());
      }
      
      public function reset() : void
      {
         this._isLoading = false;
         this._loadingIsComplete = false;
         this._isComplete = false;
         this._errorEvent = null;
      }
      
      public function getIsAnOrphan() : Boolean
      {
         var _loc1_:DependencyLoader = null;
         for each(_loc1_ in this._dependants)
         {
            if(!_loc1_.getIsDormant())
            {
               return false;
            }
         }
         return true;
      }
      
      public function getIsDormant() : Boolean
      {
         return !this._isLoading && !this._isComplete && this._errorEvent == null;
      }
      
      public function addInvalidDependency(param1:String) : *
      {
         if(this._invalidDependencies == null)
         {
            this._invalidDependencies = new Vector.<String>();
         }
         this._invalidDependencies.push(param1);
      }
      
      private function dependencyCompleteHandler(param1:Event) : void
      {
         this.loadBytes();
      }
      
      private function dataLoadErrorHandler(param1:ErrorEvent) : void
      {
         this._isLoading = false;
         dispatchEvent(param1);
      }
      
      protected function dataLoadCompleteHandler(param1:Event) : void
      {
         this._loadingIsComplete = true;
         this._isLoading = false;
         this.bytes = this._urlLoader.data as ByteArray;
         this._urlLoader.close();
         if(this.bytes.bytesAvailable == 0)
         {
            throw new Error("Could not load " + this._urlRequest.url + ", its data was empty.");
         }
         this.loadBytes();
      }
   }
}

