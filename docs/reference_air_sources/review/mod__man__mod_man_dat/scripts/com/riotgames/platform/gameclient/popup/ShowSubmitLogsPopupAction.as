package com.riotgames.platform.gameclient.popup
{
   import blix.action.BasicAction;
   import blix.signals.ISignal;
   import com.riotgames.notification.DialogQueueProviderProxy;
   import com.riotgames.platform.common.utils.app.ApplicationUtil;
   import com.riotgames.platform.gameclient.views.application.SubmitLogsDialog;
   import flash.display.DisplayObject;
   import mx.managers.PopUpManager;
   
   public class ShowSubmitLogsPopupAction extends BasicAction
   {
      
      private var popup:SubmitLogsDialog;
      
      public function ShowSubmitLogsPopupAction()
      {
         super(true);
      }
      
      override protected function onAborted() : void
      {
         this.removePopUp();
      }
      
      final public function add() : void
      {
         if(getIsFinished())
         {
            reset();
         }
         DialogQueueProviderProxy.instance.addDialog(this);
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
         this.addPopUp();
      }
      
      private function addPopUp() : void
      {
         this.popup = new SubmitLogsDialog();
         this.popup.getOnClosed().add(this.onClosed);
         var _loc1_:DisplayObject = ApplicationUtil.application as DisplayObject;
         PopUpManager.addPopUp(this.popup,_loc1_,true);
         PopUpManager.centerPopUp(this.popup);
      }
      
      private function removePopUp() : void
      {
         if(this.popup != null)
         {
            this.popup.getOnClosed().removeAll();
            PopUpManager.removePopUp(this.popup);
            this.popup = null;
         }
      }
   }
}

