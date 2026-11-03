package com.riotgames.platform.gameclient.error
{
   import flash.events.Event;
   
   public class MailError
   {
      
      private var _smtpResponseMessage:String;
      
      private var _smtpResponseCode:int;
      
      private var _relatedEvent:Event;
      
      public function MailError(param1:int, param2:String, param3:Event)
      {
         super();
         this._smtpResponseCode = param1;
         this._smtpResponseMessage = param2;
         this._relatedEvent = param3;
      }
      
      public function get smtpResponseMessage() : String
      {
         return this._smtpResponseMessage;
      }
      
      public function get smtpResponseCode() : int
      {
         return this._smtpResponseCode;
      }
      
      public function toString() : String
      {
         if(this.smtpResponseCode == 0)
         {
            return this.relatedEvent.toString();
         }
         return "Result code: " + this.smtpResponseCode + " message: " + this.smtpResponseMessage;
      }
      
      public function get relatedEvent() : Event
      {
         return this._relatedEvent;
      }
   }
}

