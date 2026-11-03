package mx.skins.spark
{
   import flash.display.Graphics;
   import mx.skins.ProgrammaticSkin;
   
   public class ProgressMaskSkin extends ProgrammaticSkin
   {
      
      public function ProgressMaskSkin()
      {
         super();
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         super.updateDisplayList(w,h);
         var g:Graphics = graphics;
         g.clear();
         g.beginFill(16776960);
         g.drawRect(2,1,w - 4,h - 2);
         g.endFill();
      }
   }
}

