package com.riotgames.pvpnet.endofgamegiftwindow.views.components
{
   import blix.components.renderer.IDataRenderer;
   import blix.signals.ISignal;
   
   public interface IGiftDetailView extends IDataRenderer
   {
      
      function getOnMessageChange() : ISignal;
      
      function getOnUnlock() : ISignal;
      
      function setNewGiftMessage(param1:String, param2:String) : void;
      
      function showConfirmGift() : void;
      
      function showRevertSelection() : void;
      
      function showOut() : void;
   }
}

