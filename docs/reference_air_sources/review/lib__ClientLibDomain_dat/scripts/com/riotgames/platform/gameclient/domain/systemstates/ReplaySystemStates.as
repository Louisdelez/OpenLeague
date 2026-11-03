package com.riotgames.platform.gameclient.domain.systemstates
{
   import com.riotgames.platform.gameclient.domain.AbstractDomainObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.systemstate.ReplaySystemStates")]
   public class ReplaySystemStates extends AbstractDomainObject implements IEventDispatcher
   {
      
      private var _backpatchingEnabled:Boolean;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _versionManagerEnabled:Boolean;
      
      private var _endOfGameEnabled:Boolean;
      
      private var _1226709830replayServiceAddress:String;
      
      private var _getReplaysTabEnabled:Boolean;
      
      private var _replayServiceEnabled:Boolean;
      
      private var _2021013996installExactVersion:Boolean;
      
      private var _matchHistoryEnabled:Boolean;
      
      public function ReplaySystemStates()
      {
         super();
      }
      
      public function get backpatchingEnabled() : Boolean
      {
         return this._backpatchingEnabled && this._replayServiceEnabled;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function set getReplaysTabEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this.getReplaysTabEnabled;
         if(_loc2_ !== param1)
         {
            this._640621630getReplaysTabEnabled = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"getReplaysTabEnabled",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get replayServiceAddress() : String
      {
         return this._1226709830replayServiceAddress;
      }
      
      [Bindable(event="propertyChange")]
      public function set backpatchingEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this.backpatchingEnabled;
         if(_loc2_ !== param1)
         {
            this._711762048backpatchingEnabled = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"backpatchingEnabled",_loc2_,param1));
         }
      }
      
      public function get versionManagerEnabled() : Boolean
      {
         return this._versionManagerEnabled && this._replayServiceEnabled;
      }
      
      private function set _764807827replayServiceEnabled(param1:Boolean) : void
      {
         this._replayServiceEnabled = param1;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function get getReplaysTabEnabled() : Boolean
      {
         return this._getReplaysTabEnabled && this._replayServiceEnabled;
      }
      
      [Bindable(event="propertyChange")]
      public function set endOfGameEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this.endOfGameEnabled;
         if(_loc2_ !== param1)
         {
            this._2083611517endOfGameEnabled = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"endOfGameEnabled",_loc2_,param1));
         }
      }
      
      public function get replayServiceEnabled() : Boolean
      {
         return this._replayServiceEnabled;
      }
      
      [Bindable(event="propertyChange")]
      public function get installExactVersion() : Boolean
      {
         return this._2021013996installExactVersion;
      }
      
      private function set _711762048backpatchingEnabled(param1:Boolean) : void
      {
         this._backpatchingEnabled = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function set versionManagerEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this.versionManagerEnabled;
         if(_loc2_ !== param1)
         {
            this._1419242036versionManagerEnabled = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"versionManagerEnabled",_loc2_,param1));
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function set replayServiceAddress(param1:String) : void
      {
         var _loc2_:Object = this._1226709830replayServiceAddress;
         if(_loc2_ !== param1)
         {
            this._1226709830replayServiceAddress = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"replayServiceAddress",_loc2_,param1));
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function set matchHistoryEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this.matchHistoryEnabled;
         if(_loc2_ !== param1)
         {
            this._1410639566matchHistoryEnabled = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"matchHistoryEnabled",_loc2_,param1));
         }
      }
      
      private function set _640621630getReplaysTabEnabled(param1:Boolean) : void
      {
         this._getReplaysTabEnabled = param1;
      }
      
      public function set installExactVersion(param1:Boolean) : void
      {
         var _loc2_:Object = this._2021013996installExactVersion;
         if(_loc2_ !== param1)
         {
            this._2021013996installExactVersion = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"installExactVersion",_loc2_,param1));
         }
      }
      
      private function set _1410639566matchHistoryEnabled(param1:Boolean) : void
      {
         this._matchHistoryEnabled = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function set replayServiceEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this.replayServiceEnabled;
         if(_loc2_ !== param1)
         {
            this._764807827replayServiceEnabled = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"replayServiceEnabled",_loc2_,param1));
         }
      }
      
      public function get matchHistoryEnabled() : Boolean
      {
         return this._matchHistoryEnabled && this._replayServiceEnabled;
      }
      
      private function set _2083611517endOfGameEnabled(param1:Boolean) : void
      {
         this._endOfGameEnabled = param1;
      }
      
      public function get endOfGameEnabled() : Boolean
      {
         return this._endOfGameEnabled && this._replayServiceEnabled;
      }
      
      private function set _1419242036versionManagerEnabled(param1:Boolean) : void
      {
         this._versionManagerEnabled = param1;
      }
   }
}

