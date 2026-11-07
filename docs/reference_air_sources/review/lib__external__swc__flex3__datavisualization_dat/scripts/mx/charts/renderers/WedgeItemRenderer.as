package mx.charts.renderers
{
   import flash.display.Graphics;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.charts.ChartItem;
   import mx.charts.chartClasses.GraphicsUtilities;
   import mx.charts.series.items.PieSeriesItem;
   import mx.core.IDataRenderer;
   import mx.graphics.IFill;
   import mx.graphics.IStroke;
   import mx.graphics.SolidColor;
   import mx.skins.ProgrammaticSkin;
   import mx.styles.StyleManager;
   import mx.utils.ColorUtil;
   
   public class WedgeItemRenderer extends ProgrammaticSkin implements IDataRenderer
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static const SHADOW_INSET:Number = 8;
      
      private var _wedge:PieSeriesItem;
      
      public function WedgeItemRenderer()
      {
         super();
      }
      
      public function set data(value:Object) : void
      {
         _wedge = PieSeriesItem(value);
         invalidateDisplayList();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var color:uint = 0;
         var innerStart:Point = null;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var g:Graphics = graphics;
         g.clear();
         if(!_wedge)
         {
            return;
         }
         var stroke:IStroke = getStyle("stroke");
         var radialStroke:IStroke = getStyle("radialStroke");
         var outerRadius:Number = _wedge.outerRadius;
         var innerRadius:Number = _wedge.innerRadius;
         var origin:Point = _wedge.origin;
         var angle:Number = _wedge.angle;
         var startAngle:Number = _wedge.startAngle;
         if(Boolean(stroke) && !isNaN(stroke.weight))
         {
            outerRadius -= Math.max(stroke.weight / 2,SHADOW_INSET);
         }
         else
         {
            outerRadius -= SHADOW_INSET;
         }
         outerRadius = Math.max(outerRadius,innerRadius);
         var rc:Rectangle = new Rectangle(origin.x - outerRadius,origin.y - outerRadius,2 * outerRadius,2 * outerRadius);
         var fill:IFill = _wedge.fill;
         var state:String = _wedge.currentState;
         switch(state)
         {
            case ChartItem.FOCUSED:
            case ChartItem.ROLLOVER:
               if(StyleManager.isValidStyleValue(getStyle("itemRollOverColor")))
               {
                  color = uint(getStyle("itemRollOverColor"));
               }
               else
               {
                  color = uint(ColorUtil.adjustBrightness2(GraphicsUtilities.colorFromFill(fill),-20));
               }
               fill = new SolidColor(color);
               break;
            case ChartItem.DISABLED:
               if(StyleManager.isValidStyleValue(getStyle("itemDisabledColor")))
               {
                  color = uint(getStyle("itemDisabledColor"));
               }
               else
               {
                  color = uint(ColorUtil.adjustBrightness2(GraphicsUtilities.colorFromFill(fill),20));
               }
               fill = new SolidColor(GraphicsUtilities.colorFromFill(color));
               break;
            case ChartItem.FOCUSEDSELECTED:
            case ChartItem.SELECTED:
               if(StyleManager.isValidStyleValue(getStyle("itemSelectionColor")))
               {
                  color = uint(getStyle("itemSelectionColor"));
               }
               else
               {
                  color = uint(ColorUtil.adjustBrightness2(GraphicsUtilities.colorFromFill(fill),-30));
               }
               fill = new SolidColor(color);
         }
         var startPt:Point = new Point(origin.x + Math.cos(startAngle) * outerRadius,origin.y - Math.sin(startAngle) * outerRadius);
         var endPt:Point = new Point(origin.x + Math.cos(startAngle + angle) * outerRadius,origin.y - Math.sin(startAngle + angle) * outerRadius);
         g.moveTo(endPt.x,endPt.y);
         fill.begin(g,rc);
         GraphicsUtilities.setLineStyle(g,radialStroke);
         if(innerRadius == 0)
         {
            g.lineTo(origin.x,origin.y);
            g.lineTo(startPt.x,startPt.y);
         }
         else
         {
            innerStart = new Point(origin.x + Math.cos(startAngle + angle) * innerRadius,origin.y - Math.sin(startAngle + angle) * innerRadius);
            g.lineTo(innerStart.x,innerStart.y);
            GraphicsUtilities.setLineStyle(g,stroke);
            GraphicsUtilities.drawArc(g,origin.x,origin.y,startAngle + angle,-angle,innerRadius,innerRadius,true);
            GraphicsUtilities.setLineStyle(g,radialStroke);
            g.lineTo(startPt.x,startPt.y);
         }
         GraphicsUtilities.setLineStyle(g,stroke);
         GraphicsUtilities.drawArc(g,origin.x,origin.y,startAngle,angle,outerRadius,outerRadius,true);
         fill.end(g);
      }
      
      [Inspectable(environment="none")]
      public function get data() : Object
      {
         return _wedge;
      }
   }
}

