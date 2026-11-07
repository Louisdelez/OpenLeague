package com.riotgames.platform.gameclient.popup
{
   import blix.action.BasicAction;
   import blix.signals.ISignal;
   import com.riotgames.notification.DialogQueueProviderProxy;
   import com.riotgames.platform.common.utils.app.ApplicationUtil;
   import com.riotgames.platform.gameclient.views.game.normal.QueueDodgeDialog;
   import com.riotgames.pvpnet.game.alerts.IQueueDodgeAlertAction;
   import flash.display.DisplayObject;
   import mx.collections.ArrayCollection;
   import mx.managers.PopUpManager;
   
   public class ShowQueueDodgePopupAction extends BasicAction implements IQueueDodgeAlertAction
   {
      
      private var failedJoinPlayers:ArrayCollection;
      
      private var popup:QueueDodgeDialog;
      
      public function ShowQueueDodgePopupAction()
      {
         super(true);
      }
      
      override protected function doInvocation() : void
      {
         this.addPopUp();
      }
      
      override protected function onErred(param1:Error) : void
      {
         this.removePopUp();
      }
      
      final public function add(param1:ArrayCollection) : void
      {
         this.failedJoinPlayers = param1;
         if(getIsFinished())
         {
            reset();
         }
         DialogQueueProviderProxy.instance.addDialog(this);
      }
      
      private function addPopUp() : void
      {
         this.popup = new QueueDodgeDialog();
         this.popup.getOnClosed().add(this.onClosed);
         var _loc1_:DisplayObject = ApplicationUtil.application as DisplayObject;
         this.popup.failedJoinPlayers = this.failedJoinPlayers;
         this.popup.width = 900;
         this.popup.height = 600;
         PopUpManager.addPopUp(this.popup,_loc1_,true);
         PopUpManager.centerPopUp(this.popup);
      }
      
      override protected function onCompleted() : void
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
            this.failedJoinPlayers = null;
         }
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
   }
}

