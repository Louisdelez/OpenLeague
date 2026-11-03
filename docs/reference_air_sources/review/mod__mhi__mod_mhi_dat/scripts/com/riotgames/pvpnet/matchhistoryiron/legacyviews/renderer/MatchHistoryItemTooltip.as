package com.riotgames.pvpnet.matchhistoryiron.legacyviews.renderer
{
   import blix.assets.proxy.BitmapProxy;
   import blix.assets.proxy.MovieClipProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.renderer.IDataRenderer;
   import blix.context.IContext;
   import com.riotgames.gameItems.model.GameItem;
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.views.icons.IItemIconRenderer;
   import com.riotgames.pvpnet.matchhistoryiron.util.ItemStyles;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   
   public class MatchHistoryItemTooltip extends SpriteProxy implements IDataRenderer
   {
      
      private const BACKGROUND_GAP:int = 75;
      
      private var _nameTexfField:TextFieldProxy;
      
      private var _priceTexfField:TextFieldProxy;
      
      private var _descriptionTexfField:TextFieldProxy;
      
      private var _itemRenderer:IItemIconRenderer;
      
      private var _iconAnchor:SpriteProxy;
      
      private var _iconReference:SpriteProxy;
      
      private var _icon:BitmapProxy;
      
      protected var _background:MovieClipProxy;
      
      public function MatchHistoryItemTooltip(param1:IContext)
      {
         super(param1);
         setLinkage("itemTooltip");
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._nameTexfField = new TextFieldProxy(this);
         this._priceTexfField = new TextFieldProxy(this);
         this._descriptionTexfField = new TextFieldProxy(this);
         this._descriptionTexfField.setAutoSize(TextFieldAutoSize.LEFT);
         this._descriptionTexfField.getLayoutInvalidated().add(invalidateLayout);
         this._descriptionTexfField.setStyleSheet(ItemStyles.getInstance().itemDescriptionStylesheet);
         this._icon = new BitmapProxy(this);
         this._icon.setSmoothing(true);
         this._iconAnchor = new SpriteProxy(this);
         this._iconReference = new SpriteProxy(this);
         this._iconReference.getLayoutInvalidated().add(invalidateLayout);
         this._icon.getLayoutInvalidated().add(invalidateLayout);
         this._background = new MovieClipProxy(this);
         this._iconAnchor.addChild(this._icon);
         setTimelineChildByName("background",this._background);
         this.setTimelineChildrenByName();
      }
      
      private function setTimelineChildrenByName() : void
      {
         setTimelineChildByName("nameText",this._nameTexfField);
         setTimelineChildByName("costText",this._priceTexfField);
         setTimelineChildByName("description",this._descriptionTexfField);
         setTimelineChildByName("itemContainer",this._iconAnchor);
         setTimelineChildByName("iconSizer",this._iconReference);
      }
      
      private function setIcon(param1:GameItem) : void
      {
         this._icon.setBitmapData(ImagePackLookup.instance.getBitmapData("e_" + param1.icon.substring(0,param1.icon.length - 4)));
      }
      
      public function getData() : *
      {
         return null;
      }
      
      public function setData(param1:*) : void
      {
         var _loc2_:GameItem = param1 as GameItem;
         if(_loc2_)
         {
            this._nameTexfField.setText(_loc2_.name);
            this.setIcon(_loc2_);
            this._priceTexfField.setText(_loc2_.totalPrice.toString());
            this._descriptionTexfField.setHtmlText("<font face=\'ApplicationFont2\'>" + _loc2_.description + "</font>");
         }
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         super.updateLayout(param1,param2);
         this._background.setHeight(this.BACKGROUND_GAP + this._descriptionTexfField.getHeight());
         this._icon.setWidth(this._iconReference.getWidth());
         this._icon.setHeight(this._iconReference.getHeight());
         return new Rectangle(0,0,this._background.getWidth(),this._background.getHeight());
      }
   }
}

