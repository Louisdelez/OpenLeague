package mx.charts.renderers
{
   import mx.charts.chartClasses.GraphicsUtilities;
   import mx.core.IDataRenderer;
   import mx.graphics.IStroke;
   import mx.skins.ProgrammaticSkin;
   
   public class LineRenderer extends ProgrammaticSkin implements IDataRenderer
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _lineSegment:Object;
      
      public function LineRenderer()
      {
         super();
      }
      
      [Inspectable(environment="none")]
      public function get data() : Object
      {
         return _lineSegment;
      }
      
      public function set data(value:Object) : void
      {
         _lineSegment = value;
         invalidateDisplayList();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var stroke:IStroke = getStyle("lineStroke");
         var form:String = getStyle("form");
         graphics.clear();
         GraphicsUtilities.drawPolyLine(graphics,_lineSegment.items,_lineSegment.start,_lineSegment.end + 1,"x","y",stroke,form);
      }
   }
}

