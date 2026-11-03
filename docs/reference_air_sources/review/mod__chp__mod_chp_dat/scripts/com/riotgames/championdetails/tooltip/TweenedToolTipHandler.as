package com.riotgames.championdetails.tooltip
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.IDisplayContainer;
   import blix.assets.proxy.InteractiveObjectProxy;
   import blix.components.tooltip.ToolTipHandler;
   import blix.frame.getEnterFrame;
   import com.greensock.TweenLite;
   import com.greensock.easing.Sine;
   
   public class TweenedToolTipHandler extends ToolTipHandler
   {
      
      private var _useTransitions:int = 1;
      
      public function TweenedToolTipHandler(param1:DisplayObjectProxy = null, param2:int = 1, param3:int = 0)
      {
         super(param1);
         this.showDelay = param2;
         this.hideDelay = param3;
      }
      
      override public function createToolTip(param1:DisplayObjectContainerProxy, param2:*, param3:InteractiveObjectProxy) : void
      {
         super.createToolTip(param1,param2,param3);
         TweenLite.killTweensOf(_view.getSetterProxy());
         _view.setAlpha(0);
         TweenLite.to(_view.getSetterProxy(),this._useTransitions * 0.2,{
            "alpha":1,
            "ease":Sine.easeIn
         });
      }
      
      override public function destroyToolTip() : void
      {
         TweenLite.to(_view.getSetterProxy(),this._useTransitions * 0.2,{
            "alpha":0,
            "ease":Sine.easeOut,
            "onComplete":this.doDestroyToolTip,
            "onCompleteParams":[_view]
         });
         getEnterFrame().remove(update);
      }
      
      protected function doDestroyToolTip(param1:DisplayObjectProxy) : void
      {
         var _loc2_:IDisplayContainer = param1.getParentDisplayContainer();
         if(_loc2_ != null)
         {
            _loc2_.removeChild(_view);
         }
      }
      
      public function getUseTransitions() : Boolean
      {
         return this._useTransitions == 1;
      }
      
      public function setUseTransitions(param1:Boolean) : void
      {
         this._useTransitions = param1 ? 1 : 0;
      }
   }
}

