package com.riotgames.platform.gameclient.skin.image
{
   import flash.display.Bitmap;
   import mx.controls.Image;
   
   public class SmoothImage extends Image
   {
      
      public function SmoothImage()
      {
         super();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:Bitmap = null;
         super.updateDisplayList(param1,param2);
         if(content is Bitmap)
         {
            _loc3_ = Bitmap(content);
            if(Boolean(_loc3_) && _loc3_.smoothing == false)
            {
               _loc3_.smoothing = true;
            }
         }
      }
   }
}

