package com.riotgames.pvpnet.endofgamegiftwindow.views
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.button.LabelButtonX;
   import blix.components.list.IRendererFactory;
   import blix.components.list.MultiRendererFactory;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.module.RiotModuleInfo;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.EndOfGameGift;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.GiftBucketHeaderData;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.player.IPlayerSummary;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.components.GiftDetailView;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.components.GiftListView;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.components.GiftSendCompleteView;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.components.giftlist.GiftListBucketHeader;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.components.giftlist.GiftListItemRenderer;
   import com.riotgames.rust.module.RiotModuleView;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class EndOfGameGiftWindowView extends RiotModuleView implements IEndOfGameGiftWindow, IEndOfGameGiftWindowView
   {
      
      private static var STATE_NAME_WORKING:String = "working";
      
      private static var STATE_NAME_SELECT_GIFT:String = "selectGift";
      
      private static var STATE_NAME_CONFIRM_GIFT:String = "confirmGift";
      
      private static var STATE_NAME_COMPLETE:String = "complete";
      
      private var _nextButton:LabelButtonX;
      
      private var _backButton:LabelButtonX;
      
      private var _closeButton:ButtonX;
      
      private var _hideRequested:Signal = new Signal();
      
      private var _confirmSelection:Signal = new Signal();
      
      private var _messageChange:Signal = new Signal();
      
      private var _revertSelection:Signal = new Signal();
      
      private var _giftSent:Signal = new Signal();
      
      private var _onInitComplete:Function;
      
      private var _moduleInfo:RiotModuleInfo;
      
      private var _assetsUrlRequest:URLRequest;
      
      private var _giftedPlayerData:IPlayerSummary;
      
      private var _giftWindowTitle:TextFieldProxy;
      
      private var _giftDetailView:GiftDetailView;
      
      private var _giftList:GiftListView;
      
      private var _giftCompleteView:GiftSendCompleteView;
      
      private var _renderFactory:MultiRendererFactory;
      
      public function EndOfGameGiftWindowView(param1:IContext, param2:RiotModuleInfo, param3:Function)
      {
         this._onInitComplete = param3;
         super(param1,new MovieClip());
         this._moduleInfo = param2;
         setLinkage("Main");
      }
      
      override protected function initializeDependencies() : void
      {
         this._renderFactory = new MultiRendererFactory();
         this._renderFactory.addType(GiftBucketHeaderData,GiftListBucketHeader,[this]);
         this._renderFactory.addType(EndOfGameGift,GiftListItemRenderer,[this]);
         registerDependency(IRendererFactory,this._renderFactory);
         super.initializeDependencies();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._giftWindowTitle = new TextFieldProxy(this);
         setTimelineChildByName("screenTitle.textField",this._giftWindowTitle);
         this._giftDetailView = new GiftDetailView(this);
         setTimelineChildByName("giftDetailView",this._giftDetailView);
         this._giftList = new GiftListView(this);
         setTimelineChildByName("scrollAreaContainer",this._giftList);
         this._giftCompleteView = new GiftSendCompleteView(this);
         this._giftCompleteView.doneButtonClick.add(this.onDoneButtonClick);
         this._giftCompleteView.infoLinkClick.add(this.onInfoLinkClick,true);
         setTimelineChildByName("giftCompleteView",this._giftCompleteView);
         this._nextButton = new LabelButtonX(this);
         this._nextButton.addEventListener(MouseEvent.CLICK,this.goForwardToConfirmation);
         setTimelineChildByName("nextButton",this._nextButton);
         this._backButton = new LabelButtonX(this);
         this._backButton.addEventListener(MouseEvent.CLICK,this.goBackToGiftList);
         setTimelineChildByName("backButton",this._backButton);
         this._closeButton = new ButtonX(this);
         this._closeButton.addEventListener(MouseEvent.CLICK,this.onCloseClick);
         setTimelineChildByName("closeButton",this._closeButton);
         this.showWorking();
         this._onInitComplete.apply(this,[this._giftList,this._giftDetailView,this._giftCompleteView]);
      }
      
      private function goBackToGiftList(param1:MouseEvent) : void
      {
         this._revertSelection.dispatch();
      }
      
      private function goForwardToConfirmation(param1:MouseEvent) : void
      {
         this._confirmSelection.dispatch();
      }
      
      public function onDoneButtonClick() : void
      {
         this._hideRequested.dispatch();
      }
      
      public function onInfoLinkClick(param1:String) : void
      {
         navigateToURL(new URLRequest(param1),"_blank");
      }
      
      private function onCloseClick(param1:MouseEvent) : void
      {
         this._hideRequested.dispatch();
      }
      
      public function getIsThinChrome() : Boolean
      {
         return false;
      }
      
      public function getHasNavigation() : Boolean
      {
         return true;
      }
      
      public function show() : void
      {
         this._assetsUrlRequest = getThemeAssetUrl(this._moduleInfo.getPath(),"EndOfGameGiftWindowAsset.swf");
         loadAssets(this._assetsUrlRequest);
      }
      
      public function getHideCompleted() : ISignal
      {
         return this._hideRequested;
      }
      
      public function hide() : void
      {
         unloadAssets(this._assetsUrlRequest);
      }
      
      override public function destroy() : void
      {
         this._nextButton.removeEventListener(MouseEvent.CLICK,this.goForwardToConfirmation);
         this._backButton.removeEventListener(MouseEvent.CLICK,this.goBackToGiftList);
         this._closeButton.removeEventListener(MouseEvent.CLICK,this.onCloseClick);
         this._hideRequested.removeAll();
         this._hideRequested = null;
         this._giftSent.removeAll();
         this._giftSent = null;
         this._giftedPlayerData = null;
         super.destroy();
      }
      
      public function setGiftedPlayer(param1:IPlayerSummary) : void
      {
         this._giftedPlayerData = param1;
      }
      
      public function getGiftSent() : ISignal
      {
         return this._giftSent;
      }
      
      public function get display() : DisplayObject
      {
         return getAsset();
      }
      
      public function setViewData(param1:String, param2:String, param3:String) : void
      {
         this._giftWindowTitle.setText(param1);
         this._nextButton.setText(param2);
         this._backButton.setText(param3);
      }
      
      public function showWorking() : void
      {
         setCurrentState(STATE_NAME_WORKING);
         getCurrentTimelineAnimation().getCompleted().addOnce(this.resolveNonInteractiveState);
      }
      
      public function showSelectGift() : void
      {
         this._nextButton.setVisible(true);
         this._closeButton.setVisible(true);
         setCurrentState(STATE_NAME_SELECT_GIFT);
         getCurrentTimelineAnimation().getCompleted().addOnce(this.resolveSelectGiftState);
      }
      
      public function showConfirmGift() : void
      {
         this._backButton.setVisible(true);
         this._closeButton.setVisible(true);
         setCurrentState(STATE_NAME_CONFIRM_GIFT);
         getCurrentTimelineAnimation().getCompleted().addOnce(this.resolveConfirmState);
      }
      
      public function showComplete() : void
      {
         setCurrentState(STATE_NAME_COMPLETE);
         getCurrentTimelineAnimation().getCompleted().addOnce(this.resolveNonInteractiveState);
      }
      
      public function showGiftServiceError() : void
      {
         setCurrentState(STATE_NAME_COMPLETE);
         getCurrentTimelineAnimation().getCompleted().addOnce(this.resolveNonInteractiveState);
      }
      
      public function updateNextEnabled(param1:Boolean) : void
      {
         this._nextButton.setEnabled(param1);
      }
      
      public function getConfirmSelection() : ISignal
      {
         return this._confirmSelection;
      }
      
      public function getMessageChange() : ISignal
      {
         return this._messageChange;
      }
      
      public function getRevertSelection() : ISignal
      {
         return this._revertSelection;
      }
      
      public function getUnlock() : ISignal
      {
         return this._giftDetailView.getOnUnlock();
      }
      
      private function resolveNonInteractiveState() : void
      {
         this._nextButton.setVisible(false);
         this._backButton.setVisible(false);
         this._closeButton.setVisible(false);
      }
      
      private function resolveSelectGiftState() : void
      {
         this._backButton.setVisible(false);
      }
      
      private function resolveConfirmState() : void
      {
         this._nextButton.setVisible(false);
      }
   }
}

