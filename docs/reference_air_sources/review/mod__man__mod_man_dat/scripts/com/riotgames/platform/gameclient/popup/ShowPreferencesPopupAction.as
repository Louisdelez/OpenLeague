package com.riotgames.platform.gameclient.popup
{
   import blix.action.BasicAction;
   import blix.signals.ISignal;
   import com.riotgames.notification.DialogQueueProviderProxy;
   import com.riotgames.platform.common.utils.app.ApplicationUtil;
   import com.riotgames.platform.gameclient.account.PreferencesView;
   import flash.display.DisplayObject;
   import mx.managers.PopUpManager;
   
   public class ShowPreferencesPopupAction extends BasicAction
   {
      
      private var popup:PreferencesView;
      
      private var submitLogsAlertAction:ShowSubmitLogsPopupAction = new ShowSubmitLogsPopupAction();
      
      public function ShowPreferencesPopupAction()
      {
         super(true);
      }
      
      final public function add() : void
      {
         if(getIsFinished())
         {
            reset();
         }
         DialogQueueProviderProxy.instance.addDialog(this);
      }
      
      override protected function onCompleted() : void
      {
         this.removePopUp();
      }
      
      override protected function onErred(param1:Error) : void
      {
         this.removePopUp();
      }
      
      private function onSubmitLogs(param1:ISignal) : void
      {
         param1.remove(this.onSubmitLogs);
         this.submitLogsAlertAction.add();
         complete();
      }
      
      private function removePopUp() : void
      {
         if(this.popup != null)
         {
            this.popup.getOnClosed().removeAll();
            this.popup.getOnSubmitLogs().removeAll();
            PopUpManager.removePopUp(this.popup);
            this.popup = null;
         }
      }
      
      private function addPopUp() : void
      {
         this.popup = new PreferencesView();
         this.popup.getOnClosed().add(this.onClosed);
         this.popup.getOnSubmitLogs().add(this.onSubmitLogs);
         var _loc1_:DisplayObject = ApplicationUtil.application as DisplayObject;
         PopUpManager.addPopUp(this.popup,_loc1_,true);
         PopUpManager.centerPopUp(this.popup);
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
      
      override protected function doInvocation() : void
      {
         this.addPopUp();
      }
   }
}

