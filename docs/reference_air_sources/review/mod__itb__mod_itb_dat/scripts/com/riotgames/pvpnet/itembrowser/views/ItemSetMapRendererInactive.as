package com.riotgames.pvpnet.itembrowser.views
{
   import blix.assets.proxy.BitmapProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.renderer.IItemRenderer;
   import blix.context.IContext;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   
   public class ItemSetMapRendererInactive extends ButtonX implements IItemRenderer
   {
      
      private var _iconSizer:SpriteProxy;
      
      private var _iconBitmap:BitmapProxy;
      
      private var _iconContainer:SpriteProxy;
      
      private var _gameMap:GameMap;
      
      private var _index:uint = 0;
      
      private var _mapLabel:TextFieldProxy;
      
      public function ItemSetMapRendererInactive(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         setLinkage("ItemSetMapRenderer");
         setMouseEnabled(false);
         setMouseChildren(false);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = this._mapLabel.setExplicitSize(NaN,NaN);
         this._mapLabel.setExplicitPosition(NaN,this._iconSizer.getHeight() - _loc3_.y + 8);
         this._iconBitmap.setExplicitSize(this._iconSizer.getWidth(),this._iconSizer.getHeight());
         return _asset.getBounds(null);
      }
      
      private function setGameMap(param1:GameMap) : void
      {
         var _loc2_:BitmapData = null;
         if(this._gameMap != param1)
         {
            this._gameMap = param1;
            if(this._gameMap)
            {
               _loc2_ = ImagePackLookup.instance.getBitmapData("E_MAP_" + this._gameMap.mapId);
               if(!_loc2_)
               {
                  _loc2_ = ImagePackLookup.instance.getBitmapData("E_MAP_ERROR");
               }
               this._iconBitmap.setBitmapData(_loc2_);
               this._mapLabel.setText(this._gameMap.displayName);
            }
            else
            {
               this._iconBitmap.setBitmapData(null);
               this._mapLabel.setText("");
            }
         }
      }
      
      override public function setData(param1:*) : void
      {
         this.setGameMap(param1);
      }
      
      override public function getData() : *
      {
         return this._gameMap;
      }
      
      public function setIndex(param1:uint) : void
      {
         this._index = param1;
      }
      
      override protected function createChildren() : void
      {
         this._iconSizer = new SpriteProxy(this);
         setTimelineChildByName("iconSizer",this._iconSizer);
         this._iconContainer = new SpriteProxy(this);
         setTimelineChildByName("itemContainer",this._iconContainer);
         this._iconBitmap = new BitmapProxy(this);
         var _loc1_:ScalingTransformBehavior = new ScalingTransformBehavior();
         _loc1_.setMaintainAspectRatio(true);
         this._iconBitmap.setTransformBehavior(_loc1_);
         this._iconBitmap.setSmoothing(true);
         this._iconContainer.addChild(this._iconBitmap);
         this._mapLabel = new TextFieldProxy(this);
         setTimelineChildByName("textField",this._mapLabel);
         this._mapLabel.setAutoSize(TextFieldAutoSize.LEFT);
         this._mapLabel.getLayoutInvalidated().add(invalidateLayout);
         this._mapLabel.setMouseWheelEnabled(false);
         this._mapLabel.setVerticalScrollEnabled(false);
         super.createChildren();
      }
      
      public function getIndex() : uint
      {
         return this._index;
      }
   }
}

