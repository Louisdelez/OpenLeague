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
   import mx.charts.renderers.DiamondItemRenderer;
   import mx.charts.series.items.PlotSeriesItem;
   import mx.charts.series.renderData.PlotSeriesRenderData;
   import mx.charts.styles.HaloDefaults;
   import mx.collections.CursorBookmark;
   import mx.core.ClassFactory;
   import mx.core.IDataRenderer;
   import mx.core.IFactory;
   import mx.core.IFlexDisplayObject;
   import mx.events.PropertyChangeEvent;
   import mx.graphics.IFill;
   import mx.graphics.SolidColor;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.ISimpleStyleClient;
   
   [Style(name="radius",type="Number",format="Length",inherit="no")]
   [Style(name="fills",type="Array",arrayType="mx.graphics.IFill",inherit="no")]
   [Style(name="adjustedRadius",type="Number",format="Length",inherit="yes")]
   [Style(name="legendMarkerRenderer",type="mx.core.IFactory",inherit="no")]
   [Style(name="itemRenderer",type="mx.core.IFactory",inherit="no")]
   [Style(name="stroke",type="mx.graphics.IStroke",inherit="no")]
   [Style(name="fill",type="mx.graphics.IFill",inherit="no")]
   public class PlotSeries extends Series
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static var stylesInited:Boolean = initStyles();
      
      private var _xField:String = "";
      
      private var _horizontalAxis:IAxis;
      
      private var _renderData:PlotSeriesRenderData;
      
      private var _bAxesDirty:Boolean = false;
      
      private var _verticalAxis:IAxis;
      
      private var _yField:String = "";
      
      private var _localFills:Array;
      
      private var _fillCount:Number;
      
      private var _instanceCache:InstanceCache;
      
      private var _1757871014_fillFunction:Function = defaultFillFunction;
      
      public function PlotSeries()
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
         seriesStyle = HaloDefaults.createSelector("PlotSeries");
         seriesStyle.defaultFactory = function():void
         {
            this.fill = new SolidColor(4474026);
            this.fills = [];
            this.itemRenderer = new ClassFactory(DiamondItemRenderer);
            this.radius = 5;
            this.adjustedRadius = 2;
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
      
      [Deprecated(replacement="radius style")]
      [Inspectable(category="Styles")]
      public function get radius() : Number
      {
         return getStyle("radius");
      }
      
      override protected function updateData() : void
      {
         var renderDataType:Class = this.renderDataType;
         _renderData = new renderDataType();
         _renderData.cache = [];
         var i:int = 0;
         var itemType:Class = this.itemType;
         if(Boolean(cursor))
         {
            cursor.seek(CursorBookmark.FIRST);
            while(!cursor.afterLast)
            {
               _renderData.cache[i] = new itemType(this,cursor.current,i);
               i++;
               cursor.moveNext();
            }
         }
         cacheIndexValues(_xField,_renderData.cache,"xValue");
         cacheDefaultValues(_yField,_renderData.cache,"yValue");
         super.updateData();
         var radius:Number = Number(getStyle("radius"));
         var n:int = int(_renderData.cache.length);
         for(i = 0; i < n; i++)
         {
            _renderData.cache[i].radius = radius;
         }
      }
      
      override public function localToData(v:Point) : Array
      {
         return dataTransform.invertTransform(v.x - this.x,v.y - this.y);
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
         var v:Object = null;
         var maxBounds:Rectangle = null;
         var i:int = 0;
         var b:Rectangle = null;
         var cache:Array = renderData.cache;
         var rb:Array = [];
         var sampleCount:int = int(cache.length);
         if(Boolean(sampleCount))
         {
            radius = Number(renderData.radius);
            v = cache[0];
            maxBounds = new Rectangle(v.x,v.x,0,0);
            for(i = 0; i < sampleCount; i++)
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
         else
         {
            maxBounds = new Rectangle();
         }
         renderData.elementBounds = rb;
         renderData.bounds = maxBounds;
      }
      
      override public function describeData(dimension:String, requiredFields:uint) : Array
      {
         validateData();
         var desc:DataDescription = new DataDescription();
         var cache:Array = _renderData.cache;
         var radius:Number = Number(getStyle("radius"));
         if(dimension == CartesianTransform.VERTICAL_AXIS)
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
               desc.boundedValues.push(new BoundedValue(desc.max,0,radius));
               desc.boundedValues.push(new BoundedValue(desc.min,radius,0));
            }
         }
         else
         {
            if(dimension != CartesianTransform.HORIZONTAL_AXIS)
            {
               return [];
            }
            if((requiredFields & DataDescription.REQUIRED_MIN_INTERVAL) != 0)
            {
               cache = cache.concat();
               cache.sortOn("xNumber",Array.NUMERIC);
            }
            extractMinMax(cache,"xNumber",desc,(requiredFields & DataDescription.REQUIRED_MIN_INTERVAL) != 0);
            if((requiredFields & DataDescription.REQUIRED_BOUNDED_VALUES) != 0)
            {
               desc.boundedValues = [];
               desc.boundedValues.push(new BoundedValue(desc.max,0,radius));
               desc.boundedValues.push(new BoundedValue(desc.min,radius,0));
            }
         }
         return [desc];
      }
      
      override public function beginInterpolation(sourceRenderData:Object, destRenderData:Object) : Object
      {
         var idata:Object = initializeInterpolationData(sourceRenderData.cache,destRenderData.cache,{
            "x":true,
            "y":true
         },itemType);
         var interpolationRenderData:PlotSeriesRenderData = PlotSeriesRenderData(destRenderData.clone());
         interpolationRenderData.cache = idata.cache;
         interpolationRenderData.filteredCache = idata.cache;
         transitionRenderData = interpolationRenderData;
         return idata;
      }
      
      override protected function updateFilter() : void
      {
         if(filterData)
         {
            _renderData.filteredCache = _renderData.cache.concat();
            dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).filterCache(_renderData.filteredCache,"xNumber","xFilter");
            dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).filterCache(_renderData.filteredCache,"yNumber","yFilter");
            stripNaNs(_renderData.filteredCache,"yFilter");
            stripNaNs(_renderData.filteredCache,"xFilter");
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
         dt += dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).formatForScreen(PlotSeriesItem(hd.chartItem).xValue) + "\n";
         var yName:String = dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).displayName;
         if(yName != "")
         {
            dt += "<i>" + yName + ":</i> ";
         }
         return dt + (dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).formatForScreen(PlotSeriesItem(hd.chartItem).yValue) + "\n");
      }
      
      override public function getItemsInRegion(r:Rectangle) : Array
      {
         var v:PlotSeriesItem = null;
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
         return PlotSeriesRenderData;
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
            _instanceCache.remove = true;
            _instanceCache.discard = true;
            _instanceCache.count = 0;
            _instanceCache.discard = false;
            _instanceCache.remove = false;
         }
         invalidateDisplayList();
         legendDataChanged();
         invalidateData();
      }
      
      override protected function updateMapping() : void
      {
         dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).mapCache(_renderData.cache,"xValue","xNumber",_xField == "");
         dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).mapCache(_renderData.cache,"yValue","yNumber");
         super.updateMapping();
      }
      
      override public function findDataPoints(x:Number, y:Number, sensitivity:Number) : Array
      {
         var i:int = 0;
         var v:Object = null;
         var dist:Number = NaN;
         var item:PlotSeriesItem = null;
         var hd:HitData = null;
         var fill:IFill = null;
         if(interactive == false || !_renderData)
         {
            return [];
         }
         var radius:Number = Number(getStyle("radius"));
         var minDist2:Number = radius + sensitivity;
         minDist2 *= minDist2;
         var minItems:Array = [];
         var pr2:Number = radius * radius;
         var n:int = int(_renderData.filteredCache.length);
         for(i = n - 1; i >= 0; i--)
         {
            v = _renderData.filteredCache[i];
            dist = (v.x - x) * (v.x - x) + (v.y - y) * (v.y - y);
            if(dist <= minDist2)
            {
               minItems.push(v);
            }
         }
         for(i = 0; i < minItems.length; i++)
         {
            item = minItems[i];
            hd = new HitData(createDataID(item.index),Math.sqrt(minDist2),item.x,item.y,item);
            hd.dataTipFunction = formatDataTip;
            fill = PlotSeriesItem(hd.chartItem).fill;
            hd.contextColor = GraphicsUtilities.colorFromFill(fill);
            minItems[i] = hd;
         }
         return minItems;
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
         ld.aspectRatio = 1;
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
      
      override protected function get renderData() : Object
      {
         var renderDataType:Class = null;
         if(!_renderData)
         {
            renderDataType = this.renderDataType;
            return new renderDataType([],[],0);
         }
         _renderData.radius = getStyle("radius");
         return _renderData;
      }
      
      [Inspectable(category="General")]
      public function get xField() : String
      {
         return _xField;
      }
      
      private function defaultFillFunction(element:PlotSeriesItem, i:Number) : IFill
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
         return PlotSeriesItem;
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
         var instances:Array = null;
         var inst:IFlexDisplayObject = null;
         var rc:Rectangle = null;
         var v:PlotSeriesItem = null;
         var elementBounds:Array = null;
         var radius:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var g:Graphics = graphics;
         g.clear();
         var renderData:PlotSeriesRenderData = Boolean(transitionRenderData) ? PlotSeriesRenderData(transitionRenderData) : _renderData;
         if(!renderData)
         {
            return;
         }
         var renderCache:Array = renderData.filteredCache;
         var sampleCount:int = int(renderCache.length);
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
            radius = Number(getStyle("radius"));
            for(i = 0; i < sampleCount; i++)
            {
               v = renderCache[i];
               inst = instances[i];
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
               inst.move(v.x - radius,v.y - radius);
               inst.setActualSize(2 * radius,2 * radius);
            }
            if(Boolean(chart) && Boolean(allSeriesTransform) && chart.chartState == 0)
            {
               chart.updateAllDataTips();
            }
         }
      }
      
      public function get fillFunction() : Function
      {
         return _fillFunction;
      }
      
      override public function getAllDataPoints() : Array
      {
         var i:uint = 0;
         var v:PlotSeriesItem = null;
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
               fill = PlotSeriesItem(hd.chartItem).fill;
               hd.contextColor = GraphicsUtilities.colorFromFill(fill);
               result.push(hd);
            }
         }
         return result;
      }
   }
}

