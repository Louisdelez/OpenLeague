package com.riotgames.pvpnet.endofgamegiftwindow.views.components.giftlist
{
   import blix.IDestructible;
   import blix.components.renderer.IDataRenderer;
   import blix.components.renderer.IItemRenderer;
   import blix.signals.ISignal;
   
   public interface IGiftListBucketHeader extends IDataRenderer, IDestructible, IItemRenderer
   {
      
      function get doExpand() : ISignal;
      
      function get doCollapse() : ISignal;
   }
}

