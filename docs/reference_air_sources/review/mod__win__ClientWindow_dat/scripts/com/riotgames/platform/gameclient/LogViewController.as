package com.riotgames.platform.gameclient
{
   import com.riotgames.pvpnet.system.logging.LogManager;
   import com.riotgames.pvpnet.system.logging.MemoryTarget;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   import mx.logging.Log;
   import mx.logging.LogEventLevel;
   import mx.logging.targets.TraceTarget;
   
   public class LogViewController implements IEventDispatcher
   {
      
      private var regex:RegExp;
      
      public var logManager:LogManager = LogManager.instance;
      
      private var _1277920432logMessages:ArrayCollection;
      
      private var _1418339351logFilters:ArrayCollection;
      
      private var _1738138067logLevels:ArrayCollection;
      
      private var _1995731616logLevel:String;
      
      private var _logMessages:ArrayCollection;
      
      private var logMemoryBufferLimit:int = 5000;
      
      private var _searchString:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function LogViewController()
      {
         super();
         var _loc1_:Array = ["ALL","DEBUG","INFO","WARN","ERROR","FATAL"];
         this.logLevels = new ArrayCollection(_loc1_);
         var _loc2_:TraceTarget = new TraceTarget();
         _loc2_.level = LogEventLevel.ALL;
         Log.addTarget(_loc2_);
         var _loc3_:MemoryTarget = new MemoryTarget();
         _loc3_.messageLimit = this.logMemoryBufferLimit;
         _loc3_.initialized(null,"memory");
         _loc3_.includeDate = true;
         _loc3_.includeTime = true;
         _loc3_.includeCategory = true;
         _loc3_.includeLevel = true;
         this.logMessages = _loc3_.messageBuffer;
         Log.addTarget(_loc3_);
      }
      
      private function setFilters() : void
      {
         this.logManager.logFilters = this.logFilters.toArray();
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function takeMemorySnapshot() : void
      {
         this.logManager.logMemorySnapshot();
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set logLevel(param1:String) : void
      {
         var _loc2_:Object = this._1995731616logLevel;
         if(_loc2_ !== param1)
         {
            this._1995731616logLevel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"logLevel",_loc2_,param1));
         }
      }
      
      public function initialize() : void
      {
         this.logLevel = "WARN";
         var _loc1_:String = "com.*, LolClient*, ChannelSet*";
         var _loc2_:Array = _loc1_.split(",");
         this.logFilters = new ArrayCollection(_loc2_);
      }
      
      private function filterMessage(param1:Object) : Boolean
      {
         if(this._searchString == null || this._searchString == "")
         {
            return true;
         }
         return this.regex.test(param1 as String);
      }
      
      [Bindable(event="propertyChange")]
      public function get logLevels() : ArrayCollection
      {
         return this._1738138067logLevels;
      }
      
      public function removeFilters(param1:Array) : void
      {
         var _loc2_:String = null;
         for each(_loc2_ in param1)
         {
            this.logFilters.removeItemAt(this.logFilters.getItemIndex(_loc2_));
         }
         this.setFilters();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get logFilters() : ArrayCollection
      {
         return this._1418339351logFilters;
      }
      
      [Bindable(event="propertyChange")]
      public function get logLevel() : String
      {
         return this._1995731616logLevel;
      }
      
      public function set logLevels(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1738138067logLevels;
         if(_loc2_ !== param1)
         {
            this._1738138067logLevels = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"logLevels",_loc2_,param1));
         }
      }
      
      public function set logMessages(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1277920432logMessages;
         if(_loc2_ !== param1)
         {
            this._1277920432logMessages = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"logMessages",_loc2_,param1));
         }
      }
      
      public function setLogLevel(param1:String) : void
      {
         if(param1 != null)
         {
            this.logManager.setLogLevelByString(param1);
         }
      }
      
      public function search(param1:String, param2:Boolean) : void
      {
         this._searchString = param1;
         if(!param2)
         {
            param1 = param1.replace(/\[/,"\\[");
            param1 = param1.replace(/\]/,"\\]");
         }
         this.regex = new RegExp(param1,"im");
         this.logMessages.refresh();
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function clearFilters() : void
      {
         this.logFilters.removeAll();
         this.setFilters();
      }
      
      public function addFilter(param1:String) : void
      {
         this.logFilters.addItem(param1);
         this.setFilters();
      }
      
      public function set logFilters(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1418339351logFilters;
         if(_loc2_ !== param1)
         {
            this._1418339351logFilters = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"logFilters",_loc2_,param1));
         }
      }
      
      public function clearLog() : void
      {
         this.logMessages.removeAll();
      }
      
      [Bindable(event="propertyChange")]
      public function get logMessages() : ArrayCollection
      {
         return this._1277920432logMessages;
      }
   }
}

