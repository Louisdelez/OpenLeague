package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.HairColor")]
   public class HairColor implements IEventDispatcher
   {
      
      private var _3373707name:String;
      
      private var _284741986hairClrId:int;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _111972721value:String;
      
      public function HairColor()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get hairClrId() : int
      {
         return this._284741986hairClrId;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set hairClrId(param1:int) : void
      {
         var _loc2_:Object = this._284741986hairClrId;
         if(_loc2_ !== param1)
         {
            this._284741986hairClrId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hairClrId",_loc2_,param1));
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
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
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
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
   }
}

