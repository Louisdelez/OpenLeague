package mx.controls
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.ProgressEvent;
   import flash.events.TimerEvent;
   import flash.text.TextLineMetrics;
   import flash.utils.Timer;
   import mx.core.FlexVersion;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModuleFactory;
   import mx.core.IFontContextComponent;
   import mx.core.IUITextField;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.core.mx_internal;
   import mx.styles.ISimpleStyleClient;
   
   use namespace mx_internal;
   
   [ResourceBundle("controls")]
   [IconFile("ProgressBar.png")]
   [DefaultTriggerEvent("progress")]
   [DefaultBindingProperty(source="percentComplete")]
   [Effect(name="completeEffect",event="complete")]
   [Style(name="labelWidth",type="Number",format="Length",inherit="yes")]
   [Style(name="trackHeight",type="Number",format="Length",inherit="no")]
   [Style(name="trackColors",type="Array",arrayType="uint",format="Color",inherit="no")]
   [Style(name="themeColor",type="uint",format="Color",inherit="yes")]
   [Style(name="trackSkin",type="Class",inherit="no")]
   [Style(name="maskSkin",type="Class",inherit="no")]
   [Style(name="indeterminateSkin",type="Class",inherit="no")]
   [Style(name="indeterminateMoveInterval",type="Number",inherit="no")]
   [Style(name="borderColor",type="uint",format="Color",inherit="no")]
   [Style(name="barSkin",type="Class",inherit="no")]
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
   [Style(name="paddingRight",type="Number",format="Length",inherit="no")]
   [Style(name="paddingLeft",type="Number",format="Length",inherit="no")]
   [Style(name="leading",type="Number",format="Length",inherit="yes")]
   [Style(name="verticalGap",type="Number",format="Length",inherit="no")]
   [Style(name="horizontalGap",type="Number",format="Length",inherit="no")]
   [Style(name="barColor",type="uint",format="Color",inherit="yes")]
   [Event(name="show",type="mx.events.FlexEvent")]
   [Event(name="progress",type="flash.events.ProgressEvent")]
   [Event(name="hide",type="mx.events.FlexEvent")]
   [Event(name="complete",type="flash.events.Event")]
   public class ProgressBar extends UIComponent implements IFontContextComponent
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var _direction:String = "right";
      
      private var stopPolledMode:Boolean = false;
      
      mx_internal var _labelField:IUITextField;
      
      mx_internal var _determinateBar:IFlexDisplayObject;
      
      private var sourceChanged:Boolean = false;
      
      private var _interval:Number = 30;
      
      private var trackSkinChanged:Boolean = false;
      
      mx_internal var _content:UIComponent;
      
      private var _source:Object;
      
      mx_internal var _track:IFlexDisplayObject;
      
      mx_internal var _bar:UIComponent;
      
      mx_internal var _barMask:IFlexDisplayObject;
      
      private var barSkinChanged:Boolean = false;
      
      private var _stringSource:String;
      
      private var _labelPlacement:String = "bottom";
      
      private var _value:Number = 0;
      
      private var indeterminateChanged:Boolean = true;
      
      private var _mode:String = "event";
      
      private var stringSourceChanged:Boolean = false;
      
      private var modeChanged:Boolean = false;
      
      private var _conversion:Number = 1;
      
      mx_internal var _indeterminateBar:IFlexDisplayObject;
      
      private var indeterminateSkinChanged:Boolean = false;
      
      private var _indeterminate:Boolean = false;
      
      private var pollTimer:Timer;
      
      private var _minimum:Number = 0;
      
      private var labelOverride:String;
      
      private var _maximum:Number = 0;
      
      private var visibleChanged:Boolean = false;
      
      private var indeterminatePlaying:Boolean = false;
      
      private var _label:String;
      
      public function ProgressBar()
      {
         super();
         pollTimer = new Timer(_interval);
         cacheAsBitmap = true;
      }
      
      [Inspectable(category="General",defaultValue="0")]
      [Bindable("minimumChanged")]
      public function get minimum() : Number
      {
         return _minimum;
      }
      
      [Inspectable(defaultValue="1")]
      [Bindable("conversionChanged")]
      public function get conversion() : Number
      {
         return _conversion;
      }
      
      private function completeHandler(event:Event) : void
      {
         dispatchEvent(event);
         invalidateDisplayList();
      }
      
      [Inspectable(category="General")]
      [Bindable("sourceChanged")]
      public function get source() : Object
      {
         return _source;
      }
      
      public function set minimum(value:Number) : void
      {
         if(!isNaN(value) && _mode == ProgressBarMode.MANUAL && value != _minimum)
         {
            _minimum = value;
            invalidateDisplayList();
            dispatchEvent(new Event("minimumChanged"));
         }
      }
      
      [Inspectable(category="General",defaultValue="0")]
      [Bindable("maximumChanged")]
      public function get maximum() : Number
      {
         return _maximum;
      }
      
      override protected function createChildren() : void
      {
         var barMaskClass:Class = null;
         super.createChildren();
         if(!_content)
         {
            _content = new UIComponent();
            addChild(_content);
         }
         if(!_bar)
         {
            _bar = new UIComponent();
            _content.addChild(_bar);
         }
         if(!_barMask)
         {
            if(FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0)
            {
               barMaskClass = getStyle("maskSkin");
               _barMask = new barMaskClass();
            }
            else
            {
               _barMask = new UIComponent();
            }
            _barMask.visible = true;
            _bar.addChild(DisplayObject(_barMask));
            UIComponent(_bar).mask = DisplayObject(_barMask);
         }
         if(!_labelField)
         {
            _labelField = IUITextField(createInFontContext(UITextField));
            _labelField.styleName = this;
            addChild(DisplayObject(_labelField));
         }
      }
      
      public function set source(value:Object) : void
      {
         if(value is String)
         {
            _stringSource = String(value);
            try
            {
               value = document[_stringSource];
            }
            catch(e:Error)
            {
               stringSourceChanged = true;
            }
         }
         if(Boolean(_source) && _source is IEventDispatcher)
         {
            removeSourceListeners();
         }
         if(Boolean(value))
         {
            _source = value;
            sourceChanged = true;
            modeChanged = true;
            indeterminateChanged = true;
            invalidateProperties();
            invalidateDisplayList();
         }
         else if(_source != null)
         {
            _source = null;
            sourceChanged = true;
            indeterminateChanged = true;
            invalidateProperties();
            invalidateDisplayList();
            pollTimer.reset();
         }
      }
      
      public function set conversion(value:Number) : void
      {
         if(!isNaN(value) && Number(value) > 0 && value != _conversion)
         {
            _conversion = Number(value);
            invalidateDisplayList();
            dispatchEvent(new Event("conversionChanged"));
         }
      }
      
      public function set maximum(value:Number) : void
      {
         if(!isNaN(value) && _mode == ProgressBarMode.MANUAL && value != _maximum)
         {
            _maximum = value;
            invalidateDisplayList();
            dispatchEvent(new Event("maximumChanged"));
         }
      }
      
      public function set mode(value:String) : void
      {
         if(value != _mode)
         {
            if(_mode == ProgressBarMode.POLLED)
            {
               stopPolledMode = true;
            }
            _mode = value;
            modeChanged = true;
            indeterminateChanged = true;
            invalidateProperties();
            invalidateDisplayList();
         }
      }
      
      private function removeSourceListeners() : void
      {
         _source.removeEventListener(ProgressEvent.PROGRESS,progressHandler);
         _source.removeEventListener(Event.COMPLETE,completeHandler);
      }
      
      private function stopPlayingIndeterminate() : void
      {
         if(indeterminatePlaying)
         {
            indeterminatePlaying = false;
            pollTimer.removeEventListener(TimerEvent.TIMER,updateIndeterminateHandler);
            if(_mode != ProgressBarMode.POLLED)
            {
               pollTimer.reset();
            }
         }
      }
      
      [Inspectable(category="General",enumeration="left,right,top,bottom,center",defaultValue="bottom")]
      [Bindable("labelPlacementChanged")]
      public function get labelPlacement() : String
      {
         return _labelPlacement;
      }
      
      private function progressHandler(event:ProgressEvent) : void
      {
         _setProgress(event.bytesLoaded,event.bytesTotal);
      }
      
      override protected function measure() : void
      {
         var prefWidth:Number = NaN;
         var prefHeight:Number = NaN;
         super.measure();
         var minWidth:Number = NaN;
         var minHeight:Number = NaN;
         var trackHeight:Number = getStyle("trackHeight");
         var preferredTrackWidth:Number = _track.measuredWidth;
         var preferredTrackHeight:Number = isNaN(trackHeight) ? _track.measuredHeight : trackHeight;
         var horizontalGap:Number = getStyle("horizontalGap");
         var verticalGap:Number = getStyle("verticalGap");
         var paddingLeft:Number = getStyle("paddingLeft");
         var paddingRight:Number = getStyle("paddingRight");
         var paddingTop:Number = getStyle("paddingTop");
         var paddingBottom:Number = getStyle("paddingBottom");
         var labelWidth:Number = getStyle("labelWidth");
         var lineMetrics:TextLineMetrics = measureText(predictLabelText());
         var textWidth:Number = isNaN(labelWidth) ? lineMetrics.width + UITextField.TEXT_WIDTH_PADDING : labelWidth;
         var textHeight:Number = lineMetrics.height + UITextField.TEXT_HEIGHT_PADDING;
         switch(labelPlacement)
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
      
      public function get fontContext() : IFlexModuleFactory
      {
         return moduleFactory;
      }
      
      private function predictLabelText() : String
      {
         var largestValue:Number = NaN;
         if(label == null)
         {
            return "";
         }
         var labelText:String = label;
         if(_maximum != 0)
         {
            largestValue = _maximum;
         }
         else
         {
            largestValue = 100000;
         }
         if(Boolean(labelText))
         {
            if(_indeterminate)
            {
               labelText = labelText.replace("%1",String(Math.floor(largestValue / _conversion)));
               labelText = labelText.replace("%2","??");
               labelText = labelText.replace("%3","");
               labelText = labelText.replace("%%","");
            }
            else
            {
               labelText = labelText.replace("%1",String(Math.floor(largestValue / _conversion)));
               labelText = labelText.replace("%2",String(Math.floor(largestValue / _conversion)));
               labelText = labelText.replace("%3","100");
               labelText = labelText.replace("%%","%");
            }
         }
         var actualText:String = getFullLabelText();
         if(labelText.length > actualText.length)
         {
            return labelText;
         }
         return actualText;
      }
      
      [Bindable("change")]
      public function get value() : Number
      {
         return _value;
      }
      
      public function set indeterminate(value:Boolean) : void
      {
         _indeterminate = value;
         indeterminateChanged = true;
         invalidateProperties();
         invalidateDisplayList();
         dispatchEvent(new Event("indeterminateChanged"));
      }
      
      private function createBar() : void
      {
         if(Boolean(_determinateBar))
         {
            _bar.removeChild(DisplayObject(_determinateBar));
            _determinateBar = null;
         }
         var barClass:Class = getStyle("barSkin");
         if(Boolean(barClass))
         {
            _determinateBar = new barClass();
            if(_determinateBar is ISimpleStyleClient)
            {
               ISimpleStyleClient(_determinateBar).styleName = this;
            }
            _bar.addChild(DisplayObject(_determinateBar));
         }
      }
      
      private function createIndeterminateBar() : void
      {
         if(Boolean(_indeterminateBar))
         {
            _bar.removeChild(DisplayObject(_indeterminateBar));
            _indeterminateBar = null;
         }
         var indeterminateClass:Class = getStyle("indeterminateSkin");
         if(Boolean(indeterminateClass))
         {
            _indeterminateBar = new indeterminateClass();
            if(_indeterminateBar is ISimpleStyleClient)
            {
               ISimpleStyleClient(_indeterminateBar).styleName = this;
            }
            _indeterminateBar.visible = false;
            _bar.addChild(DisplayObject(_indeterminateBar));
         }
      }
      
      [Inspectable(enumeration="left,right",defaultValue="right")]
      [Bindable("directionChanged")]
      public function get direction() : String
      {
         return _direction;
      }
      
      private function addSourceListeners() : void
      {
         _source.addEventListener(ProgressEvent.PROGRESS,progressHandler);
         _source.addEventListener(Event.COMPLETE,completeHandler);
      }
      
      private function updateIndeterminateHandler(event:Event) : void
      {
         if(_indeterminateBar.x < 1)
         {
            _indeterminateBar.x += 1;
         }
         else
         {
            _indeterminateBar.x = -(getStyle("indeterminateMoveInterval") - 2);
         }
      }
      
      private function updatePolledHandler(event:Event) : void
      {
         var comp:Object = null;
         var bytesLoaded:Number = NaN;
         var bytesTotal:Number = NaN;
         if(Boolean(_source))
         {
            comp = _source;
            bytesLoaded = Number(comp.bytesLoaded);
            bytesTotal = Number(comp.bytesTotal);
            if(!isNaN(bytesLoaded) && !isNaN(bytesTotal))
            {
               _setProgress(bytesLoaded,bytesTotal);
               if(percentComplete >= 100 && _value > 0)
               {
                  pollTimer.reset();
               }
            }
         }
      }
      
      public function set labelPlacement(value:String) : void
      {
         if(value != _labelPlacement)
         {
            _labelPlacement = value;
         }
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new Event("labelPlacementChanged"));
      }
      
      [Inspectable(category="General",enumeration="event,polled,manual",defaultValue="event")]
      [Bindable("modeChanged")]
      public function get mode() : String
      {
         return _mode;
      }
      
      [Bindable("progress")]
      public function get percentComplete() : Number
      {
         if(_value < _minimum || _maximum < _minimum)
         {
            return 0;
         }
         if(_maximum - _minimum == 0)
         {
            return 0;
         }
         var perc:Number = 100 * (_value - _minimum) / (_maximum - _minimum);
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
      
      public function setProgress(value:Number, total:Number) : void
      {
         if(_mode == ProgressBarMode.MANUAL)
         {
            _setProgress(value,total);
         }
      }
      
      private function createTrack() : void
      {
         if(Boolean(_track))
         {
            _content.removeChild(DisplayObject(_track));
            _track = null;
         }
         var trackClass:Class = getStyle("trackSkin");
         if(Boolean(trackClass))
         {
            _track = new trackClass();
            if(_track is ISimpleStyleClient)
            {
               ISimpleStyleClient(_track).styleName = this;
            }
            _content.addChildAt(DisplayObject(_track),0);
         }
      }
      
      [Inspectable(category="General",defaultValue="false")]
      [Bindable("indeterminateChanged")]
      public function get indeterminate() : Boolean
      {
         return _indeterminate;
      }
      
      private function startPlayingIndeterminate() : void
      {
         if(!indeterminatePlaying)
         {
            indeterminatePlaying = true;
            pollTimer.addEventListener(TimerEvent.TIMER,updateIndeterminateHandler,false,0,true);
            pollTimer.start();
         }
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var invalidate:Boolean = false;
         super.styleChanged(styleProp);
         if(styleProp == null || styleProp == "styleName")
         {
            barSkinChanged = trackSkinChanged = indeterminateSkinChanged = true;
            invalidate = true;
         }
         else if(styleProp == "barSkin")
         {
            barSkinChanged = true;
            invalidate = true;
         }
         else if(styleProp == "trackSkin")
         {
            trackSkinChanged = true;
            invalidate = true;
         }
         else if(styleProp == "indeterminateSkin")
         {
            indeterminateSkinChanged = true;
            invalidate = true;
         }
         if(invalidate)
         {
            invalidateProperties();
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      private function getFullLabelText() : String
      {
         var current:Number = Math.max(_value,0);
         var total:Number = Math.max(_maximum,0);
         var labelText:String = label;
         if(Boolean(labelText))
         {
            if(_indeterminate)
            {
               labelText = labelText.replace("%1",String(Math.floor(current / _conversion)));
               labelText = labelText.replace("%2","??");
               labelText = labelText.replace("%3","");
               labelText = labelText.replace("%%","");
            }
            else
            {
               labelText = labelText.replace("%1",String(Math.floor(current / _conversion)));
               labelText = labelText.replace("%2",String(Math.floor(total / _conversion)));
               labelText = labelText.replace("%3",String(Math.floor(percentComplete)));
               labelText = labelText.replace("%%","%");
            }
         }
         return labelText;
      }
      
      override protected function commitProperties() : void
      {
         var index:int = 0;
         super.commitProperties();
         if(hasFontContextChanged() && _labelField != null)
         {
            index = getChildIndex(DisplayObject(_labelField));
            removeChild(DisplayObject(_labelField));
            _labelField = IUITextField(createInFontContext(UITextField));
            _labelField.styleName = this;
            addChildAt(DisplayObject(_labelField),index);
         }
         if(trackSkinChanged)
         {
            trackSkinChanged = false;
            createTrack();
         }
         if(barSkinChanged)
         {
            barSkinChanged = false;
            createBar();
         }
         if(indeterminateSkinChanged)
         {
            indeterminateSkinChanged = false;
            createIndeterminateBar();
         }
         if(stringSourceChanged)
         {
            stringSourceChanged = false;
            try
            {
               _source = document[_stringSource];
            }
            catch(e:Error)
            {
            }
         }
         if(sourceChanged)
         {
            sourceChanged = false;
            dispatchEvent(new Event("sourceChanged"));
         }
         if(modeChanged)
         {
            modeChanged = false;
            if(Boolean(_source))
            {
               if(_mode == ProgressBarMode.EVENT)
               {
                  if(_source is IEventDispatcher)
                  {
                     addSourceListeners();
                  }
                  else
                  {
                     _source = null;
                  }
               }
               else if(_source is IEventDispatcher)
               {
                  removeSourceListeners();
               }
            }
            if(_mode == ProgressBarMode.POLLED)
            {
               pollTimer.addEventListener(TimerEvent.TIMER,updatePolledHandler,false,0,true);
               pollTimer.start();
            }
            else if(stopPolledMode)
            {
               stopPolledMode = false;
               pollTimer.removeEventListener(TimerEvent.TIMER,updatePolledHandler);
               pollTimer.reset();
            }
            dispatchEvent(new Event("modeChanged"));
         }
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         label = labelOverride;
      }
      
      public function set fontContext(moduleFactory:IFlexModuleFactory) : void
      {
         this.moduleFactory = moduleFactory;
      }
      
      override public function set visible(value:Boolean) : void
      {
         super.visible = value;
         visibleChanged = true;
         invalidateDisplayList();
      }
      
      public function set label(value:String) : void
      {
         labelOverride = value;
         _label = value != null ? value : resourceManager.getString("controls","label");
         invalidateDisplayList();
         dispatchEvent(new Event("labelChanged"));
      }
      
      override protected function childrenCreated() : void
      {
         super.childrenCreated();
         trackSkinChanged = true;
         barSkinChanged = true;
         indeterminateSkinChanged = true;
      }
      
      private function layoutContent(newWidth:Number, newHeight:Number) : void
      {
         _track.move(0,0);
         _track.setActualSize(newWidth,newHeight);
         _bar.move(0,0);
         _determinateBar.move(0,0);
         _indeterminateBar.setActualSize(newWidth + getStyle("indeterminateMoveInterval"),newHeight);
      }
      
      private function _setProgress(value:Number, maximum:Number) : void
      {
         var progressEvent:ProgressEvent = null;
         if(enabled && !isNaN(value) && !isNaN(maximum))
         {
            _value = value;
            _maximum = maximum;
            dispatchEvent(new Event(Event.CHANGE));
            progressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
            progressEvent.bytesLoaded = value;
            progressEvent.bytesTotal = maximum;
            dispatchEvent(progressEvent);
            if(_indeterminate)
            {
               startPlayingIndeterminate();
            }
            if(_value == _maximum && _value > 0)
            {
               if(_indeterminate)
               {
                  stopPlayingIndeterminate();
               }
               if(mode != ProgressBarMode.EVENT)
               {
                  dispatchEvent(new Event(Event.COMPLETE));
               }
            }
            invalidateDisplayList();
         }
      }
      
      [Inspectable(category="General",defaultValue="null")]
      [Bindable("labelChanged")]
      public function get label() : String
      {
         return _label;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var cWidth:Number = NaN;
         var g:Graphics = null;
         var w:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var horizontalGap:Number = getStyle("horizontalGap");
         var verticalGap:Number = getStyle("verticalGap");
         var paddingLeft:Number = getStyle("paddingLeft");
         var paddingRight:Number = getStyle("paddingRight");
         var paddingTop:Number = getStyle("paddingTop");
         var paddingBottom:Number = getStyle("paddingBottom");
         var left:Number = paddingLeft;
         var top:Number = paddingTop;
         var labelWidth:Number = getStyle("labelWidth");
         var trackHeight:Number = getStyle("trackHeight");
         trackHeight = isNaN(trackHeight) ? _track.measuredHeight : trackHeight;
         var lineMetrics:TextLineMetrics = measureText(predictLabelText());
         var textWidth:Number = isNaN(labelWidth) ? lineMetrics.width + UITextField.TEXT_WIDTH_PADDING : labelWidth;
         var textHeight:Number = lineMetrics.height + UITextField.TEXT_HEIGHT_PADDING;
         switch(labelPlacement)
         {
            case ProgressBarLabelPlacement.TOP:
               _labelField.move(left,top);
               _labelField.setActualSize(textWidth,textHeight);
               _content.move(left,top + textHeight + verticalGap);
               layoutContent(unscaledWidth - left - paddingRight,trackHeight);
               break;
            case ProgressBarLabelPlacement.RIGHT:
               cWidth = unscaledWidth - left - paddingRight - textWidth - horizontalGap;
               _labelField.move(left + cWidth + horizontalGap,(unscaledHeight - textHeight) / 2);
               _labelField.setActualSize(textWidth,textHeight);
               _content.move(left,top + (textHeight - trackHeight) / 2);
               layoutContent(cWidth,trackHeight);
               break;
            case ProgressBarLabelPlacement.LEFT:
               _labelField.move(left,top + (unscaledHeight - textHeight) / 2);
               _labelField.setActualSize(textWidth,textHeight);
               _content.move(left + textWidth + horizontalGap,top + (textHeight - trackHeight) / 2);
               layoutContent(unscaledWidth - left - textWidth - verticalGap - paddingRight,trackHeight);
               break;
            case ProgressBarLabelPlacement.CENTER:
               _labelField.move((unscaledWidth - textWidth) / 2,(unscaledHeight - textHeight) / 2);
               _labelField.setActualSize(textWidth,textHeight);
               _content.move(left,top);
               layoutContent(unscaledWidth - paddingRight,unscaledHeight - paddingBottom);
               break;
            default:
               _labelField.move(left,top + trackHeight + verticalGap);
               _labelField.setActualSize(textWidth,textHeight);
               _content.move(left,top);
               layoutContent(unscaledWidth - left - paddingRight,trackHeight);
         }
         if(Boolean(_barMask))
         {
            _barMask.move(0,0);
            if(FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0)
            {
               _barMask.setActualSize(_track.width,_track.height);
            }
            else
            {
               g = UIComponent(_barMask).graphics;
               g.clear();
               g.beginFill(16776960);
               g.drawRect(1,1,_track.width - 2,_track.height - 2);
               g.endFill();
            }
         }
         _labelField.text = getFullLabelText();
         _indeterminateBar.visible = _indeterminate;
         if(indeterminateChanged || visibleChanged)
         {
            indeterminateChanged = false;
            visibleChanged = false;
            _indeterminateBar.visible = _indeterminate;
            if(_indeterminate && _source == null && _mode == ProgressBarMode.EVENT && visible)
            {
               startPlayingIndeterminate();
            }
            else
            {
               stopPlayingIndeterminate();
            }
         }
         if(_indeterminate)
         {
            _determinateBar.setActualSize(_track.width,_track.height);
         }
         else
         {
            w = Math.max(0,_track.width * percentComplete / 100);
            _determinateBar.setActualSize(w,_track.height);
            _determinateBar.x = direction == ProgressBarDirection.RIGHT ? 0 : _track.width - w;
         }
      }
      
      public function set direction(value:String) : void
      {
         if(value == ProgressBarDirection.LEFT || value == ProgressBarDirection.RIGHT)
         {
            _direction = value;
         }
         invalidateDisplayList();
         dispatchEvent(new Event("directionChanged"));
      }
   }
}

