package mx.core
{
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.system.ApplicationDomain;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import mx.events.ModuleEvent;
   import mx.events.RSLEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.utils.LoaderUtil;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class FlexModuleFactory extends MovieClip implements IFlexModuleFactory
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private static const INIT_STATE:int = 0;
      
      private static const RSL_START_LOAD_STATE:int = 1;
      
      private static const APP_LOAD_STATE:int = 2;
      
      private static const APP_START_STATE:int = 3;
      
      private static const APP_RUNNING_STATE:int = 4;
      
      private static const ERROR_STATE:int = 5;
      
      private static const RSL_LOADING_STATE:int = 6;
      
      private var rslListLoader:RSLListLoader;
      
      private var mixinList:Array;
      
      private var state:int = 0;
      
      private var appReady:Boolean = false;
      
      private var appInitDone:Boolean = false;
      
      private var appLoaded:Boolean = false;
      
      private var timer:Timer = null;
      
      private var lastFrame:int;
      
      private var nextFrameTimer:Timer = null;
      
      private var errorMessage:String = null;
      
      private var resourceBundles:Array;
      
      private var rslDataList:Array;
      
      private var _allowDomainsInNewRSLs:Boolean = true;
      
      private var _allowInsecureDomainsInNewRSLs:Boolean = true;
      
      private var implMap:Object = {};
      
      public function FlexModuleFactory()
      {
         super();
         this.mixinList = this.info()["mixins"];
         stop();
         loaderInfo.addEventListener(Event.INIT,this.moduleInitHandler);
         loaderInfo.addEventListener(Event.COMPLETE,this.moduleCompleteHandler);
         var docFrame:int = totalFrames == 1 ? 0 : 1;
         addEventListener(Event.ENTER_FRAME,this.docFrameListener);
         this.timer = new Timer(100);
         this.timer.addEventListener(TimerEvent.TIMER,this.timerHandler);
         this.timer.start();
      }
      
      private function docFrameListener(event:Event) : void
      {
         if(currentFrame == 2)
         {
            removeEventListener(Event.ENTER_FRAME,this.docFrameListener);
            if(totalFrames > 2)
            {
               addEventListener(Event.ENTER_FRAME,this.extraFrameListener);
            }
            this.docFrameHandler();
         }
      }
      
      private function extraFrameListener(event:Event) : void
      {
         if(this.lastFrame == currentFrame)
         {
            return;
         }
         this.lastFrame = currentFrame;
         if(currentFrame + 1 > totalFrames)
         {
            removeEventListener(Event.ENTER_FRAME,this.extraFrameListener);
         }
         this.extraFrameHandler();
      }
      
      public function get allowDomainsInNewRSLs() : Boolean
      {
         return this._allowDomainsInNewRSLs;
      }
      
      public function set allowDomainsInNewRSLs(value:Boolean) : void
      {
         this._allowDomainsInNewRSLs = value;
      }
      
      public function get allowInsecureDomainsInNewRSLs() : Boolean
      {
         return this._allowInsecureDomainsInNewRSLs;
      }
      
      public function set allowInsecureDomainsInNewRSLs(value:Boolean) : void
      {
         this._allowInsecureDomainsInNewRSLs = value;
      }
      
      public function get preloadedRSLs() : Dictionary
      {
         return null;
      }
      
      public function addPreloadedRSL(loaderInfo:LoaderInfo, rsl:Vector.<RSLData>) : void
      {
         var rslEvent:RSLEvent = null;
         this.preloadedRSLs[loaderInfo] = rsl;
         if(hasEventListener(RSLEvent.RSL_ADD_PRELOADED))
         {
            rslEvent = new RSLEvent(RSLEvent.RSL_ADD_PRELOADED);
            rslEvent.loaderInfo = loaderInfo;
            dispatchEvent(rslEvent);
         }
      }
      
      public function callInContext(fn:Function, thisArg:Object, argArray:Array, returns:Boolean = true) : *
      {
         return undefined;
      }
      
      public function create(... params) : Object
      {
         var url:String = null;
         var dot:Number = NaN;
         var slash:Number = NaN;
         var mainClassName:String = this.info()["mainClassName"];
         if(mainClassName == null)
         {
            url = loaderInfo.loaderURL;
            dot = url.lastIndexOf(".");
            slash = url.lastIndexOf("/");
            mainClassName = url.substring(slash + 1,dot);
         }
         var mainClass:Class = Class(this.getDefinitionByName(mainClassName));
         return Boolean(mainClass) ? new mainClass() : null;
      }
      
      public function info() : Object
      {
         return {};
      }
      
      public function allowDomain(... domains) : void
      {
      }
      
      public function allowInsecureDomain(... domains) : void
      {
      }
      
      public function registerImplementation(interfaceName:String, impl:Object) : void
      {
         var c:Object = this.implMap[interfaceName];
         if(!c)
         {
            this.implMap[interfaceName] = impl;
         }
      }
      
      public function getImplementation(interfaceName:String) : Object
      {
         return this.implMap[interfaceName];
      }
      
      public function getDefinitionByName(name:String) : Object
      {
         var definition:Object = null;
         var domain:ApplicationDomain = this.info()["currentDomain"] as ApplicationDomain;
         if(domain.hasDefinition(name))
         {
            definition = domain.getDefinition(name);
         }
         return definition;
      }
      
      private function update() : void
      {
         var n:int = 0;
         var i:int = 0;
         var c:Class = null;
         var tf:TextField = null;
         switch(this.state)
         {
            case INIT_STATE:
               if(!this.appInitDone)
               {
                  return;
               }
               this.getRSLInfo();
               if(this.rslListLoader.isDone())
               {
                  this.state = APP_LOAD_STATE;
               }
               else
               {
                  this.state = RSL_START_LOAD_STATE;
               }
               break;
            case RSL_START_LOAD_STATE:
               this.rslListLoader.load(null,this.rslCompleteHandler,this.rslErrorHandler,this.rslErrorHandler,this.rslErrorHandler);
               this.state = RSL_LOADING_STATE;
               break;
            case RSL_LOADING_STATE:
               if(this.rslListLoader.isDone())
               {
                  this.rslListLoader = null;
                  this.state = APP_LOAD_STATE;
               }
               break;
            case APP_LOAD_STATE:
               if(this.appLoaded)
               {
                  this.deferredNextFrame();
                  this.state = APP_START_STATE;
               }
               break;
            case APP_START_STATE:
               if(this.appReady)
               {
                  if(Boolean(this.mixinList) && this.mixinList.length > 0)
                  {
                     n = int(this.mixinList.length);
                     for(i = 0; i < n; i++)
                     {
                        try
                        {
                           c = Class(this.getDefinitionByName(this.mixinList[i]));
                           c["init"](this);
                        }
                        catch(e:Error)
                        {
                        }
                     }
                  }
                  this.state = APP_RUNNING_STATE;
                  this.timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
                  this.timer.reset();
                  dispatchEvent(new Event("ready"));
                  loaderInfo.removeEventListener(Event.COMPLETE,this.moduleCompleteHandler);
               }
               break;
            case ERROR_STATE:
               if(this.timer != null)
               {
                  this.timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
                  this.timer.reset();
               }
               tf = new TextField();
               tf.text = this.errorMessage;
               tf.x = 0;
               tf.y = 0;
               tf.autoSize = TextFieldAutoSize.LEFT;
               addChild(tf);
               dispatchEvent(new ModuleEvent(ModuleEvent.ERROR,false,false,0,0,this.errorMessage));
               loaderInfo.removeEventListener(Event.COMPLETE,this.moduleCompleteHandler);
         }
      }
      
      private function getRSLInfo() : void
      {
         var n:int = 0;
         var i:int = 0;
         var normalizedURL:String = null;
         var crossDomainRSLItem:Class = null;
         var rslWithFailovers:Array = null;
         var cdNode:Object = null;
         var node:RSLItem = null;
         var rsls:Array = this.info()["rsls"];
         var cdRsls:Array = this.info()["cdRsls"];
         var rslItemList:Array = [];
         if(Boolean(cdRsls) && cdRsls.length > 0)
         {
            this.rslDataList = LoaderUtil.processRequiredRSLs(this,cdRsls);
            normalizedURL = LoaderUtil.normalizeURL(this.loaderInfo);
            crossDomainRSLItem = Class(this.getDefinitionByName("mx.core::CrossDomainRSLItem"));
            n = int(this.rslDataList.length);
            for(i = 0; i < n; i++)
            {
               rslWithFailovers = this.rslDataList[i];
               cdNode = new crossDomainRSLItem(rslWithFailovers,normalizedURL,this);
               rslItemList.push(cdNode);
            }
         }
         if(rsls != null && rsls.length > 0)
         {
            if(normalizedURL == null)
            {
               normalizedURL = LoaderUtil.normalizeURL(this.loaderInfo);
            }
            n = int(rsls.length);
            for(i = 0; i < n; i++)
            {
               node = new RSLItem(rsls[i].url,normalizedURL,this);
               rslItemList.push(node);
            }
         }
         this.rslListLoader = new RSLListLoader(rslItemList);
      }
      
      public function autorun() : Boolean
      {
         return true;
      }
      
      private function displayError(msg:String) : void
      {
         this.errorMessage = msg;
         this.state = ERROR_STATE;
         this.update();
      }
      
      private function docFrameHandler(event:Event = null) : void
      {
         Singleton.registerClass("mx.managers::IBrowserManager",Class(this.getDefinitionByName("mx.managers::BrowserManagerImpl")));
         Singleton.registerClass("mx.managers::ICursorManager",Class(this.getDefinitionByName("mx.managers::CursorManagerImpl")));
         Singleton.registerClass("mx.managers::IDragManager",Class(this.getDefinitionByName("mx.managers::DragManagerImpl")));
         Singleton.registerClass("mx.managers::IHistoryManager",Class(this.getDefinitionByName("mx.managers::HistoryManagerImpl")));
         Singleton.registerClass("mx.managers::ILayoutManager",Class(this.getDefinitionByName("mx.managers::LayoutManager")));
         Singleton.registerClass("mx.managers::IPopUpManager",Class(this.getDefinitionByName("mx.managers::PopUpManagerImpl")));
         Singleton.registerClass("mx.resources::IResourceManager",Class(this.getDefinitionByName("mx.resources::ResourceManagerImpl")));
         Singleton.registerClass("mx.styles::IStyleManager",Class(this.getDefinitionByName("mx.styles::StyleManagerImpl")));
         Singleton.registerClass("mx.styles::IStyleManager2",Class(this.getDefinitionByName("mx.styles::StyleManagerImpl")));
         Singleton.registerClass("mx.managers::IToolTipManager2",Class(this.getDefinitionByName("mx.managers::ToolTipManagerImpl")));
         this.appReady = true;
         this.installCompiledResourceBundles();
         this.update();
         if(currentFrame < totalFrames)
         {
            this.deferredNextFrame();
         }
      }
      
      private function installCompiledResourceBundles() : void
      {
         var info:Object = this.info();
         var applicationDomain:ApplicationDomain = info["currentDomain"];
         var compiledLocales:Array = info["compiledLocales"];
         var compiledResourceBundleNames:Array = info["compiledResourceBundleNames"];
         var resourceManager:IResourceManager = ResourceManager.getInstance();
         this.resourceBundles = resourceManager.installCompiledResourceBundles(applicationDomain,compiledLocales,compiledResourceBundleNames,true);
         if(!resourceManager.localeChain)
         {
            resourceManager.initializeLocaleChain(compiledLocales);
         }
      }
      
      private function deferredNextFrame() : void
      {
         if(currentFrame + 1 <= framesLoaded)
         {
            nextFrame();
         }
         else
         {
            this.nextFrameTimer = new Timer(100);
            this.nextFrameTimer.addEventListener(TimerEvent.TIMER,this.nextFrameTimerHandler);
            this.nextFrameTimer.start();
         }
      }
      
      private function extraFrameHandler(event:Event = null) : void
      {
         var c:Class = null;
         var frameList:Object = this.info()["frames"];
         if(Boolean(frameList) && Boolean(frameList[currentLabel]))
         {
            try
            {
               c = Class(this.getDefinitionByName(frameList[currentLabel]));
               c["frame"](this);
            }
            catch(e:Error)
            {
            }
         }
         if(currentFrame < totalFrames)
         {
            this.deferredNextFrame();
         }
      }
      
      private function rslCompleteHandler(event:Event) : void
      {
         var rslIndex:int = 0;
         var rsl:Vector.<RSLData> = null;
         var moduleFactory:IFlexModuleFactory = null;
         if(event.target is LoaderInfo)
         {
            rslIndex = this.rslListLoader.getIndex();
            rsl = Vector.<RSLData>(this.rslDataList[rslIndex]);
            moduleFactory = this;
            if(Boolean(rsl) && Boolean(rsl[0].moduleFactory))
            {
               moduleFactory = rsl[0].moduleFactory;
            }
            if(moduleFactory == this)
            {
               this.preloadedRSLs[event.target] = rsl;
            }
            else
            {
               moduleFactory.addPreloadedRSL(LoaderInfo(event.target),rsl);
            }
         }
         this.update();
      }
      
      private function rslErrorHandler(event:Event) : void
      {
         var detailedError:String = null;
         var message:String = null;
         var rsl:RSLItem = this.rslListLoader.getItem(this.rslListLoader.getIndex());
         if(event is ErrorEvent)
         {
            detailedError = ErrorEvent(event).text;
         }
         if(!detailedError)
         {
            detailedError = "";
         }
         message = "RSL " + rsl.urlRequest.url + " failed to load. " + detailedError;
         this.displayError(message);
      }
      
      private function moduleInitHandler(event:Event) : void
      {
         loaderInfo.removeEventListener(Event.INIT,this.moduleInitHandler);
         this.appInitDone = true;
         this.update();
      }
      
      private function moduleCompleteHandler(event:Event) : void
      {
         this.appLoaded = true;
         this.update();
      }
      
      private function timerHandler(event:TimerEvent) : void
      {
         if(totalFrames > 2 && framesLoaded >= 2 || framesLoaded == totalFrames)
         {
            this.appLoaded = true;
         }
         this.update();
      }
      
      private function nextFrameTimerHandler(event:TimerEvent) : void
      {
         if(currentFrame + 1 <= framesLoaded)
         {
            nextFrame();
            this.nextFrameTimer.removeEventListener(TimerEvent.TIMER,this.nextFrameTimerHandler);
            this.nextFrameTimer.reset();
         }
      }
   }
}

