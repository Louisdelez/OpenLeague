package mx.charts.series
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import mx.charts.ColumnChart;
   import mx.charts.HitData;
   import mx.charts.chartClasses.CartesianChart;
   import mx.charts.chartClasses.CartesianTransform;
   import mx.charts.chartClasses.DataDescription;
   import mx.charts.chartClasses.GraphicsUtilities;
   import mx.charts.chartClasses.IAxis;
   import mx.charts.chartClasses.IColumn;
   import mx.charts.chartClasses.IStackable;
   import mx.charts.chartClasses.IStackable2;
   import mx.charts.chartClasses.InstanceCache;
   import mx.charts.chartClasses.LegendData;
   import mx.charts.chartClasses.Series;
   import mx.charts.chartClasses.StackedSeries;
   import mx.charts.renderers.BoxItemRenderer;
   import mx.charts.series.items.ColumnSeriesItem;
   import mx.charts.series.renderData.ColumnSeriesRenderData;
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
   public class ColumnSeries extends Series implements IColumn, IStackable2
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static var stylesInited:Boolean = initStyles();
      
      private var _horizontalAxis:IAxis;
      
      private var _labelField:String;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var maxLabelSize:Number;
      
      private var _verticalAxis:IAxis;
      
      private var _bAxesDirty:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var measuringField:IUITextField;
      
      private var _yField:String = "";
      
      private var _minField:String = "";
      
      private var _maxColumnWidth:Number;
      
      private var _columnWidthRatio:Number = 0.65;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var labelAngle:Number;
      
      private var _localFills:Array;
      
      private var _labelLayer:UIComponent;
      
      private var _1757871014_fillFunction:Function = defaultFillFunction;
      
      private var _xField:String = "";
      
      private var _userMinField:String = "";
      
      private var _offset:Number = 0;
      
      private var _sortOnXField:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var labelPos:String = "none";
      
      private var _fillCount:int;
      
      private var _stacked:Boolean = false;
      
      private var _instanceCache:InstanceCache;
      
      private var _labelFunction:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var labelCache:InstanceCache;
      
      private var _stacker:StackedSeries;
      
      private var _renderData:ColumnSeriesRenderData;
      
      public function ColumnSeries()
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
         var columnSeriesStyle:CSSStyleDeclaration;
         HaloDefaults.init();
         columnSeriesStyle = HaloDefaults.createSelector("ColumnSeries");
         columnSeriesStyle.defaultFactory = function():void
         {
            this.fill = new SolidColor(0);
            this.fills = [];
            this.itemRenderer = new ClassFactory(BoxItemRenderer);
            this.stroke = HaloDefaults.emptyStroke;
            this.labelSizeLimit = 9;
         };
         return true;
      }
      
      public function stackAll(stackedPosXValueDictionary:Dictionary, stackedNegXValueDictionary:Dictionary, previousElement:IStackable2) : Object
      {
         var chartItem:ColumnSeriesItem = null;
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
         _stacked = previousElement != null;
         invalidateMapping(true);
         invalidateData(false);
         return {
            "maxValue":maxValue,
            "minValue":minValue
         };
      }
      
      [Inspectable(category="General")]
      public function get yField() : String
      {
         return _yField;
      }
      
      public function set yField(value:String) : void
      {
         _yField = value;
         dataChanged();
      }
      
      [Inspectable(category="General")]
      public function get maxColumnWidth() : Number
      {
         return _maxColumnWidth;
      }
      
      override public function localToData(v:Point) : Array
      {
         return dataTransform.invertTransform(v.x - this.x,v.y - this.y);
      }
      
      override protected function updateData() : void
      {
         var v:ColumnSeriesItem = null;
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
         var i:uint = 0;
         var itemClass:Class = itemType;
         if(Boolean(cursor))
         {
            cursor.seek(CursorBookmark.FIRST);
            while(!cursor.afterLast)
            {
               _renderData.cache[i] = v = new itemClass(this,cursor.current,i);
               i++;
               cursor.moveNext();
            }
         }
         cacheIndexValues(_xField,_renderData.cache,"xValue");
         cacheDefaultValues(_yField,_renderData.cache,"yValue");
         if(_minField != "")
         {
            cacheNamedValues(_minField,_renderData.cache,"minValue");
            _renderData.renderedBase = NaN;
         }
         super.updateData();
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
            extractMinMax(_renderData.cache,"yNumber",description);
            if(_minField != "")
            {
               extractMinMax(_renderData.cache,"minNumber",description);
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
               if(_sortOnXField == false && (requiredFields & DataDescription.REQUIRED_MIN_INTERVAL) != 0)
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
      
      public function set maxColumnWidth(value:Number) : void
      {
         _maxColumnWidth = value;
         invalidateTransform();
      }
      
      override protected function invalidateMapping(invalid:Boolean = true) : void
      {
         if(Boolean(_stacker))
         {
            _stacker.invalidateStacking();
         }
         super.invalidateMapping(invalid);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         measuringField = IUITextField(createInFontContext(UITextField));
         measuringField.visible = false;
         measuringField.styleName = this;
         addChild(DisplayObject(measuringField));
      }
      
      public function invalidateLabels() : void
      {
         var c:ColumnChart = null;
         labelPos = getStyle("labelPosition");
         var temp:IUITextField = IUITextField(createInFontContext(UITextField));
         temp.text = "W";
         if(labelPos == "inside")
         {
            if(temp.textWidth > 2 * _renderData.renderedHalfWidth)
            {
               if(measuringField.embedFonts)
               {
                  if(temp.textHeight > 2 * renderData.renderedHalfWidth)
                  {
                     labelPos = "";
                     labelCache.count = 0;
                  }
               }
               else
               {
                  labelPos = "";
                  labelCache.count = 0;
               }
            }
         }
         else if(labelPos == "outside")
         {
            if(Boolean(chart) && !ColumnChart(chart).showLabelVertically)
            {
               if(temp.textWidth / 2 > 2 * _renderData.renderedHalfWidth)
               {
                  labelPos = "";
                  labelCache.count = 0;
               }
            }
            else if(temp.textWidth > 2 * _renderData.renderedHalfWidth)
            {
               if(measuringField.embedFonts)
               {
                  if(temp.textHeight > 2 * renderData.renderedHalfWidth)
                  {
                     labelPos = "";
                     labelCache.count = 0;
                  }
               }
               else
               {
                  labelPos = "";
                  labelCache.count = 0;
               }
            }
         }
         if(Boolean(chart) && chart is ColumnChart)
         {
            c = ColumnChart(chart);
            c.measureLabels();
         }
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
      
      public function set offset(value:Number) : void
      {
         _offset = value;
         invalidateTransform();
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
         var renderData:ColumnSeriesRenderData = transitionRenderData == null ? _renderData : ColumnSeriesRenderData(transitionRenderData);
         var activeCount:Array = renderData.filteredCache;
         if(renderData.length == 0)
         {
            labelCache.count = 0;
            _instanceCache.count = 0;
            return;
         }
         if(Boolean(chart) && Boolean(chart is ColumnChart) && ColumnChart(chart).allLabelsMeasured)
         {
            labelPosition = labelPos;
            if(labelPosition == "outside")
            {
               renderExternalLabels(renderData,activeCount);
            }
            else if(labelPosition == "inside")
            {
               renderInternalLabels(renderData,activeCount);
            }
            else
            {
               labelCache.count = 0;
            }
         }
      }
      
      override public function getElementBounds(renderData:Object) : void
      {
         var ro:Number = NaN;
         var lo:Number = NaN;
         var v:Object = null;
         var maxBounds:Rectangle = null;
         var i:uint = 0;
         var top:Number = NaN;
         var b:Rectangle = null;
         var cache:Array = renderData.filteredCache;
         var rb:Array = [];
         var sampleCount:uint = cache.length;
         if(Boolean(sampleCount))
         {
            ro = renderData.renderedHalfWidth + renderData.renderedXOffset;
            lo = -renderData.renderedHalfWidth + renderData.renderedXOffset;
            v = cache[0];
            maxBounds = new Rectangle(v.x,v.y,0,0);
            for(i = 0; i < sampleCount; i++)
            {
               v = cache[i];
               top = Math.min(v.y,v.min);
               b = new Rectangle(v.x + lo,top,ro - lo,Math.max(v.y,v.min) - top);
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
      
      public function get stacker() : StackedSeries
      {
         return _stacker;
      }
      
      [Inspectable(category="Data")]
      public function get verticalAxis() : IAxis
      {
         return _verticalAxis;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get seriesRenderData() : Object
      {
         var renderDataType:Class = null;
         var rv:ColumnSeriesRenderData = null;
         if(!_renderData)
         {
            renderDataType = this.renderDataType;
            rv = new renderDataType();
            rv.cache = rv.filteredCache = [];
            rv.renderedHalfWidth = 0;
            rv.renderedXOffset = 0;
            rv.renderedBase = 0;
            return rv;
         }
         return _renderData;
      }
      
      private function renderInternalLabels(renderData:ColumnSeriesRenderData, activeCount:Array) : void
      {
         var label:Label = null;
         var v:ColumnSeriesItem = null;
         var len:int = int(activeCount.length);
         labelCache.count = len;
         var labels:Array = labelCache.instances;
         var dataTransform:CartesianTransform = CartesianTransform(dataTransform);
         var size:Number = Number(getStyle("fontSize"));
         var align:String = getStyle("labelAlign");
         for(var i:int = 0; i < len; i++)
         {
            v = activeCount[i];
            label = labels[i];
            label.x = v.labelX;
            label.y = v.labelY;
            label.width = v.labelWidth;
            label.height = v.labelHeight;
            label.setStyle("fontSize",size * renderData.labelScale);
            label.text = v.labelText;
            if(v.labelIsHorizontal)
            {
               if(v.y == (isNaN(v.min) ? renderData.renderedBase : v.min))
               {
                  label.text = "";
               }
               else
               {
                  label.setStyle("textAlign","center");
                  label.rotation = 0;
               }
            }
            else
            {
               if(align == "bottom")
               {
                  if(v.y < (isNaN(v.min) ? renderData.renderedBase : v.min))
                  {
                     label.setStyle("textAlign","left");
                  }
                  else if(v.y > (isNaN(v.min) ? renderData.renderedBase : v.min))
                  {
                     label.setStyle("textAlign","right");
                  }
                  else
                  {
                     label.text = "";
                  }
               }
               else if(align == "top")
               {
                  if(v.y < (isNaN(v.min) ? renderData.renderedBase : v.min))
                  {
                     label.setStyle("textAlign","right");
                  }
                  else if(v.y > (isNaN(v.min) ? renderData.renderedBase : v.min))
                  {
                     label.setStyle("textAlign","left");
                  }
                  else
                  {
                     label.text = "";
                  }
               }
               else if(v.y == (isNaN(v.min) ? renderData.renderedBase : v.min))
               {
                  label.text = "";
               }
               else
               {
                  label.setStyle("textAlign","center");
               }
               label.rotation = -90;
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
         var markerFactory:IFactory = getStyle("legendMarkerRenderer");
         ld.element = this;
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
      
      [Bindable(event="propertyChange")]
      private function get _fillFunction() : Function
      {
         return this._1757871014_fillFunction;
      }
      
      private function defaultFillFunction(element:ColumnSeriesItem, i:Number) : IFill
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
         var rv:ColumnSeriesRenderData = null;
         if(!_renderData)
         {
            renderDataType = this.renderDataType;
            rv = new renderDataType();
            rv.cache = rv.filteredCache = [];
            rv.renderedHalfWidth = 0;
            rv.renderedXOffset = 0;
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
         var interpolationRenderData:ColumnSeriesRenderData = ColumnSeriesRenderData(destRenderData.clone());
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
            if(propName == "y" || propName == "min")
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
      
      public function stack(stackedXValueDictionary:Dictionary, previousElement:IStackable) : Number
      {
         var chartItem:ColumnSeriesItem = null;
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
         _stacked = previousElement != null;
         invalidateMapping(true);
         invalidateData(false);
         return maxValue;
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
            dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).filterCache(_renderData.filteredCache,"yNumber","yFilter");
            if(_minField != "" || _stacked)
            {
               dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).filterCache(_renderData.filteredCache,"minNumber","minFilter");
            }
            stripNaNs(_renderData.filteredCache,"yFilter");
            stripNaNs(_renderData.filteredCache,"xFilter");
            if(_minField != "" || _stacked)
            {
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
         var len:uint = 0;
         var i:int = 0;
         var cChart:CartesianChart = null;
         var seriesLen:int = 0;
         var secondSeriesLen:int = 0;
         if(_minField != "" || _stacked)
         {
            dataTransform.transformCache(_renderData.filteredCache,null,null,"minNumber","min");
         }
         else
         {
            baseVal = dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).baseline;
            stub = [{"yNumber":baseVal}];
            dataTransform.transformCache(stub,null,null,"yNumber","y");
            len = _renderData.filteredCache.length;
            _renderData.renderedBase = stub[0].y;
            for(i = 0; i < len; i++)
            {
               _renderData.filteredCache[i].min = _renderData.renderedBase;
            }
         }
         dataTransform.transformCache(_renderData.filteredCache,"xNumber","x","yNumber","y");
         var unitSize:Number = dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).unitSize;
         var params:Array = [{"xNumber":0},{"xNumber":_columnWidthRatio * unitSize / 2},{"xNumber":_offset * unitSize}];
         dataTransform.transformCache(params,"xNumber","x",null,null);
         if(!isNaN(_maxColumnWidth) && (_maxColumnWidth <= 0 || _columnWidthRatio <= 0))
         {
            return;
         }
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
         labelPos = getStyle("labelPosition");
         var temp:IUITextField = IUITextField(createInFontContext(UITextField));
         temp.text = "W";
         if(labelPos == "inside")
         {
            if(temp.textWidth > 2 * _renderData.renderedHalfWidth)
            {
               if(measuringField.embedFonts)
               {
                  if(temp.textHeight > 2 * renderData.renderedHalfWidth)
                  {
                     labelPos = "";
                     labelCache.count = 0;
                  }
               }
               else
               {
                  labelPos = "";
                  labelCache.count = 0;
               }
            }
         }
         else if(labelPos == "outside")
         {
            if(Boolean(chart) && !ColumnChart(chart).showLabelVertically)
            {
               if(temp.textWidth / 2 > 2 * _renderData.renderedHalfWidth)
               {
                  labelPos = "";
                  labelCache.count = 0;
               }
            }
            else if(temp.textWidth > 2 * _renderData.renderedHalfWidth)
            {
               if(measuringField.embedFonts)
               {
                  if(temp.textHeight > 2 * renderData.renderedHalfWidth)
                  {
                     labelPos = "";
                     labelCache.count = 0;
                  }
               }
               else
               {
                  labelPos = "";
                  labelCache.count = 0;
               }
            }
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
         if(n != null && n.length > 0)
         {
            dt += "<b>" + n + "</b><BR/>";
         }
         var xName:String = dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).displayName;
         if(xName != "")
         {
            dt += "<i>" + xName + ":</i> ";
         }
         dt += dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).formatForScreen(ColumnSeriesItem(hd.chartItem).xValue) + "\n";
         var yName:String = dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).displayName;
         if(_minField == "")
         {
            if(yName != "")
            {
               dt += "<i>" + yName + ":</i> ";
            }
            dt += dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).formatForScreen(ColumnSeriesItem(hd.chartItem).yValue) + "\n";
         }
         else
         {
            if(yName != "")
            {
               dt += "<i>" + yName + " (high):</i> ";
            }
            else
            {
               dt += "<i>high:</i> ";
            }
            dt += dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).formatForScreen(ColumnSeriesItem(hd.chartItem).yValue) + "\n";
            if(yName != "")
            {
               dt += "<i>" + yName + " (low):</i> ";
            }
            else
            {
               dt += "<i>low:</i> ";
            }
            dt += dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).formatForScreen(ColumnSeriesItem(hd.chartItem).minValue) + "\n";
         }
         return dt;
      }
      
      override public function getItemsInRegion(r:Rectangle) : Array
      {
         var v:ColumnSeriesItem = null;
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
         localRectangle.topLeft = globalToLocal(r.topLeft);
         localRectangle.bottomRight = globalToLocal(r.bottomRight);
         for(var i:int = 0; i < len; i++)
         {
            v = _renderData.filteredCache[i];
            ro = renderData.renderedHalfWidth + renderData.renderedXOffset;
            lo = -renderData.renderedHalfWidth + renderData.renderedXOffset;
            rc.left = v.x + lo;
            rc.right = v.x + ro;
            rc.top = v.y;
            if(!isNaN(v.min))
            {
               rc.bottom = v.min;
            }
            else
            {
               rc.bottom = _renderData.renderedBase;
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
         var item:ColumnSeriesItem = null;
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
      
      private function set _fillFunction(value:Function) : void
      {
         var oldValue:Object = this._1757871014_fillFunction;
         if(oldValue !== value)
         {
            this._1757871014_fillFunction = value;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_fillFunction",oldValue,value));
         }
      }
      
      public function set columnWidthRatio(value:Number) : void
      {
         _columnWidthRatio = value;
         invalidateTransform();
      }
      
      [Inspectable(environment="none")]
      protected function get renderDataType() : Class
      {
         return ColumnSeriesRenderData;
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
         else if(style2.indexOf(styleProp) != -1)
         {
            _localFills = getStyle("fills");
            _fillCount = _localFills.length;
            invalidateDisplayList();
            legendDataChanged();
         }
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
      
      override public function findDataPoints(x:Number, y:Number, sensitivity:Number) : Array
      {
         var minItem:ColumnSeriesItem = null;
         var i:uint = 0;
         var v:ColumnSeriesItem = null;
         var dist:Number = NaN;
         var base:Number = NaN;
         var max:Number = NaN;
         var min:Number = NaN;
         var ypos:Number = NaN;
         var id:uint = 0;
         var hd:HitData = null;
         var fill:IFill = null;
         if(interactive == false || !_renderData)
         {
            return [];
         }
         var minDist:Number = _renderData.renderedHalfWidth + sensitivity;
         var len:uint = _renderData.filteredCache.length;
         var right:Number = Number(unscaledWidth);
         for(i = 0; i < len; i++)
         {
            v = _renderData.filteredCache[i];
            if(v.x + _renderData.renderedXOffset + _renderData.renderedHalfWidth > 0)
            {
               if(v.x + _renderData.renderedXOffset - _renderData.renderedHalfWidth < right)
               {
                  dist = Math.abs(v.x + _renderData.renderedXOffset - x);
                  if(dist <= minDist)
                  {
                     base = isNaN(v.min) ? _renderData.renderedBase : v.min;
                     max = Math.max(v.y,base);
                     min = Math.min(v.y,base);
                     if(min - y <= sensitivity)
                     {
                        if(y - max <= sensitivity)
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
            if(minItem.yNumber >= 0)
            {
               ypos = isNaN(minItem.min) ? minItem.y : Math.min(minItem.y,minItem.min);
            }
            else
            {
               ypos = isNaN(minItem.min) ? minItem.y : Math.max(minItem.y,minItem.min);
            }
            id = uint(minItem.index);
            hd = new HitData(createDataID(id),Math.sqrt(minDist),minItem.x + _renderData.renderedXOffset,ypos,minItem);
            hd.dataTipFunction = formatDataTip;
            fill = ColumnSeriesItem(hd.chartItem).fill;
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
         return _userMinField;
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
      
      public function set sortOnXField(value:Boolean) : void
      {
         if(_sortOnXField == value)
         {
            return;
         }
         _sortOnXField = value;
         invalidateMapping();
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
      
      [Inspectable(category="General",defaultValue="0.65")]
      public function get columnWidthRatio() : Number
      {
         return _columnWidthRatio;
      }
      
      [Inspectable]
      public function get sortOnXField() : Boolean
      {
         return _sortOnXField;
      }
      
      private function renderExternalLabels(renderData:ColumnSeriesRenderData, activeCount:Array) : void
      {
         var label:Label = null;
         var v:ColumnSeriesItem = null;
         var rotation:Number = NaN;
         var len:int = int(activeCount.length);
         labelCache.count = len;
         var labels:Array = labelCache.instances;
         var size:Number = Number(getStyle("fontSize"));
         for(var i:int = 0; i < len; i++)
         {
            v = activeCount[i];
            label = labels[i];
            label.x = v.labelX;
            label.y = v.labelY;
            label.width = v.labelWidth;
            label.height = v.labelHeight;
            label.setStyle("fontSize",size * renderData.labelScale);
            label.text = v.labelText;
            rotation = Number(getStyle("labelRotation"));
            if(v.labelIsHorizontal)
            {
               if(v.y == (isNaN(v.min) ? renderData.renderedBase : v.min))
               {
                  label.text = "";
               }
               else if(Boolean(chart) && !ColumnChart(chart).showLabelVertically)
               {
                  label.setStyle("textAlign","left");
                  label.setStyle("paddingLeft",0);
                  label.rotation = 0;
               }
               else
               {
                  label.setStyle("textAlign","center");
                  label.rotation = 0;
               }
            }
            else
            {
               if(v.y < (isNaN(v.min) ? renderData.renderedBase : v.min))
               {
                  label.setStyle("textAlign","left");
               }
               else if(v.y > (isNaN(v.min) ? renderData.renderedBase : v.min))
               {
                  if(!isNaN(rotation))
                  {
                     label.setStyle("textAlign","left");
                  }
                  else
                  {
                     label.setStyle("textAlign","right");
                  }
               }
               else
               {
                  label.text = "";
               }
               if(!isNaN(rotation))
               {
                  label.rotation = rotation;
               }
               else
               {
                  label.rotation = -90;
               }
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
      
      [Inspectable(environment="none")]
      protected function get itemType() : Class
      {
         return ColumnSeriesItem;
      }
      
      [Inspectable(category="General")]
      public function set fillFunction(value:Function) : void
      {
         if(value != null)
         {
            _fillFunction = value;
         }
         else
         {
            _fillFunction = defaultFillFunction;
         }
         invalidateProperties();
         invalidateDisplayList();
         legendDataChanged();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var i:uint = 0;
         var rc:Rectangle = null;
         var instances:Array = null;
         var inst:IFlexDisplayObject = null;
         var v:ColumnSeriesItem = null;
         var elementBounds:Array = null;
         var ro:Number = NaN;
         var lo:Number = NaN;
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
         if(!isNaN(_maxColumnWidth) && (_maxColumnWidth <= 0 || _columnWidthRatio <= 0))
         {
            return;
         }
         var renderData:ColumnSeriesRenderData = transitionRenderData == null ? _renderData : ColumnSeriesRenderData(transitionRenderData);
         var activeCount:Array = renderData.filteredCache;
         var sampleCount:uint = activeCount.length;
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
               v = activeCount[i];
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
            ro = renderData.renderedHalfWidth + renderData.renderedXOffset;
            lo = -renderData.renderedHalfWidth + renderData.renderedXOffset;
            rc = new Rectangle();
            rc.bottom = Number(_minField == "" ? -renderData.renderedBase : 0);
            for(i = 0; i < sampleCount; i++)
            {
               v = activeCount[i];
               rc.left = v.x + lo;
               rc.right = v.x + ro;
               rc.top = v.y;
               if(!isNaN(v.min))
               {
                  rc.bottom = v.min;
               }
               else
               {
                  rc.bottom = renderData.renderedBase;
               }
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
               inst.move(rc.left,rc.top);
               inst.setActualSize(rc.width,rc.height);
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
         var v:ColumnSeriesItem = null;
         var base:Number = NaN;
         var itemExists:Boolean = false;
         var j:int = 0;
         var ypos:Number = NaN;
         var id:uint = 0;
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
            if(v.x + _renderData.renderedXOffset + _renderData.renderedHalfWidth > 0)
            {
               if(v.x + _renderData.renderedXOffset - _renderData.renderedHalfWidth < right)
               {
                  base = isNaN(v.min) ? _renderData.renderedBase : v.min;
                  if(Boolean(v))
                  {
                     if(v.yNumber >= 0)
                     {
                        ypos = isNaN(v.min) ? v.y : Math.min(v.y,v.min);
                     }
                     else
                     {
                        ypos = isNaN(v.min) ? v.y : Math.max(v.y,v.min);
                     }
                     id = uint(v.index);
                     hd = new HitData(createDataID(id),Math.sqrt(0),v.x + _renderData.renderedXOffset,ypos,v);
                     hd.dataTipFunction = formatDataTip;
                     fill = ColumnSeriesItem(hd.chartItem).fill;
                     hd.contextColor = GraphicsUtilities.colorFromFill(fill);
                     result.push(hd);
                  }
               }
            }
         }
         return result;
      }
      
      override public function get labelContainer() : Sprite
      {
         return _labelLayer;
      }
   }
}

