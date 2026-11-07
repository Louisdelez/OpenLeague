package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.game.GameZone")]
   public class GameZone implements IEventDispatcher
   {
      
      private var _1003362399gameZonePort:int;
      
      private var _1003124102gameZoneHost:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function GameZone()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get gameZoneHost() : String
      {
         return this._1003124102gameZoneHost;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function set gameZoneHost(param1:String) : void
      {
         var _loc2_:Object = this._1003124102gameZoneHost;
         if(_loc2_ !== param1)
         {
            this._1003124102gameZoneHost = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameZoneHost",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function toString() : String
      {
         return "GameZone\n\r" + "gameZoneHost: " + this.gameZoneHost + "\n\rgameZonePort: " + this.gameZonePort;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set gameZonePort(param1:int) : void
      {
         var _loc2_:Object = this._1003362399gameZonePort;
         if(_loc2_ !== param1)
         {
            this._1003362399gameZonePort = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameZonePort",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gameZonePort() : int
      {
         return this._1003362399gameZonePort;
      }
   }
}

