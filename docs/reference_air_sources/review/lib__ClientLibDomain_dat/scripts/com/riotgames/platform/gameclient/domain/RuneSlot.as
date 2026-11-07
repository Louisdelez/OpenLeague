package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.RuneSlot")]
   public class RuneSlot extends AbstractDomainObject implements IEventDispatcher
   {
      
      public static const DATA_FORMAT:String = "RuneSlot";
      
      private var _1386076078minLevel:int;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _3355id:int;
      
      private var _820735380runeType:RuneType;
      
      public function RuneSlot()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get runeType() : RuneType
      {
         return this._820735380runeType;
      }
      
      public function set minLevel(param1:int) : void
      {
         var _loc2_:Object = this._1386076078minLevel;
         if(_loc2_ !== param1)
         {
            this._1386076078minLevel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"minLevel",_loc2_,param1));
         }
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
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get minLevel() : int
      {
         return this._1386076078minLevel;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set id(param1:int) : void
      {
         var _loc2_:Object = this._3355id;
         if(_loc2_ !== param1)
         {
            this._3355id = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"id",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get id() : int
      {
         return this._3355id;
      }
   }
}

