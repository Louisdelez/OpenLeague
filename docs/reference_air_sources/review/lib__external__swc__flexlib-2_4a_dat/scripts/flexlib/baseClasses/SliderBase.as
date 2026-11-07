package flexlib.baseClasses
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.system.ApplicationDomain;
   import flexlib.controls.sliderClasses.SliderThumb;
   import mx.controls.sliderClasses.SliderDataTip;
   import mx.controls.sliderClasses.SliderDirection;
   import mx.controls.sliderClasses.SliderLabel;
   import mx.core.IFlexDisplayObject;
   import mx.core.UIComponent;
   import mx.effects.Tween;
   import mx.events.FlexEvent;
   import mx.events.SliderEvent;
   import mx.events.SliderEventClickTarget;
   import mx.formatters.NumberBase;
   import mx.resources.ResourceBundle;
   import mx.styles.ISimpleStyleClient;
   
   [Style(name="trackSkin",type="Class",inherit="no")]
   [Style(name="trackHighlightSkin",type="Class",inherit="no")]
   [Style(name="thumbDisabledSkin",type="Class",inherit="no")]
   [Style(name="thumbDownSkin",type="Class",inherit="no")]
   [Style(name="thumbOverSkin",type="Class",inherit="no")]
   [Style(name="thumbUpSkin",type="Class",inherit="no")]
   [Style(name="dataTipPrecision",type="int",inherit="no")]
   [Style(name="dataTipOffset",type="Number",format="Length",inherit="no")]
   [Style(name="dataTipStyleName",type="String",inherit="no")]
   [Style(name="trackMargin",type="Number",format="Length",inherit="no")]
   [Style(name="showTrackHighlight",type="Boolean",inherit="no")]
   [Style(name="trackColors",type="Array",arrayType="uint",format="Color",inherit="no")]
   [Style(name="tickThickness",type="Number",format="Length",inherit="no")]
   [Style(name="tickOffset",type="Number",format="Length",inherit="no")]
   [Style(name="tickLength",type="Number",format="Length",inherit="no")]
   [Style(name="tickColor",type="uint",format="Color",inherit="no")]
   [Style(name="thumbOffset",type="Number",format="Length",inherit="no")]
   [Style(name="slideEasingFunction",type="Function",inherit="no")]
   [Style(name="slideDuration",type="Number",format="Time",inherit="no")]
   [Style(name="labelStyleName",type="String",inherit="no")]
   [Style(name="labelOffset",type="Number",format="Length",inherit="no")]
   [Style(name="invertThumbDirection",type="Boolean",inherit="no")]
   [Style(name="fillColors",type="Array",arrayType="uint",format="Color",inherit="no")]
   [Style(name="borderColor",type="uint",format="Color",inherit="no")]
   [Event(name="thumbRelease",type="mx.events.SliderEvent")]
   [Event(name="thumbPress",type="mx.events.SliderEvent")]
   [Event(name="thumbDrag",type="mx.events.SliderEvent")]
   [Event(name="change",type="mx.events.SliderEvent")]
   public class SliderBase extends UIComponent
   {
      
      private static var resourceDecimalSeparatorTo:String;
      
      private static var resourceThousandsSeparatorFrom:String;
      
      private static var resourceDecimalSeparatorFrom:String;
      
      [ResourceBundle("SharedResources")]
      private static var sharedResources:ResourceBundle = ResourceBundle.getResourceBundle("SharedResources",ApplicationDomain.currentDomain);
      
      loadResources();
      
      private var enabledChanged:Boolean = false;
      
      protected var dataFormatter:NumberBase;
      
      protected var dataTip:SliderDataTip;
      
      private var _snapInterval:Number = 0;
      
      private var labelStyleChanged:Boolean = false;
      
      protected var _dataTipFormatFunction:Function;
      
      protected var highlightTrack:IFlexDisplayObject;
      
      private var snapIntervalChanged:Boolean = false;
      
      private var _maximum:Number = 10;
      
      private var _labels:Array = [];
      
      protected var thumbs:UIComponent;
      
      private var minimumSet:Boolean = false;
      
      protected var track:IFlexDisplayObject;
      
      private var _sliderDataTipClass:Class = SliderDataTip;
      
      private var tabIndexChanged:Boolean;
      
      private var labelsChanged:Boolean = false;
      
      protected var _direction:String = SliderDirection.HORIZONTAL;
      
      private var _enabled:Boolean;
      
      private var directionChanged:Boolean = false;
      
      private var _values:Array = [0,0];
      
      private var initValues:Boolean = true;
      
      [Inspectable(category="General",defaultValue="false")]
      public var liveDragging:Boolean = false;
      
      private var _thumbCount:int = 1;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var keyInteraction:Boolean = false;
      
      private var thumbsChanged:Boolean = true;
      
      private var ticks:UIComponent;
      
      private var _tickValues:Array = [];
      
      private var snapIntervalPrecision:int = -1;
      
      private var _minimum:Number = 0;
      
      protected var trackHighlightChanged:Boolean = true;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var innerSlider:UIComponent;
      
      protected var _thumbClass:Class = SliderThumb;
      
      [Inspectable(category="General",defaultValue="true")]
      public var showDataTip:Boolean = true;
      
      private var trackHitArea:UIComponent;
      
      [Inspectable(defaultValue="true")]
      public var allowTrackClick:Boolean = true;
      
      private var valuesChanged:Boolean = false;
      
      private var ticksChanged:Boolean = false;
      
      private var _tickInterval:Number = 0;
      
      protected var labelObjects:UIComponent;
      
      [Inspectable(defaultValue="false")]
      public var allowThumbOverlap:Boolean = false;
      
      private var _tabIndex:Number;
      
      protected var interactionClickTarget:String;
      
      public function SliderBase()
      {
         super();
         tabChildren = true;
      }
      
      private static function loadResources() : void
      {
         resourceDecimalSeparatorFrom = sharedResources.getString("decimalSeparatorFrom");
         resourceThousandsSeparatorFrom = sharedResources.getString("thousandsSeparatorFrom");
         resourceDecimalSeparatorTo = sharedResources.getString("decimalSeparatorTo");
      }
      
      public function set labels(value:Array) : void
      {
         _labels = value;
         labelsChanged = true;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      private function getComponentBounds() : Object
      {
         var isHorizontal:Boolean = false;
         var numLabels:int = 0;
         var labelY:Number = NaN;
         var labelSize:Number = NaN;
         var thumbY:Number = NaN;
         var upperBound:Number = NaN;
         var lowerBound:Number = NaN;
         var sliderLabel:SliderLabel = null;
         var labOffset:Number = NaN;
         var i:int = 0;
         var tLen:Number = NaN;
         var tOff:Number = NaN;
         isHorizontal = direction == SliderDirection.HORIZONTAL;
         numLabels = Boolean(labelObjects) ? int(labelObjects.numChildren) : 0;
         labelSize = 0;
         upperBound = 0;
         lowerBound = Number(track.height);
         if(numLabels > 0)
         {
            sliderLabel = SliderLabel(labelObjects.getChildAt(0));
            if(isHorizontal)
            {
               labelSize = Number(sliderLabel.getExplicitOrMeasuredHeight());
            }
            else
            {
               for(i = 0; i < numLabels; i++)
               {
                  sliderLabel = SliderLabel(labelObjects.getChildAt(i));
                  labelSize = Math.max(labelSize,sliderLabel.getExplicitOrMeasuredWidth());
               }
            }
            labOffset = Number(getStyle("labelOffset"));
            labelY = labOffset - (labOffset > 0 ? 0 : labelSize);
            upperBound = Math.min(upperBound,labelY);
            lowerBound = Math.max(lowerBound,labOffset + (labOffset > 0 ? labelSize : 0));
         }
         if(Boolean(ticks))
         {
            tLen = Number(getStyle("tickLength"));
            tOff = Number(getStyle("tickOffset"));
            upperBound = Math.min(upperBound,tOff - tLen);
            lowerBound = Math.max(lowerBound,tOff);
         }
         if(thumbs.numChildren > 0)
         {
            thumbY = (track.height - SliderThumb(thumbs.getChildAt(0)).getExplicitOrMeasuredHeight()) / 2 + getStyle("thumbOffset");
            upperBound = Math.min(upperBound,thumbY);
            lowerBound = Math.max(lowerBound,thumbY + SliderThumb(thumbs.getChildAt(0)).getExplicitOrMeasuredHeight());
         }
         return {
            "lower":lowerBound,
            "upper":upperBound
         };
      }
      
      [Inspectable(category="General",defaultValue="0")]
      public function get minimum() : Number
      {
         return _minimum;
      }
      
      private function createLabels() : void
      {
         var labelObj:SliderLabel = null;
         var i:int = 0;
         var numLabels:int = 0;
         var j:int = 0;
         var labelStyleName:String = null;
         if(Boolean(labelObjects))
         {
            for(i = labelObjects.numChildren - 1; i >= 0; i--)
            {
               labelObjects.removeChildAt(i);
            }
         }
         else
         {
            labelObjects = new UIComponent();
            innerSlider.addChildAt(labelObjects,innerSlider.getChildIndex(trackHitArea));
         }
         if(Boolean(_labels))
         {
            numLabels = int(_labels.length);
            for(j = 0; j < numLabels; j++)
            {
               labelObj = new SliderLabel();
               labelObj.text = _labels[j] is String ? _labels[j] : _labels[j].toString();
               if(_direction != SliderDirection.HORIZONTAL)
               {
                  labelObj.rotation = 90;
               }
               labelStyleName = getStyle("labelStyleName");
               if(Boolean(labelStyleName))
               {
                  labelObj.styleName = labelStyleName;
               }
               labelObjects.addChild(labelObj);
            }
         }
      }
      
      public function set minimum(value:Number) : void
      {
         _minimum = value;
         ticksChanged = true;
         if(!initValues)
         {
            valuesChanged = true;
         }
         invalidateProperties();
         invalidateDisplayList();
      }
      
      private function createBackgroundTrack() : void
      {
         var trackSkinClass:Class = null;
         if(!track)
         {
            trackSkinClass = getStyle("trackSkin");
            track = new trackSkinClass();
            if(track is ISimpleStyleClient)
            {
               ISimpleStyleClient(track).styleName = this;
            }
            innerSlider.addChildAt(DisplayObject(track),0);
         }
      }
      
      public function set maximum(value:Number) : void
      {
         _maximum = value;
         ticksChanged = true;
         if(!initValues)
         {
            valuesChanged = true;
         }
         invalidateProperties();
         invalidateDisplayList();
      }
      
      public function setThumbValueAt(index:int, value:Number) : void
      {
         setValueAt(value,index);
         valuesChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      override public function set tabIndex(value:int) : void
      {
         super.tabIndex = value;
         _tabIndex = value;
         tabIndexChanged = true;
         invalidateProperties();
      }
      
      public function getThumbAt(index:int) : SliderThumb
      {
         return index >= 0 && index < thumbs.numChildren ? SliderThumb(thumbs.getChildAt(index)) : null;
      }
      
      [Inspectable(category="General",defaultValue="1")]
      public function get thumbCount() : int
      {
         return _thumbCount;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getSnapValue(value:Number, thumb:SliderThumb = null) : Number
      {
         var val:Number = NaN;
         var check_bounds:Boolean = false;
         var bounds:Object = null;
         var prevThumb:SliderThumb = null;
         var nextThumb:SliderThumb = null;
         if(!isNaN(_snapInterval) && _snapInterval != 0)
         {
            val = getValueFromX(value);
            if(Boolean(thumb) && Boolean(thumbs.numChildren > 1) && !allowThumbOverlap)
            {
               check_bounds = true;
               bounds = getXBounds(thumb.thumbIndex);
               prevThumb = thumb.thumbIndex > 0 ? SliderThumb(thumbs.getChildAt(thumb.thumbIndex - 1)) : null;
               nextThumb = thumb.thumbIndex + 1 < thumbs.numChildren ? SliderThumb(thumbs.getChildAt(thumb.thumbIndex + 1)) : null;
               if(Boolean(prevThumb))
               {
                  bounds.min -= prevThumb.width / 2;
                  if(val == minimum)
                  {
                     if(getValueFromX(prevThumb.xPosition - prevThumb.width / 2) != minimum)
                     {
                        check_bounds = false;
                     }
                  }
               }
               else if(val == minimum)
               {
                  check_bounds = false;
               }
               if(Boolean(nextThumb))
               {
                  bounds.max += nextThumb.width / 2;
                  if(val == maximum)
                  {
                     if(getValueFromX(nextThumb.xPosition + nextThumb.width / 2) != maximum)
                     {
                        check_bounds = false;
                     }
                  }
               }
               else if(val == maximum)
               {
                  check_bounds = false;
               }
               if(check_bounds)
               {
                  val = Math.min(Math.max(val,getValueFromX(Math.round(bounds.min)) + _snapInterval),getValueFromX(Math.round(bounds.max)) - _snapInterval);
               }
            }
            return getXFromValue(val);
         }
         return value;
      }
      
      public function get sliderThumbClass() : Class
      {
         return _thumbClass;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getXBounds(selectedThumbIndex:int) : Object
      {
         var maxX:Number = NaN;
         var minX:Number = NaN;
         var minBound:Number = NaN;
         var maxBound:Number = NaN;
         var prevThumb:SliderThumb = null;
         var nextThumb:SliderThumb = null;
         maxX = track.x + track.width;
         minX = Number(track.x);
         if(allowThumbOverlap)
         {
            return {
               "max":maxX,
               "min":minX
            };
         }
         minBound = NaN;
         maxBound = NaN;
         prevThumb = selectedThumbIndex > 0 ? SliderThumb(thumbs.getChildAt(selectedThumbIndex - 1)) : null;
         nextThumb = selectedThumbIndex + 1 < thumbs.numChildren ? SliderThumb(thumbs.getChildAt(selectedThumbIndex + 1)) : null;
         if(Boolean(prevThumb))
         {
            minBound = prevThumb.xPosition + prevThumb.width / 2;
         }
         if(Boolean(nextThumb))
         {
            maxBound = nextThumb.xPosition - nextThumb.width / 2;
         }
         if(isNaN(minBound))
         {
            minBound = minX;
         }
         else
         {
            minBound = Math.min(Math.max(minX,minBound),maxX);
         }
         if(isNaN(maxBound))
         {
            maxBound = maxX;
         }
         else
         {
            maxBound = Math.max(Math.min(maxX,maxBound),minX);
         }
         return {
            "max":maxBound,
            "min":minBound
         };
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function onThumbRelease(thumb:Object) : void
      {
         var event:SliderEvent = null;
         interactionClickTarget = SliderEventClickTarget.THUMB;
         destroyDataTip();
         setValueFromPos(thumb.thumbIndex);
         event = new SliderEvent(SliderEvent.THUMB_RELEASE);
         event.thumbIndex = thumb.thumbIndex;
         dispatchEvent(event);
      }
      
      [Inspectable(category="General",defaultValue="undefined",arrayType="Number")]
      public function get tickValues() : Array
      {
         return _tickValues;
      }
      
      [Inspectable(category="General",arrayType="Number")]
      [Bindable("change")]
      public function get values() : Array
      {
         return _values;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function unRegisterMouseMove(listener:Function) : void
      {
         innerSlider.removeEventListener(MouseEvent.MOUSE_MOVE,listener);
      }
      
      protected function setValueFromPos(thumbIndex:int) : void
      {
         var thumb:SliderThumb = null;
         thumb = SliderThumb(thumbs.getChildAt(thumbIndex));
         setValueAt(getValueFromX(thumb.xPosition),thumbIndex);
      }
      
      override protected function measure() : void
      {
         var isHorizontal:Boolean = false;
         var numLabels:int = 0;
         var trackMargin:Number = NaN;
         var length:Number = NaN;
         var bounds:Object = null;
         var thickness:Number = NaN;
         super.measure();
         isHorizontal = direction == SliderDirection.HORIZONTAL;
         numLabels = Boolean(labelObjects) ? int(labelObjects.numChildren) : 0;
         trackMargin = Number(getStyle("trackMargin"));
         length = Number(DEFAULT_MEASURED_WIDTH);
         if(!isNaN(trackMargin))
         {
            if(numLabels > 0)
            {
               length += isHorizontal ? SliderLabel(labelObjects.getChildAt(0)).getExplicitOrMeasuredWidth() / 2 : SliderLabel(labelObjects.getChildAt(0)).getExplicitOrMeasuredHeight() / 2;
            }
            if(numLabels > 1)
            {
               length += isHorizontal ? SliderLabel(labelObjects.getChildAt(numLabels - 1)).getExplicitOrMeasuredWidth() / 2 : SliderLabel(labelObjects.getChildAt(numLabels - 1)).getExplicitOrMeasuredHeight() / 2;
            }
         }
         bounds = getComponentBounds();
         thickness = bounds.lower - bounds.upper;
         measuredMinWidth = measuredWidth = isHorizontal ? length : thickness;
         measuredMinHeight = measuredHeight = isHorizontal ? thickness : length;
      }
      
      protected function createHighlightTrack() : void
      {
         var showTrackHighlight:Boolean = false;
         var trackHighlightClass:Class = null;
         showTrackHighlight = Boolean(getStyle("showTrackHighlight"));
         if(!highlightTrack && showTrackHighlight)
         {
            trackHighlightClass = getStyle("trackHighlightSkin");
            highlightTrack = new trackHighlightClass();
            if(highlightTrack is ISimpleStyleClient)
            {
               ISimpleStyleClient(highlightTrack).styleName = this;
            }
            innerSlider.addChildAt(DisplayObject(highlightTrack),innerSlider.getChildIndex(DisplayObject(track)) + 1);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getTrackHitArea() : UIComponent
      {
         return trackHitArea;
      }
      
      [Inspectable(category="General",defaultValue="undefined")]
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get value() : Number
      {
         return _values[0];
      }
      
      protected function createThumbs() : void
      {
         var n:int = 0;
         var i:int = 0;
         var thumb:SliderThumb = null;
         if(Boolean(thumbs))
         {
            n = int(thumbs.numChildren);
            for(i = n - 1; i >= 0; i--)
            {
               thumbs.removeChildAt(i);
            }
         }
         else
         {
            thumbs = new UIComponent();
            thumbs.tabChildren = true;
            thumbs.tabEnabled = false;
            innerSlider.addChild(thumbs);
         }
         n = _thumbCount;
         for(i = 0; i < n; i++)
         {
            thumb = SliderThumb(new _thumbClass());
            thumb.owner = this;
            thumb.styleName = this;
            thumb.thumbIndex = i;
            thumb.visible = true;
            thumb.enabled = enabled;
            thumb.upSkinName = "thumbUpSkin";
            thumb.downSkinName = "thumbDownSkin";
            thumb.disabledSkinName = "thumbDisabledSkin";
            thumb.overSkinName = "thumbOverSkin";
            thumbs.addChild(thumb);
            thumb.addEventListener(FocusEvent.FOCUS_IN,thumb_focusInHandler);
            thumb.addEventListener(FocusEvent.FOCUS_OUT,thumb_focusOutHandler);
         }
      }
      
      private function layoutTicks() : void
      {
         var g:Graphics = null;
         var tLength:Number = NaN;
         var tOffset:Number = NaN;
         var tickWidth:Number = NaN;
         var xOffset:Number = NaN;
         var xPos:Number = NaN;
         var tColor:Number = NaN;
         var usePositions:Boolean = false;
         var positionIndex:int = 0;
         var val:Number = NaN;
         if(Boolean(ticks))
         {
            g = ticks.graphics;
            tLength = Number(getStyle("tickLength"));
            tOffset = Number(getStyle("tickOffset"));
            tickWidth = Number(getStyle("tickThickness"));
            xOffset = tickWidth / 2;
            tColor = Number(getStyle("tickColor"));
            usePositions = Boolean(_tickValues) && _tickValues.length > 0 ? true : false;
            positionIndex = 0;
            val = usePositions ? Number(_tickValues[positionIndex++]) : minimum;
            g.clear();
            if(_tickInterval > 0 || usePositions)
            {
               g.lineStyle(tickWidth,tColor,100);
               do
               {
                  xPos = Math.round(getXFromValue(val) - xOffset);
                  g.moveTo(xPos,tLength);
                  g.lineTo(xPos,0);
                  val = usePositions ? (positionIndex < _tickValues.length ? Number(_tickValues[positionIndex++]) : NaN) : _tickInterval + val;
               }
               while(val < maximum || usePositions && positionIndex < _tickValues.length);
               if(!usePositions || val == maximum)
               {
                  xPos = track.x + track.width - 1 - xOffset;
                  g.moveTo(xPos,tLength);
                  g.lineTo(xPos,0);
               }
               ticks.y = Math.round(track.y + tOffset - tLength);
            }
         }
      }
      
      [Inspectable(category="General",defaultValue="0")]
      public function get tickInterval() : Number
      {
         return _tickInterval;
      }
      
      public function set snapInterval(value:Number) : void
      {
         var parts:Array = null;
         _snapInterval = value;
         parts = new String(1 + value).split(".");
         if(parts.length == 2)
         {
            snapIntervalPrecision = parts[1].length;
         }
         else
         {
            snapIntervalPrecision = -1;
         }
         if(!isNaN(value) && value != 0)
         {
            snapIntervalChanged = true;
            invalidateProperties();
            invalidateDisplayList();
         }
      }
      
      private function setPosFromValue() : void
      {
         var n:int = 0;
         var i:int = 0;
         var thumb:SliderThumb = null;
         n = _thumbCount;
         for(i = 0; i < n; i++)
         {
            thumb = SliderThumb(thumbs.getChildAt(i));
            thumb.xPosition = getXFromValue(values[i]);
         }
      }
      
      public function set thumbCount(value:int) : void
      {
         var numThumbs:int = 0;
         numThumbs = value > 2 ? 2 : value;
         numThumbs = value < 1 ? 1 : value;
         if(numThumbs != _thumbCount)
         {
            _thumbCount = numThumbs;
            thumbsChanged = true;
            initValues = true;
            invalidateProperties();
            invalidateDisplayList();
         }
      }
      
      override protected function commitProperties() : void
      {
         var n:int = 0;
         var i:int = 0;
         var isHorizontal:Boolean = false;
         var labelIndex:int = 0;
         var labelObj:SliderLabel = null;
         var labelStyleName:String = null;
         var val:Number = NaN;
         super.commitProperties();
         if(trackHighlightChanged)
         {
            trackHighlightChanged = false;
            if(Boolean(getStyle("showTrackHighlight")))
            {
               createHighlightTrack();
            }
            else if(Boolean(highlightTrack))
            {
               innerSlider.removeChild(DisplayObject(highlightTrack));
               highlightTrack = null;
            }
         }
         if(directionChanged)
         {
            directionChanged = false;
            isHorizontal = _direction == SliderDirection.HORIZONTAL;
            if(isHorizontal)
            {
               DisplayObject(innerSlider).rotation = 0;
            }
            else
            {
               DisplayObject(innerSlider).rotation = -90;
               innerSlider.y = unscaledHeight;
            }
            if(Boolean(labelObjects))
            {
               for(labelIndex = labelObjects.numChildren - 1; labelIndex >= 0; labelIndex--)
               {
                  labelObj = SliderLabel(labelObjects.getChildAt(labelIndex));
                  labelObj.rotation = isHorizontal ? 0 : 90;
               }
            }
         }
         if(labelStyleChanged && !labelsChanged)
         {
            labelStyleChanged = false;
            if(Boolean(labelObjects))
            {
               labelStyleName = getStyle("labelStyleName");
               n = int(labelObjects.numChildren);
               for(i = 0; i < n; i++)
               {
                  ISimpleStyleClient(labelObjects.getChildAt(i)).styleName = labelStyleName;
               }
            }
         }
         if(thumbsChanged)
         {
            thumbsChanged = false;
            createThumbs();
         }
         if(ticksChanged)
         {
            ticksChanged = false;
            createTicks();
         }
         if(labelsChanged)
         {
            labelsChanged = false;
            createLabels();
         }
         if(initValues)
         {
            initValues = false;
            if(!valuesChanged)
            {
               val = minimum;
               n = _thumbCount;
               for(i = 0; i < n; i++)
               {
                  _values[i] = val;
                  setValueAt(val,i);
                  if(Boolean(_snapInterval) && _snapInterval != 0)
                  {
                     val += snapInterval;
                  }
                  else
                  {
                     val++;
                  }
               }
               snapIntervalChanged = false;
            }
         }
         if(snapIntervalChanged)
         {
            snapIntervalChanged = false;
            if(!valuesChanged)
            {
               n = int(thumbs.numChildren);
               for(i = 0; i < n; i++)
               {
                  setValueAt(getValueFromX(SliderThumb(thumbs.getChildAt(i)).xPosition),i);
               }
            }
         }
         if(valuesChanged)
         {
            valuesChanged = false;
            n = _thumbCount;
            for(i = 0; i < n; i++)
            {
               setValueAt(getValueFromX(getXFromValue(Math.min(Math.max(values[i],minimum),maximum))),i);
            }
         }
         if(enabledChanged)
         {
            enabledChanged = false;
            n = int(thumbs.numChildren);
            for(i = 0; i < n; i++)
            {
               SliderThumb(thumbs.getChildAt(i)).enabled = _enabled;
            }
            n = Boolean(labelObjects) ? int(labelObjects.numChildren) : 0;
            for(i = 0; i < n; i++)
            {
               SliderLabel(labelObjects.getChildAt(i)).enabled = _enabled;
            }
         }
         if(tabIndexChanged)
         {
            tabIndexChanged = false;
            n = int(thumbs.numChildren);
            for(i = 0; i < n; i++)
            {
               SliderThumb(thumbs.getChildAt(i)).tabIndex = _tabIndex;
            }
         }
      }
      
      protected function thumb_focusInHandler(event:FocusEvent) : void
      {
         dispatchEvent(event);
      }
      
      public function set sliderDataTipClass(value:Class) : void
      {
         _sliderDataTipClass = value;
         invalidateProperties();
      }
      
      public function set sliderThumbClass(value:Class) : void
      {
         _thumbClass = value;
         thumbsChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function drawTrackHighlight() : void
      {
         var xPos:Number = NaN;
         var tWidth:Number = NaN;
         var firstThumb:SliderThumb = null;
         var secondThumb:SliderThumb = null;
         if(Boolean(highlightTrack))
         {
            firstThumb = SliderThumb(thumbs.getChildAt(0));
            if(_thumbCount > 1)
            {
               xPos = firstThumb.xPosition;
               secondThumb = SliderThumb(thumbs.getChildAt(1));
               tWidth = secondThumb.xPosition - firstThumb.xPosition;
            }
            else
            {
               xPos = Number(track.x);
               tWidth = firstThumb.xPosition - xPos;
            }
            highlightTrack.move(xPos,track.y + 1);
            highlightTrack.setActualSize(tWidth > 0 ? tWidth : 0,highlightTrack.height);
         }
      }
      
      [Inspectable(category="General",defaultValue="10")]
      public function get maximum() : Number
      {
         return _maximum;
      }
      
      public function set values(value:Array) : void
      {
         _values = value;
         valuesChanged = true;
         minimumSet = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      public function set tickValues(value:Array) : void
      {
         _tickValues = value;
         ticksChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      override public function set enabled(value:Boolean) : void
      {
         _enabled = value;
         enabledChanged = true;
         invalidateProperties();
      }
      
      protected function thumb_focusOutHandler(event:FocusEvent) : void
      {
         dispatchEvent(event);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getXFromValue(v:Number) : Number
      {
         var val:Number = NaN;
         if(v == minimum)
         {
            val = Number(track.x);
         }
         else if(v == maximum)
         {
            val = track.x + track.width;
         }
         else
         {
            val = track.x + (v - minimum) * track.width / (maximum - minimum);
         }
         return val;
      }
      
      [Inspectable(category="General",defaultValue="0")]
      public function get snapInterval() : Number
      {
         return _snapInterval;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function registerMouseMove(listener:Function) : void
      {
         innerSlider.addEventListener(MouseEvent.MOUSE_MOVE,listener);
      }
      
      public function set value(val:Number) : void
      {
         setValueAt(val,0,true);
         valuesChanged = true;
         minimumSet = true;
         invalidateProperties();
         invalidateDisplayList();
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function updateThumbValue(thumbIndex:int) : void
      {
         setValueFromPos(thumbIndex);
      }
      
      private function track_mouseDownHandler(event:MouseEvent) : void
      {
         var pt:Point = null;
         var xM:Number = NaN;
         var minIndex:Number = NaN;
         var minDistance:Number = NaN;
         var n:int = 0;
         var i:int = 0;
         var thumb:SliderThumb = null;
         var duration:Number = NaN;
         var t:Tween = null;
         var easingFunction:Function = null;
         var d:Number = NaN;
         if(event.target != trackHitArea && event.target != ticks)
         {
            return;
         }
         if(enabled && allowTrackClick)
         {
            interactionClickTarget = SliderEventClickTarget.TRACK;
            keyInteraction = false;
            pt = new Point(event.localX,event.localY);
            xM = pt.x;
            minIndex = 0;
            minDistance = 10000000;
            n = _thumbCount;
            for(i = 0; i < n; i++)
            {
               d = Math.abs(SliderThumb(thumbs.getChildAt(i)).xPosition - xM);
               if(d < minDistance)
               {
                  minIndex = i;
                  minDistance = d;
               }
            }
            thumb = SliderThumb(thumbs.getChildAt(minIndex));
            if(!isNaN(_snapInterval) && _snapInterval != 0)
            {
               xM = getXFromValue(getValueFromX(xM));
            }
            duration = Number(getStyle("slideDuration"));
            t = new Tween(thumb,thumb.xPosition,xM,duration);
            easingFunction = getStyle("slideEasingFunction") as Function;
            if(easingFunction != null)
            {
               t.easingFunction = easingFunction;
            }
            drawTrackHighlight();
         }
      }
      
      private function createTicks() : void
      {
         if(!ticks)
         {
            ticks = new UIComponent();
            innerSlider.addChild(ticks);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getValueFromX(xPos:Number) : Number
      {
         var v:Number = NaN;
         v = (xPos - track.x) * (maximum - minimum) / track.width + minimum;
         if(v - minimum <= 0.002)
         {
            v = minimum;
         }
         else if(maximum - v <= 0.002)
         {
            v = maximum;
         }
         else if(!isNaN(_snapInterval) && _snapInterval != 0)
         {
            v = Math.round((v - minimum) / _snapInterval) * _snapInterval + minimum;
         }
         return v;
      }
      
      public function set direction(value:String) : void
      {
         _direction = value;
         directionChanged = true;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      protected function setValueAt(value:Number, index:int, isProgrammatic:Boolean = false) : void
      {
         var oldValue:Number = NaN;
         var scale:Number = NaN;
         var event:SliderEvent = null;
         oldValue = Number(_values[index]);
         if(snapIntervalPrecision != -1)
         {
            scale = Math.pow(10,snapIntervalPrecision);
            value = Math.round(value * scale) / scale;
         }
         _values[index] = value;
         if(!isProgrammatic)
         {
            event = new SliderEvent(SliderEvent.CHANGE);
            event.value = value;
            event.thumbIndex = index;
            event.clickTarget = interactionClickTarget;
            if(keyInteraction)
            {
               event.triggerEvent = new KeyboardEvent(KeyboardEvent.KEY_DOWN);
               keyInteraction = false;
            }
            else
            {
               event.triggerEvent = new MouseEvent(MouseEvent.CLICK);
            }
            if(!isNaN(oldValue) && Math.abs(oldValue - value) > 0.002)
            {
               dispatchEvent(event);
            }
         }
         invalidateDisplayList();
      }
      
      public function set tickInterval(value:Number) : void
      {
         _tickInterval = value;
         ticksChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         dataFormatter = new NumberBase(resourceDecimalSeparatorFrom,resourceThousandsSeparatorFrom,resourceDecimalSeparatorTo,"");
         if(!innerSlider)
         {
            innerSlider = new UIComponent();
            UIComponent(innerSlider).tabChildren = true;
            addChild(innerSlider);
         }
         createBackgroundTrack();
         if(!trackHitArea)
         {
            trackHitArea = new UIComponent();
            innerSlider.addChild(trackHitArea);
            trackHitArea.addEventListener(MouseEvent.MOUSE_DOWN,track_mouseDownHandler);
         }
         invalidateProperties();
      }
      
      public function get sliderDataTipClass() : Class
      {
         return _sliderDataTipClass;
      }
      
      protected function positionDataTip(thumb:Object) : void
      {
         var relX:Number = NaN;
         var relY:Number = NaN;
         var tX:Number = NaN;
         var tY:Number = NaN;
         var tPlacement:String = null;
         var tOffset:Number = NaN;
         var o:Point = null;
         var r:Point = null;
         tX = Number(thumb.x);
         tY = Number(thumb.y);
         tPlacement = getStyle("dataTipPlacement");
         tOffset = Number(getStyle("dataTipOffset"));
         if(_direction == SliderDirection.HORIZONTAL)
         {
            relX = tX;
            relY = tY;
            if(tPlacement == "left")
            {
               relX -= tOffset + dataTip.width;
               relY += (thumb.height - dataTip.height) / 2;
            }
            else if(tPlacement == "right")
            {
               relX += tOffset + thumb.width;
               relY += (thumb.height - dataTip.height) / 2;
            }
            else if(tPlacement == "top")
            {
               relY -= tOffset + dataTip.height;
               relX -= (dataTip.width - thumb.width) / 2;
            }
            else if(tPlacement == "bottom")
            {
               relY += tOffset + thumb.height;
               relX -= (dataTip.width - thumb.width) / 2;
            }
         }
         else
         {
            relX = tY;
            relY = unscaledHeight - tX - (dataTip.height + thumb.width) / 2;
            if(tPlacement == "left")
            {
               relX -= tOffset + dataTip.width;
            }
            else if(tPlacement == "right")
            {
               relX += tOffset + thumb.height;
            }
            else if(tPlacement == "top")
            {
               relY -= tOffset + (dataTip.height + thumb.width) / 2;
               relX -= (dataTip.width - thumb.height) / 2;
            }
            else if(tPlacement == "bottom")
            {
               relY += tOffset + (dataTip.height + thumb.width) / 2;
               relX -= (dataTip.width - thumb.height) / 2;
            }
         }
         o = new Point(relX,relY);
         r = localToGlobal(o);
         dataTip.x = r.x < 0 ? 0 : r.x;
         dataTip.y = r.y < 0 ? 0 : r.y;
      }
      
      [Inspectable(category="General",enumeration="true,false",defaultValue="true")]
      override public function get enabled() : Boolean
      {
         return _enabled;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function onThumbPress(thumb:Object) : void
      {
         var event:SliderEvent = null;
         var formattedVal:String = null;
         var dataTipStyleName:String = null;
         if(showDataTip)
         {
            if(!dataTip)
            {
               dataTip = SliderDataTip(new sliderDataTipClass());
               systemManager.toolTipChildren.addChild(dataTip);
               dataTipStyleName = getStyle("dataTipStyleName");
               if(Boolean(dataTipStyleName))
               {
                  dataTip.styleName = dataTipStyleName;
               }
            }
            if(_dataTipFormatFunction != null)
            {
               formattedVal = this._dataTipFormatFunction(getValueFromX(thumb.xPosition));
            }
            else
            {
               formattedVal = dataFormatter.formatPrecision(String(getValueFromX(thumb.xPosition)),getStyle("dataTipPrecision"));
            }
            dataTip.text = formattedVal;
            dataTip.validateNow();
            dataTip.setActualSize(dataTip.getExplicitOrMeasuredWidth(),dataTip.getExplicitOrMeasuredHeight());
            positionDataTip(thumb);
         }
         keyInteraction = false;
         event = new SliderEvent(SliderEvent.THUMB_PRESS);
         event.thumbIndex = thumb.thumbIndex;
         dispatchEvent(event);
      }
      
      private function destroyDataTip() : void
      {
         if(Boolean(dataTip))
         {
            systemManager.toolTipChildren.removeChild(dataTip);
            dataTip = null;
         }
      }
      
      [Inspectable(defaultValue="horizontal")]
      public function get direction() : String
      {
         return _direction;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getSnapIntervalWidth() : Number
      {
         return _snapInterval * track.width / (maximum - minimum);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function onThumbMove(thumb:Object) : void
      {
         var value:Number = NaN;
         var event:SliderEvent = null;
         value = getValueFromX(thumb.xPosition);
         if(showDataTip)
         {
            dataTip.text = _dataTipFormatFunction != null ? _dataTipFormatFunction(value) : dataFormatter.formatPrecision(String(value),getStyle("dataTipPrecision"));
            dataTip.setActualSize(dataTip.getExplicitOrMeasuredWidth(),dataTip.getExplicitOrMeasuredHeight());
            positionDataTip(thumb);
         }
         if(liveDragging)
         {
            interactionClickTarget = SliderEventClickTarget.THUMB;
            setValueAt(value,thumb.thumbIndex);
         }
         event = new SliderEvent(SliderEvent.THUMB_DRAG);
         event.thumbIndex = thumb.thumbIndex;
         dispatchEvent(event);
      }
      
      public function set dataTipFormatFunction(value:Function) : void
      {
         _dataTipFormatFunction = value;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var anyStyle:Boolean = false;
         anyStyle = styleProp == null || styleProp == "styleName";
         super.styleChanged(styleProp);
         if(styleProp == "showTrackHighlight" || anyStyle)
         {
            trackHighlightChanged = true;
            invalidateProperties();
         }
         if(styleProp == "trackHighlightSkin" || anyStyle)
         {
            if(Boolean(innerSlider) && Boolean(highlightTrack))
            {
               innerSlider.removeChild(DisplayObject(highlightTrack));
               highlightTrack = null;
            }
            trackHighlightChanged = true;
            invalidateProperties();
         }
         if(styleProp == "labelStyleName" || anyStyle)
         {
            labelStyleChanged = true;
            invalidateProperties();
         }
         if(styleProp == "trackMargin" || anyStyle)
         {
            invalidateSize();
         }
         if(styleProp == "trackSkin" || anyStyle)
         {
            if(Boolean(track))
            {
               innerSlider.removeChild(DisplayObject(track));
               track = null;
               createBackgroundTrack();
            }
         }
         invalidateDisplayList();
      }
      
      private function layoutLabels() : void
      {
         var numLabels:Number = NaN;
         var availSpace:Number = NaN;
         var labelInterval:Number = NaN;
         var labelPos:Number = NaN;
         var left:Number = NaN;
         var curLabel:Object = null;
         var i:int = 0;
         var yPos:Number = NaN;
         var labelOff:Number = NaN;
         numLabels = Boolean(labelObjects) ? Number(labelObjects.numChildren) : 0;
         if(numLabels > 0)
         {
            labelInterval = track.width / (numLabels - 1);
            availSpace = Math.max((_direction == SliderDirection.HORIZONTAL ? unscaledWidth : unscaledHeight) - track.width,SliderThumb(thumbs.getChildAt(0)).getExplicitOrMeasuredWidth());
            left = Number(track.x);
            for(i = 0; i < numLabels; i++)
            {
               curLabel = labelObjects.getChildAt(i);
               curLabel.setActualSize(curLabel.getExplicitOrMeasuredWidth(),curLabel.getExplicitOrMeasuredHeight());
               yPos = track.y - curLabel.height + getStyle("labelOffset");
               if(_direction == SliderDirection.HORIZONTAL)
               {
                  labelPos = curLabel.getExplicitOrMeasuredWidth() / 2;
                  if(i == 0)
                  {
                     labelPos = Math.min(labelPos,availSpace / (numLabels > Number(1) ? Number(2) : Number(1)));
                  }
                  else if(i == numLabels - 1)
                  {
                     labelPos = Math.max(labelPos,curLabel.getExplicitOrMeasuredWidth() - availSpace / 2);
                  }
                  curLabel.move(left - labelPos,yPos);
               }
               else
               {
                  labelOff = Number(getStyle("labelOffset"));
                  labelPos = curLabel.getExplicitOrMeasuredHeight() / 2;
                  if(i == 0)
                  {
                     labelPos = Math.max(labelPos,curLabel.getExplicitOrMeasuredHeight() - availSpace / (numLabels > Number(1) ? Number(2) : Number(1)));
                  }
                  else if(i == numLabels - 1)
                  {
                     labelPos = Math.min(labelPos,availSpace / 2);
                  }
                  curLabel.move(left + labelPos,track.y + labelOff + (labelOff > 0 ? 0 : -curLabel.getExplicitOrMeasuredWidth()));
               }
               left += labelInterval;
            }
         }
      }
      
      public function get dataTipFormatFunction() : Function
      {
         return _dataTipFormatFunction;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var isHorizontal:Boolean = false;
         var numLabels:int = 0;
         var numThumbs:int = 0;
         var trackMargin:Number = NaN;
         var widestThumb:Number = NaN;
         var firstThumb:SliderThumb = null;
         var trackLeftOffset:Number = NaN;
         var trackRightOffset:Number = NaN;
         var availSpace:Number = NaN;
         var firstLabelSize:Number = NaN;
         var lastLabelSize:Number = NaN;
         var bounds:Object = null;
         var trackY:Number = NaN;
         var tY:Number = NaN;
         var n:int = 0;
         var i:int = 0;
         var g:Graphics = null;
         var tLength:Number = NaN;
         var fullThumbHeight:Number = NaN;
         var halfThumbHeight:Number = NaN;
         var firstLabel:SliderLabel = null;
         var lastLabel:SliderLabel = null;
         var currentThumb:SliderThumb = null;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         isHorizontal = _direction == SliderDirection.HORIZONTAL;
         numLabels = Boolean(labelObjects) ? int(labelObjects.numChildren) : 0;
         numThumbs = Boolean(thumbs) ? int(thumbs.numChildren) : 0;
         trackMargin = Number(getStyle("trackMargin"));
         widestThumb = 6;
         firstThumb = SliderThumb(thumbs.getChildAt(0));
         if(Boolean(thumbs) && Boolean(firstThumb))
         {
            widestThumb = Number(firstThumb.getExplicitOrMeasuredWidth());
         }
         trackLeftOffset = widestThumb / 2;
         trackRightOffset = trackLeftOffset;
         firstLabelSize = 0;
         if(numLabels > 0)
         {
            firstLabel = SliderLabel(labelObjects.getChildAt(0));
            firstLabelSize = isHorizontal ? Number(firstLabel.getExplicitOrMeasuredWidth()) : Number(firstLabel.getExplicitOrMeasuredHeight());
         }
         lastLabelSize = 0;
         if(numLabels > 1)
         {
            lastLabel = SliderLabel(labelObjects.getChildAt(numLabels - 1));
            lastLabelSize = isHorizontal ? Number(lastLabel.getExplicitOrMeasuredWidth()) : Number(lastLabel.getExplicitOrMeasuredHeight());
         }
         if(!isNaN(trackMargin))
         {
            availSpace = trackMargin;
         }
         else
         {
            availSpace = (firstLabelSize + lastLabelSize) / 2;
         }
         if(numLabels > 0)
         {
            if(!isNaN(trackMargin))
            {
               trackLeftOffset = Math.max(trackLeftOffset,availSpace / (numLabels > 1 ? 2 : 1));
            }
            else
            {
               trackLeftOffset = Math.max(trackLeftOffset,firstLabelSize / 2);
            }
         }
         else
         {
            trackLeftOffset = Math.max(trackLeftOffset,availSpace / 2);
         }
         bounds = getComponentBounds();
         trackY = ((isHorizontal ? unscaledHeight : unscaledWidth) - (Number(bounds.lower) - Number(bounds.upper))) / 2 - Number(bounds.upper);
         track.move(Math.round(trackLeftOffset),trackY);
         track.setActualSize((isHorizontal ? unscaledWidth : unscaledHeight) - trackLeftOffset * 2,track.height);
         tY = track.y + (track.height - firstThumb.getExplicitOrMeasuredHeight()) / 2 + getStyle("thumbOffset");
         n = _thumbCount;
         for(i = 0; i < n; i++)
         {
            currentThumb = SliderThumb(thumbs.getChildAt(i));
            currentThumb.move(currentThumb.x,tY);
            currentThumb.visible = true;
            currentThumb.setActualSize(currentThumb.getExplicitOrMeasuredWidth(),currentThumb.getExplicitOrMeasuredHeight());
         }
         g = trackHitArea.graphics;
         tLength = 0;
         if(_tickInterval > 0 || Boolean(_tickValues) && Boolean(_tickValues.length > 0))
         {
            tLength = Number(getStyle("tickLength"));
         }
         g.clear();
         g.beginFill(0,0);
         fullThumbHeight = Number(firstThumb.getExplicitOrMeasuredHeight());
         halfThumbHeight = !fullThumbHeight ? 0 : fullThumbHeight / 2;
         g.drawRect(track.x,track.y - halfThumbHeight - tLength,track.width,track.height + fullThumbHeight + tLength);
         g.endFill();
         if(_direction != SliderDirection.HORIZONTAL)
         {
            innerSlider.y = unscaledHeight;
         }
         layoutTicks();
         layoutLabels();
         setPosFromValue();
         drawTrackHighlight();
      }
      
      [Inspectable(category="General",arrayType="String",defaultValue="undefined")]
      public function get labels() : Array
      {
         return _labels;
      }
   }
}

