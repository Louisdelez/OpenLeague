package com.riotgames.platform.common.event
{
   import flash.events.Event;
   
   public class GameChatEvent extends Event
   {
      
      public static const CHAT_EVENT_FROM_GAME:String = "gameChatEvent";
      
      public var chatMessage:String;
      
      public function GameChatEvent(param1:String)
      {
         this.chatMessage = param1;
         super(CHAT_EVENT_FROM_GAME,false,false);
      }
   }
}

