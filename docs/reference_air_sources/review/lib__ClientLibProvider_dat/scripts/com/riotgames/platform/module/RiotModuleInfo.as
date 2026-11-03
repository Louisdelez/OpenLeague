package com.riotgames.platform.module
{
   import blix.signals.IToggleSignal;
   import blix.signals.ToggleSignal;
   import com.riotgames.dependencyloader.DependenciesManager;
   import com.riotgames.dependencyloader.DependencyLoader;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   
   public class RiotModuleInfo
   {
      
      protected var _completed:ToggleSignal = new ToggleSignal();
      
      protected var _erred:ToggleSignal = new ToggleSignal();
      
      private var _error:Error;
      
      private var _loadInvoked:Boolean;
      
      private var _instance:Object;
      
      private var _isReady:Boolean;
      
      private var _isPendingUrl:Boolean;
      
      private var _path:String;
      
      private var _url:String;
      
      private var _fileName:String;
      
      private var _extraData:Dictionary;
      
      public function RiotModuleInfo(param1:String = null, param2:Dictionary = null)
      {
         super();
         this._url = param1;
         this._extraData = param2;
      }
      
      public function getPath() : String
      {
         if(this._path == null)
         {
            this._path = this.getUrl().replace(/[^\/\\]*$/,"");
         }
         return this._path;
      }
      
      public function getFileName() : String
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(this._fileName == null)
         {
            _loc1_ = uint(this.getUrl().lastIndexOf("/"));
            _loc2_ = uint(this.getUrl().lastIndexOf("\\"));
            this._fileName = this.getUrl().substr(0,Math.max(_loc1_,_loc2_));
         }
         return this._fileName;
      }
      
      public function getModuleAssetPath(param1:String, param2:String = "") : String
      {
         var _loc3_:String = this.getPath() + "assets/";
         if(param2.length > 0)
         {
            _loc3_ += param2 + "/";
         }
         return _loc3_ + param1;
      }
      
      public function getErred() : IToggleSignal
      {
         return this._erred;
      }
      
      public function getCompleted() : IToggleSignal
      {
         return this._completed;
      }
      
      public function getIsReady() : Boolean
      {
         return this._isReady;
      }
      
      public function getUrl() : String
      {
         return this._url;
      }
      
      public function setUrl(param1:String) : void
      {
         this._path = null;
         this._fileName = null;
         this._url = param1;
         if(this._isPendingUrl)
         {
            this.load();
         }
      }
      
      public function getError() : Error
      {
         return this._error;
      }
      
      public function setError(param1:Error) : void
      {
         this._error = param1;
         this._erred.dispatch(this);
         this._completed.removeAll();
      }
      
      public function getModuleInstance() : Object
      {
         return this._instance;
      }
      
      public function getExtraData() : Dictionary
      {
         return this._extraData;
      }
      
      public function getExtraDataValue(param1:String) : *
      {
         if(this._extraData == null)
         {
            return null;
         }
         return this._extraData[param1];
      }
      
      public function load() : void
      {
         if(this._loadInvoked)
         {
            return;
         }
         if(!this._url)
         {
            this._isPendingUrl = true;
            return;
         }
         this._loadInvoked = true;
         this.getDependencyLoader().load(this.loadCompleteHandler,this.loadErrorHandler);
      }
      
      public function reload() : void
      {
         this.reset();
         this.load();
      }
      
      public function reset() : void
      {
         if(this._loadInvoked)
         {
            this._completed.toggleOff();
            this._erred.toggleOff();
            this._loadInvoked = false;
            this.getDependencyLoader().unload();
         }
      }
      
      protected function loadCompleteHandler(param1:DependencyLoader) : void
      {
         var _loc2_:Object = null;
         this._instance = this.create(param1.getLoader().content);
         if(this._instance == null)
         {
            _loc2_ = param1.getLoader().content;
            (_loc2_ as IEventDispatcher).addEventListener("ready",this.moduleReadyHandler);
         }
         else
         {
            this.moduleCompleted();
         }
      }
      
      protected function moduleReadyHandler(param1:Event) : void
      {
         (param1.currentTarget as IEventDispatcher).removeEventListener(param1.type,this.moduleReadyHandler);
         this._instance = this.create(param1.currentTarget);
         if(this._instance == null)
         {
            throw new Error("There was a problem with the module\'s factory. " + this.toString());
         }
         this.moduleCompleted();
      }
      
      protected function moduleCompleted() : void
      {
         this._erred.removeAll();
         this._completed.dispatch(this);
      }
      
      protected function create(param1:Object) : Object
      {
         if(param1.hasOwnProperty("create"))
         {
            return param1.create();
         }
         return param1;
      }
      
      protected function loadErrorHandler(param1:DependencyLoader) : void
      {
         this.setError(new Error(param1.getErrorEvent().text));
      }
      
      public function getDependencyLoader() : DependencyLoader
      {
         return DependenciesManager.getLoader(new URLRequest(this._url));
      }
      
      public function toString() : String
      {
         return "[RiotModuleInfo url=" + this._url + "]";
      }
   }
}

