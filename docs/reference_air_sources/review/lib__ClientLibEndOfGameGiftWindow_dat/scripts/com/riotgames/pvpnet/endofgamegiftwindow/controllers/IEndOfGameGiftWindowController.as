package com.riotgames.pvpnet.endofgamegiftwindow.controllers
{
   import blix.IDestructible;
   import blix.signals.ISignal;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.player.IPlayerSummary;
   
   public interface IEndOfGameGiftWindowController extends IDestructible
   {
      
      function showEndOfGameGiftWindow() : void;
      
      function hideEndOfGameGiftWindow() : void;
      
      function canEnableGiftButton(param1:IPlayerSummary) : Boolean;
      
      function canShowGiftButton(param1:IPlayerSummary) : Boolean;
      
      function getGiftButtonToolTip(param1:IPlayerSummary) : String;
      
      function cleanSessionData() : void;
      
      function sendGift() : void;
      
      function setGiftRecipient(param1:IPlayerSummary) : void;
      
      function getGiftWindowClosed() : ISignal;
      
      function getGiftSendSuccess() : ISignal;
      
      function getGiftedPlayerUpdated() : ISignal;
   }
}

