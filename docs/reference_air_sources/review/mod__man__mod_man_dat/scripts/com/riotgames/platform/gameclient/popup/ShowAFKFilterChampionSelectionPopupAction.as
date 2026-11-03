package com.riotgames.platform.gameclient.popup
{
   import blix.action.BasicAction;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.notification.DialogQueueProviderProxy;
   import com.riotgames.platform.common.utils.app.ApplicationUtil;
   import com.riotgames.platform.gameclient.views.game.common.ConfirmStartChampionSelectView;
   import com.riotgames.pvpnet.clientfeaturedcontent.IClientFeaturedContentProviderProxy;
   import com.riotgames.pvpnet.game.alerts.IAFKFilterChampionSelectionAlertAction;
   import com.riotgames.pvpnet.game.domain.GameAFKStatus;
   import com.riotgames.rust.context.RustContext;
   import flash.display.DisplayObject;
   import mx.managers.PopUpManager;
   
   public class ShowAFKFilterChampionSelectionPopupAction extends BasicAction implements IAFKFilterChampionSelectionAlertAction
   {
      
      private var closeAfterShortDelay:Boolean;
      
      private var initialTimerValue:int;
      
      private var matchAccepted:Signal = new Signal();
      
      private var dialogClosed:Signal = new Signal();
      
      private var matchDeclined:Signal = new Signal();
      
      private var gameAFKStatus:GameAFKStatus;
      
      private var popup:ConfirmStartChampionSelectView;
      
      private var context:RustContext;
      
      private var participantStatusString:String;
      
      public function ShowAFKFilterChampionSelectionPopupAction()
      {
         super(true);
      }
      
      override protected function doInvocation() : void
      {
         this.addPopUp();
      }
      
      public function remove() : void
      {
         complete();
      }
      
      public function updateForLobbyReturn() : void
      {
         if(this.popup != null)
         {
            this.popup.showReturningToLobby();
         }
      }
      
      override protected function onAborted() : void
      {
         this.removePopUp();
      }
      
      public function getDialogClosed() : ISignal
      {
         return this.dialogClosed;
      }
      
      override protected function onCompleted() : void
      {
         this.removePopUp();
      }
      
      public function getMatchAccepted() : ISignal
      {
         return this.matchAccepted;
      }
      
      public function add(param1:GameAFKStatus, param2:String, param3:Boolean = false) : void
      {
         this.gameAFKStatus = param1;
         this.participantStatusString = param2;
         this.closeAfterShortDelay = param3;
         if(getIsFinished())
         {
            reset();
         }
         if(this.popup == null)
         {
            DialogQueueProviderProxy.instance.removeActiveDialogs();
            DialogQueueProviderProxy.instance.addDialog(this);
         }
         else
         {
            this.popup.updateView(param1,param2,param3);
         }
      }
      
      public function getMatchDeclined() : ISignal
      {
         return this.matchDeclined;
      }
      
      private function onClosed(param1:ISignal) : void
      {
         param1.remove(this.onClosed);
         complete();
      }
      
      private function addPopUp() : void
      {
         this.context = new RustContext();
         this.context.loadAssets("/assets/swfs/enterChampionSelect/enterChampSelectPrompt.swf");
         this.context.enableAutoLocalization("resources");
         this.popup = new ConfirmStartChampionSelectView(this.context,this.gameAFKStatus.initialTimerValue);
         this.popup.getOnClosed().add(this.onClosed);
         this.popup.getOnAccepted().add(this.onAccepted);
         this.popup.getOnDeclined().add(this.onDeclined);
         this.popup.updateView(this.gameAFKStatus,this.participantStatusString,this.closeAfterShortDelay);
         var _loc1_:DisplayObject = ApplicationUtil.application as DisplayObject;
         PopUpManager.addPopUp(this.popup,_loc1_,true);
         PopUpManager.centerPopUp(this.popup);
      }
      
      private function onDeclined(param1:ISignal) : void
      {
         param1.remove(this.onDeclined);
         this.matchDeclined.dispatch(this.matchDeclined);
      }
      
      private function onAccepted(param1:ISignal) : void
      {
         param1.remove(this.onAccepted);
         IClientFeaturedContentProviderProxy.instance.closeFromShowAFKFilterChampionSelectionPopupActionAccepted();
         this.matchAccepted.dispatch(this.matchAccepted);
      }
      
      private function removePopUp() : void
      {
         if(this.popup != null)
         {
            this.dialogClosed.dispatch();
            this.matchAccepted.removeAll();
            this.matchDeclined.removeAll();
            this.popup.getOnClosed().remove(this.onClosed);
            this.popup.getOnAccepted().remove(this.onAccepted);
            this.popup.getOnDeclined().remove(this.onDeclined);
            this.popup.cleanUp();
            PopUpManager.removePopUp(this.popup);
            this.popup = null;
         }
      }
      
      override protected function onErred(param1:Error) : void
      {
         this.removePopUp();
      }
   }
}

