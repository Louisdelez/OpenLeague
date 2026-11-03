package mx.charts.series
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import mx.charts.HitData;
   import mx.charts.chartClasses.DataDescription;
   import mx.charts.chartClasses.GraphicsUtilities;
   import mx.charts.chartClasses.IAxis;
   import mx.charts.chartClasses.InstanceCache;
   import mx.charts.chartClasses.PolarChart;
   import mx.charts.chartClasses.PolarTransform;
   import mx.charts.chartClasses.Series;
   import mx.charts.renderers.WedgeItemRenderer;
   import mx.charts.series.items.PieSeriesItem;
   import mx.charts.series.renderData.PieSeriesRenderData;
   import mx.charts.styles.HaloDefaults;
   import mx.collections.CursorBookmark;
   import mx.core.ClassFactory;
   import mx.core.ContextualClassFactory;
   import mx.core.IDataRenderer;
   import mx.core.IFactory;
   import mx.core.IFlexDisplayObject;
   import mx.core.IUITextField;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.events.PropertyChangeEvent;
   import mx.graphics.IFill;
   import mx.graphics.IStroke;
   import mx.graphics.SolidColor;
   import mx.graphics.Stroke;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.ISimpleStyleClient;
   
   [Style(name="stroke",type="mx.graphics.IStroke",inherit="no")]
   [Style(name="radialStroke",type="mx.graphics.IStroke",inherit="no")]
   [Style(name="labelPosition",type="String",enumeration="none,outside,callout,inside,insideWithCallout",inherit="no")]
   [Style(name="insideLabelSizeLimit",type="Number",inherit="no")]
   [Style(name="innerRadius",type="Number",inherit="no")]
   [Style(name="fills",type="Array",arrayType="mx.graphics.IFill",inherit="no")]
   [Style(name="calloutStroke",type="mx.graphics.IStroke",inherit="no")]
   [Style(name="calloutGap",type="Number",format="Length",inherit="no")]
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
   public class PieSeries extends Series
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static var stylesInited:Boolean = initStyles();
      
      private static const DROP_SHADOW_SIZE:Number = 6;
      
      private var _field:String = "";
      
      private var _radiusInPixelsScaledForExplode:Number = 1;
      
      private var _assignedExplodeRadiusRatio:Number = 0;
      
      private var _renderData:PieSeriesRenderData;
      
      private var _labelField:String;
      
      private var _innerRadiusInPixelsScaledForExplode:Number = 0;
      
      private var _bAxesDirty:Boolean = false;
      
      private var _innerRadiusInPixels:Number = 0;
      
      private var _startAngleRadians:Number = 0;
      
      private var _radiusInPixelsAfterLabels:Number;
      
      private var _labelFunction:Function;
      
      private var _assignedReserveExplodeRadiusRatio:Number = 0;
      
      private var _assignedRadiusRatio:Number = 1;
      
      private var _measuringField:IUITextField;
      
      private var _origin:Point;
      
      private var _localFills:Array;
      
      private var _labelLayer:UIComponent;
      
      [Inspectable(category="General")]
      private var _1757871014_fillFunction:Function = defaultFillFunction;
      
      private var _maxExplodeRadiusRatio:Number = 0;
      
      private var _labelCache:InstanceCache;
      
      private var _perWedgeExplodeRadiusRatio:Array;
      
      [Inspectable(category="General")]
      public var maxLabelRadius:Number = 0.6;
      
      private var _nameField:String = "";
      
      private var _fillCount:int;
      
      private var _angularAxis:IAxis;
      
      private var _instanceCache:InstanceCache;
      
      public function PieSeries()
      {
         super();
         _labelLayer = new UIComponent();
         _labelLayer.styleName = this;
         _labelCache = new InstanceCache(UITextField,_labelLayer);
         _labelCache.discard = true;
         _labelCache.remove = true;
         _labelCache.properties = {
            "autoSize":TextFieldAutoSize.LEFT,
            "selectable":false,
            "styleName":this
         };
         perWedgeExplodeRadius = [];
         _instanceCache = new InstanceCache(null,this);
         _instanceCache.properties = {"styleName":this};
         filters = [new DropShadowFilter(DROP_SHADOW_SIZE,45,0,60,DROP_SHADOW_SIZE,DROP_SHADOW_SIZE)];
         dataTransform = new PolarTransform();
      }
      
      private static function initStyles() : Boolean
      {
         var i:int;
         var seriesStyle:CSSStyleDeclaration;
         var n:int;
         var pieFills:Array = null;
         HaloDefaults.init();
         seriesStyle = HaloDefaults.createSelector("PieSeries");
         pieFills = [];
         n = int(HaloDefaults.defaultFills.length);
         for(i = 0; i < n; i++)
         {
            pieFills[i] = HaloDefaults.defaultFills[i];
         }
         seriesStyle.defaultFactory = function():void
         {
            this.calloutGap = 10;
            this.calloutStroke = new Stroke(0,0,1);
            this.fills = pieFills;
            this.innerRadius = 0;
            this.insideLabelSizeLimit = 9;
            this.itemRenderer = new ClassFactory(WedgeItemRenderer);
            this.labelPosition = "none";
            this.legendMarkerRenderer = new ClassFactory(PieSeriesLegendMarker);
            this.shadowDepth = 4;
         };
         return true;
      }
      
      [Inspectable(category="General")]
      public function get field() : String
      {
         return _field;
      }
      
      override public function interpolate(interpolationValues:Array, interpolationData:Object) : void
      {
         var interpValue:Number = NaN;
         var src:PieSeriesItem = null;
         var delta:PieSeriesItem = null;
         var interp:PieSeriesItem = null;
         super.interpolate(interpolationValues,interpolationData);
         var len:int = int(interpolationValues.length);
         var srcCache:Array = interpolationData.interpolationSource;
         var deltaCache:Array = interpolationData.deltaCache;
         var interpolationCache:Array = interpolationData.cache;
         var iProps:Object = interpolationData.properties;
         len = int(interpolationCache.length);
         for(var i:int = 0; i < len; i++)
         {
            interpValue = Number(interpolationValues[i]);
            src = srcCache[i];
            delta = deltaCache[i];
            interp = interpolationCache[i];
            interp.origin.x = src.origin.x + delta.origin.x * interpValue;
            interp.origin.y = src.origin.y + delta.origin.y * interpValue;
         }
      }
      
      [Inspectable(environment="none")]
      protected function get itemType() : Class
      {
         return PieSeriesItem;
      }
      
      override public function localToData(v:Point) : Array
      {
         var dataTransform:PolarTransform = PolarTransform(dataTransform);
         var dx:Number = v.x - dataTransform.origin.x;
         var dy:Number = v.y - dataTransform.origin.y;
         var a:Number = calcAngle(dx,dy);
         var r:Number = Math.sqrt(dx * dx + dy * dy);
         return dataTransform.invertTransform(a,r);
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
            cacheDefaultValues(_field,_renderData.cache,"value");
         }
         super.updateData();
      }
      
      override public function describeData(dimension:String, requiredFields:uint) : Array
      {
         var description:DataDescription = null;
         validateData();
         if(dimension == PolarTransform.ANGULAR_AXIS)
         {
            description = new DataDescription();
            description.boundedValues = null;
            description.min = 0;
            description.max = 100;
            return [description];
         }
         return [];
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
      
      public function set startAngle(value:Number) : void
      {
         var twopi:Number = 2 * Math.PI;
         _startAngleRadians = value * Math.PI / 180 % twopi;
         if(value < 0)
         {
            _startAngleRadians += twopi;
         }
         invalidateTransform();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         _measuringField = IUITextField(createInFontContext(UITextField));
         _measuringField.visible = false;
         _measuringField.styleName = this;
         _measuringField.autoSize = TextFieldAutoSize.LEFT;
         addChild(DisplayObject(_measuringField));
      }
      
      private function auxRenderCalloutLabels(renderData:PieSeriesRenderData, labelData:Object, firstLabelIndex:Number) : void
      {
         var i:int = 0;
         var ld:PieSeriesItem = null;
         var label:IUITextField = null;
         var endRad:Number = NaN;
         var o:Point = null;
         var dataTransform:PolarTransform = PolarTransform(dataTransform);
         var rc:Rectangle = new Rectangle(0,0,unscaledWidth,unscaledHeight);
         var leftStack:Array = labelData.leftStack;
         var rightStack:Array = labelData.rightStack;
         var g:Graphics = _labelLayer.graphics;
         var labels:Array = _labelCache.instances;
         var inr:Number = _innerRadiusInPixelsScaledForExplode;
         var startRad:Number = inr + (_radiusInPixelsScaledForExplode - inr) * 0.8;
         var calloutStroke:IStroke = getStyle("calloutStroke");
         if(Boolean(calloutStroke))
         {
            GraphicsUtilities.setLineStyle(g,calloutStroke);
         }
         var calloutGap:Number = Number(getStyle("calloutGap"));
         var labelScale:Number = renderData.labelScale;
         var leftEdge:Number = _origin.x - _radiusInPixelsAfterLabels - calloutGap;
         for(i = 0; i < leftStack.length; i++)
         {
            ld = leftStack[i];
            if(ld.percentValue != 0)
            {
               o = ld.origin;
               label = ld.label = labels[firstLabelIndex++];
               label.x = ld.labelX;
               label.y = ld.labelY;
               label.text = ld.labelText;
               label.scaleX = label.scaleY = labelScale;
               endRad = ld.labelSin == 0 ? leftEdge : (label.y + label.height / 2 - o.y) / ld.labelSin;
               if(endRad >= startRad)
               {
                  if(o.y + ld.labelSin * endRad > rc.top)
                  {
                     g.moveTo(o.x + ld.labelCos * startRad,o.y + ld.labelSin * startRad);
                     if(o.x + ld.labelCos * endRad > leftEdge)
                     {
                        g.lineTo(o.x + ld.labelCos * endRad,o.y + ld.labelSin * endRad);
                     }
                     else
                     {
                        g.lineTo(o.x + ld.labelCos * _radiusInPixelsScaledForExplode,o.y + ld.labelSin * _radiusInPixelsScaledForExplode);
                     }
                     g.lineTo(leftEdge,o.y + ld.labelSin * endRad);
                  }
               }
               else if(endRad > _radiusInPixelsScaledForExplode * 0.2)
               {
                  if(o.y + ld.labelSin * endRad > rc.top)
                  {
                     g.moveTo(o.x + ld.labelCos * endRad,o.y + ld.labelSin * endRad);
                     g.lineTo(leftEdge,o.y + ld.labelSin * endRad);
                  }
               }
               else if(o.y + ld.labelSin * endRad > rc.top)
               {
                  g.moveTo(o.x + ld.labelCos * _radiusInPixelsScaledForExplode * 0.2,o.y + ld.labelSin * _radiusInPixelsScaledForExplode * 0.2);
                  g.lineTo(leftEdge,o.y + ld.labelSin * endRad);
               }
            }
         }
         var rightEdge:Number = _origin.x + _radiusInPixelsAfterLabels + calloutGap;
         for(i = 0; i < rightStack.length; i++)
         {
            ld = rightStack[i];
            if(ld.percentValue != 0)
            {
               o = ld.origin;
               label = ld.label = labels[firstLabelIndex++];
               label.x = ld.labelX;
               label.y = ld.labelY;
               label.text = ld.labelText;
               label.scaleX = label.scaleY = labelScale;
               endRad = (label.y + label.height / 2 - o.y) / ld.labelSin;
               if(endRad == Infinity || endRad == -Infinity || isNaN(endRad))
               {
                  if(o.y + ld.labelSin * endRad > rc.top)
                  {
                     g.moveTo(o.x + ld.labelCos * startRad,o.y + ld.labelSin * startRad);
                     g.lineTo(rightEdge,o.y + ld.labelSin * startRad);
                  }
               }
               else if(endRad >= startRad)
               {
                  if(o.y + ld.labelSin * endRad > rc.top)
                  {
                     g.moveTo(o.x + ld.labelCos * startRad,o.y + ld.labelSin * startRad);
                     if(o.x + ld.labelCos * endRad < rightEdge)
                     {
                        g.lineTo(o.x + ld.labelCos * endRad,o.y + ld.labelSin * endRad);
                     }
                     else
                     {
                        g.lineTo(o.x + ld.labelCos * _radiusInPixelsScaledForExplode,o.y + ld.labelSin * _radiusInPixelsScaledForExplode);
                     }
                     g.lineTo(rightEdge,o.y + ld.labelSin * endRad);
                  }
               }
               else if(endRad > _radiusInPixelsScaledForExplode * 0.2)
               {
                  if(o.y + ld.labelSin * endRad > rc.top)
                  {
                     g.moveTo(o.x + ld.labelCos * endRad,o.y + ld.labelSin * endRad);
                     g.lineTo(rightEdge,o.y + ld.labelSin * endRad);
                  }
               }
               else if(o.y + ld.labelSin * endRad > rc.top)
               {
                  g.moveTo(o.x + ld.labelCos * _radiusInPixelsScaledForExplode * 0.2,o.y + ld.labelSin * _radiusInPixelsScaledForExplode * 0.2);
                  g.lineTo(rightEdge,o.y + ld.labelSin * endRad);
               }
            }
         }
      }
      
      [Inspectable(category="General")]
      public function get nameField() : String
      {
         return _nameField;
      }
      
      private function measureInternalLabels(bCallout:Boolean, renderCache:Array) : Object
      {
         var i:int = 0;
         var ld:PieSeriesItem = null;
         var label:IUITextField = null;
         var wedgeExplodeRadiusInPixels:Number = NaN;
         var nextNeighbor:PieSeriesItem = null;
         var prevNeighbor:PieSeriesItem = null;
         var rscale:Number = NaN;
         var RXScale:Number = NaN;
         var RYScale:Number = NaN;
         var returnData:Object = null;
         var dataTransform:PolarTransform = PolarTransform(dataTransform);
         var len:int = int(renderCache.length);
         var rc:Rectangle = new Rectangle(0,0,unscaledWidth,unscaledHeight);
         var o:Point = dataTransform.origin;
         var removedLabels:Array = [];
         var visibleLabels:Array = [];
         var baseRadius:Number = _radiusInPixelsAfterLabels * _assignedRadiusRatio * (1 - _maxExplodeRadiusRatio) * 0.7;
         var labelData:Array = [];
         var baseAngle:Number = _startAngleRadians;
         var labelScale:Number = 1;
         for(i = 0; i < len; i++)
         {
            ld = renderCache[i];
            if(Boolean(_labelFunction))
            {
               _measuringField.text = ld.labelText = _labelFunction(renderCache[i].item,_field,i,renderCache[i].percentValue);
            }
            else if(Boolean(_labelField))
            {
               _measuringField.text = ld.labelText = renderCache[i].item[_labelField];
            }
            else
            {
               _measuringField.text = ld.labelText = renderCache[i].value.toString();
            }
            ld.labelAngle = (baseAngle + renderCache[i].angle / 2) % (2 * Math.PI);
            ld.labelCos = Math.cos(ld.labelAngle);
            ld.labelSin = -Math.sin(ld.labelAngle);
            ld.labelWidth = _measuringField.width;
            ld.labelHeight = _measuringField.height;
            wedgeExplodeRadiusInPixels = calculateExplodeRadiusForWedge(i);
            ld.labelX = ld.labelCos * (wedgeExplodeRadiusInPixels + baseRadius) + o.x - ld.labelWidth / 2;
            ld.labelY = ld.labelSin * (wedgeExplodeRadiusInPixels + baseRadius) + o.y - ld.labelHeight / 2;
            if(i > 0)
            {
               ld.prev = labelData[i - 1];
               ld.prev.next = ld;
            }
            labelData[i] = ld;
            baseAngle += renderCache[i].angle;
         }
         labelData[0].prev = labelData[len - 1];
         labelData[len - 1].next = labelData[0];
         var sortedLabels:Array = labelData.concat();
         sortedLabels.sortOn("angle",Array.NUMERIC);
         var insideLabelSizeLimit:Number = Number(getStyle("insideLabelSizeLimit"));
         i = 0;
         var labelFormat:TextFormat = determineTextFormatFromStyles();
         while(i < sortedLabels.length)
         {
            ld = sortedLabels[i];
            label = ld.label;
            nextNeighbor = ld.next;
            prevNeighbor = ld.prev;
            rscale = 1;
            RXScale = Math.abs(ld.labelX - nextNeighbor.labelX) / (ld.labelWidth / 2 + nextNeighbor.labelWidth / 2);
            RYScale = Math.abs(ld.labelY - nextNeighbor.labelY) / (ld.labelHeight / 2 + nextNeighbor.labelHeight / 2);
            if(RXScale < 1 && RYScale < 1)
            {
               rscale = Math.max(RXScale,RYScale);
            }
            RXScale = Math.abs(ld.labelX - prevNeighbor.labelX) / (ld.labelWidth / 2 + prevNeighbor.labelWidth / 2);
            RYScale = Math.abs(ld.labelY - prevNeighbor.labelY) / (ld.labelHeight / 2 + prevNeighbor.labelHeight / 2);
            if(RXScale < 1 && RYScale < 1)
            {
               rscale = Math.min(rscale,Math.max(RXScale,RYScale));
            }
            if(rscale * Number(labelFormat.size) < insideLabelSizeLimit)
            {
               ld.prev.next = ld.next;
               ld.next.prev = ld.prev;
               removedLabels.push(ld);
               sortedLabels.splice(i,1);
            }
            else
            {
               visibleLabels.push(ld);
               labelScale = Math.min(labelScale,rscale);
               i++;
            }
         }
         labelScale = Math.max(0.6,labelScale);
         _renderData.labelScale = labelScale;
         if(bCallout == false)
         {
            returnData = {
               "visibleLabels":visibleLabels,
               "renderCallouts":false
            };
         }
         else
         {
            returnData = {
               "visibleLabels":visibleLabels,
               "renderCallouts":true,
               "calloutLabelData":auxMeasureCalloutLabels(_renderData,removedLabels)
            };
         }
         return returnData;
      }
      
      override public function getElementBounds(renderData:Object) : void
      {
         var sample:PieSeriesItem = null;
         var rb:Array = [];
         var cache:Array = renderData.filteredCache;
         var sampleCount:int = int(cache.length);
         var minAngle:Number = Number.MAX_VALUE;
         var maxAngle:Number = Number.MIN_VALUE;
         for(var i:int = 0; i < sampleCount; i++)
         {
            sample = cache[i];
            rb.push(new Rectangle(sample.startAngle,sample.innerRadius,sample.angle,sample.outerRadius - sample.innerRadius));
            maxAngle = Math.max(maxAngle,sample.startAngle + sample.angle);
            minAngle = Math.min(minAngle,sample.startAngle);
         }
         sample = cache[sampleCount - 1];
         renderData.elementBounds = rb;
         renderData.bounds = new Rectangle(minAngle,_innerRadiusInPixelsScaledForExplode,maxAngle - minAngle,_radiusInPixelsScaledForExplode - _innerRadiusInPixelsScaledForExplode);
         renderData.visibleRegion = new Rectangle(minAngle,_innerRadiusInPixelsScaledForExplode,maxAngle - minAngle,_radiusInPixelsScaledForExplode - _innerRadiusInPixelsScaledForExplode);
      }
      
      public function set angularAxis(value:IAxis) : void
      {
         _angularAxis = value;
         _bAxesDirty = true;
         invalidateData();
      }
      
      private function renderInternalLabels(renderData:PieSeriesRenderData, renderCache:Array) : void
      {
         var i:int = 0;
         var ld:PieSeriesItem = null;
         var label:IUITextField = null;
         _labelCache.discard = true;
         _labelCache.count = 0;
         _labelCache.discard = false;
         var labelData:Object = renderData.labelData;
         if(!labelData)
         {
            return;
         }
         var visibleLabelSet:Array = labelData.visibleLabels;
         var len:int = int(visibleLabelSet.length);
         _labelCache.count = Boolean(labelData.renderCallouts) ? int(renderCache.length) : int(visibleLabelSet.length);
         var labels:Array = _labelCache.instances;
         var labelScale:Number = renderData.labelScale;
         for(i = 0; i < len; i++)
         {
            ld = visibleLabelSet[i];
            if(ld.percentValue != 0)
            {
               label = labels[i];
               ld.label = label;
               label.text = ld.labelText;
               label.scaleX = label.scaleY = labelScale;
               label.x = ld.labelX;
               label.y = ld.labelY;
            }
         }
         if(Boolean(labelData.renderCallouts))
         {
            auxRenderCalloutLabels(renderData,labelData.calloutLabelData,visibleLabelSet.length);
         }
      }
      
      override public function get legendData() : Array
      {
         var labelText:String = null;
         var legendData:PieSeriesLegendData = null;
         var current:PieSeriesItem = null;
         validateData();
         var keyItems:Array = [];
         var localFills:Array = getStyle("fills");
         var i:int = 0;
         var markerFactory:IFactory = getStyle("legendMarkerRenderer");
         if(!localFills)
         {
            localFills = [new SolidColor(0)];
         }
         var cache:Array = Boolean(_renderData.filteredCache) ? _renderData.filteredCache : _renderData.cache;
         var len:int = int(cache.length);
         for(i = 0; i < len; i++)
         {
            current = cache[i];
            legendData = new PieSeriesLegendData();
            legendData.fill = GraphicsUtilities.fillFromStyle(localFills[i % localFills.length]);
            if(_nameField != null && _nameField != "")
            {
               legendData.label = current.item[_nameField];
            }
            else
            {
               legendData.label = null;
            }
            legendData.element = this;
            if(Boolean(markerFactory))
            {
               legendData.marker = markerFactory.newInstance();
               if(legendData.marker is ISimpleStyleClient)
               {
                  (legendData.marker as ISimpleStyleClient).styleName = this;
               }
            }
            keyItems[i] = legendData;
         }
         return keyItems;
      }
      
      private function renderCalloutLabels(renderData:PieSeriesRenderData) : void
      {
         _labelCache.discard = true;
         _labelCache.count = 0;
         _labelCache.discard = false;
         var labelData:Object = renderData.labelData;
         if(!labelData)
         {
            return;
         }
         _labelCache.count = labelData.leftStack.length + labelData.rightStack.length;
         auxRenderCalloutLabels(renderData,renderData.labelData,0);
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable(category="General")]
      private function get _fillFunction() : Function
      {
         return this._1757871014_fillFunction;
      }
      
      private function defaultFillFunction(element:PieSeriesItem, i:Number) : IFill
      {
         _localFills = getStyle("fills");
         _fillCount = _localFills.length;
         return GraphicsUtilities.fillFromStyle(_localFills[i % _fillCount]);
      }
      
      public function set nameField(value:String) : void
      {
         _nameField = value;
         dataChanged();
         legendDataChanged();
      }
      
      override protected function get renderData() : Object
      {
         var renderDataType:Class = null;
         var td:PieSeriesRenderData = null;
         if(!_renderData)
         {
            renderDataType = this.renderDataType;
            td = new renderDataType();
            td.cache = td.filteredCache = [];
            return td;
         }
         return _renderData;
      }
      
      [Inspectable(category="General")]
      public function get labelField() : String
      {
         return _labelField;
      }
      
      private function auxMeasureCalloutLabels(renderData:PieSeriesRenderData, labelSet:Array) : Object
      {
         var i:int = 0;
         var ly:Number = NaN;
         var ld:PieSeriesItem = null;
         var lastTop:Number = NaN;
         var oldTextSize:Number = NaN;
         var dataTransform:PolarTransform = PolarTransform(dataTransform);
         var len:int = int(labelSet.length);
         var rc:Rectangle = new Rectangle(0,0,unscaledWidth,unscaledHeight);
         var baseRadius:Number = dataTransform.radius * _assignedRadiusRatio;
         var baseAngle:Number = _startAngleRadians;
         var leftStack:Array = [];
         var rightStack:Array = [];
         var leftHeight:Number = 0;
         var rightHeight:Number = 0;
         var labelScale:Number = renderData.labelScale;
         var calloutGap:Number = Number(getStyle("calloutGap"));
         for(i = 0; i < len; i++)
         {
            ld = labelSet[i];
            if((ld.labelAngle + Math.PI / 2) % (2 * Math.PI) < Math.PI)
            {
               if(ld.labelAngle > Math.PI)
               {
                  ld.labelAngle -= 2 * Math.PI;
               }
               ld.labelX = 0;
               baseRadius = Math.min(baseRadius,rc.right - ld.labelWidth - _origin.x - calloutGap);
               rightStack.push(ld);
               rightHeight += ld.labelHeight;
            }
            else
            {
               ld.labelX = -ld.labelWidth;
               baseRadius = Math.min(baseRadius,_origin.x - ld.labelWidth - calloutGap);
               leftStack.push(ld);
               leftHeight += ld.labelHeight;
            }
            ly = -ld.labelHeight / 2 + _origin.y + ld.labelSin * baseRadius * 1.1;
            if(ly < rc.top)
            {
               baseRadius = (rc.top + ld.labelHeight / 2 - _origin.y) / (ld.labelSin * 1.1);
            }
            if(ly > rc.bottom - ld.labelHeight)
            {
               baseRadius = (rc.bottom - ld.labelHeight + ld.labelHeight / 2 - _origin.y) / (ld.labelSin * 1.1);
            }
         }
         leftStack.sortOn("labelAngle",Array.NUMERIC);
         rightStack.sortOn("labelAngle",Array.NUMERIC | Array.DESCENDING);
         if(leftHeight > rc.height)
         {
            labelScale = Math.min(labelScale,rc.height / leftHeight);
         }
         if(rightHeight > rc.height)
         {
            labelScale = Math.min(labelScale,rc.height / rightHeight);
         }
         if(baseRadius < (1 - maxLabelRadius) * (dataTransform.radius * _assignedRadiusRatio))
         {
            oldTextSize = dataTransform.radius * _assignedRadiusRatio - baseRadius - calloutGap;
            baseRadius = (1 - maxLabelRadius) * (dataTransform.radius * _assignedRadiusRatio);
            labelScale = Math.min(labelScale,(dataTransform.radius * _assignedRadiusRatio - baseRadius - calloutGap) / oldTextSize);
         }
         _radiusInPixelsAfterLabels = baseRadius / _assignedRadiusRatio;
         var leftEdge:Number = _origin.x - baseRadius - calloutGap;
         var lastBottom:Number = 0;
         for(i = 0; i < leftStack.length; i++)
         {
            ld = leftStack[i];
            ld.labelX = leftEdge + ld.labelX * labelScale;
            ly = -ld.labelHeight / 2 + _origin.y + ld.labelSin * baseRadius * 1.1;
            if(ly < lastBottom)
            {
               ly = lastBottom;
            }
            ld.labelY = ly;
            lastBottom = ly + ld.labelHeight;
         }
         if(lastBottom > rc.bottom)
         {
            lastTop = rc.bottom;
            for(i = leftStack.length - 1; i >= 0; i--)
            {
               ld = leftStack[i];
               if(ld.labelY + ld.labelHeight <= lastTop)
               {
                  break;
               }
               ld.labelY = lastTop - ld.labelHeight;
               lastTop = ld.labelY;
            }
         }
         var rightEdge:Number = _origin.x + baseRadius + calloutGap;
         lastBottom = 0;
         for(i = 0; i < rightStack.length; i++)
         {
            ld = rightStack[i];
            ld.labelX = rightEdge;
            ly = -ld.labelHeight / 2 + _origin.y + ld.labelSin * baseRadius * 1.1;
            if(ly < lastBottom)
            {
               ly = lastBottom;
            }
            ld.labelY = ly;
            lastBottom = ly + ld.labelHeight;
         }
         if(lastBottom > rc.bottom)
         {
            lastTop = rc.bottom;
            for(i = rightStack.length - 1; i >= 0; i--)
            {
               ld = rightStack[i];
               if(ld.labelY + ld.labelHeight <= lastTop)
               {
                  break;
               }
               ld.labelY = lastTop - ld.labelHeight;
               lastTop = ld.labelY;
            }
         }
         renderData.labelScale = labelScale;
         return {
            "leftStack":leftStack,
            "rightStack":rightStack
         };
      }
      
      [Inspectable(category="General")]
      public function get reserveExplodeRadius() : Number
      {
         return _assignedReserveExplodeRadiusRatio;
      }
      
      public function get fillFunction() : Function
      {
         return _fillFunction;
      }
      
      private function calcAngle(x:Number, y:Number) : Number
      {
         var angle:Number = NaN;
         var twoMP:Number = Math.PI * 2;
         var at:Number = Math.atan(-y / x);
         if(x < 0)
         {
            angle = at + Math.PI;
         }
         else if(y < 0)
         {
            angle = at;
         }
         else
         {
            angle = at + twoMP;
         }
         return angle;
      }
      
      override public function beginInterpolation(sourceRenderData:Object, destRenderData:Object) : Object
      {
         var srcItem:PieSeriesItem = null;
         var dstItem:PieSeriesItem = null;
         var idata:Object = initializeInterpolationData(sourceRenderData.filteredCache,destRenderData.filteredCache,{
            "angle":true,
            "startAngle":true,
            "innerRadius":true,
            "outerRadius":true
         },itemType,{
            "lastInvalidSrcValue":0,
            "lastInvalidSrcIndex":NaN,
            "lastInvalidDestValue":0,
            "lastInvalidDestIndex":NaN
         });
         var origin:Point = PolarTransform(dataTransform).origin;
         var srcCache:Array = sourceRenderData.filteredCache;
         var dstCache:Array = destRenderData.filteredCache;
         var len:int = Math.max(srcCache.length,dstCache.length);
         var shortLen:int = Math.min(srcCache.length,dstCache.length);
         for(var i:int = 0; i < shortLen; i++)
         {
            dstItem = dstCache[i];
            srcItem = srcCache[i];
            idata.interpolationSource[i].origin = srcItem.origin;
            idata.deltaCache[i].origin = new Point(dstItem.origin.x - srcItem.origin.x,dstItem.origin.y - srcItem.origin.y);
            idata.cache[i].origin = srcItem.origin.clone();
         }
         if(shortLen < srcCache.length)
         {
            for(i = shortLen; i < len; i++)
            {
               srcItem = srcCache[i];
               idata.interpolationSource[i].origin = srcItem.origin;
               idata.deltaCache[i].origin = new Point(origin.x - srcItem.origin.x,origin.y - srcItem.origin.y);
               idata.cache[i].origin = srcItem.origin.clone();
            }
         }
         else
         {
            for(i = shortLen; i < len; i++)
            {
               dstItem = dstCache[i];
               idata.interpolationSource[i].origin = origin;
               idata.deltaCache[i].origin = new Point(dstItem.origin.x - origin.x,dstItem.origin.y - origin.y);
               idata.cache[i].origin = origin.clone();
            }
         }
         var interpolationRenderData:Object = destRenderData.clone();
         interpolationRenderData.cache = idata.cache;
         interpolationRenderData.filteredCache = idata.cache;
         transitionRenderData = interpolationRenderData;
         return idata;
      }
      
      [Inspectable(category="General",arrayType="Number")]
      public function get perWedgeExplodeRadius() : Array
      {
         return _perWedgeExplodeRadiusRatio.concat();
      }
      
      private function measureRadialLabels(renderCache:Array) : Object
      {
         var i:int = 0;
         var ld:PieSeriesItem = null;
         var label:IUITextField = null;
         var oldTextSize:Number = NaN;
         var dataTransform:PolarTransform = PolarTransform(dataTransform);
         var len:int = int(renderCache.length);
         var rc:Rectangle = new Rectangle(0,0,unscaledWidth,unscaledHeight);
         var o:Point = dataTransform.origin;
         var labels:Array = _labelCache.instances;
         var baseRadius:Number = dataTransform.radius * _assignedRadiusRatio;
         var labelData:Array = [];
         var baseAngle:Number = _startAngleRadians;
         var labelScale:Number = 1;
         for(i = 0; i < len; i++)
         {
            ld = renderCache[i];
            if(_labelFunction != null)
            {
               _measuringField.text = ld.labelText = _labelFunction(renderCache[i].item,_field,i,renderCache[i].percentValue);
            }
            else if(_labelField != null)
            {
               _measuringField.text = ld.labelText = renderCache[i].item[_labelField];
            }
            else
            {
               _measuringField.text = ld.labelText = renderCache[i].value.toString();
            }
            ld.labelAngle = (baseAngle + renderCache[i].angle / 2) % (2 * Math.PI);
            ld.labelCos = Math.cos(ld.labelAngle);
            ld.labelSin = -Math.sin(ld.labelAngle);
            if(ld.labelAngle < Math.PI)
            {
               ld.labelY = -_measuringField.height;
               baseRadius = Math.min(baseRadius,(o.y - _measuringField.height) / Math.abs(ld.labelSin));
            }
            else
            {
               ld.labelY = 0;
               baseRadius = Math.min(baseRadius,(rc.bottom - _measuringField.height - o.y) / Math.abs(ld.labelSin));
            }
            if((ld.labelAngle + Math.PI / 2) % (2 * Math.PI) < Math.PI)
            {
               ld.labelX = 0;
               baseRadius = Math.min(baseRadius,(rc.right - _measuringField.width - o.x) / Math.abs(ld.labelCos));
            }
            else
            {
               ld.labelX = -_measuringField.width;
               baseRadius = Math.min(baseRadius,(o.x - _measuringField.width) / Math.abs(ld.labelCos));
            }
            labelData[i] = ld;
            baseAngle += renderCache[i].angle;
         }
         if(baseRadius < (1 - maxLabelRadius) * (dataTransform.radius * _assignedRadiusRatio))
         {
            oldTextSize = dataTransform.radius * _assignedRadiusRatio - baseRadius;
            baseRadius = (1 - maxLabelRadius) * (dataTransform.radius * _assignedRadiusRatio);
            labelScale = (dataTransform.radius * _assignedRadiusRatio - baseRadius) / oldTextSize;
         }
         _radiusInPixelsAfterLabels = baseRadius / _assignedRadiusRatio;
         for(i = 0; i < len; i++)
         {
            ld = labelData[i];
            ld.labelX = ld.labelX * labelScale + o.x + ld.labelCos * baseRadius;
            ld.labelY = ld.labelY * labelScale + o.y + ld.labelSin * baseRadius;
         }
         _renderData.labelScale = labelScale;
         return null;
      }
      
      [Inspectable(category="General")]
      public function get startAngle() : Number
      {
         return _startAngleRadians * 180 / Math.PI;
      }
      
      override protected function getMissingInterpolationValues(sourceProps:Object, srcCache:Array, destProps:Object, destCache:Array, index:Number, customData:Object) : void
      {
         var propName:String = null;
         var src:Number = NaN;
         var dst:Number = NaN;
         var i:int = 0;
         for(propName in sourceProps)
         {
            src = Number(sourceProps[propName]);
            dst = Number(destProps[propName]);
            if(propName == "startAngle")
            {
               if(isNaN(src))
               {
                  if(customData.lastInvalidSrcIndex != index - 1)
                  {
                     if(index == 0)
                     {
                        for(i = 0; i < srcCache.length; i++)
                        {
                           if(srcCache[i] != null && !isNaN(srcCache[i].startAngle))
                           {
                              customData.lastInvalidSrcValue = srcCache[i].startAngle + srcCache[i].angle;
                              break;
                           }
                        }
                     }
                     else
                     {
                        for(i = index - 1; i >= 0; i--)
                        {
                           if(srcCache[i] != null && !isNaN(srcCache[i].startAngle))
                           {
                              customData.lastInvalidSrcValue = srcCache[i].startAngle + srcCache[i].angle;
                              break;
                           }
                        }
                     }
                  }
                  src = Number(customData.lastInvalidSrcValue);
                  customData.lastInvalidSrcIndex = index;
               }
               if(isNaN(dst))
               {
                  if(customData.lastInvalidDestIndex != index - 1)
                  {
                     if(index == 0)
                     {
                        for(i = 0; i < destCache.length; i++)
                        {
                           if(destCache[i] != null && !isNaN(destCache[i].startAngle))
                           {
                              customData.lastInvalidDestValue = destCache[i].startAngle + destCache[i].angle;
                              break;
                           }
                        }
                     }
                     else
                     {
                        for(i = index - 1; i >= 0; i--)
                        {
                           if(destCache[i] != null && !isNaN(destCache[i].startAngle))
                           {
                              customData.lastInvalidDestValue = destCache[i].startAngle + destCache[i].angle;
                              break;
                           }
                        }
                     }
                  }
                  dst = Number(customData.lastInvalidDestValue);
                  customData.lastInvalidDestIndex = index;
               }
            }
            else if(propName == "angle")
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
            else if(propName == "innerRadius")
            {
               if(isNaN(src))
               {
                  src = _innerRadiusInPixelsScaledForExplode;
               }
               if(isNaN(dst))
               {
                  dst = _innerRadiusInPixelsScaledForExplode;
               }
            }
            else if(propName == "outerRadius")
            {
               if(isNaN(src))
               {
                  src = _radiusInPixelsScaledForExplode;
               }
               if(isNaN(dst))
               {
                  dst = _radiusInPixelsScaledForExplode;
               }
            }
            else
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
      
      private function calculateExplodeRadiusForWedge(i:int) : Number
      {
         var pwer:Number = Boolean(_perWedgeExplodeRadiusRatio) && _perWedgeExplodeRadiusRatio[i] != null ? parseFloat(_perWedgeExplodeRadiusRatio[i]) : 0;
         if(isNaN(pwer))
         {
            pwer = 0;
         }
         return ((isNaN(_assignedExplodeRadiusRatio) ? 0 : _assignedExplodeRadiusRatio) + pwer) * _radiusInPixelsAfterLabels;
      }
      
      private function measureCalloutLabels(renderCache:Array) : Object
      {
         var v:PieSeriesItem = null;
         var len:int = int(renderCache.length);
         var baseAngle:Number = _startAngleRadians;
         for(var i:int = 0; i < len; i++)
         {
            v = renderCache[i];
            if(_labelFunction != null)
            {
               _measuringField.text = v.labelText = _labelFunction(v.item,_field,i,v.percentValue);
            }
            else if(_labelField != null)
            {
               _measuringField.text = v.labelText = v.item[_labelField];
            }
            else
            {
               _measuringField.text = v.labelText = v.value.toString();
            }
            v.labelAngle = (baseAngle + v.angle / 2) % (2 * Math.PI);
            v.labelCos = Math.cos(v.labelAngle);
            v.labelSin = -Math.sin(v.labelAngle);
            v.labelWidth = _measuringField.width;
            v.labelHeight = _measuringField.height;
            baseAngle += v.angle;
         }
         return auxMeasureCalloutLabels(_renderData,renderCache);
      }
      
      override protected function updateFilter() : void
      {
         if(filterData)
         {
            _renderData.filteredCache = _renderData.cache.concat();
            stripNaNs(_renderData.filteredCache,"number");
         }
         else
         {
            _renderData.filteredCache = _renderData.cache;
         }
         legendDataChanged();
         super.updateFilter();
      }
      
      [Inspectable(category="Data")]
      public function get angularAxis() : IAxis
      {
         return _angularAxis;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getInnerRadiusInPixels() : Number
      {
         return _innerRadiusInPixelsScaledForExplode;
      }
      
      public function set explodeRadius(value:Number) : void
      {
         _assignedExplodeRadiusRatio = Math.max(0,Math.min(value,1));
         invalidateData();
      }
      
      private function formatDataTip(hd:HitData) : String
      {
         var dt:String = "";
         var sliceName:String = "";
         if(_nameField != "")
         {
            sliceName = PieSeriesItem(hd.chartItem).item[_nameField];
         }
         if(sliceName != "")
         {
            dt += "<b>" + sliceName + ":</b> <b> " + Math.round(PieSeriesItem(hd.chartItem).percentValue * 10) / 10 + "%</b><BR/>";
         }
         else
         {
            dt += "<b>" + Math.round(PieSeriesItem(hd.chartItem).percentValue * 10) / 10 + "%</b><BR/>";
         }
         return dt + ("<i>(" + PieSeriesItem(hd.chartItem).value + ")</i>");
      }
      
      override protected function updateTransform() : void
      {
         var lastItem:PieSeriesItem = null;
         var thisItem:PieSeriesItem = null;
         var i:int = 0;
         var labelData:Object = null;
         var item:PieSeriesItem = null;
         var er:Number = NaN;
         var pwer:Number = NaN;
         var sa:Number = NaN;
         var wedgeExplodeRadius:Number = NaN;
         var wedgeAngle:Number = NaN;
         var angle:Number = NaN;
         var dataTransform:PolarTransform = PolarTransform(dataTransform);
         dataTransform.transformCache(_renderData.filteredCache,"percentValue","angle",null,null);
         var sampleCount:int = int(_renderData.filteredCache.length);
         if(Boolean(sampleCount))
         {
            lastItem = _renderData.filteredCache[0];
            lastItem.startAngle = _startAngleRadians;
            for(i = 1; i < sampleCount; i++)
            {
               thisItem = _renderData.filteredCache[i];
               thisItem.startAngle = lastItem.startAngle + lastItem.angle;
               lastItem = thisItem;
            }
         }
         var renderData:PieSeriesRenderData = _renderData;
         var assignRadiusToAllItems:Boolean = true;
         var assignOriginToAllItems:Boolean = true;
         if(!renderData || !renderData.filteredCache)
         {
            return;
         }
         var renderCache:Array = renderData.filteredCache;
         var len:int = int(renderCache.length);
         if(len == 0)
         {
            _labelCache.count = 0;
            return;
         }
         _origin = dataTransform.origin;
         _radiusInPixelsAfterLabels = dataTransform.radius - DROP_SHADOW_SIZE;
         if(Boolean(_perWedgeExplodeRadiusRatio) && _perWedgeExplodeRadiusRatio.length > 0)
         {
            er = _assignedExplodeRadiusRatio;
            if(isNaN(er))
            {
               er = 0;
            }
            _maxExplodeRadiusRatio = er;
            for(i = 0; i < len; i++)
            {
               pwer = _perWedgeExplodeRadiusRatio[i] != null ? parseFloat(_perWedgeExplodeRadiusRatio[i]) : 0;
               if(isNaN(pwer))
               {
                  pwer = 0;
               }
               _maxExplodeRadiusRatio = Math.max(_maxExplodeRadiusRatio,er + pwer);
            }
         }
         else if(!isNaN(_assignedExplodeRadiusRatio) && _assignedExplodeRadiusRatio != 0)
         {
            _maxExplodeRadiusRatio = _assignedExplodeRadiusRatio;
         }
         else
         {
            _maxExplodeRadiusRatio = 0;
         }
         _maxExplodeRadiusRatio = Math.max(_maxExplodeRadiusRatio,_assignedReserveExplodeRadiusRatio);
         _renderData.labelScale = 1;
         var labelPosition:String = getStyle("labelPosition");
         var r1:Point = new Point(0,0);
         var r2:Point = new Point(1,1);
         r1 = localToGlobal(r1);
         r2 = localToGlobal(r2);
         var actualScale:Number = r2.x - r1.x;
         if(getStyle("fontSize") * actualScale < 2)
         {
            labelPosition = "none";
         }
         if(getStyle("innerRadius") >= _assignedRadiusRatio)
         {
            _renderData.labelData = null;
            _labelCache.count = 0;
         }
         else if(labelPosition == "outside")
         {
            _renderData.labelData = measureRadialLabels(renderCache);
         }
         else if(labelPosition == "callout")
         {
            _renderData.labelData = measureCalloutLabels(renderCache);
         }
         else if(labelPosition == "inside")
         {
            _renderData.labelData = measureInternalLabels(false,renderCache);
         }
         else if(labelPosition == "insideWithCallout")
         {
            _renderData.labelData = measureInternalLabels(true,renderCache);
         }
         else
         {
            _renderData.labelData = null;
            _labelCache.count = 0;
         }
         var innerRadius:Number = Number(getStyle("innerRadius"));
         _innerRadiusInPixels = _radiusInPixelsAfterLabels * innerRadius;
         _radiusInPixelsAfterLabels *= _assignedRadiusRatio;
         _radiusInPixelsScaledForExplode = _radiusInPixelsAfterLabels * (1 - _maxExplodeRadiusRatio);
         _innerRadiusInPixelsScaledForExplode = _innerRadiusInPixels * (1 - _maxExplodeRadiusRatio);
         if(Boolean(_perWedgeExplodeRadiusRatio) && Boolean(_perWedgeExplodeRadiusRatio.length > 0) || _assignedExplodeRadiusRatio != 0)
         {
            assignOriginToAllItems = false;
            sa = startAngle;
            for(i = 0; i < len; i++)
            {
               wedgeExplodeRadius = calculateExplodeRadiusForWedge(i);
               item = renderCache[i];
               if(!isNaN(item.startAngle))
               {
                  sa = item.startAngle;
               }
               wedgeAngle = Number(renderCache[i].angle);
               angle = wedgeAngle / 2 + sa;
               item.origin = new Point(_origin.x + Math.cos(angle) * wedgeExplodeRadius,_origin.y + -Math.sin(angle) * wedgeExplodeRadius);
               sa += wedgeAngle;
            }
         }
         if(assignOriginToAllItems || assignRadiusToAllItems)
         {
            for(i = 0; i < sampleCount; i++)
            {
               item = renderCache[i];
               if(assignOriginToAllItems)
               {
                  item.origin = _origin;
               }
               if(assignRadiusToAllItems)
               {
                  item.innerRadius = _innerRadiusInPixelsScaledForExplode;
                  item.outerRadius = _radiusInPixelsScaledForExplode;
               }
            }
         }
         super.updateTransform();
      }
      
      override public function dataToLocal(... dataValues) : Point
      {
         var data:Object = {};
         var da:Array = [data];
         var len:int = int(dataValues.length);
         var dataTransform:PolarTransform = PolarTransform(dataTransform);
         if(len > 0)
         {
            data["d0"] = dataValues[0];
            dataTransform.getAxis(PolarTransform.ANGULAR_AXIS).mapCache(da,"d0","v0");
         }
         if(len > 1)
         {
            data["d1"] = dataValues[1];
            dataTransform.getAxis(PolarTransform.RADIAL_AXIS).mapCache(da,"d1","v1");
         }
         dataTransform.transformCache(da,"v0","s0","v1","s1");
         return new Point(dataTransform.origin.x + Math.cos(data.s0) * data.s1,dataTransform.origin.y - Math.sin(data.s0) * data.s1);
      }
      
      override public function getItemsInRegion(r:Rectangle) : Array
      {
         var v:PieSeriesItem = null;
         var angleAdjustment:Number = NaN;
         var startAngle:Number = NaN;
         var a:Number = NaN;
         var xpos:Number = NaN;
         var ypos:Number = NaN;
         if(interactive == false || !_renderData)
         {
            return [];
         }
         var arrItems:Array = [];
         var localRectangle:Rectangle = new Rectangle();
         var len:uint = _renderData.filteredCache.length;
         var inr:Number = _innerRadiusInPixelsScaledForExplode;
         localRectangle.topLeft = globalToLocal(r.topLeft);
         localRectangle.bottomRight = globalToLocal(r.bottomRight);
         for(var i:int = 0; i < len; i++)
         {
            v = _renderData.filteredCache[i];
            angleAdjustment = Number(_renderData.filteredCache[0].startAngle);
            startAngle = v.startAngle - angleAdjustment;
            a = startAngle + _startAngleRadians + v.angle / 2;
            xpos = v.origin.x + Math.cos(a) * (inr + (_radiusInPixelsScaledForExplode - inr) * 0.5);
            ypos = v.origin.y - Math.sin(a) * (inr + (_radiusInPixelsScaledForExplode - inr) * 0.5);
            if(localRectangle.contains(xpos,ypos))
            {
               arrItems.push(v);
            }
         }
         return arrItems;
      }
      
      private function renderRadialLabels(renderData:PieSeriesRenderData, renderCache:Array) : void
      {
         var i:int = 0;
         var ld:PieSeriesItem = null;
         var label:IUITextField = null;
         _labelCache.discard = true;
         _labelCache.count = 0;
         _labelCache.discard = false;
         var len:int = int(renderCache.length);
         _labelCache.count = len;
         var labels:Array = _labelCache.instances;
         var labelScale:Number = renderData.labelScale;
         for(i = 0; i < len; i++)
         {
            ld = renderCache[i];
            if(ld.percentValue != 0)
            {
               label = labels[i];
               ld.label = label;
               label.text = ld.labelText;
               label.scaleX = label.scaleY = labelScale;
               label.x = ld.labelX;
               label.y = ld.labelY;
            }
         }
      }
      
      [Inspectable(environment="none")]
      protected function get renderDataType() : Class
      {
         return PieSeriesRenderData;
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
      
      override public function get items() : Array
      {
         return Boolean(_renderData) ? _renderData.filteredCache : null;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         if(styleProp == null || styleProp == "" || styleProp == "fills")
         {
            invalidateDisplayList();
            legendDataChanged();
         }
         if(styleProp == "labelPosition")
         {
            invalidateTransform();
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
         var i:int = 0;
         var v:Number = NaN;
         dataTransform.getAxis(PolarTransform.ANGULAR_AXIS).mapCache(_renderData.cache,"value","number");
         var total:Number = 0;
         var len:int = int(_renderData.cache.length);
         for(i = 0; i < len; i++)
         {
            v = Number(_renderData.cache[i].number);
            if(!isNaN(v))
            {
               total += _renderData.cache[i].number;
            }
         }
         _renderData.itemSum = total;
         total /= 100;
         if(total == 0)
         {
            total = 1;
         }
         for(i = 0; i < len; i++)
         {
            _renderData.cache[i].percentValue = _renderData.cache[i].number / total;
         }
         super.updateMapping();
      }
      
      override public function findDataPoints(x:Number, y:Number, sensitivity:Number) : Array
      {
         var hitItem:PieSeriesItem = null;
         var startAngle:Number = NaN;
         var v:PieSeriesItem = null;
         var dst2:Number = NaN;
         var s2:Number = NaN;
         var a:Number = NaN;
         var xpos:Number = NaN;
         var ypos:Number = NaN;
         var hd:HitData = null;
         var fills:Array = null;
         var fill:Object = null;
         if(interactive == false || !_renderData)
         {
            return [];
         }
         var dataTransform:PolarTransform = PolarTransform(dataTransform);
         var len:int = int(_renderData.filteredCache.length);
         var o:Point = dataTransform.origin;
         var msPt:Point = new Point(x,y);
         var innerRadius:Number = Number(getStyle("innerRadius"));
         var inr:Number = _innerRadiusInPixelsScaledForExplode;
         var mp2:Number = Math.PI * 2;
         if(len == 0)
         {
            return [];
         }
         var angle:Number = calcAngle(msPt.x - _origin.x,msPt.y - _origin.y);
         var angleAdjustment:Number = Number(_renderData.filteredCache[0].startAngle);
         angle -= angleAdjustment;
         if(angle < 0)
         {
            angle += mp2;
         }
         for(var i:int = 0; i < _renderData.filteredCache.length; i++)
         {
            v = _renderData.filteredCache[i];
            angle = calcAngle(msPt.x - v.origin.x,msPt.y - v.origin.y);
            angle -= angleAdjustment;
            if(angle < 0)
            {
               angle += mp2;
            }
            startAngle = v.startAngle - angleAdjustment;
            if(angle >= startAngle && angle < startAngle + v.angle)
            {
               hitItem = v;
               break;
            }
         }
         if(Boolean(hitItem))
         {
            dst2 = (x - hitItem.origin.x) * (x - hitItem.origin.x) + (y - hitItem.origin.y) * (y - hitItem.origin.y);
            s2 = sensitivity * sensitivity;
            if(dst2 < inr * inr - s2 || dst2 > _radiusInPixelsScaledForExplode * _radiusInPixelsScaledForExplode + s2)
            {
               return [];
            }
            a = startAngle + _startAngleRadians + hitItem.angle / 2;
            xpos = hitItem.origin.x + Math.cos(a) * (inr + (_radiusInPixelsScaledForExplode - inr) * 0.5);
            ypos = hitItem.origin.y - Math.sin(a) * (inr + (_radiusInPixelsScaledForExplode - inr) * 0.5);
            hd = new HitData(createDataID(hitItem.index),0,xpos,ypos,hitItem);
            hd.dataTipFunction = formatDataTip;
            fills = getStyle("fills");
            if(Boolean(fills))
            {
               fill = PieSeriesItem(hd.chartItem).fill;
               hd.contextColor = GraphicsUtilities.colorFromFill(fill);
            }
            return [hd];
         }
         return [];
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(!_labelCache.factory)
         {
            _labelCache.factory = new ContextualClassFactory(UITextField,moduleFactory);
         }
         if(Boolean(dataTransform))
         {
            if(Boolean(_angularAxis))
            {
               dataTransform.setAxis(PolarTransform.ANGULAR_AXIS,_angularAxis);
            }
         }
         var c:PolarChart = PolarChart(chart);
         if(Boolean(c))
         {
            if(!_angularAxis && dataTransform.axes[PolarTransform.ANGULAR_AXIS] != c.angularAxis)
            {
               PolarTransform(dataTransform).setAxis(PolarTransform.ANGULAR_AXIS,c.angularAxis);
            }
         }
         dataTransform.elements = [this];
      }
      
      public function set labelField(value:String) : void
      {
         _labelField = value;
         invalidateTransform();
      }
      
      [Inspectable(category="General")]
      public function get explodeRadius() : Number
      {
         return _assignedExplodeRadiusRatio;
      }
      
      public function set labelFunction(value:Function) : void
      {
         _labelFunction = value;
         invalidateDisplayList();
      }
      
      public function set outerRadius(value:Number) : void
      {
         _assignedRadiusRatio = value;
         invalidateDisplayList();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getRadiusInPixels() : Number
      {
         return _radiusInPixelsScaledForExplode;
      }
      
      [Inspectable(category="General")]
      public function get labelFunction() : Function
      {
         return _labelFunction;
      }
      
      public function set reserveExplodeRadius(value:Number) : void
      {
         _assignedReserveExplodeRadiusRatio = Math.max(0,Math.min(value,1));
         invalidateData();
      }
      
      override public function get labelContainer() : Sprite
      {
         return _labelLayer;
      }
      
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
         var item:PieSeriesItem = null;
         var inst:IFlexDisplayObject = null;
         var instances:Array = null;
         var twoP:Number = NaN;
         var boundsArray:Array = null;
         var visibleBoundsStart:Number = NaN;
         var visibleBoundsEnd:Number = NaN;
         var dataItem:PieSeriesItem = null;
         var dataItemBounds:Rectangle = null;
         var tmpStartAngle:Number = NaN;
         var tmpA:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var dataTransform:PolarTransform = PolarTransform(dataTransform);
         var g:Graphics = graphics;
         g.clear();
         _labelLayer.graphics.clear();
         if(!dataProvider)
         {
            _labelCache.count = 0;
            return;
         }
         var renderData:PieSeriesRenderData = Boolean(transitionRenderData) ? PieSeriesRenderData(transitionRenderData) : _renderData;
         if(!renderData || !renderData.filteredCache)
         {
            return;
         }
         var renderCache:Array = renderData.filteredCache;
         var len:int = int(renderCache.length);
         if(renderData == transitionRenderData && Boolean(transitionRenderData.elementBounds))
         {
            twoP = Math.PI * 2;
            boundsArray = transitionRenderData.elementBounds;
            len = int(renderCache.length);
            visibleBoundsStart = Number(transitionRenderData.visibleRegion.left);
            visibleBoundsEnd = Number(transitionRenderData.visibleRegion.right);
            for(i = 0; i < len; i++)
            {
               dataItem = renderCache[i];
               dataItemBounds = boundsArray[i];
               tmpStartAngle = dataItemBounds.left;
               tmpA = dataItemBounds.width;
               if(tmpStartAngle < visibleBoundsStart)
               {
                  tmpA = Math.max(0,tmpA + tmpStartAngle - visibleBoundsStart);
                  tmpStartAngle = visibleBoundsStart;
               }
               else if(tmpStartAngle + tmpA > visibleBoundsEnd)
               {
                  tmpStartAngle = Math.min(visibleBoundsEnd,tmpStartAngle);
                  tmpA = Math.max(0,visibleBoundsEnd - tmpStartAngle);
               }
               dataItem.startAngle = tmpStartAngle;
               dataItem.angle = tmpA;
               dataItem.innerRadius = dataItemBounds.top;
               dataItem.outerRadius = dataItemBounds.bottom;
            }
         }
         if(renderData.itemSum == 0)
         {
            _labelCache.count = 0;
            _instanceCache.count = 0;
            if(Boolean(chart) && (chart.showAllDataTips || chart.dataTipItemsSet))
            {
               chart.updateAllDataTips();
            }
            return;
         }
         var labelPosition:String = getStyle("labelPosition");
         if(getStyle("innerRadius") >= _assignedRadiusRatio || renderData == transitionRenderData || len == 0)
         {
            _labelCache.count = 0;
         }
         else if(labelPosition == "outside")
         {
            renderRadialLabels(renderData,renderCache);
         }
         else if(labelPosition == "inside" || labelPosition == "insideWithCallout")
         {
            renderInternalLabels(renderData,renderCache);
         }
         else if(labelPosition == "callout")
         {
            renderCalloutLabels(renderData);
         }
         else
         {
            _labelCache.count = 0;
         }
         var fills:Array = getStyle("fills");
         var fillCount:int = int(fills.length);
         _instanceCache.factory = getStyle("itemRenderer");
         _instanceCache.count = len;
         instances = _instanceCache.instances;
         for(i = 0; i < len; i++)
         {
            item = renderCache[i];
            inst = instances[i];
            item.fill = fillFunction(item,i);
            if(!item.fill)
            {
               item.fill = defaultFillFunction(item,i);
            }
            inst.setActualSize(unscaledWidth,unscaledHeight);
            item.itemRenderer = inst;
            (inst as IDataRenderer).data = item;
            if((item.itemRenderer as Object).hasOwnProperty("invalidateDisplayList"))
            {
               (item.itemRenderer as Object).invalidateDisplayList();
            }
         }
         if(allSeriesTransform && Boolean(chart))
         {
            chart.updateAllDataTips();
         }
      }
      
      public function set perWedgeExplodeRadius(value:Array) : void
      {
         _perWedgeExplodeRadiusRatio = value.concat();
         var len:int = int(_perWedgeExplodeRadiusRatio.length);
         for(var i:int = 0; i < len; i++)
         {
            _perWedgeExplodeRadiusRatio[i] = _perWedgeExplodeRadiusRatio[i] is Number ? Math.max(0,Math.min(_perWedgeExplodeRadiusRatio[i],1)) : undefined;
         }
         invalidateData();
      }
      
      public function set field(value:String) : void
      {
         _field = value;
         dataChanged();
      }
      
      [Inspectable(category="General")]
      public function get outerRadius() : Number
      {
         return _assignedRadiusRatio;
      }
      
      override public function getAllDataPoints() : Array
      {
         var i:uint = 0;
         var startAngle:Number = NaN;
         var v:PieSeriesItem = null;
         var itemExists:Boolean = false;
         var j:int = 0;
         var a:Number = NaN;
         var xpos:Number = NaN;
         var ypos:Number = NaN;
         var hd:HitData = null;
         var fills:Array = null;
         var fill:Object = null;
         if(!_renderData)
         {
            return [];
         }
         if(!_renderData.filteredCache)
         {
            return [];
         }
         if(_renderData.filteredCache.length == 0)
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
         var inr:Number = _innerRadiusInPixelsScaledForExplode;
         var angleAdjustment:Number = Number(_renderData.filteredCache[0].startAngle);
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
               startAngle = v.startAngle - angleAdjustment;
               a = startAngle + _startAngleRadians + v.angle / 2;
               xpos = v.origin.x + Math.cos(a) * (inr + (_radiusInPixelsScaledForExplode - inr) * 0.5);
               ypos = v.origin.y - Math.sin(a) * (inr + (_radiusInPixelsScaledForExplode - inr) * 0.5);
               hd = new HitData(createDataID(v.index),0,xpos,ypos,v);
               hd.dataTipFunction = formatDataTip;
               fills = getStyle("fills");
               if(Boolean(fills))
               {
                  fill = PieSeriesItem(hd.chartItem).fill;
                  hd.contextColor = GraphicsUtilities.colorFromFill(fill);
               }
               result.push(hd);
            }
         }
         return result;
      }
   }
}

import flash.display.Graphics;
import flash.geom.Rectangle;
import mx.charts.chartClasses.LegendData;
import mx.core.IDataRenderer;
import mx.graphics.IFill;
import mx.graphics.IStroke;
import mx.skins.ProgrammaticSkin;

class PieSeriesLegendMarker extends ProgrammaticSkin implements IDataRenderer
{
   
   private var _legendData:Object;
   
   public function PieSeriesLegendMarker()
   {
      super();
   }
   
   [Inspectable(category="General")]
   public function get data() : Object
   {
      return _legendData;
   }
   
   public function set data(value:Object) : void
   {
      _legendData = value;
      invalidateDisplayList();
   }
   
   override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
   {
      var fill:IFill = null;
      super.updateDisplayList(unscaledWidth,unscaledHeight);
      var stroke:IStroke = getStyle("stroke");
      if(_legendData != null && "fill" in _legendData)
      {
         fill = _legendData.fill;
      }
      else
      {
         fill = getStyle("fill");
      }
      var g:Graphics = graphics;
      g.clear();
      g.moveTo(0,0);
      if(Boolean(stroke))
      {
         stroke.apply(g);
      }
      else
      {
         g.lineStyle(0,0,0);
      }
      if(Boolean(fill))
      {
         fill.begin(g,new Rectangle(0,0,width,height));
      }
      g.lineTo(width,0);
      g.lineTo(width,height);
      g.lineTo(0,height);
      g.lineTo(0,0);
      if(Boolean(fill))
      {
         fill.end(g);
      }
   }
}

class PieSeriesLegendData extends LegendData
{
   
   public var fill:IFill;
   
   public function PieSeriesLegendData()
   {
      super();
   }
}
