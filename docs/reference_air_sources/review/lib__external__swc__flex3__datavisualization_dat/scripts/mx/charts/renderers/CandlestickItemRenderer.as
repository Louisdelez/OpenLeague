package mx.charts.renderers
{
   import flash.display.Graphics;
   import flash.geom.Rectangle;
   import mx.charts.ChartItem;
   import mx.charts.chartClasses.GraphicsUtilities;
   import mx.charts.series.items.HLOCSeriesItem;
   import mx.core.IDataRenderer;
   import mx.graphics.IFill;
   import mx.graphics.IStroke;
   import mx.graphics.SolidColor;
   import mx.skins.ProgrammaticSkin;
   import mx.styles.StyleManager;
   import mx.utils.ColorUtil;
   
   public class CandlestickItemRenderer extends ProgrammaticSkin implements IDataRenderer
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _chartItem:HLOCSeriesItem;
      
      public function CandlestickItemRenderer()
      {
         super();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var fill:IFill = null;
         var rc:Rectangle = null;
         var state:String = null;
         var color:uint = 0;
         var max:Number = NaN;
         var min:Number = NaN;
         var boxMin:Number = NaN;
         var boxMax:Number = NaN;
         var candlestickHeight:Number = NaN;
         var heightScaleFactor:Number = NaN;
         var declineFill:IFill = null;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var stroke:IStroke = getStyle("stroke");
         var boxStroke:IStroke = getStyle("boxStroke");
         var w:Number = Boolean(boxStroke) ? boxStroke.weight / 2 : 0;
         var g:Graphics = graphics;
         if(Boolean(_chartItem))
         {
            fill = data.fill;
            state = data.currentState;
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
            max = Math.min(_chartItem.high,Math.min(_chartItem.close,_chartItem.open));
            min = Math.max(_chartItem.low,Math.max(_chartItem.open,_chartItem.close));
            boxMin = Math.min(_chartItem.open,_chartItem.close);
            boxMax = Math.max(_chartItem.open,_chartItem.close);
            candlestickHeight = min - max;
            heightScaleFactor = height / candlestickHeight;
            rc = new Rectangle(w,(boxMin - max) * heightScaleFactor + w,width - 2 * w,(boxMax - boxMin) * heightScaleFactor - 2 * w);
            g.clear();
            g.moveTo(rc.left,rc.top);
            if(Boolean(boxStroke))
            {
               boxStroke.apply(g);
            }
            else
            {
               g.lineStyle(0,0,0);
            }
            if(Boolean(fill))
            {
               fill.begin(g,rc);
            }
            g.lineTo(rc.right,rc.top);
            g.lineTo(rc.right,rc.bottom);
            g.lineTo(rc.left,rc.bottom);
            g.lineTo(rc.left,rc.top);
            if(Boolean(fill))
            {
               fill.end(g);
            }
            if(Boolean(stroke))
            {
               stroke.apply(g);
               g.moveTo(width / 2,0);
               g.lineTo(width / 2,(boxMin - max) * heightScaleFactor);
               g.moveTo(width / 2,(boxMax - max) * heightScaleFactor);
               g.lineTo(width / 2,height);
            }
         }
         else
         {
            fill = GraphicsUtilities.fillFromStyle(getStyle("declineFill"));
            declineFill = GraphicsUtilities.fillFromStyle(getStyle("fill"));
            rc = new Rectangle(0,0,unscaledWidth,unscaledHeight);
            g.clear();
            g.moveTo(width,0);
            if(Boolean(fill))
            {
               fill.begin(g,rc);
            }
            g.lineStyle(0,0,0);
            g.lineTo(0,height);
            if(Boolean(boxStroke))
            {
               boxStroke.apply(g);
            }
            g.lineTo(0,0);
            g.lineTo(width,0);
            if(Boolean(fill))
            {
               fill.end(g);
            }
            if(Boolean(declineFill))
            {
               declineFill.begin(g,rc);
            }
            g.lineTo(width,height);
            g.lineTo(0,height);
            g.lineStyle(0,0,0);
            g.lineTo(width,0);
            if(Boolean(declineFill))
            {
               declineFill.end(g);
            }
         }
      }
      
      [Inspectable(environment="none")]
      public function get data() : Object
      {
         return _chartItem;
      }
      
      public function set data(value:Object) : void
      {
         _chartItem = value as HLOCSeriesItem;
         invalidateDisplayList();
      }
   }
}

