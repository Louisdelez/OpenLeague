package com.riotgames.pvpnet.endofgamegiftwindow.views.components
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.dropdown.DropDown;
   import blix.components.list.RendererFactory;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.pvpnet.endofgamegiftwindow.enums.ImageTypes;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.GiftImageData;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.IEndOfGameGiftDetailData;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.components.giftdetail.CustomMessageContainer;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.components.giftdetail.GiftDetailLayoutContainer;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.components.giftdetail.GiftMessageDropDownItemRenderer;
   import flash.text.TextFieldAutoSize;
   
   public class GiftDetailView extends StatefulView implements IGiftDetailView
   {
      
      private static const MESSAGE_DROP_DOWN_LIST_LINKAGE:String = "assets.DropDownDataList";
      
      private var _giftDetailData:IEndOfGameGiftDetailData;
      
      private var _giftImageLarge:GiftImageContainer;
      
      private var _giftDetailTitle:TextFieldProxy;
      
      private var _giftDetail:GiftDetailLayoutContainer;
      
      private var _messageDropDown:DropDown;
      
      private var _messageDropDownRenderFactory:RendererFactory;
      
      private var _customMessageContainer:CustomMessageContainer;
      
      private var _giftMessageField:TextFieldProxy;
      
      private var _senderNameField:TextFieldProxy;
      
      private var _onMessageChange:Signal;
      
      public function GiftDetailView(param1:IContext)
      {
         super(param1,null);
         this._onMessageChange = new Signal();
      }
      
      override protected function createChildren() : void
      {
         this._messageDropDownRenderFactory = new RendererFactory(GiftMessageDropDownItemRenderer,[this]);
         this._giftDetailTitle = new TextFieldProxy(this);
         this._giftDetailTitle.setAutoSize(TextFieldAutoSize.LEFT);
         this._giftDetailTitle.setMultiline(false);
         setTimelineChildByName("giftedPlayerNameField.textField",this._giftDetailTitle);
         this._giftImageLarge = new GiftImageContainer(this);
         setTimelineChildByName("giftImageContainer",this._giftImageLarge);
         this._giftDetail = new GiftDetailLayoutContainer(this);
         setTimelineChildByName("giftDetailLayout",this._giftDetail);
         this._messageDropDown = new DropDown(this);
         this._messageDropDown.setRendererFactory(this._messageDropDownRenderFactory);
         this._messageDropDown.setListLinkage(MESSAGE_DROP_DOWN_LIST_LINKAGE);
         this._messageDropDown.getSelectionBehavior().allowMultipleSelection = false;
         setTimelineChildByName("dropDown",this._messageDropDown);
         this._customMessageContainer = new CustomMessageContainer(this);
         setTimelineChildByName("customMessageText",this._customMessageContainer);
         this._giftMessageField = new TextFieldProxy(this);
         setTimelineChildByName("sentMessage.textField",this._giftMessageField);
         this._senderNameField = new TextFieldProxy(this);
         setTimelineChildByName("senderName.textField",this._senderNameField);
         this.gotoDefaultState();
         super.createChildren();
      }
      
      public function getData() : *
      {
         return this._giftDetailData;
      }
      
      public function setData(param1:*) : void
      {
         this._giftDetailData = IEndOfGameGiftDetailData(param1);
         this._giftDetailTitle.setText(this._giftDetailData.giftRecipientName + this._giftDetailData.giftDetailTitle);
         var _loc2_:String = ImageTypes.getImageTypeFromInventoryType(this._giftDetailData.itemInventoryType,ImageTypes.IMAGE_SIZE_REGULAR);
         this._giftImageLarge.setData(new GiftImageData(this._giftDetailData.detailImageURL,_loc2_));
         this._giftDetail.setData(this._giftDetailData.giftDetailDisplayData);
         this._customMessageContainer.setData(this._giftDetailData.customMessageConfig);
         this._messageDropDown.setLabelField(this._giftDetailData.giftDropDownLabel);
         this._messageDropDown.setNoneSelectedLabel(this._giftDetailData.giftDropDownNoneSelectedLabel);
         this._messageDropDown.setDataProvider(this._giftDetailData.giftDropDownDataProvider);
         this._messageDropDown.getSelectionBehavior().getSelectedItemsChanged().add(this.onDropDownSelectionChange);
      }
      
      public function setNewGiftMessage(param1:String, param2:String) : void
      {
         this._giftMessageField.setText(param1);
         this._senderNameField.setText(param2);
      }
      
      public function getOnUnlock() : ISignal
      {
         return this._giftDetail.getOnUnlock();
      }
      
      public function getOnMessageChange() : ISignal
      {
         return this._onMessageChange;
      }
      
      public function showConfirmGift() : void
      {
         this.gotoConfirmState();
      }
      
      public function showRevertSelection() : void
      {
         this.gotoDefaultState();
      }
      
      public function showOut() : void
      {
         this.gotoOutState();
      }
      
      override public function destroy() : void
      {
         this._messageDropDownRenderFactory.destroy();
         this._messageDropDownRenderFactory = null;
         super.destroy();
         this._giftDetailData = null;
         this._giftDetailTitle = null;
         this._giftImageLarge = null;
         this._giftDetail = null;
      }
      
      private function onDropDownSelectionChange() : void
      {
         var _loc1_:Object = this._messageDropDown.getSelectionBehavior().getSelectedItem();
         this._onMessageChange.dispatch(_loc1_);
      }
      
      private function gotoDefaultState() : void
      {
         setCurrentState("defaultState");
         this._giftDetail.hideUnlock();
      }
      
      private function gotoConfirmState() : void
      {
         setCurrentState("confirmState");
         this._giftDetail.showUnlock();
      }
      
      private function gotoOutState() : void
      {
         setCurrentState("outState");
         this._giftDetail.hideUnlock();
      }
   }
}

