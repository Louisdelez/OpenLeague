package com.riotgames.platform.gameclient.chat
{
   import blix.signals.ISignal;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   import com.riotgames.platform.provider.proxy.ProviderProxyNoop;
   import mx.collections.ArrayCollection;
   
   public class ChatRoomProviderProxy extends ProviderProxyNoop implements IChatRoomProvider
   {
      
      private static var _instance:IChatRoomProvider;
      
      public function ChatRoomProviderProxy()
      {
         super(IChatRoomProvider);
      }
      
      public static function get instance() : IChatRoomProvider
      {
         if(_instance == null)
         {
            _instance = new ChatRoomProviderProxy();
         }
         return _instance;
      }
      
      §§namespace("http://www.riotgames.com/pvpnet/internal") static function setInstance(param1:IChatRoomProvider) : void
      {
         _instance = param1;
      }
      
      public function requestChatRoom(param1:String, param2:String, param3:String, param4:String, param5:Function) : void
      {
         _invoke("requestChatRoom",[param1,param2,param3,param4,param5]);
      }
      
      public function getChatCloseChatRoomSignal() : ISignal
      {
         return _getSignal("getChatCloseChatRoomSignal");
      }
      
      public function getChatCloseMatchmakingQueueChatRoomSignal() : ISignal
      {
         return _getSignal("getChatCloseMatchmakingQueueChatRoomSignal");
      }
      
      public function inviteSummonersToChatRoom(param1:Array, param2:String, param3:String, param4:String, param5:String, param6:Boolean) : void
      {
         _invoke("inviteSummonersToChatRoom",[param1,param2,param3,param4,param5,param6]);
      }
      
      public function obfuscateChatRoom(param1:String, param2:String) : String
      {
         return _invoke("obfuscateChatRoom",[param1,param2]);
      }
      
      public function getAllOccupantsInChatRooms() : ArrayCollection
      {
         return _invoke("getAllOccupantsInChatRooms");
      }
      
      public function closeChatRoom(param1:ChatRoom) : void
      {
         _invoke("closeChatRoom",[param1]);
      }
      
      public function getChatCloseAllChatRoomsSignal() : ISignal
      {
         return _getSignal("getChatCloseAllChatRoomsSignal");
      }
      
      public function inviteToChatRoom(param1:Array, param2:String, param3:String, param4:String, param5:Boolean) : void
      {
         _invoke("inviteToChatRoom",[param1,param2,param3,param4,param5]);
      }
   }
}

