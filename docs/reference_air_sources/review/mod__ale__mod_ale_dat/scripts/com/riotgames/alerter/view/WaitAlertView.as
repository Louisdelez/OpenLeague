package com.riotgames.alerter.view
{
   import blix.assets.proxy.SpriteProxy;
   import blix.context.IContext;
   import blix.layout.data.SizeLayoutData;
   import blix.layout.vo.HorizontalAlign;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.alerter.AlertWaitAction;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class WaitAlertView extends StandardMessageAlertView
   {
      
      private var showTimeoutId:uint;
      
      private var showCloseButtonTimeoutId:uint;
      
      public function WaitAlertView(param1:IContext)
      {
         super(param1);
         setLinkage("WaitAlertView");
         setVisible(false);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:SpriteProxy = new SpriteProxy(this);
         setTimelineChildByName("loadingAnimation",_loc1_);
         var _loc2_:SizeLayoutData = new SizeLayoutData();
         _loc2_.setHorizontalAlign(HorizontalAlign.CENTER);
         verticalLayoutContainer.addElementAt(_loc1_,0,_loc2_);
      }
      
      override public function setAlertAction(param1:AlertAction) : void
      {
         var _loc2_:AlertWaitAction = null;
         if(this.showTimeoutId)
         {
            clearTimeout(this.showTimeoutId);
         }
         if(this.showCloseButtonTimeoutId)
         {
            clearTimeout(this.showCloseButtonTimeoutId);
         }
         super.setAlertAction(param1);
         if(_alertAction)
         {
            _loc2_ = _alertAction as AlertWaitAction;
            if(_loc2_.showDelay >= 0)
            {
               setVisible(false);
               this.showTimeoutId = setTimeout(this.show,_loc2_.showDelay);
            }
            else
            {
               setVisible(true);
            }
            if(_loc2_.showNegativeDelay >= 0)
            {
               this.showCloseButtonTimeoutId = setTimeout(this.showCloseButton,_loc2_.showNegativeDelay);
            }
         }
      }
      
      protected function show() : void
      {
         setVisible(true);
      }
      
      private function showCloseButton() : void
      {
         negativeButton.setVisible(true);
      }
   }
}

