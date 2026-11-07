package com.riotgames.platform.gameclient.chat
{
   import blix.signals.ISignal;
   
   public interface IChatBlockedRosterProvider
   {
      
      function isBlockedBySummonerId(param1:Number) : Boolean;
      
      function getPrivacyListInitializedSignal() : ISignal;
      
      function isBlockedByJid(param1:String) : Boolean;
      
      function isPrivacyListReady() : Boolean;
   }
}

