package mx.skins.halo
{
   import flash.display.Graphics;
   import mx.skins.ProgrammaticSkin;
   
   public class DataGridHeaderSeparator extends ProgrammaticSkin
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
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

