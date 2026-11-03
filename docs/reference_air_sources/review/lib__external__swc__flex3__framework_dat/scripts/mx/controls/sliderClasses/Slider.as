package mx.controls.sliderClasses
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import mx.core.FlexVersion;
   import mx.core.IFlexDisplayObject;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.effects.Tween;
   import mx.events.FlexEvent;
   import mx.events.SliderEvent;
   import mx.events.SliderEventClickTarget;
   import mx.formatters.NumberFormatter;
   import mx.styles.ISimpleStyleClient;
   import mx.styles.StyleProxy;
   
   use namespace mx_internal;
   
   [ResourceBundle("SharedResources")]
   [AccessibilityClass(implementation="mx.accessibility.SliderAccImpl")]
   [Style(name="trackSkin",type="Class",inherit="no")]
   [Style(name="trackHighlightSkin",type="Class",inherit="no")]
   [Style(name="thumbDisabledSkin",type="Class",inherit="no")]
   [Style(name="thumbDownSkin",type="Class",inherit="no")]
   [Style(name="thumbOverSkin",type="Class",inherit="no")]
   [Style(name="thumbUpSkin",type="Class",inherit="no")]
   [Style(name="thumbSkin",type="Class",inherit="no",states="up, over, down, disabled")]
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
   [Style(name="borderColor",type="uint",format="Color",inherit="no")]
   [Style(name="fillColors",type="Array",arrayType="uint",format="Color",inherit="no")]
   [Style(name="fillAlphas",type="Array",arrayType="Number",inherit="no")]
   [Event(name="thumbRelease",type="mx.events.SliderEvent")]
   [Event(name="thumbPress",type="mx.events.SliderEvent")]
   [Event(name="thumbDrag",type="mx.events.SliderEvent")]
   [Event(name="change",type="mx.events.SliderEvent")]
   public class Slider extends UIComponent
   {
      
      mx_internal static var createAccessibilityImplementation:Function;
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var _enabled:Boolean;
      
      private var snapIntervalChanged:Boolean = false;
      
      private var _direction:String = "horizontal";
      
      private var _thumbClass:Class = SliderThumb;
      
      private var _labels:Array = [];
      
      [Inspectable(defaultValue="true")]
      public var allowTrackClick:Boolean = true;
      
      private var valuesChanged:Boolean = false;
      
      mx_internal var keyInteraction:Boolean = false;
      
      private var directionChanged:Boolean = false;
      
      private var enabledChanged:Boolean = false;
      
      private var dataFormatter:NumberFormatter;
      
      private var track:IFlexDisplayObject;
      
      private var _values:Array = [0,0];
      
      private var initValues:Boolean = true;
      
      [Inspectable(category="General",defaultValue="false")]
      public var liveDragging:Boolean = false;
      
      private var thumbs:UIComponent;
      
      private var _tickInterval:Number = 0;
      
      private var ticksChanged:Boolean = false;
      
      private var minimumSet:Boolean = false;
      
      private var ticks:UIComponent;
      
      private var _thumbCount:int = 1;
      
      private var labelObjects:UIComponent;
      
      [Inspectable(defaultValue="false")]
      public var allowThumbOverlap:Boolean = false;
      
      private var snapIntervalPrecision:int = -1;
      
      mx_internal var dataTip:SliderDataTip;
      
      private var _snapInterval:Number = 0;
      
      private var thumbsChanged:Boolean = true;
      
      private var _tabIndex:Number;
      
      private var _sliderDataTipClass:Class = SliderDataTip;
      
      private var tabIndexChanged:Boolean;
      
      private var _tickValues:Array = [];
      
      private var labelsChanged:Boolean = false;
      
      private var interactionClickTarget:String;
      
      private var trackHighlightChanged:Boolean = true;
      
      private var _minimum:Number = 0;
      
      [Inspectable(category="General",defaultValue="true")]
      public var showDataTip:Boolean = true;
      
      mx_internal var innerSlider:UIComponent;
      
      private var labelStyleChanged:Boolean = false;
      
      private var _dataTipFormatFunction:Function;
      
      private var trackHitArea:UIComponent;
      
      private var highlightTrack:IFlexDisplayObject;
      
      private var _maximum:Number = 10;
      
      public function Slider()
      {
         super();
         tabChildren = true;
      }
      
      public function get sliderThumbClass() : Class
      {
         return _thumbClass;
      }
      
      public function set sliderThumbClass(value:Class) : void
      {
         _thumbClass = value;
         thumbsChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      public function set tickInterval(value:Number) : void
      {
         _tickInterval = value;
         ticksChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      public function set direction(value:String) : void
      {
         _direction = value;
         directionChanged = true;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      [Inspectable(category="General",defaultValue="0")]
      public function get minimum() : Number
      {
         return _minimum;
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
               n = labelObjects.numChildren;
               for(i = 0; i < n; i++)
               {
                  ISimpleStyleClient(labelObjects.getChildAt(i)).styleName = labelStyleName;
               }
            }
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
         if(thumbsChanged)
         {
            thumbsChanged = false;
            createThumbs();
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
               n = thumbs.numChildren;
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
            n = thumbs.numChildren;
            for(i = 0; i < n; i++)
            {
               SliderThumb(thumbs.getChildAt(i)).enabled = _enabled;
            }
            n = Boolean(labelObjects) ? labelObjects.numChildren : 0;
            for(i = 0; i < n; i++)
            {
               SliderLabel(labelObjects.getChildAt(i)).enabled = _enabled;
            }
         }
         if(tabIndexChanged)
         {
            tabIndexChanged = false;
            n = thumbs.numChildren;
            for(i = 0; i < n; i++)
            {
               SliderThumb(thumbs.getChildAt(i)).tabIndex = _tabIndex;
            }
         }
      }
      
      mx_internal function getSnapValue(value:Number, thumb:SliderThumb = null) : Number
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
      
      private function createHighlightTrack() : void
      {
         var trackHighlightClass:Class = null;
         var showTrackHighlight:Boolean = getStyle("showTrackHighlight");
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
      
      mx_internal function drawTrackHighlight() : void
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
               xPos = track.x;
               tWidth = firstThumb.xPosition - xPos;
            }
            highlightTrack.move(xPos,track.y + 1);
            highlightTrack.setActualSize(tWidth > 0 ? tWidth : 0,highlightTrack.height);
         }
      }
      
      mx_internal function getXBounds(selectedThumbIndex:int) : Object
      {
         var maxX:Number = track.x + track.width;
         var minX:Number = track.x;
         if(allowThumbOverlap)
         {
            return {
               "max":maxX,
               "min":minX
            };
         }
         var minBound:Number = NaN;
         var maxBound:Number = NaN;
         var prevThumb:SliderThumb = selectedThumbIndex > 0 ? SliderThumb(thumbs.getChildAt(selectedThumbIndex - 1)) : null;
         var nextThumb:SliderThumb = selectedThumbIndex + 1 < thumbs.numChildren ? SliderThumb(thumbs.getChildAt(selectedThumbIndex + 1)) : null;
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
      
      protected function get thumbStyleFilters() : Object
      {
         return null;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var availSpace:Number = NaN;
         var firstLabel:SliderLabel = null;
         var lastLabel:SliderLabel = null;
         var currentThumb:SliderThumb = null;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var isHorizontal:Boolean = _direction == SliderDirection.HORIZONTAL;
         var numLabels:int = Boolean(labelObjects) ? labelObjects.numChildren : 0;
         var numThumbs:int = Boolean(thumbs) ? thumbs.numChildren : 0;
         var trackMargin:Number = getStyle("trackMargin");
         var widestThumb:Number = 6;
         var firstThumb:SliderThumb = SliderThumb(thumbs.getChildAt(0));
         if(Boolean(thumbs) && Boolean(firstThumb))
         {
            widestThumb = firstThumb.getExplicitOrMeasuredWidth();
         }
         var trackLeftOffset:Number = widestThumb / 2;
         var trackRightOffset:Number = trackLeftOffset;
         var firstLabelSize:Number = 0;
         if(numLabels > 0)
         {
            firstLabel = SliderLabel(labelObjects.getChildAt(0));
            firstLabelSize = isHorizontal ? firstLabel.getExplicitOrMeasuredWidth() : firstLabel.getExplicitOrMeasuredHeight();
         }
         var lastLabelSize:Number = 0;
         if(numLabels > 1)
         {
            lastLabel = SliderLabel(labelObjects.getChildAt(numLabels - 1));
            lastLabelSize = isHorizontal ? lastLabel.getExplicitOrMeasuredWidth() : lastLabel.getExplicitOrMeasuredHeight();
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
         var bounds:Object = getComponentBounds();
         var trackY:Number = ((isHorizontal ? unscaledHeight : unscaledWidth) - (Number(bounds.lower) - Number(bounds.upper))) / 2 - Number(bounds.upper);
         track.move(Math.round(trackLeftOffset),Math.round(trackY));
         track.setActualSize((isHorizontal ? unscaledWidth : unscaledHeight) - trackLeftOffset * 2,track.height);
         var tY:Number = track.y + (track.height - firstThumb.getExplicitOrMeasuredHeight()) / 2 + getStyle("thumbOffset");
         var n:int = _thumbCount;
         for(var i:int = 0; i < n; i++)
         {
            currentThumb = SliderThumb(thumbs.getChildAt(i));
            currentThumb.move(currentThumb.x,tY);
            currentThumb.visible = true;
            currentThumb.setActualSize(currentThumb.getExplicitOrMeasuredWidth(),currentThumb.getExplicitOrMeasuredHeight());
         }
         var g:Graphics = trackHitArea.graphics;
         var tLength:Number = 0;
         if(_tickInterval > 0 || Boolean(_tickValues) && Boolean(_tickValues.length > 0))
         {
            tLength = getStyle("tickLength");
         }
         g.clear();
         g.beginFill(0,0);
         var fullThumbHeight:Number = firstThumb.getExplicitOrMeasuredHeight();
         var halfThumbHeight:Number = !fullThumbHeight ? 0 : fullThumbHeight / 2;
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
      
      override protected function createChildren() : void
      {
         super.createChildren();
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
      
      [Inspectable(category="General",defaultValue="undefined",arrayType="Number")]
      public function get tickValues() : Array
      {
         return _tickValues;
      }
      
      [Inspectable(category="General",defaultValue="10")]
      public function get maximum() : Number
      {
         return _maximum;
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
      
      private function positionDataTip(thumb:Object) : void
      {
         var relX:Number = NaN;
         var relY:Number = NaN;
         var tX:Number = Number(thumb.x);
         var tY:Number = Number(thumb.y);
         var tPlacement:String = getStyle("dataTipPlacement");
         var tOffset:Number = getStyle("dataTipOffset");
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
         var o:Point = new Point(relX,relY);
         var r:Point = localToGlobal(o);
         r = dataTip.parent.globalToLocal(r);
         dataTip.x = r.x < 0 ? 0 : r.x;
         dataTip.y = r.y < 0 ? 0 : r.y;
      }
      
      [Inspectable(category="General",arrayType="Number")]
      [Bindable("change")]
      public function get values() : Array
      {
         return _values;
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
      
      private function destroyDataTip() : void
      {
         if(Boolean(dataTip))
         {
            systemManager.toolTipChildren.removeChild(dataTip);
            dataTip = null;
         }
      }
      
      private function setValueFromPos(thumbIndex:int) : void
      {
         var thumb:SliderThumb = SliderThumb(thumbs.getChildAt(thumbIndex));
         setValueAt(getValueFromX(thumb.xPosition),thumbIndex);
      }
      
      public function set tickValues(value:Array) : void
      {
         _tickValues = value;
         ticksChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      [Inspectable(category="General",enumeration="true,false",defaultValue="true")]
      override public function get enabled() : Boolean
      {
         return _enabled;
      }
      
      public function set values(value:Array) : void
      {
         _values = value;
         valuesChanged = true;
         minimumSet = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      mx_internal function getXFromValue(v:Number) : Number
      {
         var val:Number = NaN;
         if(v == minimum)
         {
            val = track.x;
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
      
      mx_internal function onThumbPress(thumb:Object) : void
      {
         var formattedVal:String = null;
         var dataTipStyleName:String = null;
         if(showDataTip)
         {
            dataFormatter = new NumberFormatter();
            dataFormatter.precision = getStyle("dataTipPrecision");
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
               formattedVal = dataFormatter.format(getValueFromX(thumb.xPosition));
            }
            dataTip.text = formattedVal;
            dataTip.validateNow();
            dataTip.setActualSize(dataTip.getExplicitOrMeasuredWidth(),dataTip.getExplicitOrMeasuredHeight());
            positionDataTip(thumb);
         }
         keyInteraction = false;
         var event:SliderEvent = new SliderEvent(SliderEvent.THUMB_PRESS);
         event.value = getValueFromX(thumb.xPosition);
         event.thumbIndex = thumb.thumbIndex;
         dispatchEvent(event);
      }
      
      public function setThumbValueAt(index:int, value:Number) : void
      {
         setValueAt(value,index,true);
         valuesChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      public function set snapInterval(value:Number) : void
      {
         _snapInterval = value;
         var parts:Array = new String(1 + value).split(".");
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
      
      mx_internal function unRegisterMouseMove(listener:Function) : void
      {
         innerSlider.removeEventListener(MouseEvent.MOUSE_MOVE,listener);
      }
      
      mx_internal function getTrackHitArea() : UIComponent
      {
         return trackHitArea;
      }
      
      private function layoutTicks() : void
      {
         var g:Graphics = null;
         var tLength:Number = NaN;
         var tOffset:Number = NaN;
         var tickWidth:Number = NaN;
         var xPos:Number = NaN;
         var tColor:Number = NaN;
         var usePositions:Boolean = false;
         var positionIndex:int = 0;
         var val:Number = NaN;
         if(Boolean(ticks))
         {
            g = ticks.graphics;
            tLength = getStyle("tickLength");
            tOffset = getStyle("tickOffset");
            tickWidth = getStyle("tickThickness");
            tColor = getStyle("tickColor");
            usePositions = Boolean(_tickValues) && _tickValues.length > 0 ? true : false;
            positionIndex = 0;
            val = usePositions ? Number(_tickValues[positionIndex++]) : minimum;
            g.clear();
            if(_tickInterval > 0 || usePositions)
            {
               g.lineStyle(tickWidth,tColor,100);
               do
               {
                  xPos = Math.round(getXFromValue(val));
                  g.moveTo(xPos,tLength);
                  g.lineTo(xPos,0);
                  val = usePositions ? (positionIndex < _tickValues.length ? Number(_tickValues[positionIndex++]) : NaN) : _tickInterval + val;
               }
               while(val < maximum || usePositions && positionIndex < _tickValues.length);
               if(!usePositions || val == maximum)
               {
                  xPos = track.x + track.width - 1;
                  g.moveTo(xPos,tLength);
                  g.lineTo(xPos,0);
               }
               ticks.y = Math.round(track.y + tOffset - tLength);
            }
         }
      }
      
      public function getThumbAt(index:int) : SliderThumb
      {
         return index >= 0 && index < thumbs.numChildren ? SliderThumb(thumbs.getChildAt(index)) : null;
      }
      
      private function setPosFromValue() : void
      {
         var thumb:SliderThumb = null;
         var n:int = _thumbCount;
         for(var i:int = 0; i < n; i++)
         {
            thumb = SliderThumb(thumbs.getChildAt(i));
            thumb.xPosition = getXFromValue(values[i]);
         }
      }
      
      private function createThumbs() : void
      {
         var n:int = 0;
         var i:int = 0;
         var thumb:SliderThumb = null;
         if(Boolean(thumbs))
         {
            n = thumbs.numChildren;
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
            thumb.styleName = new StyleProxy(this,thumbStyleFilters);
            thumb.thumbIndex = i;
            thumb.visible = true;
            thumb.enabled = enabled;
            thumb.upSkinName = "thumbUpSkin";
            thumb.downSkinName = "thumbDownSkin";
            thumb.disabledSkinName = "thumbDisabledSkin";
            thumb.overSkinName = "thumbOverSkin";
            thumb.skinName = "thumbSkin";
            thumbs.addChild(thumb);
            thumb.addEventListener(FocusEvent.FOCUS_IN,thumb_focusInHandler);
            thumb.addEventListener(FocusEvent.FOCUS_OUT,thumb_focusOutHandler);
         }
      }
      
      override public function set tabIndex(value:int) : void
      {
         super.tabIndex = value;
         _tabIndex = value;
         tabIndexChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(defaultValue="horizontal")]
      public function get direction() : String
      {
         return _direction;
      }
      
      override public function set enabled(value:Boolean) : void
      {
         _enabled = value;
         enabledChanged = true;
         invalidateProperties();
      }
      
      override protected function measure() : void
      {
         var isHorizontal:Boolean = false;
         var thickness:Number = NaN;
         super.measure();
         isHorizontal = direction == SliderDirection.HORIZONTAL;
         var numLabels:int = Boolean(labelObjects) ? labelObjects.numChildren : 0;
         var trackMargin:Number = getStyle("trackMargin");
         var length:Number = DEFAULT_MEASURED_WIDTH;
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
         var bounds:Object = getComponentBounds();
         thickness = bounds.lower - bounds.upper;
         measuredMinWidth = measuredWidth = isHorizontal ? length : thickness;
         measuredMinHeight = measuredHeight = isHorizontal ? thickness : length;
      }
      
      [Inspectable(category="General",defaultValue="undefined")]
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get value() : Number
      {
         return _values[0];
      }
      
      [Inspectable(category="General",defaultValue="0")]
      public function get tickInterval() : Number
      {
         return _tickInterval;
      }
      
      override public function get baselinePosition() : Number
      {
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
         {
            return super.baselinePosition;
         }
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         return int(0.75 * height);
      }
      
      mx_internal function getSnapIntervalWidth() : Number
      {
         return _snapInterval * track.width / (maximum - minimum);
      }
      
      private function thumb_focusOutHandler(event:FocusEvent) : void
      {
         dispatchEvent(event);
      }
      
      override protected function initializeAccessibility() : void
      {
         if(Slider.createAccessibilityImplementation != null)
         {
            Slider.createAccessibilityImplementation(this);
         }
      }
      
      [Inspectable(category="General",defaultValue="0")]
      public function get snapInterval() : Number
      {
         return _snapInterval;
      }
      
      public function set thumbCount(value:int) : void
      {
         var numThumbs:int = value > 2 ? 2 : value;
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
      
      mx_internal function registerMouseMove(listener:Function) : void
      {
         innerSlider.addEventListener(MouseEvent.MOUSE_MOVE,listener);
      }
      
      public function set dataTipFormatFunction(value:Function) : void
      {
         _dataTipFormatFunction = value;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var anyStyle:Boolean = styleProp == null || styleProp == "styleName";
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
      
      public function set sliderDataTipClass(value:Class) : void
      {
         _sliderDataTipClass = value;
         invalidateProperties();
      }
      
      mx_internal function onThumbMove(thumb:Object) : void
      {
         var value:Number = getValueFromX(thumb.xPosition);
         if(showDataTip)
         {
            dataTip.text = _dataTipFormatFunction != null ? _dataTipFormatFunction(value) : dataFormatter.format(value);
            dataTip.setActualSize(dataTip.getExplicitOrMeasuredWidth(),dataTip.getExplicitOrMeasuredHeight());
            positionDataTip(thumb);
         }
         if(liveDragging)
         {
            interactionClickTarget = SliderEventClickTarget.THUMB;
            setValueAt(value,thumb.thumbIndex);
         }
         var event:SliderEvent = new SliderEvent(SliderEvent.THUMB_DRAG);
         event.value = value;
         event.thumbIndex = thumb.thumbIndex;
         dispatchEvent(event);
      }
      
      private function layoutLabels() : void
      {
         var availSpace:Number = NaN;
         var labelInterval:Number = NaN;
         var labelPos:Number = NaN;
         var left:Number = NaN;
         var curLabel:Object = null;
         var i:int = 0;
         var yPos:Number = NaN;
         var labelOff:Number = NaN;
         var numLabels:Number = Boolean(labelObjects) ? labelObjects.numChildren : 0;
         if(numLabels > 0)
         {
            labelInterval = track.width / (numLabels - 1);
            availSpace = Math.max((_direction == SliderDirection.HORIZONTAL ? unscaledWidth : unscaledHeight) - track.width,SliderThumb(thumbs.getChildAt(0)).getExplicitOrMeasuredWidth());
            left = track.x;
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
                  labelOff = getStyle("labelOffset");
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
      
      [Inspectable(category="General",defaultValue="1")]
      public function get thumbCount() : int
      {
         return _thumbCount;
      }
      
      private function getComponentBounds() : Object
      {
         var labelY:Number = NaN;
         var thumbY:Number = NaN;
         var sliderLabel:SliderLabel = null;
         var labOffset:Number = NaN;
         var i:int = 0;
         var tLen:Number = NaN;
         var tOff:Number = NaN;
         var isHorizontal:Boolean = direction == SliderDirection.HORIZONTAL;
         var numLabels:int = Boolean(labelObjects) ? labelObjects.numChildren : 0;
         var labelSize:Number = 0;
         var upperBound:Number = 0;
         var lowerBound:Number = track.height;
         if(numLabels > 0)
         {
            sliderLabel = SliderLabel(labelObjects.getChildAt(0));
            if(isHorizontal)
            {
               labelSize = sliderLabel.getExplicitOrMeasuredHeight();
            }
            else
            {
               for(i = 0; i < numLabels; i++)
               {
                  sliderLabel = SliderLabel(labelObjects.getChildAt(i));
                  labelSize = Math.max(labelSize,sliderLabel.getExplicitOrMeasuredWidth());
               }
            }
            labOffset = getStyle("labelOffset");
            labelY = labOffset - (labOffset > 0 ? 0 : labelSize);
            upperBound = Math.min(upperBound,labelY);
            lowerBound = Math.max(lowerBound,labOffset + (labOffset > 0 ? labelSize : 0));
         }
         if(Boolean(ticks))
         {
            tLen = getStyle("tickLength");
            tOff = getStyle("tickOffset");
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
      
      mx_internal function onThumbRelease(thumb:Object) : void
      {
         interactionClickTarget = SliderEventClickTarget.THUMB;
         destroyDataTip();
         setValueFromPos(thumb.thumbIndex);
         dataFormatter = null;
         var event:SliderEvent = new SliderEvent(SliderEvent.THUMB_RELEASE);
         event.value = getValueFromX(thumb.xPosition);
         event.thumbIndex = thumb.thumbIndex;
         dispatchEvent(event);
      }
      
      public function get dataTipFormatFunction() : Function
      {
         return _dataTipFormatFunction;
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
      
      mx_internal function updateThumbValue(thumbIndex:int) : void
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
            duration = getStyle("slideDuration");
            t = new Tween(thumb,thumb.xPosition,xM,duration);
            easingFunction = getStyle("slideEasingFunction") as Function;
            if(easingFunction != null)
            {
               t.easingFunction = easingFunction;
            }
            drawTrackHighlight();
         }
      }
      
      public function get sliderDataTipClass() : Class
      {
         return _sliderDataTipClass;
      }
      
      private function createTicks() : void
      {
         if(!ticks)
         {
            ticks = new UIComponent();
            innerSlider.addChild(ticks);
         }
      }
      
      mx_internal function getValueFromX(xPos:Number) : Number
      {
         var v:Number = (xPos - track.x) * (maximum - minimum) / track.width + minimum;
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
      
      private function thumb_focusInHandler(event:FocusEvent) : void
      {
         dispatchEvent(event);
      }
      
      private function setValueAt(value:Number, index:int, isProgrammatic:Boolean = false) : void
      {
         var scale:Number = NaN;
         var event:SliderEvent = null;
         var oldValue:Number = Number(_values[index]);
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
            if(!isNaN(oldValue))
            {
               if(Math.abs(oldValue - value) > 0.002)
               {
                  dispatchEvent(event);
               }
            }
            else if(!isNaN(value))
            {
               dispatchEvent(event);
            }
         }
         invalidateDisplayList();
      }
      
      public function set labels(value:Array) : void
      {
         _labels = value;
         labelsChanged = true;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      [Inspectable(category="General",arrayType="String",defaultValue="undefined")]
      public function get labels() : Array
      {
         return _labels;
      }
   }
}

