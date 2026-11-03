package com.riotgames.pvpnet.endofgamegiftwindow.controllers
{
   import blix.action.IAction;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import com.riotgames.pvpnet.endofgamegiftwindow.actions.IEndOfGameGiftActionFactory;
   import com.riotgames.pvpnet.endofgamegiftwindow.actions.async.LoadGiftsForPlayerServiceCall;
   import com.riotgames.pvpnet.endofgamegiftwindow.actions.async.SendGiftToPlayerServiceCall;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.IEndOfGameGiftModel;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.IJSONserializable;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.dto.SendGiftRequestDTO;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.AvailableGiftCategory;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.IEndOfGameGift;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.IEndOfGameGiftDetailData;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.IGiftCompleteDetailData;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.player.IPlayerSummary;
   import com.riotgames.pvpnet.endofgamegiftwindow.services.IEndOfGameGiftService;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.IEndOfGameGiftViewMediator;
   
   public class EndOfGameGiftWindowController implements IEndOfGameGiftWindowController
   {
      
      private var _context:IContext;
      
      private var _moduleInfo:ProviderModuleInfo;
      
      private var _eoggModel:IEndOfGameGiftModel;
      
      private var _viewMediator:IEndOfGameGiftViewMediator;
      
      private var _eoggService:IEndOfGameGiftService;
      
      private var _eoggActionFactory:IEndOfGameGiftActionFactory;
      
      private var _isNavigationEnabled:Boolean = false;
      
      private var _hideCompleted:Signal;
      
      private var _giftSentSuccess:Signal;
      
      private var _asyncResponseTimeoutAction:IAction;
      
      public function EndOfGameGiftWindowController(param1:IContext, param2:ProviderModuleInfo, param3:IEndOfGameGiftModel, param4:IEndOfGameGiftViewMediator, param5:IEndOfGameGiftService, param6:IEndOfGameGiftActionFactory)
      {
         super();
         this._context = param1;
         this._moduleInfo = param2;
         this._eoggModel = param3;
         this._viewMediator = param4;
         this._eoggService = param5;
         this._eoggActionFactory = param6;
         this._hideCompleted = new Signal();
         this._giftSentSuccess = new Signal();
      }
      
      public function canEnableGiftButton(param1:IPlayerSummary) : Boolean
      {
         return this._eoggModel.getPlayerGiftable(param1);
      }
      
      public function canShowGiftButton(param1:IPlayerSummary) : Boolean
      {
         return true;
      }
      
      public function getGiftButtonToolTip(param1:IPlayerSummary) : String
      {
         return this._eoggModel.getGiftButtonToolTip(param1);
      }
      
      public function showEndOfGameGiftWindow() : void
      {
         var _loc1_:IAction = this._eoggActionFactory.getShowEndOfGameGiftViewAction(this.hideEndOfGameGiftWindow,this.sendGift);
         _loc1_.invoke();
      }
      
      public function hideEndOfGameGiftWindow() : void
      {
         var _loc1_:IAction = this._eoggActionFactory.getHideEndOfGameGiftViewAction();
         _loc1_.invoke();
      }
      
      public function sendGift() : void
      {
         this._eoggService.serviceCallResponseReceived().addOnce(this.onServiceCallSuccessSignal);
         this._eoggService.serviceUnavailable().addOnce(this.onServiceUnavailable);
      }
      
      public function setGiftRecipient(param1:IPlayerSummary) : void
      {
         var _loc2_:IAction = this._eoggActionFactory.getUpdateGiftRecipientAction(param1,this.onGiftRecipientUpdated,this.onGiftListUpdated,this.onGiftServiceError);
         _loc2_.invoke();
      }
      
      public function getGiftWindowClosed() : ISignal
      {
         return this._hideCompleted;
      }
      
      public function getGiftSendSuccess() : ISignal
      {
         return this._giftSentSuccess;
      }
      
      public function getGiftedPlayerUpdated() : ISignal
      {
         return null;
      }
      
      public function cleanSessionData() : void
      {
         var _loc1_:IAction = this._eoggActionFactory.getResetSessionDataAction();
         _loc1_.invoke();
      }
      
      public function destroy() : void
      {
         this._context = null;
         this._moduleInfo = null;
         this._eoggModel.destroy();
      }
      
      private function onGiftRecipientUpdated(param1:IPlayerSummary, param2:IJSONserializable) : void
      {
         var _loc3_:IAction = this._eoggActionFactory.getInitializeViewDataAction();
         _loc3_.invoke();
         this._asyncResponseTimeoutAction = this._eoggActionFactory.getAsyncTimeoutAction(this.onAsyncResponseTimeoutAborted,this.onAsyncResponseTimeoutReached);
         this._asyncResponseTimeoutAction.invoke();
         this._eoggService.serviceCallResponseReceived().addOnce(this.onServiceCallSuccessSignal);
         this._eoggService.serviceUnavailable().addOnce(this.onServiceUnavailable);
         var _loc4_:IAction = this._eoggActionFactory.getShowLoadingGiftsAction();
         _loc4_.invoke();
         var _loc5_:String = param2.toJSONString();
         var _loc6_:IAction = this._eoggActionFactory.createAction(LoadGiftsForPlayerServiceCall.METHOD_NAME,_loc5_);
         _loc6_.invoke();
      }
      
      private function onGiftListUpdated(param1:Vector.<AvailableGiftCategory>) : void
      {
         var _loc2_:IAction = this._eoggActionFactory.getUpdateGiftListAction(param1,this.onGiftSelectionChange);
         _loc2_.invoke();
      }
      
      private function onGiftSelectionChange(param1:IEndOfGameGift) : void
      {
         var _loc2_:IAction = this._eoggActionFactory.getUpdateGiftSelectionAction(param1,this.onGiftSelectionUpdated);
         _loc2_.invoke();
      }
      
      private function onGiftSelectionUpdated(param1:IEndOfGameGiftDetailData) : void
      {
         var _loc2_:IAction = this._eoggActionFactory.getShowGiftDetailDataAction(param1);
         _loc2_.invoke();
         if(!this._isNavigationEnabled)
         {
            this.onEnableNavigation();
         }
      }
      
      private function onConfirmGiftSelection() : void
      {
         var _loc1_:IAction = this._eoggActionFactory.getConfirmGiftSelectionAction();
         _loc1_.invoke();
      }
      
      private function onRevertGiftSelection() : void
      {
         var _loc1_:IAction = this._eoggActionFactory.getRevertGiftSelectionAction();
         _loc1_.invoke();
      }
      
      private function onGiftMessageChange(param1:Object) : void
      {
         var _loc2_:IAction = this._eoggActionFactory.getUpdateGiftMessageAction(param1,this.onGiftMessageUpdated);
         _loc2_.invoke();
      }
      
      private function onGiftMessageUpdated(param1:String, param2:String) : void
      {
         var _loc3_:IAction = this._eoggActionFactory.getShowNewGiftSelectionMessageAction(param1,param2);
         _loc3_.invoke();
      }
      
      private function onUnlockGiftClick() : void
      {
         var _loc1_:IAction = this._eoggActionFactory.getUnlockGiftPayloadAction(this.onUnlockGiftPayloadReady);
         _loc1_.invoke();
      }
      
      private function onEnableNavigation() : void
      {
         this._isNavigationEnabled = true;
         var _loc1_:IAction = this._eoggActionFactory.getEnableNavigationAction(this.onConfirmGiftSelection,this.onRevertGiftSelection,this.onGiftMessageChange,this.onUnlockGiftClick,this.onCloseWindow);
         _loc1_.invoke();
      }
      
      private function onDisableNavigation() : void
      {
         this._isNavigationEnabled = false;
         var _loc1_:IAction = this._eoggActionFactory.getDisableNavigationAction();
         _loc1_.invoke();
      }
      
      private function onCloseWindow() : void
      {
         this.onDisableNavigation();
         this.hideEndOfGameGiftWindow();
         this.destroyEndOfGameGiftWindow();
         this._hideCompleted.dispatch();
      }
      
      private function destroyEndOfGameGiftWindow() : void
      {
         var _loc1_:IAction = this._eoggActionFactory.getDestroyEndOfGameGiftViewAction();
         _loc1_.invoke();
      }
      
      private function onUnlockGiftPayloadReady(param1:SendGiftRequestDTO) : void
      {
         this._asyncResponseTimeoutAction = this._eoggActionFactory.getAsyncTimeoutAction(this.onAsyncResponseTimeoutAborted,this.onAsyncResponseTimeoutReached);
         this._asyncResponseTimeoutAction.invoke();
         this._eoggService.serviceCallResponseReceived().addOnce(this.onServiceCallSuccessSignal);
         this._eoggService.serviceUnavailable().addOnce(this.onServiceUnavailable);
         var _loc2_:IAction = this._eoggActionFactory.getReadySendGiftResponseAction(this.onGiftSendSuccess,this.onGiftServiceError);
         _loc2_.invoke();
         var _loc3_:IAction = this._eoggActionFactory.getShowSendingGiftAction();
         _loc3_.invoke();
         var _loc4_:String = param1.toJSONString();
         var _loc5_:IAction = this._eoggActionFactory.createAction(SendGiftToPlayerServiceCall.METHOD_NAME,_loc4_);
         _loc5_.invoke();
      }
      
      private function onGiftSendSuccess(param1:IGiftCompleteDetailData) : void
      {
         this._giftSentSuccess.dispatch();
         var _loc2_:IAction = this._eoggActionFactory.getShowGiftCompleteAction(param1);
         _loc2_.invoke();
      }
      
      private function onGiftServiceError(param1:IGiftCompleteDetailData) : void
      {
         var _loc2_:IAction = this._eoggActionFactory.getShowGiftCompleteAction(param1);
         _loc2_.invoke();
      }
      
      private function onServiceCallSuccessSignal(param1:String, param2:String) : void
      {
         this._asyncResponseTimeoutAction.abort();
         var _loc3_:IAction = this._eoggActionFactory.createAction(param1,param2);
         _loc3_.invoke();
      }
      
      private function onServiceUnavailable() : void
      {
         this._asyncResponseTimeoutAction.abort();
         var _loc1_:IAction = this._eoggActionFactory.getServiceUnavailableAction();
         _loc1_.invoke();
         this._eoggService.serviceCallResponseReceived().remove(this.onServiceCallSuccessSignal);
         this._eoggService.serviceUnavailable().remove(this.onServiceUnavailable);
         var _loc2_:IAction = this._eoggActionFactory.getUnlockErrorCleanupAction();
         _loc2_.invoke();
      }
      
      private function onAsyncResponseTimeoutAborted() : void
      {
         this._asyncResponseTimeoutAction = null;
      }
      
      private function onAsyncResponseTimeoutReached() : void
      {
         var _loc1_:IAction = this._eoggActionFactory.getAsyncErrorAction();
         _loc1_.invoke();
         this._asyncResponseTimeoutAction = null;
         this._eoggService.serviceCallResponseReceived().remove(this.onServiceCallSuccessSignal);
         this._eoggService.serviceUnavailable().remove(this.onServiceUnavailable);
         var _loc2_:IAction = this._eoggActionFactory.getUnlockErrorCleanupAction();
         _loc2_.invoke();
      }
   }
}

