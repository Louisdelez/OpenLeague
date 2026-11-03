package mx.skins.halo
{
   import flash.display.Graphics;
   import mx.skins.ProgrammaticSkin;
   
   public class ProgressMaskSkin extends ProgrammaticSkin
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
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
         g.drawRect(1,1,w - 2,h - 2);
         g.endFill();
      }
   }
}

