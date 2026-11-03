package com.riotgames.platform.gameclient.skin
{
   import flash.display.Graphics;
   import mx.skins.ProgrammaticSkin;
   
   public class MinimizeButton extends ProgrammaticSkin
   {
      
      public function MinimizeButton()
      {
         super();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:Graphics = this.graphics;
         _loc3_.clear();
         _loc3_.lineStyle(2,8421504);
         _loc3_.moveTo(0,8);
         _loc3_.lineTo(9,8);
      }
   }
}

