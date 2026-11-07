package com.riotgames.pvpnet.endofgamegiftwindow.views.components.giftdetail
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.renderer.IDataRenderer;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.GiftTitleData;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   
   public class GiftTitleView extends StatefulView implements IDataRenderer
   {
      
      private static const TITLE_VERTICAL_PADDING:Number = 4;
      
      private var _itemTitle:TextFieldProxy;
      
      private var _itemSubtitle:TextFieldProxy;
      
      private var _displayData:GiftTitleData;
      
      public function GiftTitleView(param1:IContext)
      {
         super(param1,null);
      }
      
      override protected function createChildren() : void
      {
         this._itemTitle = new TextFieldProxy(this);
         this._itemTitle.setEmbedFonts(true);
         setTimelineChildByName("itemTitle",this._itemTitle);
         this._itemSubtitle = new TextFieldProxy(this);
         this._itemSubtitle.setEmbedFonts(true);
         setTimelineChildByName("itemSubTitle",this._itemSubtitle);
         super.createChildren();
      }
      
      public function getData() : *
      {
         return this._displayData;
      }
      
      public function setData(param1:*) : void
      {
         this._displayData = GiftTitleData(param1);
         this.redrawView();
      }
      
      override public function destroy() : void
      {
         this._displayData = null;
         this._itemTitle = null;
         this._itemSubtitle = null;
         super.destroy();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         if(this._itemSubtitle.getText() != "")
         {
            this._itemSubtitle.setY(this._itemTitle.getY() + this._itemTitle.getTextHeight() + TITLE_VERTICAL_PADDING);
         }
         return super.updateLayout(param1,param2);
      }
      
      private function redrawView() : void
      {
         this.drawChampLayout();
         invalidateLayout();
      }
      
      private function drawChampLayout() : void
      {
         setCurrentState("stateChampion");
         this._itemTitle.setAutoSize(TextFieldAutoSize.LEFT);
         this._itemTitle.setMultiline(true);
         this._itemTitle.setWordWrap(true);
         this._itemTitle.setText(this._displayData.giftTitleText);
         this._itemSubtitle.setAutoSize(TextFieldAutoSize.LEFT);
         this._itemSubtitle.setMultiline(false);
         this._itemSubtitle.setText(this._displayData.giftSubTitleText);
      }
      
      private function drawItemLayout() : void
      {
         setCurrentState("stateItem");
      }
   }
}

