package mx.skins.halo
{
   import flash.display.Graphics;
   import mx.core.mx_internal;
   import mx.skins.ProgrammaticSkin;
   
   use namespace mx_internal;
   
   public class ProgressMaskSkin extends ProgrammaticSkin
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
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

