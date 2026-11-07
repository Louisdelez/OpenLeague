package com.riotgames.platform.gameclient.popup
{
   import blix.action.BasicAction;
   import blix.signals.ISignal;
   import com.riotgames.notification.DialogQueueProviderProxy;
   import com.riotgames.platform.common.utils.app.ApplicationUtil;
   import com.riotgames.platform.gameclient.views.game.normal.RankedQueueFailuresDialog;
   import com.riotgames.pvpnet.game.alerts.IRankedQueueFailureAlertAction;
   import flash.display.DisplayObject;
   import mx.collections.ArrayCollection;
   import mx.managers.PopUpManager;
   
   public class ShowRankedQueueFailurePopupAction extends BasicAction implements IRankedQueueFailureAlertAction
   {
      
      private var minLevelNeeded:int = 0;
      
      private var popup:RankedQueueFailuresDialog;
      
      private var failedPlayers:ArrayCollection;
      
      public function ShowRankedQueueFailurePopupAction()
      {
         super(true);
      }
      
      override protected function onCompleted() : void
      {
         this.removePopUp();
      }
      
      override protected function onErred(param1:Error) : void
      {
         this.removePopUp();
      }
      
      final public function add(param1:ArrayCollection, param2:int = 0) : void
      {
         this.failedPlayers = param1;
         this.minLevelNeeded = param2;
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
      
      private function removePopUp() : void
      {
         if(this.popup != null)
         {
            this.popup.getOnClosed().remove(this.onClosed);
            PopUpManager.removePopUp(this.popup);
            this.popup = null;
            this.failedPlayers = null;
         }
      }
      
      override protected function onAborted() : void
      {
         this.removePopUp();
      }
      
      private function addPopUp() : void
      {
         this.popup = new RankedQueueFailuresDialog();
         this.popup.getOnClosed().add(this.onClosed);
         this.popup.minLevelNeeded = this.minLevelNeeded;
         this.popup.width = 900;
         this.popup.height = 600;
         this.popup.failedJoinPlayers = this.failedPlayers;
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

