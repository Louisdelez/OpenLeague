package com.riotgames.platform.gameclient.skin.textinput
{
   import flash.display.Graphics;
   import flash.filters.DropShadowFilter;
   import mx.skins.ProgrammaticSkin;
   
   public class WhiteBorderSkin extends ProgrammaticSkin
   {
      
      public function WhiteBorderSkin()
      {
         super();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:Graphics = this.graphics;
         _loc3_.clear();
         _loc3_.beginFill(16777215);
         _loc3_.drawRoundRectComplex(0,0,param1,param2,3,3,3,3);
         var _loc4_:DropShadowFilter = new DropShadowFilter();
         _loc4_.alpha = 0.1;
         _loc4_.blurX = 0.1;
         _loc4_.blurY = 0.1;
         _loc4_.inner = true;
         _loc4_.quality = 3;
         this.filters = [_loc4_];
      }
   }
}

