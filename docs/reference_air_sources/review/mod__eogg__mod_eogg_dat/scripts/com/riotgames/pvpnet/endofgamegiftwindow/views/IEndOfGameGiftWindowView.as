package com.riotgames.pvpnet.endofgamegiftwindow.views
{
   import blix.signals.ISignal;
   
   public interface IEndOfGameGiftWindowView
   {
      
      function setViewData(param1:String, param2:String, param3:String) : void;
      
      function showWorking() : void;
      
      function showSelectGift() : void;
      
      function showConfirmGift() : void;
      
      function showComplete() : void;
      
      function showGiftServiceError() : void;
      
      function updateNextEnabled(param1:Boolean) : void;
      
      function getConfirmSelection() : ISignal;
      
      function getMessageChange() : ISignal;
      
      function getRevertSelection() : ISignal;
      
      function getUnlock() : ISignal;
   }
}

