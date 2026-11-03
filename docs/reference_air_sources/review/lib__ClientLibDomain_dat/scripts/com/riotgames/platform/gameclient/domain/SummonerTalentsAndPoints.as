package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.SummonerTalentsAndPoints")]
   public class SummonerTalentsAndPoints extends AbstractDomainObject implements IEventDispatcher
   {
      
      private var _1626892049talentPoints:Number;
      
      private var _830060173summonerAssociatedTalents:ArrayCollection;
      
      private var _80971529summonerId:Number;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function SummonerTalentsAndPoints()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerId() : Number
      {
         return this._80971529summonerId;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set summonerId(param1:Number) : void
      {
         var _loc2_:Object = this._80971529summonerId;
         if(_loc2_ !== param1)
         {
            this._80971529summonerId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerId",_loc2_,param1));
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set talentPoints(param1:Number) : void
      {
         var _loc2_:Object = this._1626892049talentPoints;
         if(_loc2_ !== param1)
         {
            this._1626892049talentPoints = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"talentPoints",_loc2_,param1));
         }
      }
      
      public function set summonerAssociatedTalents(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._830060173summonerAssociatedTalents;
         if(_loc2_ !== param1)
         {
            this._830060173summonerAssociatedTalents = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerAssociatedTalents",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get talentPoints() : Number
      {
         return this._1626892049talentPoints;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerAssociatedTalents() : ArrayCollection
      {
         return this._830060173summonerAssociatedTalents;
      }
   }
}

