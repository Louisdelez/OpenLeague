package flexlib.scheduling.scheduleClasses.viewers
{
   import flexlib.scheduling.scheduleClasses.layout.HorizontalLinesLayoutItem;
   import flexlib.scheduling.scheduleClasses.layout.IHorizontalLinesLayout;
   import flexlib.scheduling.scheduleClasses.layout.LayoutUpdateEvent;
   import flexlib.scheduling.scheduleClasses.lineRenderer.DottedHorizontalLineRenderer;
   import flexlib.scheduling.scheduleClasses.lineRenderer.ILineRenderer;
   import flexlib.scheduling.scheduleClasses.lineRenderer.LineRenderer;
   import mx.core.UIComponent;
   
   public class HorizontalLinesViewer extends UIComponent implements IHorizontalLinesViewer
   {
      
      private var _horizontalGridLineAlpha:Number;
      
      private var _horizontalGridLineThickness:Number;
      
      private var _dottedGridLines:Boolean;
      
      private var _horizontalGridLineColor:uint;
      
      protected var layout:IHorizontalLinesLayout;
      
      public function HorizontalLinesViewer()
      {
         super();
      }
      
      protected function getLineRendererForStyling() : ILineRenderer
      {
         var lineRenderer:ILineRenderer = null;
         if(dottedGridLines)
         {
            lineRenderer = new DottedHorizontalLineRenderer();
         }
         else
         {
            lineRenderer = new LineRenderer();
         }
         lineRenderer.weight = horizontalGridLineThickness;
         lineRenderer.color = horizontalGridLineColor;
         lineRenderer.alpha = horizontalGridLineAlpha;
         return lineRenderer;
      }
      
      public function get dottedGridLines() : Boolean
      {
         return _dottedGridLines;
      }
      
      public function get horizontalGridLineThickness() : Number
      {
         return _horizontalGridLineThickness;
      }
      
      public function set dottedGridLines(value:Boolean) : void
      {
         _dottedGridLines = value;
      }
      
      public function update(event:LayoutUpdateEvent) : void
      {
         layout = IHorizontalLinesLayout(event.layout);
         invalidateDisplayList();
      }
      
      public function set horizontalGridLineThickness(value:Number) : void
      {
         _horizontalGridLineThickness = value;
      }
      
      protected function drawLineForItem(item:HorizontalLinesLayoutItem, lineRenderer:ILineRenderer) : void
      {
         var y:Number = NaN;
         y = item.y - layout.yPosition;
         lineRenderer.moveTo(graphics,0,y);
         lineRenderer.apply(graphics);
         lineRenderer.drawTo(graphics,item.width,y);
      }
      
      public function get horizontalGridLineColor() : uint
      {
         return _horizontalGridLineColor;
      }
      
      protected function render(layout:IHorizontalLinesLayout) : void
      {
         var lineRenderer:ILineRenderer = null;
         var item:HorizontalLinesLayoutItem = null;
         lineRenderer = getLineRendererForStyling();
         for each(item in layout.items)
         {
            drawLineForItem(item,lineRenderer);
         }
      }
      
      public function set horizontalGridLineAlpha(value:Number) : void
      {
         _horizontalGridLineAlpha = value;
      }
      
      public function set horizontalGridLineColor(value:uint) : void
      {
         _horizontalGridLineColor = value;
      }
      
      public function get horizontalGridLineAlpha() : Number
      {
         return _horizontalGridLineAlpha;
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

