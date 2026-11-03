package mx.controls
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.ProgressEvent;
   import flash.events.TimerEvent;
   import flash.text.TextLineMetrics;
   import flash.utils.Timer;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModuleFactory;
   import mx.core.IFontContextComponent;
   import mx.core.IUITextField;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.styles.ISimpleStyleClient;
   
   [DiscouragedForProfile("mobileDevice")]
   [ResourceBundle("controls")]
   [IconFile("ProgressBar.png")]
   [DefaultTriggerEvent("progress")]
   [DefaultBindingProperty(source="percentComplete")]
   [Effect(name="completeEffect",event="complete")]
   [Style(name="labelWidth",type="Number",format="Length",inherit="yes")]
   [Style(name="trackHeight",type="Number",format="Length",inherit="no")]
   [Style(name="trackColors",type="Array",arrayType="uint",format="Color",inherit="no",theme="halo")]
   [Style(name="themeColor",type="uint",format="Color",inherit="yes",theme="halo")]
   [Style(name="trackSkin",type="Class",inherit="no")]
   [Style(name="maskSkin",type="Class",inherit="no")]
   [Style(name="indeterminateSkin",type="Class",inherit="no")]
   [Style(name="indeterminateMoveInterval",type="Number",inherit="no")]
   [Style(name="borderColor",type="uint",format="Color",inherit="no",theme="halo")]
   [Style(name="barSkin",type="Class",inherit="no")]
   [Style(name="textIndent",type="Number",format="Length",inherit="yes")]
   [Style(name="textFieldClass",type="Class",inherit="no")]
   [Style(name="textDecoration",type="String",enumeration="none,underline",inherit="yes")]
   [Style(name="textAlign",type="String",enumeration="left,center,right",inherit="yes")]
   [Style(name="locale",type="String",inherit="yes")]
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
   [Style(name="direction",type="String",enumeration="ltr,rtl,inherit",inherit="yes")]
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   [Style(name="paddingRight",type="Number",format="Length",inherit="no")]
   [Style(name="paddingLeft",type="Number",format="Length",inherit="no")]
   [Style(name="leading",type="Number",format="Length",inherit="yes")]
   [Style(name="verticalGap",type="Number",format="Length",inherit="no")]
   [Style(name="horizontalGap",type="Number",format="Length",inherit="no")]
   [Style(name="barColor",type="uint",format="Color",inherit="yes",theme="halo")]
   [Event(name="show",type="mx.events.FlexEvent")]
   [Event(name="progress",type="flash.events.ProgressEvent")]
   [Event(name="hide",type="mx.events.FlexEvent")]
   [Event(name="complete",type="flash.events.Event")]
   public class ProgressBar extends UIComponent implements IFontContextComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _content:UIComponent;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bar:UIComponent;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _indeterminateBar:IFlexDisplayObject;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _determinateBar:IFlexDisplayObject;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _track:IFlexDisplayObject;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _barMask:IFlexDisplayObject;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _labelField:IUITextField;
      
      private var pollTimer:Timer;
      
      private var _interval:Number = 30;
      
      private var indeterminatePlaying:Boolean = false;
      
      private var stopPolledMode:Boolean = false;
      
      private var barSkinChanged:Boolean = false;
      
      private var trackSkinChanged:Boolean = false;
      
      private var indeterminateSkinChanged:Boolean = false;
      
      private var visibleChanged:Boolean = false;
      
      private var _conversion:Number = 1;
      
      private var _direction:String = "right";
      
      private var _indeterminate:Boolean = false;
      
      private var indeterminateChanged:Boolean = true;
      
      private var _label:String;
      
      private var labelOverride:String;
      
      private var _labelPlacement:String = "bottom";
      
      private var _maximum:Number = 0;
      
      private var _minimum:Number = 0;
      
      private var _mode:String = "event";
      
      private var modeChanged:Boolean = false;
      
      private var _source:Object;
      
      private var _stringSource:String;
      
      private var sourceChanged:Boolean = false;
      
      private var stringSourceChanged:Boolean = false;
      
      private var _value:Number = 0;
      
      public function ProgressBar()
      {
         super();
         this.pollTimer = new Timer(this._interval);
         cacheAsBitmap = true;
      }
      
      [Inspectable(defaultValue="1")]
      [Bindable("conversionChanged")]
      public function get conversion() : Number
      {
         return this._conversion;
      }
      
      public function set conversion(value:Number) : void
      {
         if(!isNaN(value) && Number(value) > 0 && value != this._conversion)
         {
            this._conversion = Number(value);
            invalidateDisplayList();
            dispatchEvent(new Event("conversionChanged"));
         }
      }
      
      [Inspectable(enumeration="left,right",defaultValue="right")]
      [Bindable("directionChanged")]
      public function get direction() : String
      {
         return this._direction;
      }
      
      public function set direction(value:String) : void
      {
         if(value == ProgressBarDirection.LEFT || value == ProgressBarDirection.RIGHT)
         {
            this._direction = value;
         }
         invalidateDisplayList();
         dispatchEvent(new Event("directionChanged"));
      }
      
      public function get fontContext() : IFlexModuleFactory
      {
         return moduleFactory;
      }
      
      public function set fontContext(moduleFactory:IFlexModuleFactory) : void
      {
         this.moduleFactory = moduleFactory;
      }
      
      [Inspectable(category="General",defaultValue="false")]
      [Bindable("indeterminateChanged")]
      public function get indeterminate() : Boolean
      {
         return this._indeterminate;
      }
      
      public function set indeterminate(value:Boolean) : void
      {
         this._indeterminate = value;
         this.indeterminateChanged = true;
         invalidateProperties();
         invalidateDisplayList();
         dispatchEvent(new Event("indeterminateChanged"));
      }
      
      [Inspectable(category="General",defaultValue="null")]
      [Bindable("labelChanged")]
      public function get label() : String
      {
         return this._label;
      }
      
      public function set label(value:String) : void
      {
         this.labelOverride = value;
         this._label = value != null ? value : resourceManager.getString("controls","label");
         invalidateDisplayList();
         dispatchEvent(new Event("labelChanged"));
      }
      
      [Inspectable(category="General",enumeration="left,right,top,bottom,center",defaultValue="bottom")]
      [Bindable("labelPlacementChanged")]
      public function get labelPlacement() : String
      {
         return this._labelPlacement;
      }
      
      public function set labelPlacement(value:String) : void
      {
         if(value != this._labelPlacement)
         {
            this._labelPlacement = value;
         }
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new Event("labelPlacementChanged"));
      }
      
      [Inspectable(category="General",defaultValue="0")]
      [Bindable("maximumChanged")]
      public function get maximum() : Number
      {
         return this._maximum;
      }
      
      public function set maximum(value:Number) : void
      {
         if(!isNaN(value) && this._mode == ProgressBarMode.MANUAL && value != this._maximum)
         {
            this._maximum = value;
            invalidateDisplayList();
            dispatchEvent(new Event("maximumChanged"));
         }
      }
      
      [Inspectable(category="General",defaultValue="0")]
      [Bindable("minimumChanged")]
      public function get minimum() : Number
      {
         return this._minimum;
      }
      
      public function set minimum(value:Number) : void
      {
         if(!isNaN(value) && this._mode == ProgressBarMode.MANUAL && value != this._minimum)
         {
            this._minimum = value;
            invalidateDisplayList();
            dispatchEvent(new Event("minimumChanged"));
         }
      }
      
      [Inspectable(category="General",enumeration="event,polled,manual",defaultValue="event")]
      [Bindable("modeChanged")]
      public function get mode() : String
      {
         return this._mode;
      }
      
      public function set mode(value:String) : void
      {
         if(value != this._mode)
         {
            if(this._mode == ProgressBarMode.POLLED)
            {
               this.stopPolledMode = true;
            }
            this._mode = value;
            this.modeChanged = true;
            this.indeterminateChanged = true;
            invalidateProperties();
            invalidateDisplayList();
         }
      }
      
      [Bindable("progress")]
      public function get percentComplete() : Number
      {
         if(this._value < this._minimum || this._maximum < this._minimum)
         {
            return 0;
         }
         if(this._maximum - this._minimum == 0)
         {
            return 0;
         }
         var perc:Number = 100 * (this._value - this._minimum) / (this._maximum - this._minimum);
         if(isNaN(perc) || perc < 0)
         {
            return 0;
         }
         if(perc > 100)
         {
            return 100;
         }
         return perc;
      }
      
      [Inspectable(category="General")]
      [Bindable("sourceChanged")]
      public function get source() : Object
      {
         return this._source;
      }
      
      public function set source(value:Object) : void
      {
         if(value is String)
         {
            this._stringSource = String(value);
            try
            {
               value = document[this._stringSource];
            }
            catch(e:Error)
            {
               stringSourceChanged = true;
            }
         }
         if(Boolean(this._source) && this._source is IEventDispatcher)
         {
            this.removeSourceListeners();
         }
         if(Boolean(value))
         {
            this._source = value;
            this.sourceChanged = true;
            this.modeChanged = true;
            this.indeterminateChanged = true;
            invalidateProperties();
            invalidateDisplayList();
         }
         else if(this._source != null)
         {
            this._source = null;
            this.sourceChanged = true;
            this.indeterminateChanged = true;
            invalidateProperties();
            invalidateDisplayList();
            this.pollTimer.reset();
         }
      }
      
      [Bindable("change")]
      public function get value() : Number
      {
         return this._value;
      }
      
      override public function set visible(value:Boolean) : void
      {
         super.visible = value;
         this.visibleChanged = true;
         invalidateDisplayList();
      }
      
      override protected function createChildren() : void
      {
         var barMaskClass:Class = null;
         super.createChildren();
         if(!this._content)
         {
            this._content = new UIComponent();
            addChild(this._content);
         }
         if(!this._bar)
         {
            this._bar = new UIComponent();
            this._content.addChild(this._bar);
         }
         if(!this._barMask)
         {
            barMaskClass = getStyle("maskSkin");
            this._barMask = new barMaskClass();
            this._barMask.visible = true;
            this._bar.addChild(DisplayObject(this._barMask));
            UIComponent(this._bar).mask = DisplayObject(this._barMask);
         }
         if(!this._labelField)
         {
            this._labelField = IUITextField(createInFontContext(UITextField));
            this._labelField.styleName = this;
            addChild(DisplayObject(this._labelField));
         }
      }
      
      override protected function childrenCreated() : void
      {
         super.childrenCreated();
         this.trackSkinChanged = true;
         this.barSkinChanged = true;
         this.indeterminateSkinChanged = true;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var invalidate:Boolean = false;
         super.styleChanged(styleProp);
         if(styleProp == null || styleProp == "styleName")
         {
            this.barSkinChanged = this.trackSkinChanged = this.indeterminateSkinChanged = true;
            invalidate = true;
         }
         else if(styleProp == "barSkin")
         {
            this.barSkinChanged = true;
            invalidate = true;
         }
         else if(styleProp == "trackSkin")
         {
            this.trackSkinChanged = true;
            invalidate = true;
         }
         else if(styleProp == "indeterminateSkin")
         {
            this.indeterminateSkinChanged = true;
            invalidate = true;
         }
         if(invalidate)
         {
            invalidateProperties();
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      override protected function commitProperties() : void
      {
         var index:int = 0;
         super.commitProperties();
         if(Boolean(hasFontContextChanged()) && this._labelField != null)
         {
            index = int(getChildIndex(DisplayObject(this._labelField)));
            removeChild(DisplayObject(this._labelField));
            this._labelField = IUITextField(createInFontContext(UITextField));
            this._labelField.styleName = this;
            addChildAt(DisplayObject(this._labelField),index);
         }
         if(this.trackSkinChanged)
         {
            this.trackSkinChanged = false;
            this.createTrack();
         }
         if(this.barSkinChanged)
         {
            this.barSkinChanged = false;
            this.createBar();
         }
         if(this.indeterminateSkinChanged)
         {
            this.indeterminateSkinChanged = false;
            this.createIndeterminateBar();
         }
         if(this.stringSourceChanged)
         {
            this.stringSourceChanged = false;
            try
            {
               this._source = document[this._stringSource];
            }
            catch(e:Error)
            {
            }
         }
         if(this.sourceChanged)
         {
            this.sourceChanged = false;
            dispatchEvent(new Event("sourceChanged"));
         }
         if(this.modeChanged)
         {
            this.modeChanged = false;
            if(Boolean(this._source))
            {
               if(this._mode == ProgressBarMode.EVENT)
               {
                  if(this._source is IEventDispatcher)
                  {
                     this.addSourceListeners();
                  }
                  else
                  {
                     this._source = null;
                  }
               }
               else if(this._source is IEventDispatcher)
               {
                  this.removeSourceListeners();
               }
            }
            if(this._mode == ProgressBarMode.POLLED)
            {
               this.pollTimer.addEventListener(TimerEvent.TIMER,this.updatePolledHandler,false,0,true);
               this.pollTimer.start();
            }
            else if(this.stopPolledMode)
            {
               this.stopPolledMode = false;
               this.pollTimer.removeEventListener(TimerEvent.TIMER,this.updatePolledHandler);
               this.pollTimer.reset();
            }
            dispatchEvent(new Event("modeChanged"));
         }
      }
      
      override protected function measure() : void
      {
         var prefWidth:Number = NaN;
         var prefHeight:Number = NaN;
         var minWidth:Number = NaN;
         super.measure();
         minWidth = NaN;
         var minHeight:Number = NaN;
         var trackHeight:Number = Number(getStyle("trackHeight"));
         var preferredTrackWidth:Number = Number(this._track.measuredWidth);
         var preferredTrackHeight:Number = isNaN(trackHeight) ? Number(this._track.measuredHeight) : trackHeight;
         var horizontalGap:Number = Number(getStyle("horizontalGap"));
         var verticalGap:Number = Number(getStyle("verticalGap"));
         var paddingLeft:Number = Number(getStyle("paddingLeft"));
         var paddingRight:Number = Number(getStyle("paddingRight"));
         var paddingTop:Number = Number(getStyle("paddingTop"));
         var paddingBottom:Number = Number(getStyle("paddingBottom"));
         var labelWidth:Number = Number(getStyle("labelWidth"));
         var lineMetrics:TextLineMetrics = measureText(this.predictLabelText());
         var textWidth:Number = isNaN(labelWidth) ? lineMetrics.width + UITextField.TEXT_WIDTH_PADDING : labelWidth;
         var textHeight:Number = lineMetrics.height + UITextField.TEXT_HEIGHT_PADDING;
         switch(this.labelPlacement)
         {
            case ProgressBarLabelPlacement.LEFT:
            case ProgressBarLabelPlacement.RIGHT:
               prefWidth = textWidth + preferredTrackWidth + paddingLeft + paddingRight + horizontalGap;
               prefHeight = Math.max(textHeight,preferredTrackHeight) + paddingTop + paddingBottom;
               measuredMinWidth = prefWidth;
               break;
            case ProgressBarLabelPlacement.CENTER:
               prefWidth = Math.max(textWidth,preferredTrackWidth) + paddingLeft + paddingRight + horizontalGap;
               prefHeight = Math.max(textHeight,preferredTrackHeight) + paddingTop + paddingBottom;
               measuredMinWidth = textWidth;
               break;
            default:
               prefWidth = Math.max(textWidth,preferredTrackWidth) + paddingLeft + paddingRight;
               prefHeight = textHeight + preferredTrackHeight + paddingTop + paddingBottom + verticalGap;
               measuredMinWidth = textWidth;
         }
         measuredWidth = prefWidth;
         measuredMinHeight = measuredHeight = prefHeight;
         if(!isNaN(minWidth))
         {
            measuredMinWidth = minWidth;
         }
         if(!isNaN(minHeight))
         {
            measuredMinHeight = minHeight;
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var cWidth:Number = NaN;
         var w:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var horizontalGap:Number = Number(getStyle("horizontalGap"));
         var verticalGap:Number = Number(getStyle("verticalGap"));
         var paddingLeft:Number = Number(getStyle("paddingLeft"));
         var paddingRight:Number = Number(getStyle("paddingRight"));
         var paddingTop:Number = Number(getStyle("paddingTop"));
         var paddingBottom:Number = Number(getStyle("paddingBottom"));
         var left:Number = paddingLeft;
         var top:Number = paddingTop;
         var labelWidth:Number = Number(getStyle("labelWidth"));
         var trackHeight:Number = Number(getStyle("trackHeight"));
         trackHeight = isNaN(trackHeight) ? Number(this._track.measuredHeight) : trackHeight;
         var lineMetrics:TextLineMetrics = measureText(this.predictLabelText());
         var textWidth:Number = isNaN(labelWidth) ? lineMetrics.width + UITextField.TEXT_WIDTH_PADDING : labelWidth;
         var textHeight:Number = lineMetrics.height + UITextField.TEXT_HEIGHT_PADDING;
         switch(this.labelPlacement)
         {
            case ProgressBarLabelPlacement.TOP:
               this._labelField.move(left,top);
               this._labelField.setActualSize(textWidth,textHeight);
               this._content.move(left,top + textHeight + verticalGap);
               this.layoutContent(unscaledWidth - left - paddingRight,trackHeight);
               break;
            case ProgressBarLabelPlacement.RIGHT:
               cWidth = unscaledWidth - left - paddingRight - textWidth - horizontalGap;
               this._labelField.move(left + cWidth + horizontalGap,(unscaledHeight - textHeight) / 2);
               this._labelField.setActualSize(textWidth,textHeight);
               this._content.move(left,top + (textHeight - trackHeight) / 2);
               this.layoutContent(cWidth,trackHeight);
               break;
            case ProgressBarLabelPlacement.LEFT:
               this._labelField.move(left,top + (unscaledHeight - textHeight) / 2);
               this._labelField.setActualSize(textWidth,textHeight);
               this._content.move(left + textWidth + horizontalGap,top + (textHeight - trackHeight) / 2);
               this.layoutContent(unscaledWidth - left - textWidth - verticalGap - paddingRight,trackHeight);
               break;
            case ProgressBarLabelPlacement.CENTER:
               this._labelField.move((unscaledWidth - textWidth) / 2,(unscaledHeight - textHeight) / 2);
               this._labelField.setActualSize(textWidth,textHeight);
               this._content.move(left,top);
               this.layoutContent(unscaledWidth - paddingRight,unscaledHeight - paddingBottom);
               break;
            default:
               this._labelField.move(left,top + trackHeight + verticalGap);
               this._labelField.setActualSize(textWidth,textHeight);
               this._content.move(left,top);
               this.layoutContent(unscaledWidth - left - paddingRight,trackHeight);
         }
         if(Boolean(this._barMask))
         {
            this._barMask.move(0,0);
            this._barMask.setActualSize(this._track.width,this._track.height);
         }
         this._labelField.text = this.getFullLabelText();
         this._indeterminateBar.visible = this._indeterminate;
         if(this.indeterminateChanged || this.visibleChanged)
         {
            this.indeterminateChanged = false;
            this.visibleChanged = false;
            this._indeterminateBar.visible = this._indeterminate;
            if(this._indeterminate && this._source == null && this._mode == ProgressBarMode.EVENT && visible)
            {
               this.startPlayingIndeterminate();
            }
            else
            {
               this.stopPlayingIndeterminate();
            }
         }
         if(this._indeterminate)
         {
            this._determinateBar.setActualSize(this._track.width,this._track.height);
         }
         else
         {
            w = Math.max(0,this._track.width * this.percentComplete / 100);
            this._determinateBar.setActualSize(w,this._track.height);
            this._determinateBar.x = this.direction == ProgressBarDirection.RIGHT ? 0 : this._track.width - w;
         }
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         this.label = this.labelOverride;
      }
      
      public function setProgress(value:Number, total:Number) : void
      {
         if(this._mode == ProgressBarMode.MANUAL)
         {
            this._setProgress(value,total);
         }
      }
      
      private function _setProgress(value:Number, maximum:Number) : void
      {
         var progressEvent:ProgressEvent = null;
         if(Boolean(enabled) && !isNaN(value) && !isNaN(maximum))
         {
            this._value = value;
            this._maximum = maximum;
            dispatchEvent(new Event(Event.CHANGE));
            progressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
            progressEvent.bytesLoaded = value;
            progressEvent.bytesTotal = maximum;
            dispatchEvent(progressEvent);
            if(this._indeterminate)
            {
               this.startPlayingIndeterminate();
            }
            if(this._value == this._maximum && this._value > 0)
            {
               if(this._indeterminate)
               {
                  this.stopPlayingIndeterminate();
               }
               if(this.mode != ProgressBarMode.EVENT)
               {
                  dispatchEvent(new Event(Event.COMPLETE));
               }
            }
            invalidateDisplayList();
         }
      }
      
      private function createTrack() : void
      {
         if(Boolean(this._track))
         {
            this._content.removeChild(DisplayObject(this._track));
            this._track = null;
         }
         var trackClass:Class = getStyle("trackSkin");
         if(Boolean(trackClass))
         {
            this._track = new trackClass();
            if(this._track is ISimpleStyleClient)
            {
               ISimpleStyleClient(this._track).styleName = this;
            }
            this._content.addChildAt(DisplayObject(this._track),0);
         }
      }
      
      private function createBar() : void
      {
         if(Boolean(this._determinateBar))
         {
            this._bar.removeChild(DisplayObject(this._determinateBar));
            this._determinateBar = null;
         }
         var barClass:Class = getStyle("barSkin");
         if(Boolean(barClass))
         {
            this._determinateBar = new barClass();
            if(this._determinateBar is ISimpleStyleClient)
            {
               ISimpleStyleClient(this._determinateBar).styleName = this;
            }
            this._bar.addChild(DisplayObject(this._determinateBar));
         }
      }
      
      private function createIndeterminateBar() : void
      {
         if(Boolean(this._indeterminateBar))
         {
            this._bar.removeChild(DisplayObject(this._indeterminateBar));
            this._indeterminateBar = null;
         }
         var indeterminateClass:Class = getStyle("indeterminateSkin");
         if(Boolean(indeterminateClass))
         {
            this._indeterminateBar = new indeterminateClass();
            if(this._indeterminateBar is ISimpleStyleClient)
            {
               ISimpleStyleClient(this._indeterminateBar).styleName = this;
            }
            this._indeterminateBar.visible = false;
            this._bar.addChild(DisplayObject(this._indeterminateBar));
         }
      }
      
      private function layoutContent(newWidth:Number, newHeight:Number) : void
      {
         this._track.move(0,0);
         this._track.setActualSize(newWidth,newHeight);
         this._bar.move(0,0);
         this._determinateBar.move(0,0);
         this._indeterminateBar.setActualSize(newWidth + getStyle("indeterminateMoveInterval"),newHeight);
      }
      
      private function getFullLabelText() : String
      {
         var current:Number = Math.max(this._value,0);
         var total:Number = Math.max(this._maximum,0);
         var labelText:String = this.label;
         if(Boolean(labelText))
         {
            if(this._indeterminate)
            {
               labelText = labelText.replace("%1",String(Math.floor(current / this._conversion)));
               labelText = labelText.replace("%2","??");
               labelText = labelText.replace("%3","");
               labelText = labelText.replace("%%","");
            }
            else
            {
               labelText = labelText.replace("%1",String(Math.floor(current / this._conversion)));
               labelText = labelText.replace("%2",String(Math.floor(total / this._conversion)));
               labelText = labelText.replace("%3",String(Math.floor(this.percentComplete)));
               labelText = labelText.replace("%%","%");
            }
         }
         return labelText;
      }
      
      private function predictLabelText() : String
      {
         var largestValue:Number = NaN;
         if(this.label == null)
         {
            return "";
         }
         var labelText:String = this.label;
         if(this._maximum != 0)
         {
            largestValue = this._maximum;
         }
         else
         {
            largestValue = 100000;
         }
         if(Boolean(labelText))
         {
            if(this._indeterminate)
            {
               labelText = labelText.replace("%1",String(Math.floor(largestValue / this._conversion)));
               labelText = labelText.replace("%2","??");
               labelText = labelText.replace("%3","");
               labelText = labelText.replace("%%","");
            }
            else
            {
               labelText = labelText.replace("%1",String(Math.floor(largestValue / this._conversion)));
               labelText = labelText.replace("%2",String(Math.floor(largestValue / this._conversion)));
               labelText = labelText.replace("%3","100");
               labelText = labelText.replace("%%","%");
            }
         }
         var actualText:String = this.getFullLabelText();
         if(labelText.length > actualText.length)
         {
            return labelText;
         }
         return actualText;
      }
      
      private function startPlayingIndeterminate() : void
      {
         if(!this.indeterminatePlaying)
         {
            this.indeterminatePlaying = true;
            this.pollTimer.addEventListener(TimerEvent.TIMER,this.updateIndeterminateHandler,false,0,true);
            this.pollTimer.start();
         }
      }
      
      private function stopPlayingIndeterminate() : void
      {
         if(this.indeterminatePlaying)
         {
            this.indeterminatePlaying = false;
            this.pollTimer.removeEventListener(TimerEvent.TIMER,this.updateIndeterminateHandler);
            if(this._mode != ProgressBarMode.POLLED)
            {
               this.pollTimer.reset();
            }
         }
      }
      
      private function addSourceListeners() : void
      {
         this._source.addEventListener(ProgressEvent.PROGRESS,this.progressHandler);
         this._source.addEventListener(Event.COMPLETE,this.completeHandler);
      }
      
      private function removeSourceListeners() : void
      {
         this._source.removeEventListener(ProgressEvent.PROGRESS,this.progressHandler);
         this._source.removeEventListener(Event.COMPLETE,this.completeHandler);
      }
      
      private function progressHandler(event:ProgressEvent) : void
      {
         this._setProgress(event.bytesLoaded,event.bytesTotal);
      }
      
      private function completeHandler(event:Event) : void
      {
         dispatchEvent(event);
         invalidateDisplayList();
      }
      
      private function updateIndeterminateHandler(event:Event) : void
      {
         if(this._indeterminateBar.x < 1)
         {
            this._indeterminateBar.x += 1;
         }
         else
         {
            this._indeterminateBar.x = -(getStyle("indeterminateMoveInterval") - 2);
         }
      }
      
      private function updatePolledHandler(event:Event) : void
      {
         var comp:Object = null;
         var bytesLoaded:Number = NaN;
         var bytesTotal:Number = NaN;
         if(Boolean(this._source))
         {
            comp = this._source;
            bytesLoaded = Number(comp.bytesLoaded);
            bytesTotal = Number(comp.bytesTotal);
            if(!isNaN(bytesLoaded) && !isNaN(bytesTotal))
            {
               this._setProgress(bytesLoaded,bytesTotal);
               if(this.percentComplete >= 100 && this._value > 0)
               {
                  this.pollTimer.reset();
               }
            }
         }
      }
   }
}

