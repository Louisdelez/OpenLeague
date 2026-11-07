package mx.charts.series
{
   import mx.charts.HitData;
   import mx.charts.chartClasses.GraphicsUtilities;
   import mx.charts.chartClasses.HLOCSeriesBase;
   import mx.charts.renderers.CandlestickItemRenderer;
   import mx.charts.series.items.HLOCSeriesItem;
   import mx.charts.styles.HaloDefaults;
   import mx.core.ClassFactory;
   import mx.events.PropertyChangeEvent;
   import mx.graphics.IFill;
   import mx.graphics.SolidColor;
   import mx.graphics.Stroke;
   import mx.styles.CSSStyleDeclaration;
   
   [Style(name="boxStroke",type="mx.graphics.IStroke",inherit="no")]
   [Style(name="declineFill",type="mx.graphics.IFill",inherit="no")]
   [Style(name="fills",type="Array",arrayType="mx.graphics.IFill",inherit="no")]
   [Style(name="stroke",type="mx.graphics.IStroke",inherit="no")]
   [Style(name="fill",type="mx.graphics.IFill",inherit="no")]
   public class CandlestickSeries extends HLOCSeriesBase
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static var stylesInited:Boolean = initStyles();
      
      private var _localFills:Array;
      
      private var _fillCount:int;
      
      private var _1757871014_fillFunction:Function;
      
      public function CandlestickSeries()
      {
         _1757871014_fillFunction = defaultFillFunction;
         super();
      }
      
      private static function initStyles() : Boolean
      {
         var candlestickSeriesStyle:CSSStyleDeclaration;
         HaloDefaults.init();
         candlestickSeriesStyle = HaloDefaults.createSelector("CandlestickSeries");
         candlestickSeriesStyle.defaultFactory = function():void
         {
            this.boxStroke = new Stroke(0,0);
            this.declineFill = new SolidColor(0);
            this.fill = new SolidColor(16777215);
            this.fills = [];
            this.itemRenderer = new ClassFactory(CandlestickItemRenderer);
            this.stroke = new Stroke(0,0);
         };
         return true;
      }
      
      [Bindable(event="propertyChange")]
      private function get _fillFunction() : Function
      {
         return this._1757871014_fillFunction;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         var styles:String = "fills";
         if(styles.indexOf(styleProp) != -1)
         {
            _localFills = getStyle("fills");
            _fillCount = _localFills.length;
            invalidateDisplayList();
            legendDataChanged();
         }
      }
      
      override public function findDataPoints(x:Number, y:Number, sensitivity:Number) : Array
      {
         var minItem:HLOCSeriesItem = null;
         var i:uint = 0;
         var v:HLOCSeriesItem = null;
         var dist:Number = NaN;
         var lowValue:Number = NaN;
         var highValue:Number = NaN;
         var ypos:Number = NaN;
         var id:uint = 0;
         var hd:HitData = null;
         var f:Object = null;
         if(interactive == false || !_renderData)
         {
            return [];
         }
         var minDist:Number = _renderData.renderedHalfWidth + sensitivity;
         var len:uint = _renderData.filteredCache.length;
         for(i = 0; i < len; i++)
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
            ypos = (minItem.open + minItem.close) / 2;
            id = uint(minItem.index);
            hd = new HitData(createDataID(id),Math.sqrt(minDist),minItem.x + _renderData.renderedXOffset,ypos,minItem);
            f = getStyle("declineFill");
            hd.contextColor = GraphicsUtilities.colorFromFill(HLOCSeriesItem(hd.chartItem).fill);
            hd.dataTipFunction = formatDataTip;
            return [hd];
         }
         return [];
      }
      
      private function set _fillFunction(value:Function) : void
      {
         var oldValue:Object = this._1757871014_fillFunction;
         if(oldValue !== value)
         {
            this._1757871014_fillFunction = value;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_fillFunction",oldValue,value));
         }
      }
      
      [Inspectable(category="General")]
      public function set fillFunction(value:Function) : void
      {
         if(value == _fillFunction)
         {
            return;
         }
         if(value != null)
         {
            _fillFunction = value;
         }
         else
         {
            _fillFunction = defaultFillFunction;
         }
         invalidateDisplayList();
         legendDataChanged();
      }
      
      override public function stylesInitialized() : void
      {
         _localFills = getStyle("fills");
         _fillCount = _localFills.length;
         super.stylesInitialized();
      }
      
      public function get fillFunction() : Function
      {
         return _fillFunction;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function defaultFillFunction(element:HLOCSeriesItem, i:Number) : IFill
      {
         if(_fillCount != 0)
         {
            return GraphicsUtilities.fillFromStyle(_localFills[i % _fillCount]);
         }
         var item:HLOCSeriesItem = HLOCSeriesItem(element);
         if(item.close > item.open)
         {
            return GraphicsUtilities.fillFromStyle(getStyle("declineFill"));
         }
         return GraphicsUtilities.fillFromStyle(getStyle("fill"));
      }
      
      override public function getAllDataPoints() : Array
      {
         var i:uint = 0;
         var v:HLOCSeriesItem = null;
         var itemExists:Boolean = false;
         var j:int = 0;
         var ypos:Number = NaN;
         var id:uint = 0;
         var hd:HitData = null;
         var f:Object = null;
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
               ypos = (v.open + v.close) / 2;
               id = uint(v.index);
               hd = new HitData(createDataID(id),Math.sqrt(0),v.x + _renderData.renderedXOffset,ypos,v);
               f = getStyle("declineFill");
               hd.contextColor = GraphicsUtilities.colorFromFill(HLOCSeriesItem(hd.chartItem).fill);
               hd.dataTipFunction = formatDataTip;
               result.push(hd);
            }
         }
         return result;
      }
   }
}

