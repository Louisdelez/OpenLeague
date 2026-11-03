package com.riotgames.platform.gameclient.skin.verticalscrollbar
{
   import flash.display.Graphics;
   import mx.skins.ProgrammaticSkin;
   
   public class ScrollDownArrowSkin extends ProgrammaticSkin
   {
      
      public function ScrollDownArrowSkin()
      {
         super();
      }
      
      override public function get measuredWidth() : Number
      {
         return 12;
      }
      
      override public function get measuredHeight() : Number
      {
         return 12;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:Number = -6;
         var _loc4_:Graphics = this.graphics;
         _loc4_.clear();
         _loc4_.moveTo(0 + _loc3_,0);
         _loc4_.beginFill(2763306);
         _loc4_.lineTo(7 + _loc3_,0);
         _loc4_.lineTo(3.5 + _loc3_,4);
         _loc4_.lineTo(0 + _loc3_,0);
      }
   }
}

