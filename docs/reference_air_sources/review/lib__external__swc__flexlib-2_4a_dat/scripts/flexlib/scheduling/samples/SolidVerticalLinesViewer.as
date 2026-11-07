package flexlib.scheduling.samples
{
   import flexlib.scheduling.scheduleClasses.layout.IVerticalLinesLayout;
   import flexlib.scheduling.scheduleClasses.layout.VerticalLinesLayoutItem;
   import flexlib.scheduling.scheduleClasses.lineRenderer.ILineRenderer;
   import flexlib.scheduling.scheduleClasses.lineRenderer.LineRenderer;
   import flexlib.scheduling.scheduleClasses.viewers.VerticalLinesViewer;
   
   public class SolidVerticalLinesViewer extends VerticalLinesViewer
   {
      
      public function SolidVerticalLinesViewer()
      {
         super();
      }
      
      override protected function render(layout:IVerticalLinesLayout) : void
      {
         var lineRenderer:ILineRenderer = null;
         var item:VerticalLinesLayoutItem = null;
         lineRenderer = new LineRenderer();
         lineRenderer.weight = verticalGridLineThickness;
         lineRenderer.color = verticalGridLineColor;
         lineRenderer.alpha = verticalGridLineAlpha;
         for each(item in layout.items)
         {
            super.drawLineForItem(item,lineRenderer);
         }
      }
   }
}

