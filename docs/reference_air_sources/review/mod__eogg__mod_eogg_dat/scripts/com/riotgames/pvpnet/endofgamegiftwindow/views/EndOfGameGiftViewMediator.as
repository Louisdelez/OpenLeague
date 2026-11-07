package com.riotgames.pvpnet.endofgamegiftwindow.views
{
   import blix.context.IContext;
   import blix.signals.ISignal;
   import com.riotgames.platform.common.view.IMainScreen;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.AvailableGiftCategory;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.IEndOfGameGiftDetailData;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.IGiftCompleteDetailData;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.components.IGiftDetailView;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.components.IGiftListView;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.components.IGiftSendCompleteView;
   import com.riotgames.rust.popup.IPopUpManager;
   
   public class EndOfGameGiftViewMediator implements IEndOfGameGiftViewMediator
   {
      
      private var _blixContext:IContext;
      
      private var _popupManager:IPopUpManager;
      
      private var _mainView:IEndOfGameGiftWindowView;
      
      private var _giftDetailView:IGiftDetailView;
      
      private var _giftListView:IGiftListView;
      
      private var _giftCompleteView:IGiftSendCompleteView;
      
      public function EndOfGameGiftViewMediator(param1:IContext)
      {
         super();
         this._blixContext = param1;
         this._popupManager = this._blixContext.getDependency(IPopUpManager);
      }
      
      public function addMainView(param1:IEndOfGameGiftWindowView) : void
      {
         this._mainView = param1;
      }
      
      public function initialize(param1:IGiftListView, param2:IGiftDetailView, param3:IGiftSendCompleteView) : void
      {
         this._giftListView = param1;
         this._giftDetailView = param2;
         this._giftCompleteView = param3;
      }
      
      public function setMainViewData(param1:String, param2:String, param3:String) : void
      {
         this._mainView.setViewData(param1,param2,param3);
      }
      
      public function showMainView() : void
      {
         this._popupManager.addPopUp(IEndOfGameGiftWindow(this._mainView),null,true);
         IMainScreen(this._mainView).show();
      }
      
      public function hideMainView() : void
      {
         IEndOfGameGiftWindow(this._mainView).hide();
      }
      
      public function removeMainView() : void
      {
         this._popupManager.removePopUp(IEndOfGameGiftWindow(this._mainView));
      }
      
      public function showLoadingGifts() : void
      {
         this._mainView.showWorking();
      }
      
      public function showNewGiftList(param1:Vector.<AvailableGiftCategory>) : void
      {
         this._mainView.showSelectGift();
         this._giftListView.setData(param1);
      }
      
      public function showGiftSelectionChange(param1:IEndOfGameGiftDetailData) : void
      {
         this._giftDetailView.setData(param1);
      }
      
      public function setNewGiftMessage(param1:String, param2:String) : void
      {
         this._giftDetailView.setNewGiftMessage(param1,param2);
      }
      
      public function showConfirmGift() : void
      {
         this._mainView.showConfirmGift();
         this._giftDetailView.showConfirmGift();
      }
      
      public function showRevertGiftSelection() : void
      {
         this._mainView.showSelectGift();
         this._giftDetailView.showRevertSelection();
      }
      
      public function showSendingGift() : void
      {
         this._mainView.showWorking();
         this._giftDetailView.showOut();
      }
      
      public function showSentGiftConfirmation(param1:IGiftCompleteDetailData) : void
      {
         this._giftCompleteView.setData(param1);
         this._mainView.showComplete();
      }
      
      public function showGiftServiceError(param1:IGiftCompleteDetailData) : void
      {
         this._giftCompleteView.setData(param1);
         this._mainView.showGiftServiceError();
      }
      
      public function getHideCompleted() : ISignal
      {
         return IMainScreen(this._mainView).getHideCompleted();
      }
      
      public function getSelectionChanged() : ISignal
      {
         return this._giftListView.getSelectionChanged();
      }
      
      public function getConfirmSelection() : ISignal
      {
         return this._mainView.getConfirmSelection();
      }
      
      public function getMessageChange() : ISignal
      {
         return this._giftDetailView.getOnMessageChange();
      }
      
      public function getRevertSelection() : ISignal
      {
         return this._mainView.getRevertSelection();
      }
      
      public function getUnlock() : ISignal
      {
         return this._mainView.getUnlock();
      }
      
      public function getGiftSent() : ISignal
      {
         return IEndOfGameGiftWindow(this._mainView).getGiftSent();
      }
      
      public function destroy() : void
      {
         if(this._mainView)
         {
            IMainScreen(this._mainView).destroy();
         }
      }
   }
}

