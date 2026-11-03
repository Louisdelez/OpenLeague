package com.riotgames.platform.gameclient.chat.event
{
   import flash.events.Event;
   
   public class ChatEvent extends Event
   {
      
      public static const MESSAGE_RECEIVED:String = "newMessageReceived";
      
      public static const PARTICIPANT_JOINED:String = "participantJoined";
      
      public static const PARTICIPANT_LEFT:String = "participantLeft";
      
      public static const PERSONAL_MESSAGE_RECEIVED:String = "personalMessageReceived";
      
      private var _messageItems:Object;
      
      public function ChatEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._messageItems = param2;
      }
      
      public function get messageItems() : Object
      {
         return this._messageItems;
      }
      
      override public function clone() : Event
      {
         return new ChatEvent(type,this.messageItems,bubbles,cancelable);
      }
   }
}

