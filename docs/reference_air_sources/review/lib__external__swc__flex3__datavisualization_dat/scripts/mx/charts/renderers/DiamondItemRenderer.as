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
   
   public class DiamondItemRenderer extends ProgrammaticSkin implements IDataRenderer
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static var rcFill:Rectangle = new Rectangle();
      
      private var _data:Object;
      
      public function DiamondItemRenderer()
      {
         super();
      }
      
      public function set data(value:Object) : void
      {
         if(_data == value)
         {
            return;
         }
         _data = value;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var fill:IFill = null;
         var color:uint = 0;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var state:String = "";
         if(_data is ChartItem && _data.hasOwnProperty("fill"))
         {
            fill = _data.fill;
            state = _data.currentState;
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
         var cx:Number = unscaledWidth / 2;
         var cy:Number = unscaledHeight / 2;
         rcFill.left -= adjustedRadius;
         rcFill.top -= adjustedRadius;
         rcFill.right = unscaledWidth + adjustedRadius;
         rcFill.bottom = unscaledHeight + adjustedRadius;
         var g:Graphics = graphics;
         g.clear();
         g.moveTo(w,w);
         if(Boolean(stroke))
         {
            stroke.apply(g);
         }
         g.moveTo(cx,w - adjustedRadius);
         if(Boolean(fill))
         {
            fill.begin(g,rcFill);
         }
         g.lineTo(unscaledWidth - w + adjustedRadius,cy);
         g.lineTo(cx,unscaledHeight - w + adjustedRadius);
         g.lineTo(w - adjustedRadius,cy);
         g.lineTo(cx,w - adjustedRadius);
         if(Boolean(fill))
         {
            fill.end(g);
         }
      }
      
      [Inspectable(environment="none")]
      public function get data() : Object
      {
         return _data;
      }
   }
}

