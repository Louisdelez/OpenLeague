package flexlib.containers
{
   import flash.events.MouseEvent;
   import mx.controls.Button;
   import mx.core.EdgeMetrics;
   import mx.core.IFactory;
   import mx.core.LayoutContainer;
   import mx.core.ScrollPolicy;
   import mx.effects.Resize;
   import mx.effects.effectClasses.ResizeInstance;
   import mx.events.EffectEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import mx.utils.StringUtil;
   
   [Style(name="toggleHeader",type="Boolean",inherit="no")]
   [Style(name="headerTextAlign",type="String",inherit="no")]
   [Style(name="headerStyleName",type="String",inherit="no")]
   [Style(name="headerClass",type="Class",inherit="no")]
   [Style(name="closeDuration",type="Number",format="Time",inherit="no")]
   [Style(name="openDuration",type="Number",format="Time",inherit="no")]
   [Style(name="closeIcon",type="Class",inherit="no")]
   [Style(name="openIcon",type="Class",inherit="no")]
   public class WindowShade extends LayoutContainer
   {
      
      [Embed(source="../assets/assets.swf",symbol="right_arrow")]
      private static var DEFAULT_CLOSE_ICON:Class = WindowShade_DEFAULT_CLOSE_ICON;
      
      [Embed(source="../assets/assets.swf",symbol="down_arrow")]
      private static var DEFAULT_OPEN_ICON:Class = WindowShade_DEFAULT_OPEN_ICON;
      
      private static var styleDefaults:Object = {
         "openDuration":250,
         "closeDuration":250,
         "paddingTop":10,
         "headerClass":Button,
         "headerTextAlign":"left",
         "toggleHeader":false,
         "headerStyleName":null,
         "closeIcon":DEFAULT_CLOSE_ICON,
         "openIcon":DEFAULT_OPEN_ICON
      };
      
      private static var classConstructed:Boolean = constructClass();
      
      private var _openedChanged:Boolean = false;
      
      private var _headerRenderer:IFactory;
      
      private var _viewMetrics:EdgeMetrics;
      
      private var resize:Resize;
      
      private var resizeInstance:ResizeInstance;
      
      private var _opened:Boolean = true;
      
      private var _headerButton:Button = null;
      
      private var headerChanged:Boolean;
      
      private var _headerLocation:String = "top";
      
      private var resetExplicitHeight:Boolean;
      
      public function WindowShade()
      {
         super();
         this.verticalScrollPolicy = ScrollPolicy.OFF;
         this.horizontalScrollPolicy = ScrollPolicy.OFF;
         addEventListener(EffectEvent.EFFECT_END,onEffectEnd);
      }
      
      private static function constructClass() : Boolean
      {
         var css:CSSStyleDeclaration = null;
         var changed:Boolean = false;
         var styleProp:String = null;
         css = StyleManager.getStyleDeclaration("WindowShade");
         changed = false;
         if(!css)
         {
            css = new CSSStyleDeclaration();
            changed = true;
         }
         for(styleProp in styleDefaults)
         {
            if(!StyleManager.isValidStyleValue(css.getStyle(styleProp)))
            {
               css.setStyle(styleProp,styleDefaults[styleProp]);
               changed = true;
            }
         }
         if(changed)
         {
            StyleManager.setStyleDeclaration("WindowShade",css,true);
         }
         return true;
      }
      
      public function get opened() : Boolean
      {
         return _opened;
      }
      
      protected function headerButton_clickHandler(event:MouseEvent) : void
      {
         opened = !_opened;
      }
      
      [Bindable(event="propertyChange")]
      public function set opened(value:Boolean) : void
      {
         var oldValue:Object = null;
         oldValue = this.opened;
         if(oldValue !== value)
         {
            this._1010579351opened = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"opened",oldValue,value));
         }
      }
      
      public function set headerRenderer(value:IFactory) : void
      {
         _headerRenderer = value;
         headerChanged = true;
         invalidateProperties();
      }
      
      override protected function measure() : void
      {
         super.measure();
         if(!_opened)
         {
            measuredHeight = _headerButton.getExplicitOrMeasuredHeight();
         }
      }
      
      public function get headerLocation() : String
      {
         return _headerLocation;
      }
      
      protected function runResizeEffect() : void
      {
         var duration:Number = NaN;
         var instances:Array = null;
         if(Boolean(resize) && Boolean(resize.isPlaying))
         {
            resize.end();
         }
         duration = _opened ? Number(getStyle("openDuration")) : Number(getStyle("closeDuration"));
         if(duration == 0)
         {
            this.setActualSize(getExplicitOrMeasuredWidth(),measuredHeight);
            invalidateSize();
            invalidateDisplayList();
            return;
         }
         resize = new Resize(this);
         resetExplicitHeight = isNaN(explicitHeight);
         resize.heightTo = Math.min(maxHeight,measuredHeight);
         resize.duration = duration;
         instances = resize.play();
         if(Boolean(instances) && Boolean(instances.length))
         {
            resizeInstance = instances[0];
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(headerChanged)
         {
            createOrReplaceHeaderButton();
            headerChanged = false;
         }
         if(_openedChanged)
         {
            if(_opened)
            {
               _headerButton.setStyle("icon",getStyle("openIcon"));
            }
            else
            {
               _headerButton.setStyle("icon",getStyle("closeIcon"));
            }
            _openedChanged = false;
         }
      }
      
      override public function set label(value:String) : void
      {
         super.label = value;
         if(Boolean(_headerButton))
         {
            _headerButton.label = value;
         }
      }
      
      protected function applyHeaderButtonStyles(button:Button) : void
      {
         var headerStyleName:String = null;
         button.setStyle("textAlign",getStyle("headerTextAlign"));
         headerStyleName = getStyle("headerStyleName");
         if(Boolean(headerStyleName))
         {
            headerStyleName = StringUtil.trim(headerStyleName);
            button.styleName = headerStyleName;
         }
         button.toggle = getStyle("toggleHeader");
         button.label = label;
         if(_opened)
         {
            button.setStyle("icon",getStyle("openIcon"));
         }
         else
         {
            button.setStyle("icon",getStyle("closeIcon"));
         }
         if(button.toggle)
         {
            button.selected = _opened;
         }
      }
      
      [Bindable]
      private function set _1010579351opened(value:Boolean) : void
      {
         var old:Boolean = false;
         old = _opened;
         _opened = value;
         _openedChanged = _openedChanged || old != _opened;
         if(_openedChanged && Boolean(initialized))
         {
            measure();
            runResizeEffect();
            invalidateProperties();
         }
      }
      
      override public function get viewMetrics() : EdgeMetrics
      {
         var vm:EdgeMetrics = null;
         var o:EdgeMetrics = null;
         var hHeight:Number = NaN;
         if(!_viewMetrics)
         {
            _viewMetrics = new EdgeMetrics(0,0,0,0);
         }
         vm = _viewMetrics;
         o = super.viewMetrics;
         vm.left = o.left;
         vm.top = o.top;
         vm.right = o.right;
         vm.bottom = o.bottom;
         hHeight = Number(_headerButton.getExplicitOrMeasuredHeight());
         if(!isNaN(hHeight))
         {
            if(_headerLocation == "top")
            {
               vm.top += hHeight;
            }
            else if(_headerLocation == "bottom")
            {
               vm.bottom += hHeight;
            }
         }
         return vm;
      }
      
      protected function onEffectEnd(evt:EffectEvent) : void
      {
         if(evt.effectInstance == resizeInstance)
         {
            if(resetExplicitHeight)
            {
               explicitHeight = NaN;
            }
            resizeInstance = null;
         }
      }
      
      public function get headerRenderer() : IFactory
      {
         return _headerRenderer;
      }
      
      protected function createOrReplaceHeaderButton() : void
      {
         var headerClass:Class = null;
         if(Boolean(_headerButton))
         {
            _headerButton.removeEventListener(MouseEvent.CLICK,headerButton_clickHandler);
            if(rawChildren.contains(_headerButton))
            {
               rawChildren.removeChild(_headerButton);
            }
         }
         if(Boolean(_headerRenderer))
         {
            _headerButton = _headerRenderer.newInstance() as Button;
         }
         else
         {
            headerClass = getStyle("headerClass");
            _headerButton = new headerClass();
         }
         applyHeaderButtonStyles(_headerButton);
         _headerButton.addEventListener(MouseEvent.CLICK,headerButton_clickHandler);
         rawChildren.addChild(_headerButton);
      }
      
      [Inspectable(enumeration="top,bottom",defaultValue="top")]
      [Bindable]
      private function set _871495326headerLocation(value:String) : void
      {
         _headerLocation = value;
         invalidateSize();
         invalidateDisplayList();
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable(enumeration="top,bottom",defaultValue="top")]
      public function set headerLocation(value:String) : void
      {
         var oldValue:Object = null;
         oldValue = this.headerLocation;
         if(oldValue !== value)
         {
            this._871495326headerLocation = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"headerLocation",oldValue,value));
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         createOrReplaceHeaderButton();
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         if(styleProp == "headerClass")
         {
            headerChanged = true;
            invalidateProperties();
         }
         else if(styleProp == "headerStyleName" || styleProp == "headerTextAlign" || styleProp == "toggleHeader" || styleProp == "openIcon" || styleProp == "closeIcon")
         {
            applyHeaderButtonStyles(_headerButton);
         }
         invalidateDisplayList();
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         super.updateDisplayList(w,h);
         if(_headerLocation == "top")
         {
            _headerButton.move(0,0);
         }
         else if(_headerLocation == "bottom")
         {
            _headerButton.move(0,h - _headerButton.getExplicitOrMeasuredHeight());
         }
         _headerButton.setActualSize(w,_headerButton.getExplicitOrMeasuredHeight());
      }
   }
}

