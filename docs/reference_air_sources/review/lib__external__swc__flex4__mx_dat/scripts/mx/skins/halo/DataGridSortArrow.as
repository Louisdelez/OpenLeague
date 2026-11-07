package mx.skins.halo
{
   import flash.display.Graphics;
   import mx.skins.ProgrammaticSkin;
   
   public class DataGridSortArrow extends ProgrammaticSkin
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function DataGridSortArrow()
      {
         super();
      }
      
      override public function get measuredWidth() : Number
      {
         return 6;
      }
      
      override public function get measuredHeight() : Number
      {
         return 6;
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         super.updateDisplayList(w,h);
         var g:Graphics = graphics;
         g.clear();
         g.beginFill(name == "sortArrowDisabled" ? uint(getStyle("disabledIconColor")) : uint(getStyle("iconColor")));
         g.moveTo(0,0);
         g.lineTo(w,0);
         g.lineTo(w / 2,h);
         g.lineTo(0,0);
         g.endFill();
      }
   }
}

