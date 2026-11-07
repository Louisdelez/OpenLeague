package com.riotgames.platform.gameclient.domain.accountState
{
   import blix.action.BasicAction;
   import blix.signals.ISignal;
   import com.riotgames.notification.DialogQueueProviderProxy;
   import com.riotgames.platform.common.utils.app.ApplicationUtil;
   import com.riotgames.platform.gameclient.views.AccountTransfer.AccountTransferDialog;
   import flash.display.DisplayObject;
   import mx.managers.PopUpManager;
   
   public class BaseShowAccountTransferPopupAction extends BasicAction implements IShowAccountTransferPopupAction
   {
      
      private var popup:AccountTransferDialog;
      
      private var accountStateChangeContext:AccountStateChangeContext;
      
      public function BaseShowAccountTransferPopupAction()
      {
         super(true);
      }
      
      final public function add(param1:AccountStateChangeContext = null) : void
      {
         this.accountStateChangeContext = param1;
         if(getIsFinished())
         {
            reset();
         }
         DialogQueueProviderProxy.instance.addDialog(this);
      }
      
      override protected function doInvocation() : void
      {
         this.addPopUp();
      }
      
      override protected function onCompleted() : void
      {
         this.removePopUp();
      }
      
      override protected function onErred(param1:Error) : void
      {
         this.removePopUp();
      }
      
      private function addPopUp() : void
      {
         this.popup = PopUpManager.createPopUp(ApplicationUtil.application as DisplayObject,AccountTransferDialog,true) as AccountTransferDialog;
         this.popup.getOnClosed().add(this.onClosed);
         PopUpManager.centerPopUp(this.popup);
         this.setupAccountTransferPopup(this.accountStateChangeContext,this.popup);
      }
      
      private function removePopUp() : void
      {
         if(this.popup != null)
         {
            PopUpManager.removePopUp(this.popup);
            this.popup = null;
         }
      }
      
      override protected function onAborted() : void
      {
         this.removePopUp();
      }
      
      protected function setupAccountTransferPopup(param1:AccountStateChangeContext, param2:AccountTransferDialog) : void
      {
      }
      
      private function onClosed(param1:ISignal) : void
      {
         param1.remove(this.onClosed);
         complete();
      }
   }
}

