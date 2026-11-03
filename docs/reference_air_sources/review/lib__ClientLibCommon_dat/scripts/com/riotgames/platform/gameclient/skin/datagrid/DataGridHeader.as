package com.riotgames.platform.gameclient.skin.datagrid
{
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   import mx.skins.halo.DataGridHeaderBackgroundSkin;
   import mx.styles.StyleManager;
   
   public class DataGridHeader extends DataGridHeaderBackgroundSkin
   {
      
      private var _borderAlpha:Number;
      
      private var _borderThickness:Number;
      
      public function DataGridHeader()
      {
         super();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:Graphics = graphics;
         _loc3_.clear();
         var _loc4_:Array = getStyle("headerColors");
         StyleManager.getColorNames(_loc4_);
         var _loc5_:Matrix = new Matrix();
         _loc5_.createGradientBox(param1,param2 + 1,Math.PI / 2,0,0);
         _loc4_ = [_loc4_[0],_loc4_[0],_loc4_[1]];
         var _loc6_:Array = [0,60,255];
         var _loc7_:Array = [1,1,1];
         _loc3_.beginGradientFill(GradientType.LINEAR,_loc4_,_loc7_,_loc6_,_loc5_);
         _loc3_.lineStyle(0,0,0);
         _loc3_.moveTo(0,0);
         _loc3_.lineTo(param1,0);
         _loc3_.lineTo(param1,param2 - 0.5);
         _loc3_.lineStyle(0,5542110,0.7);
         _loc3_.lineTo(0,param2 - 0.5);
         _loc3_.lineStyle(0,0,0);
         _loc3_.endFill();
      }
   }
}

