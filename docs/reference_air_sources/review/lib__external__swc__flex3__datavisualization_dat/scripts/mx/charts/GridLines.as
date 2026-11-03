package mx.charts
{
   import flash.display.Graphics;
   import flash.geom.Rectangle;
   import mx.charts.chartClasses.CartesianChart;
   import mx.charts.chartClasses.ChartElement;
   import mx.charts.chartClasses.ChartState;
   import mx.charts.chartClasses.GraphicsUtilities;
   import mx.charts.chartClasses.IAxisRenderer;
   import mx.charts.styles.HaloDefaults;
   import mx.graphics.IStroke;
   import mx.graphics.Stroke;
   import mx.styles.CSSStyleDeclaration;
   
   [Style(name="verticalTickAligned",type="Boolean",inherit="no")]
   [Style(name="verticalStroke",type="mx.graphics.IStroke",inherit="no")]
   [Style(name="verticalShowOrigin",type="Boolean",inherit="no")]
   [Style(name="verticalOriginStroke",type="mx.graphics.IStroke",inherit="no")]
   [Style(name="verticalFill",type="mx.graphics.IFill",inherit="no")]
   [Style(name="verticalChangeCount",type="int",inherit="no")]
   [Style(name="verticalAlternateFill",type="mx.graphics.IFill",inherit="no")]
   [Style(name="horizontalTickAligned",type="Boolean",inherit="no")]
   [Style(name="horizontalStroke",type="mx.graphics.IStroke",inherit="no")]
   [Style(name="horizontalShowOrigin",type="Boolean",inherit="no")]
   [Style(name="horizontalOriginStroke",type="mx.graphics.IStroke",inherit="no")]
   [Style(name="horizontalFill",type="mx.graphics.IFill",inherit="no")]
   [Style(name="horizontalChangeCount",type="int",inherit="no")]
   [Style(name="horizontalAlternateFill",type="mx.graphics.IFill",inherit="no")]
   [Style(name="direction",type="String",enumeration="horizontal,vertical,both",inherit="no")]
   public class GridLines extends ChartElement
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static var stylesInited:Boolean = initStyles();
      
      public function GridLines()
      {
         super();
      }
      
      private static function initStyles() : Boolean
      {
         var hgridlinesStyle:CSSStyleDeclaration;
         var bothGridLines:CSSStyleDeclaration;
         var gridlinesStyleName:CSSStyleDeclaration;
         HaloDefaults.init();
         gridlinesStyleName = HaloDefaults.createSelector("GridLines");
         gridlinesStyleName.defaultFactory = function():void
         {
            this.direction = "horizontal";
            this.horizontalOriginStroke = new Stroke(11583952,1);
            this.horizontalShowOrigin = true;
            this.horizontalStroke = new Stroke(15658734,0);
            this.horizontalTickAligned = true;
            this.verticalOriginStroke = new Stroke(11583952,1);
            this.verticalShowOrigin = false;
            this.verticalStroke = new Stroke(15658734,0);
            this.verticalTickAligned = true;
         };
         hgridlinesStyle = HaloDefaults.createSelector(".horizontalGridLines");
         hgridlinesStyle.defaultFactory = function():void
         {
            this.direction = "vertical";
            this.horizontalFill = null;
            this.horizontalShowOrigin = false;
            this.horizontalTickAligned = true;
            this.verticalFill = null;
            this.verticalShowOrigin = true;
            this.verticalTickAligned = true;
         };
         bothGridLines = HaloDefaults.createSelector(".bothGridLines");
         bothGridLines.defaultFactory = function():void
         {
            this.direction = "both";
            this.horizontalShowOrigin = true;
            this.horizontalTickAligned = true;
            this.verticalShowOrigin = true;
            this.verticalTickAligned = true;
         };
         return true;
      }
      
      override public function chartStateChanged(oldState:uint, newState:uint) : void
      {
         invalidateDisplayList();
      }
      
      override public function mappingChanged() : void
      {
         invalidateDisplayList();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var len:int = 0;
         var c:Object = null;
         var stroke:IStroke = null;
         var changeCount:int = 0;
         var ticks:Array = null;
         var spacing:Array = null;
         var axisLength:Number = NaN;
         var colors:Array = null;
         var rc:Rectangle = null;
         var originStroke:IStroke = null;
         var addedFirstLine:Boolean = false;
         var addedLastLine:Boolean = false;
         var verticalAxisRenderer:IAxisRenderer = null;
         var i:int = 0;
         var idx:int = 0;
         var bottom:Number = NaN;
         var top:Number = NaN;
         var horizontalAxisRenderer:IAxisRenderer = null;
         var left:Number = NaN;
         var right:Number = NaN;
         var cache:Array = null;
         var sWidth:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(!chart || chart.chartState == ChartState.PREPARING_TO_HIDE_DATA || chart.chartState == ChartState.HIDING_DATA)
         {
            return;
         }
         var g:Graphics = graphics;
         g.clear();
         var direction:String = getStyle("direction");
         if(direction == "horizontal" || direction == "both")
         {
            stroke = getStyle("horizontalStroke");
            changeCount = Math.max(1,getStyle("horizontalChangeCount"));
            if(changeCount * 0 != 0 || changeCount <= 1)
            {
               changeCount = 1;
            }
            if(!CartesianChart(chart).verticalAxisRenderer)
            {
               verticalAxisRenderer = CartesianChart(chart).getLeftMostRenderer();
               if(!verticalAxisRenderer)
               {
                  verticalAxisRenderer = CartesianChart(chart).getRightMostRenderer();
               }
            }
            else
            {
               verticalAxisRenderer = CartesianChart(chart).verticalAxisRenderer;
            }
            ticks = verticalAxisRenderer.ticks;
            if(getStyle("horizontalTickAligned") == false)
            {
               len = int(ticks.length);
               spacing = [];
               for(i = 1; i < len; i++)
               {
                  spacing[i - 1] = (ticks[i] + ticks[i - 1]) / 2;
               }
            }
            else
            {
               spacing = ticks;
            }
            addedFirstLine = false;
            addedLastLine = false;
            if(spacing[0] != 0)
            {
               addedFirstLine = true;
               spacing.unshift(0);
            }
            if(spacing[spacing.length - 1] != 1)
            {
               addedLastLine = true;
               spacing.push(1);
            }
            axisLength = unscaledHeight;
            colors = [getStyle("horizontalFill"),getStyle("horizontalAlternateFill")];
            len = int(spacing.length);
            if(spacing[len - 1] < 1)
            {
               c = colors[1];
               if(c != null)
               {
                  g.lineStyle(0,0,0);
                  GraphicsUtilities.fillRect(g,0,spacing[len - 1] * axisLength,unscaledWidth,unscaledHeight,c);
               }
            }
            for(i = 0; i < spacing.length; i += changeCount)
            {
               idx = len - 1 - i;
               c = colors[i / changeCount % 2];
               bottom = spacing[idx] * axisLength;
               top = spacing[Math.max(0,idx - changeCount)] * axisLength;
               rc = new Rectangle(0,top,unscaledWidth,bottom - top);
               if(c != null)
               {
                  g.lineStyle(0,0,0);
                  GraphicsUtilities.fillRect(g,rc.left,rc.top,rc.right,rc.bottom,c);
               }
               if(Boolean(stroke) && rc.bottom >= -1)
               {
                  if(!(addedFirstLine && idx == 0))
                  {
                     if(!(addedLastLine && idx == spacing.length - 1))
                     {
                        stroke.apply(g);
                        g.moveTo(rc.left,rc.bottom);
                        g.lineTo(rc.right,rc.bottom);
                     }
                  }
               }
            }
         }
         if(direction == "vertical" || direction == "both")
         {
            stroke = getStyle("verticalStroke");
            changeCount = Math.max(1,getStyle("verticalChangeCount"));
            if(isNaN(changeCount) || changeCount <= 1)
            {
               changeCount = 1;
            }
            if(!CartesianChart(chart).horizontalAxisRenderer)
            {
               horizontalAxisRenderer = CartesianChart(chart).getBottomMostRenderer();
               if(!horizontalAxisRenderer)
               {
                  horizontalAxisRenderer = CartesianChart(chart).getTopMostRenderer();
               }
            }
            else
            {
               horizontalAxisRenderer = CartesianChart(chart).horizontalAxisRenderer;
            }
            ticks = horizontalAxisRenderer.ticks.concat();
            if(getStyle("verticalTickAligned") == false)
            {
               len = int(ticks.length);
               spacing = [];
               for(i = 1; i < len; i++)
               {
                  spacing[i - 1] = (ticks[i] + ticks[i - 1]) / 2;
               }
            }
            else
            {
               spacing = ticks;
            }
            addedFirstLine = false;
            addedLastLine = false;
            if(spacing[0] != 0)
            {
               addedFirstLine = true;
               spacing.unshift(0);
            }
            if(spacing[spacing.length - 1] != 1)
            {
               addedLastLine = true;
               spacing.push(1);
            }
            axisLength = unscaledWidth;
            colors = [getStyle("verticalFill"),getStyle("verticalAlternateFill")];
            for(i = 0; i < spacing.length; i += changeCount)
            {
               c = colors[i / changeCount % 2];
               left = spacing[i] * axisLength;
               right = spacing[Math.min(spacing.length - 1,i + changeCount)] * axisLength;
               rc = new Rectangle(left,0,right - left,unscaledHeight);
               if(c != null)
               {
                  g.lineStyle(0,0,0);
                  GraphicsUtilities.fillRect(g,rc.left,rc.top,rc.right,rc.bottom,c);
               }
               if(Boolean(stroke))
               {
                  if(!(addedFirstLine && i == 0))
                  {
                     if(!(addedLastLine && i == spacing.length - 1))
                     {
                        stroke.apply(g);
                        g.moveTo(rc.left,rc.top);
                        g.lineTo(rc.left,rc.bottom);
                     }
                  }
               }
            }
         }
         var horizontalShowOrigin:Object = getStyle("horizontalShowOrigin");
         var verticalShowOrigin:Object = getStyle("verticalShowOrigin");
         if(Boolean(verticalShowOrigin) || Boolean(horizontalShowOrigin))
         {
            cache = [{
               "xOrigin":0,
               "yOrigin":0
            }];
            sWidth = 0.5;
            dataTransform.transformCache(cache,"xOrigin","x","yOrigin","y");
            if(Boolean(horizontalShowOrigin) && Boolean(cache[0].y > 0) && cache[0].y < unscaledHeight)
            {
               originStroke = getStyle("horizontalOriginStroke");
               originStroke.apply(g);
               g.moveTo(0,cache[0].y - sWidth / 2);
               g.lineTo($width,cache[0].y - sWidth / 2);
            }
            if(Boolean(verticalShowOrigin) && Boolean(cache[0].x > 0) && cache[0].x < unscaledWidth)
            {
               originStroke = getStyle("verticalOriginStroke");
               originStroke.apply(g);
               g.moveTo(cache[0].x - sWidth / 2,0);
               g.lineTo(cache[0].x - sWidth / 2,$height);
            }
         }
      }
   }
}

