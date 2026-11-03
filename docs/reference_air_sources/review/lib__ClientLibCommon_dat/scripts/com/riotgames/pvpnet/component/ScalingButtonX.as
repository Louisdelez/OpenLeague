package com.riotgames.pvpnet.component
{
   import blix.assets.proxy.SpriteProxy;
   import blix.context.Context;
   import blix.view.behaviors.ScalingTransformBehavior;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ScalingButtonX extends AudioButton
   {
      
      private var _iconArt:SpriteProxy;
      
      private var _scalingBackground:SpriteProxy;
      
      public function ScalingButtonX(param1:Context, param2:String = null, param3:String = null)
      {
         super(param1,param2,param3);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = this._scalingBackground.setExplicitSize(param1,param2);
         this._iconArt.setExplicitPosition(Math.round((_loc3_.x - this._iconArt.getWidth()) / 2),Math.round((_loc3_.y - this._iconArt.getHeight()) / 2));
         return super.updateLayout(param1,param2);
      }
      
      override protected function createChildren() : void
      {
         this._scalingBackground = new SpriteProxy(this);
         setTimelineChildByName("background",this._scalingBackground);
         this._scalingBackground.setTransformBehavior(new ScalingTransformBehavior());
         this._iconArt = new SpriteProxy(this);
         setTimelineChildByName("iconArt",this._iconArt);
         super.createChildren();
      }
   }
}

