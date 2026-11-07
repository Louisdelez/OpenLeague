package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.catalog.Effect")]
   public class Effect implements IEventDispatcher
   {
      
      private var _1769659137gameCode:String;
      
      private var _3373707name:String;
      
      private var _1017208180effectId:int;
      
      private var _1724546052description:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _820735380runeType:RuneType;
      
      public function Effect()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function set gameCode(param1:String) : void
      {
         var _loc2_:Object = this._1769659137gameCode;
         if(_loc2_ !== param1)
         {
            this._1769659137gameCode = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameCode",_loc2_,param1));
         }
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
      public function get name() : String
      {
         return this._3373707name;
      }
      
      [Bindable(event="propertyChange")]
      public function get effectId() : int
      {
         return this._1017208180effectId;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
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
      
      public function set effectId(param1:int) : void
      {
         var _loc2_:Object = this._1017208180effectId;
         if(_loc2_ !== param1)
         {
            this._1017208180effectId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"effectId",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get runeType() : RuneType
      {
         return this._820735380runeType;
      }
      
      public function set runeType(param1:RuneType) : void
      {
         var _loc2_:Object = this._820735380runeType;
         if(_loc2_ !== param1)
         {
            this._820735380runeType = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"runeType",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set description(param1:String) : void
      {
         var _loc2_:Object = this._1724546052description;
         if(_loc2_ !== param1)
         {
            this._1724546052description = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"description",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get description() : String
      {
         return this._1724546052description;
      }
      
      [Bindable(event="propertyChange")]
      public function get gameCode() : String
      {
         return this._1769659137gameCode;
      }
   }
}

