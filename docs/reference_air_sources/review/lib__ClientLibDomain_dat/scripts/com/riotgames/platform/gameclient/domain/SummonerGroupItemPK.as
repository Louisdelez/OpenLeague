package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.SummonerGroupItemPK")]
   public class SummonerGroupItemPK implements IEventDispatcher
   {
      
      private var _1086740055slotName:String;
      
      private var _98628832grpId:Number;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _1178662002itemId:int;
      
      public function SummonerGroupItemPK()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get grpId() : Number
      {
         return this._98628832grpId;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get slotName() : String
      {
         return this._1086740055slotName;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set grpId(param1:Number) : void
      {
         var _loc2_:Object = this._98628832grpId;
         if(_loc2_ !== param1)
         {
            this._98628832grpId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"grpId",_loc2_,param1));
         }
      }
      
      public function set slotName(param1:String) : void
      {
         var _loc2_:Object = this._1086740055slotName;
         if(_loc2_ !== param1)
         {
            this._1086740055slotName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"slotName",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get itemId() : int
      {
         return this._1178662002itemId;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function set itemId(param1:int) : void
      {
         var _loc2_:Object = this._1178662002itemId;
         if(_loc2_ !== param1)
         {
            this._1178662002itemId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"itemId",_loc2_,param1));
         }
      }
   }
}

