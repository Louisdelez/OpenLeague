package com.riotgames.platform.gameclient.chat.event
{
   import flash.events.Event;
   import org.igniterealtime.xiff.data.Message;
   
   public class PlayerRoomEvent extends Event
   {
      
      public static const HIDDEN_MESSAGE:String = "hiddenMessage";
      
      public var message:Message;
      
      public function PlayerRoomEvent(param1:Message = null)
      {
         super(HIDDEN_MESSAGE,false,false);
         this.message = param1;
      }
      
      override public function clone() : Event
      {
         return new PlayerRoomEvent(this.message);
      }
   }
}

