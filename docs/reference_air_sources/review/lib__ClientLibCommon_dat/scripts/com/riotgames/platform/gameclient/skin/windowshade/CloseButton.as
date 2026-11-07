package com.riotgames.platform.gameclient.skin.windowshade
{
   import flash.display.Graphics;
   import mx.skins.ProgrammaticSkin;
   
   public class CloseButton extends ProgrammaticSkin
   {
      
      public function CloseButton()
      {
         super();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:Graphics = this.graphics;
         _loc3_.clear();
         _loc3_.moveTo(0,-6);
         _loc3_.beginFill(9408658);
         _loc3_.lineTo(0,2);
         _loc3_.lineTo(6,-2);
         _loc3_.lineTo(0,-6);
         _loc3_.endFill();
      }
   }
}

