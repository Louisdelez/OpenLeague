package com.riotgames.pvpnet.endofgamegiftwindow.actions
{
   import blix.action.IAction;
   import blix.context.IContext;
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyServiceMessenger;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.platform.common.utils.encode.IEncode;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import com.riotgames.pvpnet.endofgamegiftwindow.actions.async.AsyncErrorAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.actions.async.AsyncTimeoutAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.actions.async.ServiceUnavailableAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.actions.model.ReadySendGiftResponseAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.actions.model.ResetSessionDataAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.actions.model.UnlockErrorCleanupAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.actions.model.UnlockGiftPayloadAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.actions.model.UpdateGiftMessageAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.actions.model.UpdateGiftRecipientAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.actions.model.UpdateGiftSelectionAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.actions.view.DestroyEndOfGameGiftVewAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.actions.view.DisableNavigationAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.actions.view.EnableNavigationAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.actions.view.HideEndOfGameGiftViewAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.actions.view.InitializeViewDataAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.actions.view.RevertGiftSelectionAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.actions.view.ShowConfirmGiftAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.actions.view.ShowEndOfGameGiftViewAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.actions.view.ShowGiftDetailDataAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.actions.view.ShowGiftListAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.actions.view.ShowGiftSendCompleteAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.actions.view.ShowLoadingGiftsStateAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.actions.view.ShowNewGiftSelectionMessage;
   import com.riotgames.pvpnet.endofgamegiftwindow.actions.view.ShowSendingGiftAction;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.IEndOfGameGiftModel;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.IGiftListValueObjectFactory;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.AvailableGiftCategory;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.IEndOfGameGift;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.IEndOfGameGiftDetailData;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.IGiftCompleteDetailData;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.player.IPlayerSummary;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.IEndOfGameGiftViewMediator;
   
   public class EndOfGameGiftActionFactory implements IEndOfGameGiftActionFactory
   {
      
      private var _blixContext:IContext;
      
      private var _moduleInfo:ProviderModuleInfo;
      
      private var _model:IEndOfGameGiftModel;
      
      private var _view:IEndOfGameGiftViewMediator;
      
      private var _validator:IGiftListValueObjectFactory;
      
      private var _service:ILcdsProxyServiceMessenger;
      
      private var _messageActionFactory:EndOfGameGiftMessageActionFactory;
      
      private var _encoder:IEncode;
      
      private var _decoder:IDecode;
      
      public function EndOfGameGiftActionFactory(param1:IContext, param2:ProviderModuleInfo, param3:IEndOfGameGiftModel, param4:IEndOfGameGiftViewMediator, param5:ILcdsProxyServiceMessenger, param6:IGiftListValueObjectFactory, param7:IEncode, param8:IDecode)
      {
         super();
         this._blixContext = param1;
         this._moduleInfo = param2;
         this._model = param3;
         this._view = param4;
         this._validator = param6;
         this._service = param5;
         this._encoder = param7;
         this._decoder = param8;
         this._messageActionFactory = new EndOfGameGiftMessageActionFactory(this._model,this._view,this._validator,this._service,this._encoder,this._decoder);
      }
      
      public function createAction(param1:String, param2:String) : IAction
      {
         return this._messageActionFactory.createAction(param1,param2);
      }
      
      public function getUpdateGiftRecipientAction(param1:IPlayerSummary, param2:Function, param3:Function, param4:Function) : IAction
      {
         return new UpdateGiftRecipientAction(this._model,param1,param2,param3,param4);
      }
      
      public function getInitializeViewDataAction() : IAction
      {
         return new InitializeViewDataAction(this._model,this._view);
      }
      
      public function getUpdateGiftSelectionAction(param1:IEndOfGameGift, param2:Function) : IAction
      {
         return new UpdateGiftSelectionAction(this._model,param1,param2);
      }
      
      public function getUpdateGiftMessageAction(param1:Object, param2:Function) : IAction
      {
         return new UpdateGiftMessageAction(this._model,param1,param2);
      }
      
      public function getUnlockGiftPayloadAction(param1:Function) : IAction
      {
         return new UnlockGiftPayloadAction(this._model,param1);
      }
      
      public function getReadySendGiftResponseAction(param1:Function, param2:Function) : IAction
      {
         return new ReadySendGiftResponseAction(this._model,param1,param2);
      }
      
      public function getAsyncTimeoutAction(param1:Function, param2:Function) : IAction
      {
         return new AsyncTimeoutAction(param1,param2);
      }
      
      public function getAsyncErrorAction() : IAction
      {
         return new AsyncErrorAction(this._model);
      }
      
      public function getServiceUnavailableAction() : IAction
      {
         return new ServiceUnavailableAction(this._model);
      }
      
      public function getUnlockErrorCleanupAction() : IAction
      {
         return new UnlockErrorCleanupAction(this._model);
      }
      
      public function getResetSessionDataAction() : IAction
      {
         return new ResetSessionDataAction(this._model);
      }
      
      public function getShowEndOfGameGiftViewAction(param1:Function, param2:Function) : IAction
      {
         return new ShowEndOfGameGiftViewAction(this._view,this._blixContext,this._moduleInfo,param1,param2);
      }
      
      public function getHideEndOfGameGiftViewAction() : IAction
      {
         return new HideEndOfGameGiftViewAction(this._view);
      }
      
      public function getDestroyEndOfGameGiftViewAction() : IAction
      {
         return new DestroyEndOfGameGiftVewAction(this._view);
      }
      
      public function getShowLoadingGiftsAction() : IAction
      {
         return new ShowLoadingGiftsStateAction(this._view);
      }
      
      public function getUpdateGiftListAction(param1:Vector.<AvailableGiftCategory>, param2:Function) : IAction
      {
         return new ShowGiftListAction(this._view,param1,param2);
      }
      
      public function getShowGiftDetailDataAction(param1:IEndOfGameGiftDetailData) : IAction
      {
         return new ShowGiftDetailDataAction(this._view,param1);
      }
      
      public function getEnableNavigationAction(param1:Function, param2:Function, param3:Function, param4:Function, param5:Function) : IAction
      {
         return new EnableNavigationAction(this._view,param1,param2,param3,param4,param5);
      }
      
      public function getDisableNavigationAction() : IAction
      {
         return new DisableNavigationAction(this._view);
      }
      
      public function getConfirmGiftSelectionAction() : IAction
      {
         return new ShowConfirmGiftAction(this._model,this._view);
      }
      
      public function getRevertGiftSelectionAction() : IAction
      {
         return new RevertGiftSelectionAction(this._model,this._view);
      }
      
      public function getShowSendingGiftAction() : IAction
      {
         return new ShowSendingGiftAction(this._view);
      }
      
      public function getShowGiftCompleteAction(param1:IGiftCompleteDetailData) : IAction
      {
         return new ShowGiftSendCompleteAction(this._view,param1);
      }
      
      public function getShowNewGiftSelectionMessageAction(param1:String, param2:String) : IAction
      {
         return new ShowNewGiftSelectionMessage(this._view,param1,param2);
      }
   }
}

