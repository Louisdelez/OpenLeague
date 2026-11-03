package com.riotgames.pvpnet.endofgamegiftwindow.views
{
   import blix.IDestructible;
   import blix.signals.ISignal;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.AvailableGiftCategory;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.IEndOfGameGiftDetailData;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.IGiftCompleteDetailData;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.components.IGiftDetailView;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.components.IGiftListView;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.components.IGiftSendCompleteView;
   
   public interface IEndOfGameGiftViewMediator extends IDestructible
   {
      
      function addMainView(param1:IEndOfGameGiftWindowView) : void;
      
      function initialize(param1:IGiftListView, param2:IGiftDetailView, param3:IGiftSendCompleteView) : void;
      
      function setMainViewData(param1:String, param2:String, param3:String) : void;
      
      function showMainView() : void;
      
      function hideMainView() : void;
      
      function removeMainView() : void;
      
      function showLoadingGifts() : void;
      
      function showNewGiftList(param1:Vector.<AvailableGiftCategory>) : void;
      
      function showGiftSelectionChange(param1:IEndOfGameGiftDetailData) : void;
      
      function setNewGiftMessage(param1:String, param2:String) : void;
      
      function showConfirmGift() : void;
      
      function showRevertGiftSelection() : void;
      
      function showSendingGift() : void;
      
      function showSentGiftConfirmation(param1:IGiftCompleteDetailData) : void;
      
      function showGiftServiceError(param1:IGiftCompleteDetailData) : void;
      
      function getHideCompleted() : ISignal;
      
      function getSelectionChanged() : ISignal;
      
      function getConfirmSelection() : ISignal;
      
      function getMessageChange() : ISignal;
      
      function getRevertSelection() : ISignal;
      
      function getUnlock() : ISignal;
      
      function getGiftSent() : ISignal;
   }
}

