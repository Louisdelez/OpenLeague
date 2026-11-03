package com.riotgames.platform.gameclient.chat.mediator
{
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   
   public interface IGroupChatHandler
   {
      
      function hasRoom(param1:String) : Boolean;
      
      function handleChatSpamError(param1:String) : void;
      
      function closeChatRoom(param1:ChatRoom) : void;
      
      function inviteToChat(param1:String, param2:Array, param3:String, param4:String) : void;
      
      function openChatRoom(param1:ChatRoom) : void;
      
      function closeAllRooms() : void;
   }
}

