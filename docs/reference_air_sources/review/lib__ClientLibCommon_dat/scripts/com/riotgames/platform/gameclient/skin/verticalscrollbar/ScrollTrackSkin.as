package com.riotgames.platform.gameclient.skin.verticalscrollbar
{
   import flash.display.Graphics;
   import mx.skins.ProgrammaticSkin;
   
   public class ScrollTrackSkin extends ProgrammaticSkin
   {
      
      public function ScrollTrackSkin()
      {
         super();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:Number = -9;
         var _loc4_:Number = 12;
         var _loc5_:Graphics = this.graphics;
         _loc5_.clear();
         _loc5_.lineStyle(1,1645082);
         _loc5_.moveTo(0 + _loc3_,0 + _loc4_ + 1);
         _loc5_.lineTo(0 + _loc3_,param2 - _loc4_ * 2 - 1);
      }
   }
}

