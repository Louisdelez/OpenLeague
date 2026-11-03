package com.riotgames.platform.gameclient.chat
{
   import blix.signals.ISignal;
   import com.riotgames.platform.provider.proxy.ProviderProxyBase;
   import org.igniterealtime.xiff.core.UnescapedJID;
   
   public class ChatProviderProxy extends ProviderProxyBase implements IChatProvider
   {
      
      private static var _instance:IChatProvider;
      
      public function ChatProviderProxy()
      {
         super(IChatProvider);
      }
      
      public static function get instance() : IChatProvider
      {
         if(_instance == null)
         {
            _instance = new ChatProviderProxy();
         }
         return _instance;
      }
      
      §§namespace("http://www.riotgames.com/pvpnet/internal") static function setInstance(param1:IChatProvider) : void
      {
         _instance = param1;
      }
      
      public function get currentUserJID() : UnescapedJID
      {
         return _invokeGetter("currentUserJID");
      }
      
      public function get currentUserChatRoomName() : String
      {
         return _invokeGetter("currentUserChatRoomName");
      }
      
      public function getChatNormalMessageRecievedSignal() : ISignal
      {
         return _getSignal("getChatNormalMessageRecievedSignal");
      }
      
      public function sendBuddyMessage(param1:String, param2:String) : void
      {
         _invoke("sendBuddyMessage",[param1,param2]);
      }
      
      public function getChatSpammerErrorSignal() : ISignal
      {
         return _getSignal("getChatSpammerErrorSignal");
      }
      
      public function getChatMinimizeChatViewsSignal() : ISignal
      {
         return _getSignal("getChatMinimizeChatViewsSignal");
      }
      
      public function getChatMessageReceivedFromBuddy() : ISignal
      {
         return _getSignal("getChatMessageReceivedFromBuddy");
      }
      
      public function getChatRemoveAllChatDisplaysSignal() : ISignal
      {
         return _getSignal("getChatRemoveAllChatDisplaysSignal");
      }
      
      public function getChatMessageReceivedSignal() : ISignal
      {
         return _getSignal("getChatMessageReceivedSignal");
      }
      
      public function sendSummonerNameMessage(param1:String, param2:String) : void
      {
         _invoke("sendSummonerNameMessage",[param1,param2]);
      }
      
      public function addBuddy(param1:String, param2:String = null) : void
      {
         _invoke("addBuddy",[param1,param2]);
      }
      
      public function get loggingInChanged() : ISignal
      {
         return _getSignal("loggingInChanged");
      }
      
      public function getChatRankedTeamUpdatedSignal() : ISignal
      {
         return _getSignal("getChatRankedTeamUpdatedSignal");
      }
      
      public function getChatRestoreChatViewsSignal() : ISignal
      {
         return _getSignal("getChatRestoreChatViewsSignal");
      }
      
      public function getChatCloseChatRoomSignal() : ISignal
      {
         return _getSignal("getChatCloseChatRoomSignal");
      }
      
      public function get inGame() : Boolean
      {
         return _invokeGetter("inGame");
      }
      
      public function changePresence(param1:String) : void
      {
         _invoke("changePresence",[param1]);
      }
      
      public function getCurrentUserJIDChangedSignal() : ISignal
      {
         return _getSignal("getCurrentUserJIDChangedSignal");
      }
      
      public function getUserAvailableSignal() : ISignal
      {
         return _getSignal("getUserAvailableSignal");
      }
      
      public function getChatStateChanged() : ISignal
      {
         return _getSignal("getChatStateChanged");
      }
      
      public function getChatCloseAllChatRoomsSignal() : ISignal
      {
         return _getSignal("getChatCloseAllChatRoomsSignal");
      }
      
      public function getChatLoggingOutSignal() : ISignal
      {
         return _getSignal("getChatLoggingOutSignal");
      }
      
      public function getChatCloseMatchmakingQueueChatRoomSignal() : ISignal
      {
         return _getSignal("getChatCloseMatchmakingQueueChatRoomSignal");
      }
      
      public function get currentUserIconID() : int
      {
         return _invokeGetter("currentUserIconID");
      }
      
      public function get currentUserDisplayName() : String
      {
         return _invokeGetter("currentuserDisplayName");
      }
      
      public function addPresenceLayer(param1:String) : void
      {
         _invoke("addPresenceLayer",[param1]);
      }
      
      public function removePresenceLayer(param1:String) : void
      {
         _invoke("removePresenceLayer",[param1]);
      }
      
      public function getChatSystemInitializedSignal() : ISignal
      {
         return _getSignal("getChatSystemInitializedSignal");
      }
   }
}

