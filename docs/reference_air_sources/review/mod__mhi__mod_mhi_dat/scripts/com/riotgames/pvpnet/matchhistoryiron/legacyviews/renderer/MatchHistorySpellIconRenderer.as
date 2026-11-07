package com.riotgames.pvpnet.matchhistoryiron.legacyviews.renderer
{
   import blix.assets.proxy.BitmapProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.context.IContext;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.domain.Spell;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class MatchHistorySpellIconRenderer extends SpriteProxy
   {
      
      private const REFERENCE_LINKAGE:String = "reference";
      
      private const ANCHOR_LINKAGE:String = "anchor";
      
      private var _icon:BitmapProxy;
      
      private var _iconReference:SpriteProxy;
      
      private var _anchor:SpriteProxy;
      
      public function MatchHistorySpellIconRenderer(param1:IContext)
      {
         super(param1,new Sprite());
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._icon = new BitmapProxy(this);
         this._icon.setTransformBehavior(new ScalingTransformBehavior());
         this._icon.setSmoothing(true);
         this._icon.getLayoutInvalidated().add(invalidateLayout);
         this._iconReference = new SpriteProxy(this);
         this._iconReference.getLayoutInvalidated().add(invalidateLayout);
         this._anchor = new SpriteProxy(this);
         setTimelineChildByName(this.REFERENCE_LINKAGE,this._iconReference);
         setTimelineChildByName(this.ANCHOR_LINKAGE,this._anchor);
         var _loc1_:Point = this._iconReference.setExplicitSize(NaN,NaN);
         this._icon.setWidth(_loc1_.x);
         this._icon.setHeight(_loc1_.y);
         this._anchor.addChild(this._icon);
      }
      
      public function loadSpellVisual(param1:Spell) : void
      {
         if(param1)
         {
            this._icon.setBitmapData(ImagePackLookup.instance.getSpellBitmap(param1).bitmapData);
         }
         else
         {
            this._icon.setBitmapData(null);
         }
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = this._iconReference.setExplicitSize(NaN,NaN);
         this._icon.setWidth(_loc3_.x);
         this._icon.setHeight(_loc3_.y);
         return super.updateLayout(param1,param2);
      }
   }
}

