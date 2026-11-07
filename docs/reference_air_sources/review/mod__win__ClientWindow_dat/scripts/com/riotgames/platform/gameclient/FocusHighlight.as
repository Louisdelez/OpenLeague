package com.riotgames.platform.gameclient
{
   import blix.assets.proxy.SpriteProxy;
   import blix.context.IContext;
   import blix.view.behaviors.ScalingTransformBehavior;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class FocusHighlight extends SpriteProxy
   {
      
      private var border:SpriteProxy;
      
      public function FocusHighlight(param1:IContext)
      {
         super(param1);
         setMouseEnabled(false);
         setMouseChildren(false);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.border = new SpriteProxy(this);
         this.border.setTransformBehavior(new ScalingTransformBehavior());
         setTimelineChildByName("border",this.border);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         if(isNaN(param1 || param2))
         {
            return _asset.getBounds(null);
         }
         var _loc3_:Point = getBounds(null).topLeft;
         this.border.setExplicitSize(param1 - _loc3_.x * 2,param2 - _loc3_.y * 2);
         return new Rectangle(0,0,param1,param1);
      }
   }
}

