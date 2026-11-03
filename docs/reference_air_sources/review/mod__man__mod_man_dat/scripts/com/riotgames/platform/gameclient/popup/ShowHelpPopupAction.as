package com.riotgames.platform.gameclient.popup
{
   import blix.action.BasicAction;
   import blix.signals.ISignal;
   import com.riotgames.notification.DialogQueueProviderProxy;
   import com.riotgames.platform.common.utils.app.ApplicationUtil;
   import com.riotgames.platform.gameclient.controllers.help.HelpController;
   import com.riotgames.platform.gameclient.views.help.HelpDialog;
   import flash.display.DisplayObject;
   import mx.managers.PopUpManager;
   
   public class ShowHelpPopupAction extends BasicAction
   {
      
      private var popup:HelpDialog;
      
      private var helpController:HelpController = new HelpController();
      
      public function ShowHelpPopupAction()
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
      
      private function removePopUp() : void
      {
         if(this.popup != null)
         {
            this.popup.getOnClosed().removeAll();
            PopUpManager.removePopUp(this.popup);
            this.popup = null;
         }
      }
      
      private function onClosed(param1:ISignal) : void
      {
         param1.remove(this.onClosed);
         complete();
      }
      
      override protected function onAborted() : void
      {
         this.removePopUp();
      }
      
      private function addPopUp() : void
      {
         this.popup = new HelpDialog();
         this.popup.getOnClosed().add(this.onClosed);
         this.popup.helpController = this.helpController;
         var _loc1_:DisplayObject = ApplicationUtil.application as DisplayObject;
         PopUpManager.addPopUp(this.popup,_loc1_,true);
         PopUpManager.centerPopUp(this.popup);
      }
      
      override protected function doInvocation() : void
      {
         this.addPopUp();
      }
   }
}

