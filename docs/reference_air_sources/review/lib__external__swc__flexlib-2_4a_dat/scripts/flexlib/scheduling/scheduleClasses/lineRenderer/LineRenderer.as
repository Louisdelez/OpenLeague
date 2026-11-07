package flexlib.scheduling.scheduleClasses.lineRenderer
{
   import flash.display.Graphics;
   
   public class LineRenderer extends Line implements ILineRenderer
   {
      
      public function LineRenderer()
      {
         super();
      }
      
      public function drawTo(g:Graphics, x:Number, y:Number) : void
      {
         g.lineTo(x,y);
      }
      
      public function moveTo(g:Graphics, x:Number, y:Number) : void
      {
         g.moveTo(x,y);
      }
   }
}

