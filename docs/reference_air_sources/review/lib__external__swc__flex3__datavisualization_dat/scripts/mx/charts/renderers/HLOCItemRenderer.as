package mx.charts.renderers
{
   import flash.display.Graphics;
   import mx.charts.ChartItem;
   import mx.charts.series.items.HLOCSeriesItem;
   import mx.core.IDataRenderer;
   import mx.graphics.IStroke;
   import mx.graphics.LinearGradientStroke;
   import mx.graphics.Stroke;
   import mx.skins.ProgrammaticSkin;
   import mx.styles.StyleManager;
   import mx.utils.ColorUtil;
   
   public class HLOCItemRenderer extends ProgrammaticSkin implements IDataRenderer
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _chartItem:HLOCSeriesItem;
      
      public function HLOCItemRenderer()
      {
         super();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var stroke:Stroke = null;
         var lgstroke:LinearGradientStroke = null;
         var openTickStroke:Stroke = null;
         var lgOpenTickStroke:LinearGradientStroke = null;
         var closeTickStroke:Stroke = null;
         var lgCloseTickStroke:LinearGradientStroke = null;
         var openTick:Number = NaN;
         var closeTick:Number = NaN;
         var oldColor:uint = 0;
         var oldOpenTickColor:uint = 0;
         var oldCloseTickColor:uint = 0;
         var strokeColor:uint = 0;
         var openTickColor:uint = 0;
         var closeTickColor:uint = 0;
         var lowValue:Number = NaN;
         var highValue:Number = NaN;
         var HLOCHeight:Number = NaN;
         var heightScaleFactor:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var istroke:IStroke = getStyle("stroke");
         if(istroke is Stroke)
         {
            stroke = Stroke(istroke);
         }
         else if(istroke is LinearGradientStroke)
         {
            lgstroke = LinearGradientStroke(istroke);
         }
         else
         {
            stroke = new Stroke(getStyle("hlocColor"),istroke.weight);
         }
         var iOpenTickStroke:IStroke = getStyle("openTickStroke");
         if(iOpenTickStroke is Stroke)
         {
            openTickStroke = Stroke(iOpenTickStroke);
         }
         else if(iOpenTickStroke is LinearGradientStroke)
         {
            lgOpenTickStroke = LinearGradientStroke(iOpenTickStroke);
         }
         else
         {
            openTickStroke = new Stroke(getStyle("hlocColor"),iOpenTickStroke.weight,1,false,"normal","none");
         }
         var iCloseTickStroke:IStroke = getStyle("closeTickStroke");
         if(iCloseTickStroke is Stroke)
         {
            closeTickStroke = Stroke(iCloseTickStroke);
         }
         else if(iCloseTickStroke is LinearGradientStroke)
         {
            lgCloseTickStroke = LinearGradientStroke(iCloseTickStroke);
         }
         else
         {
            closeTickStroke = new Stroke(getStyle("hlocColor"),iCloseTickStroke.weight,1,false,"normal","none");
         }
         var w2:Number = unscaledWidth / 2;
         var openTickLen:Number = Math.min(w2,getStyle("openTickLength"));
         var closeTickLen:Number = Math.min(w2,getStyle("closeTickLength"));
         var state:String = "";
         if(Boolean(_chartItem))
         {
            lowValue = Math.max(_chartItem.low,Math.max(_chartItem.high,_chartItem.close));
            highValue = Math.min(_chartItem.low,Math.min(_chartItem.high,_chartItem.close));
            if(!isNaN(_chartItem.open))
            {
               lowValue = Math.max(lowValue,_chartItem.open);
               highValue = Math.min(highValue,_chartItem.open);
            }
            HLOCHeight = lowValue - highValue;
            heightScaleFactor = HLOCHeight > 0 ? height / HLOCHeight : 0;
            openTick = (_chartItem.open - highValue) * heightScaleFactor;
            closeTick = (_chartItem.close - highValue) * heightScaleFactor;
            state = _chartItem.currentState;
            if(Boolean(state) && state != "")
            {
               if(Boolean(stroke))
               {
                  strokeColor = uint(stroke.color);
                  oldColor = uint(stroke.color);
               }
               else if(lgstroke.entries.length > 0)
               {
                  strokeColor = uint(lgstroke.entries[0].color);
                  oldColor = uint(lgstroke.entries[0].color);
               }
               if(Boolean(openTickStroke))
               {
                  openTickColor = uint(openTickStroke.color);
                  oldOpenTickColor = uint(openTickStroke.color);
               }
               else if(lgOpenTickStroke.entries.length > 0)
               {
                  openTickColor = uint(lgOpenTickStroke.entries[0].color);
                  oldOpenTickColor = uint(lgOpenTickStroke.entries[0].color);
               }
               if(Boolean(closeTickStroke))
               {
                  closeTickColor = uint(closeTickStroke.color);
                  oldCloseTickColor = uint(closeTickStroke.color);
               }
               else if(lgCloseTickStroke.entries.length > 0)
               {
                  closeTickColor = uint(lgCloseTickStroke.entries[0].color);
                  oldCloseTickColor = uint(lgCloseTickStroke.entries[0].color);
               }
            }
            switch(state)
            {
               case ChartItem.FOCUSED:
               case ChartItem.ROLLOVER:
                  if(StyleManager.isValidStyleValue(getStyle("itemRollOverColor")))
                  {
                     strokeColor = uint(getStyle("itemRollOverColor"));
                  }
                  else
                  {
                     strokeColor = uint(ColorUtil.adjustBrightness2(strokeColor,-20));
                  }
                  openTickColor = uint(ColorUtil.adjustBrightness2(openTickColor,-20));
                  closeTickColor = uint(ColorUtil.adjustBrightness2(closeTickColor,-20));
                  break;
               case ChartItem.DISABLED:
                  if(StyleManager.isValidStyleValue(getStyle("itemDisabledColor")))
                  {
                     strokeColor = uint(getStyle("itemDisabledColor"));
                  }
                  else
                  {
                     strokeColor = uint(ColorUtil.adjustBrightness2(strokeColor,20));
                  }
                  openTickColor = uint(ColorUtil.adjustBrightness2(openTickColor,20));
                  closeTickColor = uint(ColorUtil.adjustBrightness2(closeTickColor,20));
                  break;
               case ChartItem.FOCUSEDSELECTED:
               case ChartItem.SELECTED:
                  if(StyleManager.isValidStyleValue(getStyle("itemSelectionColor")))
                  {
                     strokeColor = uint(getStyle("itemSelectionColor"));
                  }
                  else
                  {
                     strokeColor = uint(ColorUtil.adjustBrightness2(strokeColor,-30));
                  }
                  openTickColor = uint(ColorUtil.adjustBrightness2(openTickColor,-30));
                  closeTickColor = uint(ColorUtil.adjustBrightness2(closeTickColor,-30));
            }
         }
         else
         {
            openTick = 0.75 * height;
            closeTick = 0.25 * height;
         }
         if(Boolean(state) && state != "")
         {
            if(Boolean(stroke))
            {
               stroke.color = strokeColor;
            }
            else if(lgstroke.entries.length > 0)
            {
               lgstroke.entries[0].color = strokeColor;
            }
            if(Boolean(openTickStroke))
            {
               openTickStroke.color = openTickColor;
            }
            else if(lgOpenTickStroke.entries.length > 0)
            {
               lgOpenTickStroke.entries[0].color = openTickColor;
            }
            if(Boolean(closeTickStroke))
            {
               closeTickStroke.color = closeTickColor;
            }
            else if(lgCloseTickStroke.entries.length > 0)
            {
               lgCloseTickStroke.entries[0].color = closeTickColor;
            }
         }
         var g:Graphics = graphics;
         g.clear();
         if(Boolean(stroke))
         {
            stroke.apply(g);
         }
         else
         {
            lgstroke.apply(g);
         }
         g.moveTo(w2,0);
         g.lineTo(w2,height);
         if(!isNaN(openTick))
         {
            if(Boolean(openTickStroke))
            {
               openTickStroke.apply(g);
            }
            else
            {
               lgOpenTickStroke.apply(g);
            }
            g.moveTo(w2,openTick);
            g.lineTo(w2 - openTickLen,openTick);
         }
         if(!isNaN(closeTick))
         {
            if(Boolean(closeTickStroke))
            {
               closeTickStroke.apply(g);
            }
            else
            {
               lgCloseTickStroke.apply(g);
            }
            g.moveTo(w2,closeTick);
            g.lineTo(w2 + closeTickLen,closeTick);
         }
         if(Boolean(state) && state != "")
         {
            if(Boolean(stroke))
            {
               stroke.color = oldColor;
            }
            else if(lgstroke.entries.length > 0)
            {
               lgstroke.entries[0].color = oldColor;
            }
            if(Boolean(openTickStroke))
            {
               openTickStroke.color = oldOpenTickColor;
            }
            else if(lgOpenTickStroke.entries.length > 0)
            {
               lgOpenTickStroke.entries[0].color = oldOpenTickColor;
            }
            if(Boolean(closeTickStroke))
            {
               closeTickStroke.color = oldCloseTickColor;
            }
            else if(lgCloseTickStroke.entries.length > 0)
            {
               lgCloseTickStroke.entries[0].color = oldCloseTickColor;
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

