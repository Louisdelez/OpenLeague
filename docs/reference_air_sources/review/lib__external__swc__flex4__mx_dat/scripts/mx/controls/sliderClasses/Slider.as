package mx.controls.sliderClasses
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import mx.core.IFlexDisplayObject;
   import mx.core.IUIComponent;
   import mx.core.LayoutDirection;
   import mx.core.UIComponent;
   import mx.effects.Tween;
   import mx.events.FlexEvent;
   import mx.events.SliderEvent;
   import mx.events.SliderEventClickTarget;
   import mx.formatters.NumberFormatter;
   import mx.styles.ISimpleStyleClient;
   import mx.styles.StyleProxy;
   
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
   [Style(name="trackColors",type="Array",arrayType="uint",format="Color",inherit="no",theme="halo")]
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
   [Style(name="focusColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="accentColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="borderColor",type="uint",format="Color",inherit="no",theme="halo")]
   [Style(name="fillColors",type="Array",arrayType="uint",format="Color",inherit="no",theme="halo")]
   [Style(name="fillAlphas",type="Array",arrayType="Number",inherit="no",theme="halo")]
   [Event(name="thumbRelease",type="mx.events.SliderEvent")]
   [Event(name="thumbPress",type="mx.events.SliderEvent")]
   [Event(name="thumbDrag",type="mx.events.SliderEvent")]
   [Event(name="change",type="mx.events.SliderEvent")]
   public class Slider extends UIComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var track:IFlexDisplayObject;
      
      private var thumbs:UIComponent;
      
      private var thumbsChanged:Boolean = true;
      
      private var ticks:UIComponent;
      
      private var ticksChanged:Boolean = false;
      
      private var labelObjects:UIComponent;
      
      private var highlightTrack:IFlexDisplayObject;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var innerSlider:UIComponent;
      
      private var trackHitArea:UIComponent;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var dataTip:SliderDataTip;
      
      private var trackHighlightChanged:Boolean = true;
      
      private var initValues:Boolean = true;
      
      private var dataFormatter:NumberFormatter;
      
      private var interactionClickTarget:String;
      
      private var labelStyleChanged:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var keyInteraction:Boolean = false;
      
      private var _enabled:Boolean;
      
      private var enabledChanged:Boolean = false;
      
      private var _tabIndex:Number;
      
      private var tabIndexChanged:Boolean;
      
      [Inspectable(defaultValue="false")]
      public var allowThumbOverlap:Boolean = false;
      
      [Inspectable(defaultValue="true")]
      public var allowTrackClick:Boolean = true;
      
      private var _dataTipFormatFunction:Function;
      
      private var _direction:String = "horizontal";
      
      private var directionChanged:Boolean = false;
      
      private var _labels:Array = [];
      
      private var labelsChanged:Boolean = false;
      
      [Inspectable(category="General",defaultValue="false")]
      public var liveDragging:Boolean = false;
      
      private var _maximum:Number = 10;
      
      private var _minimum:Number = 0;
      
      private var minimumSet:Boolean = false;
      
      [Inspectable(category="General",defaultValue="true")]
      public var showDataTip:Boolean = true;
      
      private var _thumbClass:Class = SliderThumb;
      
      private var _sliderDataTipClass:Class = SliderDataTip;
      
      private var _snapInterval:Number = 0;
      
      private var snapIntervalPrecision:int = -1;
      
      private var snapIntervalChanged:Boolean = false;
      
      private var _thumbCount:int = 1;
      
      private var _tickInterval:Number = 0;
      
      private var _tickValues:Array = [];
      
      private var _values:Array = [0,0];
      
      private var valuesChanged:Boolean = false;
      
      public function Slider()
      {
         super();
      }
      
      override public function get baselinePosition() : Number
      {
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         return int(0.75 * height);
      }
      
      [Inspectable(category="General",enumeration="true,false",defaultValue="true")]
      override public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      override public function set enabled(value:Boolean) : void
      {
         this._enabled = value;
         this.enabledChanged = true;
         invalidateProperties();
      }
      
      override public function set tabIndex(value:int) : void
      {
         super.tabIndex = value;
         this._tabIndex = value;
         this.tabIndexChanged = true;
         invalidateProperties();
      }
      
      public function get dataTipFormatFunction() : Function
      {
         return this._dataTipFormatFunction;
      }
      
      public function set dataTipFormatFunction(value:Function) : void
      {
         this._dataTipFormatFunction = value;
      }
      
      [Inspectable(defaultValue="horizontal")]
      public function get direction() : String
      {
         return this._direction;
      }
      
      public function set direction(value:String) : void
      {
         this._direction = value;
         this.directionChanged = true;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      [Inspectable(category="General",arrayType="String",defaultValue="undefined")]
      public function get labels() : Array
      {
         return this._labels;
      }
      
      public function set labels(value:Array) : void
      {
         this._labels = value;
         this.labelsChanged = true;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      [Inspectable(category="General",defaultValue="10")]
      public function get maximum() : Number
      {
         return this._maximum;
      }
      
      public function set maximum(value:Number) : void
      {
         this._maximum = value;
         this.ticksChanged = true;
         if(!this.initValues)
         {
            this.valuesChanged = true;
         }
         invalidateProperties();
         invalidateDisplayList();
      }
      
      [Inspectable(category="General",defaultValue="0")]
      public function get minimum() : Number
      {
         return this._minimum;
      }
      
      public function set minimum(value:Number) : void
      {
         this._minimum = value;
         this.ticksChanged = true;
         if(!this.initValues)
         {
            this.valuesChanged = true;
         }
         invalidateProperties();
         invalidateDisplayList();
      }
      
      public function get sliderThumbClass() : Class
      {
         return this._thumbClass;
      }
      
      public function set sliderThumbClass(value:Class) : void
      {
         this._thumbClass = value;
         this.thumbsChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      public function get sliderDataTipClass() : Class
      {
         return this._sliderDataTipClass;
      }
      
      public function set sliderDataTipClass(value:Class) : void
      {
         this._sliderDataTipClass = value;
         invalidateProperties();
      }
      
      [Inspectable(category="General",defaultValue="0")]
      public function get snapInterval() : Number
      {
         return this._snapInterval;
      }
      
      public function set snapInterval(value:Number) : void
      {
         this._snapInterval = value;
         var parts:Array = new String(1 + value).split(".");
         if(parts.length == 2)
         {
            this.snapIntervalPrecision = parts[1].length;
         }
         else
         {
            this.snapIntervalPrecision = -1;
         }
         if(!isNaN(value) && value != 0)
         {
            this.snapIntervalChanged = true;
            invalidateProperties();
            invalidateDisplayList();
         }
      }
      
      [Inspectable(category="General",defaultValue="1")]
      public function get thumbCount() : int
      {
         return this._thumbCount;
      }
      
      public function set thumbCount(value:int) : void
      {
         var numThumbs:int = value > 2 ? 2 : value;
         numThumbs = value < 1 ? 1 : value;
         if(numThumbs != this._thumbCount)
         {
            this._thumbCount = numThumbs;
            this.thumbsChanged = true;
            this.initValues = true;
            invalidateProperties();
            invalidateDisplayList();
         }
      }
      
      protected function get thumbStyleFilters() : Object
      {
         return null;
      }
      
      [Inspectable(category="General",defaultValue="0")]
      public function get tickInterval() : Number
      {
         return this._tickInterval;
      }
      
      public function set tickInterval(value:Number) : void
      {
         this._tickInterval = value;
         this.ticksChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      [Inspectable(category="General",defaultValue="undefined",arrayType="Number")]
      public function get tickValues() : Array
      {
         return this._tickValues;
      }
      
      public function set tickValues(value:Array) : void
      {
         this._tickValues = value;
         this.ticksChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      [Inspectable(category="General",defaultValue="undefined")]
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get value() : Number
      {
         return this._values[0];
      }
      
      public function set value(val:Number) : void
      {
         this.setValueAt(val,0,true);
         this.valuesChanged = true;
         this.minimumSet = true;
         invalidateProperties();
         invalidateDisplayList();
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      [Inspectable(category="General",arrayType="Number")]
      [Bindable("change")]
      public function get values() : Array
      {
         return this._values;
      }
      
      public function set values(value:Array) : void
      {
         this._values = value;
         this.valuesChanged = true;
         this.minimumSet = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      override protected function initializeAccessibility() : void
      {
         if(Slider.createAccessibilityImplementation != null)
         {
            Slider.createAccessibilityImplementation(this);
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!this.innerSlider)
         {
            this.innerSlider = new UIComponent();
            UIComponent(this.innerSlider).tabChildren = true;
            addChild(this.innerSlider);
         }
         this.createBackgroundTrack();
         if(!this.trackHitArea)
         {
            this.trackHitArea = new UIComponent();
            this.innerSlider.addChild(this.trackHitArea);
            this.trackHitArea.addEventListener(MouseEvent.MOUSE_DOWN,this.track_mouseDownHandler);
         }
         invalidateProperties();
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var anyStyle:Boolean = styleProp == null || styleProp == "styleName";
         super.styleChanged(styleProp);
         if(styleProp == "showTrackHighlight" || anyStyle)
         {
            this.trackHighlightChanged = true;
            invalidateProperties();
         }
         if(styleProp == "trackHighlightSkin" || anyStyle)
         {
            if(Boolean(this.innerSlider) && Boolean(this.highlightTrack))
            {
               this.innerSlider.removeChild(DisplayObject(this.highlightTrack));
               this.highlightTrack = null;
            }
            this.trackHighlightChanged = true;
            invalidateProperties();
         }
         if(styleProp == "labelStyleName" || anyStyle)
         {
            this.labelStyleChanged = true;
            invalidateProperties();
         }
         if(styleProp == "trackMargin" || anyStyle)
         {
            invalidateSize();
         }
         if(styleProp == "trackSkin" || anyStyle)
         {
            if(Boolean(this.track))
            {
               this.innerSlider.removeChild(DisplayObject(this.track));
               this.track = null;
               this.createBackgroundTrack();
            }
         }
         invalidateDisplayList();
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
         if(this.trackHighlightChanged)
         {
            this.trackHighlightChanged = false;
            if(Boolean(getStyle("showTrackHighlight")))
            {
               this.createHighlightTrack();
            }
            else if(Boolean(this.highlightTrack))
            {
               this.innerSlider.removeChild(DisplayObject(this.highlightTrack));
               this.highlightTrack = null;
            }
         }
         if(this.directionChanged)
         {
            this.directionChanged = false;
            isHorizontal = this._direction == SliderDirection.HORIZONTAL;
            if(isHorizontal)
            {
               DisplayObject(this.innerSlider).rotation = 0;
            }
            else
            {
               DisplayObject(this.innerSlider).rotation = -90;
               this.innerSlider.y = unscaledHeight;
            }
            if(Boolean(this.labelObjects))
            {
               for(labelIndex = this.labelObjects.numChildren - 1; labelIndex >= 0; labelIndex--)
               {
                  labelObj = SliderLabel(this.labelObjects.getChildAt(labelIndex));
                  labelObj.rotation = isHorizontal ? 0 : 90;
               }
            }
         }
         if(this.labelStyleChanged && !this.labelsChanged)
         {
            this.labelStyleChanged = false;
            if(Boolean(this.labelObjects))
            {
               labelStyleName = getStyle("labelStyleName");
               n = int(this.labelObjects.numChildren);
               for(i = 0; i < n; i++)
               {
                  ISimpleStyleClient(this.labelObjects.getChildAt(i)).styleName = labelStyleName;
               }
            }
         }
         if(this.ticksChanged)
         {
            this.ticksChanged = false;
            this.createTicks();
         }
         if(this.labelsChanged)
         {
            this.labelsChanged = false;
            this.createLabels();
         }
         if(this.thumbsChanged)
         {
            this.thumbsChanged = false;
            this.createThumbs();
         }
         if(this.initValues)
         {
            this.initValues = false;
            if(!this.valuesChanged)
            {
               val = this.minimum;
               n = this._thumbCount;
               for(i = 0; i < n; i++)
               {
                  this._values[i] = val;
                  this.setValueAt(val,i);
                  if(Boolean(this._snapInterval) && this._snapInterval != 0)
                  {
                     val += this.snapInterval;
                  }
                  else
                  {
                     val++;
                  }
               }
               this.snapIntervalChanged = false;
            }
         }
         if(this.snapIntervalChanged)
         {
            this.snapIntervalChanged = false;
            if(!this.valuesChanged)
            {
               n = int(this.thumbs.numChildren);
               for(i = 0; i < n; i++)
               {
                  this.setValueAt(this.getValueFromX(SliderThumb(this.thumbs.getChildAt(i)).xPosition),i);
               }
            }
         }
         if(this.valuesChanged)
         {
            this.valuesChanged = false;
            n = this._thumbCount;
            for(i = 0; i < n; i++)
            {
               this.setValueAt(this.getValueFromX(this.getXFromValue(Math.min(Math.max(this.values[i],this.minimum),this.maximum))),i);
            }
         }
         if(this.enabledChanged)
         {
            this.enabledChanged = false;
            n = int(this.thumbs.numChildren);
            for(i = 0; i < n; i++)
            {
               SliderThumb(this.thumbs.getChildAt(i)).enabled = this.enabled;
            }
            n = Boolean(this.labelObjects) ? int(this.labelObjects.numChildren) : 0;
            for(i = 0; i < n; i++)
            {
               SliderLabel(this.labelObjects.getChildAt(i)).enabled = this.enabled;
            }
            if(this.track is IUIComponent)
            {
               IUIComponent(this.track).enabled = this.enabled;
            }
            if(Boolean(this.highlightTrack) && this.highlightTrack is IUIComponent)
            {
               IUIComponent(this.highlightTrack).enabled = this.enabled;
            }
         }
         if(this.tabIndexChanged)
         {
            this.tabIndexChanged = false;
            n = int(this.thumbs.numChildren);
            for(i = 0; i < n; i++)
            {
               SliderThumb(this.thumbs.getChildAt(i)).tabIndex = this._tabIndex;
            }
         }
      }
      
      override protected function measure() : void
      {
         var length:Number = NaN;
         var thickness:Number = NaN;
         super.measure();
         var isHorizontal:Boolean = this.direction == SliderDirection.HORIZONTAL;
         var numLabels:int = Boolean(this.labelObjects) ? int(this.labelObjects.numChildren) : 0;
         var trackMargin:Number = Number(getStyle("trackMargin"));
         length = Number(DEFAULT_MEASURED_WIDTH);
         if(!isNaN(trackMargin))
         {
            if(numLabels > 0)
            {
               length += isHorizontal ? SliderLabel(this.labelObjects.getChildAt(0)).getExplicitOrMeasuredWidth() / 2 : SliderLabel(this.labelObjects.getChildAt(0)).getExplicitOrMeasuredHeight() / 2;
            }
            if(numLabels > 1)
            {
               length += isHorizontal ? SliderLabel(this.labelObjects.getChildAt(numLabels - 1)).getExplicitOrMeasuredWidth() / 2 : SliderLabel(this.labelObjects.getChildAt(numLabels - 1)).getExplicitOrMeasuredHeight() / 2;
            }
         }
         var bounds:Object = this.getComponentBounds();
         thickness = bounds.lower - bounds.upper;
         measuredMinWidth = measuredWidth = isHorizontal ? length : thickness;
         measuredMinHeight = measuredHeight = isHorizontal ? thickness : length;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var availSpace:Number = NaN;
         var firstLabel:SliderLabel = null;
         var lastLabel:SliderLabel = null;
         var currentThumb:SliderThumb = null;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var isHorizontal:Boolean = this._direction == SliderDirection.HORIZONTAL;
         var numLabels:int = Boolean(this.labelObjects) ? int(this.labelObjects.numChildren) : 0;
         var numThumbs:int = Boolean(this.thumbs) ? int(this.thumbs.numChildren) : 0;
         var trackMargin:Number = Number(getStyle("trackMargin"));
         var widestThumb:Number = 6;
         var firstThumb:SliderThumb = SliderThumb(this.thumbs.getChildAt(0));
         if(Boolean(this.thumbs) && Boolean(firstThumb))
         {
            widestThumb = Number(firstThumb.getExplicitOrMeasuredWidth());
         }
         var trackLeftOffset:Number = widestThumb / 2;
         var trackRightOffset:Number = trackLeftOffset;
         var firstLabelSize:Number = 0;
         if(numLabels > 0)
         {
            firstLabel = SliderLabel(this.labelObjects.getChildAt(0));
            firstLabelSize = isHorizontal ? Number(firstLabel.getExplicitOrMeasuredWidth()) : Number(firstLabel.getExplicitOrMeasuredHeight());
         }
         var lastLabelSize:Number = 0;
         if(numLabels > 1)
         {
            lastLabel = SliderLabel(this.labelObjects.getChildAt(numLabels - 1));
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
         var bounds:Object = this.getComponentBounds();
         var trackY:Number = ((isHorizontal ? unscaledHeight : unscaledWidth) - (Number(bounds.lower) - Number(bounds.upper))) / 2 - Number(bounds.upper);
         this.track.move(Math.round(trackLeftOffset),Math.round(trackY));
         this.track.setActualSize((isHorizontal ? unscaledWidth : unscaledHeight) - trackLeftOffset * 2,this.track.height);
         var tY:Number = this.track.y + (this.track.height - firstThumb.getExplicitOrMeasuredHeight()) / 2 + getStyle("thumbOffset");
         var n:int = this._thumbCount;
         for(var i:int = 0; i < n; i++)
         {
            currentThumb = SliderThumb(this.thumbs.getChildAt(i));
            currentThumb.move(currentThumb.x,tY);
            currentThumb.visible = true;
            currentThumb.setActualSize(currentThumb.getExplicitOrMeasuredWidth(),currentThumb.getExplicitOrMeasuredHeight());
         }
         var g:Graphics = this.trackHitArea.graphics;
         var tLength:Number = 0;
         if(this._tickInterval > 0 || Boolean(this._tickValues) && Boolean(this._tickValues.length > 0))
         {
            tLength = Number(getStyle("tickLength"));
         }
         g.clear();
         g.beginFill(0,0);
         var fullThumbHeight:Number = Number(firstThumb.getExplicitOrMeasuredHeight());
         var halfThumbHeight:Number = !fullThumbHeight ? 0 : fullThumbHeight / 2;
         g.drawRect(this.track.x,this.track.y - halfThumbHeight - tLength,this.track.width,this.track.height + fullThumbHeight + tLength);
         g.endFill();
         if(this._direction != SliderDirection.HORIZONTAL)
         {
            this.innerSlider.y = unscaledHeight;
         }
         this.layoutTicks();
         this.layoutLabels();
         this.setPosFromValue();
         this.drawTrackHighlight();
      }
      
      private function createBackgroundTrack() : void
      {
         var trackSkinClass:Class = null;
         if(!this.track)
         {
            trackSkinClass = getStyle("trackSkin");
            this.track = new trackSkinClass();
            if(this.track is ISimpleStyleClient)
            {
               ISimpleStyleClient(this.track).styleName = this;
            }
            if(this.track is IUIComponent)
            {
               IUIComponent(this.track).enabled = this.enabled;
            }
            this.innerSlider.addChildAt(DisplayObject(this.track),0);
         }
      }
      
      private function createHighlightTrack() : void
      {
         var trackHighlightClass:Class = null;
         var showTrackHighlight:Boolean = Boolean(getStyle("showTrackHighlight"));
         if(!this.highlightTrack && showTrackHighlight)
         {
            trackHighlightClass = getStyle("trackHighlightSkin");
            this.highlightTrack = new trackHighlightClass();
            if(this.highlightTrack is ISimpleStyleClient)
            {
               ISimpleStyleClient(this.highlightTrack).styleName = this;
            }
            if(this.highlightTrack is IUIComponent)
            {
               IUIComponent(this.highlightTrack).enabled = this.enabled;
            }
            this.innerSlider.addChildAt(DisplayObject(this.highlightTrack),this.innerSlider.getChildIndex(DisplayObject(this.track)) + 1);
         }
      }
      
      private function createThumbs() : void
      {
         var n:int = 0;
         var i:int = 0;
         var thumb:SliderThumb = null;
         if(Boolean(this.thumbs))
         {
            n = int(this.thumbs.numChildren);
            for(i = n - 1; i >= 0; i--)
            {
               this.thumbs.removeChildAt(i);
            }
         }
         else
         {
            this.thumbs = new UIComponent();
            this.thumbs.tabChildren = true;
            this.thumbs.tabEnabled = false;
            this.thumbs.tabFocusEnabled = false;
            this.innerSlider.addChild(this.thumbs);
         }
         n = this._thumbCount;
         for(i = 0; i < n; i++)
         {
            thumb = SliderThumb(new this._thumbClass());
            thumb.owner = this;
            thumb.styleName = new StyleProxy(this,this.thumbStyleFilters);
            thumb.thumbIndex = i;
            thumb.visible = true;
            thumb.enabled = this.enabled;
            thumb.upSkinName = "thumbUpSkin";
            thumb.downSkinName = "thumbDownSkin";
            thumb.disabledSkinName = "thumbDisabledSkin";
            thumb.overSkinName = "thumbOverSkin";
            thumb.skinName = "thumbSkin";
            this.thumbs.addChild(thumb);
            thumb.addEventListener(FocusEvent.FOCUS_IN,this.thumb_focusInHandler);
            thumb.addEventListener(FocusEvent.FOCUS_OUT,this.thumb_focusOutHandler);
         }
      }
      
      private function createLabels() : void
      {
         var labelObj:SliderLabel = null;
         var i:int = 0;
         var numLabels:int = 0;
         var j:int = 0;
         var labelStyleName:String = null;
         if(Boolean(this.labelObjects))
         {
            for(i = this.labelObjects.numChildren - 1; i >= 0; i--)
            {
               this.labelObjects.removeChildAt(i);
            }
         }
         else
         {
            this.labelObjects = new UIComponent();
            this.innerSlider.addChildAt(this.labelObjects,this.innerSlider.getChildIndex(this.trackHitArea));
         }
         if(Boolean(this._labels))
         {
            numLabels = int(this._labels.length);
            for(j = 0; j < numLabels; j++)
            {
               labelObj = new SliderLabel();
               labelObj.text = this._labels[j] is String ? this._labels[j] : this._labels[j].toString();
               if(this._direction != SliderDirection.HORIZONTAL)
               {
                  labelObj.rotation = 90;
               }
               labelStyleName = getStyle("labelStyleName");
               if(Boolean(labelStyleName))
               {
                  labelObj.styleName = labelStyleName;
               }
               this.labelObjects.addChild(labelObj);
            }
         }
      }
      
      private function createTicks() : void
      {
         if(!this.ticks)
         {
            this.ticks = new UIComponent();
            this.innerSlider.addChild(this.ticks);
         }
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
         var isHorizontal:Boolean = this.direction == SliderDirection.HORIZONTAL;
         var numLabels:int = Boolean(this.labelObjects) ? int(this.labelObjects.numChildren) : 0;
         var labelSize:Number = 0;
         var upperBound:Number = 0;
         var lowerBound:Number = Number(this.track.height);
         if(numLabels > 0)
         {
            sliderLabel = SliderLabel(this.labelObjects.getChildAt(0));
            if(isHorizontal)
            {
               labelSize = Number(sliderLabel.getExplicitOrMeasuredHeight());
            }
            else
            {
               for(i = 0; i < numLabels; i++)
               {
                  sliderLabel = SliderLabel(this.labelObjects.getChildAt(i));
                  labelSize = Math.max(labelSize,sliderLabel.getExplicitOrMeasuredWidth());
               }
            }
            labOffset = Number(getStyle("labelOffset"));
            labelY = labOffset - (labOffset > 0 ? 0 : labelSize);
            upperBound = Math.min(upperBound,labelY);
            lowerBound = Math.max(lowerBound,labOffset + (labOffset > 0 ? labelSize : 0));
         }
         if(Boolean(this.ticks))
         {
            tLen = Number(getStyle("tickLength"));
            tOff = Number(getStyle("tickOffset"));
            upperBound = Math.min(upperBound,tOff - tLen);
            lowerBound = Math.max(lowerBound,tOff);
         }
         if(this.thumbs.numChildren > 0)
         {
            thumbY = (this.track.height - SliderThumb(this.thumbs.getChildAt(0)).getExplicitOrMeasuredHeight()) / 2 + getStyle("thumbOffset");
            upperBound = Math.min(upperBound,thumbY);
            lowerBound = Math.max(lowerBound,thumbY + SliderThumb(this.thumbs.getChildAt(0)).getExplicitOrMeasuredHeight());
         }
         return {
            "lower":lowerBound,
            "upper":upperBound
         };
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
         if(Boolean(this.ticks))
         {
            g = this.ticks.graphics;
            tLength = Number(getStyle("tickLength"));
            tOffset = Number(getStyle("tickOffset"));
            tickWidth = Number(getStyle("tickThickness"));
            tColor = Number(getStyle("tickColor"));
            usePositions = Boolean(this._tickValues) && this._tickValues.length > 0 ? true : false;
            positionIndex = 0;
            val = usePositions ? Number(this._tickValues[positionIndex++]) : this.minimum;
            g.clear();
            if(this._tickInterval > 0 || usePositions)
            {
               g.lineStyle(tickWidth,tColor,100);
               do
               {
                  xPos = Math.round(this.getXFromValue(val));
                  g.moveTo(xPos,tLength);
                  g.lineTo(xPos,0);
                  val = usePositions ? (positionIndex < this._tickValues.length ? Number(this._tickValues[positionIndex++]) : NaN) : this._tickInterval + val;
               }
               while(val < this.maximum || usePositions && positionIndex < this._tickValues.length);
               if(!usePositions || val == this.maximum)
               {
                  xPos = this.track.x + this.track.width - 1;
                  g.moveTo(xPos,tLength);
                  g.lineTo(xPos,0);
               }
               this.ticks.y = Math.round(this.track.y + tOffset - tLength);
            }
         }
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
         var numLabels:Number = Boolean(this.labelObjects) ? Number(this.labelObjects.numChildren) : 0;
         if(numLabels > 0)
         {
            labelInterval = this.track.width / (numLabels - 1);
            availSpace = Math.max((this._direction == SliderDirection.HORIZONTAL ? unscaledWidth : unscaledHeight) - this.track.width,SliderThumb(this.thumbs.getChildAt(0)).getExplicitOrMeasuredWidth());
            left = Number(this.track.x);
            for(i = 0; i < numLabels; i++)
            {
               curLabel = this.labelObjects.getChildAt(i);
               curLabel.setActualSize(curLabel.getExplicitOrMeasuredWidth(),curLabel.getExplicitOrMeasuredHeight());
               yPos = this.track.y - curLabel.height + getStyle("labelOffset");
               if(this._direction == SliderDirection.HORIZONTAL)
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
                  curLabel.move(left + labelPos,this.track.y + labelOff + (labelOff > 0 ? 0 : -curLabel.getExplicitOrMeasuredWidth()));
               }
               left += labelInterval;
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function drawTrackHighlight() : void
      {
         var xPos:Number = NaN;
         var tWidth:Number = NaN;
         var firstThumb:SliderThumb = null;
         var secondThumb:SliderThumb = null;
         if(Boolean(this.highlightTrack))
         {
            firstThumb = SliderThumb(this.thumbs.getChildAt(0));
            if(this._thumbCount > 1)
            {
               xPos = firstThumb.xPosition;
               secondThumb = SliderThumb(this.thumbs.getChildAt(1));
               tWidth = secondThumb.xPosition - firstThumb.xPosition;
            }
            else
            {
               xPos = Number(this.track.x);
               tWidth = firstThumb.xPosition - xPos;
            }
            this.highlightTrack.move(xPos,this.track.y + 1);
            this.highlightTrack.setActualSize(tWidth > 0 ? tWidth : 0,this.highlightTrack.height);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function onThumbPress(thumb:Object) : void
      {
         var formattedVal:String = null;
         var dataTipStyleName:String = null;
         if(this.showDataTip)
         {
            this.dataFormatter = new NumberFormatter();
            this.dataFormatter.precision = getStyle("dataTipPrecision");
            if(!this.dataTip)
            {
               this.dataTip = SliderDataTip(new this.sliderDataTipClass());
               systemManager.toolTipChildren.addChild(this.dataTip);
               dataTipStyleName = getStyle("dataTipStyleName");
               if(Boolean(dataTipStyleName))
               {
                  this.dataTip.styleName = dataTipStyleName;
               }
            }
            if(this._dataTipFormatFunction != null)
            {
               formattedVal = this._dataTipFormatFunction(this.getValueFromX(thumb.xPosition));
            }
            else
            {
               formattedVal = this.dataFormatter.format(this.getValueFromX(thumb.xPosition));
            }
            this.dataTip.text = formattedVal;
            this.dataTip.validateNow();
            this.dataTip.setActualSize(this.dataTip.getExplicitOrMeasuredWidth(),this.dataTip.getExplicitOrMeasuredHeight());
            this.positionDataTip(thumb);
         }
         this.keyInteraction = false;
         var event:SliderEvent = new SliderEvent(SliderEvent.THUMB_PRESS);
         event.value = this.getValueFromX(thumb.xPosition);
         event.thumbIndex = thumb.thumbIndex;
         dispatchEvent(event);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function onThumbRelease(thumb:Object) : void
      {
         this.interactionClickTarget = SliderEventClickTarget.THUMB;
         this.destroyDataTip();
         this.setValueFromPos(thumb.thumbIndex);
         this.dataFormatter = null;
         var event:SliderEvent = new SliderEvent(SliderEvent.THUMB_RELEASE);
         event.value = this.getValueFromX(thumb.xPosition);
         event.thumbIndex = thumb.thumbIndex;
         dispatchEvent(event);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function onThumbMove(thumb:Object) : void
      {
         var value:Number = this.getValueFromX(thumb.xPosition);
         if(this.showDataTip)
         {
            this.dataTip.text = this._dataTipFormatFunction != null ? this._dataTipFormatFunction(value) : this.dataFormatter.format(value);
            this.dataTip.setActualSize(this.dataTip.getExplicitOrMeasuredWidth(),this.dataTip.getExplicitOrMeasuredHeight());
            this.positionDataTip(thumb);
         }
         if(this.liveDragging)
         {
            this.interactionClickTarget = SliderEventClickTarget.THUMB;
            this.setValueAt(value,thumb.thumbIndex);
         }
         var event:SliderEvent = new SliderEvent(SliderEvent.THUMB_DRAG);
         event.value = value;
         event.thumbIndex = thumb.thumbIndex;
         dispatchEvent(event);
      }
      
      private function positionDataTip(thumb:Object) : void
      {
         var relX:Number = NaN;
         var relY:Number = NaN;
         var tX:Number = Number(thumb.x);
         var tY:Number = Number(thumb.y);
         var tPlacement:String = getStyle("dataTipPlacement");
         var tOffset:Number = Number(getStyle("dataTipOffset"));
         if(layoutDirection == LayoutDirection.RTL)
         {
            if(tPlacement == "left")
            {
               tPlacement = "right";
            }
            else if(tPlacement == "right")
            {
               tPlacement = "left";
            }
         }
         if(this._direction == SliderDirection.HORIZONTAL)
         {
            relX = tX;
            relY = tY;
            if(tPlacement == "left")
            {
               relX -= tOffset + this.dataTip.width;
               relY += (thumb.height - this.dataTip.height) / 2;
            }
            else if(tPlacement == "right")
            {
               relX += tOffset + thumb.width;
               relY += (thumb.height - this.dataTip.height) / 2;
            }
            else if(tPlacement == "top")
            {
               relY -= tOffset + this.dataTip.height;
               relX -= (this.dataTip.width - thumb.width) / 2;
            }
            else if(tPlacement == "bottom")
            {
               relY += tOffset + thumb.height;
               relX -= (this.dataTip.width - thumb.width) / 2;
            }
         }
         else
         {
            relX = tY;
            relY = unscaledHeight - tX - (this.dataTip.height + thumb.width) / 2;
            if(tPlacement == "left")
            {
               relX -= tOffset + this.dataTip.width;
            }
            else if(tPlacement == "right")
            {
               relX += tOffset + thumb.height;
            }
            else if(tPlacement == "top")
            {
               relY -= tOffset + (this.dataTip.height + thumb.width) / 2;
               relX -= (this.dataTip.width - thumb.height) / 2;
            }
            else if(tPlacement == "bottom")
            {
               relY += tOffset + (this.dataTip.height + thumb.width) / 2;
               relX -= (this.dataTip.width - thumb.height) / 2;
            }
         }
         if(layoutDirection == LayoutDirection.RTL)
         {
            relX += this.dataTip.width;
         }
         var o:Point = new Point(relX,relY);
         var r:Point = localToGlobal(o);
         r = this.dataTip.parent.globalToLocal(r);
         this.dataTip.x = r.x < 0 ? 0 : r.x;
         this.dataTip.y = r.y < 0 ? 0 : r.y;
      }
      
      private function destroyDataTip() : void
      {
         if(Boolean(this.dataTip))
         {
            systemManager.toolTipChildren.removeChild(this.dataTip);
            this.dataTip = null;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getXFromValue(v:Number) : Number
      {
         var val:Number = NaN;
         if(v == this.minimum)
         {
            val = Number(this.track.x);
         }
         else if(v == this.maximum)
         {
            val = this.track.x + this.track.width;
         }
         else
         {
            val = this.track.x + (v - this.minimum) * this.track.width / (this.maximum - this.minimum);
         }
         return val;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getXBounds(selectedThumbIndex:int) : Object
      {
         var maxX:Number = this.track.x + this.track.width;
         var minX:Number = Number(this.track.x);
         if(this.allowThumbOverlap)
         {
            return {
               "max":maxX,
               "min":minX
            };
         }
         var minBound:Number = NaN;
         var maxBound:Number = NaN;
         var prevThumb:SliderThumb = selectedThumbIndex > 0 ? SliderThumb(this.thumbs.getChildAt(selectedThumbIndex - 1)) : null;
         var nextThumb:SliderThumb = selectedThumbIndex + 1 < this.thumbs.numChildren ? SliderThumb(this.thumbs.getChildAt(selectedThumbIndex + 1)) : null;
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
      
      private function setPosFromValue() : void
      {
         var thumb:SliderThumb = null;
         var n:int = this._thumbCount;
         for(var i:int = 0; i < n; i++)
         {
            thumb = SliderThumb(this.thumbs.getChildAt(i));
            thumb.xPosition = this.getXFromValue(this.values[i]);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getValueFromX(xPos:Number) : Number
      {
         var v:Number = (xPos - this.track.x) * (this.maximum - this.minimum) / this.track.width + this.minimum;
         if(v - this.minimum <= 0.002)
         {
            v = this.minimum;
         }
         else if(this.maximum - v <= 0.002)
         {
            v = this.maximum;
         }
         else if(!isNaN(this._snapInterval) && this._snapInterval != 0)
         {
            v = Math.round((v - this.minimum) / this._snapInterval) * this._snapInterval + this.minimum;
         }
         return v;
      }
      
      private function setValueFromPos(thumbIndex:int) : void
      {
         var thumb:SliderThumb = SliderThumb(this.thumbs.getChildAt(thumbIndex));
         this.setValueAt(this.getValueFromX(thumb.xPosition),thumbIndex);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getSnapValue(value:Number, thumb:SliderThumb = null) : Number
      {
         var val:Number = NaN;
         var check_bounds:Boolean = false;
         var bounds:Object = null;
         var prevThumb:SliderThumb = null;
         var nextThumb:SliderThumb = null;
         if(!isNaN(this._snapInterval) && this._snapInterval != 0)
         {
            val = this.getValueFromX(value);
            if(Boolean(thumb) && Boolean(this.thumbs.numChildren > 1) && !this.allowThumbOverlap)
            {
               check_bounds = true;
               bounds = this.getXBounds(thumb.thumbIndex);
               prevThumb = thumb.thumbIndex > 0 ? SliderThumb(this.thumbs.getChildAt(thumb.thumbIndex - 1)) : null;
               nextThumb = thumb.thumbIndex + 1 < this.thumbs.numChildren ? SliderThumb(this.thumbs.getChildAt(thumb.thumbIndex + 1)) : null;
               if(Boolean(prevThumb))
               {
                  bounds.min -= prevThumb.width / 2;
                  if(val == this.minimum)
                  {
                     if(this.getValueFromX(prevThumb.xPosition - prevThumb.width / 2) != this.minimum)
                     {
                        check_bounds = false;
                     }
                  }
               }
               else if(val == this.minimum)
               {
                  check_bounds = false;
               }
               if(Boolean(nextThumb))
               {
                  bounds.max += nextThumb.width / 2;
                  if(val == this.maximum)
                  {
                     if(this.getValueFromX(nextThumb.xPosition + nextThumb.width / 2) != this.maximum)
                     {
                        check_bounds = false;
                     }
                  }
               }
               else if(val == this.maximum)
               {
                  check_bounds = false;
               }
               if(check_bounds)
               {
                  val = Math.min(Math.max(val,this.getValueFromX(Math.round(bounds.min)) + this._snapInterval),this.getValueFromX(Math.round(bounds.max)) - this._snapInterval);
               }
            }
            return this.getXFromValue(val);
         }
         return value;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getSnapIntervalWidth() : Number
      {
         return this._snapInterval * this.track.width / (this.maximum - this.minimum);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function updateThumbValue(thumbIndex:int) : void
      {
         this.setValueFromPos(thumbIndex);
      }
      
      public function getThumbAt(index:int) : SliderThumb
      {
         return index >= 0 && index < this.thumbs.numChildren ? SliderThumb(this.thumbs.getChildAt(index)) : null;
      }
      
      public function setThumbValueAt(index:int, value:Number) : void
      {
         this.setValueAt(value,index,true);
         this.valuesChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      private function setValueAt(value:Number, index:int, isProgrammatic:Boolean = false) : void
      {
         var scale:Number = NaN;
         var event:SliderEvent = null;
         var oldValue:Number = Number(this._values[index]);
         if(this.snapIntervalPrecision != -1)
         {
            scale = Math.pow(10,this.snapIntervalPrecision);
            value = Math.round(value * scale) / scale;
         }
         this._values[index] = value;
         if(!isProgrammatic)
         {
            event = new SliderEvent(SliderEvent.CHANGE);
            event.value = value;
            event.thumbIndex = index;
            event.clickTarget = this.interactionClickTarget;
            if(this.keyInteraction)
            {
               event.triggerEvent = new KeyboardEvent(KeyboardEvent.KEY_DOWN);
               this.keyInteraction = false;
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function registerMouseMove(listener:Function) : void
      {
         this.innerSlider.addEventListener(MouseEvent.MOUSE_MOVE,listener);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function unRegisterMouseMove(listener:Function) : void
      {
         this.innerSlider.removeEventListener(MouseEvent.MOUSE_MOVE,listener);
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
         if(event.target != this.trackHitArea && event.target != this.ticks)
         {
            return;
         }
         if(this.enabled && this.allowTrackClick)
         {
            this.interactionClickTarget = SliderEventClickTarget.TRACK;
            this.keyInteraction = false;
            pt = new Point(event.localX,event.localY);
            xM = pt.x;
            minIndex = 0;
            minDistance = 10000000;
            n = this._thumbCount;
            for(i = 0; i < n; i++)
            {
               d = Math.abs(SliderThumb(this.thumbs.getChildAt(i)).xPosition - xM);
               if(d < minDistance)
               {
                  minIndex = i;
                  minDistance = d;
               }
            }
            thumb = SliderThumb(this.thumbs.getChildAt(minIndex));
            if(!isNaN(this._snapInterval) && this._snapInterval != 0)
            {
               xM = this.getXFromValue(this.getValueFromX(xM));
            }
            duration = Number(getStyle("slideDuration"));
            t = new Tween(thumb,thumb.xPosition,xM,duration);
            easingFunction = getStyle("slideEasingFunction") as Function;
            if(easingFunction != null)
            {
               t.easingFunction = easingFunction;
            }
            this.drawTrackHighlight();
         }
      }
      
      private function thumb_focusInHandler(event:FocusEvent) : void
      {
         dispatchEvent(event);
      }
      
      private function thumb_focusOutHandler(event:FocusEvent) : void
      {
         dispatchEvent(event);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getTrackHitArea() : UIComponent
      {
         return this.trackHitArea;
      }
   }
}

