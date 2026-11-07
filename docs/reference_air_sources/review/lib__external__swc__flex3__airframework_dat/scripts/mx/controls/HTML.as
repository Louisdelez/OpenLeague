package mx.controls
{
   import flash.events.Event;
   import flash.events.HTMLUncaughtScriptExceptionEvent;
   import flash.events.MouseEvent;
   import flash.html.HTMLHistoryItem;
   import flash.html.HTMLHost;
   import flash.html.HTMLLoader;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.ClassFactory;
   import mx.core.EdgeMetrics;
   import mx.core.FlexHTMLLoader;
   import mx.core.IDataRenderer;
   import mx.core.IFactory;
   import mx.core.ScrollControlBase;
   import mx.core.ScrollPolicy;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.managers.IFocusManagerComponent;
   
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.6.0.12937";
      
      private static const MAX_HTML_WIDTH:Number = 2880;
      
      private static const MAX_HTML_HEIGHT:Number = 2880;
      
      private var _data:Object;
      
      private var _userAgent:String;
      
      private var _htmlLoaderFactory:IFactory = new ClassFactory(FlexHTMLLoader);
      
      private var _location:String;
      
      private var _runtimeApplicationDomain:ApplicationDomain;
      
      private var htmlTextChanged:Boolean = false;
      
      public var htmlLoader:HTMLLoader;
      
      private var _paintsDefaultBackground:Boolean;
      
      private var locationChanged:Boolean = false;
      
      private var htmlHostChanged:Boolean = false;
      
      private var _listData:BaseListData;
      
      private var _htmlText:String;
      
      private var _htmlHost:HTMLHost;
      
      private var paintsDefaultBackgroundChanged:Boolean = false;
      
      private var userAgentChanged:Boolean = false;
      
      private var runtimeApplicationDomainChanged:Boolean = false;
      
      private var textSet:Boolean;
      
      public function HTML()
      {
         super();
         mx_internal::_horizontalScrollPolicy = ScrollPolicy.AUTO;
         mx_internal::_verticalScrollPolicy = ScrollPolicy.AUTO;
         tabEnabled = false;
         tabChildren = true;
      }
      
      public static function get pdfCapability() : int
      {
         return HTMLLoader.pdfCapability;
      }
      
      public function get contentHeight() : Number
      {
         if(!htmlLoader)
         {
            return 0;
         }
         return htmlLoader.contentHeight;
      }
      
      public function get userAgent() : String
      {
         return _userAgent;
      }
      
      public function set userAgent(value:String) : void
      {
         _userAgent = value;
         userAgentChanged = true;
         invalidateProperties();
      }
      
      public function get loaded() : Boolean
      {
         if(!htmlLoader || locationChanged || htmlTextChanged)
         {
            return false;
         }
         return htmlLoader.loaded;
      }
      
      public function cancelLoad() : void
      {
         if(Boolean(htmlLoader))
         {
            htmlLoader.cancelLoad();
         }
      }
      
      private function htmlLoader_htmlRenderHandler(event:Event) : void
      {
         dispatchEvent(event);
         adjustScrollBars();
      }
      
      [Bindable("htmlLoaderFactoryChanged")]
      public function get htmlLoaderFactory() : IFactory
      {
         return _htmlLoaderFactory;
      }
      
      public function historyForward() : void
      {
         if(Boolean(htmlLoader))
         {
            htmlLoader.historyForward();
         }
      }
      
      public function set htmlLoaderFactory(value:IFactory) : void
      {
         _htmlLoaderFactory = value;
         dispatchEvent(new Event("htmlLoaderFactoryChanged"));
      }
      
      public function get historyLength() : int
      {
         if(!htmlLoader)
         {
            return 0;
         }
         return htmlLoader.historyLength;
      }
      
      public function reload() : void
      {
         if(Boolean(htmlLoader))
         {
            htmlLoader.reload();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!htmlLoader)
         {
            htmlLoader = htmlLoaderFactory.newInstance();
            htmlLoader.addEventListener(Event.HTML_DOM_INITIALIZE,htmlLoader_domInitialize);
            htmlLoader.addEventListener(Event.COMPLETE,htmlLoader_completeHandler);
            htmlLoader.addEventListener(Event.HTML_RENDER,htmlLoader_htmlRenderHandler);
            htmlLoader.addEventListener(Event.LOCATION_CHANGE,htmlLoader_locationChangeHandler);
            htmlLoader.addEventListener(Event.HTML_BOUNDS_CHANGE,htmlLoader_htmlBoundsChangeHandler);
            htmlLoader.addEventListener(Event.SCROLL,htmlLoader_scrollHandler);
            htmlLoader.addEventListener(HTMLUncaughtScriptExceptionEvent.UNCAUGHT_SCRIPT_EXCEPTION,htmlLoader_uncaughtScriptExceptionHandler);
            addChild(htmlLoader);
         }
      }
      
      public function historyGo(steps:int) : void
      {
         if(Boolean(htmlLoader))
         {
            htmlLoader.historyGo(steps);
         }
      }
      
      private function htmlLoader_domInitialize(event:Event) : void
      {
         dispatchEvent(event);
      }
      
      private function adjustScrollBars() : void
      {
         setScrollBarProperties(htmlLoader.contentWidth,htmlLoader.width,htmlLoader.contentHeight,htmlLoader.height);
         if(Boolean(verticalScrollBar))
         {
            verticalScrollBar.lineScrollSize = 20;
         }
         if(Boolean(horizontalScrollBar))
         {
            horizontalScrollBar.lineScrollSize = 20;
         }
      }
      
      [Inspectable(environment="none")]
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return _data;
      }
      
      [Bindable("locationChange")]
      public function get location() : String
      {
         return _location;
      }
      
      private function htmlLoader_completeHandler(event:Event) : void
      {
         invalidateSize();
         dispatchEvent(event);
      }
      
      public function set historyPosition(value:int) : void
      {
         if(Boolean(htmlLoader))
         {
            htmlLoader.historyPosition = value;
         }
      }
      
      public function getHistoryAt(position:int) : HTMLHistoryItem
      {
         if(!htmlLoader)
         {
            return null;
         }
         return htmlLoader.getHistoryAt(position);
      }
      
      public function get runtimeApplicationDomain() : ApplicationDomain
      {
         return _runtimeApplicationDomain;
      }
      
      override protected function scrollHandler(event:Event) : void
      {
         super.scrollHandler(event);
         htmlLoader.scrollH = horizontalScrollPosition;
         htmlLoader.scrollV = verticalScrollPosition;
      }
      
      public function historyBack() : void
      {
         if(Boolean(htmlLoader))
         {
            htmlLoader.historyBack();
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(htmlHostChanged)
         {
            htmlLoader.htmlHost = _htmlHost;
            htmlHostChanged = false;
         }
         if(paintsDefaultBackgroundChanged)
         {
            htmlLoader.paintsDefaultBackground = _paintsDefaultBackground;
            paintsDefaultBackgroundChanged = false;
         }
         if(runtimeApplicationDomainChanged)
         {
            htmlLoader.runtimeApplicationDomain = _runtimeApplicationDomain;
            runtimeApplicationDomainChanged = false;
         }
         if(userAgentChanged)
         {
            htmlLoader.userAgent = _userAgent;
            userAgentChanged = false;
         }
         if(locationChanged)
         {
            htmlLoader.load(new URLRequest(_location));
            locationChanged = false;
         }
         if(htmlTextChanged)
         {
            htmlLoader.loadString(_htmlText);
            htmlTextChanged = false;
         }
      }
      
      public function get contentWidth() : Number
      {
         if(!htmlLoader)
         {
            return 0;
         }
         return htmlLoader.contentWidth;
      }
      
      public function get domWindow() : Object
      {
         if(!htmlLoader)
         {
            return null;
         }
         return htmlLoader.window;
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
      
      override public function set verticalScrollPosition(value:Number) : void
      {
         value = Math.max(value,0);
         if(Boolean(htmlLoader) && htmlLoader.contentHeight > htmlLoader.height)
         {
            value = Math.min(value,htmlLoader.contentHeight - htmlLoader.height);
         }
         super.verticalScrollPosition = value;
         if(Boolean(htmlLoader))
         {
            htmlLoader.scrollV = value;
         }
         else
         {
            invalidateProperties();
         }
      }
      
      public function set data(value:Object) : void
      {
         var newText:* = undefined;
         _data = value;
         if(Boolean(_listData))
         {
            newText = _listData.label;
         }
         else if(_data != null)
         {
            if(_data is String)
            {
               newText = String(_data);
            }
            else
            {
               newText = _data.toString();
            }
         }
         if(newText !== undefined && !textSet)
         {
            htmlText = newText;
            textSet = false;
         }
         dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
      }
      
      private function htmlLoader_scrollHandler(event:Event) : void
      {
         horizontalScrollPosition = htmlLoader.scrollH;
         verticalScrollPosition = htmlLoader.scrollV;
      }
      
      public function get historyPosition() : int
      {
         if(!htmlLoader)
         {
            return 0;
         }
         return htmlLoader.historyPosition;
      }
      
      override protected function measure() : void
      {
         super.measure();
         var em:EdgeMetrics = viewMetrics;
         em.left += getStyle("paddingLeft");
         em.top += getStyle("paddingTop");
         em.right += getStyle("paddingRight");
         em.bottom += getStyle("paddingBottom");
         measuredWidth = Math.min(htmlLoader.contentWidth + em.left + em.right,MAX_HTML_WIDTH);
         measuredHeight = Math.min(htmlLoader.contentHeight + em.top + em.bottom,MAX_HTML_HEIGHT);
      }
      
      public function set listData(value:BaseListData) : void
      {
         _listData = value;
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
      
      private function htmlLoader_locationChangeHandler(event:Event) : void
      {
         var change:Boolean = _location != htmlLoader.location;
         _location = htmlLoader.location;
         if(change)
         {
            dispatchEvent(event);
         }
      }
      
      public function set htmlHost(value:HTMLHost) : void
      {
         _htmlHost = value;
         htmlHostChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(environment="none")]
      [Bindable("dataChange")]
      public function get listData() : BaseListData
      {
         return _listData;
      }
      
      public function set htmlText(value:String) : void
      {
         _htmlText = value;
         htmlTextChanged = true;
         _location = null;
         locationChanged = false;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new Event("htmlTextChanged"));
      }
      
      public function set location(value:String) : void
      {
         _location = value;
         locationChanged = true;
         _htmlText = null;
         htmlTextChanged = false;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new Event("locationChange"));
      }
      
      public function get htmlHost() : HTMLHost
      {
         return _htmlHost;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var em:EdgeMetrics = viewMetrics;
         em.left += getStyle("paddingLeft");
         em.top += getStyle("paddingTop");
         em.right += getStyle("paddingRight");
         em.bottom += getStyle("paddingBottom");
         htmlLoader.x = em.left;
         htmlLoader.y = em.top;
         var w:Number = Math.max(unscaledWidth - em.left - em.right,1);
         var h:Number = Math.max(unscaledHeight - em.top - em.bottom,1);
         htmlLoader.width = w;
         htmlLoader.height = h;
      }
      
      [Bindable("htmlTextChanged")]
      public function get htmlText() : String
      {
         return _htmlText;
      }
      
      private function htmlLoader_htmlBoundsChangeHandler(event:Event) : void
      {
         invalidateSize();
         adjustScrollBars();
      }
      
      public function get paintsDefaultBackground() : Boolean
      {
         return _paintsDefaultBackground;
      }
      
      public function set paintsDefaultBackground(value:Boolean) : void
      {
         _paintsDefaultBackground = value;
         paintsDefaultBackgroundChanged = true;
         invalidateProperties();
      }
      
      public function set runtimeApplicationDomain(value:ApplicationDomain) : void
      {
         _runtimeApplicationDomain = value;
         runtimeApplicationDomainChanged = true;
         invalidateProperties();
      }
   }
}

