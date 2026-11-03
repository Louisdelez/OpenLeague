package flexlib.scheduling.scheduleClasses.viewers
{
   import flexlib.scheduling.scheduleClasses.layout.IVerticalLinesLayout;
   import flexlib.scheduling.scheduleClasses.layout.LayoutUpdateEvent;
   import flexlib.scheduling.scheduleClasses.layout.VerticalLinesLayoutItem;
   import flexlib.scheduling.scheduleClasses.lineRenderer.DottedVerticalLineRenderer;
   import flexlib.scheduling.scheduleClasses.lineRenderer.ILineRenderer;
   import flexlib.scheduling.scheduleClasses.lineRenderer.LineRenderer;
   import mx.core.UIComponent;
   
   public class VerticalLinesViewer extends UIComponent implements IVerticalLinesViewer
   {
      
      private var _verticalGridLineColor:uint;
      
      private var _dottedGridLines:Boolean;
      
      private var _verticalGridLineAlpha:Number;
      
      private var layout:IVerticalLinesLayout;
      
      private var _verticalGridLineThickness:Number;
      
      public function VerticalLinesViewer()
      {
         super();
      }
      
      protected function getLineRendererForStyling() : ILineRenderer
      {
         var lineRenderer:ILineRenderer = null;
         if(dottedGridLines)
         {
            lineRenderer = new DottedVerticalLineRenderer();
         }
         else
         {
            lineRenderer = new LineRenderer();
         }
         lineRenderer.weight = verticalGridLineThickness;
         lineRenderer.color = verticalGridLineColor;
         lineRenderer.alpha = verticalGridLineAlpha;
         return lineRenderer;
      }
      
      public function get dottedGridLines() : Boolean
      {
         return _dottedGridLines;
      }
      
      public function set dottedGridLines(value:Boolean) : void
      {
         _dottedGridLines = value;
      }
      
      public function update(event:LayoutUpdateEvent) : void
      {
         layout = IVerticalLinesLayout(event.layout);
         invalidateDisplayList();
      }
      
      protected function drawLineForItem(item:VerticalLinesLayoutItem, lineRenderer:ILineRenderer) : void
      {
         var x:Number = NaN;
         x = item.x - layout.xPosition;
         lineRenderer.moveTo(graphics,x,0);
         lineRenderer.apply(graphics);
         lineRenderer.drawTo(graphics,x,item.height);
      }
      
      public function get verticalGridLineAlpha() : Number
      {
         return _verticalGridLineAlpha;
      }
      
      protected function render(layout:IVerticalLinesLayout) : void
      {
         var lineRenderer:ILineRenderer = null;
         var item:VerticalLinesLayoutItem = null;
         lineRenderer = getLineRendererForStyling();
         for each(item in layout.items)
         {
            drawLineForItem(item,lineRenderer);
         }
      }
      
      public function set verticalGridLineAlpha(value:Number) : void
      {
         _verticalGridLineAlpha = value;
      }
      
      public function set verticalGridLineColor(value:uint) : void
      {
         _verticalGridLineColor = value;
      }
      
      public function set verticalGridLineThickness(value:Number) : void
      {
         _verticalGridLineThickness = value;
      }
      
      public function get verticalGridLineColor() : uint
      {
         return _verticalGridLineColor;
      }
      
      public function get verticalGridLineThickness() : Number
      {
         return _verticalGridLineThickness;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(layout == null)
         {
            return;
         }
         graphics.clear();
         render(layout);
      }
   }
}

