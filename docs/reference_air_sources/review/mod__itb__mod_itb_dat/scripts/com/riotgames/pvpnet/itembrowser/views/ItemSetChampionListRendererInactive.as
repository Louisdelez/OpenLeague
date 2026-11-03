package com.riotgames.pvpnet.itembrowser.views
{
   import blix.assets.proxy.BitmapProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.renderer.IItemRenderer;
   import blix.context.Context;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.common.utils.ChampionIconCacheUtil;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetChampion;
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   
   public class ItemSetChampionListRendererInactive extends ButtonX implements IItemRenderer
   {
      
      private var _iconBitmap:BitmapProxy;
      
      private var _champion:ItemSetChampion;
      
      private var _iconContainer:SpriteProxy;
      
      private var _championLabel:TextFieldProxy;
      
      private var _index:uint;
      
      private var _iconSizer:SpriteProxy;
      
      public function ItemSetChampionListRendererInactive(param1:Context)
      {
         super(param1);
         setLinkage("ChampionListRenderer");
         setMouseEnabled(false);
         setMouseChildren(false);
      }
      
      override public function getData() : *
      {
         return this._champion;
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._iconBitmap.setExplicitSize(this._iconSizer.getWidth(),this._iconSizer.getHeight());
         return _asset.getBounds(null);
      }
      
      override public function setData(param1:*) : void
      {
         this.setChampion(param1);
      }
      
      public function setChampion(param1:ItemSetChampion) : void
      {
         var _loc2_:BitmapData = null;
         if(this._champion != param1)
         {
            this._champion = param1;
            if(Boolean(this._champion) && Boolean(this._champion.getChampion()) && Boolean(this._champion.getChampion()))
            {
               _loc2_ = ChampionIconCacheUtil.instance.getIcon(this._champion.getChampion().skinName);
               this._iconBitmap.setBitmapData(_loc2_);
               this._championLabel.setText(this._champion.getChampion().displayName);
            }
            else
            {
               this._iconBitmap.setBitmapData(null);
               this._championLabel.setText("");
            }
         }
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
         this._iconContainer.getLayoutInvalidated().add(invalidateLayout);
         this._championLabel = new TextFieldProxy(this);
         setTimelineChildByName("textField",this._championLabel);
      }
      
      public function getIndex() : uint
      {
         return this._index;
      }
   }
}

