package mx.core
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.events.ContextMenuEvent;
   import flash.events.Event;
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.Capabilities;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.utils.setInterval;
   import mx.containers.utilityClasses.ApplicationLayout;
   import mx.effects.EffectManager;
   import mx.events.FlexEvent;
   import mx.managers.FocusManager;
   import mx.managers.IActiveWindowManager;
   import mx.managers.ILayoutManager;
   import mx.managers.ISystemManager;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.IStyleClient;
   import mx.utils.LoaderUtil;
   
   [Alternative(replacement="spark.components.Application",since="4.0")]
   [ResourceBundle("core")]
   [Frame(factoryClass="mx.managers.SystemManager")]
   [Exclude(name="y",kind="property")]
   [Exclude(name="x",kind="property")]
   [Exclude(name="toolTip",kind="property")]
   [Exclude(name="tabIndex",kind="property")]
   [Exclude(name="label",kind="property")]
   [Exclude(name="icon",kind="property")]
   [Exclude(name="direction",kind="property")]
   [Style(name="paddingTop",type="Number",format="Length",inherit="no")]
   [Style(name="paddingBottom",type="Number",format="Length",inherit="no")]
   [Style(name="backgroundGradientColors",type="Array",arrayType="uint",format="Color",inherit="no",theme="halo")]
   [Style(name="backgroundGradientAlphas",type="Array",arrayType="Number",inherit="no",theme="halo")]
   [Style(name="modalTransparencyDuration",type="Number",format="Time",inherit="yes")]
   [Style(name="modalTransparencyColor",type="uint",format="Color",inherit="yes")]
   [Style(name="modalTransparencyBlur",type="Number",inherit="yes")]
   [Style(name="modalTransparency",type="Number",inherit="yes")]
   [Event(name="error",type="flash.events.ErrorEvent")]
   [Event(name="applicationComplete",type="mx.events.FlexEvent")]
   public class Application extends LayoutContainer
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var useProgressiveLayout:Boolean = false;
      
      private var resizeHandlerAdded:Boolean = false;
      
      private var percentBoundsChanged:Boolean;
      
      private var preloadObj:Object;
      
      private var creationQueue:Array = [];
      
      private var processingCreationQueue:Boolean = false;
      
      private var _applicationViewMetrics:EdgeMetrics;
      
      private var resizeWidth:Boolean = true;
      
      private var resizeHeight:Boolean = true;
      
      private var synchronousResize:Boolean = false;
      
      private var viewSourceCMI:ContextMenuItem;
      
      [Inspectable(defaultValue="24")]
      public var frameRate:Number;
      
      public var pageTitle:String;
      
      [Inspectable(defaultValue="mx.preloaders.DownloadProgressBar")]
      public var preloader:Object;
      
      [Inspectable(defaultValue="0xCCCCCC",format="Color")]
      public var preloaderChromeColor:uint;
      
      [Inspectable(defaultValue="1000")]
      public var scriptRecursionLimit:int;
      
      [Inspectable(defaultValue="60")]
      public var scriptTimeLimit:Number;
      
      [Inspectable(defaultValue="true")]
      public var usePreloader:Boolean;
      
      public var controlBar:IUIComponent;
      
      [Inspectable(defaultValue="true")]
      public var historyManagementEnabled:Boolean = true;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _parameters:Object;
      
      [Inspectable(defaultValue="true")]
      public var resetHistory:Boolean = true;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _url:String;
      
      private var _viewSourceURL:String;
      
      public function Application()
      {
         UIComponentGlobals.layoutManager = ILayoutManager(Singleton.getInstance("mx.managers::ILayoutManager"));
         UIComponentGlobals.layoutManager.usePhasedInstantiation = true;
         if(!FlexGlobals.topLevelApplication)
         {
            FlexGlobals.topLevelApplication = this;
         }
         super();
         layoutObject = new ApplicationLayout();
         layoutObject.target = this;
         boxLayoutClass = ApplicationLayout;
         showInAutomationHierarchy = true;
         this.initResizeBehavior();
      }
      
      [Deprecated(replacement="FlexGlobals.topLevelApplication",since="4.0")]
      public static function get application() : Object
      {
         return FlexGlobals.topLevelApplication;
      }
      
      [Inspectable(category="General",enumeration="true,false",defaultValue="true")]
      override public function set enabled(value:Boolean) : void
      {
         super.enabled = value;
         if(Boolean(this.controlBar))
         {
            this.controlBar.enabled = value;
         }
      }
      
      [Inspectable(environment="none")]
      override public function set icon(value:Class) : void
      {
      }
      
      [Inspectable(environment="none")]
      override public function get id() : String
      {
         if(!super.id && this == FlexGlobals.topLevelApplication && ExternalInterface.available)
         {
            return ExternalInterface.objectID;
         }
         return super.id;
      }
      
      [Inspectable(environment="none")]
      override public function set label(value:String) : void
      {
      }
      
      override public function set percentHeight(value:Number) : void
      {
         if(value != super.percentHeight)
         {
            super.percentHeight = value;
            this.percentBoundsChanged = true;
            invalidateProperties();
         }
      }
      
      override public function set percentWidth(value:Number) : void
      {
         if(value != super.percentWidth)
         {
            super.percentWidth = value;
            this.percentBoundsChanged = true;
            invalidateProperties();
         }
      }
      
      [Inspectable(environment="none")]
      override public function set tabIndex(value:int) : void
      {
      }
      
      [Inspectable(environment="none")]
      override public function set toolTip(value:String) : void
      {
      }
      
      override public function get viewMetrics() : EdgeMetrics
      {
         if(!this._applicationViewMetrics)
         {
            this._applicationViewMetrics = new EdgeMetrics();
         }
         var vm:EdgeMetrics = this._applicationViewMetrics;
         var o:EdgeMetrics = super.viewMetrics;
         var thickness:Number = Number(getStyle("borderThickness"));
         vm.left = o.left;
         vm.top = o.top;
         vm.right = o.right;
         vm.bottom = o.bottom;
         if(Boolean(this.controlBar) && Boolean(this.controlBar.includeInLayout))
         {
            vm.top -= thickness;
            vm.top += Math.max(this.controlBar.getExplicitOrMeasuredHeight(),thickness);
         }
         return vm;
      }
      
      public function get parameters() : Object
      {
         return this._parameters;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setUnscaledHeight(value:Number) : void
      {
         invalidateProperties();
         super.setUnscaledHeight(value);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setUnscaledWidth(value:Number) : void
      {
         invalidateProperties();
         super.setUnscaledWidth(value);
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get usePadding() : Boolean
      {
         return layout != ContainerLayout.ABSOLUTE;
      }
      
      public function get viewSourceURL() : String
      {
         return this._viewSourceURL;
      }
      
      public function set viewSourceURL(value:String) : void
      {
         this._viewSourceURL = value;
      }
      
      override public function getChildIndex(child:DisplayObject) : int
      {
         if(Boolean(this.controlBar) && child == this.controlBar)
         {
            return -1;
         }
         return super.getChildIndex(child);
      }
      
      override protected function invalidateParentSizeAndDisplayList() : void
      {
         if(!includeInLayout)
         {
            return;
         }
         var p:IInvalidating = parent as IInvalidating;
         if(!p)
         {
            if(parent is ISystemManager)
            {
               ISystemManager(parent).invalidateParentSizeAndDisplayList();
            }
            return;
         }
         super.invalidateParentSizeAndDisplayList();
      }
      
      override public function initialize() : void
      {
         var properties:Object = null;
         var sm:ISystemManager = systemManager;
         this._url = LoaderUtil.normalizeURL(sm.loaderInfo);
         this._parameters = sm.loaderInfo.parameters;
         this.initManagers(sm);
         _descriptor = null;
         if(Boolean(documentDescriptor))
         {
            creationPolicy = documentDescriptor.properties.creationPolicy;
            if(creationPolicy == null || creationPolicy.length == 0)
            {
               creationPolicy = ContainerCreationPolicy.AUTO;
            }
            properties = documentDescriptor.properties;
            if(properties.width != null)
            {
               width = properties.width;
               delete properties.width;
            }
            if(properties.height != null)
            {
               height = properties.height;
               delete properties.height;
            }
            documentDescriptor.events = null;
         }
         this.initContextMenu();
         super.initialize();
         addEventListener(Event.ADDED,this.addedHandler);
         if(Boolean(sm.isTopLevelRoot()) && Capabilities.isDebugger == true)
         {
            setInterval(this.debugTickler,1500);
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         this.resizeWidth = isNaN(explicitWidth);
         this.resizeHeight = isNaN(explicitHeight);
         if(this.resizeWidth || this.resizeHeight)
         {
            this.resizeHandler(new Event(Event.RESIZE));
            if(!this.resizeHandlerAdded)
            {
               systemManager.addEventListener(Event.RESIZE,this.resizeHandler,false,0,true);
               this.resizeHandlerAdded = true;
            }
         }
         else if(this.resizeHandlerAdded)
         {
            systemManager.removeEventListener(Event.RESIZE,this.resizeHandler);
            this.resizeHandlerAdded = false;
         }
         if(this.percentBoundsChanged)
         {
            this.updateBounds();
            this.percentBoundsChanged = false;
         }
      }
      
      override protected function measure() : void
      {
         var controlWidth:Number = NaN;
         super.measure();
         var bm:EdgeMetrics = borderMetrics;
         if(Boolean(this.controlBar) && Boolean(this.controlBar.includeInLayout))
         {
            controlWidth = this.controlBar.getExplicitOrMeasuredWidth() + bm.left + bm.right;
            measuredWidth = Math.max(measuredWidth,controlWidth);
            measuredMinWidth = Math.max(measuredMinWidth,controlWidth);
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         createBorder();
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         if(styleProp == "backgroundColor" && getStyle("backgroundImage") == getStyle("defaultBackgroundImage"))
         {
            clearStyle("backgroundImage");
         }
      }
      
      override public function prepareToPrint(target:IFlexDisplayObject) : Object
      {
         var objData:Object = {};
         if(target == this)
         {
            objData.width = width;
            objData.height = height;
            objData.verticalScrollPosition = verticalScrollPosition;
            objData.horizontalScrollPosition = horizontalScrollPosition;
            objData.horizontalScrollBarVisible = horizontalScrollBar != null;
            objData.verticalScrollBarVisible = verticalScrollBar != null;
            objData.whiteBoxVisible = whiteBox != null;
            setActualSize(measuredWidth,measuredHeight);
            horizontalScrollPosition = 0;
            verticalScrollPosition = 0;
            if(Boolean(horizontalScrollBar))
            {
               horizontalScrollBar.visible = false;
            }
            if(Boolean(verticalScrollBar))
            {
               verticalScrollBar.visible = false;
            }
            if(Boolean(whiteBox))
            {
               whiteBox.visible = false;
            }
            this.updateDisplayList(unscaledWidth,unscaledHeight);
         }
         objData.scrollRect = super.prepareToPrint(target);
         return objData;
      }
      
      override public function finishPrint(obj:Object, target:IFlexDisplayObject) : void
      {
         if(target == this)
         {
            setActualSize(obj.width,obj.height);
            if(Boolean(horizontalScrollBar))
            {
               horizontalScrollBar.visible = obj.horizontalScrollBarVisible;
            }
            if(Boolean(verticalScrollBar))
            {
               verticalScrollBar.visible = obj.verticalScrollBarVisible;
            }
            if(Boolean(whiteBox))
            {
               whiteBox.visible = obj.whiteBoxVisible;
            }
            horizontalScrollPosition = obj.horizontalScrollPosition;
            verticalScrollPosition = obj.verticalScrollPosition;
            this.updateDisplayList(unscaledWidth,unscaledHeight);
         }
         super.finishPrint(obj.scrollRect,target);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function initThemeColor() : Boolean
      {
         var tc:Object = null;
         var rc:Number = NaN;
         var sc:Number = NaN;
         var globalSelector:CSSStyleDeclaration = null;
         if(FlexVersion.compatibilityVersion >= FlexVersion.VERSION_4_0)
         {
            return true;
         }
         var result:Boolean = super.initThemeColor();
         if(!result)
         {
            globalSelector = styleManager.getMergedStyleDeclaration("global");
            if(Boolean(globalSelector))
            {
               tc = globalSelector.getStyle("themeColor");
               rc = Number(globalSelector.getStyle("rollOverColor"));
               sc = Number(globalSelector.getStyle("selectionColor"));
            }
            if(Boolean(tc) && Boolean(isNaN(rc)) && isNaN(sc))
            {
               setThemeColor(tc);
            }
            result = true;
         }
         return result;
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         if(Boolean(this.viewSourceCMI))
         {
            this.viewSourceCMI.caption = resourceManager.getString("core","viewSource");
         }
      }
      
      override protected function layoutChrome(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.layoutChrome(unscaledWidth,unscaledHeight);
         if(!doingLayout)
         {
            createBorder();
         }
         var bm:EdgeMetrics = borderMetrics;
         var thickness:Number = Number(getStyle("borderThickness"));
         var em:EdgeMetrics = new EdgeMetrics();
         em.left = bm.left - thickness;
         em.top = bm.top - thickness;
         em.right = bm.right - thickness;
         em.bottom = bm.bottom - thickness;
         if(Boolean(this.controlBar) && Boolean(this.controlBar.includeInLayout))
         {
            if(this.controlBar is IInvalidating)
            {
               IInvalidating(this.controlBar).invalidateDisplayList();
            }
            this.controlBar.setActualSize(width - (em.left + em.right),this.controlBar.getExplicitOrMeasuredHeight());
            this.controlBar.move(em.left,em.top);
         }
      }
      
      override public function addChildAt(child:DisplayObject, index:int) : DisplayObject
      {
         super.addChildAt(child,index);
         if(Boolean(child == this.controlBar && "dock" in child) && Boolean(child["dock"]) && "resetDock" in this.controlBar)
         {
            this.controlBar["resetDock"](true);
         }
         return child;
      }
      
      override public function removeChild(child:DisplayObject) : DisplayObject
      {
         if(child == this.controlBar && "dock" in child && Boolean(child["dock"]))
         {
            this.dockControlBar(IUIComponent(child),false);
         }
         return super.removeChild(child);
      }
      
      private function debugTickler() : void
      {
         var i:int = 0;
      }
      
      private function initManagers(sm:ISystemManager) : void
      {
         var awm:IActiveWindowManager = null;
         if(sm.isTopLevel())
         {
            focusManager = new FocusManager(this);
            awm = IActiveWindowManager(sm.getImplementation("mx.managers::IActiveWindowManager"));
            if(Boolean(awm))
            {
               awm.activate(this);
            }
            else
            {
               focusManager.activate();
            }
         }
      }
      
      private function initContextMenu() : void
      {
         var caption:String = null;
         if(flexContextMenu != null)
         {
            if(systemManager is InteractiveObject)
            {
               InteractiveObject(systemManager).contextMenu = contextMenu;
            }
            return;
         }
         var defaultMenu:ContextMenu = new ContextMenu();
         defaultMenu.hideBuiltInItems();
         defaultMenu.builtInItems.print = true;
         if(Boolean(this._viewSourceURL))
         {
            caption = resourceManager.getString("core","viewSource");
            this.viewSourceCMI = new ContextMenuItem(caption,true);
            this.viewSourceCMI.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.menuItemSelectHandler);
            if(Boolean(defaultMenu.customItems))
            {
               defaultMenu.customItems.push(this.viewSourceCMI);
            }
         }
         contextMenu = defaultMenu;
         if(systemManager is InteractiveObject)
         {
            InteractiveObject(systemManager).contextMenu = defaultMenu;
         }
      }
      
      public function addToCreationQueue(id:Object, preferredIndex:int = -1, callbackFunc:Function = null, parent:IFlexDisplayObject = null) : void
      {
         var insertIndex:int = 0;
         var pointerIndex:int = 0;
         var pointerLevel:int = 0;
         var parentLevel:int = 0;
         var queueLength:int = int(this.creationQueue.length);
         var queueObj:Object = {};
         var insertedItem:Boolean = false;
         queueObj.id = id;
         queueObj.parent = parent;
         queueObj.callbackFunc = callbackFunc;
         queueObj.index = preferredIndex;
         for(var i:int = 0; i < queueLength; i++)
         {
            pointerIndex = int(this.creationQueue[i].index);
            pointerLevel = Boolean(this.creationQueue[i].parent) ? int(this.creationQueue[i].parent.nestLevel) : 0;
            if(queueObj.index != -1)
            {
               if(pointerIndex == -1 || queueObj.index < pointerIndex)
               {
                  insertIndex = i;
                  insertedItem = true;
                  break;
               }
            }
            else
            {
               parentLevel = Boolean(queueObj.parent) ? int(queueObj.parent.nestLevel) : 0;
               if(pointerIndex == -1 && pointerLevel < parentLevel)
               {
                  insertIndex = i;
                  insertedItem = true;
                  break;
               }
            }
         }
         if(!insertedItem)
         {
            this.creationQueue.push(queueObj);
            insertedItem = true;
         }
         else
         {
            this.creationQueue.splice(insertIndex,0,queueObj);
         }
         if(Boolean(initialized) && !this.processingCreationQueue)
         {
            this.doNextQueueItem();
         }
      }
      
      private function doNextQueueItem(event:FlexEvent = null) : void
      {
         this.processingCreationQueue = true;
         Application.useProgressiveLayout = true;
         callLater(this.processNextQueueItem);
      }
      
      private function processNextQueueItem() : void
      {
         var queueItem:Object = null;
         var nextChild:IUIComponent = null;
         if(EffectManager.effectsPlaying.length > 0)
         {
            callLater(this.processNextQueueItem);
         }
         else if(this.creationQueue.length > 0)
         {
            queueItem = this.creationQueue.shift();
            try
            {
               nextChild = queueItem.id is String ? document[queueItem.id] : queueItem.id;
               if(nextChild is Container)
               {
                  Container(nextChild).createComponentsFromDescriptors(true);
               }
               if(nextChild is Container && Container(nextChild).creationPolicy == ContainerCreationPolicy.QUEUED)
               {
                  this.doNextQueueItem();
               }
               else
               {
                  nextChild.addEventListener("childrenCreationComplete",this.doNextQueueItem);
               }
            }
            catch(e:Error)
            {
               processNextQueueItem();
            }
         }
         else
         {
            this.processingCreationQueue = false;
            Application.useProgressiveLayout = false;
         }
      }
      
      private function printCreationQueue() : void
      {
         var child:Object = null;
         var msg:String = "";
         var n:Number = this.creationQueue.length;
         for(var i:int = 0; i < n; i++)
         {
            child = this.creationQueue[i];
            msg += " [" + i + "] " + child.id + " " + child.index;
         }
      }
      
      private function setControlBar(newControlBar:IUIComponent) : void
      {
         if(newControlBar == this.controlBar)
         {
            return;
         }
         if(Boolean(this.controlBar) && this.controlBar is IStyleClient)
         {
            IStyleClient(this.controlBar).clearStyle("cornerRadius");
            IStyleClient(this.controlBar).clearStyle("docked");
         }
         this.controlBar = newControlBar;
         if(Boolean(this.controlBar) && this.controlBar is IStyleClient)
         {
            IStyleClient(this.controlBar).setStyle("cornerRadius",0);
            IStyleClient(this.controlBar).setStyle("docked",true);
         }
         invalidateSize();
         invalidateDisplayList();
         invalidateViewMetricsAndPadding();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function dockControlBar(controlBar:IUIComponent, dock:Boolean) : void
      {
         if(dock)
         {
            try
            {
               this.removeChild(DisplayObject(controlBar));
            }
            catch(e:Error)
            {
               return;
            }
            rawChildren.addChildAt(DisplayObject(controlBar),firstChildIndex);
            this.setControlBar(controlBar);
         }
         else
         {
            try
            {
               rawChildren.removeChild(DisplayObject(controlBar));
            }
            catch(e:Error)
            {
               return;
            }
            this.setControlBar(null);
            this.addChildAt(DisplayObject(controlBar),0);
         }
      }
      
      private function initResizeBehavior() : void
      {
         var version:Array = Capabilities.version.split(" ")[1].split(",");
         this.synchronousResize = (parseFloat(version[0]) > 10 || parseFloat(version[0]) == 10 && parseFloat(version[1]) >= 1) && Capabilities.playerType != "Desktop";
      }
      
      private function addedHandler(event:Event) : void
      {
         if(event.target == this && this.creationQueue.length > 0)
         {
            this.doNextQueueItem();
         }
      }
      
      private function resizeHandler(event:Event) : void
      {
         if(!this.percentBoundsChanged)
         {
            this.updateBounds();
            if(this.synchronousResize)
            {
               UIComponentGlobals.layoutManager.validateNow();
            }
         }
      }
      
      protected function menuItemSelectHandler(event:Event) : void
      {
         navigateToURL(new URLRequest(this._viewSourceURL),"_blank");
      }
      
      private function updateBounds() : void
      {
         var w:Number = NaN;
         var h:Number = NaN;
         if(this.resizeWidth)
         {
            if(isNaN(percentWidth))
            {
               w = DisplayObject(systemManager).width;
            }
            else
            {
               super.percentWidth = Math.max(percentWidth,0);
               super.percentWidth = Math.min(percentWidth,100);
               if(FlexVersion.compatibilityVersion >= FlexVersion.VERSION_4_0)
               {
                  w = percentWidth * DisplayObject(systemManager).width / 100;
               }
               else
               {
                  w = percentWidth * screen.width / 100;
               }
            }
            if(!isNaN(explicitMaxWidth))
            {
               w = Math.min(w,explicitMaxWidth);
            }
            if(!isNaN(explicitMinWidth))
            {
               w = Math.max(w,explicitMinWidth);
            }
         }
         else
         {
            w = Number(width);
         }
         if(this.resizeHeight)
         {
            if(isNaN(percentHeight))
            {
               h = DisplayObject(systemManager).height;
            }
            else
            {
               super.percentHeight = Math.max(percentHeight,0);
               super.percentHeight = Math.min(percentHeight,100);
               if(FlexVersion.compatibilityVersion >= FlexVersion.VERSION_4_0)
               {
                  h = percentHeight * DisplayObject(systemManager).height / 100;
               }
               else
               {
                  h = percentHeight * screen.height / 100;
               }
            }
            if(!isNaN(explicitMaxHeight))
            {
               h = Math.min(h,explicitMaxHeight);
            }
            if(!isNaN(explicitMinHeight))
            {
               h = Math.max(h,explicitMinHeight);
            }
         }
         else
         {
            h = Number(height);
         }
         if(w != width || h != height)
         {
            invalidateProperties();
            invalidateSize();
         }
         setActualSize(w,h);
         invalidateDisplayList();
      }
   }
}

