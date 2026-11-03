package com.riotgames.platform.common.services
{
   public class ChatServiceState
   {
      
      public static const STATE_LOGGING_IN:String = "stateLoggingIn";
      
      public static const STATE_LOGGING_OUT:String = "stateLoggingOut";
      
      public static const STATE_RECONNECTING:String = "stateReconnecting";
      
      public static const STATE_DELAYED_RECONNECT:String = "stateDelayedReconnect";
      
      public static const STATE_CONNECTED:String = "stateConnected";
      
      public static const STATE_DISCONNECTED:String = "stateDisconnected";
      
      public function ChatServiceState()
      {
         super();
      }
   }
}

