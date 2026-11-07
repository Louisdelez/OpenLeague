package flexlib.scheduling.samples
{
   import flexlib.scheduling.scheduleClasses.layout.HorizontalLinesLayoutItem;
   import flexlib.scheduling.scheduleClasses.layout.IHorizontalLinesLayout;
   import flexlib.scheduling.scheduleClasses.lineRenderer.ILineRenderer;
   import flexlib.scheduling.scheduleClasses.viewers.HorizontalLinesViewer;
   
   public class AlternatingHorizontalLinesViewer extends HorizontalLinesViewer
   {
      
      public function AlternatingHorizontalLinesViewer()
      {
         super();
      }
      
      override protected function render(layout:IHorizontalLinesLayout) : void
      {
         var lineRenderer:ILineRenderer = null;
         var length:Number = NaN;
         var i:int = 0;
         var item:HorizontalLinesLayoutItem = null;
         var currentRow:Number = NaN;
         lineRenderer = super.getLineRendererForStyling();
         length = Number(layout.items.length);
         for(i = 0; i < length; i++)
         {
            item = layout.items[i];
            currentRow = Math.floor(item.y / layout.rowHeight);
            lineRenderer.weight = Boolean(currentRow % 2) ? 0 : 2;
            super.drawLineForItem(item,lineRenderer);
         }
      }
   }
}

