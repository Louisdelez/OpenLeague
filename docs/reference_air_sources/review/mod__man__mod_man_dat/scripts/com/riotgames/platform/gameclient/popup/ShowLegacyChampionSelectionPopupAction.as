package com.riotgames.platform.gameclient.popup
{
   import blix.action.BasicAction;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.notification.DialogQueueProviderProxy;
   import com.riotgames.platform.common.utils.app.ApplicationUtil;
   import com.riotgames.platform.gameclient.views.game.normal.EnterChampionSelectDialog;
   import com.riotgames.pvpnet.clientfeaturedcontent.IClientFeaturedContentProviderProxy;
   import com.riotgames.pvpnet.game.alerts.ILegacyChampionSelectionAlertAction;
   import com.riotgames.pvpnet.game.domain.EnterChampionSelectManager;
   import flash.display.DisplayObject;
   import mx.managers.PopUpManager;
   
   public class ShowLegacyChampionSelectionPopupAction extends BasicAction implements ILegacyChampionSelectionAlertAction
   {
      
      private var onPlayNow:Signal = new Signal();
      
      private var popup:EnterChampionSelectDialog;
      
      private var enterChampionSelectManager:EnterChampionSelectManager;
      
      public function ShowLegacyChampionSelectionPopupAction()
      {
         super(true);
      }
      
      public function add(param1:EnterChampionSelectManager) : void
      {
         this.enterChampionSelectManager = param1;
         if(getIsFinished())
         {
            reset();
         }
         DialogQueueProviderProxy.instance.removeActiveDialogs();
         DialogQueueProviderProxy.instance.addDialog(this);
      }
      
      public function remove() : void
      {
         complete();
      }
      
      override protected function onErred(param1:Error) : void
      {
         this.removePopUp();
      }
      
      private function removePopUp() : void
      {
         if(this.popup != null)
         {
            this.onPlayNow.removeAll();
            this.popup.getOnAccepted().remove(this.onAccepted);
            this.popup.getOnDismissed().remove(this.onDismissed);
            PopUpManager.removePopUp(this.popup);
            this.popup = null;
         }
      }
      
      private function onDismissed(param1:ISignal) : void
      {
         param1.remove(this.onDismissed);
         complete();
      }
      
      private function addPopUp() : void
      {
         this.popup = new EnterChampionSelectDialog();
         this.popup.getOnAccepted().add(this.onAccepted);
         this.popup.getOnDismissed().add(this.onDismissed);
         this.popup.enterChampionSelectManager = this.enterChampionSelectManager;
         var _loc1_:DisplayObject = ApplicationUtil.application as DisplayObject;
         PopUpManager.addPopUp(this.popup,_loc1_,true);
         PopUpManager.centerPopUp(this.popup);
      }
      
      public function getOnPlayNow() : ISignal
      {
         return this.onPlayNow;
      }
      
      override protected function onCompleted() : void
      {
         this.removePopUp();
      }
      
      private function onAccepted(param1:ISignal) : void
      {
         this.onPlayNow.dispatch(this.onPlayNow);
         param1.remove(this.onAccepted);
         IClientFeaturedContentProviderProxy.instance.closeFromShowLegacyChampionSelectionPopupActionAccepted();
         complete();
      }
      
      override protected function onAborted() : void
      {
         this.removePopUp();
      }
      
      override protected function doInvocation() : void
      {
         this.addPopUp();
      }
   }
}

