package com.riotgames.pvpnet.runes.views.common
{
   import blix.assets.proxy.BitmapProxy;
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.layout.vo.Padding;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.gameclient.domain.ItemEffect;
   import com.riotgames.platform.gameclient.domain.Rune;
   import com.riotgames.platform.gameclient.domain.RuneType;
   import com.riotgames.pvpnet.runes.util.RuneImageCache;
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   
   public class RuneImageRenderer extends StatefulView
   {
      
      private var runeBitmap:BitmapProxy;
      
      private var runeImageSizer:SpriteProxy;
      
      private var _rune:Rune;
      
      private var _runeImageCache:RuneImageCache;
      
      private var _runeEffectGlowActive:Boolean = false;
      
      private var _mouseoverGlow:Boolean = false;
      
      public function RuneImageRenderer(param1:IContext)
      {
         super(param1);
         setCurrentState("noglow");
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this._runeImageCache = getDependency(RuneImageCache);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:DisplayObjectContainerProxy = new DisplayObjectContainerProxy(this);
         setTimelineChildByName("imageGlow.imageContainer",_loc1_);
         this.runeBitmap = new BitmapProxy(this);
         this.runeBitmap.setTransformBehavior(new ScalingTransformBehavior());
         this.runeBitmap.setSmoothing(true);
         this.runeBitmap.getLayoutInvalidated().add(invalidateLayout);
         _loc1_.addChild(this.runeBitmap);
      }
      
      public function setRuneEffectGlowActive(param1:Boolean) : void
      {
         if(param1 == this._runeEffectGlowActive)
         {
            return;
         }
         this._runeEffectGlowActive = param1;
         this.refreshState();
      }
      
      public function setRune(param1:Rune) : void
      {
         if(this._rune == param1)
         {
            return;
         }
         this._rune = param1;
         if(param1 != null)
         {
            this._runeImageCache.loadBitmapByRune(param1,this.onRuneBitmapLoaded);
         }
         else
         {
            this.onRuneBitmapLoaded(null);
         }
      }
      
      private function onRuneBitmapLoaded(param1:BitmapData) : void
      {
         this.runeBitmap.setBitmapData(param1);
         this.refreshState();
      }
      
      public function getRune() : Rune
      {
         return this._rune;
      }
      
      public function setMouseoverGlowActive(param1:Boolean) : void
      {
         this._mouseoverGlow = param1;
         this.refreshState();
      }
      
      public function setSizer(param1:SpriteProxy) : void
      {
         this.runeImageSizer = param1;
         invalidateLayout();
      }
      
      public function refreshState() : void
      {
         var _loc1_:ItemEffect = null;
         var _loc2_:String = null;
         if(Boolean(this._rune) && Boolean(this._rune.itemEffects) && this._rune.itemEffects.length > 0)
         {
            if(this._runeEffectGlowActive)
            {
               _loc1_ = this._rune.itemEffects[0] as ItemEffect;
               if(!_loc1_)
               {
                  setCurrentState("noglow");
                  return;
               }
               _loc2_ = Boolean(getMouseIsOver()) && this._mouseoverGlow ? "Over" : "";
               switch(_loc1_.effectType)
               {
                  case RuneType.RED_RUNE:
                     setCurrentState("mark" + _loc2_);
                     break;
                  case RuneType.BLUE_RUNE:
                     setCurrentState("glyph" + _loc2_);
                     break;
                  case RuneType.YELLOW_RUNE:
                     setCurrentState("seal" + _loc2_);
                     break;
                  case RuneType.BLACK_RUNE:
                     setCurrentState("quint" + _loc2_);
               }
            }
         }
      }
      
      public function getImage() : BitmapProxy
      {
         return this.runeBitmap;
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Padding = null;
         if(this.runeImageSizer)
         {
            _loc3_ = Number(this.runeImageSizer.getX());
            _loc4_ = Number(this.runeImageSizer.getY());
            _loc5_ = Number(this.runeImageSizer.getWidth());
            _loc6_ = Number(this.runeImageSizer.getHeight());
            _loc7_ = this.generatePaddingByRuneAndState();
            this.runeBitmap.setExplicitSize(_loc5_ * (1 + _loc7_.left + _loc7_.right),_loc6_ * (1 + _loc7_.top + _loc7_.bottom));
            this.runeBitmap.setExplicitPosition(_loc3_ - _loc5_ * _loc7_.left,_loc4_ - _loc6_ * _loc7_.top);
         }
         return super.updateLayout(param1,param2);
      }
      
      private function generatePaddingByRuneAndState() : Padding
      {
         var _loc1_:Padding = new Padding();
         if(Boolean(this._rune) && Boolean(this._rune.runeType) && this._rune.runeType.runeTypeId == RuneType.BLACK_RUNE)
         {
            _loc1_.top = 35 / 306;
            _loc1_.right = 60 / 318;
            _loc1_.bottom = 37 / 306;
            _loc1_.left = 60 / 318;
         }
         else
         {
            _loc1_.top = 2 / 242;
            _loc1_.right = 5 / 215;
            _loc1_.bottom = 3 / 242;
            _loc1_.left = 6 / 215;
         }
         return _loc1_;
      }
      
      override protected function setMouseIsOver(param1:Boolean) : void
      {
         super.setMouseIsOver(param1);
         this.refreshState();
      }
      
      public function setMouseOver(param1:Boolean) : void
      {
         this.setMouseIsOver(param1);
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
   }
}

