package com.riotgames.pvpnet.tips.views
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.components.tooltip.IToolTipManager;
   import flash.display.Stage;
   
   public class FlexStageProxy extends DisplayObjectContainerProxy
   {
      
      public function FlexStageProxy(param1:Stage)
      {
         _stage = param1;
         super(null,param1);
      }
      
      override public function getStage() : Stage
      {
         return _stage;
      }
      
      public function registerToolTipManager(param1:IToolTipManager) : void
      {
         registerDependency(IToolTipManager,param1);
      }
   }
}

