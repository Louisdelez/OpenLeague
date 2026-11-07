package blix.action
{
   import flash.display.Loader;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   
   public class LoadBytesAction extends UrlLoaderAction
   {
      
      public var context:LoaderContext;
      
      public var loader:Loader = new Loader();
      
      public function LoadBytesAction(param1:URLRequest = null, param2:Boolean = false)
      {
         super(param1,URLLoaderDataFormat.BINARY,param2);
         this.createDefaultContext();
      }
      
      public function createDefaultContext() : void
      {
         this.context = new LoaderContext(false,new ApplicationDomain(ApplicationDomain.currentDomain));
         if(this.context.hasOwnProperty("allowCodeImport"))
         {
            this.context["allowCodeImport"] = true;
         }
         if(this.context.hasOwnProperty("allowLoadBytesCodeExecution"))
         {
            this.context["allowLoadBytesCodeExecution"] = true;
         }
      }
      
      override protected function completedHandler(param1:Event) : void
      {
         var bytes:ByteArray;
         var event:Event = param1;
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.loaderCompletedHandler);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.loaderErredHandler);
         this.loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loaderErredHandler);
         bytes = _urlLoader.data as ByteArray;
         try
         {
            this.loader.loadBytes(bytes,this.context);
         }
         catch(error:Error)
         {
            err(error);
         }
         bytes.clear();
      }
      
      private function loaderErredHandler(param1:ErrorEvent) : void
      {
         err(new Error(param1.text));
      }
      
      private function loaderCompletedHandler(param1:Event) : void
      {
         (param1.currentTarget as IEventDispatcher).removeEventListener(param1.type,this.loaderCompletedHandler);
         complete();
      }
   }
}

