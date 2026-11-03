package com.riotgames.platform.gameclient.domain.store
{
   import com.riotgames.platform.gameclient.notification.ClientNotificationType;
   import com.riotgames.platform.gameclient.notification.IClientNotification;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.messaging.StoreAccountBalanceNotification")]
   public class StoreAccountBalanceNotification implements IClientNotification, IEventDispatcher
   {
      
      private var _3646rp:Number;
      
      private var _3367ip:Number;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function StoreAccountBalanceNotification()
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
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get ip() : Number
      {
         return this._3367ip;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function get notificationType() : String
      {
         return ClientNotificationType.ACCOUNT_BALANCE;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set ip(param1:Number) : void
      {
         var _loc2_:Object = this._3367ip;
         if(_loc2_ !== param1)
         {
            this._3367ip = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ip",_loc2_,param1));
         }
      }
      
      public function set rp(param1:Number) : void
      {
         var _loc2_:Object = this._3646rp;
         if(_loc2_ !== param1)
         {
            this._3646rp = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rp",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rp() : Number
      {
         return this._3646rp;
      }
   }
}

