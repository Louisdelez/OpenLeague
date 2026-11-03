package com.riotgames.pvpnet.endofgamegiftwindow.models
{
   import blix.signals.ISignal;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.player.IPlayerSummary;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.player.ISessionPlayer;
   
   public interface IGiftingRules
   {
      
      function lastFailReason() : String;
      
      function playerCanSendGifts(param1:ISessionPlayer) : Boolean;
      
      function recipientCanReceiveGift(param1:IPlayerSummary) : Boolean;
      
      function playerCanGiftRecipient(param1:ISessionPlayer, param2:IPlayerSummary) : Boolean;
      
      function rulesInitialized() : ISignal;
      
      function sessionPlayerLevelMinChange() : ISignal;
      
      function sessionPlayerRPMaxChange() : ISignal;
      
      function sessionPlayerDailySendMaxChange() : ISignal;
      
      function recipientLevelMinChange() : ISignal;
      
      function recipientDailyReceiveMaxChange() : ISignal;
      
      function get sessionPLayerLevelMin() : Number;
      
      function get sessionPlayerRPMax() : Number;
      
      function get sessionPlayerDailyMax() : Number;
      
      function get recipientLevelMin() : Number;
      
      function get recipientDailyReceiveMax() : Number;
   }
}

