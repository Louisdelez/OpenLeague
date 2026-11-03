package mx.skins.halo
{
   import flash.display.Graphics;
   import mx.core.mx_internal;
   import mx.skins.ProgrammaticSkin;
   
   use namespace mx_internal;
   
   public class DataGridHeaderSeparator extends ProgrammaticSkin
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function DataGridHeaderSeparator()
      {
         super();
      }
      
      override public function get measuredWidth() : Number
      {
         return 2;
      }
      
      override public function get measuredHeight() : Number
      {
         return 10;
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         super.updateDisplayList(w,h);
         var g:Graphics = graphics;
         g.clear();
         g.lineStyle(1,16777215,0.5);
         g.moveTo(0,0);
         g.lineTo(0,h);
         g.lineStyle(1,getStyle("borderColor"));
         g.moveTo(1,0);
         g.lineTo(1,h);
      }
   }
}

