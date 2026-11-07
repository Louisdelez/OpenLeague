package com.riotgames.platform.gameclient.domain.microfeedback
{
   import com.riotgames.platform.gameclient.notification.ClientNotificationType;
   import com.riotgames.platform.gameclient.notification.IClientNotification;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.microfeedback.service.message.SurveyDTO")]
   public class SurveyDTO implements IClientNotification, IEventDispatcher
   {
      
      private var _1529642573questionContent:String;
      
      private var _172106688questionType:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _585294753questionId:Number;
      
      public function SurveyDTO()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get questionType() : String
      {
         return this._172106688questionType;
      }
      
      public function set questionId(param1:Number) : void
      {
         var _loc2_:Object = this._585294753questionId;
         if(_loc2_ !== param1)
         {
            this._585294753questionId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"questionId",_loc2_,param1));
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function get notificationType() : String
      {
         return ClientNotificationType.MICROFEEDBACK_SURVEY;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set questionType(param1:String) : void
      {
         var _loc2_:Object = this._172106688questionType;
         if(_loc2_ !== param1)
         {
            this._172106688questionType = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"questionType",_loc2_,param1));
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get questionId() : Number
      {
         return this._585294753questionId;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function set questionContent(param1:String) : void
      {
         var _loc2_:Object = this._1529642573questionContent;
         if(_loc2_ !== param1)
         {
            this._1529642573questionContent = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"questionContent",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get questionContent() : String
      {
         return this._1529642573questionContent;
      }
   }
}

