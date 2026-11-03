package mx.skins.halo
{
   import flash.display.Graphics;
   import mx.core.mx_internal;
   import mx.skins.ProgrammaticSkin;
   
   use namespace mx_internal;
   
   public class PopUpIcon extends ProgrammaticSkin
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      mx_internal var arrowColor:uint = 1118481;
      
      public function PopUpIcon()
      {
         super();
      }
      
      override public function get measuredWidth() : Number
      {
         return 6;
      }
      
      override public function get measuredHeight() : Number
      {
         return 4;
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         super.updateDisplayList(w,h);
         var g:Graphics = graphics;
         g.clear();
         g.beginFill(mx_internal::arrowColor);
         g.moveTo(w / 2,height);
         g.lineTo(0,0);
         g.lineTo(w,0);
         g.lineTo(w / 2,h);
         g.endFill();
      }
   }
}

