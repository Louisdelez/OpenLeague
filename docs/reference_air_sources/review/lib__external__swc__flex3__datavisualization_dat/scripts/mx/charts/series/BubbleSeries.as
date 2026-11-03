package mx.charts.series
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.charts.BubbleChart;
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
   import mx.charts.renderers.CircleItemRenderer;
   import mx.charts.series.items.BubbleSeriesItem;
   import mx.charts.series.renderData.BubbleSeriesRenderData;
   import mx.charts.styles.HaloDefaults;
   import mx.collections.CursorBookmark;
   import mx.core.ClassFactory;
   import mx.core.IDataRenderer;
   import mx.core.IFactory;
   import mx.core.IFlexDisplayObject;
   import mx.events.PropertyChangeEvent;
   import mx.graphics.IFill;
   import mx.graphics.SolidColor;
   import mx.graphics.Stroke;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.ISimpleStyleClient;
   
   [Style(name="fills",type="Array",arrayType="mx.graphics.IFill",inherit="no")]
   [Style(name="legendMarkerRenderer",type="mx.core.IFactory",inherit="no")]
   [Style(name="itemRenderer",type="mx.core.IFactory",inherit="no")]
   [Style(name="stroke",type="mx.graphics.IStroke",inherit="no")]
   [Style(name="fill",type="mx.graphics.IFill",inherit="no")]
   public class BubbleSeries extends Series
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      public static const RADIUS_AXIS:String = "bubbleRadius";
      
      private static var stylesInited:Boolean = initStyles();
      
      private var _xField:String = "";
      
      [Inspectable(category="General")]
      public var minRadius:Number = 0;
      
      private var _bAxesDirty:Boolean = false;
      
      private var _horizontalAxis:IAxis;
      
      [Inspectable(category="General")]
      public var maxRadius:Number = 50;
      
      private var _verticalAxis:IAxis;
      
      private var _yField:String = "";
      
      private var _localFills:Array;
      
      private var _radiusField:String = "";
      
      private var _fillCount:int;
      
      private var _instanceCache:InstanceCache;
      
      private var _radiusAxis:IAxis;
      
      private var _1757871014_fillFunction:Function = defaultFillFunction;
      
      private var _renderData:BubbleSeriesRenderData;
      
      public function BubbleSeries()
      {
         super();
         _instanceCache = new InstanceCache(null,this);
         _instanceCache.creationCallback = applyItemRendererProperties;
         dataTransform = new CartesianTransform();
      }
      
      private static function initStyles() : Boolean
      {
         var seriesStyle:CSSStyleDeclaration;
         HaloDefaults.init();
         seriesStyle = HaloDefaults.createSelector("BubbleSeries");
         seriesStyle.defaultFactory = function():void
         {
            this.fill = new SolidColor(4473924);
            this.fills = [];
            this.itemRenderer = new ClassFactory(CircleItemRenderer);
            this.stroke = new Stroke(0,1,0.2);
         };
         return true;
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
      
      override protected function updateData() : void
      {
         var renderDataType:Class = this.renderDataType;
         _renderData = new renderDataType();
         _renderData.cache = [];
         var i:uint = 0;
         var itemClass:Class = itemType;
         if(Boolean(cursor))
         {
            cursor.seek(CursorBookmark.FIRST);
            while(!cursor.afterLast)
            {
               _renderData.cache[i] = new itemClass(this,cursor.current,i);
               i++;
               cursor.moveNext();
            }
         }
         cacheIndexValues(_xField,_renderData.cache,"xValue");
         cacheDefaultValues(_yField,_renderData.cache,"yValue");
         cacheNamedValues(_radiusField,_renderData.cache,"zValue");
         super.updateData();
      }
      
      override public function describeData(dimension:String, requiredFields:uint) : Array
      {
         validateData();
         var desc:DataDescription = new DataDescription();
         var cache:Array = _renderData.cache;
         if(dimension == CartesianTransform.HORIZONTAL_AXIS)
         {
            if((requiredFields & DataDescription.REQUIRED_MIN_INTERVAL) != 0)
            {
               cache = cache.concat();
               cache.sortOn("xNumber",Array.NUMERIC);
            }
            extractMinMax(cache,"xNumber",desc,(requiredFields & DataDescription.REQUIRED_MIN_INTERVAL) != 0);
            if((requiredFields & DataDescription.REQUIRED_BOUNDED_VALUES) != 0)
            {
               desc.boundedValues = [];
               desc.boundedValues.push(new BoundedValue(desc.max,0,maxRadius));
               desc.boundedValues.push(new BoundedValue(desc.min,maxRadius,0));
            }
         }
         else if(dimension == CartesianTransform.VERTICAL_AXIS)
         {
            if((requiredFields & DataDescription.REQUIRED_MIN_INTERVAL) != 0)
            {
               cache = cache.concat();
               cache.sortOn("yNumber",Array.NUMERIC);
            }
            extractMinMax(cache,"yNumber",desc,(requiredFields & DataDescription.REQUIRED_MIN_INTERVAL) != 0);
            if((requiredFields & DataDescription.REQUIRED_BOUNDED_VALUES) != 0)
            {
               desc.boundedValues = [];
               desc.boundedValues.push(new BoundedValue(desc.max,0,maxRadius));
               desc.boundedValues.push(new BoundedValue(desc.min,maxRadius,0));
            }
         }
         else
         {
            if(dimension != BubbleSeries.RADIUS_AXIS)
            {
               return [];
            }
            extractMinMax(cache,"zNumber",desc);
         }
         return [desc];
      }
      
      [Inspectable(category="General")]
      public function get radiusField() : String
      {
         return _radiusField;
      }
      
      override public function stylesInitialized() : void
      {
         _localFills = getStyle("fills");
         _fillCount = _localFills.length;
         super.stylesInitialized();
      }
      
      override public function getElementBounds(renderData:Object) : void
      {
         var maxBounds:Rectangle = null;
         var offset:Number = NaN;
         var v:Object = null;
         var rad:Number = NaN;
         var i:uint = 0;
         var b:Rectangle = null;
         var cache:Array = renderData.cache;
         var rb:Array = [];
         var sampleCount:uint = cache.length;
         if(sampleCount == 0)
         {
            maxBounds = new Rectangle(0,0,unscaledWidth,unscaledHeight);
         }
         else
         {
            offset = maxRadius - minRadius;
            v = cache[0];
            maxBounds = new Rectangle(v.x,v.y,0,0);
            rad = minRadius + v.z * offset;
            for(i = 0; i < sampleCount; i++)
            {
               v = cache[i];
               rad = minRadius + v.z * offset;
               b = new Rectangle(v.x - rad,v.y - rad,2 * rad,2 * rad);
               maxBounds.left = Math.min(maxBounds.left,b.left);
               maxBounds.top = Math.min(maxBounds.top,b.top);
               maxBounds.right = Math.max(maxBounds.right,b.right);
               maxBounds.bottom = Math.max(maxBounds.bottom,b.bottom);
               rb[i] = b;
            }
         }
         renderData.elementBounds = rb;
         renderData.bounds = maxBounds;
      }
      
      public function set radiusField(value:String) : void
      {
         _radiusField = value;
         dataChanged();
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
            dataTransform.getAxis(BubbleSeries.RADIUS_AXIS).filterCache(_renderData.filteredCache,"zNumber","zFilter");
            stripNaNs(_renderData.filteredCache,"zFilter");
         }
         else
         {
            _renderData.filteredCache = _renderData.cache;
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
         dataTransform.getAxis(BubbleSeries.RADIUS_AXIS).transformCache(_renderData.filteredCache,"zNumber","z");
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
      
      override protected function getMissingInterpolationValues(sourceProps:Object, srcCache:Array, destProps:Object, destCache:Array, index:Number, customData:Object) : void
      {
         var propName:String = null;
         var src:Number = NaN;
         var dst:Number = NaN;
         for(propName in sourceProps)
         {
            src = Number(sourceProps[propName]);
            dst = Number(destProps[propName]);
            if(propName == "x" || propName == "y")
            {
               if(isNaN(src))
               {
                  src = dst;
               }
               if(isNaN(dst))
               {
                  dst = src;
               }
            }
            else if(propName == "z")
            {
               if(isNaN(src))
               {
                  src = 0;
               }
               if(isNaN(dst))
               {
                  dst = 0;
               }
            }
            sourceProps[propName] = src;
            destProps[propName] = dst;
         }
      }
      
      public function set radiusAxis(value:IAxis) : void
      {
         _radiusAxis = value;
         _bAxesDirty = true;
         invalidateData();
         invalidateProperties();
      }
      
      override public function localToData(v:Point) : Array
      {
         return dataTransform.invertTransform(v.x - this.x,v.y - this.y);
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
         dt += dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).formatForScreen(BubbleSeriesItem(hd.chartItem).xValue) + "\n";
         var yName:String = dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).displayName;
         if(yName != "")
         {
            dt += "<i>" + yName + ":</i> ";
         }
         dt += dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).formatForScreen(BubbleSeriesItem(hd.chartItem).yValue) + "\n";
         var radName:String = dataTransform.getAxis(BubbleSeries.RADIUS_AXIS).displayName;
         if(radName != "")
         {
            dt += "<i>" + radName + ":</i> ";
         }
         return dt + (dataTransform.getAxis(BubbleSeries.RADIUS_AXIS).formatForScreen(BubbleSeriesItem(hd.chartItem).zValue) + "\n");
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
      
      override public function beginInterpolation(sourceRenderData:Object, destRenderData:Object) : Object
      {
         var idata:Object = initializeInterpolationData(sourceRenderData.cache,destRenderData.cache,{
            "x":true,
            "y":true,
            "z":true
         },itemType);
         var interpolationRenderData:BubbleSeriesRenderData = BubbleSeriesRenderData(_renderData.clone());
         interpolationRenderData.cache = idata.cache;
         interpolationRenderData.filteredCache = idata.cache;
         transitionRenderData = interpolationRenderData;
         return idata;
      }
      
      [Inspectable(category="Data")]
      public function get verticalAxis() : IAxis
      {
         return _verticalAxis;
      }
      
      [Inspectable(environment="none")]
      protected function get renderDataType() : Class
      {
         return BubbleSeriesRenderData;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         var styles:String = "stroke fill";
         if(styleProp == null || styleProp == "" || styles.indexOf(styleProp) != -1)
         {
            invalidateDisplayList();
            legendDataChanged();
         }
         styles = "fills";
         if(styles.indexOf(styleProp) != -1)
         {
            _localFills = getStyle("fills");
            _fillCount = _localFills.length;
            invalidateDisplayList();
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
      }
      
      override protected function updateMapping() : void
      {
         dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).mapCache(_renderData.cache,"xValue","xNumber",_xField == "");
         dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).mapCache(_renderData.cache,"yValue","yNumber");
         dataTransform.getAxis(BubbleSeries.RADIUS_AXIS).mapCache(_renderData.cache,"zValue","zNumber");
         _renderData.cache.sortOn("zNumber",Array.NUMERIC | Array.DESCENDING);
         super.updateMapping();
      }
      
      override public function findDataPoints(x:Number, y:Number, sensitivity:Number) : Array
      {
         var n:int = 0;
         var i:int = 0;
         var v:BubbleSeriesItem = null;
         var dist:Number = NaN;
         var r2:Number = NaN;
         var item:BubbleSeriesItem = null;
         var hd:HitData = null;
         var fill:IFill = null;
         if(interactive == false || !_renderData)
         {
            return [];
         }
         var minDist2:Number = maxRadius + sensitivity;
         minDist2 *= minDist2;
         var minItems:Array = [];
         n = int(_renderData.filteredCache.length);
         var offset:Number = maxRadius - minRadius;
         for(i = n - 1; i >= 0; i--)
         {
            v = _renderData.filteredCache[i];
            dist = (v.x - x) * (v.x - x) + (v.y - y) * (v.y - y);
            r2 = minRadius + v.z * offset + sensitivity;
            r2 *= r2;
            if(dist <= r2)
            {
               if(dist <= minDist2)
               {
                  minItems.push(v);
               }
            }
         }
         n = int(minItems.length);
         for(i = 0; i < n; i++)
         {
            item = minItems[i];
            hd = new HitData(createDataID(item.index),Math.sqrt(minDist2),item.x,item.y,item);
            hd.dataTipFunction = formatDataTip;
            fill = BubbleSeriesItem(hd.chartItem).fill;
            hd.contextColor = GraphicsUtilities.colorFromFill(fill);
            minItems[i] = hd;
         }
         return minItems;
      }
      
      override public function get items() : Array
      {
         return Boolean(_renderData) ? _renderData.filteredCache : null;
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
            if(Boolean(_radiusAxis))
            {
               _radiusAxis.chartDataProvider = dataProvider;
               CartesianTransform(dataTransform).setAxis(RADIUS_AXIS,radiusAxis);
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
            if(!_radiusAxis)
            {
               if(c is BubbleChart)
               {
                  if(c.secondSeries.indexOf(this) != -1 && Boolean((c as BubbleChart).secondRadiusAxis))
                  {
                     if(dataTransform.axes[RADIUS_AXIS] != (c as BubbleChart).secondRadiusAxis)
                     {
                        dataTransform.setAxis(RADIUS_AXIS,(c as BubbleChart).secondRadiusAxis);
                     }
                  }
                  else if(dataTransform.axes[RADIUS_AXIS] != (c as BubbleChart).radiusAxis)
                  {
                     dataTransform.setAxis(RADIUS_AXIS,(c as BubbleChart).radiusAxis);
                  }
               }
            }
         }
         dataTransform.elements = [this];
      }
      
      public function set xField(value:String) : void
      {
         _xField = value;
         dataChanged();
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
      
      override public function getItemsInRegion(r:Rectangle) : Array
      {
         var v:BubbleSeriesItem = null;
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
      
      public function set horizontalAxis(value:IAxis) : void
      {
         _horizontalAxis = value;
         _bAxesDirty = true;
         invalidateData();
         invalidateProperties();
      }
      
      [Inspectable(category="Data")]
      public function get radiusAxis() : IAxis
      {
         return _radiusAxis;
      }
      
      protected function applyItemRendererProperties(instance:DisplayObject, cache:InstanceCache) : void
      {
         if(instance is ISimpleStyleClient)
         {
            ISimpleStyleClient(instance).styleName = this;
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _fillFunction() : Function
      {
         return this._1757871014_fillFunction;
      }
      
      override public function get legendData() : Array
      {
         var marker:IFlexDisplayObject = null;
         var keyItems:Array = null;
         if(fillFunction != defaultFillFunction || _fillCount != 0)
         {
            return [];
         }
         var ld:LegendData = new LegendData();
         ld.element = this;
         var markerFactory:IFactory = getStyle("legendMarkerRenderer");
         if(!markerFactory)
         {
            markerFactory = getStyle("itemRenderer");
         }
         if(Boolean(markerFactory))
         {
            marker = markerFactory.newInstance();
            if(Boolean(marker as ISimpleStyleClient))
            {
               (marker as ISimpleStyleClient).styleName = this;
            }
         }
         ld.marker = marker;
         ld.label = displayName;
         ld.aspectRatio = 1;
         return [ld];
      }
      
      override protected function get renderData() : Object
      {
         var renderDataType:Class = null;
         if(!_renderData)
         {
            renderDataType = this.renderDataType;
            return new renderDataType([],[]);
         }
         return _renderData;
      }
      
      [Inspectable(category="General")]
      public function get xField() : String
      {
         return _xField;
      }
      
      private function defaultFillFunction(element:BubbleSeriesItem, i:Number) : IFill
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
         return BubbleSeriesItem;
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
         var i:uint = 0;
         var instances:Array = null;
         var inst:IFlexDisplayObject = null;
         var rc:Rectangle = null;
         var v:BubbleSeriesItem = null;
         var elementBounds:Array = null;
         var offset:Number = NaN;
         var rad:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var g:Graphics = graphics;
         g.clear();
         var renderData:BubbleSeriesRenderData = Boolean(transitionRenderData) ? BubbleSeriesRenderData(transitionRenderData) : _renderData;
         if(!renderData)
         {
            return;
         }
         var renderCache:Array = renderData.filteredCache;
         var sampleCount:uint = renderCache.length;
         _instanceCache.factory = getStyle("itemRenderer");
         _instanceCache.count = sampleCount;
         instances = _instanceCache.instances;
         var bSetData:Boolean = sampleCount > 0 && instances[0] is IDataRenderer;
         if(renderData == transitionRenderData && Boolean(transitionRenderData.elementBounds))
         {
            elementBounds = renderData.elementBounds;
            for(i = 0; i < sampleCount; i++)
            {
               inst = instances[i];
               v = renderCache[i];
               v.itemRenderer = inst;
               v.fill = fillFunction(v,i);
               if(!v.fill)
               {
                  v.fill = defaultFillFunction(v,i);
               }
               if((v.itemRenderer as Object).hasOwnProperty("invalidateDisplayList"))
               {
                  (v.itemRenderer as Object).invalidateDisplayList();
               }
               if(bSetData)
               {
                  (inst as IDataRenderer).data = v;
               }
               rc = elementBounds[i];
               inst.move(rc.left,rc.top);
               inst.setActualSize(rc.width,rc.height);
            }
         }
         else
         {
            offset = maxRadius - minRadius;
            for(i = 0; i < sampleCount; i++)
            {
               v = renderCache[i];
               rad = minRadius + v.z * offset;
               if(!isNaN(rad))
               {
                  inst = instances[i];
                  v.fill = fillFunction(v,i);
                  if(!v.fill)
                  {
                     v.fill = defaultFillFunction(v,i);
                  }
                  v.itemRenderer = inst;
                  if((v.itemRenderer as Object).hasOwnProperty("invalidateDisplayList"))
                  {
                     (v.itemRenderer as Object).invalidateDisplayList();
                  }
                  if(bSetData)
                  {
                     (inst as IDataRenderer).data = v;
                  }
                  inst.move(v.x - rad,v.y - rad);
                  inst.setActualSize(2 * rad,2 * rad);
               }
            }
            if(Boolean(chart) && Boolean(allSeriesTransform) && chart.chartState == 0)
            {
               chart.updateAllDataTips();
            }
         }
      }
      
      override public function getAllDataPoints() : Array
      {
         var i:uint = 0;
         var v:BubbleSeriesItem = null;
         var itemExists:Boolean = false;
         var j:int = 0;
         var hd:HitData = null;
         var fill:IFill = null;
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
         var right:Number = Number(unscaledWidth);
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
               hd.dataTipFunction = formatDataTip;
               fill = BubbleSeriesItem(hd.chartItem).fill;
               hd.contextColor = GraphicsUtilities.colorFromFill(fill);
               result.push(hd);
            }
         }
         return result;
      }
      
      public function get fillFunction() : Function
      {
         return _fillFunction;
      }
   }
}

