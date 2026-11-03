package
{
   import com.riotgames.dependencyloader.DependenciesManager;
   import com.riotgames.dependencyloader.DependenciesManagerImpl;
   import com.riotgames.dependencyloader.DependencyLoader;
   import flash.desktop.NativeApplication;
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.UncaughtErrorEvent;
   import flash.filesystem.File;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   
   [SWF(width="1280", height="800", backgroundColor="#000000", frameRate="24")]
   public class LolClient extends Sprite
   {
      
      private var _contentSwf:String;
      
      public function LolClient()
      {
         super();
         stage.align = StageAlign.TOP_LEFT;
         stage.scaleMode = StageScaleMode.NO_SCALE;
         DependencyLoader.defaultUncaughtExceptionHandler = this.uncaughtErrorHandler;
         DependenciesManager.registerImpl(new DependenciesManagerImpl());
         DependenciesManager.loadDependencies(this.dependenciesLoadedHandler,this.dependenciesFailedHandler);
         loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,this.uncaughtErrorHandler);
      }
      
      private static function get4DigitCode(param1:int) : String
      {
         var _loc2_:String = null;
         if(param1 > 0)
         {
            _loc2_ = param1.toString();
            while(_loc2_.length < 4)
            {
               _loc2_ = "0" + _loc2_;
            }
            return _loc2_ + " ";
         }
         return "0001 ";
      }
      
      private function uncaughtErrorHandler(param1:UncaughtErrorEvent) : void
      {
         var _loc3_:Class = null;
         var _loc2_:ApplicationDomain = DependenciesManager.getDefaultContext().applicationDomain;
         if(_loc2_.hasDefinition("com.riotgames.util.logging.UncaughtErrorRelay"))
         {
            _loc3_ = _loc2_.getDefinition("com.riotgames.util.logging.UncaughtErrorRelay") as Class;
            _loc3_["pushError"]("LolClient",param1.error);
         }
      }
      
      protected function get contentSWF() : String
      {
         var _loc1_:File = null;
         var _loc2_:Array = null;
         var _loc3_:File = null;
         if(this._contentSwf == null || this._contentSwf == "")
         {
            _loc1_ = File.applicationDirectory.resolvePath("mod/win");
            if(!_loc1_.exists)
            {
               throw new Error("unable to locate the content swf directory: " + _loc1_.url);
            }
            _loc2_ = _loc1_.getDirectoryListing();
            this._contentSwf = "mod/win/ClientWindow.dat";
            for each(_loc3_ in _loc2_)
            {
               if(_loc3_.extension == "dat")
               {
                  this._contentSwf = _loc3_.url.substr("app://".length - 1);
                  return this._contentSwf;
               }
            }
         }
         return this._contentSwf;
      }
      
      private function dependenciesFailedHandler(param1:ErrorEvent) : void
      {
         this.fatalError("0001: " + param1.text);
      }
      
      private function dependenciesLoadedHandler() : void
      {
         DependenciesManager.getDefaultContext().applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
         var _loc1_:DependencyLoader = DependenciesManager.getLoader(new URLRequest(this.contentSWF));
         _loc1_.getContext().requestedContentParent = this;
         _loc1_.load(this.successHandler,this.failHandler);
      }
      
      private function failHandler(param1:DependencyLoader) : void
      {
         this.fatalError("0002: " + this.contentSWF + " " + param1.getErrorEvent());
      }
      
      private function successHandler(param1:DependencyLoader) : void
      {
      }
      
      private function fatalError(param1:String) : void
      {
         var _loc2_:ShellErrorWindow = new ShellErrorWindow(param1);
         _loc2_.addEventListener(Event.CLOSE,this.onErrorClosed);
         _loc2_.activate();
      }
      
      private function onErrorClosed(param1:Event) : void
      {
         NativeApplication.nativeApplication.exit();
      }
   }
}

