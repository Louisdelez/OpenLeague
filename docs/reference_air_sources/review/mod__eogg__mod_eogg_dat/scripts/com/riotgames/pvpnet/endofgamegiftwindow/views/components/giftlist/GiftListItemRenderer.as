package com.riotgames.pvpnet.endofgamegiftwindow.views.components.giftlist
{
   import blix.assets.proxy.BitmapProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.renderer.ISelectableRenderer;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.ILayoutElement;
   import com.riotgames.pvpnet.endofgamegiftwindow.enums.ImageTypes;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.EndOfGameGift;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.GiftImageData;
   import com.riotgames.pvpnet.endofgamegiftwindow.utils.CurrencyUtils;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.components.GiftImageContainer;
   import flash.events.MouseEvent;
   
   public class GiftListItemRenderer extends StatefulView implements ISelectableRenderer, ILayoutElement
   {
      
      private static const GIFT_LIST_ITEM_RENDERDER_LINKAGE:String = "assets.GiftListItemRenderer";
      
      private static const RENDERER_WIDTH:Number = 208;
      
      private static const RENDERER_HEIGHT:Number = 64;
      
      private var _selectionRequested:Signal = new Signal();
      
      private var _selectionIndex:uint;
      
      private var _isSelected:Boolean = false;
      
      private var _isDisabled:Boolean = false;
      
      private var _dataObject:EndOfGameGift;
      
      private var _itemName:TextFieldProxy;
      
      private var _itemCost:TextFieldProxy;
      
      private var _currencyIconContainer:SpriteProxy;
      
      private var _currencyIcon:BitmapProxy;
      
      private var _giftIcon:GiftImageContainer;
      
      private var _mysteryGiftIcon:BitmapProxy;
      
      public function GiftListItemRenderer(param1:IContext)
      {
         super(param1,null);
         setLinkage(GIFT_LIST_ITEM_RENDERDER_LINKAGE);
         setExplicitSize(RENDERER_WIDTH,RENDERER_HEIGHT);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._mysteryGiftIcon = new BitmapProxy(this);
         setTimelineChildByName("mysteryIcon",this._mysteryGiftIcon);
         this._giftIcon = new GiftImageContainer(this);
         setTimelineChildByName("imageContainer",this._giftIcon);
         this._itemName = new TextFieldProxy(this);
         setTimelineChildByName("itemName",this._itemName);
         this._itemCost = new TextFieldProxy(this);
         setTimelineChildByName("itemCost",this._itemCost);
         this._currencyIconContainer = new SpriteProxy(this);
         setTimelineChildByName("rpIcon",this._currencyIconContainer);
         this._currencyIcon = new BitmapProxy(this);
      }
      
      public function getSelectionRequested() : ISignal
      {
         return this._selectionRequested;
      }
      
      public function getSelected() : Boolean
      {
         return this._isSelected;
      }
      
      public function setSelected(param1:Boolean) : void
      {
         if(!this._isDisabled)
         {
            this._isSelected = param1;
            if(this._isSelected)
            {
               this.goToSelected();
               this.onDisabled();
            }
            else
            {
               this.gotoUnselected();
               this.onEnabled();
            }
         }
      }
      
      public function getIndex() : uint
      {
         return this._selectionIndex;
      }
      
      public function setIndex(param1:uint) : void
      {
         this._selectionIndex = param1;
      }
      
      public function getData() : *
      {
         return this._dataObject;
      }
      
      public function setData(param1:*) : void
      {
         this._dataObject = EndOfGameGift(param1);
         this._currencyIcon.setLinkage(this.getCurrencyIconLinkage());
         this.updateRenderer();
      }
      
      override public function destroy() : void
      {
         this.clearDynamicChildren();
         this._giftIcon.destroy();
         this._giftIcon = null;
         this._itemCost.destroy();
         this._itemCost = null;
         this._currencyIcon.destroy();
         this._currencyIcon = null;
         this._currencyIconContainer.destroy();
         this._currencyIconContainer = null;
         super.destroy();
      }
      
      private function updateRenderer() : void
      {
         this.clearDynamicChildren();
         var _loc1_:String = ImageTypes.getImageTypeFromInventoryType(this._dataObject.itemInventoryType,ImageTypes.IMAGE_SIZE_ICON);
         if(_loc1_ == ImageTypes.IMAGE_TYPE_MYSTERY_ICON)
         {
            this._mysteryGiftIcon.setVisible(true);
            this._giftIcon.setVisible(false);
         }
         else
         {
            this._mysteryGiftIcon.setVisible(false);
            this._giftIcon.setVisible(true);
            this._giftIcon.setData(new GiftImageData(this._dataObject.iconURL,_loc1_));
         }
         if(!this._isDisabled && !this._isSelected)
         {
            this.onEnabled();
         }
         this._itemName.setText(this._dataObject.itemName);
         this._itemCost.setText(this._dataObject.itemCost.toString());
         this._currencyIconContainer.addChild(this._currencyIcon);
      }
      
      private function clearDynamicChildren() : void
      {
         this._giftIcon.removeAllChildren();
         this._currencyIconContainer.removeAllChildren();
      }
      
      private function getCurrencyIconLinkage() : String
      {
         return CurrencyUtils.getCurrencyIconLinkageByCurrencyType(this._dataObject.currencyType);
      }
      
      private function onEnabled() : void
      {
         addEventListener(MouseEvent.CLICK,this.onGiftDisplayClicked);
         addEventListener(MouseEvent.MOUSE_OVER,this.onGiftDisplayOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onGiftDisplayOut);
         setUseHandCursor(true);
      }
      
      private function onDisabled() : void
      {
         removeEventListener(MouseEvent.CLICK,this.onGiftDisplayClicked);
         removeEventListener(MouseEvent.MOUSE_OVER,this.onGiftDisplayOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.onGiftDisplayOut);
         setUseHandCursor(false);
      }
      
      private function onGiftDisplayClicked(param1:MouseEvent) : void
      {
         this.goToSelected();
         this.onDisabled();
         this._selectionRequested.dispatch(this,false,false);
      }
      
      private function onGiftDisplayOver(param1:MouseEvent) : void
      {
         this.gotoOver();
      }
      
      public function onGiftDisplayOut(param1:MouseEvent) : void
      {
         this.gotoUnselected();
      }
      
      private function goToSelected() : void
      {
         setCurrentState("selectedUp");
      }
      
      private function gotoUnselected() : void
      {
         setCurrentState("up");
      }
      
      private function gotoOver() : void
      {
         setCurrentState("over");
      }
      
      private function gotoDisabled() : void
      {
         setCurrentState("disabled");
      }
   }
}

