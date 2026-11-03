package com.riotgames.pvpnet.endofgamegiftwindow.views.components
{
   import blix.components.renderer.IDataRenderer;
   import blix.signals.ISignal;
   
   public interface IGiftListView extends IDataRenderer
   {
      
      function getSelectionChanged() : ISignal;
   }
}

