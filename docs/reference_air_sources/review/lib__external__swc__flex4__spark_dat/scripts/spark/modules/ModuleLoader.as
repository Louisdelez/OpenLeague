package spark.modules
{
   import flash.events.Event;
   import flash.system.ApplicationDomain;
   import flash.system.SecurityDomain;
   import flash.utils.ByteArray;
   import mx.core.ContainerCreationPolicy;
   import mx.core.FlexVersion;
   import mx.core.IDeferredContentOwner;
   import mx.core.IFlexModuleFactory;
   import mx.core.INavigatorContent;
   import mx.core.IVisualElement;
   import mx.events.FlexEvent;
   import mx.events.ModuleEvent;
   import mx.modules.IModuleInfo;
   import mx.modules.ModuleManager;
   import spark.components.Group;
   
   [DiscouragedForProfile("mobileDevice")]
   [IconFile("ModuleLoader.png")]
   [ResourceBundle("modules")]
   [Event(name="unload",type="mx.events.ModuleEvent")]
   [Event(name="progress",type="mx.events.ModuleEvent")]
   [Event(name="error",type="mx.events.ModuleEvent")]
   [Event(name="ready",type="mx.events.ModuleEvent")]
   [Event(name="setup",type="mx.events.ModuleEvent")]
   [Event(name="urlChanged",type="flash.events.Event")]
   [Event(name="loading",type="flash.events.Event")]
   public class ModuleLoader extends Group implements INavigatorContent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var module:IModuleInfo;
      
      private var loadRequested:Boolean = false;
      
      public var applicationDomain:ApplicationDomain;
      
      public var child:IVisualElement;
      
      private var _trustContent:Boolean = false;
      
      private var _url:String = null;
      
      private var creationPolicyNone:Boolean = false;
      
      private var _icon:Class = null;
      
      private var _label:String = "";
      
      public function ModuleLoader()
      {
         super();
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
      
      [Inspectable(category="General")]
      public function get url() : String
      {
         return this._url;
      }
      
      public function set url(value:String) : void
      {
         if(value == this._url)
         {
            return;
         }
         var wasLoaded:Boolean = false;
         if(Boolean(this.module))
         {
            this.module.removeEventListener(ModuleEvent.PROGRESS,this.moduleProgressHandler);
            this.module.removeEventListener(ModuleEvent.SETUP,this.moduleSetupHandler);
            this.module.removeEventListener(ModuleEvent.READY,this.moduleReadyHandler);
            this.module.removeEventListener(ModuleEvent.ERROR,this.moduleErrorHandler);
            this.module.removeEventListener(ModuleEvent.UNLOAD,this.moduleUnloadHandler);
            this.module.release();
            this.module = null;
            if(Boolean(this.child))
            {
               removeElement(this.child);
               this.child = null;
            }
         }
         this._url = value;
         dispatchEvent(new FlexEvent(FlexEvent.URL_CHANGED));
         if(this._url != null && this._url != "" && this.loadRequested)
         {
            this.loadModule();
         }
      }
      
      override public function set moduleFactory(moduleFactory:IFlexModuleFactory) : void
      {
         super.moduleFactory = moduleFactory;
         styleManager.registerInheritingStyle("_creationPolicy");
      }
      
      [Inspectable(enumeration="auto,all,none",defaultValue="auto")]
      public function get creationPolicy() : String
      {
         var result:String = getStyle("_creationPolicy");
         if(result == null)
         {
            result = ContainerCreationPolicy.AUTO;
         }
         if(this.creationPolicyNone)
         {
            result = ContainerCreationPolicy.NONE;
         }
         return result;
      }
      
      public function set creationPolicy(value:String) : void
      {
         if(value == ContainerCreationPolicy.NONE)
         {
            this.creationPolicyNone = true;
            value = ContainerCreationPolicy.AUTO;
         }
         else
         {
            this.creationPolicyNone = false;
         }
         setStyle("_creationPolicy",value);
      }
      
      [Inspectable(category="General",defaultValue="",format="EmbeddedFile")]
      [Bindable("iconChanged")]
      public function get icon() : Class
      {
         return this._icon;
      }
      
      public function set icon(value:Class) : void
      {
         this._icon = value;
         dispatchEvent(new Event("iconChanged"));
      }
      
      [Inspectable(category="General",defaultValue="")]
      [Bindable("labelChanged")]
      public function get label() : String
      {
         return this._label;
      }
      
      public function set label(value:String) : void
      {
         this._label = value;
         dispatchEvent(new Event("labelChanged"));
      }
      
      public function get deferredContentCreated() : Boolean
      {
         return this.loadRequested;
      }
      
      public function createDeferredContent() : void
      {
         this.loadRequested = true;
         this.loadModule();
      }
      
      override protected function createChildren() : void
      {
         var parentCreationPolicy:String = null;
         if(this.creationPolicy == ContainerCreationPolicy.AUTO)
         {
            if(parent is IDeferredContentOwner)
            {
               parentCreationPolicy = IDeferredContentOwner(parent).creationPolicy;
               this.creationPolicy = parentCreationPolicy == ContainerCreationPolicy.ALL ? ContainerCreationPolicy.ALL : ContainerCreationPolicy.NONE;
            }
         }
         if(!this.loadRequested && this.creationPolicy != ContainerCreationPolicy.NONE)
         {
            this.createDeferredContent();
         }
         super.createChildren();
      }
      
      public function loadModule(url:String = null, bytes:ByteArray = null) : void
      {
         var currentDomain:ApplicationDomain = null;
         if(url != null)
         {
            this._url = url;
         }
         if(this._url == null || this._url == "")
         {
            return;
         }
         if(Boolean(this.child))
         {
            return;
         }
         if(Boolean(this.module))
         {
            return;
         }
         dispatchEvent(new FlexEvent(FlexEvent.LOADING));
         this.module = ModuleManager.getModule(this._url);
         this.module.addEventListener(ModuleEvent.PROGRESS,this.moduleProgressHandler);
         this.module.addEventListener(ModuleEvent.SETUP,this.moduleSetupHandler);
         this.module.addEventListener(ModuleEvent.READY,this.moduleReadyHandler);
         this.module.addEventListener(ModuleEvent.ERROR,this.moduleErrorHandler);
         this.module.addEventListener(ModuleEvent.UNLOAD,this.moduleUnloadHandler);
         var tempApplicationDomain:ApplicationDomain = this.applicationDomain;
         if(Boolean(tempApplicationDomain == null) && Boolean(moduleFactory) && FlexVersion.compatibilityVersion >= FlexVersion.VERSION_4_0)
         {
            currentDomain = moduleFactory.info()["currentDomain"];
            tempApplicationDomain = new ApplicationDomain(currentDomain);
         }
         this.module.load(tempApplicationDomain,this.trustContent ? SecurityDomain.currentDomain : null,bytes,moduleFactory);
      }
      
      public function unloadModule() : void
      {
         if(Boolean(this.child))
         {
            removeElement(this.child);
            this.child = null;
         }
         if(Boolean(this.module))
         {
            this.module.removeEventListener(ModuleEvent.PROGRESS,this.moduleProgressHandler);
            this.module.removeEventListener(ModuleEvent.SETUP,this.moduleSetupHandler);
            this.module.removeEventListener(ModuleEvent.READY,this.moduleReadyHandler);
            this.module.removeEventListener(ModuleEvent.ERROR,this.moduleErrorHandler);
            this.module.unload();
            this.module.removeEventListener(ModuleEvent.UNLOAD,this.moduleUnloadHandler);
            this.module = null;
         }
      }
      
      private function moduleProgressHandler(event:ModuleEvent) : void
      {
         dispatchEvent(event);
      }
      
      private function moduleSetupHandler(event:ModuleEvent) : void
      {
         dispatchEvent(event);
      }
      
      private function moduleReadyHandler(event:ModuleEvent) : void
      {
         var message:String = null;
         var moduleEvent:ModuleEvent = null;
         this.child = this.module.factory.create() as IVisualElement;
         dispatchEvent(event);
         if(Boolean(this.child))
         {
            addElement(this.child);
         }
         else
         {
            message = resourceManager.getString("modules","couldNotCreateModule",[this.module.factory.info()["mainClassName"]]);
            moduleEvent = new ModuleEvent(ModuleEvent.ERROR,false,false,event.bytesLoaded,event.bytesTotal,message,event.module);
            dispatchEvent(moduleEvent);
         }
      }
      
      private function moduleErrorHandler(event:ModuleEvent) : void
      {
         this.unloadModule();
         dispatchEvent(event);
      }
      
      private function moduleUnloadHandler(event:ModuleEvent) : void
      {
         dispatchEvent(event);
      }
   }
}

