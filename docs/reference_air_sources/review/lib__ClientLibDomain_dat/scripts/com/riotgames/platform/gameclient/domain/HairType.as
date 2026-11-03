package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.HairType")]
   public class HairType implements IEventDispatcher
   {
      
      private var _3373707name:String;
      
      private var _735734903hairTypeId:int;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _111972721value:String;
      
      public function HairType()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function set value(param1:String) : void
      {
         var _loc2_:Object = this._111972721value;
         if(_loc2_ !== param1)
         {
            this._111972721value = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"value",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get name() : String
      {
         return this._3373707name;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set hairTypeId(param1:int) : void
      {
         var _loc2_:Object = this._735734903hairTypeId;
         if(_loc2_ !== param1)
         {
            this._735734903hairTypeId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hairTypeId",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get value() : String
      {
         return this._111972721value;
      }
      
      public function set name(param1:String) : void
      {
         var _loc2_:Object = this._3373707name;
         if(_loc2_ !== param1)
         {
            this._3373707name = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"name",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get hairTypeId() : int
      {
         return this._735734903hairTypeId;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
   }
}

