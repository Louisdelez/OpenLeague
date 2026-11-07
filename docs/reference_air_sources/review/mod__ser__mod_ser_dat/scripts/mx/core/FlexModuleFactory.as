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
   import flash.utils.getDefinitionByName;
   import mx.events.ModuleEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   use namespace mx_internal;
   
   public class FlexModuleFactory extends MovieClip implements IFlexModuleFactory
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static const INIT_STATE:int = 0;
      
      private static const RSL_START_LOAD_STATE:int = 1;
      
      private static const APP_LOAD_STATE:int = 2;
      
      private static const APP_START_STATE:int = 3;
      
      private static const APP_RUNNING_STATE:int = 4;
      
      private static const ERROR_STATE:int = 5;
      
      private static const RSL_LOADING_STATE:int = 6;
      
      private var appReady:Boolean = false;
      
      private var timer:Timer = null;
      
      private var appLoaded:Boolean = false;
      
      private var rslListLoader:RSLListLoader;
      
      private var state:int = 0;
      
      private var errorMessage:String = null;
      
      private var nextFrameTimer:Timer = null;
      
      private var lastFrame:int;
      
      private var mixinList:Array;
      
      public function FlexModuleFactory()
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc7_:Class = null;
         var _loc8_:Object = null;
         var _loc9_:RSLItem = null;
         super();
         var _loc1_:Array = info()["rsls"];
         var _loc2_:Array = info()["cdRsls"];
         var _loc3_:Array = [];
         if(Boolean(_loc2_) && _loc2_.length > 0)
         {
            _loc7_ = Class(getDefinitionByName("mx.core::CrossDomainRSLItem"));
            _loc4_ = int(_loc2_.length);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc8_ = new _loc7_(_loc2_[_loc5_]["rsls"],_loc2_[_loc5_]["policyFiles"],_loc2_[_loc5_]["digests"],_loc2_[_loc5_]["types"],_loc2_[_loc5_]["isSigned"]);
               _loc3_.push(_loc8_);
               _loc5_++;
            }
         }
         if(_loc1_ != null && _loc1_.length > 0)
         {
            _loc4_ = int(_loc1_.length);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc9_ = new RSLItem(_loc1_[_loc5_].url);
               _loc3_.push(_loc9_);
               _loc5_++;
            }
         }
         rslListLoader = new RSLListLoader(_loc3_);
         mixinList = info()["mixins"];
         stop();
         loaderInfo.addEventListener(Event.COMPLETE,moduleCompleteHandler);
         var _loc6_:int = totalFrames == 1 ? 0 : 1;
         addEventListener(Event.ENTER_FRAME,docFrameListener);
         timer = new Timer(100);
         timer.addEventListener(TimerEvent.TIMER,timerHandler);
         timer.start();
         update();
      }
      
      private function update() : void
      {
         var n:int = 0;
         var i:int = 0;
         var c:Class = null;
         var tf:TextField = null;
         switch(state)
         {
            case INIT_STATE:
               if(rslListLoader.isDone())
               {
                  state = APP_LOAD_STATE;
               }
               else
               {
                  state = RSL_START_LOAD_STATE;
               }
               break;
            case RSL_START_LOAD_STATE:
               rslListLoader.load(null,rslCompleteHandler,rslErrorHandler,rslErrorHandler,rslErrorHandler);
               state = RSL_LOADING_STATE;
               break;
            case RSL_LOADING_STATE:
               if(rslListLoader.isDone())
               {
                  state = APP_LOAD_STATE;
               }
               break;
            case APP_LOAD_STATE:
               if(appLoaded)
               {
                  deferredNextFrame();
                  state = APP_START_STATE;
               }
               break;
            case APP_START_STATE:
               if(appReady)
               {
                  if(Boolean(mixinList) && mixinList.length > 0)
                  {
                     n = int(mixinList.length);
                     i = 0;
                     while(i < n)
                     {
                        try
                        {
                           c = Class(getDefinitionByName(mixinList[i]));
                           c["init"](this);
                        }
                        catch(e:Error)
                        {
                        }
                        i++;
                     }
                  }
                  state = APP_RUNNING_STATE;
                  timer.removeEventListener(TimerEvent.TIMER,timerHandler);
                  timer.reset();
                  dispatchEvent(new Event("ready"));
                  loaderInfo.removeEventListener(Event.COMPLETE,moduleCompleteHandler);
               }
               break;
            case ERROR_STATE:
               if(timer != null)
               {
                  timer.removeEventListener(TimerEvent.TIMER,timerHandler);
                  timer.reset();
               }
               tf = new TextField();
               tf.text = errorMessage;
               tf.x = 0;
               tf.y = 0;
               tf.autoSize = TextFieldAutoSize.LEFT;
               addChild(tf);
               dispatchEvent(new ModuleEvent(ModuleEvent.ERROR,false,false,0,0,errorMessage));
               loaderInfo.removeEventListener(Event.COMPLETE,moduleCompleteHandler);
         }
      }
      
      private function nextFrameTimerHandler(param1:TimerEvent) : void
      {
         if(currentFrame + 1 <= framesLoaded)
         {
            nextFrame();
            nextFrameTimer.removeEventListener(TimerEvent.TIMER,nextFrameTimerHandler);
            nextFrameTimer.reset();
         }
      }
      
      public function autorun() : Boolean
      {
         return true;
      }
      
      private function rslCompleteHandler(param1:Event) : void
      {
         var _loc2_:RSLItem = rslListLoader.getItem(rslListLoader.getIndex());
         if(param1.target is LoaderInfo)
         {
            preloadedRSLs[param1.target] = _loc2_.urlRequest.url;
         }
         update();
      }
      
      public function get preloadedRSLs() : Dictionary
      {
         return null;
      }
      
      private function extraFrameListener(param1:Event) : void
      {
         if(lastFrame == currentFrame)
         {
            return;
         }
         lastFrame = currentFrame;
         if(currentFrame + 1 > totalFrames)
         {
            removeEventListener(Event.ENTER_FRAME,extraFrameListener);
         }
         extraFrameHandler();
      }
      
      private function deferredNextFrame() : void
      {
         if(currentFrame + 1 <= framesLoaded)
         {
            nextFrame();
         }
         else
         {
            nextFrameTimer = new Timer(100);
            nextFrameTimer.addEventListener(TimerEvent.TIMER,nextFrameTimerHandler);
            nextFrameTimer.start();
         }
      }
      
      private function extraFrameHandler(param1:Event = null) : void
      {
         var c:Class = null;
         var event:Event = param1;
         var frameList:Object = info()["frames"];
         if(Boolean(frameList) && Boolean(frameList[currentLabel]))
         {
            try
            {
               c = Class(getDefinitionByName(frameList[currentLabel]));
               c["frame"](this);
            }
            catch(e:Error)
            {
            }
         }
         if(currentFrame < totalFrames)
         {
            deferredNextFrame();
         }
      }
      
      private function moduleCompleteHandler(param1:Event) : void
      {
         appLoaded = true;
         update();
      }
      
      private function installCompiledResourceBundles() : void
      {
         var _loc1_:Object = this.info();
         var _loc2_:ApplicationDomain = _loc1_["currentDomain"];
         var _loc3_:Array = _loc1_["compiledLocales"];
         var _loc4_:Array = _loc1_["compiledResourceBundleNames"];
         var _loc5_:IResourceManager = ResourceManager.getInstance();
         _loc5_.installCompiledResourceBundles(_loc2_,_loc3_,_loc4_);
         if(!_loc5_.localeChain)
         {
            _loc5_.initializeLocaleChain(_loc3_);
         }
      }
      
      private function rslErrorHandler(param1:Event) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc2_:RSLItem = rslListLoader.getItem(rslListLoader.getIndex());
         if(param1 is ErrorEvent)
         {
            _loc3_ = ErrorEvent(param1).text;
         }
         if(!_loc3_)
         {
            _loc3_ = "";
         }
         _loc4_ = "RSL " + _loc2_.urlRequest.url + " failed to load. " + _loc3_;
         trace(_loc4_);
         displayError(_loc4_);
      }
      
      private function displayError(param1:String) : void
      {
         errorMessage = param1;
         state = ERROR_STATE;
         update();
      }
      
      private function timerHandler(param1:TimerEvent) : void
      {
         if(totalFrames > 2 && framesLoaded >= 2 || framesLoaded == totalFrames)
         {
            appLoaded = true;
         }
         update();
      }
      
      private function docFrameListener(param1:Event) : void
      {
         if(currentFrame == 2)
         {
            removeEventListener(Event.ENTER_FRAME,docFrameListener);
            if(totalFrames > 2)
            {
               addEventListener(Event.ENTER_FRAME,extraFrameListener);
            }
            docFrameHandler();
         }
      }
      
      public function allowDomain(... rest) : void
      {
      }
      
      public function allowInsecureDomain(... rest) : void
      {
      }
      
      public function getDefinitionByName(param1:String) : Object
      {
         var _loc3_:Object = null;
         var _loc2_:ApplicationDomain = info()["currentDomain"] as ApplicationDomain;
         if(_loc2_.hasDefinition(param1))
         {
            _loc3_ = _loc2_.getDefinition(param1);
         }
         return _loc3_;
      }
      
      public function info() : Object
      {
         return {};
      }
      
      private function docFrameHandler(param1:Event = null) : void
      {
         Singleton.registerClass("mx.managers::IBrowserManager",Class(getDefinitionByName("mx.managers::BrowserManagerImpl")));
         Singleton.registerClass("mx.managers::ICursorManager",Class(getDefinitionByName("mx.managers::CursorManagerImpl")));
         Singleton.registerClass("mx.managers::IDragManager",Class(getDefinitionByName("mx.managers::DragManagerImpl")));
         Singleton.registerClass("mx.managers::IHistoryManager",Class(getDefinitionByName("mx.managers::HistoryManagerImpl")));
         Singleton.registerClass("mx.managers::ILayoutManager",Class(getDefinitionByName("mx.managers::LayoutManager")));
         Singleton.registerClass("mx.managers::IPopUpManager",Class(getDefinitionByName("mx.managers::PopUpManagerImpl")));
         Singleton.registerClass("mx.resources::IResourceManager",Class(getDefinitionByName("mx.resources::ResourceManagerImpl")));
         Singleton.registerClass("mx.styles::IStyleManager",Class(getDefinitionByName("mx.styles::StyleManagerImpl")));
         Singleton.registerClass("mx.styles::IStyleManager2",Class(getDefinitionByName("mx.styles::StyleManagerImpl")));
         Singleton.registerClass("mx.managers::IToolTipManager2",Class(getDefinitionByName("mx.managers::ToolTipManagerImpl")));
         appReady = true;
         installCompiledResourceBundles();
         update();
         if(currentFrame < totalFrames)
         {
            deferredNextFrame();
         }
      }
      
      public function create(... rest) : Object
      {
         var _loc4_:String = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc2_:String = info()["mainClassName"];
         if(_loc2_ == null)
         {
            _loc4_ = loaderInfo.loaderURL;
            _loc5_ = _loc4_.lastIndexOf(".");
            _loc6_ = _loc4_.lastIndexOf("/");
            _loc2_ = _loc4_.substring(_loc6_ + 1,_loc5_);
         }
         var _loc3_:Class = Class(getDefinitionByName(_loc2_));
         return _loc3_ ? new _loc3_() : null;
      }
   }
}

