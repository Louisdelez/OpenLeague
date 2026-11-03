package com.riotgames.platform.gameclient.popup
{
   import blix.action.BasicAction;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.notification.DialogQueueProviderProxy;
   import com.riotgames.platform.common.utils.app.ApplicationUtil;
   import com.riotgames.platform.gameclient.views.game.normal.LeaverBusterDialogue;
   import com.riotgames.pvpnet.game.alerts.ILeaverBusterAlertAction;
   import flash.display.DisplayObject;
   import mx.collections.ArrayCollection;
   import mx.managers.PopUpManager;
   
   public class ShowLeaverBusterAlertAction extends BasicAction implements ILeaverBusterAlertAction
   {
      
      private var _abortedByLocalUser:Boolean;
      
      private var _dialogueAborted:Signal = new Signal();
      
      private var _dialogueWaitComplete:Signal = new Signal();
      
      private var isSolo:Boolean;
      
      private var bustedLeavers:ArrayCollection;
      
      private var popup:LeaverBusterDialogue;
      
      public function ShowLeaverBusterAlertAction()
      {
         super(true);
      }
      
      private function removePopUp() : void
      {
         if(this.popup != null)
         {
            this.popup.cleanUp();
            this.popup.getOnClosed().removeAll();
            PopUpManager.removePopUp(this.popup);
            this.popup = null;
            this.bustedLeavers = null;
            abort();
         }
      }
      
      public function removeDialogue() : void
      {
         this._abortedByLocalUser = false;
         this.removePopUp();
      }
      
      public function showDialogueForLeavers(param1:ArrayCollection, param2:Boolean) : void
      {
         this.bustedLeavers = param1;
         this.isSolo = param2;
         if(getIsFinished())
         {
            reset();
         }
         DialogQueueProviderProxy.instance.addDialog(this);
      }
      
      override protected function onCompleted() : void
      {
         this._dialogueWaitComplete.dispatch(this.bustedLeavers);
         this.removePopUp();
      }
      
      public function getDialogueAborted() : ISignal
      {
         return this._dialogueAborted;
      }
      
      public function getDialogueWaitCompleted() : ISignal
      {
         return this._dialogueWaitComplete;
      }
      
      private function onClosed(param1:ISignal) : void
      {
         this._abortedByLocalUser = true;
         param1.remove(this.onClosed);
         abort();
      }
      
      private function handleTimerExpired() : void
      {
         complete();
      }
      
      private function addPopUp() : void
      {
         this.popup = new LeaverBusterDialogue();
         this.popup.getOnClosed().add(this.onClosed);
         this.popup.getTimerExpired().add(this.handleTimerExpired);
         var _loc1_:DisplayObject = ApplicationUtil.application as DisplayObject;
         this.popup.setBustedLeavers(this.bustedLeavers,this.isSolo);
         this.popup.width = 900;
         this.popup.height = 600;
         PopUpManager.addPopUp(this.popup,_loc1_,true);
         PopUpManager.centerPopUp(this.popup);
      }
      
      override protected function onErred(param1:Error) : void
      {
         this.removePopUp();
      }
      
      override protected function doInvocation() : void
      {
         this.addPopUp();
      }
      
      override protected function onAborted() : void
      {
         this._dialogueAborted.dispatch(this._abortedByLocalUser);
         this.removePopUp();
      }
   }
}

