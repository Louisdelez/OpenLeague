package com.riotgames.platform.gameclient.chat.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class ChatPersonalMessageVO implements IEventDispatcher
   {
      
      private var _266888683userFrom:String;
      
      protected var _message:String;
      
      private var _836030554userTo:String;
      
      protected var _timeStamp:Date;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function ChatPersonalMessageVO(param1:String, param2:String, param3:String)
      {
         super();
         this.userFrom = param1;
         this.userTo = param2;
         this.message = param3;
      }
      
      public static function removeHTMLTags(param1:String) : String
      {
         var _loc2_:RegExp = /</g;
         return param1.replace(_loc2_,"&lt;");
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function get message() : String
      {
         return this._message;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function set userTo(param1:String) : void
      {
         var _loc2_:Object = this._836030554userTo;
         if(_loc2_ !== param1)
         {
            this._836030554userTo = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"userTo",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function set message(param1:String) : void
      {
         var _loc2_:Object = this.message;
         if(_loc2_ !== param1)
         {
            this._954925063message = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"message",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get userFrom() : String
      {
         return this._266888683userFrom;
      }
      
      [Bindable(event="propertyChange")]
      public function get userTo() : String
      {
         return this._836030554userTo;
      }
      
      public function set userFrom(param1:String) : void
      {
         var _loc2_:Object = this._266888683userFrom;
         if(_loc2_ !== param1)
         {
            this._266888683userFrom = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"userFrom",_loc2_,param1));
         }
      }
      
      public function toString() : String
      {
         return this.userFrom + ": " + this.message;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      private function set _954925063message(param1:String) : void
      {
         this._message = removeHTMLTags(param1);
         this._timeStamp = new Date();
      }
      
      public function get timeStamp() : Date
      {
         return this._timeStamp;
      }
   }
}

