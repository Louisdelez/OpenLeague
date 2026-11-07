package mx.controls
{
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.HTTPStatusEvent;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.Capabilities;
   import flash.system.LoaderContext;
   import flash.system.SecurityDomain;
   import flash.utils.ByteArray;
   import mx.core.FlexGlobals;
   import mx.core.FlexLoader;
   import mx.core.FlexVersion;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModuleFactory;
   import mx.core.ILayoutDirectionElement;
   import mx.core.ISWFLoader;
   import mx.core.IUIComponent;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.InterManagerRequest;
   import mx.events.InvalidateRequestData;
   import mx.events.Request;
   import mx.events.SWFBridgeEvent;
   import mx.events.SWFBridgeRequest;
   import mx.managers.CursorManager;
   import mx.managers.IMarshalSystemManager;
   import mx.managers.ISystemManager;
   import mx.managers.SystemManagerGlobals;
   import mx.styles.ISimpleStyleClient;
   import mx.utils.LoaderUtil;
   
   use namespace mx_internal;
   
   [ResourceBundle("controls")]
   [IconFile("SWFLoader.png")]
   [DefaultTriggerEvent("progress")]
   [DefaultBindingProperty(source="percentLoaded",destination="source")]
   [Exclude(name="chromeColor",kind="style")]
   [Effect(name="completeEffect",event="complete")]
   [Style(name="verticalAlign",type="String",enumeration="bottom,middle,top",inherit="no")]
   [Style(name="horizontalAlign",type="String",enumeration="left,center,right",inherit="no")]
   [Style(name="brokenImageSkin",type="Class",inherit="no")]
   [Style(name="brokenImageBorderSkin",type="Class",inherit="no")]
   [Event(name="unload",type="flash.events.Event")]
   [Event(name="securityError",type="flash.events.SecurityErrorEvent")]
   [Event(name="progress",type="flash.events.ProgressEvent")]
   [Event(name="open",type="flash.events.Event")]
   [Event(name="ioError",type="flash.events.IOErrorEvent")]
   [Event(name="init",type="flash.events.Event")]
   [Event(name="httpStatus",type="flash.events.HTTPStatusEvent")]
   [Event(name="complete",type="flash.events.Event")]
   public class SWFLoader extends UIComponent implements ISWFLoader
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      mx_internal var contentHolder:DisplayObject;
      
      private var contentChanged:Boolean = false;
      
      private var scaleContentChanged:Boolean = false;
      
      private var smoothBitmapContentChanged:Boolean = false;
      
      private var isContentLoaded:Boolean = false;
      
      private var brokenImage:Boolean = false;
      
      private var resizableContent:Boolean = false;
      
      private var flexContent:Boolean = false;
      
      private var contentRequestID:String = null;
      
      private var attemptingChildAppDomain:Boolean = false;
      
      private var requestedURL:URLRequest;
      
      private var brokenImageBorder:IFlexDisplayObject;
      
      private var explicitLoaderContext:Boolean = false;
      
      private var mouseShield:Sprite;
      
      private var useUnloadAndStop:Boolean;
      
      private var unloadAndStopGC:Boolean;
      
      private var _autoLoad:Boolean = true;
      
      private var _loadForCompatibility:Boolean = false;
      
      private var _bytesLoaded:Number = NaN;
      
      private var _bytesTotal:Number = NaN;
      
      private var _loaderContext:LoaderContext;
      
      private var _maintainAspectRatio:Boolean = true;
      
      private var _swfBridge:IEventDispatcher;
      
      private var _scaleContent:Boolean = true;
      
      private var _showBusyCursor:Boolean = false;
      
      private var _smoothBitmapContent:Boolean = false;
      
      private var _source:Object;
      
      private var _trustContent:Boolean = false;
      
      public function SWFLoader()
      {
         super();
         tabEnabled = false;
         tabFocusEnabled = false;
         addEventListener(FlexEvent.INITIALIZE,this.initializeHandler);
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler);
         addEventListener(MouseEvent.CLICK,this.clickHandler);
         showInAutomationHierarchy = false;
      }
      
      [Inspectable(defaultValue="true")]
      [Bindable("autoLoadChanged")]
      public function get autoLoad() : Boolean
      {
         return this._autoLoad;
      }
      
      public function set autoLoad(value:Boolean) : void
      {
         if(this._autoLoad != value)
         {
            this._autoLoad = value;
            this.contentChanged = true;
            invalidateProperties();
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("autoLoadChanged"));
         }
      }
      
      [Inspectable(defaultValue="false")]
      [Bindable("loadForCompatibilityChanged")]
      public function get loadForCompatibility() : Boolean
      {
         return this._loadForCompatibility;
      }
      
      public function set loadForCompatibility(value:Boolean) : void
      {
         if(this._loadForCompatibility != value)
         {
            this._loadForCompatibility = value;
            this.contentChanged = true;
            invalidateProperties();
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("loadForCompatibilityChanged"));
         }
      }
      
      [Bindable("progress")]
      public function get bytesLoaded() : Number
      {
         return this._bytesLoaded;
      }
      
      [Bindable("complete")]
      public function get bytesTotal() : Number
      {
         return this._bytesTotal;
      }
      
      public function get content() : DisplayObject
      {
         if(this.contentHolder is Loader)
         {
            return Loader(this.contentHolder).content;
         }
         return this.contentHolder;
      }
      
      public function get contentHeight() : Number
      {
         return Boolean(this.contentHolder) ? this.contentHolder.height : NaN;
      }
      
      private function get contentHolderHeight() : Number
      {
         var loaderInfo:LoaderInfo = null;
         var mp:IMarshalSystemManager = null;
         var content:IFlexDisplayObject = null;
         var bridge:IEventDispatcher = null;
         var request:SWFBridgeRequest = null;
         var testContent:DisplayObject = null;
         if(this.contentHolder is Loader)
         {
            loaderInfo = Loader(this.contentHolder).contentLoaderInfo;
         }
         if(Boolean(loaderInfo))
         {
            if(loaderInfo.contentType == "application/x-shockwave-flash")
            {
               try
               {
                  mp = IMarshalSystemManager(systemManager.getImplementation("mx.managers::IMarshalSystemManager"));
                  if(Boolean(mp) && Boolean(mp.swfBridgeGroup))
                  {
                     bridge = this.swfBridge;
                     if(Boolean(bridge))
                     {
                        request = new SWFBridgeRequest(SWFBridgeRequest.GET_SIZE_REQUEST);
                        bridge.dispatchEvent(request);
                        return request.data.height;
                     }
                  }
                  content = Loader(this.contentHolder).content as IFlexDisplayObject;
                  if(Boolean(content))
                  {
                     return content.measuredHeight;
                  }
               }
               catch(error:Error)
               {
                  return contentHolder.height;
               }
            }
            else
            {
               try
               {
                  testContent = Loader(this.contentHolder).content;
               }
               catch(error:Error)
               {
                  return contentHolder.height;
               }
            }
            return loaderInfo.height;
         }
         if(this.contentHolder is IUIComponent)
         {
            return IUIComponent(this.contentHolder).getExplicitOrMeasuredHeight();
         }
         if(this.contentHolder is IFlexDisplayObject)
         {
            return IFlexDisplayObject(this.contentHolder).measuredHeight;
         }
         return this.contentHolder.height;
      }
      
      private function get contentHolderWidth() : Number
      {
         var loaderInfo:LoaderInfo = null;
         var content:IFlexDisplayObject = null;
         var request:SWFBridgeRequest = null;
         var testContent:DisplayObject = null;
         if(this.contentHolder is Loader)
         {
            loaderInfo = Loader(this.contentHolder).contentLoaderInfo;
         }
         if(Boolean(loaderInfo))
         {
            if(loaderInfo.contentType == "application/x-shockwave-flash")
            {
               try
               {
                  if(Boolean(this.swfBridge))
                  {
                     request = new SWFBridgeRequest(SWFBridgeRequest.GET_SIZE_REQUEST);
                     this.swfBridge.dispatchEvent(request);
                     return request.data.width;
                  }
                  content = Loader(this.contentHolder).content as IFlexDisplayObject;
                  if(Boolean(content))
                  {
                     return content.measuredWidth;
                  }
               }
               catch(error:Error)
               {
                  return contentHolder.width;
               }
            }
            else
            {
               try
               {
                  testContent = Loader(this.contentHolder).content;
               }
               catch(error:Error)
               {
                  return contentHolder.width;
               }
            }
            return loaderInfo.width;
         }
         if(this.contentHolder is IUIComponent)
         {
            return IUIComponent(this.contentHolder).getExplicitOrMeasuredWidth();
         }
         if(this.contentHolder is IFlexDisplayObject)
         {
            return IFlexDisplayObject(this.contentHolder).measuredWidth;
         }
         return this.contentHolder.width;
      }
      
      public function get contentWidth() : Number
      {
         return Boolean(this.contentHolder) ? this.contentHolder.width : NaN;
      }
      
      [Inspectable(defaultValue="true")]
      [Bindable("loaderContextChanged")]
      public function get loaderContext() : LoaderContext
      {
         return this._loaderContext;
      }
      
      public function set loaderContext(value:LoaderContext) : void
      {
         this._loaderContext = value;
         this.explicitLoaderContext = true;
         dispatchEvent(new Event("loaderContextChanged"));
      }
      
      [Inspectable(defaultValue="true")]
      [Bindable("maintainAspectRatioChanged")]
      public function get maintainAspectRatio() : Boolean
      {
         return this._maintainAspectRatio;
      }
      
      public function set maintainAspectRatio(value:Boolean) : void
      {
         this._maintainAspectRatio = value;
         dispatchEvent(new Event("maintainAspectRatioChanged"));
      }
      
      [Bindable("progress")]
      public function get percentLoaded() : Number
      {
         var p:Number = isNaN(this._bytesTotal) || this._bytesTotal == 0 ? 0 : 100 * (this._bytesLoaded / this._bytesTotal);
         if(isNaN(p))
         {
            p = 0;
         }
         return p;
      }
      
      [Inspectable(category="General",defaultValue="true")]
      [Bindable("scaleContentChanged")]
      public function get scaleContent() : Boolean
      {
         return this._scaleContent;
      }
      
      public function set scaleContent(value:Boolean) : void
      {
         if(this._scaleContent != value)
         {
            this._scaleContent = value;
            this.scaleContentChanged = true;
            invalidateDisplayList();
         }
         dispatchEvent(new Event("scaleContentChanged"));
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get showBusyCursor() : Boolean
      {
         return this._showBusyCursor;
      }
      
      public function set showBusyCursor(value:Boolean) : void
      {
         if(this._showBusyCursor != value)
         {
            this._showBusyCursor = value;
            if(this._showBusyCursor)
            {
               CursorManager.registerToUseBusyCursor(this);
            }
            else
            {
               CursorManager.unRegisterToUseBusyCursor(this);
            }
         }
      }
      
      [Inspectable(category="General",defaultValue="false")]
      [Bindable("smoothBitmapContentChanged")]
      public function get smoothBitmapContent() : Boolean
      {
         return this._smoothBitmapContent;
      }
      
      public function set smoothBitmapContent(value:Boolean) : void
      {
         if(this._smoothBitmapContent != value)
         {
            this._smoothBitmapContent = value;
            this.smoothBitmapContentChanged = true;
            invalidateDisplayList();
         }
         dispatchEvent(new Event("smoothBitmapContentChanged"));
      }
      
      [Inspectable(category="General",defaultValue="",format="File")]
      [Bindable("sourceChanged")]
      public function get source() : Object
      {
         return this._source;
      }
      
      public function set source(value:Object) : void
      {
         if(this._source != value)
         {
            this._source = value;
            this.contentChanged = true;
            invalidateProperties();
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("sourceChanged"));
         }
      }
      
      [Inspectable(defaultValue="false")]
      [Bindable("trustContentChanged")]
      public function get trustContent() : Boolean
      {
         return this._trustContent;
      }
      
      public function set trustContent(value:Boolean) : void
      {
         if(this._trustContent != value)
         {
            this._trustContent = value;
            invalidateProperties();
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("trustContentChanged"));
         }
      }
      
      public function get swfBridge() : IEventDispatcher
      {
         return this._swfBridge;
      }
      
      public function get childAllowsParent() : Boolean
      {
         if(!this.isContentLoaded)
         {
            return false;
         }
         try
         {
            if(this.contentHolder is Loader)
            {
               return Loader(this.contentHolder).contentLoaderInfo.childAllowsParent;
            }
         }
         catch(error:Error)
         {
            return false;
         }
         return true;
      }
      
      public function get parentAllowsChild() : Boolean
      {
         if(!this.isContentLoaded)
         {
            return false;
         }
         try
         {
            if(this.contentHolder is Loader)
            {
               return Loader(this.contentHolder).contentLoaderInfo.parentAllowsChild;
            }
         }
         catch(error:Error)
         {
            return false;
         }
         return true;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.contentChanged)
         {
            this.contentChanged = false;
            if(this._autoLoad)
            {
               this.load(this._source);
            }
         }
      }
      
      override protected function measure() : void
      {
         var oldScaleX:Number = NaN;
         var oldScaleY:Number = NaN;
         super.measure();
         if(this.isContentLoaded)
         {
            oldScaleX = this.contentHolder.scaleX;
            oldScaleY = this.contentHolder.scaleY;
            this.contentHolder.scaleX = 1;
            this.contentHolder.scaleY = 1;
            measuredWidth = this.contentHolderWidth;
            measuredHeight = this.contentHolderHeight;
            this.contentHolder.scaleX = oldScaleX;
            this.contentHolder.scaleY = oldScaleY;
         }
         else if(!this._source || this._source == "")
         {
            measuredWidth = 0;
            measuredHeight = 0;
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var skinClass:Class = null;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(this.contentChanged)
         {
            this.contentChanged = false;
            if(this._autoLoad)
            {
               this.load(this._source);
            }
         }
         if(this.isContentLoaded)
         {
            if(this._scaleContent && !this.brokenImage)
            {
               this.doScaleContent();
            }
            else
            {
               this.doScaleLoader();
            }
            this.scaleContentChanged = false;
            if(this.smoothBitmapContentChanged)
            {
               this.doSmoothBitmapContent();
               this.smoothBitmapContentChanged = false;
            }
         }
         if(this.brokenImage && !this.brokenImageBorder)
         {
            skinClass = getStyle("brokenImageBorderSkin");
            if(Boolean(skinClass))
            {
               this.brokenImageBorder = IFlexDisplayObject(new skinClass());
               if(this.brokenImageBorder is ISimpleStyleClient)
               {
                  ISimpleStyleClient(this.brokenImageBorder).styleName = this;
               }
               addChild(DisplayObject(this.brokenImageBorder));
            }
         }
         else if(!this.brokenImage && Boolean(this.brokenImageBorder))
         {
            removeChild(DisplayObject(this.brokenImageBorder));
            this.brokenImageBorder = null;
         }
         if(Boolean(this.brokenImageBorder))
         {
            this.brokenImageBorder.setActualSize(unscaledWidth,unscaledHeight);
         }
         this.sizeShield();
      }
      
      public function load(url:Object = null) : void
      {
         if(Boolean(url))
         {
            this._source = url;
         }
         this.unloadContent();
         this.isContentLoaded = false;
         this.brokenImage = false;
         this.useUnloadAndStop = false;
         this.contentChanged = false;
         if(!this._source || this._source == "")
         {
            return;
         }
         this.loadContent(this._source);
      }
      
      public function unloadAndStop(invokeGarbageCollector:Boolean = true) : void
      {
         this.useUnloadAndStop = true;
         this.unloadAndStopGC = invokeGarbageCollector;
         this.source = null;
         if(!this.autoLoad)
         {
            this.load(null);
         }
      }
      
      public function getVisibleApplicationRect(allApplications:Boolean = false) : Rectangle
      {
         var rect:Rectangle = getVisibleRect();
         if(allApplications)
         {
            rect = systemManager.getVisibleApplicationRect(rect);
         }
         return rect;
      }
      
      private function unloadContent() : void
      {
         var imageData:Bitmap = null;
         var contentLoader:Loader = null;
         var request:SWFBridgeEvent = null;
         if(Boolean(this.contentHolder))
         {
            if(this.isContentLoaded)
            {
               if(this.contentHolder is Loader)
               {
                  contentLoader = Loader(this.contentHolder);
                  try
                  {
                     if(contentLoader.content is Bitmap)
                     {
                        imageData = Bitmap(contentLoader.content);
                        if(Boolean(imageData.bitmapData))
                        {
                           imageData.bitmapData = null;
                        }
                     }
                  }
                  catch(error:Error)
                  {
                  }
                  if(Boolean(this._swfBridge))
                  {
                     request = new SWFBridgeEvent(SWFBridgeEvent.BRIDGE_APPLICATION_UNLOADING,false,false,this._swfBridge);
                     this._swfBridge.dispatchEvent(request);
                  }
                  if(contentLoader.contentLoaderInfo.contentType == "application/x-shockwave-flash" && contentLoader.contentLoaderInfo.parentAllowsChild && contentLoader.contentLoaderInfo.childAllowsParent && Boolean(contentLoader.content))
                  {
                     contentLoader.content.removeEventListener(Request.GET_PARENT_FLEX_MODULE_FACTORY_REQUEST,this.contentHolder_getFlexModuleFactoryRequestHandler);
                  }
                  this.contentHolder.removeEventListener(Event.ADDED,this.contentHolder_addedHandler);
                  this.removeInitSystemManagerCompleteListener(contentLoader.contentLoaderInfo);
                  if(this.useUnloadAndStop)
                  {
                     contentLoader.unloadAndStop(this.unloadAndStopGC);
                  }
                  else
                  {
                     contentLoader.unload();
                  }
                  if(!this.explicitLoaderContext)
                  {
                     this._loaderContext = null;
                  }
               }
               else if(this.contentHolder is Bitmap)
               {
                  imageData = Bitmap(this.contentHolder);
                  if(Boolean(imageData.bitmapData))
                  {
                     imageData.bitmapData = null;
                  }
               }
            }
            else if(this.contentHolder is Loader)
            {
               try
               {
                  Loader(this.contentHolder).close();
               }
               catch(error:Error)
               {
               }
            }
            try
            {
               if(this.contentHolder.parent == this)
               {
                  removeChild(this.contentHolder);
               }
            }
            catch(error:Error)
            {
               try
               {
                  removeChild(contentHolder);
               }
               catch(error1:Error)
               {
               }
            }
            this.contentHolder = null;
         }
      }
      
      private function loadContent(classOrString:Object) : void
      {
         var child:DisplayObject = null;
         var cls:Class = null;
         var url:String = null;
         var byteArray:ByteArray = null;
         var loader:Loader = null;
         var lc:LoaderContext = null;
         var rootURL:String = null;
         var currentDomain:ApplicationDomain = null;
         var appDomain:ApplicationDomain = null;
         var topmostDomain:ApplicationDomain = null;
         var message:String = null;
         if(classOrString is Class)
         {
            cls = Class(classOrString);
         }
         else if(classOrString is String)
         {
            try
            {
               cls = Class(systemManager.getDefinitionByName(String(classOrString)));
            }
            catch(e:Error)
            {
            }
            url = String(classOrString);
         }
         else if(classOrString is ByteArray)
         {
            byteArray = ByteArray(classOrString);
         }
         else
         {
            url = classOrString.toString();
         }
         if(Boolean(cls))
         {
            this.contentHolder = child = new cls();
            this.contentHolder.addEventListener(Event.ADDED,this.contentHolder_addedHandler,false,0,true);
            addChild(child);
            this.contentLoaded();
         }
         else if(classOrString is DisplayObject)
         {
            addChild(this.contentHolder = DisplayObject(classOrString));
            this.contentLoaded();
            this.contentHolder.addEventListener(Request.GET_PARENT_FLEX_MODULE_FACTORY_REQUEST,this.contentHolder_getFlexModuleFactoryRequestHandler);
         }
         else if(Boolean(byteArray))
         {
            loader = new FlexLoader();
            addChild(this.contentHolder = loader);
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.contentLoaderInfo_completeEventHandler);
            loader.contentLoaderInfo.addEventListener(Event.INIT,this.contentLoaderInfo_initEventHandler);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.contentLoaderInfo_ioErrorEventHandler);
            loader.contentLoaderInfo.addEventListener(Event.UNLOAD,this.contentLoaderInfo_unloadEventHandler);
            loader.loadBytes(byteArray,this.loaderContext);
         }
         else
         {
            if(!Boolean(url))
            {
               message = resourceManager.getString("controls","notLoadable",[this.source]);
               throw new Error(message);
            }
            loader = new FlexLoader();
            this.contentHolder = child = loader;
            addChild(loader);
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.contentLoaderInfo_completeEventHandler);
            loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.contentLoaderInfo_httpStatusEventHandler);
            loader.contentLoaderInfo.addEventListener(Event.INIT,this.contentLoaderInfo_initEventHandler);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.contentLoaderInfo_ioErrorEventHandler);
            loader.contentLoaderInfo.addEventListener(Event.OPEN,this.contentLoaderInfo_openEventHandler);
            loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.contentLoaderInfo_progressEventHandler);
            loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.contentLoaderInfo_securityErrorEventHandler);
            loader.contentLoaderInfo.addEventListener(Event.UNLOAD,this.contentLoaderInfo_unloadEventHandler);
            if(Capabilities.isDebugger == true && url.indexOf(".jpg") == -1 && LoaderUtil.normalizeURL(FlexGlobals.topLevelApplication.systemManager.loaderInfo).indexOf("debug=true") > -1)
            {
               url += url.indexOf("?") > -1 ? "&debug=true" : "?debug=true";
            }
            if(!(url.indexOf(":") > -1 || url.indexOf("/") == 0 || url.indexOf("\\") == 0))
            {
               if(SystemManagerGlobals.bootstrapLoaderInfoURL != null && SystemManagerGlobals.bootstrapLoaderInfoURL != "")
               {
                  rootURL = SystemManagerGlobals.bootstrapLoaderInfoURL;
               }
               else if(Boolean(root))
               {
                  rootURL = LoaderUtil.normalizeURL(root.loaderInfo);
               }
               else if(Boolean(systemManager))
               {
                  rootURL = LoaderUtil.normalizeURL(DisplayObject(systemManager).loaderInfo);
               }
               url = LoaderUtil.OSToPlayerURI(url,LoaderUtil.isLocal(Boolean(rootURL) ? rootURL : url));
               if(Boolean(rootURL))
               {
                  url = LoaderUtil.createAbsoluteURL(rootURL,url);
               }
            }
            else
            {
               url = LoaderUtil.OSToPlayerURI(url,LoaderUtil.isLocal(url));
            }
            this.requestedURL = new URLRequest(url);
            lc = this.loaderContext;
            if(!lc)
            {
               lc = new LoaderContext();
               this._loaderContext = lc;
               if(Boolean(moduleFactory) && FlexVersion.compatibilityVersion >= FlexVersion.VERSION_4_0)
               {
                  currentDomain = moduleFactory.info()["currentDomain"];
               }
               else
               {
                  currentDomain = ApplicationDomain.currentDomain;
               }
               if(this.loadForCompatibility)
               {
                  appDomain = currentDomain.parentDomain;
                  topmostDomain = null;
                  while(Boolean(appDomain))
                  {
                     topmostDomain = appDomain;
                     appDomain = appDomain.parentDomain;
                  }
                  lc.applicationDomain = new ApplicationDomain(topmostDomain);
               }
               if(this.trustContent)
               {
                  lc.securityDomain = SecurityDomain.currentDomain;
               }
               else if(!this.loadForCompatibility)
               {
                  this.attemptingChildAppDomain = true;
                  lc.applicationDomain = new ApplicationDomain(currentDomain);
               }
            }
            loader.load(this.requestedURL,lc);
         }
         if(Boolean(this.contentHolder) && this.contentHolder is ILayoutDirectionElement)
         {
            ILayoutDirectionElement(this.contentHolder).layoutDirection = null;
         }
         invalidateDisplayList();
      }
      
      protected function contentLoaded() : void
      {
         var loaderInfo:LoaderInfo = null;
         this.isContentLoaded = true;
         if(this.contentHolder is Loader)
         {
            loaderInfo = Loader(this.contentHolder).contentLoaderInfo;
         }
         this.resizableContent = false;
         if(Boolean(loaderInfo))
         {
            if(loaderInfo.contentType == "application/x-shockwave-flash")
            {
               this.resizableContent = true;
            }
            if(this.resizableContent)
            {
               try
               {
                  if(Loader(this.contentHolder).content is IFlexDisplayObject)
                  {
                     this.flexContent = true;
                  }
                  else
                  {
                     this.flexContent = this.swfBridge != null;
                  }
               }
               catch(e:Error)
               {
                  flexContent = swfBridge != null;
               }
            }
         }
         try
         {
            if(tabChildren && this.contentHolder is Loader && (loaderInfo.contentType == "application/x-shockwave-flash" || Loader(this.contentHolder).content is DisplayObjectContainer))
            {
               Loader(this.contentHolder).tabChildren = true;
               DisplayObjectContainer(Loader(this.contentHolder).content).tabChildren = true;
            }
         }
         catch(e:Error)
         {
         }
         invalidateSize();
         invalidateDisplayList();
      }
      
      private function doScaleContent() : void
      {
         var interiorWidth:Number = NaN;
         var interiorHeight:Number = NaN;
         var contentWidth:Number = NaN;
         var contentHeight:Number = NaN;
         var x:Number = NaN;
         var y:Number = NaN;
         var newXScale:Number = NaN;
         var newYScale:Number = NaN;
         var scale:Number = NaN;
         var w:Number = NaN;
         var h:Number = NaN;
         var holder:Loader = null;
         var sizeSet:Boolean = false;
         var lInfo:LoaderInfo = null;
         if(!this.isContentLoaded)
         {
            return;
         }
         if(!this.resizableContent || this.maintainAspectRatio && !this.flexContent)
         {
            this.unScaleContent();
            interiorWidth = unscaledWidth;
            interiorHeight = unscaledHeight;
            contentWidth = this.contentHolderWidth;
            contentHeight = this.contentHolderHeight;
            x = 0;
            y = 0;
            newXScale = contentWidth == 0 ? 1 : interiorWidth / contentWidth;
            newYScale = contentHeight == 0 ? 1 : interiorHeight / contentHeight;
            if(this._maintainAspectRatio)
            {
               if(newXScale > newYScale)
               {
                  x = Math.floor((interiorWidth - contentWidth * newYScale) * this.getHorizontalAlignValue());
                  scale = newYScale;
               }
               else
               {
                  y = Math.floor((interiorHeight - contentHeight * newXScale) * this.getVerticalAlignValue());
                  scale = newXScale;
               }
               this.contentHolder.scaleX = scale;
               this.contentHolder.scaleY = scale;
            }
            else
            {
               this.contentHolder.scaleX = newXScale;
               this.contentHolder.scaleY = newYScale;
            }
            this.contentHolder.x = x;
            this.contentHolder.y = y;
         }
         else
         {
            this.contentHolder.x = 0;
            this.contentHolder.y = 0;
            w = unscaledWidth;
            h = unscaledHeight;
            if(this.contentHolder is Loader)
            {
               holder = Loader(this.contentHolder);
               try
               {
                  if(this.getContentSize().x > 0)
                  {
                     sizeSet = false;
                     if(holder.contentLoaderInfo.contentType == "application/x-shockwave-flash")
                     {
                        if(this.childAllowsParent)
                        {
                           if(holder.content is IFlexDisplayObject)
                           {
                              IFlexDisplayObject(holder.content).setActualSize(w,h);
                              sizeSet = true;
                           }
                        }
                        if(!sizeSet && Boolean(this.swfBridge))
                        {
                           this.swfBridge.dispatchEvent(new SWFBridgeRequest(SWFBridgeRequest.SET_ACTUAL_SIZE_REQUEST,false,false,null,{
                              "width":w,
                              "height":h
                           }));
                           sizeSet = true;
                        }
                     }
                     if(!sizeSet)
                     {
                        lInfo = holder.contentLoaderInfo;
                        if(Boolean(lInfo))
                        {
                           this.contentHolder.scaleX = w / lInfo.width;
                           this.contentHolder.scaleY = h / lInfo.height;
                        }
                        else
                        {
                           this.contentHolder.width = w;
                           this.contentHolder.height = h;
                        }
                     }
                  }
                  else if(this.childAllowsParent && !(holder.content is IFlexDisplayObject))
                  {
                     this.contentHolder.width = w;
                     this.contentHolder.height = h;
                  }
               }
               catch(error:Error)
               {
                  contentHolder.width = w;
                  contentHolder.height = h;
               }
               if(!this.parentAllowsChild)
               {
                  this.contentHolder.scrollRect = new Rectangle(0,0,w / this.contentHolder.scaleX,h / this.contentHolder.scaleY);
               }
            }
            else
            {
               this.contentHolder.width = w;
               this.contentHolder.height = h;
            }
         }
      }
      
      private function doScaleLoader() : void
      {
         if(!this.isContentLoaded)
         {
            return;
         }
         this.unScaleContent();
         var w:Number = unscaledWidth;
         var h:Number = unscaledHeight;
         if(this.contentHolderWidth > w || this.contentHolderHeight > h || !this.parentAllowsChild)
         {
            this.contentHolder.scrollRect = new Rectangle(0,0,w,h);
         }
         else
         {
            this.contentHolder.scrollRect = null;
         }
         this.contentHolder.x = (w - this.contentHolderWidth) * this.getHorizontalAlignValue();
         this.contentHolder.y = (h - this.contentHolderHeight) * this.getVerticalAlignValue();
      }
      
      private function doSmoothBitmapContent() : void
      {
         if(this.content is Bitmap)
         {
            (this.content as Bitmap).smoothing = this._smoothBitmapContent;
         }
      }
      
      private function unScaleContent() : void
      {
         this.contentHolder.scaleX = 1;
         this.contentHolder.scaleY = 1;
         this.contentHolder.x = 0;
         this.contentHolder.y = 0;
      }
      
      private function getHorizontalAlignValue() : Number
      {
         var horizontalAlign:String = getStyle("horizontalAlign");
         if(horizontalAlign == "left")
         {
            return 0;
         }
         if(horizontalAlign == "right")
         {
            return 1;
         }
         return 0.5;
      }
      
      private function getVerticalAlignValue() : Number
      {
         var verticalAlign:String = getStyle("verticalAlign");
         if(verticalAlign == "top")
         {
            return 0;
         }
         if(verticalAlign == "bottom")
         {
            return 1;
         }
         return 0.5;
      }
      
      private function dispatchInvalidateRequest(invalidateProperites:Boolean, invalidateSize:Boolean, invalidateDisplayList:Boolean) : void
      {
         var sm:ISystemManager = systemManager;
         var mp:IMarshalSystemManager = IMarshalSystemManager(systemManager.getImplementation("mx.managers::IMarshalSystemManager"));
         if(!mp || !mp.useSWFBridge())
         {
            return;
         }
         var bridge:IEventDispatcher = mp.swfBridgeGroup.parentBridge;
         var flags:uint = 0;
         if(invalidateProperites)
         {
            flags |= InvalidateRequestData.PROPERTIES;
         }
         if(invalidateSize)
         {
            flags |= InvalidateRequestData.SIZE;
         }
         if(invalidateDisplayList)
         {
            flags |= InvalidateRequestData.DISPLAY_LIST;
         }
         var request:SWFBridgeRequest = new SWFBridgeRequest(SWFBridgeRequest.INVALIDATE_REQUEST,false,false,bridge,flags);
         bridge.dispatchEvent(request);
      }
      
      private function initializeHandler(event:FlexEvent) : void
      {
         if(this.contentChanged)
         {
            this.contentChanged = false;
            if(this._autoLoad)
            {
               this.load(this._source);
            }
         }
      }
      
      private function addedToStageHandler(event:Event) : void
      {
         systemManager.getSandboxRoot().addEventListener(InterManagerRequest.DRAG_MANAGER_REQUEST,this.mouseShieldHandler,false,0,true);
      }
      
      mx_internal function contentLoaderInfo_completeEventHandler(event:Event) : void
      {
         if(LoaderInfo(event.target).loader != this.contentHolder)
         {
            return;
         }
         dispatchEvent(event);
         this.contentLoaded();
      }
      
      private function contentLoaderInfo_httpStatusEventHandler(event:HTTPStatusEvent) : void
      {
         dispatchEvent(event);
      }
      
      private function contentLoaderInfo_initEventHandler(event:Event) : void
      {
         dispatchEvent(event);
         var loaderInfo:LoaderInfo = LoaderInfo(event.target);
         this.addInitSystemManagerCompleteListener(loaderInfo.loader.contentLoaderInfo);
         if(loaderInfo.contentType == "application/x-shockwave-flash" && loaderInfo.parentAllowsChild && loaderInfo.childAllowsParent && Boolean(loaderInfo.content))
         {
            loaderInfo.content.addEventListener(Request.GET_PARENT_FLEX_MODULE_FACTORY_REQUEST,this.contentHolder_getFlexModuleFactoryRequestHandler);
         }
      }
      
      private function addInitSystemManagerCompleteListener(loaderInfo:LoaderInfo) : void
      {
         var bridge:EventDispatcher = null;
         if(loaderInfo.contentType == "application/x-shockwave-flash")
         {
            bridge = loaderInfo.sharedEvents;
            bridge.addEventListener(SWFBridgeEvent.BRIDGE_NEW_APPLICATION,this.initSystemManagerCompleteEventHandler);
         }
      }
      
      private function removeInitSystemManagerCompleteListener(loaderInfo:LoaderInfo) : void
      {
         var bridge:EventDispatcher = null;
         if(loaderInfo.contentType == "application/x-shockwave-flash")
         {
            bridge = loaderInfo.sharedEvents;
            bridge.removeEventListener(SWFBridgeEvent.BRIDGE_NEW_APPLICATION,this.initSystemManagerCompleteEventHandler);
         }
      }
      
      private function contentLoaderInfo_ioErrorEventHandler(event:IOErrorEvent) : void
      {
         this.source = getStyle("brokenImageSkin");
         this.load();
         this.contentChanged = false;
         this.brokenImage = true;
         if(hasEventListener(event.type))
         {
            dispatchEvent(event);
         }
         if(this.contentHolder is Loader)
         {
            this.removeInitSystemManagerCompleteListener(Loader(this.contentHolder).contentLoaderInfo);
         }
      }
      
      private function contentLoaderInfo_openEventHandler(event:Event) : void
      {
         dispatchEvent(event);
      }
      
      private function contentLoaderInfo_progressEventHandler(event:ProgressEvent) : void
      {
         this._bytesTotal = event.bytesTotal;
         this._bytesLoaded = event.bytesLoaded;
         dispatchEvent(event);
      }
      
      private function contentLoaderInfo_securityErrorEventHandler(event:SecurityErrorEvent) : void
      {
         var lc:LoaderContext = null;
         if(this.attemptingChildAppDomain)
         {
            this.attemptingChildAppDomain = false;
            lc = new LoaderContext();
            this._loaderContext = lc;
            callLater(this.load);
            return;
         }
         dispatchEvent(event);
         if(this.contentHolder is Loader)
         {
            this.removeInitSystemManagerCompleteListener(Loader(this.contentHolder).contentLoaderInfo);
         }
      }
      
      private function contentLoaderInfo_unloadEventHandler(event:Event) : void
      {
         var sm:ISystemManager = null;
         var mp:IMarshalSystemManager = null;
         this.isContentLoaded = false;
         dispatchEvent(event);
         if(Boolean(this._swfBridge))
         {
            this._swfBridge.removeEventListener(SWFBridgeRequest.INVALIDATE_REQUEST,this.invalidateRequestHandler);
            sm = systemManager;
            mp = IMarshalSystemManager(systemManager.getImplementation("mx.managers::IMarshalSystemManager"));
            mp.removeChildBridge(this._swfBridge);
            this._swfBridge = null;
         }
      }
      
      private function contentHolder_getFlexModuleFactoryRequestHandler(request:Event) : void
      {
         if("value" in request)
         {
            request["value"] = moduleFactory;
         }
      }
      
      private function contentHolder_addedHandler(event:Event) : void
      {
         if(event.target == this.contentHolder)
         {
            return;
         }
         if(event.target is IFlexModuleFactory)
         {
            event.target.addEventListener(Request.GET_PARENT_FLEX_MODULE_FACTORY_REQUEST,this.contentHolder_getFlexModuleFactoryRequestHandler);
         }
         this.contentHolder.removeEventListener(Event.ADDED,this.contentHolder_addedHandler);
      }
      
      private function initSystemManagerCompleteEventHandler(event:Event) : void
      {
         var sm:ISystemManager = null;
         var eObj:Object = Object(event);
         if(this.contentHolder is Loader && eObj.data == Loader(this.contentHolder).contentLoaderInfo.sharedEvents)
         {
            this._swfBridge = Loader(this.contentHolder).contentLoaderInfo.sharedEvents;
            this.flexContent = true;
            this.unScaleContent();
            sm = systemManager;
            IMarshalSystemManager(sm.getImplementation("mx.managers::IMarshalSystemManager")).addChildBridge(this._swfBridge,this);
            this.removeInitSystemManagerCompleteListener(Loader(this.contentHolder).contentLoaderInfo);
            this._swfBridge.addEventListener(SWFBridgeRequest.INVALIDATE_REQUEST,this.invalidateRequestHandler);
         }
      }
      
      private function invalidateRequestHandler(event:Event) : void
      {
         if(event is SWFBridgeRequest)
         {
            return;
         }
         var request:SWFBridgeRequest = SWFBridgeRequest.marshal(event);
         var invalidateFlags:uint = uint(request.data);
         if(Boolean(invalidateFlags & InvalidateRequestData.PROPERTIES))
         {
            invalidateProperties();
         }
         if(Boolean(invalidateFlags & InvalidateRequestData.SIZE))
         {
            invalidateSize();
         }
         if(Boolean(invalidateFlags & InvalidateRequestData.DISPLAY_LIST))
         {
            invalidateDisplayList();
         }
         this.dispatchInvalidateRequest((invalidateFlags & InvalidateRequestData.PROPERTIES) != 0,(invalidateFlags & InvalidateRequestData.SIZE) != 0,(invalidateFlags & InvalidateRequestData.DISPLAY_LIST) != 0);
      }
      
      private function mouseShieldHandler(event:Event) : void
      {
         if(event["name"] != "mouseShield")
         {
            return;
         }
         if(!this.isContentLoaded || this.parentAllowsChild)
         {
            return;
         }
         if(Boolean(event["value"]))
         {
            if(!this.mouseShield)
            {
               this.mouseShield = new Sprite();
               this.mouseShield.graphics.beginFill(0,0);
               this.mouseShield.graphics.drawRect(0,0,100,100);
               this.mouseShield.graphics.endFill();
            }
            if(!this.mouseShield.parent)
            {
               addChild(this.mouseShield);
            }
            this.sizeShield();
         }
         else if(Boolean(this.mouseShield) && Boolean(this.mouseShield.parent))
         {
            removeChild(this.mouseShield);
         }
      }
      
      private function sizeShield() : void
      {
         if(Boolean(this.mouseShield) && Boolean(this.mouseShield.parent))
         {
            this.mouseShield.width = unscaledWidth;
            this.mouseShield.height = unscaledHeight;
         }
      }
      
      override public function regenerateStyleCache(recursive:Boolean) : void
      {
         var sm:ISystemManager = null;
         var cm:Object = null;
         super.regenerateStyleCache(recursive);
         try
         {
            sm = this.content as ISystemManager;
            if(sm != null)
            {
               cm = sm.getImplementation("mx.managers::ISystemManagerChildManager");
               Object(cm).regenerateStyleCache(recursive);
            }
         }
         catch(error:Error)
         {
         }
      }
      
      override public function notifyStyleChangeInChildren(styleProp:String, recursive:Boolean) : void
      {
         var sm:ISystemManager = null;
         var cm:Object = null;
         super.notifyStyleChangeInChildren(styleProp,recursive);
         try
         {
            sm = this.content as ISystemManager;
            if(sm != null)
            {
               cm = sm.getImplementation("mx.managers::ISystemManagerChildManager");
               Object(cm).notifyStyleChangeInChildren(styleProp,recursive);
            }
         }
         catch(error:Error)
         {
         }
      }
      
      private function getContentSize() : Point
      {
         var bridge:IEventDispatcher = null;
         var request:SWFBridgeRequest = null;
         var pt:Point = new Point();
         if(!this.contentHolder is Loader)
         {
            return pt;
         }
         var holder:Loader = Loader(this.contentHolder);
         if(holder.contentLoaderInfo.childAllowsParent)
         {
            pt.x = holder.content.width;
            pt.y = holder.content.height;
         }
         else
         {
            bridge = this.swfBridge;
            if(Boolean(bridge))
            {
               request = new SWFBridgeRequest(SWFBridgeRequest.GET_SIZE_REQUEST);
               bridge.dispatchEvent(request);
               pt.x = request.data.width;
               pt.y = request.data.height;
            }
         }
         if(pt.x == 0)
         {
            pt.x = holder.contentLoaderInfo.width;
         }
         if(pt.y == 0)
         {
            pt.y = holder.contentLoaderInfo.height;
         }
         return pt;
      }
      
      protected function clickHandler(event:MouseEvent) : void
      {
         if(!enabled)
         {
            event.stopImmediatePropagation();
            return;
         }
      }
   }
}

