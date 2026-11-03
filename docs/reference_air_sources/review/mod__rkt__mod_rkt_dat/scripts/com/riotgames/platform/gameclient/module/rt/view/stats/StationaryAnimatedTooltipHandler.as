package com.riotgames.platform.gameclient.module.rt.view.stats
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.IDisplayContainer;
   import blix.assets.proxy.InteractiveObjectProxy;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.ToolTipHandler;
   import blix.frame.getEnterFrame;
   import com.greensock.TweenLite;
   
   public class StationaryAnimatedTooltipHandler extends ToolTipHandler
   {
      
      public function StationaryAnimatedTooltipHandler(param1:StatefulView = null)
      {
         super(param1);
      }
      
      private function get statefulView() : StatefulView
      {
         return _view as StatefulView;
      }
      
      private function doDestroyToolTip(param1:DisplayObjectProxy) : void
      {
         var _loc2_:IDisplayContainer = param1.getParentDisplayContainer();
         if(_loc2_ != null)
         {
            _loc2_.removeChild(_view);
         }
      }
      
      override protected function update() : void
      {
      }
      
      override public function destroyToolTip() : void
      {
         this.statefulView.setCurrentState("hide");
         TweenLite.to(_view.getSetterProxy(),0.5,{
            "onComplete":this.doDestroyToolTip,
            "onCompleteParams":[_view]
         });
         getEnterFrame().remove(this.update);
      }
      
      override public function createToolTip(param1:DisplayObjectContainerProxy, param2:*, param3:InteractiveObjectProxy) : void
      {
         super.createToolTip(param1,param2,param3);
         TweenLite.killTweensOf(_view.getSetterProxy());
         this.statefulView.setCurrentState("show");
      }
   }
}

