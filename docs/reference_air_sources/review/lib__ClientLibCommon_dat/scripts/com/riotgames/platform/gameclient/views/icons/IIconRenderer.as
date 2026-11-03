package com.riotgames.platform.gameclient.views.icons
{
   import blix.assets.proxy.IDisplayChild;
   import blix.components.tooltip.ToolTipHandler;
   
   public interface IIconRenderer extends IDisplayChild
   {
      
      function setTooltip(param1:ToolTipHandler) : void;
   }
}

