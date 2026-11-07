package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.catalog.ItemEffect")]
   public class ItemEffect extends AbstractDomainObject implements IEventDispatcher
   {
      
      private var _1714148973displayName:String;
      
      private var _1577207377effectCategory:int;
      
      private var _name:String;
      
      private var _1715833963effectType:int;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _111972721value:Number;
      
      public function ItemEffect()
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
      
      public function get name() : String
      {
         return this._name;
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
      public function set name(param1:String) : void
      {
         var _loc2_:Object = this.name;
         if(_loc2_ !== param1)
         {
            this._3373707name = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"name",_loc2_,param1));
         }
      }
      
      public function set displayName(param1:String) : void
      {
         var _loc2_:Object = this._1714148973displayName;
         if(_loc2_ !== param1)
         {
            this._1714148973displayName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"displayName",_loc2_,param1));
         }
      }
      
      private function set _3373707name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function set effectType(param1:int) : void
      {
         var _loc2_:Object = this._1715833963effectType;
         if(_loc2_ !== param1)
         {
            this._1715833963effectType = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"effectType",_loc2_,param1));
         }
      }
      
      public function set effectCategory(param1:int) : void
      {
         var _loc2_:Object = this._1577207377effectCategory;
         if(_loc2_ !== param1)
         {
            this._1577207377effectCategory = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"effectCategory",_loc2_,param1));
         }
      }
      
      public function set value(param1:Number) : void
      {
         var _loc2_:Object = this._111972721value;
         if(_loc2_ !== param1)
         {
            this._111972721value = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"value",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get effectType() : int
      {
         return this._1715833963effectType;
      }
      
      [Bindable(event="propertyChange")]
      public function get displayName() : String
      {
         return this._1714148973displayName;
      }
      
      [Bindable(event="propertyChange")]
      public function get effectCategory() : int
      {
         return this._1577207377effectCategory;
      }
      
      [Bindable(event="propertyChange")]
      public function get value() : Number
      {
         return this._111972721value;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
   }
}

