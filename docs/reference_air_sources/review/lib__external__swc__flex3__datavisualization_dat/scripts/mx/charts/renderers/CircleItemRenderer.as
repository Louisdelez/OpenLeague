package mx.charts.renderers
{
   import flash.display.Graphics;
   import flash.geom.Rectangle;
   import mx.charts.ChartItem;
   import mx.charts.chartClasses.GraphicsUtilities;
   import mx.core.IDataRenderer;
   import mx.graphics.IFill;
   import mx.graphics.IStroke;
   import mx.graphics.SolidColor;
   import mx.skins.ProgrammaticSkin;
   import mx.styles.StyleManager;
   import mx.utils.ColorUtil;
   
   public class CircleItemRenderer extends ProgrammaticSkin implements IDataRenderer
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static var rcFill:Rectangle = new Rectangle();
      
      private var _chartItem:Object;
      
      public function CircleItemRenderer()
      {
         super();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var fill:IFill = null;
         var color:uint = 0;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var state:String = "";
         if(_chartItem is ChartItem && _chartItem.hasOwnProperty("fill"))
         {
            fill = _chartItem.fill;
            state = _chartItem.currentState;
         }
         else
         {
            fill = GraphicsUtilities.fillFromStyle(getStyle("fill"));
         }
         var adjustedRadius:Number = 0;
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
               adjustedRadius = Number(getStyle("adjustedRadius"));
               if(!adjustedRadius)
               {
                  adjustedRadius = 0;
               }
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
               adjustedRadius = Number(getStyle("adjustedRadius"));
               if(!adjustedRadius)
               {
                  adjustedRadius = 0;
               }
         }
         var stroke:IStroke = getStyle("stroke");
         var w:Number = Boolean(stroke) ? stroke.weight / 2 : 0;
         rcFill.right = unscaledWidth;
         rcFill.bottom = unscaledHeight;
         var g:Graphics = graphics;
         g.clear();
         if(Boolean(stroke))
         {
            stroke.apply(g);
         }
         if(Boolean(fill))
         {
            fill.begin(g,rcFill);
         }
         g.drawEllipse(w - adjustedRadius,w - adjustedRadius,unscaledWidth - 2 * w + adjustedRadius * 2,unscaledHeight - 2 * w + adjustedRadius * 2);
         if(Boolean(fill))
         {
            fill.end(g);
         }
      }
      
      [Inspectable(environment="none")]
      public function get data() : Object
      {
         return _chartItem;
      }
      
      public function set data(value:Object) : void
      {
         if(_chartItem == value)
         {
            return;
         }
         _chartItem = value;
      }
   }
}

