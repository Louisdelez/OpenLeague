package com.riotgames.platform.common.ratings
{
   import blix.action.BasicAction;
   import blix.signals.ISignal;
   import com.riotgames.platform.common.utils.app.ApplicationUtil;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import flash.display.DisplayObject;
   import mx.managers.PopUpManager;
   
   public class ShowRatingsPopupAction extends BasicAction
   {
      
      private var popup:RatingsPopup;
      
      public function ShowRatingsPopupAction()
      {
         super(true);
      }
      
      override protected function onAborted() : void
      {
         this.removePopUp();
      }
      
      private function onClosed(param1:ISignal) : void
      {
         param1.remove(this.onClosed);
         complete();
      }
      
      override protected function onCompleted() : void
      {
         this.removePopUp();
      }
      
      override protected function onErred(param1:Error) : void
      {
         this.removePopUp();
      }
      
      override protected function doInvocation() : void
      {
         if(ClientConfig.instance.locale == "ko_KR")
         {
            this.addPopUp();
         }
         else
         {
            complete();
         }
      }
      
      private function addPopUp() : void
      {
         var _loc1_:DisplayObject = ApplicationUtil.application as DisplayObject;
         this.popup = PopUpManager.createPopUp(_loc1_,RatingsPopup,true) as RatingsPopup;
         this.popup.getOnClosed().add(this.onClosed);
         PopUpManager.centerPopUp(this.popup);
      }
      
      private function removePopUp() : void
      {
         if(this.popup != null)
         {
            PopUpManager.removePopUp(this.popup);
            this.popup = null;
         }
      }
   }
}

