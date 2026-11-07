package com.riotgames.platform.gameclient.notification
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.net.registerClassAlias;
   import mx.events.PropertyChangeEvent;
   import mx.managers.ISystemManager;
   
   [Mixin]
   [RemoteClass(alias="com.riotgames.platform.serviceproxy.dispatch.LcdsServiceProxyResponse")]
   public class LcdsServiceProxyResponse implements IEventDispatcher
   {
      
      private var _723163380methodName:String;
      
      private var _messageId:String;
      
      private var _892481550status:String;
      
      private var _1928572192serviceName:String;
      
      private var _786701938payload:Object;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function LcdsServiceProxyResponse()
      {
         super();
      }
      
      public static function init(param1:ISystemManager) : void
      {
         registerClassAlias("com.riotgames.platform.serviceproxy.dispatch.LcdsServiceProxyResponse",LcdsServiceProxyResponse);
      }
      
      public function set serviceName(param1:String) : void
      {
         var _loc2_:Object = this._1928572192serviceName;
         if(_loc2_ !== param1)
         {
            this._1928572192serviceName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"serviceName",_loc2_,param1));
         }
      }
      
      public function get messageId() : String
      {
         return this._messageId;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function set messageId(param1:String) : void
      {
         var _loc2_:Object = this.messageId;
         if(_loc2_ !== param1)
         {
            this._1440013438messageId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"messageId",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get methodName() : String
      {
         return this._723163380methodName;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get payload() : Object
      {
         return this._786701938payload;
      }
      
      public function set methodName(param1:String) : void
      {
         var _loc2_:Object = this._723163380methodName;
         if(_loc2_ !== param1)
         {
            this._723163380methodName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"methodName",_loc2_,param1));
         }
      }
      
      public function set payload(param1:Object) : void
      {
         var _loc2_:Object = this._786701938payload;
         if(_loc2_ !== param1)
         {
            this._786701938payload = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"payload",_loc2_,param1));
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get serviceName() : String
      {
         return this._1928572192serviceName;
      }
      
      public function set status(param1:String) : void
      {
         var _loc2_:Object = this._892481550status;
         if(_loc2_ !== param1)
         {
            this._892481550status = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"status",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get status() : String
      {
         return this._892481550status;
      }
      
      private function set _1440013438messageId(param1:String) : void
      {
         this._messageId = param1;
      }
   }
}

