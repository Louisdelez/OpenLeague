package com.riotgames.pvpnet.CLS.views.tooltip
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.components.tooltip.ToolTipHandler;
   
   public class EmblemsToolTipHandler extends ToolTipHandler
   {
      
      public function EmblemsToolTipHandler(param1:DisplayObjectProxy = null, param2:int = 1, param3:int = 0)
      {
         super(param1);
         this.showDelay = param2;
         this.hideDelay = param3;
      }
   }
}

