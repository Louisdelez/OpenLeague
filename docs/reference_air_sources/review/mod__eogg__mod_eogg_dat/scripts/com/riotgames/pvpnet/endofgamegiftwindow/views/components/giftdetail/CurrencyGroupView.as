package com.riotgames.pvpnet.endofgamegiftwindow.views.components.giftdetail
{
   import blix.assets.proxy.BitmapProxy;
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.renderer.IDataRenderer;
   import blix.context.IContext;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.GiftCurrencyData;
   import com.riotgames.pvpnet.endofgamegiftwindow.utils.CurrencyUtils;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   
   public class CurrencyGroupView extends SpriteProxy implements IDataRenderer
   {
      
      public static const CURRENCY_AMOUNT_PADDING:Number = 4;
      
      private var _currencyData:GiftCurrencyData;
      
      private var _currencyName:TextFieldProxy;
      
      private var _currencyAmount:TextFieldProxy;
      
      private var _currencyIconContainer:DisplayObjectContainerProxy;
      
      private var _currencyIcon:BitmapProxy;
      
      public function CurrencyGroupView(param1:IContext)
      {
         super(param1,null);
      }
      
      override protected function createChildren() : void
      {
         this._currencyName = new TextFieldProxy(this);
         this._currencyName.setEmbedFonts(true);
         this._currencyName.setAutoSize(TextFieldAutoSize.LEFT);
         this._currencyName.setMultiline(false);
         setTimelineChildByName("currencyName",this._currencyName);
         this._currencyAmount = new TextFieldProxy(this);
         this._currencyAmount.setEmbedFonts(true);
         this._currencyAmount.setAutoSize(TextFieldAutoSize.LEFT);
         this._currencyAmount.setMultiline(false);
         setTimelineChildByName("currencyAmount",this._currencyAmount);
         this._currencyIconContainer = new DisplayObjectContainerProxy(this);
         setTimelineChildByName("currencyIconContainer",this._currencyIconContainer);
         this._currencyIcon = new BitmapProxy(this);
         super.createChildren();
      }
      
      public function getData() : *
      {
         return this._currencyData;
      }
      
      public function setData(param1:*) : void
      {
         this._currencyData = GiftCurrencyData(param1);
         this.updateDisplay();
      }
      
      override public function destroy() : void
      {
         this._currencyData = null;
         this._currencyName = null;
         this._currencyAmount = null;
         this._currencyIconContainer = null;
         this._currencyIcon = null;
         super.destroy();
      }
      
      private function updateDisplay() : void
      {
         if(!this._currencyData.showCurrencyGroup)
         {
            setVisible(false);
            return;
         }
         this._currencyName.setText(this._currencyData.currencyName);
         this._currencyAmount.setText(this._currencyData.currencyAmount.toString());
         invalidateLayout();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._currencyIconContainer.setX(this._currencyAmount.getX() + this._currencyAmount.getTextWidth() + CURRENCY_AMOUNT_PADDING);
         return super.updateLayout(param1,param2);
      }
      
      private function getCurrencyIconLinkage() : String
      {
         return CurrencyUtils.getCurrencyIconLinkageByCurrencyType(this._currencyData.currencyType);
      }
   }
}

