package com.riotgames.platform.gameclient.domain.binge
{
   import com.riotgames.platform.gameclient.notification.ClientNotificationType;
   import com.riotgames.platform.gameclient.notification.IClientNotification;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.binge.server.BingePreventionNotification")]
   public class BingePreventionNotification implements IClientNotification, IEventDispatcher
   {
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _954925063message:String;
      
      private var _1951932516preventPlayForXMinutes:Number;
      
      private var _601235430currentTime:Number;
      
      private var _1905218437totalPlayTime:Number;
      
      private var _31415431eventTime:Number;
      
      private var _933009914blockPlayerInXMinutes:Number;
      
      public function BingePreventionNotification()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get blockPlayerInXMinutes() : Number
      {
         return this._933009914blockPlayerInXMinutes;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function get notificationType() : String
      {
         return ClientNotificationType.BINGE_PREVENTION;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get eventTime() : Number
      {
         return this._31415431eventTime;
      }
      
      public function set preventPlayForXMinutes(param1:Number) : void
      {
         var _loc2_:Object = this._1951932516preventPlayForXMinutes;
         if(_loc2_ !== param1)
         {
            this._1951932516preventPlayForXMinutes = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"preventPlayForXMinutes",_loc2_,param1));
         }
      }
      
      public function set totalPlayTime(param1:Number) : void
      {
         var _loc2_:Object = this._1905218437totalPlayTime;
         if(_loc2_ !== param1)
         {
            this._1905218437totalPlayTime = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"totalPlayTime",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set eventTime(param1:Number) : void
      {
         var _loc2_:Object = this._31415431eventTime;
         if(_loc2_ !== param1)
         {
            this._31415431eventTime = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"eventTime",_loc2_,param1));
         }
      }
      
      public function set currentTime(param1:Number) : void
      {
         var _loc2_:Object = this._601235430currentTime;
         if(_loc2_ !== param1)
         {
            this._601235430currentTime = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentTime",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get totalPlayTime() : Number
      {
         return this._1905218437totalPlayTime;
      }
      
      public function set message(param1:String) : void
      {
         var _loc2_:Object = this._954925063message;
         if(_loc2_ !== param1)
         {
            this._954925063message = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"message",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get message() : String
      {
         return this._954925063message;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get preventPlayForXMinutes() : Number
      {
         return this._1951932516preventPlayForXMinutes;
      }
      
      [Bindable(event="propertyChange")]
      public function get currentTime() : Number
      {
         return this._601235430currentTime;
      }
      
      public function set blockPlayerInXMinutes(param1:Number) : void
      {
         var _loc2_:Object = this._933009914blockPlayerInXMinutes;
         if(_loc2_ !== param1)
         {
            this._933009914blockPlayerInXMinutes = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"blockPlayerInXMinutes",_loc2_,param1));
         }
      }
   }
}

