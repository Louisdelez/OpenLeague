package com.riotgames.platform.gameclient.domain.summoner.customization
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.customization.SummonerNameChangeDTO")]
   public class SummonerNameChangeDTO implements SummonerCustomizationDTO, IEventDispatcher
   {
      
      private var _1845020747newName:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function SummonerNameChangeDTO()
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
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get newName() : String
      {
         return this._1845020747newName;
      }
      
      public function toString() : String
      {
         return "newName=" + this.newName;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set newName(param1:String) : void
      {
         var _loc2_:Object = this._1845020747newName;
         if(_loc2_ !== param1)
         {
            this._1845020747newName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"newName",_loc2_,param1));
         }
      }
      
      public function getCustomizationType() : String
      {
         return SummonerCustomizationType.NAME_CHANGE;
      }
   }
}

