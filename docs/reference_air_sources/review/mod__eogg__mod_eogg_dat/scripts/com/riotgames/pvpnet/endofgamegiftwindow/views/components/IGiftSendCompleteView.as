package com.riotgames.pvpnet.endofgamegiftwindow.views.components
{
   import blix.components.renderer.IDataRenderer;
   import blix.signals.ISignal;
   
   public interface IGiftSendCompleteView extends IDataRenderer
   {
      
      function showOut() : void;
      
      function showComplete() : void;
      
      function showError() : void;
      
      function get doneButtonClick() : ISignal;
      
      function get infoLinkClick() : ISignal;
   }
}

