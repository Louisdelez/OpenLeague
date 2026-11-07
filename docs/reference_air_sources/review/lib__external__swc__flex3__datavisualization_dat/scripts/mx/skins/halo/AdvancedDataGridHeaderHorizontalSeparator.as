package mx.skins.halo
{
   import flash.display.Graphics;
   import mx.skins.ProgrammaticSkin;
   
   public class AdvancedDataGridHeaderHorizontalSeparator extends ProgrammaticSkin
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      public function AdvancedDataGridHeaderHorizontalSeparator()
      {
         super();
      }
      
      override public function get measuredWidth() : Number
      {
         return 10;
      }
      
      override public function get measuredHeight() : Number
      {
         return 2;
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         super.updateDisplayList(w,h);
         var g:Graphics = graphics;
         g.clear();
         g.moveTo(0,0);
         g.lineTo(w,0);
         g.lineStyle(1,getStyle("borderColor"));
         g.moveTo(0,1);
         g.lineTo(w,1);
      }
   }
}

