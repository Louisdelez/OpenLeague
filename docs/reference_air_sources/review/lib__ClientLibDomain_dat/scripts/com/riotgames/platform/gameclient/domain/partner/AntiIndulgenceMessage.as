package com.riotgames.platform.gameclient.domain.partner
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class AntiIndulgenceMessage implements IEventDispatcher
   {
      
      public static const REGISTRATION_MESSAGE:String = "AAS-REG";
      
      private var _1690741544messageKey:String;
      
      private var _3575610type:String;
      
      private var _790377500messageArgument:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function AntiIndulgenceMessage(param1:String, param2:String, param3:String)
      {
         super();
         this.type = param1;
         this.messageKey = param2;
         this.messageArgument = param3;
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
      
      public function get isRegistrationMessage() : Boolean
      {
         return this.messageKey == AntiIndulgenceMessage.REGISTRATION_MESSAGE;
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
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
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
      
      [Bindable(event="propertyChange")]
      public function get messageKey() : String
      {
         return this._1690741544messageKey;
      }
      
      [Bindable(event="propertyChange")]
      public function get messageArgument() : String
      {
         return this._790377500messageArgument;
      }
      
      public function set messageKey(param1:String) : void
      {
         var _loc2_:Object = this._1690741544messageKey;
         if(_loc2_ !== param1)
         {
            this._1690741544messageKey = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"messageKey",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
   }
}

