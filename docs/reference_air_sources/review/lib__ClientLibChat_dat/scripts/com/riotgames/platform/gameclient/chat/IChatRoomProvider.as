package com.riotgames.platform.gameclient.chat
{
   import blix.signals.ISignal;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   import mx.collections.ArrayCollection;
   
   public interface IChatRoomProvider
   {
      
      function getAllOccupantsInChatRooms() : ArrayCollection;
      
      function getChatCloseAllChatRoomsSignal() : ISignal;
      
      function requestChatRoom(param1:String, param2:String, param3:String, param4:String, param5:Function) : void;
      
      function obfuscateChatRoom(param1:String, param2:String) : String;
      
      function getChatCloseChatRoomSignal() : ISignal;
      
      function getChatCloseMatchmakingQueueChatRoomSignal() : ISignal;
      
      function inviteToChatRoom(param1:Array, param2:String, param3:String, param4:String, param5:Boolean) : void;
      
      function inviteSummonersToChatRoom(param1:Array, param2:String, param3:String, param4:String, param5:String, param6:Boolean) : void;
      
      function closeChatRoom(param1:ChatRoom) : void;
   }
}

