package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.SummonerLevelAndPoints")]
   public class SummonerLevelAndPoints extends AbstractDomainObject implements IEventDispatcher
   {
      
      private var _468186784expPoints:Number;
      
      private var _1545882922summonerLevel:Number;
      
      private var _358593572infPoints:Number;
      
      private var _109797574sumId:Number;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function SummonerLevelAndPoints()
      {
         super();
      }
      
      public function set expPoints(param1:Number) : void
      {
         var _loc2_:Object = this._468186784expPoints;
         if(_loc2_ !== param1)
         {
            this._468186784expPoints = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"expPoints",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get sumId() : Number
      {
         return this._109797574sumId;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function set infPoints(param1:Number) : void
      {
         var _loc2_:Object = this._358593572infPoints;
         if(_loc2_ !== param1)
         {
            this._358593572infPoints = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"infPoints",_loc2_,param1));
         }
      }
      
      public function set sumId(param1:Number) : void
      {
         var _loc2_:Object = this._109797574sumId;
         if(_loc2_ !== param1)
         {
            this._109797574sumId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sumId",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerLevel() : Number
      {
         return this._1545882922summonerLevel;
      }
      
      [Bindable(event="propertyChange")]
      public function get expPoints() : Number
      {
         return this._468186784expPoints;
      }
      
      [Bindable(event="propertyChange")]
      public function get infPoints() : Number
      {
         return this._358593572infPoints;
      }
      
      public function set summonerLevel(param1:Number) : void
      {
         var _loc2_:Object = this._1545882922summonerLevel;
         if(_loc2_ !== param1)
         {
            this._1545882922summonerLevel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerLevel",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
   }
}

