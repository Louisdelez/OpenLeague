package com.riotgames.platform.gameclient.domain.celebration
{
   import com.riotgames.platform.gameclient.notification.ClientNotificationType;
   import com.riotgames.platform.gameclient.notification.IClientNotification;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.messaging.persistence.SimpleDialogMessage")]
   public class SimpleDialogMessage implements IClientNotification, IEventDispatcher
   {
      
      private var _995427962params:ArrayCollection;
      
      private var _3575610type:String;
      
      private var _1702148783bodyCode:String;
      
      private var _1827029976accountId:Number;
      
      private var _2136254363titleCode:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _104191100msgId:String;
      
      public function SimpleDialogMessage()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get msgId() : String
      {
         return this._104191100msgId;
      }
      
      public function get notificationType() : String
      {
         return ClientNotificationType.SIMPLE_DIALOG;
      }
      
      [Bindable(event="propertyChange")]
      public function get params() : ArrayCollection
      {
         return this._995427962params;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set titleCode(param1:String) : void
      {
         var _loc2_:Object = this._2136254363titleCode;
         if(_loc2_ !== param1)
         {
            this._2136254363titleCode = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"titleCode",_loc2_,param1));
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set accountId(param1:Number) : void
      {
         var _loc2_:Object = this._1827029976accountId;
         if(_loc2_ !== param1)
         {
            this._1827029976accountId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"accountId",_loc2_,param1));
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function set params(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._995427962params;
         if(_loc2_ !== param1)
         {
            this._995427962params = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"params",_loc2_,param1));
         }
      }
      
      public function set bodyCode(param1:String) : void
      {
         var _loc2_:Object = this._1702148783bodyCode;
         if(_loc2_ !== param1)
         {
            this._1702148783bodyCode = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bodyCode",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get accountId() : Number
      {
         return this._1827029976accountId;
      }
      
      [Bindable(event="propertyChange")]
      public function get titleCode() : String
      {
         return this._2136254363titleCode;
      }
      
      [Bindable(event="propertyChange")]
      public function get bodyCode() : String
      {
         return this._1702148783bodyCode;
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
      
      public function set msgId(param1:String) : void
      {
         var _loc2_:Object = this._104191100msgId;
         if(_loc2_ !== param1)
         {
            this._104191100msgId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"msgId",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get type() : String
      {
         return this._3575610type;
      }
   }
}

