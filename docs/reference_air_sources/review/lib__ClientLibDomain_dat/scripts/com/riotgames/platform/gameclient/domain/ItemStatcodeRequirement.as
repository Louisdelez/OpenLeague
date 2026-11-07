package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.catalog.ItemStatcodeRequirement")]
   public class ItemStatcodeRequirement implements IEventDispatcher
   {
      
      private var _934835885aggregatedStatType:AggregatedStatType;
      
      private var _950481995comp_id:ItemStatcodeRequirementPK;
      
      private var _1376969153minValue:Number;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function ItemStatcodeRequirement()
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
      
      public function set aggregatedStatType(param1:AggregatedStatType) : void
      {
         var _loc2_:Object = this._934835885aggregatedStatType;
         if(_loc2_ !== param1)
         {
            this._934835885aggregatedStatType = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"aggregatedStatType",_loc2_,param1));
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get comp_id() : ItemStatcodeRequirementPK
      {
         return this._950481995comp_id;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set comp_id(param1:ItemStatcodeRequirementPK) : void
      {
         var _loc2_:Object = this._950481995comp_id;
         if(_loc2_ !== param1)
         {
            this._950481995comp_id = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"comp_id",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get aggregatedStatType() : AggregatedStatType
      {
         return this._934835885aggregatedStatType;
      }
      
      public function set minValue(param1:Number) : void
      {
         var _loc2_:Object = this._1376969153minValue;
         if(_loc2_ !== param1)
         {
            this._1376969153minValue = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"minValue",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get minValue() : Number
      {
         return this._1376969153minValue;
      }
   }
}

