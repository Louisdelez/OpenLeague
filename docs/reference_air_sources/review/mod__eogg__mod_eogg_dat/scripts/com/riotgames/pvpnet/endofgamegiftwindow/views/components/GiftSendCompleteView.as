package com.riotgames.pvpnet.endofgamegiftwindow.views.components
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.button.LabelButtonX;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.domain.Summoner;
   import com.riotgames.pvpnet.endofgamegiftwindow.enums.GiftTypes;
   import com.riotgames.pvpnet.endofgamegiftwindow.enums.ImageTypes;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.GiftImageData;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.IEndOfGameGiftDetailData;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.IGiftCompleteDetailData;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.IGiftErrorData;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.components.giftdetail.GiftDetailLayoutContainer;
   import flash.events.MouseEvent;
   import flash.text.TextFieldAutoSize;
   
   public class GiftSendCompleteView extends StatefulView implements IGiftSendCompleteView
   {
      
      private static var ERROR_MESSAGE_TEXT_WIDTH:Number = 380;
      
      private static var GIFT_MESSAGE_DEFAULT_WIDTH:Number = 250;
      
      private static var GIFT_LINK_DEFUALT_WIDTH:Number = 210;
      
      private var _doneButtonClick:Signal = new Signal();
      
      private var _infoLinkClick:Signal = new Signal();
      
      private var _displayData:IGiftCompleteDetailData;
      
      private var _sessionData:Summoner;
      
      private var _titleText:TextFieldProxy;
      
      private var _giftDetailImage:GiftImageContainer;
      
      private var _giftDetailView:GiftDetailLayoutContainer;
      
      private var _giftMessage:TextFieldProxy;
      
      private var _infoLink:TextOnlyLabelButton;
      
      private var _closeButton:ButtonX;
      
      private var _doneButton:LabelButtonX;
      
      public function GiftSendCompleteView(param1:IContext)
      {
         super(param1,null);
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this._sessionData = Session.instance.summoner;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._titleText = new TextFieldProxy(this);
         setTimelineChildByName("giftSentTitle.textField",this._titleText);
         this._giftDetailImage = new GiftImageContainer(this);
         setTimelineChildByName("giftImageContainer",this._giftDetailImage);
         this._giftDetailView = new GiftDetailLayoutContainer(this);
         setTimelineChildByName("giftDetailView",this._giftDetailView);
         this._giftMessage = new TextFieldProxy(this);
         setTimelineChildByName("giftMessage.textField",this._giftMessage);
         this._infoLink = new TextOnlyLabelButton(this);
         setTimelineChildByName("infoLink",this._infoLink);
         this._closeButton = new ButtonX(this);
         setTimelineChildByName("giftSentCloseButton",this._closeButton);
         this._closeButton.addEventListener(MouseEvent.CLICK,this.onButtonClick,false);
         this._doneButton = new LabelButtonX(this);
         setTimelineChildByName("doneButton",this._doneButton);
         this._doneButton.addEventListener(MouseEvent.CLICK,this.onButtonClick,false);
         this.showOut();
      }
      
      public function getData() : *
      {
         return this._displayData;
      }
      
      public function setData(param1:*) : void
      {
         this._displayData = IGiftCompleteDetailData(param1);
         if(this._displayData.isErrorState)
         {
            this.drawErrorState();
         }
         else
         {
            this.drawCompleteState();
         }
      }
      
      public function get doneButtonClick() : ISignal
      {
         return this._doneButtonClick;
      }
      
      public function get infoLinkClick() : ISignal
      {
         return this._infoLinkClick;
      }
      
      override public function destroy() : void
      {
         if(this._infoLink.hasEventListener(MouseEvent.CLICK))
         {
            this._infoLink.removeEventListener(MouseEvent.CLICK,this.onInfoClick,false);
         }
         if(this._closeButton.hasEventListener(MouseEvent.CLICK))
         {
            this._closeButton.removeEventListener(MouseEvent.CLICK,this.onButtonClick,false);
         }
         if(this._doneButton.hasEventListener(MouseEvent.CLICK))
         {
            this._doneButton.removeEventListener(MouseEvent.CLICK,this.onButtonClick,false);
         }
         this._doneButtonClick.removeAll();
         this._infoLinkClick.removeAll();
         super.destroy();
      }
      
      private function drawErrorState() : void
      {
         this._giftMessage.setWidth(ERROR_MESSAGE_TEXT_WIDTH);
         this._giftMessage.setWordWrap(true);
         this._giftMessage.setMultiline(true);
         this._giftMessage.setAutoSize(TextFieldAutoSize.LEFT);
         this._infoLink.textField.setWidth(ERROR_MESSAGE_TEXT_WIDTH);
         this._infoLink.textField.setWordWrap(true);
         this._infoLink.textField.setMultiline(true);
         this._infoLink.textField.setAutoSize(TextFieldAutoSize.LEFT);
         var _loc1_:IGiftErrorData = this._displayData.errorData;
         this._titleText.setText(_loc1_.errorTitleText);
         this._giftMessage.setText(_loc1_.errorText);
         this._infoLink.setText(_loc1_.errorInfoText);
         this._infoLink.addEventListener(MouseEvent.CLICK,this.onInfoClick,false,0,true);
         this._doneButton.setText(_loc1_.doneButtonLabel);
         this.showError();
      }
      
      private function drawCompleteState() : void
      {
         this._giftMessage.setWidth(GIFT_MESSAGE_DEFAULT_WIDTH);
         this._giftMessage.setWordWrap(false);
         this._giftMessage.setMultiline(false);
         this._giftMessage.setAutoSize(TextFieldAutoSize.NONE);
         this._infoLink.textField.setWidth(GIFT_LINK_DEFUALT_WIDTH);
         this._infoLink.textField.setWordWrap(false);
         this._infoLink.textField.setMultiline(false);
         this._infoLink.textField.setAutoSize(TextFieldAutoSize.NONE);
         var _loc1_:IEndOfGameGiftDetailData = this._displayData.giftDetailData;
         this._titleText.setText(_loc1_.giftDetailTitle);
         if(_loc1_.itemInventoryType == GiftTypes.GIFT_TYPE_CHAMPION)
         {
            this._giftDetailImage.setData(new GiftImageData(_loc1_.detailImageURL,ImageTypes.IMAGE_TYPE_CHAMP_PORTRAIT_REG));
         }
         else
         {
            this._giftDetailImage.setData(new GiftImageData(_loc1_.detailImageURL,ImageTypes.IMAGE_TYPE_CHAMP_SKIN));
         }
         this._giftDetailView.setData(_loc1_.giftDetailDisplayData);
         this._giftMessage.setText(_loc1_.giftMessage);
         this._doneButton.setText(_loc1_.buttonLabel);
         this.showComplete();
      }
      
      public function showComplete() : void
      {
         this.showButtons();
         setCurrentState("completeIn");
      }
      
      public function showError() : void
      {
         this.showButtons();
         setCurrentState("errorIn");
      }
      
      public function showOut() : void
      {
         setCurrentState("out");
         getCurrentTimelineAnimation().getCompleted().addOnce(this.hideButtons);
      }
      
      private function onButtonClick(param1:MouseEvent) : void
      {
         this._closeButton.removeEventListener(MouseEvent.CLICK,this.onButtonClick,false);
         this._doneButton.removeEventListener(MouseEvent.CLICK,this.onButtonClick,false);
         this.showOut();
         this._doneButtonClick.dispatch();
      }
      
      private function onInfoClick(param1:MouseEvent) : void
      {
         this._infoLinkClick.dispatch(this._displayData.errorData.errorInfoLink);
      }
      
      private function hideButtons() : void
      {
         this._closeButton.setVisible(false);
         this._doneButton.setVisible(false);
      }
      
      private function showButtons() : void
      {
         this._closeButton.setVisible(true);
         this._doneButton.setVisible(true);
      }
   }
}

