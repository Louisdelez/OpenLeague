package flexlib.scheduling.scheduleClasses.utils
{
   import flash.display.Graphics;
   
   public class GraphicUtils
   {
      
      public function GraphicUtils()
      {
         super();
      }
      
      public static function drawDottedHorizontalLineTo(g:Graphics, y:Number, xStart:Number, xEnd:Number) : void
      {
         var x:Number = NaN;
         for(x = xStart; x < xEnd; x += 3)
         {
            if(x % 2 == 0)
            {
               g.lineTo(x + 3,y);
            }
            else
            {
               g.moveTo(x + 3,y);
            }
         }
      }
      
      public static function drawDottedVerticalLineTo(g:Graphics, x:Number, yStart:Number, yEnd:Number) : void
      {
         var y:Number = NaN;
         for(y = yStart; y < yEnd; y += 3)
         {
            if(y % 2 == 0)
            {
               g.lineTo(x,y + 3);
            }
            else
            {
               g.moveTo(x,y + 3);
            }
         }
      }
   }
}

