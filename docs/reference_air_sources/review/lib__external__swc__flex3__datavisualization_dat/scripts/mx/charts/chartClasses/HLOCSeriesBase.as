package mx.charts.chartClasses
{
   import flash.display.Graphics;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.charts.HitData;
   import mx.charts.series.CandlestickSeries;
   import mx.charts.series.items.HLOCSeriesItem;
   import mx.charts.series.renderData.HLOCSeriesRenderData;
   import mx.collections.CursorBookmark;
   import mx.core.IDataRenderer;
   import mx.core.IFactory;
   import mx.core.IFlexDisplayObject;
   import mx.styles.ISimpleStyleClient;
   
   [ResourceBundle("charts")]
   [Style(name="legendMarkerRenderer",type="mx.core.IFactory",inherit="no")]
   [Style(name="itemRenderer",type="mx.core.IFactory",inherit="no")]
   public class HLOCSeriesBase extends Series implements IColumn
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _closeField:String = "";
      
      private var _horizontalAxis:IAxis;
      
      private var _bAxesDirty:Boolean = false;
      
      private var _xField:String = "";
      
      private var _verticalAxis:IAxis;
      
      private var _maxColumnWidth:Number;
      
      private var _offset:Number = 0;
      
      private var _columnWidthRatio:Number = 0.65;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _openField:String = "";
      
      private var _lowField:String = "";
      
      private var _instanceCache:InstanceCache;
      
      private var _highField:String = "";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _renderData:HLOCSeriesRenderData;
      
      public function HLOCSeriesBase()
      {
         super();
         _instanceCache = new InstanceCache(null,this);
         _instanceCache.properties = {"styleName":this};
         dataTransform = new CartesianTransform();
      }
      
      [Inspectable(category="General")]
      public function get lowField() : String
      {
         return _lowField;
      }
      
      public function set lowField(value:String) : void
      {
         _lowField = value;
         dataChanged();
      }
      
      [Inspectable(category="General")]
      public function get maxColumnWidth() : Number
      {
         return _maxColumnWidth;
      }
      
      override public function describeData(dimension:String, requiredFields:uint) : Array
      {
         var sortedCache:Array = null;
         validateData();
         if(_renderData.cache.length == 0)
         {
            return [];
         }
         var description:DataDescription = new DataDescription();
         description.boundedValues = null;
         if(dimension == CartesianTransform.VERTICAL_AXIS)
         {
            extractMinMax(_renderData.cache,"highNumber",description);
            extractMinMax(_renderData.cache,"lowNumber",description);
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
                  sortedCache = _renderData.cache.concat();
                  sortedCache.sortOn("xNumber",Array.NUMERIC);
                  extractMinMax(sortedCache,"xNumber",description,(requiredFields & DataDescription.REQUIRED_MIN_INTERVAL) != 0);
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
            description.padding = 0.5;
         }
         return [description];
      }
      
      override public function localToData(v:Point) : Array
      {
         return dataTransform.invertTransform(v.x - this.x,v.y - this.y);
      }
      
      public function set maxColumnWidth(value:Number) : void
      {
         _maxColumnWidth = value;
         invalidateTransform();
      }
      
      [Inspectable(category="General",defaultValue="0")]
      public function get offset() : Number
      {
         return _offset;
      }
      
      override public function getElementBounds(renderData:Object) : void
      {
         var ro:Number = NaN;
         var lo:Number = NaN;
         var v:HLOCSeriesItem = null;
         var maxBounds:Rectangle = null;
         var i:int = 0;
         var top:Number = NaN;
         var b:Rectangle = null;
         var cache:Array = renderData.filteredCache;
         var rb:Array = [];
         var sampleCount:int = int(cache.length);
         if(Boolean(sampleCount))
         {
            ro = renderData.renderedHalfWidth + renderData.renderedXOffset;
            lo = -renderData.renderedHalfWidth + renderData.renderedXOffset;
            v = cache[0];
            maxBounds = new Rectangle(v.x,v.low,0,0);
            for(i = 0; i < sampleCount; i++)
            {
               v = cache[i];
               top = Math.min(v.high,v.low);
               b = new Rectangle(v.x + lo,top,ro - lo,Math.max(v.high,v.low) - top);
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
      
      override protected function getMissingInterpolationValues(sourceProps:Object, srcCache:Array, destProps:Object, destCache:Array, index:Number, customData:Object) : void
      {
         var propName:String = null;
         var src:Number = NaN;
         var dst:Number = NaN;
         for(propName in sourceProps)
         {
            src = Number(sourceProps[propName]);
            dst = Number(destProps[propName]);
            if(propName == "high" || propName == "low" || propName == "open" || propName == "close")
            {
               if(isNaN(src))
               {
                  src = Number(unscaledHeight);
               }
               if(isNaN(dst))
               {
                  dst = Number(unscaledHeight);
               }
            }
            else if(propName == "x")
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
      
      public function set openField(value:String) : void
      {
         _openField = value;
         dataChanged();
      }
      
      override protected function updateFilter() : void
      {
         var yAxis:IAxis = null;
         if(filterData)
         {
            _renderData.filteredCache = _renderData.cache.concat();
            dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).filterCache(_renderData.filteredCache,"xNumber","xFilter");
            yAxis = dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS);
            yAxis.filterCache(_renderData.filteredCache,"lowNumber","lowFilter");
            yAxis.filterCache(_renderData.filteredCache,"highNumber","highFilter");
            if(_openField != "")
            {
               yAxis.filterCache(_renderData.filteredCache,"openNumber","openFilter");
            }
            yAxis.filterCache(_renderData.filteredCache,"closeNumber","closeFilter");
            stripNaNs(_renderData.filteredCache,"xFilter");
            stripNaNs(_renderData.filteredCache,"lowFilter");
            stripNaNs(_renderData.filteredCache,"highFilter");
            if(_openField != "")
            {
               stripNaNs(_renderData.filteredCache,"openFilter");
            }
            stripNaNs(_renderData.filteredCache,"closeFilter");
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
         dataTransform.transformCache(_renderData.filteredCache,"xNumber","x","highNumber","high");
         dataTransform.transformCache(_renderData.filteredCache,null,null,"highNumber","high");
         dataTransform.transformCache(_renderData.filteredCache,null,null,"lowNumber","low");
         if(_openField != "")
         {
            dataTransform.transformCache(_renderData.filteredCache,null,null,"openNumber","open");
         }
         dataTransform.transformCache(_renderData.filteredCache,null,null,"closeNumber","close");
         var unitSize:Number = dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).unitSize;
         var params:Array = [{"xNumber":0},{"xNumber":_columnWidthRatio * unitSize / 2},{"xNumber":_offset * unitSize}];
         dataTransform.transformCache(params,"xNumber","x",null,null);
         _renderData.renderedHalfWidth = params[1].x - params[0].x;
         if(_offset == 0)
         {
            _renderData.renderedXOffset = 0;
         }
         else
         {
            _renderData.renderedXOffset = params[2].x - params[0].x;
         }
         if(!isNaN(_maxColumnWidth) && _maxColumnWidth < _renderData.renderedHalfWidth)
         {
            _renderData.renderedXOffset *= _maxColumnWidth / _renderData.renderedHalfWidth;
            _renderData.renderedHalfWidth = _maxColumnWidth;
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
      
      public function set offset(value:Number) : void
      {
         _offset = value;
         invalidateTransform();
      }
      
      protected function formatDataTip(hd:HitData) : String
      {
         var openString:String = resourceManager.getString("charts","open");
         var closeString:String = resourceManager.getString("charts","close");
         var highString:String = resourceManager.getString("charts","high");
         var lowString:String = resourceManager.getString("charts","low");
         var dt:String = "";
         var n:String = displayName;
         if(n != null && n.length > 0)
         {
            dt += "<B>" + n + "</B><BR/>";
         }
         var xName:String = dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).displayName;
         if(xName != "")
         {
            dt += "<I>" + xName + ":</I> ";
         }
         dt += dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).formatForScreen(HLOCSeriesItem(hd.chartItem).xValue) + "\n";
         var yName:String = dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).displayName;
         if(_openField != "")
         {
            if(yName != "")
            {
               dt += "<I>" + yName + " (" + openString + "):</I> ";
            }
            else
            {
               dt += "<I>" + openString + ":</I> ";
            }
            dt += dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).formatForScreen(HLOCSeriesItem(hd.chartItem).openValue) + "\n";
         }
         if(yName != "")
         {
            dt += "<I>" + yName + " (" + closeString + "):</I> ";
         }
         else
         {
            dt += "<I>" + closeString + ":</I> ";
         }
         dt += dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).formatForScreen(HLOCSeriesItem(hd.chartItem).closeValue) + "\n";
         if(yName != "")
         {
            dt += "<I>" + yName + " (" + highString + "):</I> ";
         }
         else
         {
            dt += "<I>" + highString + ":</I> ";
         }
         dt += dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).formatForScreen(HLOCSeriesItem(hd.chartItem).highValue) + "\n";
         if(yName != "")
         {
            dt += "<I>" + yName + " (" + lowString + "):</I> ";
         }
         else
         {
            dt += "<I>" + lowString + ":</I> ";
         }
         return dt + (dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).formatForScreen(HLOCSeriesItem(hd.chartItem).lowValue) + "\n");
      }
      
      override public function getItemsInRegion(r:Rectangle) : Array
      {
         var v:HLOCSeriesItem = null;
         var ro:Number = NaN;
         var lo:Number = NaN;
         var rcTemp:Rectangle = null;
         if(interactive == false || !_renderData)
         {
            return [];
         }
         var arrItems:Array = [];
         var rc:Rectangle = new Rectangle();
         var localRectangle:Rectangle = new Rectangle();
         var len:uint = _renderData.filteredCache.length;
         var considerOpen:Boolean = _openField != "";
         localRectangle.topLeft = globalToLocal(r.topLeft);
         localRectangle.bottomRight = globalToLocal(r.bottomRight);
         for(var i:int = 0; i < len; i++)
         {
            v = _renderData.filteredCache[i];
            ro = renderData.renderedHalfWidth + renderData.renderedXOffset;
            lo = -renderData.renderedHalfWidth + renderData.renderedXOffset;
            rc.left = v.x + lo;
            rc.right = v.x + ro;
            rc.top = Math.min(v.high,Math.min(v.low,v.close));
            if(considerOpen)
            {
               rc.top = Math.min(rc.top,v.open);
            }
            rc.bottom = Math.max(v.high,Math.max(v.low,v.close));
            if(considerOpen)
            {
               rc.bottom = Math.max(rc.bottom,v.close);
            }
            if(rc.right < rc.left || rc.bottom < rc.top)
            {
               rcTemp = new Rectangle(rc.x,rc.y,rc.width,rc.height);
               if(rc.right < rc.left)
               {
                  rcTemp.left = rc.right;
                  rcTemp.right = rc.left;
               }
               if(rc.bottom < rc.top)
               {
                  rcTemp.top = rc.bottom;
                  rcTemp.bottom = rc.top;
               }
               rc = rcTemp;
            }
            if(rc.intersects(localRectangle))
            {
               arrItems.push(v);
            }
         }
         return arrItems;
      }
      
      override protected function updateData() : void
      {
         var renderDataType:Class = this.renderDataType;
         _renderData = new renderDataType();
         _renderData.cache = [];
         var i:int = 0;
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
         cacheDefaultValues(_highField,_renderData.cache,"highValue");
         cacheNamedValues(_lowField,_renderData.cache,"lowValue");
         if(_openField != "")
         {
            cacheNamedValues(_openField,_renderData.cache,"openValue");
         }
         cacheNamedValues(_closeField,_renderData.cache,"closeValue");
         super.updateData();
      }
      
      public function set columnWidthRatio(value:Number) : void
      {
         _columnWidthRatio = value;
         invalidateTransform();
      }
      
      [Inspectable(category="Data")]
      public function get verticalAxis() : IAxis
      {
         return _verticalAxis;
      }
      
      protected function get renderDataType() : Class
      {
         return HLOCSeriesRenderData;
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
      
      public function set closeField(value:String) : void
      {
         _closeField = value;
         dataChanged();
      }
      
      override protected function updateMapping() : void
      {
         dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).mapCache(_renderData.cache,"xValue","xNumber",_xField == "");
         var yAxis:IAxis = dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS);
         yAxis.mapCache(_renderData.cache,"lowValue","lowNumber");
         yAxis.mapCache(_renderData.cache,"highValue","highNumber");
         if(_openField != "")
         {
            yAxis.mapCache(_renderData.cache,"openValue","openNumber");
         }
         yAxis.mapCache(_renderData.cache,"closeValue","closeNumber");
         super.updateMapping();
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
      
      [Inspectable(category="General")]
      public function get openField() : String
      {
         return _openField;
      }
      
      override public function get legendData() : Array
      {
         var marker:IFlexDisplayObject = null;
         var ld:LegendData = new LegendData();
         ld.element = this;
         var markerClass:IFactory = getStyle("legendMarkerRenderer");
         if(!markerClass)
         {
            markerClass = getStyle("itemRenderer");
         }
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
      
      [Inspectable(category="General",defaultValue="0.65")]
      public function get columnWidthRatio() : Number
      {
         return _columnWidthRatio;
      }
      
      override protected function get renderData() : Object
      {
         var renderDataType:Class = null;
         var rv:HLOCSeriesRenderData = null;
         if(!_renderData)
         {
            renderDataType = this.renderDataType;
            rv = new renderDataType();
            rv.cache = rv.filteredCache = [];
            rv.renderedHalfWidth = 0;
            rv.renderedXOffset = 0;
            return rv;
         }
         return _renderData;
      }
      
      [Inspectable(category="General")]
      public function get closeField() : String
      {
         return _closeField;
      }
      
      [Inspectable(category="Data")]
      public function get horizontalAxis() : IAxis
      {
         return _horizontalAxis;
      }
      
      [Inspectable(category="General")]
      public function get xField() : String
      {
         return _xField;
      }
      
      protected function get itemType() : Class
      {
         return HLOCSeriesItem;
      }
      
      public function set verticalAxis(value:IAxis) : void
      {
         _verticalAxis = value;
         _bAxesDirty = true;
         invalidateData();
         invalidateProperties();
      }
      
      public function set highField(value:String) : void
      {
         _highField = value;
         dataChanged();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var i:int = 0;
         var rc:Rectangle = null;
         var instances:Array = null;
         var inst:IFlexDisplayObject = null;
         var v:HLOCSeriesItem = null;
         var elementBounds:Array = null;
         var ro:Number = NaN;
         var lo:Number = NaN;
         var considerOpen:Boolean = false;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(!dataTransform)
         {
            return;
         }
         var g:Graphics = graphics;
         g.clear();
         if(!isNaN(_maxColumnWidth) && (_maxColumnWidth <= 0 || _columnWidthRatio <= 0))
         {
            return;
         }
         var renderData:HLOCSeriesRenderData = transitionRenderData == null ? _renderData : HLOCSeriesRenderData(transitionRenderData);
         var renderCache:Array = renderData.filteredCache;
         var sampleCount:int = int(renderCache.length);
         _instanceCache.factory = getStyle("itemRenderer");
         _instanceCache.count = sampleCount;
         instances = _instanceCache.instances;
         var bSetData:Boolean = sampleCount > 0 && instances[0] is IDataRenderer;
         if(Boolean(transitionRenderData) && Boolean(transitionRenderData.elementBounds))
         {
            elementBounds = transitionRenderData.elementBounds;
            for(i = 0; i < sampleCount; i++)
            {
               inst = instances[i];
               v = renderCache[i];
               v.itemRenderer = inst;
               if(this is CandlestickSeries)
               {
                  v.fill = CandlestickSeries(this).fillFunction(v,i);
                  if(!v.fill)
                  {
                     v.fill = CandlestickSeries(this).defaultFillFunction(v,i);
                  }
                  if((v.itemRenderer as Object).hasOwnProperty("invalidateDisplayList"))
                  {
                     (v.itemRenderer as Object).invalidateDisplayList();
                  }
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
            ro = renderData.renderedHalfWidth + renderData.renderedXOffset;
            lo = -renderData.renderedHalfWidth + renderData.renderedXOffset;
            rc = new Rectangle();
            considerOpen = _openField != "";
            for(i = 0; i < sampleCount; i++)
            {
               v = renderCache[i];
               rc.left = v.x + lo;
               rc.right = v.x + ro;
               rc.top = Math.min(v.high,Math.min(v.low,v.close));
               if(considerOpen)
               {
                  rc.top = Math.min(rc.top,v.open);
               }
               rc.bottom = Math.max(v.high,Math.max(v.low,v.close));
               if(considerOpen)
               {
                  rc.bottom = Math.max(rc.bottom,v.close);
               }
               inst = instances[i];
               v.itemRenderer = inst;
               if(this is CandlestickSeries)
               {
                  v.fill = CandlestickSeries(this).fillFunction(v,i);
                  if(!v.fill)
                  {
                     v.fill = CandlestickSeries(this).defaultFillFunction(v,i);
                  }
                  if((v.itemRenderer as Object).hasOwnProperty("invalidateDisplayList"))
                  {
                     (v.itemRenderer as Object).invalidateDisplayList();
                  }
               }
               if(bSetData)
               {
                  (inst as IDataRenderer).data = v;
               }
               inst.move(rc.left,rc.top);
               inst.setActualSize(rc.width,rc.height);
            }
            if(Boolean(chart) && Boolean(allSeriesTransform) && chart.chartState == 0)
            {
               chart.updateAllDataTips();
            }
         }
      }
      
      [Inspectable(category="General")]
      public function get highField() : String
      {
         return _highField;
      }
      
      override public function beginInterpolation(sourceRenderData:Object, destRenderData:Object) : Object
      {
         var interpFields:Object = {
            "x":true,
            "high":true,
            "low":true,
            "close":true
         };
         if(_openField != "")
         {
            interpFields.open = true;
         }
         var idata:Object = initializeInterpolationData(sourceRenderData.cache,destRenderData.cache,interpFields,itemType,{
            "sourceRenderData":sourceRenderData,
            "destRenderData":destRenderData
         });
         var interpolationRenderData:HLOCSeriesRenderData = HLOCSeriesRenderData(destRenderData.clone());
         interpolationRenderData.cache = idata.cache;
         interpolationRenderData.filteredCache = idata.cache;
         transitionRenderData = interpolationRenderData;
         return idata;
      }
   }
}

