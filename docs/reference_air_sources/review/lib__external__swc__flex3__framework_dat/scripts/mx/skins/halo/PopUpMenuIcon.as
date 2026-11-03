package mx.skins.halo
{
   import flash.display.Graphics;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class PopUpMenuIcon extends PopUpIcon
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function PopUpMenuIcon()
      {
         super();
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         super.updateDisplayList(w,h);
         var g:Graphics = graphics;
         g.clear();
         g.lineStyle(1,mx_internal::arrowColor);
         g.moveTo(0,0);
         g.lineTo(w / 2,height);
         g.lineTo(w,0);
      }
   }
}

