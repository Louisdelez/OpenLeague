package blix
{
   import blix.context.IApplicationLoadable;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Event(name="applicationLoaded",type="flash.events.Event")]
   public class ApplicationLoader extends MovieClip
   {
      
      public static const APPLICATION_LOADED:String = "applicationLoaded";
      
      public var main:IApplicationLoadable;
      
      protected var preloaderView:MovieClip;
      
      protected var isPreloaderPlaying:Boolean;
      
      protected var applicationSize:uint = 10000;
      
      protected var preloaderGfxClass:Class;
      
      protected var rootWidth:uint = 550;
      
      protected var rootHeight:uint = 400;
      
      protected var loadingInitialized:Boolean;
      
      protected var mainAppComplete:Boolean;
      
      protected var mainClassIsReady:Boolean;
      
      public function ApplicationLoader()
      {
         super();
         loaderInfo.addEventListener(Event.COMPLETE,this.mainAppCompleteHandler);
         stop();
         addEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
      }
      
      protected function mainAppCompleteHandler(param1:Event) : void
      {
         loaderInfo.removeEventListener(Event.COMPLETE,this.mainAppCompleteHandler);
         this.mainAppComplete = true;
      }
      
      protected function enterFrameHandler(param1:Event) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(!this.loadingInitialized && loaderInfo.bytesTotal > 0)
         {
            this.loadingInitialized = true;
            this.initPreloader();
         }
         if(this.mainAppComplete && this.main == null)
         {
            gotoAndStop(2);
            this.createMain();
         }
         if(this.loadingInitialized)
         {
            _loc2_ = this.getBytesLoaded();
            _loc3_ = this.getBytesTotal();
            if(this.mainAppComplete && _loc2_ >= _loc3_)
            {
               removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
               if(this.preloaderView != null)
               {
                  removeChild(this.preloaderView);
                  this.preloaderView = null;
               }
            }
            else if(this.preloaderView != null)
            {
               this.updatePreloader(_loc2_ / _loc3_);
            }
         }
      }
      
      protected function getBytesLoaded() : uint
      {
         var _loc1_:uint = 0;
         if(this.main != null)
         {
            _loc1_ = this.main.getPercentLoaded() * this.applicationSize;
         }
         return loaderInfo.bytesLoaded + _loc1_;
      }
      
      protected function getBytesTotal() : uint
      {
         return loaderInfo.bytesTotal + this.applicationSize;
      }
      
      protected function initPreloader() : void
      {
         if(this.preloaderView == null && this.preloaderGfxClass != null)
         {
            this.preloaderView = new this.preloaderGfxClass();
         }
         if(this.preloaderView != null)
         {
            this.preloaderView.tabEnabled = false;
            this.preloaderView.tabChildren = false;
            this.preloaderView.focusRect = null;
            this.preloaderView.stop();
            addChild(this.preloaderView);
            this.updatePreloader(0);
         }
      }
      
      protected function updatePreloader(param1:Number) : void
      {
         if(this.preloaderView == null)
         {
            return;
         }
         this.preloaderView.x = this.rootWidth - this.preloaderView.width >> 1;
         this.preloaderView.y = this.rootHeight - this.preloaderView.height >> 1;
         var _loc2_:Number = this.preloaderView.currentFrame / this.preloaderView.totalFrames;
         var _loc3_:Boolean = param1 > _loc2_;
         if(this.isPreloaderPlaying != _loc3_)
         {
            this.isPreloaderPlaying = _loc3_;
            if(_loc3_)
            {
               this.preloaderView.play();
            }
            else
            {
               this.preloaderView.stop();
            }
         }
         if(this.preloaderView.hasOwnProperty("updatePercent"))
         {
            this.preloaderView["updatePercent"](_loc2_);
         }
      }
      
      protected function createMain() : void
      {
         var _loc1_:String = this.getMainClassName();
         var _loc2_:Class = loaderInfo.applicationDomain.getDefinition(_loc1_) as Class;
         this.main = new _loc2_(this.getConfiguration());
         loaderInfo.sharedEvents.dispatchEvent(new Event(APPLICATION_LOADED));
         this.mainClassIsReady = true;
      }
      
      protected function getConfiguration() : Object
      {
         return {
            "root":this,
            "width":this.rootWidth,
            "height":this.rootHeight
         };
      }
      
      protected function getMainClassName() : String
      {
         return currentFrameLabel.replace(/_/g,".");
      }
      
      override public function toString() : String
      {
         return "[ApplicationLoader]";
      }
   }
}

