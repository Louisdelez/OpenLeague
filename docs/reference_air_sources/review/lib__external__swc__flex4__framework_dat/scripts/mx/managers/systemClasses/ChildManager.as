package mx.managers.systemClasses
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.events.IEventDispatcher;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModule;
   import mx.core.IFlexModuleFactory;
   import mx.core.IFontContextComponent;
   import mx.core.IInvalidating;
   import mx.core.IUIComponent;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.managers.ILayoutManagerClient;
   import mx.managers.ISystemManager;
   import mx.managers.ISystemManagerChildManager;
   import mx.messaging.config.LoaderConfig;
   import mx.preloaders.Preloader;
   import mx.styles.ISimpleStyleClient;
   import mx.styles.IStyleClient;
   import mx.utils.LoaderUtil;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class ChildManager implements ISystemManagerChildManager
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var systemManager:ISystemManager;
      
      public function ChildManager(systemManager:IFlexModuleFactory)
      {
         super();
         if(systemManager is ISystemManager)
         {
            systemManager["childManager"] = this;
            this.systemManager = ISystemManager(systemManager);
            this.systemManager.registerImplementation("mx.managers::ISystemManagerChildManager",this);
         }
      }
      
      public function addingChild(child:DisplayObject) : void
      {
         var obj:DisplayObjectContainer = null;
         var newNestLevel:int = 1;
         if(!this.topLevel && Boolean(DisplayObject(this.systemManager).parent))
         {
            obj = DisplayObject(this.systemManager).parent.parent;
            while(Boolean(obj))
            {
               if(obj is ILayoutManagerClient)
               {
                  newNestLevel = ILayoutManagerClient(obj).nestLevel + 1;
                  break;
               }
               obj = obj.parent;
            }
         }
         this.nestLevel = newNestLevel;
         if(child is IUIComponent)
         {
            IUIComponent(child).systemManager = this.systemManager;
         }
         if(child is IUIComponent && !IUIComponent(child).document)
         {
            IUIComponent(child).document = this.systemManager.document;
         }
         if(child is IFlexModule && IFlexModule(child).moduleFactory == null)
         {
            IFlexModule(child).moduleFactory = this.systemManager;
         }
         if(child is IFontContextComponent && !child is UIComponent && IFontContextComponent(child).fontContext == null)
         {
            IFontContextComponent(child).fontContext = this.systemManager;
         }
         if(child is ILayoutManagerClient)
         {
            ILayoutManagerClient(child).nestLevel = this.nestLevel + 1;
         }
         if(child is InteractiveObject)
         {
            if(InteractiveObject(this.systemManager).doubleClickEnabled)
            {
               InteractiveObject(child).doubleClickEnabled = true;
            }
         }
         if(child is IUIComponent)
         {
            IUIComponent(child).parentChanged(DisplayObjectContainer(this.systemManager));
         }
         if(child is IStyleClient)
         {
            IStyleClient(child).regenerateStyleCache(true);
         }
         if(child is ISimpleStyleClient)
         {
            ISimpleStyleClient(child).styleChanged(null);
         }
         if(child is IStyleClient)
         {
            IStyleClient(child).notifyStyleChangeInChildren(null,true);
         }
         if(child is UIComponent)
         {
            UIComponent(child).initThemeColor();
         }
         if(child is UIComponent)
         {
            UIComponent(child).stylesInitialized();
         }
      }
      
      public function childAdded(child:DisplayObject) : void
      {
         if(child.hasEventListener(FlexEvent.ADD))
         {
            child.dispatchEvent(new FlexEvent(FlexEvent.ADD));
         }
         if(child is IUIComponent)
         {
            IUIComponent(child).initialize();
         }
      }
      
      public function removingChild(child:DisplayObject) : void
      {
         if(child.hasEventListener(FlexEvent.REMOVE))
         {
            child.dispatchEvent(new FlexEvent(FlexEvent.REMOVE));
         }
      }
      
      public function childRemoved(child:DisplayObject) : void
      {
         if(child is IUIComponent)
         {
            IUIComponent(child).parentChanged(null);
         }
      }
      
      public function regenerateStyleCache(recursive:Boolean) : void
      {
         var child:IStyleClient = null;
         var foundTopLevelWindow:Boolean = false;
         var n:int = this.systemManager.rawChildren.numChildren;
         for(var i:int = 0; i < n; i++)
         {
            child = this.systemManager.rawChildren.getChildAt(i) as IStyleClient;
            if(Boolean(child))
            {
               child.regenerateStyleCache(recursive);
            }
            if(this.isTopLevelWindow(DisplayObject(child)))
            {
               foundTopLevelWindow = true;
            }
            n = this.systemManager.rawChildren.numChildren;
         }
         if(!foundTopLevelWindow && this.topLevelWindow is IStyleClient)
         {
            IStyleClient(this.topLevelWindow).regenerateStyleCache(recursive);
         }
      }
      
      public function notifyStyleChangeInChildren(styleProp:String, recursive:Boolean) : void
      {
         var child:IStyleClient = null;
         var foundTopLevelWindow:Boolean = false;
         var n:int = this.systemManager.rawChildren.numChildren;
         for(var i:int = 0; i < n; i++)
         {
            child = this.systemManager.rawChildren.getChildAt(i) as IStyleClient;
            if(Boolean(child))
            {
               child.styleChanged(styleProp);
               child.notifyStyleChangeInChildren(styleProp,recursive);
            }
            if(this.isTopLevelWindow(DisplayObject(child)))
            {
               foundTopLevelWindow = true;
            }
            n = this.systemManager.rawChildren.numChildren;
         }
         if(!foundTopLevelWindow && this.topLevelWindow is IStyleClient)
         {
            IStyleClient(this.topLevelWindow).styleChanged(styleProp);
            IStyleClient(this.topLevelWindow).notifyStyleChangeInChildren(styleProp,recursive);
         }
      }
      
      public function initializeTopLevelWindow(width:Number, height:Number) : void
      {
         var app:IUIComponent = null;
         this.systemManager.document = app = this.topLevelWindow = IUIComponent(this.systemManager.create());
         if(Boolean(this.systemManager.document))
         {
            IEventDispatcher(app).addEventListener(FlexEvent.CREATION_COMPLETE,this.appCreationCompleteHandler);
            if(!LoaderConfig._url)
            {
               LoaderConfig._url = LoaderUtil.normalizeURL(this.systemManager.loaderInfo);
               LoaderConfig._parameters = this.systemManager.loaderInfo.parameters;
               LoaderConfig._swfVersion = this.systemManager.loaderInfo.swfVersion;
            }
            IFlexDisplayObject(app).setActualSize(width,height);
            if(Boolean(this.preloader))
            {
               this.preloader.registerApplication(app);
            }
            this.addingChild(DisplayObject(app));
            this.childAdded(DisplayObject(app));
         }
         else
         {
            this.systemManager.document = this;
         }
      }
      
      private function appCreationCompleteHandler(event:FlexEvent) : void
      {
         var obj:DisplayObjectContainer = null;
         if(!this.topLevel && Boolean(DisplayObject(this.systemManager).parent))
         {
            obj = DisplayObject(this.systemManager).parent.parent;
            while(Boolean(obj))
            {
               if(obj is IInvalidating)
               {
                  IInvalidating(obj).invalidateSize();
                  IInvalidating(obj).invalidateDisplayList();
                  return;
               }
               obj = obj.parent;
            }
         }
      }
      
      private function isTopLevelWindow(object:DisplayObject) : Boolean
      {
         return this.systemManager["isTopLevelWindow"](object);
      }
      
      private function get topLevel() : Boolean
      {
         return this.systemManager["topLevel"];
      }
      
      private function set topLevel(topLevel:Boolean) : void
      {
         this.systemManager["topLevel"] = topLevel;
      }
      
      private function get topLevelWindow() : IUIComponent
      {
         return this.systemManager["topLevelWindow"];
      }
      
      private function set topLevelWindow(window:IUIComponent) : void
      {
         this.systemManager["topLevelWindow"] = window;
      }
      
      private function get nestLevel() : int
      {
         return this.systemManager["nestLevel"];
      }
      
      private function set nestLevel(level:int) : void
      {
         this.systemManager["nestLevel"] = level;
      }
      
      private function get preloader() : Preloader
      {
         return this.systemManager["preloader"];
      }
      
      private function set preloader(preloader:Preloader) : void
      {
         this.systemManager["preloader"] = preloader;
      }
   }
}

