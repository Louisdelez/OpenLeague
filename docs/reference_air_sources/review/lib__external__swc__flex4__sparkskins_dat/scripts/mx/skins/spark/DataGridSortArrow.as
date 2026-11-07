package mx.skins.spark
{
   import flash.display.Graphics;
   import mx.skins.ProgrammaticSkin;
   
   public class DataGridSortArrow extends ProgrammaticSkin
   {
      
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
         var alpha:Number = name == "sortArrowDisabled" ? 0.5 : 1;
         g.clear();
         g.beginFill(getStyle("symbolColor"),alpha);
         g.moveTo(0,0);
         g.lineTo(w,0);
         g.lineTo(w / 2,h);
         g.lineTo(0,0);
         g.endFill();
      }
   }
}

