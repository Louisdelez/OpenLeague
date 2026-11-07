package com.riotgames.platform.gameclient.domain.microfeedback
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.microfeedback.service.message.SurveyResponseDTO")]
   public class SurveyResponseDTO implements IEventDispatcher
   {
      
      private var _340323263response:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _585294753questionId:Number;
      
      public function SurveyResponseDTO()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get response() : String
      {
         return this._340323263response;
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
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get questionId() : Number
      {
         return this._585294753questionId;
      }
      
      public function set response(param1:String) : void
      {
         var _loc2_:Object = this._340323263response;
         if(_loc2_ !== param1)
         {
            this._340323263response = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"response",_loc2_,param1));
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
   }
}

