package com.riotgames.pvpnet.endofgamegiftwindow.views.components.giftdetail
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.renderer.IDataRenderer;
   import blix.context.IContext;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.GiftRecipientData;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   
   public class RecipientLineView extends SpriteProxy implements IDataRenderer
   {
      
      private static const SALUTATION_HORIZONTAL_PADDING:Number = 4;
      
      private var _recipientData:GiftRecipientData;
      
      private var _toField:TextFieldProxy;
      
      private var _recipientName:TextFieldProxy;
      
      public function RecipientLineView(param1:IContext)
      {
         super(param1,null);
      }
      
      override protected function createChildren() : void
      {
         this._toField = new TextFieldProxy(this);
         this._toField.setEmbedFonts(true);
         this._toField.setAutoSize(TextFieldAutoSize.LEFT);
         this._toField.setMultiline(false);
         setTimelineChildByName("toText",this._toField);
         this._recipientName = new TextFieldProxy(this);
         this._recipientName.setEmbedFonts(true);
         this._recipientName.setAutoSize(TextFieldAutoSize.LEFT);
         this._recipientName.setMultiline(false);
         setTimelineChildByName("recipientName",this._recipientName);
         super.createChildren();
      }
      
      public function getData() : *
      {
         return this._recipientData;
      }
      
      public function setData(param1:*) : void
      {
         this._recipientData = GiftRecipientData(param1);
         this.updateView();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._recipientName.setX(this._toField.getX() + this._toField.getTextWidth() + SALUTATION_HORIZONTAL_PADDING);
         return super.updateLayout(param1,param2);
      }
      
      override public function destroy() : void
      {
         this._recipientData = null;
         this._toField = null;
         this._recipientName = null;
         super.destroy();
      }
      
      private function updateView() : void
      {
         this._toField.setText(this._recipientData.toFieldText);
         this._recipientName.setText(this._recipientData.recipientName);
         invalidateLayout();
      }
   }
}

