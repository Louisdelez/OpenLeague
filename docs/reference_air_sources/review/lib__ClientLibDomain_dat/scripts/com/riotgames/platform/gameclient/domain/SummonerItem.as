package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.SummonerItem")]
   public class SummonerItem implements IEventDispatcher
   {
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _950481995comp_id:SummonerItemPK;
      
      private var _1706464642correlation:int;
      
      private var _147115730usesRem:int;
      
      private var _3242771item:Item;
      
      public function SummonerItem()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get correlation() : int
      {
         return this._1706464642correlation;
      }
      
      public function set correlation(param1:int) : void
      {
         var _loc2_:Object = this._1706464642correlation;
         if(_loc2_ !== param1)
         {
            this._1706464642correlation = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"correlation",_loc2_,param1));
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get comp_id() : SummonerItemPK
      {
         return this._950481995comp_id;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get item() : Item
      {
         return this._3242771item;
      }
      
      public function set comp_id(param1:SummonerItemPK) : void
      {
         var _loc2_:Object = this._950481995comp_id;
         if(_loc2_ !== param1)
         {
            this._950481995comp_id = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"comp_id",_loc2_,param1));
         }
      }
      
      public function set usesRem(param1:int) : void
      {
         var _loc2_:Object = this._147115730usesRem;
         if(_loc2_ !== param1)
         {
            this._147115730usesRem = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"usesRem",_loc2_,param1));
         }
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
      public function get usesRem() : int
      {
         return this._147115730usesRem;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
   }
}

