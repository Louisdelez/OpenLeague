package com.riotgames.platform.gameclient.chat
{
   import blix.signals.ISignal;
   import com.riotgames.platform.provider.proxy.ProviderProxyNoop;
   
   public class ChatBlockedRosterProviderProxy extends ProviderProxyNoop implements IChatBlockedRosterProvider
   {
      
      private static var _instance:IChatBlockedRosterProvider;
      
      public function ChatBlockedRosterProviderProxy()
      {
         super(IChatBlockedRosterProvider);
      }
      
      public static function get instance() : IChatBlockedRosterProvider
      {
         if(_instance == null)
         {
            _instance = new ChatBlockedRosterProviderProxy();
         }
         return _instance;
      }
      
      §§namespace("http://www.riotgames.com/pvpnet/internal") static function setInstance(param1:IChatBlockedRosterProvider) : void
      {
         _instance = param1;
      }
      
      public function isPrivacyListReady() : Boolean
      {
         return _invoke("isPrivacyListReady");
      }
      
      public function isBlockedBySummonerId(param1:Number) : Boolean
      {
         return _invoke("isBlockedBySummonerId",[param1]);
      }
      
      public function getPrivacyListInitializedSignal() : ISignal
      {
         return _getSignal("getPrivacyListInitializedSignal");
      }
      
      public function isBlockedByJid(param1:String) : Boolean
      {
         return _invoke("isBlockedByJid",[param1]);
      }
   }
}

