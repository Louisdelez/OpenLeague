package mx.charts.renderers
{
   import flash.display.Graphics;
   import flash.geom.Rectangle;
   import mx.charts.chartClasses.GraphicsUtilities;
   import mx.core.IDataRenderer;
   import mx.graphics.IFill;
   import mx.graphics.IStroke;
   import mx.graphics.Stroke;
   import mx.skins.ProgrammaticSkin;
   
   public class AreaRenderer extends ProgrammaticSkin implements IDataRenderer
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static var noStroke:Stroke = new Stroke(0,0,0);
      
      private var _area:Object;
      
      public function AreaRenderer()
      {
         super();
      }
      
      [Inspectable(environment="none")]
      public function get data() : Object
      {
         return _area;
      }
      
      public function set data(value:Object) : void
      {
         _area = value;
         invalidateDisplayList();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var xMin:Number = NaN;
         var yMin:Number = NaN;
         var i:int = 0;
         var v:Object = null;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var fill:IFill = GraphicsUtilities.fillFromStyle(getStyle("areaFill"));
         var stroke:IStroke = getStyle("areaStroke");
         var form:String = getStyle("form");
         var g:Graphics = graphics;
         g.clear();
         if(!_area)
         {
            return;
         }
         var boundary:Array = _area.filteredCache;
         var n:int = int(boundary.length);
         if(n == 0)
         {
            return;
         }
         var xMax:Number = xMin = Number(boundary[0].x);
         var yMax:Number = yMin = Number(boundary[0].y);
         for(i = 0; i < n; i++)
         {
            v = boundary[i];
            xMin = Math.min(xMin,v.x);
            yMin = Math.min(yMin,v.y);
            xMax = Math.max(xMax,v.x);
            yMax = Math.max(yMax,v.y);
            if(!isNaN(v.min))
            {
               yMin = Math.min(yMin,v.min);
               yMax = Math.max(yMax,v.min);
            }
         }
         if(Boolean(fill))
         {
            fill.begin(g,new Rectangle(xMin,yMin,xMax - xMin,yMax - yMin));
         }
         GraphicsUtilities.drawPolyLine(g,boundary,0,n,"x","y",stroke,form);
         g.lineStyle(0,0,0);
         if(boundary[0].element.minField != null && boundary[0].element.minField != "")
         {
            g.lineTo(boundary[n - 1].x,boundary[n - 1].min);
            GraphicsUtilities.drawPolyLine(g,boundary,n - 1,-1,"x","min",noStroke,form,false);
         }
         else
         {
            g.lineTo(boundary[n - 1].x,_area.renderedBase);
            g.lineTo(boundary[0].x,_area.renderedBase);
         }
         g.lineStyle(0,0,0);
         g.lineTo(boundary[0].x,boundary[0].y);
         g.endFill();
      }
   }
}

