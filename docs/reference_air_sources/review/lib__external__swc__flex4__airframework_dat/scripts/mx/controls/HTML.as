package mx.controls
{
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.HTMLUncaughtScriptExceptionEvent;
   import flash.events.MouseEvent;
   import flash.html.HTMLHistoryItem;
   import flash.html.HTMLHost;
   import flash.html.HTMLLoader;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.IME;
   import flash.system.IMEConversionMode;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.ClassFactory;
   import mx.core.EdgeMetrics;
   import mx.core.FlexHTMLLoader;
   import mx.core.IDataRenderer;
   import mx.core.IFactory;
   import mx.core.IIMESupport;
   import mx.core.ScrollControlBase;
   import mx.core.ScrollPolicy;
   import mx.events.FlexEvent;
   import mx.managers.IFocusManagerComponent;
   
   [ResourceBundle("controls")]
   [IconFile("HTML.png")]
   [Style(name="paddingTop",type="Number",format="Length",inherit="no")]
   [Style(name="paddingRight",type="Number",format="Length",inherit="no")]
   [Style(name="paddingLeft",type="Number",format="Length",inherit="no")]
   [Style(name="paddingBottom",type="Number",format="Length",inherit="no")]
   [Event(name="uncaughtScriptException",type="flash.events.HTMLUncaughtScriptExceptionEvent")]
   [Event(name="locationChange",type="flash.events.Event")]
   [Event(name="htmlRender",type="flash.events.Event")]
   [Event(name="htmlDOMInitialize",type="flash.events.Event")]
   [Event(name="complete",type="flash.events.Event")]
   public class HTML extends ScrollControlBase implements IDataRenderer, IDropInListItemRenderer, IListItemRenderer, IFocusManagerComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const MAX_HTML_WIDTH:Number = 2880;
      
      private static const MAX_HTML_HEIGHT:Number = 2880;
      
      private var textSet:Boolean;
      
      private var errorCaught:Boolean = false;
      
      private var _data:Object;
      
      public var htmlLoader:HTMLLoader;
      
      private var _htmlLoaderFactory:IFactory = new ClassFactory(FlexHTMLLoader);
      
      private var _htmlHost:HTMLHost;
      
      private var htmlHostChanged:Boolean = false;
      
      private var _htmlText:String;
      
      private var htmlTextChanged:Boolean = false;
      
      private var _imeMode:String = null;
      
      private var _listData:BaseListData;
      
      private var _location:String;
      
      private var locationChanged:Boolean = false;
      
      private var _paintsDefaultBackground:Boolean;
      
      private var paintsDefaultBackgroundChanged:Boolean = false;
      
      private var _runtimeApplicationDomain:ApplicationDomain;
      
      private var runtimeApplicationDomainChanged:Boolean = false;
      
      private var _userAgent:String;
      
      private var userAgentChanged:Boolean = false;
      
      public function HTML()
      {
         super();
         _horizontalScrollPolicy = ScrollPolicy.AUTO;
         _verticalScrollPolicy = ScrollPolicy.AUTO;
         tabFocusEnabled = false;
      }
      
      public static function get pdfCapability() : int
      {
         return HTMLLoader.pdfCapability;
      }
      
      override public function set verticalScrollPosition(value:Number) : void
      {
         value = Math.max(value,0);
         if(Boolean(this.htmlLoader) && this.htmlLoader.contentHeight > this.htmlLoader.height)
         {
            value = Math.min(value,this.htmlLoader.contentHeight - this.htmlLoader.height);
         }
         super.verticalScrollPosition = value;
         if(Boolean(this.htmlLoader))
         {
            this.htmlLoader.scrollV = value;
         }
         else
         {
            invalidateProperties();
         }
      }
      
      public function get contentHeight() : Number
      {
         if(!this.htmlLoader)
         {
            return 0;
         }
         return this.htmlLoader.contentHeight;
      }
      
      public function get contentWidth() : Number
      {
         if(!this.htmlLoader)
         {
            return 0;
         }
         return this.htmlLoader.contentWidth;
      }
      
      [Inspectable(environment="none")]
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(value:Object) : void
      {
         var newText:* = undefined;
         this._data = value;
         if(Boolean(this._listData))
         {
            newText = this._listData.label;
         }
         else if(this._data != null)
         {
            if(this._data is String)
            {
               newText = String(this._data);
            }
            else
            {
               newText = this._data.toString();
            }
         }
         if(newText !== undefined && !this.textSet)
         {
            this.htmlText = newText;
            this.textSet = false;
         }
         dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
      }
      
      public function get historyLength() : int
      {
         if(!this.htmlLoader)
         {
            return 0;
         }
         return this.htmlLoader.historyLength;
      }
      
      public function get historyPosition() : int
      {
         if(!this.htmlLoader)
         {
            return 0;
         }
         return this.htmlLoader.historyPosition;
      }
      
      public function set historyPosition(value:int) : void
      {
         if(Boolean(this.htmlLoader))
         {
            this.htmlLoader.historyPosition = value;
         }
      }
      
      [Bindable("htmlLoaderFactoryChanged")]
      public function get htmlLoaderFactory() : IFactory
      {
         return this._htmlLoaderFactory;
      }
      
      public function set htmlLoaderFactory(value:IFactory) : void
      {
         this._htmlLoaderFactory = value;
         dispatchEvent(new Event("htmlLoaderFactoryChanged"));
      }
      
      public function get htmlHost() : HTMLHost
      {
         return this._htmlHost;
      }
      
      public function set htmlHost(value:HTMLHost) : void
      {
         this._htmlHost = value;
         this.htmlHostChanged = true;
         invalidateProperties();
      }
      
      [Bindable("htmlTextChanged")]
      public function get htmlText() : String
      {
         return this._htmlText;
      }
      
      public function set htmlText(value:String) : void
      {
         this._htmlText = value;
         this.htmlTextChanged = true;
         this._location = null;
         this.locationChanged = false;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new Event("htmlTextChanged"));
      }
      
      public function get domWindow() : Object
      {
         if(!this.htmlLoader)
         {
            return null;
         }
         return this.htmlLoader.window;
      }
      
      public function get imeMode() : String
      {
         return this._imeMode;
      }
      
      public function set imeMode(value:String) : void
      {
         this._imeMode = value;
      }
      
      [Inspectable(environment="none")]
      [Bindable("dataChange")]
      public function get listData() : BaseListData
      {
         return this._listData;
      }
      
      public function set listData(value:BaseListData) : void
      {
         this._listData = value;
      }
      
      public function get loaded() : Boolean
      {
         if(!this.htmlLoader || this.locationChanged || this.htmlTextChanged)
         {
            return false;
         }
         return this.htmlLoader.loaded;
      }
      
      [Bindable("locationChange")]
      public function get location() : String
      {
         return this._location;
      }
      
      public function set location(value:String) : void
      {
         this._location = value;
         this.locationChanged = true;
         this._htmlText = null;
         this.htmlTextChanged = false;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new Event("locationChange"));
      }
      
      public function get paintsDefaultBackground() : Boolean
      {
         return this._paintsDefaultBackground;
      }
      
      public function set paintsDefaultBackground(value:Boolean) : void
      {
         this._paintsDefaultBackground = value;
         this.paintsDefaultBackgroundChanged = true;
         invalidateProperties();
      }
      
      public function get runtimeApplicationDomain() : ApplicationDomain
      {
         return this._runtimeApplicationDomain;
      }
      
      public function set runtimeApplicationDomain(value:ApplicationDomain) : void
      {
         this._runtimeApplicationDomain = value;
         this.runtimeApplicationDomainChanged = true;
         invalidateProperties();
      }
      
      public function get userAgent() : String
      {
         return this._userAgent;
      }
      
      public function set userAgent(value:String) : void
      {
         this._userAgent = value;
         this.userAgentChanged = true;
         invalidateProperties();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!this.htmlLoader)
         {
            this.htmlLoader = this.htmlLoaderFactory.newInstance();
            this.htmlLoader.addEventListener(Event.HTML_DOM_INITIALIZE,this.htmlLoader_domInitialize);
            this.htmlLoader.addEventListener(Event.COMPLETE,this.htmlLoader_completeHandler);
            this.htmlLoader.addEventListener(Event.HTML_RENDER,this.htmlLoader_htmlRenderHandler);
            this.htmlLoader.addEventListener(Event.LOCATION_CHANGE,this.htmlLoader_locationChangeHandler);
            this.htmlLoader.addEventListener(Event.HTML_BOUNDS_CHANGE,this.htmlLoader_htmlBoundsChangeHandler);
            this.htmlLoader.addEventListener(Event.SCROLL,this.htmlLoader_scrollHandler);
            this.htmlLoader.addEventListener(HTMLUncaughtScriptExceptionEvent.UNCAUGHT_SCRIPT_EXCEPTION,this.htmlLoader_uncaughtScriptExceptionHandler);
            addChild(this.htmlLoader);
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.htmlHostChanged)
         {
            this.htmlLoader.htmlHost = this._htmlHost;
            this.htmlHostChanged = false;
         }
         if(this.paintsDefaultBackgroundChanged)
         {
            this.htmlLoader.paintsDefaultBackground = this._paintsDefaultBackground;
            this.paintsDefaultBackgroundChanged = false;
         }
         if(this.runtimeApplicationDomainChanged)
         {
            this.htmlLoader.runtimeApplicationDomain = this._runtimeApplicationDomain;
            this.runtimeApplicationDomainChanged = false;
         }
         if(this.userAgentChanged)
         {
            this.htmlLoader.userAgent = this._userAgent;
            this.userAgentChanged = false;
         }
         if(this.locationChanged)
         {
            this.htmlLoader.load(new URLRequest(this._location));
            this.locationChanged = false;
         }
         if(this.htmlTextChanged)
         {
            this.htmlLoader.loadString(this._htmlText);
            this.htmlTextChanged = false;
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         var em:EdgeMetrics = viewMetrics;
         em.left += getStyle("paddingLeft");
         em.top += getStyle("paddingTop");
         em.right += getStyle("paddingRight");
         em.bottom += getStyle("paddingBottom");
         measuredWidth = Math.min(this.htmlLoader.contentWidth + em.left + em.right,MAX_HTML_WIDTH);
         measuredHeight = Math.min(this.htmlLoader.contentHeight + em.top + em.bottom,MAX_HTML_HEIGHT);
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var em:EdgeMetrics = viewMetrics;
         em.left += getStyle("paddingLeft");
         em.top += getStyle("paddingTop");
         em.right += getStyle("paddingRight");
         em.bottom += getStyle("paddingBottom");
         this.htmlLoader.x = em.left;
         this.htmlLoader.y = em.top;
         var w:Number = Math.max(unscaledWidth - em.left - em.right,1);
         var h:Number = Math.max(unscaledHeight - em.top - em.bottom,1);
         this.htmlLoader.width = w;
         this.htmlLoader.height = h;
      }
      
      public function cancelLoad() : void
      {
         if(Boolean(this.htmlLoader))
         {
            this.htmlLoader.cancelLoad();
         }
      }
      
      public function getHistoryAt(position:int) : HTMLHistoryItem
      {
         if(!this.htmlLoader)
         {
            return null;
         }
         return this.htmlLoader.getHistoryAt(position);
      }
      
      public function historyBack() : void
      {
         if(Boolean(this.htmlLoader))
         {
            this.htmlLoader.historyBack();
         }
      }
      
      public function historyForward() : void
      {
         if(Boolean(this.htmlLoader))
         {
            this.htmlLoader.historyForward();
         }
      }
      
      public function historyGo(steps:int) : void
      {
         if(Boolean(this.htmlLoader))
         {
            this.htmlLoader.historyGo(steps);
         }
      }
      
      public function reload() : void
      {
         if(Boolean(this.htmlLoader))
         {
            this.htmlLoader.reload();
         }
      }
      
      private function adjustScrollBars() : void
      {
         setScrollBarProperties(this.htmlLoader.contentWidth,this.htmlLoader.width,this.htmlLoader.contentHeight,this.htmlLoader.height);
         if(Boolean(verticalScrollBar))
         {
            verticalScrollBar.lineScrollSize = 20;
         }
         if(Boolean(horizontalScrollBar))
         {
            horizontalScrollBar.lineScrollSize = 20;
         }
      }
      
      override protected function focusInHandler(event:FocusEvent) : void
      {
         var message:String = null;
         super.focusInHandler(event);
         if(this._imeMode != null && (this.htmlLoader is IIMESupport && Boolean(IIMESupport(this.htmlLoader).enableIME)))
         {
            try
            {
               if(!this.errorCaught && IME.conversionMode != IMEConversionMode.UNKNOWN)
               {
                  IME.conversionMode = this._imeMode;
               }
               this.errorCaught = false;
            }
            catch(e:Error)
            {
               errorCaught = true;
               message = resourceManager.getString("controls","unsupportedMode",[_imeMode]);
               throw new Error(message);
            }
         }
      }
      
      override protected function scrollHandler(event:Event) : void
      {
         super.scrollHandler(event);
         this.htmlLoader.scrollH = horizontalScrollPosition;
         this.htmlLoader.scrollV = verticalScrollPosition;
      }
      
      override protected function mouseWheelHandler(event:MouseEvent) : void
      {
         if(event.target != this)
         {
            return;
         }
         event.delta *= 6;
         super.mouseWheelHandler(event);
      }
      
      private function htmlLoader_domInitialize(event:Event) : void
      {
         dispatchEvent(event);
      }
      
      private function htmlLoader_completeHandler(event:Event) : void
      {
         invalidateSize();
         dispatchEvent(event);
      }
      
      private function htmlLoader_htmlRenderHandler(event:Event) : void
      {
         dispatchEvent(event);
         this.adjustScrollBars();
         hasFocusableChildren = this.htmlLoader.hasFocusableContent;
      }
      
      private function htmlLoader_locationChangeHandler(event:Event) : void
      {
         var change:Boolean = this._location != this.htmlLoader.location;
         this._location = this.htmlLoader.location;
         if(change)
         {
            dispatchEvent(event);
         }
      }
      
      private function htmlLoader_htmlBoundsChangeHandler(event:Event) : void
      {
         invalidateSize();
         this.adjustScrollBars();
      }
      
      private function htmlLoader_scrollHandler(event:Event) : void
      {
         horizontalScrollPosition = this.htmlLoader.scrollH;
         this.verticalScrollPosition = this.htmlLoader.scrollV;
      }
      
      private function htmlLoader_uncaughtScriptExceptionHandler(event:HTMLUncaughtScriptExceptionEvent) : void
      {
         var clonedEvent:Event = event.clone();
         dispatchEvent(clonedEvent);
         if(clonedEvent.isDefaultPrevented())
         {
            event.preventDefault();
         }
      }
   }
}

