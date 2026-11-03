package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.ItemSetItem")]
   public class ItemSetItem implements IEventDispatcher
   {
      
      private var _109327645setId:int;
      
      private var _3242771item:Item;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function ItemSetItem()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
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
      
      [Bindable(event="propertyChange")]
      public function get item() : Item
      {
         return this._3242771item;
      }
      
      public function set setId(param1:int) : void
      {
         var _loc2_:Object = this._109327645setId;
         if(_loc2_ !== param1)
         {
            this._109327645setId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"setId",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get setId() : int
      {
         return this._109327645setId;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
   }
}

