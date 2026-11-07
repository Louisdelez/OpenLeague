package com.riotgames.util.temp
{
   import blix.assets.proxy.SpriteProxy;
   import flash.display.GradientType;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.text.TextField;
   
   public class RainbowUtil
   {
      
      public function RainbowUtil()
      {
         super();
      }
      
      public static function create(param1:String = "", param2:int = 500, param3:int = 400) : SpriteProxy
      {
         var _loc4_:Number = 200;
         var _loc5_:Number = 100;
         var _loc6_:Shape = new Shape();
         _loc6_.x = (param2 - _loc4_) / 2;
         _loc6_.y = (param3 - _loc5_) / 2;
         _loc6_.graphics.lineStyle();
         var _loc7_:Matrix = new Matrix();
         _loc7_.createGradientBox(_loc4_,_loc5_);
         _loc6_.graphics.beginGradientFill(GradientType.LINEAR,[16711680,16776960,65280,65535,255,16711935,16711680],[1,1,1,1,1,1,1],[0,42,84,126,168,210,255],_loc7_);
         _loc6_.graphics.drawRect(0,0,_loc4_,_loc5_);
         _loc6_.graphics.endFill();
         var _loc8_:TextField = new TextField();
         _loc8_.x = _loc6_.x;
         _loc8_.y = _loc6_.y;
         _loc8_.width = _loc4_;
         _loc8_.height = _loc5_;
         _loc8_.text = param1;
         var _loc9_:Sprite = new Sprite();
         _loc9_.width = _loc4_;
         _loc9_.height = _loc5_;
         _loc9_.addChild(_loc6_);
         _loc9_.addChild(_loc8_);
         var _loc10_:SpriteProxy = new SpriteProxy(null,_loc9_);
         _loc10_.setWidth(param2);
         _loc10_.setHeight(param3);
         return _loc10_;
      }
   }
}

