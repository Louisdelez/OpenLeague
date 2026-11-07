package mx.charts.series
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import mx.charts.HitData;
   import mx.charts.chartClasses.BoundedValue;
   import mx.charts.chartClasses.CartesianChart;
   import mx.charts.chartClasses.CartesianTransform;
   import mx.charts.chartClasses.DataDescription;
   import mx.charts.chartClasses.GraphicsUtilities;
   import mx.charts.chartClasses.IAxis;
   import mx.charts.chartClasses.IStackable;
   import mx.charts.chartClasses.IStackable2;
   import mx.charts.chartClasses.InstanceCache;
   import mx.charts.chartClasses.LegendData;
   import mx.charts.chartClasses.Series;
   import mx.charts.chartClasses.StackedSeries;
   import mx.charts.renderers.AreaRenderer;
   import mx.charts.series.items.AreaSeriesItem;
   import mx.charts.series.renderData.AreaSeriesRenderData;
   import mx.charts.styles.HaloDefaults;
   import mx.collections.CursorBookmark;
   import mx.core.ClassFactory;
   import mx.core.IDataRenderer;
   import mx.core.IFactory;
   import mx.core.IFlexDisplayObject;
   import mx.events.PropertyChangeEvent;
   import mx.graphics.IFill;
   import mx.graphics.IStroke;
   import mx.graphics.SolidColor;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.ISimpleStyleClient;
   
   [Style(name="radius",type="Number",format="Length",inherit="no")]
   [Style(name="form",type="String",enumeration="segment,step,reverseStep,vertical,horizontal,curve",inherit="no")]
   [Style(name="areaStroke",type="mx.graphics.IStroke",inherit="no")]
   [Style(name="areaRenderer",type="mx.core.IFactory",inherit="no")]
   [Style(name="areaFill",type="mx.graphics.IFill",inherit="no")]
   [Style(name="fills",type="Array",arrayType="mx.graphics.IFill",inherit="no")]
   [Style(name="adjustedRadius",type="Number",format="Length",inherit="yes")]
   [Style(name="legendMarkerRenderer",type="mx.core.IFactory",inherit="no")]
   [Style(name="itemRenderer",type="mx.core.IFactory",inherit="no")]
   [Style(name="stroke",type="mx.graphics.IStroke",inherit="no")]
   [Style(name="fill",type="mx.graphics.IFill",inherit="no")]
   public class AreaSeries extends Series implements IStackable2
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static var stylesInited:Boolean = initStyles();
      
      private var _xField:String = "";
      
      private var _horizontalAxis:IAxis;
      
      private var _bAxesDirty:Boolean = false;
      
      private var _userMinField:String = "";
      
      private var _verticalAxis:IAxis;
      
      private var _yField:String = "";
      
      private var _minField:String = "";
      
      private var _sortOnXField:Boolean = true;
      
      private var _localFills:Array;
      
      private var _fillCount:int;
      
      private var _areaRenderer:IFlexDisplayObject;
      
      private var _instanceCache:InstanceCache;
      
      private var _stacked:Boolean = false;
      
      private var _1757871014_fillFunction:Function = defaultFillFunction;
      
      private var _transition:Boolean = false;
      
      private var _stacker:StackedSeries;
      
      private var _renderData:AreaSeriesRenderData;
      
      public function AreaSeries()
      {
         super();
         _instanceCache = new InstanceCache(null,this,1);
         _instanceCache.creationCallback = applyItemRendererProperties;
         dataTransform = new CartesianTransform();
      }
      
      private static function initStyles() : Boolean
      {
         var areaSeriesStyle:CSSStyleDeclaration;
         HaloDefaults.init();
         areaSeriesStyle = HaloDefaults.createSelector("AreaSeries");
         areaSeriesStyle.defaultFactory = function():void
         {
            this.areaRenderer = new ClassFactory(AreaRenderer);
            this.adjustedRadius = 2;
            this.legendMarkerRenderer = new ClassFactory(AreaSeriesLegendMarker);
            this.radius = 4;
            this.areaFill = new SolidColor(0);
            this.fills = [];
            this.stroke = HaloDefaults.pointStroke;
         };
         return true;
      }
      
      override protected function invalidateData(invalid:Boolean = true) : void
      {
         if(Boolean(_stacker))
         {
            _stacker.invalidateStacking();
         }
         super.invalidateData(invalid);
      }
      
      public function set yField(value:String) : void
      {
         _yField = value;
         dataChanged();
      }
      
      private function findClosestValidValue(index:uint, propName:String, cache:Array) : Number
      {
         var value:Number = NaN;
         var cachelen:int = 0;
         var lastValidIndex:int = int(index);
         if(lastValidIndex >= cache.length)
         {
            lastValidIndex = cache.length - 1;
         }
         while(lastValidIndex >= 0 && isNaN(cache[lastValidIndex][propName]))
         {
            lastValidIndex--;
         }
         if(lastValidIndex >= 0)
         {
            value = Number(cache[lastValidIndex][propName]);
         }
         if(isNaN(value))
         {
            lastValidIndex = index + 1;
            cachelen = int(cache.length);
            while(lastValidIndex < cachelen && isNaN(cache[lastValidIndex][propName]))
            {
               lastValidIndex++;
            }
            if(lastValidIndex < cachelen)
            {
               value = cache[lastValidIndex][propName] + 0.01 * (lastValidIndex - index);
            }
         }
         return value + 0.01 * (lastValidIndex - index);
      }
      
      public function set minField(value:String) : void
      {
         _userMinField = value;
         _minField = value;
         dataChanged();
      }
      
      override protected function invalidateMapping(invalid:Boolean = true) : void
      {
         if(Boolean(_stacker))
         {
            _stacker.invalidateStacking();
         }
         super.invalidateMapping(invalid);
      }
      
      override public function describeData(dimension:String, requiredFields:uint) : Array
      {
         var dataMargin:Number = NaN;
         var stroke:IStroke = null;
         var radius:Number = NaN;
         var renderer:Object = null;
         var cache:Array = null;
         validateData();
         if(_renderData.cache.length == 0)
         {
            return [];
         }
         var description:DataDescription = new DataDescription();
         description.boundedValues = null;
         if(dimension == CartesianTransform.VERTICAL_AXIS)
         {
            extractMinMax(_renderData.cache,"yNumber",description);
            if(_minField != "")
            {
               extractMinMax(_renderData.cache,"minNumber",description);
            }
            if((requiredFields & DataDescription.REQUIRED_BOUNDED_VALUES) != 0)
            {
               dataMargin = 0;
               stroke = getStyle("lineStroke");
               if(Boolean(stroke))
               {
                  dataMargin = stroke.weight / 2;
               }
               radius = Number(getStyle("radius"));
               renderer = getStyle("itemRenderer");
               if(radius > 0 && Boolean(renderer))
               {
                  stroke = getStyle("stroke");
                  if(Boolean(stroke))
                  {
                     radius += stroke.weight / 2;
                  }
                  dataMargin = Math.max(radius,dataMargin);
               }
               if(dataMargin > 0)
               {
                  description.boundedValues = [];
                  description.boundedValues.push(new BoundedValue(description.max,0,dataMargin));
                  description.boundedValues.push(new BoundedValue(description.min,dataMargin,0));
               }
            }
         }
         else
         {
            if(dimension != CartesianTransform.HORIZONTAL_AXIS)
            {
               return [];
            }
            if(_xField != "")
            {
               if((requiredFields & DataDescription.REQUIRED_MIN_INTERVAL) != 0)
               {
                  cache = _renderData.cache;
                  if(_sortOnXField == false)
                  {
                     cache = _renderData.cache.concat();
                     cache.sortOn("xNumber",Array.NUMERIC);
                  }
                  extractMinMax(cache,"xNumber",description,0 != (requiredFields & DataDescription.REQUIRED_MIN_INTERVAL));
               }
               else
               {
                  extractMinMax(_renderData.cache,"xNumber",description,(requiredFields & DataDescription.REQUIRED_MIN_INTERVAL) != 0);
               }
            }
            else
            {
               description.min = _renderData.cache[0].xNumber;
               description.max = _renderData.cache[_renderData.cache.length - 1].xNumber;
               if((requiredFields & DataDescription.REQUIRED_MIN_INTERVAL) != 0)
               {
                  extractMinInterval(_renderData.cache,"xNumber",description);
               }
            }
         }
         return [description];
      }
      
      override public function localToData(v:Point) : Array
      {
         return dataTransform.invertTransform(v.x - this.x,v.y - this.y);
      }
      
      [Inspectable(category="General")]
      public function get yField() : String
      {
         return _yField;
      }
      
      override public function getElementBounds(renderData:Object) : void
      {
         var pointRadius:Number = NaN;
         var v:AreaSeriesItem = null;
         var maxBounds:Rectangle = null;
         var i:int = 0;
         var b:Rectangle = null;
         var base:Number = NaN;
         var top:Number = NaN;
         var bottom:Number = NaN;
         var min:Number = NaN;
         var cache:Array = renderData.filteredCache;
         var rb:Array = [];
         var sampleCount:int = int(cache.length);
         if(Boolean(sampleCount))
         {
            pointRadius = Number(getStyle("radius"));
            if(isNaN(pointRadius))
            {
               pointRadius = 0;
            }
            v = cache[0];
            maxBounds = new Rectangle(v.x,v.y,0,0);
            if(minField == "")
            {
               base = Number(renderData.renderedBase);
               maxBounds.bottom = base;
               for(i = 0; i < sampleCount; i++)
               {
                  v = cache[i];
                  b = new Rectangle(v.x - pointRadius,v.y - pointRadius,2 * pointRadius,base - (v.y - pointRadius));
                  maxBounds.left = Math.min(maxBounds.left,b.left);
                  maxBounds.top = Math.min(maxBounds.top,b.top);
                  maxBounds.right = Math.max(maxBounds.right,b.right);
                  rb[i] = b;
               }
            }
            else
            {
               for(i = 0; i < sampleCount; i++)
               {
                  v = cache[i];
                  top = v.y - pointRadius;
                  bottom = v.min;
                  min = Math.min(top,bottom);
                  b = new Rectangle(v.x - pointRadius,min,2 * pointRadius,Math.max(top,bottom) - min);
                  maxBounds.left = Math.min(maxBounds.left,b.left);
                  maxBounds.top = Math.min(maxBounds.top,b.top);
                  maxBounds.right = Math.max(maxBounds.right,b.right);
                  maxBounds.bottom = Math.max(maxBounds.bottom,b.bottom);
                  rb[i] = b;
               }
            }
         }
         else
         {
            maxBounds = new Rectangle();
         }
         renderData.elementBounds = rb;
         renderData.bounds = maxBounds;
      }
      
      override public function beginInterpolation(sourceRenderData:Object, destRenderData:Object) : Object
      {
         var interpolatedFields:Object = {
            "x":true,
            "y":true
         };
         if(minField != "")
         {
            interpolatedFields["min"] = true;
         }
         var idata:Object = initializeInterpolationData(sourceRenderData.cache,destRenderData.filteredCache,interpolatedFields,itemType,{
            "sourceRenderData":sourceRenderData,
            "destRenderData":destRenderData
         });
         var interpolationRenderData:AreaSeriesRenderData = AreaSeriesRenderData(destRenderData.clone());
         interpolationRenderData.filteredCache = interpolationRenderData.cache = idata.cache;
         transitionRenderData = interpolationRenderData;
         return idata;
      }
      
      override public function stylesInitialized() : void
      {
         _localFills = getStyle("fills");
         _fillCount = _localFills.length;
         super.stylesInitialized();
      }
      
      override protected function updateData() : void
      {
         var i:int = 0;
         var itemType:Class = null;
         if(Boolean(_stacker))
         {
            _stacker.stack();
            super.updateData();
            return;
         }
         _stacked = false;
         var renderDataType:Class = this.renderDataType;
         _renderData = new renderDataType(this);
         _renderData.cache = [];
         if(Boolean(cursor))
         {
            cursor.seek(CursorBookmark.FIRST);
            i = 0;
            itemType = this.itemType;
            while(!cursor.afterLast)
            {
               _renderData.cache[i] = new itemType(this,cursor.current,i);
               i++;
               cursor.moveNext();
            }
            cacheDefaultValues(_yField,_renderData.cache,"yValue");
            cacheIndexValues(_xField,_renderData.cache,"xValue");
            if(_minField != "")
            {
               cacheNamedValues(_minField,_renderData.cache,"minValue");
            }
         }
         super.updateData();
      }
      
      override public function getItemsInRegion(r:Rectangle) : Array
      {
         var v:AreaSeriesItem = null;
         if(interactive == false || !_renderData)
         {
            return [];
         }
         var arrItems:Array = [];
         var localRectangle:Rectangle = new Rectangle();
         var len:uint = _renderData.filteredCache.length;
         localRectangle.topLeft = globalToLocal(r.topLeft);
         localRectangle.bottomRight = globalToLocal(r.bottomRight);
         for(var i:int = 0; i < len; i++)
         {
            v = _renderData.filteredCache[i];
            if(localRectangle.contains(v.x,v.y))
            {
               arrItems.push(v);
            }
         }
         return arrItems;
      }
      
      override protected function getMissingInterpolationValues(sourceProps:Object, srcCache:Array, destProps:Object, destCache:Array, index:Number, customData:Object) : void
      {
         var propName:String = null;
         var src:Number = NaN;
         var dst:Number = NaN;
         for(propName in sourceProps)
         {
            src = Number(sourceProps[propName]);
            dst = Number(destProps[propName]);
            if(isNaN(src))
            {
               if(srcCache.length == 0)
               {
                  sourceProps[propName] = propName == "x" ? dst : unscaledHeight;
               }
               else
               {
                  sourceProps[propName] = findClosestValidValue(index,propName,srcCache);
               }
            }
            if(isNaN(dst))
            {
               if(srcCache.length == 0)
               {
                  destProps[propName] = propName == "x" ? src : unscaledHeight;
               }
               else
               {
                  destProps[propName] = findClosestValidValue(index,propName,destCache);
               }
            }
         }
      }
      
      override public function dataToLocal(... dataValues) : Point
      {
         var data:Object = {};
         var da:Array = [data];
         var n:int = int(dataValues.length);
         if(n > 0)
         {
            data["d0"] = dataValues[0];
            dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).mapCache(da,"d0","v0");
         }
         if(n > 1)
         {
            data["d1"] = dataValues[1];
            dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).mapCache(da,"d1","v1");
         }
         dataTransform.transformCache(da,"v0","s0","v1","s1");
         return new Point(data.s0 + this.x,data.s1 + this.y);
      }
      
      override protected function updateFilter() : void
      {
         if(filterData)
         {
            _renderData.filteredCache = _renderData.cache.concat();
            dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).filterCache(_renderData.filteredCache,"xNumber","xFilter");
            stripNaNs(_renderData.filteredCache,"xFilter");
            dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).filterCache(_renderData.filteredCache,"yNumber","yFilter");
            stripNaNs(_renderData.filteredCache,"yFilter");
            if(_minField != "" || _stacked)
            {
               dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).filterCache(_renderData.filteredCache,"minNumber","minFilter");
               stripNaNs(_renderData.filteredCache,"minFilter");
            }
         }
         super.updateFilter();
      }
      
      private function formatDataTip(hd:HitData) : String
      {
         var dt:String = "";
         var n:String = displayName;
         if(Boolean(n) && n != "")
         {
            dt += "<b>" + n + "</b><BR/>";
         }
         var xName:String = dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).displayName;
         if(xName == "")
         {
            xName = xField;
         }
         if(xName != "")
         {
            dt += "<i>" + xName + ": </i>";
         }
         var item:AreaSeriesItem = AreaSeriesItem(hd.chartItem);
         var lowItem:AreaSeriesItem = minField != "" ? item : null;
         dt += dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).formatForScreen(item.xValue) + "\n";
         var yName:String = dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).displayName;
         if(!lowItem)
         {
            if(yName != "")
            {
               dt += "<i>" + yName + ":</i> ";
            }
            dt += dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).formatForScreen(item.yValue) + "\n";
         }
         else
         {
            if(yName != "")
            {
               dt += "<i>" + yName + " (high):</i> ";
            }
            else
            {
               dt += "<i>high: </i>";
            }
            dt += dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).formatForScreen(item.yValue) + "\n";
            if(yName != "")
            {
               dt += "<i>" + yName + " (low):</i> ";
            }
            else
            {
               dt += "<i>low:</i> ";
            }
            dt += dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).formatForScreen(lowItem.yValue) + "\n";
         }
         return dt;
      }
      
      public function stack(stackedXValueDictionary:Dictionary, previousElement:IStackable) : Number
      {
         var chartItem:AreaSeriesItem = null;
         var dataItem:* = undefined;
         var xValue:* = undefined;
         var yValue:Number = NaN;
         var stackedValue:Object = null;
         var i:uint = 0;
         var itemClass:Class = itemType;
         var haveYField:Boolean = _yField != null && _yField != "";
         var haveXField:Boolean = _xField != null && _xField != "";
         var maxValue:Number = 0;
         var renderDataType:Class = this.renderDataType;
         _renderData = new renderDataType(this);
         _renderData.cache = [];
         _renderData.filteredCache = [];
         if(Boolean(cursor))
         {
            cursor.seek(CursorBookmark.FIRST);
            while(!cursor.afterLast)
            {
               dataItem = cursor.current;
               _renderData.cache[i] = chartItem = new itemClass(this,dataItem,i);
               if(dataFunction != null)
               {
                  xValue = dataFunction(this,dataItem,"xValue");
                  yValue = dataFunction(this,dataItem,"yValue");
               }
               else
               {
                  xValue = haveXField ? dataItem[_xField] : i;
                  yValue = Number(haveYField ? dataItem[_yField] : dataItem);
               }
               if(xValue == null)
               {
                  i++;
                  cursor.moveNext();
               }
               else
               {
                  if(xValue is XMLList)
                  {
                     xValue = xValue.toString();
                  }
                  if(isNaN(yValue))
                  {
                     yValue = 0;
                  }
                  stackedValue = stackedXValueDictionary[xValue];
                  if(stackedValue == null)
                  {
                     stackedValue = 0;
                  }
                  yValue += stackedValue;
                  chartItem.minValue = stackedValue;
                  stackedXValueDictionary[xValue] = yValue;
                  chartItem.yValue = yValue;
                  chartItem.xValue = xValue;
                  maxValue = Math.max(maxValue,yValue);
                  i++;
                  cursor.moveNext();
               }
            }
         }
         invalidateMapping(true);
         invalidateData(false);
         _stacked = previousElement != null;
         return maxValue;
      }
      
      public function set stackTotals(totals:Dictionary) : void
      {
         var cache:Array = null;
         var n:int = 0;
         var i:int = 0;
         var item:AreaSeriesItem = null;
         var total:Number = NaN;
         if(Boolean(totals))
         {
            cache = _renderData.cache;
            n = int(_renderData.cache.length);
            for(i = 0; i < n; i++)
            {
               item = cache[i];
               total = Number(totals[item.xValue]);
               item.yValue = Math.min(100,Number(item.yValue) / total * 100);
               item.minValue = Math.min(100,Number(item.minValue) / total * 100);
            }
         }
      }
      
      override protected function updateTransform() : void
      {
         var cChart:CartesianChart = null;
         var seriesLen:int = 0;
         var secondSeriesLen:int = 0;
         var i:int = 0;
         if(dataProvider == null || _renderData.filteredCache.length == 0)
         {
            return;
         }
         dataTransform.transformCache(_renderData.filteredCache,"xNumber","x","yNumber","y");
         var baseVal:Number = dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).baseline;
         var stub:Array = [{"yNumber":baseVal}];
         dataTransform.transformCache(stub,null,null,"yNumber","y");
         _renderData.renderedBase = stub[0].y;
         if(_minField != "" || _stacked)
         {
            dataTransform.transformCache(_renderData.filteredCache,null,null,"minNumber","min");
         }
         super.updateTransform();
         allSeriesTransform = true;
         if(Boolean(chart) && chart is CartesianChart)
         {
            cChart = CartesianChart(chart);
            seriesLen = int(cChart.series.length);
            secondSeriesLen = int(cChart.secondSeries.length);
            for(i = 0; i < seriesLen; i++)
            {
               if(cChart.getSeriesTransformState(cChart.series[i]))
               {
                  allSeriesTransform = false;
               }
            }
            for(i = 0; i < secondSeriesLen; i++)
            {
               if(cChart.getSeriesTransformState(cChart.secondSeries[i]))
               {
                  allSeriesTransform = false;
               }
            }
            if(allSeriesTransform)
            {
               cChart.measureLabels();
            }
         }
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
      
      [Inspectable(category="Data")]
      public function get verticalAxis() : IAxis
      {
         return _verticalAxis;
      }
      
      protected function get renderDataType() : Class
      {
         return AreaSeriesRenderData;
      }
      
      public function get stacker() : StackedSeries
      {
         return _stacker;
      }
      
      override public function get items() : Array
      {
         return Boolean(_renderData) ? _renderData.filteredCache : null;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         var styles:String = "stroke fill";
         if(styleProp == null || styleProp == "" || styles.indexOf(styleProp) != -1)
         {
            legendDataChanged();
         }
         styles = "fills";
         if(styles.indexOf(styleProp) != -1)
         {
            _localFills = getStyle("fills");
            _fillCount = _localFills.length;
            legendDataChanged();
         }
         if(styleProp == "itemRenderer")
         {
            _instanceCache.remove = true;
            _instanceCache.discard = true;
            _instanceCache.count = 0;
            _instanceCache.discard = false;
            _instanceCache.remove = false;
         }
         invalidateDisplayList();
      }
      
      public function set sortOnXField(value:Boolean) : void
      {
         if(_sortOnXField == value)
         {
            return;
         }
         _sortOnXField = value;
         invalidateMapping();
      }
      
      override public function findDataPoints(x:Number, y:Number, sensitivity:Number) : Array
      {
         var minItem:AreaSeriesItem = null;
         var minIndex:int = 0;
         var low:Number = NaN;
         var high:Number = NaN;
         var cur:Number = NaN;
         var v:AreaSeriesItem = null;
         var dist:Number = NaN;
         var i:uint = 0;
         var hd:HitData = null;
         if(interactive == false || !_renderData)
         {
            return [];
         }
         var pr:Number = Number(getStyle("radius"));
         var minDist2:Number = pr + sensitivity;
         minDist2 *= minDist2;
         var pr2:Number = pr * pr;
         var len:int = int(_renderData.filteredCache.length);
         if(len == 0)
         {
            return [];
         }
         if(sortOnXField == true)
         {
            low = 0;
            high = len;
            cur = Math.floor((low + high) / 2);
            while(true)
            {
               v = _renderData.filteredCache[cur];
               if(!isNaN(v.yNumber))
               {
                  dist = (v.x - x) * (v.x - x) + (v.y - y) * (v.y - y);
                  if(dist <= minDist2)
                  {
                     minDist2 = dist;
                     minItem = v;
                     minIndex = cur;
                  }
               }
               if(v.x < x)
               {
                  low = cur;
                  cur = Math.floor((low + high) / 2);
                  if(cur == low)
                  {
                     break;
                  }
               }
               else
               {
                  high = cur;
                  cur = Math.floor((low + high) / 2);
                  if(cur == high)
                  {
                     break;
                  }
               }
            }
         }
         else
         {
            for(i = 0; i < len; i++)
            {
               v = _renderData.filteredCache[i];
               if(!isNaN(v.yFilter) && !isNaN(v.xFilter))
               {
                  dist = (v.x - x) * (v.x - x) + (v.y - y) * (v.y - y);
                  if(dist <= minDist2)
                  {
                     minDist2 = dist;
                     minItem = v;
                  }
               }
            }
         }
         if(Boolean(minItem))
         {
            hd = new HitData(createDataID(minItem.index),Math.sqrt(minDist2),minItem.x,minItem.y,minItem);
            hd.contextColor = GraphicsUtilities.colorFromFill(getStyle("areaFill"));
            hd.dataTipFunction = formatDataTip;
            return [hd];
         }
         return [];
      }
      
      [Inspectable(category="General")]
      public function get minField() : String
      {
         return _minField;
      }
      
      public function set horizontalAxis(value:IAxis) : void
      {
         _horizontalAxis = value;
         _bAxesDirty = true;
         invalidateData();
         invalidateProperties();
      }
      
      public function set xField(value:String) : void
      {
         _xField = value;
         dataChanged();
      }
      
      override protected function updateMapping() : void
      {
         dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).mapCache(_renderData.cache,"xValue","xNumber",_xField == "");
         dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).mapCache(_renderData.cache,"yValue","yNumber");
         if(_minField != "" || _stacked)
         {
            dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).mapCache(_renderData.cache,"minValue","minNumber");
         }
         if(_xField != "" && _sortOnXField)
         {
            _renderData.cache.sortOn("xNumber",Array.NUMERIC);
         }
         super.updateMapping();
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(Boolean(dataTransform))
         {
            if(Boolean(_horizontalAxis))
            {
               _horizontalAxis.chartDataProvider = dataProvider;
               CartesianTransform(dataTransform).setAxis(CartesianTransform.HORIZONTAL_AXIS,_horizontalAxis);
            }
            if(Boolean(_verticalAxis))
            {
               _verticalAxis.chartDataProvider = dataProvider;
               CartesianTransform(dataTransform).setAxis(CartesianTransform.VERTICAL_AXIS,_verticalAxis);
            }
         }
         var c:CartesianChart = CartesianChart(chart);
         if(Boolean(c))
         {
            if(!_horizontalAxis)
            {
               if(c.secondSeries.indexOf(this) != -1 && Boolean(c.secondHorizontalAxis))
               {
                  if(dataTransform.axes[CartesianTransform.HORIZONTAL_AXIS] != c.secondHorizontalAxis)
                  {
                     CartesianTransform(dataTransform).setAxis(CartesianTransform.HORIZONTAL_AXIS,c.secondHorizontalAxis);
                  }
               }
               else if(dataTransform.axes[CartesianTransform.HORIZONTAL_AXIS] != c.horizontalAxis)
               {
                  CartesianTransform(dataTransform).setAxis(CartesianTransform.HORIZONTAL_AXIS,c.horizontalAxis);
               }
            }
            if(!_verticalAxis)
            {
               if(c.secondSeries.indexOf(this) != -1 && Boolean(c.secondVerticalAxis))
               {
                  if(dataTransform.axes[CartesianTransform.VERTICAL_AXIS] != c.secondVerticalAxis)
                  {
                     CartesianTransform(dataTransform).setAxis(CartesianTransform.VERTICAL_AXIS,c.secondVerticalAxis);
                  }
               }
               else if(dataTransform.axes[CartesianTransform.VERTICAL_AXIS] != c.verticalAxis)
               {
                  CartesianTransform(dataTransform).setAxis(CartesianTransform.VERTICAL_AXIS,c.verticalAxis);
               }
            }
         }
         dataTransform.elements = [this];
      }
      
      override public function get legendData() : Array
      {
         var keyItems:Array = null;
         if(fillFunction != defaultFillFunction || _fillCount != 0)
         {
            return [];
         }
         var marker:IFlexDisplayObject = null;
         var ld:LegendData = new LegendData();
         ld.element = this;
         var markerClass:IFactory = getStyle("legendMarkerRenderer");
         if(Boolean(markerClass))
         {
            marker = markerClass.newInstance();
            if(Boolean(marker as ISimpleStyleClient))
            {
               (marker as ISimpleStyleClient).styleName = this;
            }
         }
         ld.marker = marker;
         ld.label = displayName;
         return [ld];
      }
      
      [Bindable(event="propertyChange")]
      private function get _fillFunction() : Function
      {
         return this._1757871014_fillFunction;
      }
      
      protected function applyItemRendererProperties(instance:DisplayObject, cache:InstanceCache) : void
      {
         if(instance is ISimpleStyleClient)
         {
            ISimpleStyleClient(instance).styleName = this;
         }
      }
      
      [Inspectable]
      public function get sortOnXField() : Boolean
      {
         return _sortOnXField;
      }
      
      override protected function get renderData() : Object
      {
         var renderDataType:Class = null;
         var td:AreaSeriesRenderData = null;
         if(!_renderData)
         {
            renderDataType = this.renderDataType;
            td = new renderDataType(this);
            td.cache = td.filteredCache = [];
            td.radius = 0;
            return td;
         }
         _renderData.radius = getStyle("radius");
         return _renderData;
      }
      
      [Inspectable(category="General")]
      public function get xField() : String
      {
         return _xField;
      }
      
      private function defaultFillFunction(element:AreaSeriesItem, i:Number) : IFill
      {
         if(_fillCount != 0)
         {
            return GraphicsUtilities.fillFromStyle(_localFills[i % _fillCount]);
         }
         return GraphicsUtilities.fillFromStyle(getStyle("fill"));
      }
      
      [Inspectable(category="Data")]
      public function get horizontalAxis() : IAxis
      {
         return _horizontalAxis;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get upperBoundCache() : Array
      {
         return _renderData.cache;
      }
      
      public function set stacker(value:StackedSeries) : void
      {
         _stacker = value;
      }
      
      protected function get itemType() : Class
      {
         return AreaSeriesItem;
      }
      
      public function set verticalAxis(value:IAxis) : void
      {
         _verticalAxis = value;
         _bAxesDirty = true;
         invalidateData();
         invalidateProperties();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var i:int = 0;
         var v:AreaSeriesItem = null;
         var elementBounds:Array = null;
         var pointRadius:Number = NaN;
         var sampleCount:int = 0;
         var renderCache:Array = null;
         var rcBounds:Rectangle = null;
         var asClass:IFactory = null;
         var instances:Array = null;
         var bSetData:Boolean = false;
         var rc:Rectangle = null;
         var inst:IFlexDisplayObject = null;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(!_areaRenderer)
         {
            asClass = getStyle("areaRenderer");
            _areaRenderer = asClass.newInstance();
            if(_areaRenderer is ISimpleStyleClient)
            {
               (_areaRenderer as ISimpleStyleClient).styleName = this;
            }
            addChildAt(_areaRenderer as DisplayObject,0);
         }
         var renderData:AreaSeriesRenderData = Boolean(transitionRenderData) ? AreaSeriesRenderData(transitionRenderData) : _renderData;
         var activeRenderCache:Array = renderData.filteredCache;
         if(renderData == transitionRenderData && Boolean(transitionRenderData.elementBounds))
         {
            elementBounds = renderData.elementBounds;
            sampleCount = int(elementBounds.length);
            pointRadius = renderData.radius;
            for(i = 0; i < sampleCount; i++)
            {
               rcBounds = elementBounds[i];
               v = activeRenderCache[i];
               v.x = (rcBounds.left + rcBounds.right) / 2;
               v.y = rcBounds.top + pointRadius;
               v.min = rcBounds.bottom;
            }
            _transition = true;
         }
         else if(_transition && minField == "" && Boolean(renderData.elementBounds))
         {
            elementBounds = renderData.elementBounds;
            sampleCount = int(elementBounds.length);
            for(i = 0; i < sampleCount; i++)
            {
               v = activeRenderCache[i];
               v.min = NaN;
            }
            _transition = false;
         }
         _areaRenderer.setActualSize(unscaledWidth,unscaledHeight);
         (_areaRenderer as IDataRenderer).data = renderData;
         sampleCount = int(activeRenderCache.length);
         pointRadius = Number(getStyle("radius"));
         if(isNaN(pointRadius))
         {
            pointRadius = 0;
         }
         if(pointRadius > 0)
         {
            _instanceCache.factory = getStyle("itemRenderer");
            _instanceCache.count = sampleCount;
            instances = _instanceCache.instances;
            bSetData = sampleCount > 0 && instances[0] is IDataRenderer;
            if(renderData == transitionRenderData && Boolean(renderData.elementBounds))
            {
               elementBounds = renderData.elementBounds;
               for(i = 0; i < sampleCount; i++)
               {
                  inst = instances[i];
                  v = activeRenderCache[i];
                  v.fill = fillFunction(v,i);
                  if(!v.fill)
                  {
                     v.fill = defaultFillFunction(v,i);
                  }
                  v.itemRenderer = inst;
                  if(Boolean(v.itemRenderer) && (v.itemRenderer as Object).hasOwnProperty("invalidateDisplayList"))
                  {
                     (v.itemRenderer as Object).invalidateDisplayList();
                  }
                  if(Boolean(inst))
                  {
                     if(bSetData)
                     {
                        (inst as IDataRenderer).data = v;
                     }
                     rc = elementBounds[i];
                     inst.move(rc.left,rc.top);
                     inst.setActualSize(rc.width,rc.height);
                  }
               }
            }
            else
            {
               for(i = 0; i < sampleCount; i++)
               {
                  v = activeRenderCache[i];
                  inst = instances[i];
                  v.fill = fillFunction(v,i);
                  if(!v.fill)
                  {
                     v.fill = defaultFillFunction(v,i);
                  }
                  v.itemRenderer = inst;
                  if(Boolean(v.itemRenderer) && (v.itemRenderer as Object).hasOwnProperty("invalidateDisplayList"))
                  {
                     (v.itemRenderer as Object).invalidateDisplayList();
                  }
                  if(Boolean(inst))
                  {
                     if(bSetData)
                     {
                        (inst as IDataRenderer).data = v;
                     }
                     rc = new Rectangle(v.x - pointRadius,v.y - pointRadius,2 * pointRadius,2 * pointRadius);
                     inst.move(rc.left,rc.top);
                     inst.setActualSize(rc.width,rc.height);
                  }
               }
               if(Boolean(chart) && Boolean(allSeriesTransform) && chart.chartState == 0)
               {
                  chart.updateAllDataTips();
               }
            }
         }
      }
      
      override public function getAllDataPoints() : Array
      {
         var i:uint = 0;
         var v:AreaSeriesItem = null;
         var itemExists:Boolean = false;
         var j:int = 0;
         var hd:HitData = null;
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
               hd = new HitData(createDataID(v.index),Math.sqrt(0),v.x,v.y,v);
               hd.contextColor = GraphicsUtilities.colorFromFill(getStyle("areaFill"));
               hd.dataTipFunction = formatDataTip;
               result.push(hd);
            }
         }
         return result;
      }
      
      public function stackAll(stackedPosXValueDictionary:Dictionary, stackedNegXValueDictionary:Dictionary, previousElement:IStackable2) : Object
      {
         var chartItem:AreaSeriesItem = null;
         var dataItem:* = undefined;
         var xValue:* = undefined;
         var yValue:Number = NaN;
         var stackedValue:Object = null;
         var i:uint = 0;
         var itemClass:Class = itemType;
         var haveYField:Boolean = _yField != null && _yField != "";
         var haveXField:Boolean = _xField != null && _xField != "";
         var maxValue:Number = 0;
         var minValue:Number = 0;
         var renderDataType:Class = this.renderDataType;
         _renderData = new renderDataType(this);
         _renderData.cache = [];
         _renderData.filteredCache = [];
         if(Boolean(cursor))
         {
            cursor.seek(CursorBookmark.FIRST);
            while(!cursor.afterLast)
            {
               dataItem = cursor.current;
               _renderData.cache[i] = chartItem = new itemClass(this,dataItem,i);
               if(dataFunction != null)
               {
                  xValue = dataFunction(this,dataItem,"xValue");
                  yValue = dataFunction(this,dataItem,"yValue");
               }
               else
               {
                  xValue = haveXField ? dataItem[_xField] : i;
                  yValue = Number(haveYField ? dataItem[_yField] : dataItem);
               }
               if(xValue == null)
               {
                  i++;
                  cursor.moveNext();
               }
               else
               {
                  if(xValue is XMLList)
                  {
                     xValue = xValue.toString();
                  }
                  if(isNaN(yValue))
                  {
                     yValue = 0;
                  }
                  if(yValue >= 0)
                  {
                     stackedValue = stackedPosXValueDictionary[xValue];
                  }
                  else
                  {
                     stackedValue = stackedNegXValueDictionary[xValue];
                  }
                  if(stackedValue == null)
                  {
                     stackedValue = 0;
                  }
                  yValue += stackedValue;
                  chartItem.minValue = stackedValue;
                  if(yValue >= 0)
                  {
                     stackedPosXValueDictionary[xValue] = yValue;
                     maxValue = Math.max(maxValue,yValue);
                  }
                  else if(yValue < 0)
                  {
                     stackedNegXValueDictionary[xValue] = yValue;
                     minValue = Math.min(minValue,yValue);
                  }
                  chartItem.yValue = yValue;
                  chartItem.xValue = xValue;
                  i++;
                  cursor.moveNext();
               }
            }
         }
         invalidateMapping(true);
         invalidateData(false);
         _stacked = previousElement != null;
         return {
            "maxValue":maxValue,
            "minValue":minValue
         };
      }
      
      public function get fillFunction() : Function
      {
         return _fillFunction;
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
   }
}

import flash.display.Graphics;
import flash.geom.Rectangle;
import mx.charts.chartClasses.GraphicsUtilities;
import mx.graphics.IFill;
import mx.graphics.IStroke;
import mx.skins.ProgrammaticSkin;

class AreaSeriesLegendMarker extends ProgrammaticSkin
{
   
   public function AreaSeriesLegendMarker()
   {
      super();
   }
   
   override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
   {
      var strokeWeight:Number = NaN;
      super.updateDisplayList(unscaledWidth,unscaledHeight);
      var fill:IFill = GraphicsUtilities.fillFromStyle(getStyle("areaFill"));
      var stroke:IStroke = getStyle("areaStroke");
      var w:Number = Boolean(stroke) ? 0.5 : 0;
      var rc:Rectangle = new Rectangle(w,w,width - 2 * w,height - 2 * w);
      var g:Graphics = graphics;
      g.clear();
      g.moveTo(rc.left,rc.top);
      if(Boolean(stroke))
      {
         strokeWeight = Number(stroke.weight);
         stroke.weight = 1;
         stroke.apply(g);
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
         stroke.weight = strokeWeight;
      }
   }
}
