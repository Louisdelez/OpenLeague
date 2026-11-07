package com.riotgames.platform.gameclient.domain.game
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.game.message.GameNotification")]
   public class GameNotification implements IEventDispatcher
   {
      
      private var _3575610type:String;
      
      private var _873609580messageCode:String;
      
      private var _790377500messageArgument:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function GameNotification()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get type() : String
      {
         return this._3575610type;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set messageArgument(param1:String) : void
      {
         var _loc2_:Object = this._790377500messageArgument;
         if(_loc2_ !== param1)
         {
            this._790377500messageArgument = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"messageArgument",_loc2_,param1));
         }
      }
      
      public function set type(param1:String) : void
      {
         var _loc2_:Object = this._3575610type;
         if(_loc2_ !== param1)
         {
            this._3575610type = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"type",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function get messageCode() : String
      {
         return this._873609580messageCode;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get messageArgument() : String
      {
         return this._790377500messageArgument;
      }
      
      public function set messageCode(param1:String) : void
      {
         var _loc2_:Object = this._873609580messageCode;
         if(_loc2_ !== param1)
         {
            this._873609580messageCode = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"messageCode",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
   }
}

