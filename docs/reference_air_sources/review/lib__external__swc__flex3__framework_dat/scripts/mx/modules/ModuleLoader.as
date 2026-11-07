package mx.modules
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.system.ApplicationDomain;
   import flash.utils.ByteArray;
   import mx.containers.VBox;
   import mx.core.IDeferredInstantiationUIComponent;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.ModuleEvent;
   
   use namespace mx_internal;
   
   [Event(name="unload",type="mx.events.ModuleEvent")]
   [Event(name="progress",type="mx.events.ModuleEvent")]
   [Event(name="error",type="mx.events.ModuleEvent")]
   [Event(name="ready",type="mx.events.ModuleEvent")]
   [Event(name="setup",type="mx.events.ModuleEvent")]
   [Event(name="urlChanged",type="flash.events.Event")]
   [Event(name="loading",type="flash.events.Event")]
   public class ModuleLoader extends VBox implements IDeferredInstantiationUIComponent
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var loadRequested:Boolean = false;
      
      private var module:IModuleInfo;
      
      public var applicationDomain:ApplicationDomain;
      
      private var _url:String = null;
      
      public var child:DisplayObject;
      
      public function ModuleLoader()
      {
         super();
      }
      
      private function moduleUnloadHandler(event:ModuleEvent) : void
      {
         dispatchEvent(event);
      }
      
      public function unloadModule() : void
      {
         if(Boolean(child))
         {
            removeChild(child);
            child = null;
         }
         if(Boolean(module))
         {
            module.removeEventListener(ModuleEvent.PROGRESS,moduleProgressHandler);
            module.removeEventListener(ModuleEvent.SETUP,moduleSetupHandler);
            module.removeEventListener(ModuleEvent.READY,moduleReadyHandler);
            module.removeEventListener(ModuleEvent.ERROR,moduleErrorHandler);
            module.unload();
            module.removeEventListener(ModuleEvent.UNLOAD,moduleUnloadHandler);
            module = null;
         }
      }
      
      private function moduleErrorHandler(event:ModuleEvent) : void
      {
         unloadModule();
         dispatchEvent(event);
      }
      
      public function get url() : String
      {
         return _url;
      }
      
      private function moduleProgressHandler(event:ModuleEvent) : void
      {
         dispatchEvent(event);
      }
      
      public function loadModule(url:String = null, bytes:ByteArray = null) : void
      {
         if(url != null)
         {
            _url = url;
         }
         if(_url == null)
         {
            return;
         }
         if(Boolean(child))
         {
            return;
         }
         if(Boolean(module))
         {
            return;
         }
         dispatchEvent(new FlexEvent(FlexEvent.LOADING));
         module = ModuleManager.getModule(_url);
         module.addEventListener(ModuleEvent.PROGRESS,moduleProgressHandler);
         module.addEventListener(ModuleEvent.SETUP,moduleSetupHandler);
         module.addEventListener(ModuleEvent.READY,moduleReadyHandler);
         module.addEventListener(ModuleEvent.ERROR,moduleErrorHandler);
         module.addEventListener(ModuleEvent.UNLOAD,moduleUnloadHandler);
         module.load(applicationDomain,null,bytes);
      }
      
      override public function createComponentsFromDescriptors(recurse:Boolean = true) : void
      {
         super.createComponentsFromDescriptors(recurse);
         loadRequested = true;
         loadModule();
      }
      
      private function moduleSetupHandler(event:ModuleEvent) : void
      {
         dispatchEvent(event);
      }
      
      private function moduleReadyHandler(event:ModuleEvent) : void
      {
         var p:DisplayObjectContainer = null;
         child = module.factory.create() as DisplayObject;
         dispatchEvent(event);
         if(Boolean(child))
         {
            p = parent;
            addChild(child);
         }
      }
      
      public function set url(value:String) : void
      {
         if(value == _url)
         {
            return;
         }
         var wasLoaded:Boolean = false;
         if(Boolean(module))
         {
            module.removeEventListener(ModuleEvent.PROGRESS,moduleProgressHandler);
            module.removeEventListener(ModuleEvent.SETUP,moduleSetupHandler);
            module.removeEventListener(ModuleEvent.READY,moduleReadyHandler);
            module.removeEventListener(ModuleEvent.ERROR,moduleErrorHandler);
            module.removeEventListener(ModuleEvent.UNLOAD,moduleUnloadHandler);
            module.release();
            module = null;
            if(Boolean(child))
            {
               removeChild(child);
               child = null;
            }
         }
         _url = value;
         dispatchEvent(new FlexEvent(FlexEvent.URL_CHANGED));
         if(_url != null && loadRequested)
         {
            loadModule();
         }
      }
   }
}

