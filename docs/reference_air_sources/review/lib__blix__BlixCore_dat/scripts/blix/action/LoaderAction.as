package blix.action
{
   import blix.signals.ISignal;
   import blix.signals.NativeSignal;
   import flash.display.Loader;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   
   public class LoaderAction extends BasicAction
   {
      
      public var urlRequest:URLRequest;
      
      public var context:LoaderContext;
      
      public var loader:Loader;
      
      public var bytes:ByteArray;
      
      private var _progress:NativeSignal = new NativeSignal(ProgressEvent.PROGRESS);
      
      private var _hasInitialized:Boolean;
      
      public function LoaderAction(param1:URLRequest = null, param2:LoaderContext = null, param3:Boolean = false)
      {
         super(param3);
         this.loader = new Loader();
         this._progress.setEventDispatcher(this.loader.contentLoaderInfo);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.erredHandler);
         this.loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.erredHandler);
         this.loader.contentLoaderInfo.addEventListener(Event.INIT,this.initializedHandler);
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.completedHandler);
         this.context = param2;
         this.urlRequest = param1;
      }
      
      override protected function doInvocation() : void
      {
         this._hasInitialized = false;
         if(this.urlRequest == null)
         {
            err(new Error("urlRequest not set."));
            return;
         }
         if(this.bytes != null)
         {
            try
            {
               this.loader.loadBytes(this.bytes,this.context);
               complete();
            }
            catch(error:Error)
            {
               err(error);
               return;
            }
         }
         else
         {
            try
            {
               this.loader.load(this.urlRequest,this.context);
            }
            catch(error:Error)
            {
               err(error);
            }
         }
      }
      
      public function getProgress() : ISignal
      {
         return this._progress;
      }
      
      public function getPercentLoaded() : Number
      {
         if(this.loader.contentLoaderInfo.bytesTotal <= 0)
         {
            return 0;
         }
         return this.loader.contentLoaderInfo.bytesLoaded / this.loader.contentLoaderInfo.bytesTotal;
      }
      
      public function getHasInitialized() : Boolean
      {
         return this._hasInitialized;
      }
      
      public function unload() : void
      {
         this.reset();
         this.loader.unload();
      }
      
      public function unloadAndStop(param1:Boolean = true) : void
      {
         this.reset();
         this.loader.unloadAndStop(param1);
      }
      
      public function load(param1:URLRequest, param2:LoaderContext = null) : void
      {
         this.urlRequest = param1;
         this.context = param2;
         invoke();
      }
      
      public function loadBytes(param1:ByteArray, param2:LoaderContext = null) : void
      {
         this.bytes = param1;
         this.context = param2;
         invoke();
      }
      
      protected function initializedHandler(param1:Event) : void
      {
         this._hasInitialized = true;
      }
      
      protected function completedHandler(param1:Event) : void
      {
         complete();
      }
      
      protected function erredHandler(param1:ErrorEvent) : void
      {
         err(new Error(param1.text));
      }
      
      override public function abort() : void
      {
         if(_hasCompleted || _error != null)
         {
            return;
         }
         if(_hasBeenInvoked && !_hasCompleted)
         {
            this.loader.close();
         }
         if(_hasCompleted)
         {
            this.loader.unloadAndStop();
         }
         super.abort();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this._progress.removeAll();
      }
      
      override public function reset() : void
      {
         this._hasInitialized = false;
         super.reset();
      }
      
      public function getApplicationDomain() : ApplicationDomain
      {
         return this.loader.contentLoaderInfo.applicationDomain;
      }
   }
}

