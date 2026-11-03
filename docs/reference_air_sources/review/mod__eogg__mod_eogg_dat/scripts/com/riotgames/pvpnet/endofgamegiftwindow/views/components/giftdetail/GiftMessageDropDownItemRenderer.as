package com.riotgames.pvpnet.endofgamegiftwindow.views.components.giftdetail
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.renderer.SelectableRenderer;
   import blix.context.IContext;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.GiftMessageDropDownItemData;
   
   public class GiftMessageDropDownItemRenderer extends SelectableRenderer
   {
      
      public static const DROP_DOWN_LINKAGE:String = "assets.DropDownItemRenderer";
      
      private var _rendererData:GiftMessageDropDownItemData;
      
      private var _itemText:TextFieldProxy;
      
      private var _isSelectable:Boolean;
      
      public function GiftMessageDropDownItemRenderer(param1:IContext)
      {
         super(param1);
         setLinkage(DROP_DOWN_LINKAGE);
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
      }
      
      override protected function createChildren() : void
      {
         this._itemText = new TextFieldProxy(this);
         setTimelineChildByName("textField",this._itemText);
         super.createChildren();
      }
      
      override public function setData(param1:*) : void
      {
         this._rendererData = GiftMessageDropDownItemData(param1);
         this.updateRenderer();
      }
      
      override public function getData() : *
      {
         return this._rendererData;
      }
      
      private function updateRenderer() : void
      {
         this._itemText.setText(this._rendererData.itemLabel);
         this._isSelectable = this._rendererData.isSelectable;
         if(!this._isSelectable)
         {
            _enabled = false;
         }
      }
   }
}

