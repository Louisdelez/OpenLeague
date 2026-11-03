package com.riotgames.platform.gameclient.init
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.components.tooltip.IToolTipManager;
   import flash.display.DisplayObjectContainer;
   
   public class DeprecatedParentProxy extends DisplayObjectContainerProxy
   {
      
      public function DeprecatedParentProxy(param1:DisplayObjectContainer)
      {
         super(null,param1);
      }
      
      public function registerToolTipManager(param1:IToolTipManager) : void
      {
         registerDependency(IToolTipManager,param1);
      }
   }
}

