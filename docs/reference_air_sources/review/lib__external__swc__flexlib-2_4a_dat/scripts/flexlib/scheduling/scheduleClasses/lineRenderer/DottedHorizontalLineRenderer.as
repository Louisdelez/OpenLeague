package flexlib.scheduling.scheduleClasses.lineRenderer
{
   import flash.display.Graphics;
   import flexlib.scheduling.scheduleClasses.utils.GraphicUtils;
   
   public class DottedHorizontalLineRenderer extends Line implements ILineRenderer
   {
      
      public function DottedHorizontalLineRenderer()
      {
         super();
      }
      
      public function drawTo(g:Graphics, x:Number, y:Number) : void
      {
         GraphicUtils.drawDottedHorizontalLineTo(g,y,0,x);
      }
      
      public function moveTo(g:Graphics, x:Number, y:Number) : void
      {
         g.moveTo(x,y);
      }
   }
}

