package com.riotgames.pvpnet.system.product
{
   import blix.IDestructible;
   import blix.assets.proxy.IDisplayChild;
   import blix.view.ILayoutElement;
   
   public interface IProductChrome extends ILayoutElement, IDisplayChild, IDestructible
   {
      
      function show() : void;
      
      function hide() : void;
   }
}

