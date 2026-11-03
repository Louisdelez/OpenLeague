package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.icon.SummonerIconInventoryDTO")]
   public class SummonerIconInventoryDTO extends AbstractDomainObject implements IEventDispatcher
   {
      
      private var _1548719508summonerIcons:ArrayCollection;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function SummonerIconInventoryDTO()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerIcons() : ArrayCollection
      {
         return this._1548719508summonerIcons;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set summonerIcons(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1548719508summonerIcons;
         if(_loc2_ !== param1)
         {
            this._1548719508summonerIcons = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerIcons",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
   }
}

