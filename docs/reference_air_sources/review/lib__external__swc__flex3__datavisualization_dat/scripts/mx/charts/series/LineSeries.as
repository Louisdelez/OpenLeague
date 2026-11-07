package mx.charts.series
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.charts.HitData;
   import mx.charts.chartClasses.BoundedValue;
   import mx.charts.chartClasses.CartesianChart;
   import mx.charts.chartClasses.CartesianTransform;
   import mx.charts.chartClasses.DataDescription;
   import mx.charts.chartClasses.GraphicsUtilities;
   import mx.charts.chartClasses.IAxis;
   import mx.charts.chartClasses.InstanceCache;
   import mx.charts.chartClasses.LegendData;
   import mx.charts.chartClasses.Series;
   import mx.charts.renderers.LineRenderer;
   import mx.charts.series.items.LineSeriesItem;
   import mx.charts.series.items.LineSeriesSegment;
   import mx.charts.series.renderData.LineSeriesRenderData;
   import mx.charts.styles.HaloDefaults;
   import mx.collections.CursorBookmark;
   import mx.core.ClassFactory;
   import mx.core.IDataRenderer;
   import mx.core.IFactory;
   import mx.core.IFlexDisplayObject;
   import mx.events.PropertyChangeEvent;
   import mx.graphics.IFill;
   import mx.graphics.IStroke;
   import mx.graphics.LinearGradientStroke;
   import mx.graphics.SolidColor;
   import mx.graphics.Stroke;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.ISimpleStyleClient;
   
   [Style(name="radius",type="Number",format="Length",inherit="no")]
   [Style(name="lineStroke",type="mx.graphics.IStroke",inherit="no")]
   [Style(name="lineSegmentRenderer",type="mx.core.IFactory",inherit="no")]
   [Style(name="form",type="String",enumeration="segment,step,reverseStep,vertical,horizontal,curve",inherit="no")]
   [Style(name="fills",type="Array",arrayType="mx.graphics.IFill",inherit="no")]
   [Style(name="adjustedRadius",type="Number",format="Length",inherit="yes")]
   [Style(name="legendMarkerRenderer",type="mx.core.IFactory",inherit="no")]
   [Style(name="itemRenderer",type="mx.core.IFactory",inherit="no")]
   [Style(name="stroke",type="mx.graphics.IStroke",inherit="no")]
   [Style(name="fill",type="mx.graphics.IFill",inherit="no")]
   public class LineSeries extends Series
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static var stylesInited:Boolean = initStyles();
      
      private var _xField:String = "";
      
      private var _interpolateValues:Boolean = false;
      
      private var _bAxesDirty:Boolean = false;
      
      private var _horizontalAxis:IAxis;
      
      private var _verticalAxis:IAxis;
      
      private var _yField:String = "";
      
      private var _sortOnXField:Boolean = true;
      
      private var _localFills:Array;
      
      private var _fillCount:int;
      
      private var _segmentInstanceCache:InstanceCache;
      
      private var _pointInstanceCache:InstanceCache;
      
      private var _1757871014_fillFunction:Function = defaultFillFunction;
      
      private var _renderData:LineSeriesRenderData;
      
      public function LineSeries()
      {
         super();
         _pointInstanceCache = new InstanceCache(null,this,1000);
         _pointInstanceCache.creationCallback = applyItemRendererProperties;
         _segmentInstanceCache = new InstanceCache(null,this,0);
         _segmentInstanceCache.properties = {"styleName":this};
         dataTransform = new CartesianTransform();
      }
      
      private static function initStyles() : Boolean
      {
         var seriesStyle:CSSStyleDeclaration;
         HaloDefaults.init();
         seriesStyle = HaloDefaults.createSelector("LineSeries");
         seriesStyle.defaultFactory = function():void
         {
            this.adjustedRadius = 2;
            this.fill = new SolidColor(16777215);
            this.lineSegmentRenderer = new ClassFactory(LineRenderer);
            this.lineStroke = new Stroke(0,3);
            this.radius = 4;
            this.fills = [];
         };
         return true;
      }
      
      [Inspectable(category="General")]
      public function get interpolateValues() : Boolean
      {
         return _interpolateValues;
      }
      
      public function set interpolateValues(value:Boolean) : void
      {
         if(_interpolateValues != value)
         {
            _interpolateValues = value;
            invalidateData();
         }
      }
      
      public function set yField(value:String) : void
      {
         _yField = value;
         dataChanged();
      }
      
      [Inspectable(category="General")]
      public function get yField() : String
      {
         return _yField;
      }
      
      [Inspectable(category="Styles")]
      public function get radius() : Number
      {
         return getStyle("radius");
      }
      
      override protected function updateData() : void
      {
         var i:int = 0;
         var itemClass:Class = null;
         var renderDataType:Class = this.renderDataType;
         _renderData = new renderDataType();
         _renderData.cache = [];
         if(Boolean(dataProvider))
         {
            cursor.seek(CursorBookmark.FIRST);
            i = 0;
            itemClass = itemType;
            while(!cursor.afterLast)
            {
               _renderData.cache[i] = new itemClass(this,cursor.current,i);
               i++;
               cursor.moveNext();
            }
            cacheDefaultValues(_yField,_renderData.cache,"yValue");
            cacheIndexValues(_xField,_renderData.cache,"xValue");
         }
         _renderData.validPoints = _renderData.cache.length;
         super.updateData();
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
         return [description];
      }
      
      override public function stylesInitialized() : void
      {
         _localFills = getStyle("fills");
         _fillCount = _localFills.length;
         super.stylesInitialized();
      }
      
      override public function getElementBounds(renderData:Object) : void
      {
         var radius:Number = NaN;
         var segCount:int = 0;
         var j:int = 0;
         var v:Object = null;
         var maxBounds:Rectangle = null;
         var seg:Object = null;
         var i:int = 0;
         var b:Rectangle = null;
         var cache:Array = renderData.cache;
         var segments:Array = renderData.segments;
         var rb:Array = [];
         var sampleCount:int = int(cache.length);
         if(sampleCount == 0)
         {
            maxBounds = new Rectangle();
         }
         else
         {
            radius = Number(renderData.radius);
            if(radius == 0 || isNaN(radius))
            {
               radius = 1;
            }
            segCount = int(segments.length);
            if(Boolean(segCount))
            {
               v = cache[renderData.segments[0].start];
               maxBounds = new Rectangle(v.x,v.y,0,0);
            }
            for(j = 0; j < segCount; j++)
            {
               seg = renderData.segments[j];
               for(i = int(seg.start); i <= seg.end; i++)
               {
                  v = cache[i];
                  b = new Rectangle(v.x - radius,v.y - radius,2 * radius,2 * radius);
                  maxBounds.left = Math.min(maxBounds.left,b.left);
                  maxBounds.top = Math.min(maxBounds.top,b.top);
                  maxBounds.right = Math.max(maxBounds.right,b.right);
                  maxBounds.bottom = Math.max(maxBounds.bottom,b.bottom);
                  rb[i] = b;
               }
            }
         }
         renderData.elementBounds = rb;
         renderData.bounds = maxBounds;
      }
      
      override public function beginInterpolation(sourceRenderData:Object, destRenderData:Object) : Object
      {
         var idata:Object = initializeInterpolationData(sourceRenderData.cache,destRenderData.cache,{
            "x":true,
            "y":true
         },itemType,{
            "sourceRenderData":sourceRenderData,
            "destRenderData":destRenderData
         });
         var interpolationRenderData:LineSeriesRenderData = LineSeriesRenderData(destRenderData.clone());
         interpolationRenderData.cache = idata.cache;
         interpolationRenderData.filteredCache = idata.cache;
         var segs:Array = interpolationRenderData.segments;
         var len:int = int(segs.length);
         for(var i:int = 0; i < len; i++)
         {
            segs[i].items = idata.cache;
         }
         transitionRenderData = interpolationRenderData;
         return idata;
      }
      
      override public function localToData(v:Point) : Array
      {
         return dataTransform.invertTransform(v.x - this.x,v.y - this.y);
      }
      
      override protected function updateFilter() : void
      {
         var start:int = 0;
         var end:int = 0;
         var len:int = 0;
         var i:int = 0;
         var v:LineSeriesItem = null;
         _renderData.segments = [];
         var lineSegmentType:Class = this.lineSegmentType;
         if(filterData)
         {
            _renderData.filteredCache = _renderData.cache.concat();
            dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).filterCache(_renderData.filteredCache,"xNumber","xFilter");
            dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).filterCache(_renderData.filteredCache,"yNumber","yFilter");
            if(xField != "" && sortOnXField)
            {
               stripNaNs(_renderData.filteredCache,"xFilter");
            }
            _renderData.validPoints = _renderData.filteredCache.length;
            if(_interpolateValues == false)
            {
               end = -1;
               len = int(_renderData.filteredCache.length);
               while(end < len)
               {
                  for(i = end + 1; i < len; i++)
                  {
                     v = LineSeriesItem(_renderData.filteredCache[i]);
                     if(!isNaN(v.xFilter) && !isNaN(v.yFilter))
                     {
                        break;
                     }
                     --_renderData.validPoints;
                  }
                  if(i == len)
                  {
                     break;
                  }
                  start = i;
                  for(i = start + 1; i < len; i++)
                  {
                     v = LineSeriesItem(_renderData.filteredCache[i]);
                     if(isNaN(v.xFilter) || isNaN(v.yFilter))
                     {
                        break;
                     }
                  }
                  end = i - 1;
                  if(end != start)
                  {
                     _renderData.segments.push(new lineSegmentType(this,_renderData.segments.length,_renderData.filteredCache,start,end));
                  }
               }
            }
            else
            {
               stripNaNs(_renderData.filteredCache,"yFilter");
               _renderData.validPoints = _renderData.filteredCache.length;
               if(_renderData.filteredCache.length > 1)
               {
                  _renderData.segments.push(new lineSegmentType(this,0,_renderData.filteredCache,start,_renderData.filteredCache.length - 1));
               }
            }
         }
         else
         {
            _renderData.filteredCache = _renderData.cache;
            _renderData.segments.push(new lineSegmentType(this,0,_renderData.filteredCache,start,_renderData.filteredCache.length - 1));
         }
         super.updateFilter();
      }
      
      override protected function updateTransform() : void
      {
         var cChart:CartesianChart = null;
         var seriesLen:int = 0;
         var secondSeriesLen:int = 0;
         var i:int = 0;
         dataTransform.transformCache(_renderData.filteredCache,"xNumber","x","yNumber","y");
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
      
      public function set radius(value:Number) : void
      {
         setStyle("radius",value);
      }
      
      override protected function getMissingInterpolationValues(sourceProps:Object, srcCache:Array, destProps:Object, destCache:Array, index:Number, customData:Object) : void
      {
         var propName:String = null;
         var src:Number = NaN;
         var dst:Number = NaN;
         var lastValidIndex:int = 0;
         var cachelen:int = 0;
         var cache:Array = customData.sourceRenderData.cache;
         var dstCache:Array = customData.destRenderData.cache;
         for(propName in sourceProps)
         {
            src = Number(sourceProps[propName]);
            dst = Number(destProps[propName]);
            lastValidIndex = index;
            if(isNaN(src))
            {
               if(cache.length == 0)
               {
                  src = propName == "x" ? Number(dstCache[index].x) : Number(unscaledHeight);
               }
               else
               {
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
                     src = cache[lastValidIndex][propName] + 0.01 * (lastValidIndex - index);
                  }
                  if(isNaN(src))
                  {
                     lastValidIndex = index + 1;
                     cachelen = int(cache.length);
                     while(lastValidIndex < cachelen && isNaN(cache[lastValidIndex][propName]))
                     {
                        lastValidIndex++;
                     }
                     if(lastValidIndex < cachelen)
                     {
                        src = cache[lastValidIndex][propName] + 0.01 * (lastValidIndex - index);
                     }
                  }
               }
            }
            sourceProps[propName] = src;
            destProps[propName] = dst;
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
      
      private function formatDataTip(hd:HitData) : String
      {
         var dt:String = "";
         var n:String = displayName;
         if(Boolean(n) && n != "")
         {
            dt += "<b>" + n + "</b><BR/>";
         }
         var xName:String = dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).displayName;
         if(xName != "")
         {
            dt += "<i>" + xName + ":</i> ";
         }
         dt += dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).formatForScreen(LineSeriesItem(hd.chartItem).xValue) + "\n";
         var yName:String = dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).displayName;
         if(yName != "")
         {
            dt += "<i>" + yName + ":</i> ";
         }
         return dt + (dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).formatForScreen(LineSeriesItem(hd.chartItem).yValue) + "\n");
      }
      
      override public function getItemsInRegion(r:Rectangle) : Array
      {
         var v:LineSeriesItem = null;
         if(interactive == false || !_renderData)
         {
            return [];
         }
         var arrItems:Array = [];
         var rc:Rectangle = new Rectangle();
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
      
      [Inspectable(environment="none")]
      protected function get renderDataType() : Class
      {
         return LineSeriesRenderData;
      }
      
      override public function get items() : Array
      {
         return Boolean(_renderData) ? _renderData.filteredCache : null;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         var styles:String = "fills";
         if(styles.indexOf(styleProp) != -1)
         {
            _localFills = getStyle("fills");
            _fillCount = _localFills.length;
         }
         if(styleProp == "itemRenderer")
         {
            _pointInstanceCache.remove = true;
            _pointInstanceCache.discard = true;
            _pointInstanceCache.count = 0;
            _pointInstanceCache.discard = false;
            _pointInstanceCache.remove = false;
         }
         if(styleProp == "lineSegmentRenderer")
         {
            _segmentInstanceCache.remove = true;
            _segmentInstanceCache.discard = true;
            _segmentInstanceCache.count = 0;
            _segmentInstanceCache.discard = false;
            _segmentInstanceCache.remove = false;
         }
         invalidateDisplayList();
         legendDataChanged();
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
         var low:Number = NaN;
         var high:Number = NaN;
         var cur:Number = NaN;
         var bFirstIsNaN:Boolean = false;
         var v:LineSeriesItem = null;
         var dist:Number = NaN;
         var i:uint = 0;
         var hd:HitData = null;
         var istroke:IStroke = null;
         var gb:LinearGradientStroke = null;
         if(interactive == false || !_renderData)
         {
            return [];
         }
         var pr:Number = Number(getStyle("radius"));
         var minDist2:Number = pr + sensitivity;
         minDist2 *= minDist2;
         var minItem:LineSeriesItem = null;
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
            bFirstIsNaN = isNaN(_renderData.filteredCache[0]);
            while(true)
            {
               v = _renderData.filteredCache[cur];
               if(!isNaN(v.yFilter) && !isNaN(v.xFilter))
               {
                  dist = (v.x - x) * (v.x - x) + (v.y - y) * (v.y - y);
                  if(dist <= minDist2)
                  {
                     minDist2 = dist;
                     minItem = v;
                  }
               }
               if(v.x < x || isNaN(v.x) && bFirstIsNaN)
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
            istroke = getStyle("lineStroke");
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
            return [hd];
         }
         return [];
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
         var markerAspectRatio:Number = NaN;
         var marker:IFlexDisplayObject = null;
         var keyItems:Array = null;
         if(fillFunction != defaultFillFunction || _fillCount != 0)
         {
            return [];
         }
         var radius:Number = Number(getStyle("radius"));
         var itemRenderer:IFactory = getStyle("itemRenderer");
         var color:int = 0;
         var ld:LegendData = new LegendData();
         ld.element = this;
         ld.label = displayName;
         var markerFactory:IFactory = getStyle("legendMarkerRenderer");
         if(Boolean(markerFactory))
         {
            marker = markerFactory.newInstance();
            if(marker is ISimpleStyleClient)
            {
               (marker as ISimpleStyleClient).styleName = this;
            }
            ld.aspectRatio = 1;
         }
         else if(!itemRenderer || radius == 0 || isNaN(radius))
         {
            marker = new LineSeriesLegendMarker(this);
         }
         else
         {
            markerFactory = getStyle("itemRenderer");
            marker = markerFactory.newInstance();
            ld.aspectRatio = 1;
            if(Boolean(marker as ISimpleStyleClient))
            {
               (marker as ISimpleStyleClient).styleName = this;
            }
         }
         ld.marker = marker;
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
         var ld:LineSeriesRenderData = null;
         if(!_renderData || !_renderData.cache || _renderData.cache.length == 0)
         {
            renderDataType = this.renderDataType;
            ld = new renderDataType();
            ld.cache = ld.filteredCache = [];
            ld.segments = [];
            ld.radius = 0;
            return ld;
         }
         _renderData.radius = getStyle("radius");
         return _renderData;
      }
      
      [Inspectable(category="General")]
      public function get xField() : String
      {
         return _xField;
      }
      
      private function defaultFillFunction(element:LineSeriesItem, i:Number) : IFill
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
      
      [Inspectable(environment="none")]
      protected function get itemType() : Class
      {
         return LineSeriesItem;
      }
      
      public function set verticalAxis(value:IAxis) : void
      {
         _verticalAxis = value;
         _bAxesDirty = true;
         invalidateData();
         invalidateProperties();
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
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var i:int = 0;
         var activeRenderCache:Array = null;
         var v:LineSeriesItem = null;
         var elementBounds:Array = null;
         var rcBounds:Object = null;
         var localData:LineSeriesItem = null;
         var segment:IFlexDisplayObject = null;
         var nextInstanceIdx:int = 0;
         var bSetData:Boolean = false;
         var rc:Rectangle = null;
         var inst:IFlexDisplayObject = null;
         var e:Object = null;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var renderData:LineSeriesRenderData = Boolean(transitionRenderData) ? LineSeriesRenderData(transitionRenderData) : _renderData;
         if(!renderData || !renderData.filteredCache)
         {
            return;
         }
         var g:Graphics = graphics;
         g.clear();
         var radius:Number = Number(getStyle("radius"));
         var sampleCount:int = int(renderData.filteredCache.length);
         var segCount:int = int(renderData.segments.length);
         if(renderData == transitionRenderData && Boolean(renderData.elementBounds))
         {
            elementBounds = renderData.elementBounds;
            sampleCount = int(elementBounds.length);
            activeRenderCache = renderData.filteredCache;
            for(i = 0; i < sampleCount; i++)
            {
               rcBounds = elementBounds[i];
               localData = activeRenderCache[i];
               localData.x = (rcBounds.left + rcBounds.right) / 2;
               localData.y = (rcBounds.bottom + rcBounds.top) / 2;
            }
         }
         else
         {
            activeRenderCache = renderData.filteredCache;
         }
         _segmentInstanceCache.factory = getStyle("lineSegmentRenderer");
         _segmentInstanceCache.count = segCount;
         var instances:Array = _segmentInstanceCache.instances;
         for(i = 0; i < segCount; i++)
         {
            segment = instances[i];
            if(segment is IDataRenderer)
            {
               IDataRenderer(segment).data = renderData.segments[i];
            }
            segment.setActualSize(unscaledWidth,unscaledHeight);
         }
         if(radius > 0)
         {
            _pointInstanceCache.factory = getStyle("itemRenderer");
            _pointInstanceCache.count = renderData.validPoints;
            instances = _pointInstanceCache.instances;
            nextInstanceIdx = 0;
            bSetData = sampleCount > 0 && instances[0] is IDataRenderer;
            if(renderData == transitionRenderData && Boolean(renderData.elementBounds))
            {
               for(i = 0; i < sampleCount; i++)
               {
                  v = activeRenderCache[i];
                  inst = instances[nextInstanceIdx++];
                  v.itemRenderer = inst;
                  v.fill = fillFunction(v,i);
                  if(!v.fill)
                  {
                     v.fill = defaultFillFunction(v,i);
                  }
                  if(Boolean(v.itemRenderer) && (v.itemRenderer as Object).hasOwnProperty("invalidateDisplayList"))
                  {
                     (v.itemRenderer as Object).invalidateDisplayList();
                  }
                  if(Boolean(inst))
                  {
                     if(bSetData)
                     {
                        IDataRenderer(inst).data = v;
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
                  e = renderData.filteredCache[i];
                  if(!(filterData && (isNaN(e.xFilter) || isNaN(e.yFilter))))
                  {
                     inst = instances[nextInstanceIdx++];
                     v.itemRenderer = inst;
                     v.fill = fillFunction(v,i);
                     if(!v.fill)
                     {
                        v.fill = defaultFillFunction(v,i);
                     }
                     if(Boolean(v.itemRenderer) && (v.itemRenderer as Object).hasOwnProperty("invalidateDisplayList"))
                     {
                        (v.itemRenderer as Object).invalidateDisplayList();
                     }
                     if(Boolean(inst))
                     {
                        if(bSetData)
                        {
                           IDataRenderer(inst).data = v;
                        }
                        inst.move(v.x - radius,v.y - radius);
                        inst.setActualSize(2 * radius,2 * radius);
                     }
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
         var v:LineSeriesItem = null;
         var itemExists:Boolean = false;
         var j:int = 0;
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
               hd = new HitData(createDataID(v.index),Math.sqrt(0),v.x,v.y,v);
               istroke = getStyle("lineStroke");
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
      
      [Inspectable(environment="none")]
      protected function get lineSegmentType() : Class
      {
         return LineSeriesSegment;
      }
      
      public function get fillFunction() : Function
      {
         return _fillFunction;
      }
   }
}

import flash.display.Graphics;
import mx.charts.series.LineSeries;
import mx.graphics.IStroke;
import mx.graphics.LinearGradientStroke;
import mx.graphics.Stroke;
import mx.skins.ProgrammaticSkin;

class LineSeriesLegendMarker extends ProgrammaticSkin
{
   
   private var _element:LineSeries;
   
   public function LineSeriesLegendMarker(element:LineSeries)
   {
      super();
      _element = element;
      styleName = _element;
   }
   
   override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
   {
      var color:Number = NaN;
      var gb:LinearGradientStroke = null;
      super.updateDisplayList(unscaledWidth,unscaledHeight);
      var fillStroke:IStroke = getStyle("lineStroke");
      if(fillStroke is Stroke)
      {
         color = Number(Stroke(fillStroke).color);
      }
      else if(fillStroke is LinearGradientStroke)
      {
         gb = LinearGradientStroke(fillStroke);
         if(gb.entries.length > 0)
         {
            color = Number(gb.entries[0].color);
         }
      }
      var g:Graphics = graphics;
      g.clear();
      g.moveTo(0,0);
      g.lineStyle(0,0,0);
      g.beginFill(color);
      g.lineTo(width,0);
      g.lineTo(width,height);
      g.lineTo(0,height);
      g.lineTo(0,0);
      g.endFill();
   }
}
