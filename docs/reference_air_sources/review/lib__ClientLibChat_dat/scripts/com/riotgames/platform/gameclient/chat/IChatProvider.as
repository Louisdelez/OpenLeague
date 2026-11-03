package com.riotgames.platform.gameclient.chat
{
   import blix.signals.ISignal;
   import com.riotgames.platform.provider.IProvider;
   import org.igniterealtime.xiff.core.UnescapedJID;
   
   public interface IChatProvider extends IProvider
   {
      
      function get currentUserJID() : UnescapedJID;
      
      function get currentUserChatRoomName() : String;
      
      function getChatNormalMessageRecievedSignal() : ISignal;
      
      function getCurrentUserJIDChangedSignal() : ISignal;
      
      function sendBuddyMessage(param1:String, param2:String) : void;
      
      function changePresence(param1:String) : void;
      
      function getChatSpammerErrorSignal() : ISignal;
      
      function getUserAvailableSignal() : ISignal;
      
      function getChatMessageReceivedFromBuddy() : ISignal;
      
      function getChatMinimizeChatViewsSignal() : ISignal;
      
      function get currentUserIconID() : int;
      
      function getChatRemoveAllChatDisplaysSignal() : ISignal;
      
      function getChatMessageReceivedSignal() : ISignal;
      
      function getChatLoggingOutSignal() : ISignal;
      
      function sendSummonerNameMessage(param1:String, param2:String) : void;
      
      function get currentUserDisplayName() : String;
      
      function addBuddy(param1:String, param2:String = null) : void;
      
      function getChatRankedTeamUpdatedSignal() : ISignal;
      
      function get loggingInChanged() : ISignal;
      
      function removePresenceLayer(param1:String) : void;
      
      function addPresenceLayer(param1:String) : void;
      
      function get inGame() : Boolean;
      
      function getChatRestoreChatViewsSignal() : ISignal;
      
      function getChatSystemInitializedSignal() : ISignal;
   }
}

