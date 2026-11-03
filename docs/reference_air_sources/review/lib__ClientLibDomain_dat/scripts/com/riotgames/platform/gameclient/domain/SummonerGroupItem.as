package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.SummonerGroupItem")]
   public class SummonerGroupItem implements IEventDispatcher
   {
      
      private var _1086740055slotName:String;
      
      private var _3242771item:Item;
      
      private var _950481995comp_id:SummonerGroupItemPK;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function SummonerGroupItem()
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
      
      public function set item(param1:Item) : void
      {
         var _loc2_:Object = this._3242771item;
         if(_loc2_ !== param1)
         {
            this._3242771item = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"item",_loc2_,param1));
         }
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
      
      [Bindable(event="propertyChange")]
      public function get comp_id() : SummonerGroupItemPK
      {
         return this._950481995comp_id;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
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
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set comp_id(param1:SummonerGroupItemPK) : void
      {
         var _loc2_:Object = this._950481995comp_id;
         if(_loc2_ !== param1)
         {
            this._950481995comp_id = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"comp_id",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get item() : Item
      {
         return this._3242771item;
      }
   }
}

