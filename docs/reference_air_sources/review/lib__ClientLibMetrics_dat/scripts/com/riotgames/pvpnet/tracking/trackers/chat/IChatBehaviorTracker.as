package com.riotgames.pvpnet.tracking.trackers.chat
{
   public interface IChatBehaviorTracker
   {
      
      function setChatWindowsOpened_InASession(param1:uint) : void;
      
      function incrementChatMessageSent_InASession(param1:String, param2:String) : void;
      
      function incrementChatMessagesReceived_InASession(param1:String, param2:String) : void;
      
      function setChatWindowsOpenedAtOnce(param1:uint) : void;
      
      function incrementChatWindowClosed_InASession(param1:String) : void;
      
      function incrementChatStartByReceivedMessage_InASession(param1:String) : void;
      
      function incrementChatStartBySentMessage_InASession(param1:String) : void;
      
      function incrementInGameChatReceived_InASession() : void;
      
      function incrementInGameChatSent_InASession() : void;
      
      function incrementChatWindowSwitched_InASession() : void;
      
      function incrementChatWindowsMinimizedViaButton() : void;
      
      function incrementChatWindowOptionsClicked() : void;
      
      function incrementViewProfileClicked() : void;
      
      function incrementURLReceived() : void;
      
      function incrementURLClicked() : void;
   }
}

