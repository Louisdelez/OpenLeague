package com.riotgames.pvpnet.endofgamegiftwindow.actions
{
   import blix.action.IAction;
   import com.riotgames.platform.common.services.lcdsproxy.responses.factory.ILcdsProxyMessageActionFactory;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.AvailableGiftCategory;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.IEndOfGameGift;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.IEndOfGameGiftDetailData;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.IGiftCompleteDetailData;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.player.IPlayerSummary;
   
   public interface IEndOfGameGiftActionFactory extends ILcdsProxyMessageActionFactory
   {
      
      function getUpdateGiftRecipientAction(param1:IPlayerSummary, param2:Function, param3:Function, param4:Function) : IAction;
      
      function getInitializeViewDataAction() : IAction;
      
      function getUpdateGiftSelectionAction(param1:IEndOfGameGift, param2:Function) : IAction;
      
      function getUpdateGiftMessageAction(param1:Object, param2:Function) : IAction;
      
      function getUnlockGiftPayloadAction(param1:Function) : IAction;
      
      function getReadySendGiftResponseAction(param1:Function, param2:Function) : IAction;
      
      function getAsyncTimeoutAction(param1:Function, param2:Function) : IAction;
      
      function getAsyncErrorAction() : IAction;
      
      function getServiceUnavailableAction() : IAction;
      
      function getUnlockErrorCleanupAction() : IAction;
      
      function getResetSessionDataAction() : IAction;
      
      function getShowEndOfGameGiftViewAction(param1:Function, param2:Function) : IAction;
      
      function getHideEndOfGameGiftViewAction() : IAction;
      
      function getDestroyEndOfGameGiftViewAction() : IAction;
      
      function getShowLoadingGiftsAction() : IAction;
      
      function getUpdateGiftListAction(param1:Vector.<AvailableGiftCategory>, param2:Function) : IAction;
      
      function getShowGiftDetailDataAction(param1:IEndOfGameGiftDetailData) : IAction;
      
      function getEnableNavigationAction(param1:Function, param2:Function, param3:Function, param4:Function, param5:Function) : IAction;
      
      function getDisableNavigationAction() : IAction;
      
      function getConfirmGiftSelectionAction() : IAction;
      
      function getRevertGiftSelectionAction() : IAction;
      
      function getShowSendingGiftAction() : IAction;
      
      function getShowGiftCompleteAction(param1:IGiftCompleteDetailData) : IAction;
      
      function getShowNewGiftSelectionMessageAction(param1:String, param2:String) : IAction;
   }
}

