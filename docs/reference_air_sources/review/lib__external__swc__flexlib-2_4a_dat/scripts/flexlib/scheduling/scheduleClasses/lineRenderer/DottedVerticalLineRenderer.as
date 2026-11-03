package flexlib.scheduling.scheduleClasses.lineRenderer
{
   import flash.display.Graphics;
   import flexlib.scheduling.scheduleClasses.utils.GraphicUtils;
   
   public class DottedVerticalLineRenderer extends Line implements ILineRenderer
   {
      
      public function DottedVerticalLineRenderer()
      {
         super();
      }
      
      public function drawTo(g:Graphics, x:Number, y:Number) : void
      {
         GraphicUtils.drawDottedVerticalLineTo(g,x,0,y);
      }
      
      public function moveTo(g:Graphics, x:Number, y:Number) : void
      {
         g.moveTo(x,y);
      }
   }
}

