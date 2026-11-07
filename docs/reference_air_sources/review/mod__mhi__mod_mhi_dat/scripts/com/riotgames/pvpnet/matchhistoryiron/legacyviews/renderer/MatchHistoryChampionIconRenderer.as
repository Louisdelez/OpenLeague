package com.riotgames.pvpnet.matchhistoryiron.legacyviews.renderer
{
   import blix.assets.proxy.BitmapProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.context.IContext;
   import com.riotgames.platform.common.utils.ChampionIconCacheUtil;
   import com.riotgames.platform.gameclient.domain.Champion;
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   
   public class MatchHistoryChampionIconRenderer extends SpriteProxy
   {
      
      private const REFERENCE_LINKAGE:String = "reference";
      
      private const ANCHOR_LINKAGE:String = "anchor";
      
      private var _icon:BitmapProxy;
      
      private var _iconReference:SpriteProxy;
      
      private var _anchor:SpriteProxy;
      
      public function MatchHistoryChampionIconRenderer(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._icon = new BitmapProxy(this);
         this._icon.setSmoothing(true);
         this._icon.getLayoutInvalidated().add(invalidateLayout);
         this._iconReference = new SpriteProxy(this);
         this._iconReference.getLayoutInvalidated().add(invalidateLayout);
         this._anchor = new SpriteProxy(this);
         setTimelineChildByName(this.REFERENCE_LINKAGE,this._iconReference);
         setTimelineChildByName(this.ANCHOR_LINKAGE,this._anchor);
         this._anchor.addChild(this._icon);
      }
      
      public function loadChampionIcon(param1:Champion) : void
      {
         if(param1)
         {
            this.loadChampionIconBySkinName(param1.skinName);
         }
      }
      
      public function loadChampionIconBySkinName(param1:String) : void
      {
         var _loc2_:BitmapData = ChampionIconCacheUtil.instance.getIcon(param1);
         this._icon.setBitmapData(_loc2_);
         this._icon.setWidth(this._iconReference.getWidth());
         this._icon.setHeight(this._iconReference.getHeight());
         invalidateLayout();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._icon.setWidth(this._iconReference.getWidth());
         this._icon.setHeight(this._iconReference.getHeight());
         return new Rectangle(0,0,this._iconReference.getWidth(),this._iconReference.getHeight());
      }
   }
}

