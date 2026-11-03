package com.riotgames.platform.gameclient.popup
{
   import blix.action.BasicAction;
   import blix.signals.ISignal;
   import com.riotgames.notification.DialogQueueProviderProxy;
   import com.riotgames.platform.common.utils.app.ApplicationUtil;
   import com.riotgames.platform.gameclient.views.summoner.wizard.ChooseSummonerIcon;
   import com.riotgames.pvpnet.accountcreation.AccountCreationProviderProxy;
   import com.riotgames.pvpnet.accountcreation.model.ChooseIconModel;
   import flash.display.DisplayObject;
   import mx.managers.PopUpManager;
   
   public class ShowChooseSummonerIconPopupAction extends BasicAction
   {
      
      private var popup:ChooseSummonerIcon;
      
      public function ShowChooseSummonerIconPopupAction()
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
         var _loc1_:ChooseIconModel = AccountCreationProviderProxy.instance.getChooseIconModel();
         _loc1_.continueTutorialSequence = false;
         this.popup = new ChooseSummonerIcon();
         this.popup.chooseIconModel = _loc1_;
         this.popup.getOnClosed().add(this.onClosed);
         this.popup.width = 934.4;
         this.popup.height = 580;
         var _loc2_:DisplayObject = ApplicationUtil.application as DisplayObject;
         PopUpManager.addPopUp(this.popup,_loc2_,true);
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

