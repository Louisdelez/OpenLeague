package mx.charts.series
{
   import mx.charts.HitData;
   import mx.charts.chartClasses.HLOCSeriesBase;
   import mx.charts.renderers.HLOCItemRenderer;
   import mx.charts.series.items.HLOCSeriesItem;
   import mx.charts.styles.HaloDefaults;
   import mx.core.ClassFactory;
   import mx.graphics.IStroke;
   import mx.graphics.LinearGradientStroke;
   import mx.graphics.Stroke;
   import mx.styles.CSSStyleDeclaration;
   
   [Style(name="openTickStroke",type="mx.graphics.IStroke",inherit="no")]
   [Style(name="openTickLength",type="Number",format="Length",inherit="no")]
   [Style(name="stroke",type="mx.graphics.IStroke",inherit="no")]
   [Style(name="closeTickStroke",type="mx.graphics.IStroke",inherit="no")]
   [Style(name="closeTickLength",type="Number",format="Length",inherit="no")]
   [Style(name="hlocColor",type="uint",format="Color",inherit="no")]
   [Exclude(name="hlocColor",kind="style")]
   public class HLOCSeries extends HLOCSeriesBase
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static var stylesInited:Boolean = initStyles();
      
      public function HLOCSeries()
      {
         super();
      }
      
      private static function initStyles() : Boolean
      {
         var hlocSeriesStyle:CSSStyleDeclaration;
         HaloDefaults.init();
         hlocSeriesStyle = HaloDefaults.createSelector("HLOCSeries");
         hlocSeriesStyle.defaultFactory = function():void
         {
            this.closeTickLength = 3;
            this.closeTickStroke = new Stroke(0,3,1,false,"normal","none");
            this.itemRenderer = new ClassFactory(HLOCItemRenderer);
            this.openTickLength = 3;
            this.openTickStroke = new Stroke(0,3,1,false,"normal","none");
            this.stroke = new Stroke(0,0);
            this.hlocColor = 0;
         };
         return true;
      }
      
      override public function getAllDataPoints() : Array
      {
         var i:uint = 0;
         var v:HLOCSeriesItem = null;
         var itemExists:Boolean = false;
         var j:int = 0;
         var ypos:Number = NaN;
         var id:int = 0;
         var hd:HitData = null;
         var istroke:IStroke = null;
         var gb:LinearGradientStroke = null;
         if(!_renderData)
         {
            return [];
         }
         if(!_renderData.filteredCache)
         {
            return [];
         }
         var itemArr:Array = [];
         if(Boolean(chart) && Boolean(chart.dataTipItemsSet) && Boolean(dataTipItems))
         {
            itemArr = dataTipItems;
         }
         else if(Boolean(chart) && Boolean(chart.showAllDataTips) && Boolean(_renderData.filteredCache))
         {
            itemArr = _renderData.filteredCache;
         }
         else
         {
            itemArr = [];
         }
         var len:uint = itemArr.length;
         var result:Array = [];
         for(i = 0; i < len; i++)
         {
            v = itemArr[i];
            if(_renderData.filteredCache.indexOf(v) == -1)
            {
               itemExists = false;
               for(j = 0; j < _renderData.filteredCache.length; j++)
               {
                  if(v.item == _renderData.filteredCache[j].item)
                  {
                     v = _renderData.filteredCache[j];
                     itemExists = true;
                     break;
                  }
               }
               if(!itemExists)
               {
                  continue;
               }
            }
            if(Boolean(v))
            {
               ypos = _openField != "" ? (v.open + v.close) / 2 : v.close;
               id = v.index;
               hd = new HitData(createDataID(id),Math.sqrt(0),v.x + _renderData.renderedXOffset,ypos,v);
               istroke = getStyle("stroke");
               if(istroke is Stroke)
               {
                  hd.contextColor = Stroke(istroke).color;
               }
               else if(istroke is LinearGradientStroke)
               {
                  gb = LinearGradientStroke(istroke);
                  if(gb.entries.length > 0)
                  {
                     hd.contextColor = gb.entries[0].color;
                  }
               }
               hd.dataTipFunction = formatDataTip;
               result.push(hd);
            }
         }
         return result;
      }
      
      override public function findDataPoints(x:Number, y:Number, sensitivity:Number) : Array
      {
         var minItem:HLOCSeriesItem = null;
         var v:HLOCSeriesItem = null;
         var dist:Number = NaN;
         var lowValue:Number = NaN;
         var highValue:Number = NaN;
         var ypos:Number = NaN;
         var id:int = 0;
         var hd:HitData = null;
         var istroke:IStroke = null;
         var gb:LinearGradientStroke = null;
         if(interactive == false || !_renderData)
         {
            return [];
         }
         var minDist:Number = _renderData.renderedHalfWidth;
         var strokeLength:Number = Number(getStyle("closeTickLength"));
         if(openField != "" && openField != null)
         {
            strokeLength += getStyle("openTickLength");
         }
         if(minDist > strokeLength)
         {
            minDist = strokeLength;
         }
         minDist += sensitivity;
         var len:int = int(_renderData.filteredCache.length);
         for(var i:int = 0; i < len; i++)
         {
            v = _renderData.filteredCache[i];
            dist = Math.abs(v.x + _renderData.renderedXOffset - x);
            if(dist <= minDist)
            {
               lowValue = Math.max(v.low,Math.max(v.high,v.close));
               highValue = Math.min(v.low,Math.min(v.high,v.close));
               if(!isNaN(v.open))
               {
                  lowValue = Math.max(lowValue,v.open);
                  highValue = Math.min(highValue,v.open);
               }
               if(highValue - y <= sensitivity)
               {
                  if(y - lowValue <= sensitivity)
                  {
                     minDist = dist;
                     minItem = v;
                     if(dist < _renderData.renderedHalfWidth)
                     {
                        break;
                     }
                  }
               }
            }
         }
         if(Boolean(minItem))
         {
            ypos = _openField != "" ? (minItem.open + minItem.close) / 2 : minItem.close;
            id = minItem.index;
            hd = new HitData(createDataID(id),Math.sqrt(minDist),minItem.x + _renderData.renderedXOffset,ypos,minItem);
            istroke = getStyle("stroke");
            if(istroke is Stroke)
            {
               hd.contextColor = Stroke(istroke).color;
            }
            else if(istroke is LinearGradientStroke)
            {
               gb = LinearGradientStroke(istroke);
               if(gb.entries.length > 0)
               {
                  hd.contextColor = gb.entries[0].color;
               }
            }
            hd.dataTipFunction = formatDataTip;
            istroke = getStyle("stroke");
            if(istroke is Stroke)
            {
               hd.contextColor = Stroke(istroke).color;
            }
            else if(istroke is LinearGradientStroke)
            {
               gb = LinearGradientStroke(istroke);
               if(gb.entries.length > 0)
               {
                  hd.contextColor = gb.entries[0].color;
               }
            }
            return [hd];
         }
         return [];
      }
   }
}

