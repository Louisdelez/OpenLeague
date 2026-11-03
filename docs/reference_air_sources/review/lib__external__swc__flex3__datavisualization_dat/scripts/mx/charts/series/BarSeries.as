package mx.charts.series
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import mx.charts.BarChart;
   import mx.charts.HitData;
   import mx.charts.chartClasses.CartesianChart;
   import mx.charts.chartClasses.CartesianTransform;
   import mx.charts.chartClasses.DataDescription;
   import mx.charts.chartClasses.GraphicsUtilities;
   import mx.charts.chartClasses.IAxis;
   import mx.charts.chartClasses.IBar;
   import mx.charts.chartClasses.IStackable;
   import mx.charts.chartClasses.IStackable2;
   import mx.charts.chartClasses.InstanceCache;
   import mx.charts.chartClasses.LegendData;
   import mx.charts.chartClasses.Series;
   import mx.charts.chartClasses.StackedSeries;
   import mx.charts.renderers.BoxItemRenderer;
   import mx.charts.series.items.BarSeriesItem;
   import mx.charts.series.renderData.BarSeriesRenderData;
   import mx.charts.styles.HaloDefaults;
   import mx.collections.CursorBookmark;
   import mx.controls.Label;
   import mx.core.ClassFactory;
   import mx.core.IDataRenderer;
   import mx.core.IFactory;
   import mx.core.IFlexDisplayObject;
   import mx.core.IUITextField;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.events.PropertyChangeEvent;
   import mx.graphics.IFill;
   import mx.graphics.SolidColor;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.ISimpleStyleClient;
   
   [Style(name="labelRotation",type="Number",inherit="no")]
   [Style(name="labelSizeLimit",type="Number",inherit="no")]
   [Style(name="labelPosition",type="String",enumeration="none,outside,inside",inherit="no")]
   [Style(name="labelAlign",type="String",enumeration="left, center, right",inherit="no")]
   [Style(name="fills",type="Array",arrayType="mx.graphics.IFill",inherit="no")]
   [Style(name="textIndent",type="Number",format="Length",inherit="yes")]
   [Style(name="textDecoration",type="String",enumeration="none,underline",inherit="yes")]
   [Style(name="textAlign",type="String",enumeration="left,center,right",inherit="yes")]
   [Style(name="letterSpacing",type="Number",inherit="yes")]
   [Style(name="kerning",type="Boolean",inherit="yes")]
   [Style(name="fontWeight",type="String",enumeration="normal,bold",inherit="yes")]
   [Style(name="fontThickness",type="Number",inherit="yes")]
   [Style(name="fontStyle",type="String",enumeration="normal,italic",inherit="yes")]
   [Style(name="fontSize",type="Number",format="Length",inherit="yes")]
   [Style(name="fontSharpness",type="Number",inherit="yes")]
   [Style(name="fontGridFitType",type="String",enumeration="none,pixel,subpixel",inherit="yes")]
   [Style(name="fontFamily",type="String",inherit="yes")]
   [Style(name="fontAntiAliasType",type="String",enumeration="normal,advanced",inherit="yes")]
   [Style(name="disabledColor",type="uint",format="Color",inherit="yes")]
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   [Style(name="legendMarkerRenderer",type="mx.core.IFactory",inherit="no")]
   [Style(name="itemRenderer",type="mx.core.IFactory",inherit="no")]
   [Style(name="stroke",type="mx.graphics.IStroke",inherit="no")]
   [Style(name="fill",type="mx.graphics.IFill",inherit="no")]
   public class BarSeries extends Series implements IStackable2, IBar
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static var stylesInited:Boolean = initStyles();
      
      private var _horizontalAxis:IAxis;
      
      private var _labelField:String;
      
      private var _stacker:StackedSeries;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var labelCache:InstanceCache;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var maxLabelSize:Number;
      
      private var _verticalAxis:IAxis;
      
      private var _renderData:BarSeriesRenderData;
      
      private var _bAxesDirty:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var measuringField:IUITextField;
      
      private var _yField:String = "";
      
      private var _minField:String = "";
      
      private var _maxBarWidth:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var labelAngle:Number;
      
      private var _localFills:Array;
      
      private var _barWidthRatio:Number = 0.65;
      
      private var _labelLayer:UIComponent;
      
      private var _1757871014_fillFunction:Function = defaultFillFunction;
      
      private var _xField:String = "";
      
      private var _userMinField:String = "";
      
      private var _offset:Number = 0;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var labelPos:String = "none";
      
      private var _fillCount:int;
      
      private var _stacked:Boolean = false;
      
      private var _labelFunction:Function;
      
      private var _instanceCache:InstanceCache;
      
      public function BarSeries()
      {
         super();
         _instanceCache = new InstanceCache(null,this);
         _instanceCache.creationCallback = applyItemRendererProperties;
         _labelLayer = new UIComponent();
         _labelLayer.styleName = this;
         labelCache = new InstanceCache(Label,_labelLayer);
         labelCache.discard = true;
         labelCache.properties = {
            "selectable":false,
            "styleName":this
         };
         dataTransform = new CartesianTransform();
      }
      
      private static function initStyles() : Boolean
      {
         var barSeriesStyle:CSSStyleDeclaration;
         HaloDefaults.init();
         barSeriesStyle = HaloDefaults.createSelector("BarSeries");
         barSeriesStyle.defaultFactory = function():void
         {
            this.fill = new SolidColor(0);
            this.fills = [];
            this.itemRenderer = new ClassFactory(BoxItemRenderer);
            this.stroke = HaloDefaults.emptyStroke;
            this.labelSizeLimit = 9;
         };
         return true;
      }
      
      [Inspectable(category="General")]
      public function get yField() : String
      {
         return _yField;
      }
      
      [Inspectable(category="General")]
      public function get maxBarWidth() : Number
      {
         return _maxBarWidth;
      }
      
      public function set yField(value:String) : void
      {
         _yField = value;
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
            if(_yField != "")
            {
               if((requiredFields & DataDescription.REQUIRED_MIN_INTERVAL) != 0)
               {
                  sortedCache = _renderData.cache.concat();
                  sortedCache.sortOn("yNumber",Array.NUMERIC);
                  extractMinMax(sortedCache,"yNumber",description,(requiredFields & DataDescription.REQUIRED_MIN_INTERVAL) != 0);
               }
               else
               {
                  extractMinMax(_renderData.cache,"yNumber",description,(requiredFields & DataDescription.REQUIRED_MIN_INTERVAL) != 0);
               }
            }
            else
            {
               description.min = _renderData.cache[0].yNumber;
               description.max = _renderData.cache[_renderData.cache.length - 1].yNumber;
               if((requiredFields & DataDescription.REQUIRED_MIN_INTERVAL) != 0)
               {
                  extractMinInterval(_renderData.cache,"xNumber",description);
               }
            }
            description.padding = 0.5;
         }
         else
         {
            if(dimension != CartesianTransform.HORIZONTAL_AXIS)
            {
               return [];
            }
            extractMinMax(_renderData.cache,"xNumber",description);
            if(_minField != "")
            {
               extractMinMax(_renderData.cache,"minNumber",description);
            }
         }
         return [description];
      }
      
      override protected function updateData() : void
      {
         if(Boolean(_stacker))
         {
            _stacker.stack();
            super.updateData();
            return;
         }
         _stacked = false;
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
         cacheDefaultValues(_xField,_renderData.cache,"xValue");
         cacheIndexValues(_yField,_renderData.cache,"yValue");
         if(_minField != "")
         {
            cacheNamedValues(_minField,_renderData.cache,"minValue");
            _renderData.renderedBase = NaN;
         }
         super.updateData();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         measuringField = IUITextField(createInFontContext(UITextField));
         measuringField.visible = false;
         measuringField.styleName = this;
         addChild(DisplayObject(measuringField));
      }
      
      override public function notifyStyleChangeInChildren(styleProp:String, recursive:Boolean) : void
      {
         super.notifyStyleChangeInChildren(styleProp,recursive);
         _labelLayer.styleChanged(styleProp);
         if(recursive)
         {
            _labelLayer.notifyStyleChangeInChildren(styleProp,recursive);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function invalidateLabels() : void
      {
         var b:BarChart = null;
         if(Boolean(chart) && chart is BarChart)
         {
            b = BarChart(chart);
            b.measureLabels();
         }
      }
      
      public function set offset(value:Number) : void
      {
         _offset = value;
         invalidateTransform();
      }
      
      override public function localToData(v:Point) : Array
      {
         return dataTransform.invertTransform(v.x - this.x,v.y - this.y);
      }
      
      override public function getElementBounds(renderData:Object) : void
      {
         var maxBounds:Rectangle = null;
         var bo:Number = NaN;
         var to:Number = NaN;
         var v:Object = null;
         var i:int = 0;
         var l:Number = NaN;
         var b:Rectangle = null;
         var cache:Array = renderData.cache;
         var rb:Array = [];
         var sampleCount:int = int(cache.length);
         if(sampleCount == 0)
         {
            maxBounds = new Rectangle(0,0,unscaledWidth,unscaledHeight);
         }
         else
         {
            bo = renderData.renderedHalfWidth + renderData.renderedYOffset;
            to = -renderData.renderedHalfWidth + renderData.renderedYOffset;
            v = cache[0];
            maxBounds = new Rectangle(v.x,v.y,0,0);
            for(i = 0; i < sampleCount; i++)
            {
               v = cache[i];
               l = Math.min(v.min,v.x);
               b = new Rectangle(l,v.y + to,Math.max(v.min,v.x) - l,bo - to);
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function updateLabels() : void
      {
         var labelPosition:String = null;
         if(!dataTransform)
         {
            labelCache.count = 0;
            return;
         }
         _labelLayer.graphics.clear();
         if(!dataProvider)
         {
            labelCache.count = 0;
            return;
         }
         var renderData:BarSeriesRenderData = !transitionRenderData ? _renderData : BarSeriesRenderData(transitionRenderData);
         var activeRenderCache:Array = renderData.filteredCache;
         if(renderData.length == 0)
         {
            labelCache.count = 0;
            _instanceCache.count = 0;
            return;
         }
         if(Boolean(chart) && Boolean(chart is BarChart) && BarChart(chart).allLabelsMeasured)
         {
            labelPosition = labelPos;
            if(labelPosition == "outside")
            {
               renderExternalLabels(renderData,activeRenderCache);
            }
            else if(labelPosition == "inside")
            {
               renderInternalLabels(renderData,activeRenderCache);
            }
            else
            {
               labelCache.count = 0;
            }
         }
      }
      
      public function get stacker() : StackedSeries
      {
         return _stacker;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get seriesRenderData() : Object
      {
         var renderDataType:Class = null;
         var rv:BarSeriesRenderData = null;
         if(!_renderData)
         {
            renderDataType = this.renderDataType;
            rv = new renderDataType();
            rv.cache = rv.filteredCache = [];
            rv.renderedHalfWidth = 0;
            rv.renderedYOffset = 0;
            rv.renderedBase = 0;
            return rv;
         }
         return _renderData;
      }
      
      [Inspectable(category="Data")]
      public function get verticalAxis() : IAxis
      {
         return _verticalAxis;
      }
      
      private function renderInternalLabels(renderData:BarSeriesRenderData, activeCount:Array) : void
      {
         var label:Label = null;
         var v:BarSeriesItem = null;
         var len:int = int(activeCount.length);
         labelCache.count = len;
         var labels:Array = labelCache.instances;
         var dataTransform:CartesianTransform = CartesianTransform(dataTransform);
         var align:String = getStyle("labelAlign");
         var size:Number = Number(getStyle("fontSize"));
         for(var i:int = 0; i < len; i++)
         {
            v = activeCount[i];
            label = labels[i];
            label.x = v.labelX;
            label.y = v.labelY;
            label.text = v.labelText;
            label.width = v.labelWidth;
            label.height = v.labelHeight;
            label.setStyle("fontSize",size * renderData.labelScale);
            if(align == "left")
            {
               if(v.x > (isNaN(v.min) ? renderData.renderedBase : v.min))
               {
                  label.setStyle("textAlign","left");
               }
               else if(v.x < (isNaN(v.min) ? renderData.renderedBase : v.min))
               {
                  label.setStyle("textAlign","right");
               }
               else
               {
                  label.text = "";
               }
            }
            else if(align == "right")
            {
               if(v.x > (isNaN(v.min) ? renderData.renderedBase : v.min))
               {
                  label.setStyle("textAlign","right");
               }
               else if(v.x < (isNaN(v.min) ? renderData.renderedBase : v.min))
               {
                  label.setStyle("textAlign","left");
               }
               else
               {
                  label.text = "";
               }
            }
            else if(v.x == (isNaN(v.min) ? renderData.renderedBase : v.min))
            {
               label.text = "";
            }
            else
            {
               label.setStyle("textAlign","center");
            }
            label.validateNow();
         }
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
         return [ld];
      }
      
      [Inspectable(category="General",defaultValue="0.65")]
      public function get barWidthRatio() : Number
      {
         return _barWidthRatio;
      }
      
      [Bindable(event="propertyChange")]
      private function get _fillFunction() : Function
      {
         return this._1757871014_fillFunction;
      }
      
      private function defaultFillFunction(element:BarSeriesItem, i:Number) : IFill
      {
         if(_fillCount != 0)
         {
            return GraphicsUtilities.fillFromStyle(_localFills[i % _fillCount]);
         }
         return GraphicsUtilities.fillFromStyle(getStyle("fill"));
      }
      
      override protected function get renderData() : Object
      {
         var renderDataType:Class = null;
         var rv:BarSeriesRenderData = null;
         if(!_renderData)
         {
            renderDataType = this.renderDataType;
            rv = new renderDataType();
            rv.cache = rv.filteredCache = [];
            rv.renderedHalfWidth = 0;
            rv.renderedYOffset = 0;
            rv.renderedBase = 0;
            return rv;
         }
         return _renderData;
      }
      
      [Inspectable(category="General")]
      public function get xField() : String
      {
         return _xField;
      }
      
      [Inspectable(category="General")]
      public function get labelField() : String
      {
         return _labelField;
      }
      
      public function set stacker(value:StackedSeries) : void
      {
         _stacker = value;
      }
      
      public function set verticalAxis(value:IAxis) : void
      {
         _verticalAxis = value;
         _bAxesDirty = true;
         invalidateData();
         invalidateProperties();
      }
      
      public function get fillFunction() : Function
      {
         return _fillFunction;
      }
      
      override public function beginInterpolation(sourceRenderData:Object, destRenderData:Object) : Object
      {
         var idata:Object = initializeInterpolationData(sourceRenderData.cache,destRenderData.cache,{
            "x":true,
            "y":true,
            "min":true
         },itemType,{
            "sourceRenderData":sourceRenderData,
            "destRenderData":destRenderData
         });
         var interpolationRenderData:BarSeriesRenderData = BarSeriesRenderData(destRenderData.clone());
         interpolationRenderData.cache = idata.cache;
         interpolationRenderData.filteredCache = idata.cache;
         transitionRenderData = interpolationRenderData;
         return idata;
      }
      
      override protected function invalidateData(invalid:Boolean = true) : void
      {
         if(Boolean(_stacker))
         {
            _stacker.invalidateStacking();
         }
         super.invalidateData(invalid);
      }
      
      public function stack(stackedYValueDictionary:Dictionary, previousElement:IStackable) : Number
      {
         var chartItem:BarSeriesItem = null;
         var dataItem:* = undefined;
         var xValue:Number = NaN;
         var yValue:* = undefined;
         var stackedValue:Object = null;
         var i:uint = 0;
         var itemClass:Class = itemType;
         var haveYField:Boolean = _yField != null && _yField != "";
         var haveXField:Boolean = _xField != null && _xField != "";
         var maxValue:Number = 0;
         var renderDataType:Class = this.renderDataType;
         _renderData = new renderDataType();
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
                  xValue = Number(haveXField ? dataItem[_xField] : dataItem);
                  yValue = haveYField ? dataItem[_yField] : i;
               }
               if(yValue == null)
               {
                  i++;
                  cursor.moveNext();
               }
               else
               {
                  if(yValue is XMLList)
                  {
                     yValue = yValue.toString();
                  }
                  if(isNaN(xValue))
                  {
                     xValue = 0;
                  }
                  stackedValue = stackedYValueDictionary[yValue];
                  if(stackedValue == null)
                  {
                     stackedValue = 0;
                  }
                  xValue += stackedValue;
                  chartItem.minValue = stackedValue;
                  stackedYValueDictionary[yValue] = xValue;
                  chartItem.yValue = yValue;
                  chartItem.xValue = xValue;
                  maxValue = Math.max(maxValue,xValue);
                  i++;
                  cursor.moveNext();
               }
            }
         }
         _stacked = previousElement != null;
         invalidateMapping(true);
         invalidateData(false);
         return maxValue;
      }
      
      public function set minField(value:String) : void
      {
         _userMinField = value;
         _minField = value;
         dataChanged();
      }
      
      [Inspectable(category="General",defaultValue="0")]
      public function get offset() : Number
      {
         return _offset;
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
            if(propName == "x" || propName == "min")
            {
               if(isNaN(src))
               {
                  src = Number(customData.destRenderData.renderedBase);
               }
               if(isNaN(dst))
               {
                  dst = Number(customData.sourceRenderData.renderedBase);
               }
            }
            else if(propName == "y")
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
      
      override public function stylesInitialized() : void
      {
         _localFills = getStyle("fills");
         _fillCount = _localFills.length;
         labelPos = getStyle("labelPosition");
         if(labelPos == "none")
         {
            labelPos = "";
         }
         labelAngle = getStyle("labelRotation");
         maxLabelSize = getStyle("labelSizeLimit");
         super.stylesInitialized();
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
               dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).filterCache(_renderData.filteredCache,"minNumber","minFilter");
               stripNaNs(_renderData.filteredCache,"minFilter");
            }
         }
         else
         {
            _renderData.filteredCache = _renderData.cache;
         }
         super.updateFilter();
      }
      
      override protected function updateTransform() : void
      {
         var baseVal:Number = NaN;
         var stub:Array = null;
         var len:int = 0;
         var i:int = 0;
         var cChart:CartesianChart = null;
         var seriesLen:int = 0;
         var secondSeriesLen:int = 0;
         if(_minField != "" || _stacked)
         {
            dataTransform.transformCache(_renderData.filteredCache,"minNumber","min","","");
         }
         else
         {
            baseVal = dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).baseline;
            stub = [{"xNumber":baseVal}];
            dataTransform.transformCache(stub,"xNumber","x",null,null);
            _renderData.renderedBase = stub[0].x;
            len = int(_renderData.filteredCache.length);
            for(i = 0; i < len; i++)
            {
               _renderData.filteredCache[i].min = _renderData.renderedBase;
            }
         }
         dataTransform.transformCache(_renderData.filteredCache,"xNumber","x","yNumber","y");
         var unitSize:Number = dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).unitSize;
         var params:Array = [{"yNumber":0},{"yNumber":_barWidthRatio * unitSize / 2},{"yNumber":_offset * unitSize}];
         dataTransform.transformCache(params,null,null,"yNumber","y");
         if(!isNaN(_maxBarWidth) && (_maxBarWidth <= 0 || _barWidthRatio <= 0))
         {
            return;
         }
         _renderData.renderedHalfWidth = params[0].y - params[1].y;
         if(_offset == 0)
         {
            _renderData.renderedYOffset = 0;
         }
         else
         {
            _renderData.renderedYOffset = params[2].y - params[0].y;
         }
         if(Boolean(_maxBarWidth) && _maxBarWidth < _renderData.renderedHalfWidth)
         {
            _renderData.renderedYOffset *= _maxBarWidth / _renderData.renderedHalfWidth;
            _renderData.renderedHalfWidth = _maxBarWidth;
         }
         labelPos = getStyle("labelPosition");
         var temp:IUITextField = IUITextField(createInFontContext(UITextField));
         temp.text = "W";
         if(temp.textHeight > 2 * _renderData.renderedHalfWidth)
         {
            labelPos = "";
            labelCache.count = 0;
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
         var yName:String = dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).displayName;
         if(yName != "")
         {
            dt += "<i>" + yName + ":</i> ";
         }
         dt += dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).formatForScreen(BarSeriesItem(hd.chartItem).yValue) + "\n";
         var xName:String = dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).displayName;
         if(minField == "")
         {
            if(xName != "")
            {
               dt += "<i>" + xName + ":</i> ";
            }
            dt += dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).formatForScreen(BarSeriesItem(hd.chartItem).xValue) + "\n";
         }
         else
         {
            if(xName != "")
            {
               dt += "<i>" + xName + " (high):</i> ";
            }
            else
            {
               dt += "<i>high:</i> ";
            }
            dt += dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).formatForScreen(BarSeriesItem(hd.chartItem).xValue) + "\n";
            if(xName != "")
            {
               dt += "<i>" + xName + " (low):</i> ";
            }
            else
            {
               dt += "<i>low:</i> ";
            }
            dt += dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).formatForScreen(BarSeriesItem(hd.chartItem).minValue) + "\n";
         }
         return dt;
      }
      
      override public function getItemsInRegion(r:Rectangle) : Array
      {
         var v:BarSeriesItem = null;
         var bo:Number = NaN;
         var to:Number = NaN;
         var rcTemp:Rectangle = null;
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
            bo = renderData.renderedHalfWidth + renderData.renderedYOffset;
            to = -renderData.renderedHalfWidth + renderData.renderedYOffset;
            rc.top = v.y + to;
            rc.bottom = v.y + bo;
            rc.right = v.x;
            if(!isNaN(v.min))
            {
               rc.left = v.min;
            }
            else
            {
               rc.left = renderData.renderedBase;
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
      
      public function set stackTotals(totals:Dictionary) : void
      {
         var cache:Array = null;
         var n:int = 0;
         var i:int = 0;
         var item:BarSeriesItem = null;
         var total:Number = NaN;
         if(Boolean(totals))
         {
            cache = _renderData.cache;
            n = int(_renderData.cache.length);
            for(i = 0; i < n; i++)
            {
               item = cache[i];
               total = Number(totals[item.yValue]);
               item.xValue = Math.min(100,Number(item.xValue) / total * 100);
               item.minValue = Math.min(100,Number(item.minValue) / total * 100);
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
      
      public function set barWidthRatio(value:Number) : void
      {
         _barWidthRatio = value;
         invalidateTransform();
      }
      
      [Inspectable(environment="none")]
      protected function get renderDataType() : Class
      {
         return BarSeriesRenderData;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         var style1:String = "stroke fill";
         var style2:String = "fills";
         if(styleProp == null || styleProp == "" || style1.indexOf(styleProp) != -1)
         {
            invalidateDisplayList();
            legendDataChanged();
         }
         else if(styleProp == "itemRenderer")
         {
            _instanceCache.remove = true;
            _instanceCache.discard = true;
            _instanceCache.count = 0;
            _instanceCache.discard = false;
            _instanceCache.remove = false;
         }
         else if(style2.indexOf(styleProp) != -1)
         {
            _localFills = getStyle("fills");
            _fillCount = _localFills.length;
            invalidateDisplayList();
            legendDataChanged();
         }
         else if(styleProp == "labelAlign")
         {
            invalidateLabels();
         }
         else if(styleProp == "labelPosition")
         {
            labelPos = getStyle("labelPosition");
            invalidateLabels();
         }
         else if(styleProp == "labelSizeLimit")
         {
            maxLabelSize = getStyle("labelSizeLimit");
            invalidateLabels();
         }
         else if(styleProp == "labelRotation")
         {
            labelAngle = getStyle("labelRotation");
            invalidateLabels();
         }
      }
      
      public function set xField(value:String) : void
      {
         _xField = value;
         dataChanged();
      }
      
      override protected function updateMapping() : void
      {
         dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).mapCache(_renderData.cache,"xValue","xNumber");
         dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).mapCache(_renderData.cache,"yValue","yNumber",_yField == "");
         if(_minField != "" || _stacked)
         {
            dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).mapCache(_renderData.cache,"minValue","minNumber");
         }
         if(_yField != "")
         {
            _renderData.cache.sortOn("yNumber",Array.NUMERIC);
         }
         super.updateMapping();
      }
      
      override public function findDataPoints(x:Number, y:Number, sensitivity:Number) : Array
      {
         var minItem:BarSeriesItem = null;
         var v:BarSeriesItem = null;
         var dist:Number = NaN;
         var base:Number = NaN;
         var max:Number = NaN;
         var min:Number = NaN;
         var xpos:Number = NaN;
         var hd:HitData = null;
         var fill:IFill = null;
         if(interactive == false || !_renderData)
         {
            return [];
         }
         var modY:Number = y + _renderData.renderedYOffset;
         var minDist:Number = _renderData.renderedHalfWidth + sensitivity;
         var len:int = int(_renderData.filteredCache.length);
         var bottom:Number = Number(unscaledHeight);
         for(var i:int = 0; i < len; i++)
         {
            v = _renderData.filteredCache[i];
            if(v.y + _renderData.renderedYOffset + _renderData.renderedHalfWidth > 0)
            {
               if(v.y + _renderData.renderedYOffset - _renderData.renderedHalfWidth < bottom)
               {
                  dist = Math.abs(v.y + _renderData.renderedYOffset - y);
                  if(dist <= minDist)
                  {
                     base = isNaN(v.min) ? _renderData.renderedBase : v.min;
                     max = Math.max(v.x,base);
                     min = Math.min(v.x,base);
                     if(min - x <= sensitivity)
                     {
                        if(x - max <= sensitivity)
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
            }
         }
         if(Boolean(minItem))
         {
            if(minItem.xNumber >= 0)
            {
               xpos = isNaN(minItem.min) ? minItem.x : Math.max(minItem.x,minItem.min);
            }
            else
            {
               xpos = isNaN(minItem.min) ? minItem.x : Math.min(minItem.x,minItem.min);
            }
            hd = new HitData(createDataID(minItem.index),Math.sqrt(minDist),xpos,minItem.y + _renderData.renderedYOffset,minItem);
            hd.dataTipFunction = formatDataTip;
            fill = BarSeriesItem(hd.chartItem).fill;
            hd.contextColor = GraphicsUtilities.colorFromFill(fill);
            return [hd];
         }
         return [];
      }
      
      override public function get items() : Array
      {
         return Boolean(_renderData) ? _renderData.filteredCache : null;
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
      
      public function set labelField(value:String) : void
      {
         _labelField = value;
         invalidateLabels();
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
      
      protected function applyItemRendererProperties(instance:DisplayObject, cache:InstanceCache) : void
      {
         if(instance is ISimpleStyleClient)
         {
            ISimpleStyleClient(instance).styleName = this;
         }
      }
      
      public function set labelFunction(value:Function) : void
      {
         _labelFunction = value;
         invalidateLabels();
      }
      
      private function renderExternalLabels(renderData:BarSeriesRenderData, activeCount:Array) : void
      {
         var label:Label = null;
         var v:BarSeriesItem = null;
         var len:int = int(activeCount.length);
         labelCache.count = len;
         var labels:Array = labelCache.instances;
         var rotation:Number = Number(getStyle("labelRotation"));
         var size:Number = Number(getStyle("fontSize"));
         for(var i:int = 0; i < len; i++)
         {
            v = activeCount[i];
            label = labels[i];
            label.x = v.labelX;
            label.y = v.labelY;
            label.width = v.labelWidth;
            label.height = v.labelHeight;
            label.text = v.labelText;
            label.setStyle("fontSize",size * renderData.labelScale);
            if(v.x > (isNaN(v.min) ? renderData.renderedBase : v.min))
            {
               label.setStyle("textAlign","left");
            }
            else if(v.x < (isNaN(v.min) ? renderData.renderedBase : v.min))
            {
               if(!isNaN(rotation) && rotation != 0 && Boolean(measuringField.embedFonts))
               {
                  label.setStyle("textAlign","left");
                  label.rotation = rotation;
               }
               else
               {
                  label.setStyle("textAlign","right");
                  label.rotation = 0;
               }
            }
            else
            {
               label.text = "";
            }
            label.validateNow();
         }
      }
      
      [Inspectable(category="Data")]
      public function get horizontalAxis() : IAxis
      {
         return _horizontalAxis;
      }
      
      [Inspectable(category="General")]
      public function get labelFunction() : Function
      {
         return _labelFunction;
      }
      
      public function set maxBarWidth(value:Number) : void
      {
         _maxBarWidth = value;
         invalidateTransform();
      }
      
      [Inspectable(environment="none")]
      protected function get itemType() : Class
      {
         return BarSeriesItem;
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
         var rc:Rectangle = null;
         var instances:Array = null;
         var inst:IFlexDisplayObject = null;
         var elementBounds:Array = null;
         var bo:Number = NaN;
         var to:Number = NaN;
         var v:BarSeriesItem = null;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(!dataTransform)
         {
            labelCache.count = 0;
            return;
         }
         var g:Graphics = graphics;
         g.clear();
         _labelLayer.graphics.clear();
         if(!dataProvider)
         {
            labelCache.count = 0;
            return;
         }
         if(!isNaN(_maxBarWidth) && (_maxBarWidth <= 0 || _barWidthRatio <= 0))
         {
            return;
         }
         var renderData:BarSeriesRenderData = Boolean(transitionRenderData) ? BarSeriesRenderData(transitionRenderData) : _renderData;
         var activeRenderCache:Array = renderData.filteredCache;
         var sampleCount:int = int(activeRenderCache.length);
         _instanceCache.factory = getStyle("itemRenderer");
         _instanceCache.count = sampleCount;
         instances = _instanceCache.instances;
         var bSetData:Boolean = sampleCount > 0 && instances[0] is IDataRenderer;
         if(renderData.length == 0)
         {
            labelCache.count = 0;
            _instanceCache.count = 0;
            if(Boolean(chart) && (chart.showAllDataTips || chart.dataTipItemsSet))
            {
               chart.updateAllDataTips();
            }
            return;
         }
         if(Boolean(transitionRenderData) && Boolean(transitionRenderData.elementBounds))
         {
            elementBounds = transitionRenderData.elementBounds;
            labelCache.count = 0;
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
            bo = renderData.renderedHalfWidth + renderData.renderedYOffset;
            to = -renderData.renderedHalfWidth + renderData.renderedYOffset;
            rc = new Rectangle();
            for(i = 0; i < sampleCount; i++)
            {
               v = activeRenderCache[i];
               rc.top = v.y + to;
               rc.bottom = v.y + bo;
               rc.right = v.x;
               if(!isNaN(v.min))
               {
                  rc.left = v.min;
               }
               else
               {
                  rc.left = renderData.renderedBase;
               }
               inst = instances[i];
               v = activeRenderCache[i];
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
               inst.move(rc.left,rc.top);
               inst.setActualSize(rc.width,rc.height);
            }
            if(Boolean(chart) && Boolean(allSeriesTransform) && chart.chartState == 0)
            {
               chart.updateAllDataTips();
            }
         }
      }
      
      public function stackAll(stackedPosYValueDictionary:Dictionary, stackedNegYValueDictionary:Dictionary, previousElement:IStackable2) : Object
      {
         var chartItem:BarSeriesItem = null;
         var dataItem:* = undefined;
         var xValue:Number = NaN;
         var yValue:* = undefined;
         var stackedValue:Object = null;
         var i:uint = 0;
         var itemClass:Class = itemType;
         var haveYField:Boolean = _yField != null && _yField != "";
         var haveXField:Boolean = _xField != null && _xField != "";
         var maxValue:Number = 0;
         var minValue:Number = 0;
         var renderDataType:Class = this.renderDataType;
         _renderData = new renderDataType();
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
                  xValue = Number(haveXField ? dataItem[_xField] : dataItem);
                  yValue = haveYField ? dataItem[_yField] : i;
               }
               if(yValue == null)
               {
                  i++;
                  cursor.moveNext();
               }
               else
               {
                  if(yValue is XMLList)
                  {
                     yValue = yValue.toString();
                  }
                  if(isNaN(xValue))
                  {
                     xValue = 0;
                  }
                  if(xValue >= 0)
                  {
                     stackedValue = stackedPosYValueDictionary[yValue];
                  }
                  else
                  {
                     stackedValue = stackedNegYValueDictionary[yValue];
                  }
                  if(stackedValue == null)
                  {
                     stackedValue = 0;
                  }
                  xValue += stackedValue;
                  chartItem.minValue = stackedValue;
                  if(xValue >= 0)
                  {
                     stackedPosYValueDictionary[yValue] = xValue;
                     maxValue = Math.max(maxValue,xValue);
                  }
                  else
                  {
                     stackedNegYValueDictionary[yValue] = xValue;
                     minValue = Math.min(minValue,xValue);
                  }
                  chartItem.yValue = yValue;
                  chartItem.xValue = xValue;
                  i++;
                  cursor.moveNext();
               }
            }
         }
         _stacked = previousElement != null;
         invalidateMapping(true);
         invalidateData(false);
         return {
            "maxValue":maxValue,
            "minValue":minValue
         };
      }
      
      override public function get labelContainer() : Sprite
      {
         return _labelLayer;
      }
      
      override public function getAllDataPoints() : Array
      {
         var i:uint = 0;
         var v:BarSeriesItem = null;
         var base:Number = NaN;
         var itemExists:Boolean = false;
         var j:int = 0;
         var xpos:Number = NaN;
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
         var bottom:Number = Number(unscaledHeight);
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
            if(v.y + _renderData.renderedYOffset + _renderData.renderedHalfWidth > 0)
            {
               if(v.y + _renderData.renderedYOffset - _renderData.renderedHalfWidth < bottom)
               {
                  base = isNaN(v.min) ? _renderData.renderedBase : v.min;
                  if(Boolean(v))
                  {
                     if(v.xNumber >= 0)
                     {
                        xpos = isNaN(v.min) ? v.x : Math.max(v.x,v.min);
                     }
                     else
                     {
                        xpos = isNaN(v.min) ? v.x : Math.min(v.x,v.min);
                     }
                     hd = new HitData(createDataID(v.index),Math.sqrt(0),xpos,v.y + _renderData.renderedYOffset,v);
                     hd.dataTipFunction = formatDataTip;
                     fill = BarSeriesItem(hd.chartItem).fill;
                     hd.contextColor = GraphicsUtilities.colorFromFill(fill);
                     result.push(hd);
                  }
               }
            }
         }
         return result;
      }
   }
}

