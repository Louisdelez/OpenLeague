package spark.components
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.events.ContextMenuEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.SoftKeyboardEvent;
   import flash.events.UncaughtErrorEvent;
   import flash.external.ExternalInterface;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.Capabilities;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.utils.Dictionary;
   import flash.utils.setInterval;
   import mx.core.EventPriority;
   import mx.core.FlexGlobals;
   import mx.core.IInvalidating;
   import mx.core.InteractionMode;
   import mx.core.Singleton;
   import mx.core.UIComponentGlobals;
   import mx.managers.FocusManager;
   import mx.managers.IActiveWindowManager;
   import mx.managers.ILayoutManager;
   import mx.managers.ISystemManager;
   import mx.managers.SystemManager;
   import mx.managers.ToolTipManager;
   import mx.utils.BitFlagUtil;
   import mx.utils.DensityUtil;
   import mx.utils.LoaderUtil;
   import spark.layouts.supportClasses.LayoutBase;
   
   [ResourceBundle("components")]
   [Frame(factoryClass="mx.managers.SystemManager")]
   [Exclude(name="y",kind="property")]
   [Exclude(name="x",kind="property")]
   [Exclude(name="toolTip",kind="property")]
   [Exclude(name="tabIndex",kind="property")]
   [Exclude(name="direction",kind="property")]
   [Style(name="backgroundColor",type="uint",format="Color",inherit="no")]
   [Event(name="uncaughtError",type="flash.events.UncaughtErrorEvent")]
   [Event(name="error",type="flash.events.ErrorEvent")]
   [Event(name="applicationComplete",type="mx.events.FlexEvent")]
   public class Application extends SkinnableContainer
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const CONTROLBAR_PROPERTY_FLAG:uint = 1 << 0;
      
      private static const LAYOUT_PROPERTY_FLAG:uint = 1 << 1;
      
      private static const VISIBLE_PROPERTY_FLAG:uint = 1 << 2;
      
      private static var _softKeyboardBehavior:String = null;
      
      private static var _skinParts:Object = {
         "contentGroup":false,
         "controlBarGroup":false
      };
      
      private var isIOS:Boolean = false;
      
      private var softKeyboardTarget:Object = null;
      
      private var explicitSizingForOrientation:Boolean = false;
      
      private var cachedDimensions:Dictionary;
      
      private var previousWidth:Number;
      
      private var previousHeight:Number;
      
      private var keyboardActiveInOrientationChange:Boolean = false;
      
      private var resizeHandlerAdded:Boolean = false;
      
      private var percentBoundsChanged:Boolean;
      
      private var preloadObj:Object;
      
      private var resizeWidth:Boolean = true;
      
      private var resizeHeight:Boolean = true;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var isSoftKeyboardActive:Boolean = false;
      
      private var synchronousResize:Boolean = false;
      
      private var viewSourceCMI:ContextMenuItem;
      
      private var controlBarGroupProperties:Object = {"visible":true};
      
      [SkinPart(required="false")]
      public var controlBarGroup:Group;
      
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
      
      [Inspectable(enumeration="none,letterbox,stretch,zoom",defaultValue="none")]
      public var splashScreenScaleMode:String;
      
      public var splashScreenMinimumDisplayTime:Number;
      
      private var _applicationDPI:Number = NaN;
      
      [Inspectable(defaultValue="true")]
      public var usePreloader:Boolean;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _parameters:Object;
      
      private var _resizeForSoftKeyboard:Boolean = false;
      
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
         showInAutomationHierarchy = true;
         this.initResizeBehavior();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function get softKeyboardBehavior() : String
      {
         var nativeApp:Object = null;
         var appXML:XML = null;
         var ns:Namespace = null;
         if(_softKeyboardBehavior != null)
         {
            return _softKeyboardBehavior;
         }
         nativeApp = FlexGlobals.topLevelApplication.systemManager.getDefinitionByName("flash.desktop.NativeApplication");
         if(Boolean(nativeApp))
         {
            try
            {
               appXML = XML(nativeApp["nativeApplication"]["applicationDescriptor"]);
               ns = appXML.namespace();
               _softKeyboardBehavior = String(appXML..ns::softKeyboardBehavior);
            }
            catch(e:Error)
            {
               _softKeyboardBehavior = "";
            }
         }
         else
         {
            _softKeyboardBehavior = "";
         }
         return _softKeyboardBehavior;
      }
      
      private function get scaleFactor() : Number
      {
         if(Boolean(systemManager))
         {
            return (systemManager as SystemManager).densityScale;
         }
         return 1;
      }
      
      [Inspectable(enumeration="default,off,on",defaultValue="default")]
      public function get colorCorrection() : String
      {
         var sm:ISystemManager = null;
         try
         {
            sm = systemManager;
            if(Boolean(sm) && Boolean(sm.stage))
            {
               return sm.stage.colorCorrection;
            }
         }
         catch(e:SecurityError)
         {
         }
         return null;
      }
      
      public function set colorCorrection(value:String) : void
      {
         var sm:ISystemManager = systemManager;
         if(Boolean(sm) && Boolean(sm.stage) && Boolean(sm.isTopLevelRoot()))
         {
            sm.stage.colorCorrection = value;
         }
      }
      
      [ArrayElementType("mx.core.IVisualElement")]
      public function get controlBarContent() : Array
      {
         if(Boolean(this.controlBarGroup))
         {
            return this.controlBarGroup.getMXMLContent();
         }
         return this.controlBarGroupProperties.controlBarContent;
      }
      
      public function set controlBarContent(value:Array) : void
      {
         if(Boolean(this.controlBarGroup))
         {
            this.controlBarGroup.mxmlContent = value;
            this.controlBarGroupProperties = BitFlagUtil.update(this.controlBarGroupProperties as uint,CONTROLBAR_PROPERTY_FLAG,value != null);
         }
         else
         {
            this.controlBarGroupProperties.controlBarContent = value;
         }
         invalidateSkinState();
      }
      
      public function get controlBarLayout() : LayoutBase
      {
         return Boolean(this.controlBarGroup) ? this.controlBarGroup.layout : this.controlBarGroupProperties.layout;
      }
      
      public function set controlBarLayout(value:LayoutBase) : void
      {
         if(Boolean(this.controlBarGroup))
         {
            this.controlBarGroup.layout = value;
            this.controlBarGroupProperties = BitFlagUtil.update(this.controlBarGroupProperties as uint,LAYOUT_PROPERTY_FLAG,true);
         }
         else
         {
            this.controlBarGroupProperties.layout = value;
         }
      }
      
      public function get controlBarVisible() : Boolean
      {
         return Boolean(this.controlBarGroup) ? Boolean(this.controlBarGroup.visible) : Boolean(this.controlBarGroupProperties.visible);
      }
      
      public function set controlBarVisible(value:Boolean) : void
      {
         if(Boolean(this.controlBarGroup))
         {
            this.controlBarGroup.visible = value;
            this.controlBarGroupProperties = BitFlagUtil.update(this.controlBarGroupProperties as uint,VISIBLE_PROPERTY_FLAG,value);
         }
         else
         {
            this.controlBarGroupProperties.visible = value;
         }
         invalidateSkinState();
         if(Boolean(skin))
         {
            skin.invalidateSize();
         }
      }
      
      public function get splashScreenImage() : Class
      {
         return systemManager.info()["splashScreenImage"];
      }
      
      public function set splashScreenImage(value:Class) : void
      {
         systemManager.info()["splashScreenImage"] = value;
      }
      
      [Inspectable(category="General",enumeration="160,240,320")]
      public function get applicationDPI() : Number
      {
         var value:String = null;
         if(isNaN(this._applicationDPI))
         {
            value = systemManager.info()["applicationDPI"];
            this._applicationDPI = Boolean(value) ? Number(value) : this.runtimeDPI;
         }
         return this._applicationDPI;
      }
      
      public function set applicationDPI(value:Number) : void
      {
      }
      
      public function get runtimeDPI() : Number
      {
         return DensityUtil.getRuntimeDPI();
      }
      
      public function get runtimeDPIProvider() : Class
      {
         return systemManager.info()["runtimeDPIProvider"];
      }
      
      public function set runtimeDPIProvider(value:Class) : void
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
      
      public function get aspectRatio() : String
      {
         var actualHeight:Number = Number(height);
         if(this.isSoftKeyboardActive && softKeyboardBehavior == "none" && this.resizeForSoftKeyboard)
         {
            actualHeight += stage.softKeyboardRect.height;
         }
         return width > actualHeight ? "landscape" : "portrait";
      }
      
      public function get parameters() : Object
      {
         return this._parameters;
      }
      
      public function get resizeForSoftKeyboard() : Boolean
      {
         return this._resizeForSoftKeyboard;
      }
      
      public function set resizeForSoftKeyboard(value:Boolean) : void
      {
         if(this._resizeForSoftKeyboard != value)
         {
            this._resizeForSoftKeyboard = value;
         }
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      public function get viewSourceURL() : String
      {
         return this._viewSourceURL;
      }
      
      public function set viewSourceURL(value:String) : void
      {
         this._viewSourceURL = value;
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
         var sm:ISystemManager = systemManager;
         if(hasEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR))
         {
            systemManager.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,this.uncaughtErrorRedispatcher);
         }
         this.isIOS = Capabilities.version.indexOf("IOS") == 0;
         if(Boolean(this.isIOS && sm) && Boolean(sm.stage) && Boolean(sm.isTopLevelRoot()))
         {
            sm.stage.addEventListener("orientationChanging",this.stage_orientationChangingHandler);
            sm.stage.addEventListener("orientationChange",this.stage_orientationChange);
         }
         this._url = LoaderUtil.normalizeURL(sm.loaderInfo);
         this._parameters = sm.loaderInfo.parameters;
         this.initManagers(sm);
         this.initContextMenu();
         super.initialize();
         if(Boolean(sm.isTopLevel()) && Capabilities.isDebugger == true)
         {
            setInterval(this.debugTickler,1500);
         }
      }
      
      private function stage_orientationChangingHandler(event:Event) : void
      {
         var newWidth:Number = NaN;
         var newHeight:Number = NaN;
         var sm:ISystemManager = systemManager;
         if(!stage || !isNaN(explicitWidth) || !isNaN(explicitHeight))
         {
            return;
         }
         if(!this.cachedDimensions)
         {
            this.cachedDimensions = new Dictionary();
         }
         this.previousWidth = width;
         this.previousHeight = height;
         var key:String = width + ":" + height;
         this.keyboardActiveInOrientationChange = this.isSoftKeyboardActive;
         var beforeOrientation:String = event["beforeOrientation"];
         var afterOrientation:String = event["afterOrientation"];
         if(beforeOrientation == "default" && afterOrientation == "upsideDown" || beforeOrientation == "upsideDown" && afterOrientation == "default" || beforeOrientation == "rotatedLeft" && afterOrientation == "rotatedRight" || beforeOrientation == "rotatedRight" && afterOrientation == "rotatedLeft")
         {
            return;
         }
         if(Boolean(this.cachedDimensions[key]))
         {
            newWidth = Number(this.cachedDimensions[key].width);
            newHeight = Number(this.cachedDimensions[key].height);
         }
         else
         {
            newWidth = Boolean(stage) ? stage.stageHeight / this.scaleFactor : Number(height);
            newHeight = Number(width);
         }
         setActualSize(newWidth,newHeight);
         this.explicitSizingForOrientation = true;
         validateNow();
      }
      
      private function stage_orientationChange(event:Event) : void
      {
         if(!stage || !this.explicitSizingForOrientation)
         {
            return;
         }
         if(!this.keyboardActiveInOrientationChange)
         {
            this.updateScreenSizeCache(stage.stageWidth / this.scaleFactor,stage.stageHeight / this.scaleFactor);
         }
         this.explicitSizingForOrientation = false;
      }
      
      private function updateScreenSizeCache(newWidth:Number, newHeight:Number) : void
      {
         var orientationChangeKey:String = null;
         var reverseOrientationChangeKey:String = null;
         if(this.previousWidth == newWidth && this.previousHeight == newHeight)
         {
            return;
         }
         var key:String = this.previousWidth + ":" + this.previousHeight;
         if(Boolean(this.cachedDimensions[key]))
         {
            this.cachedDimensions[key].width = newWidth;
            this.cachedDimensions[key].height = newHeight;
         }
         else
         {
            orientationChangeKey = this.previousWidth + ":" + this.previousHeight;
            reverseOrientationChangeKey = newWidth + ":" + newHeight;
            this.cachedDimensions[orientationChangeKey] = {
               "width":newWidth,
               "height":newHeight
            };
            this.cachedDimensions[reverseOrientationChangeKey] = {
               "width":this.previousWidth,
               "height":this.previousHeight
            };
         }
      }
      
      override protected function createChildren() : void
      {
         var nativeApp:Object = null;
         super.createChildren();
         if(softKeyboardBehavior != "")
         {
            this.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE,this.softKeyboardActivateHandler,true,EventPriority.DEFAULT,true);
            this.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE,this.softKeyboardDeactivateHandler,true,EventPriority.DEFAULT,true);
            nativeApp = FlexGlobals.topLevelApplication.systemManager.getDefinitionByName("flash.desktop.NativeApplication");
            if(Boolean(nativeApp) && Boolean(nativeApp["nativeApplication"]))
            {
               EventDispatcher(nativeApp["nativeApplication"]).addEventListener(Event.DEACTIVATE,this.nativeApplication_deactivateHandler);
            }
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
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         if(Boolean(this.viewSourceCMI))
         {
            this.viewSourceCMI.caption = resourceManager.getString("components","viewSource");
         }
      }
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         var newControlBarGroupProperties:uint = 0;
         super.partAdded(partName,instance);
         if(instance == this.controlBarGroup)
         {
            newControlBarGroupProperties = 0;
            if(this.controlBarGroupProperties.controlBarContent !== undefined)
            {
               this.controlBarGroup.mxmlContent = this.controlBarGroupProperties.controlBarContent;
               newControlBarGroupProperties = uint(BitFlagUtil.update(newControlBarGroupProperties,CONTROLBAR_PROPERTY_FLAG,true));
            }
            if(this.controlBarGroupProperties.layout !== undefined)
            {
               this.controlBarGroup.layout = this.controlBarGroupProperties.layout;
               newControlBarGroupProperties = uint(BitFlagUtil.update(newControlBarGroupProperties,LAYOUT_PROPERTY_FLAG,true));
            }
            if(this.controlBarGroupProperties.visible !== undefined)
            {
               this.controlBarGroup.visible = this.controlBarGroupProperties.visible;
               newControlBarGroupProperties = uint(BitFlagUtil.update(newControlBarGroupProperties,VISIBLE_PROPERTY_FLAG,true));
            }
            this.controlBarGroupProperties = newControlBarGroupProperties;
         }
      }
      
      override protected function partRemoved(partName:String, instance:Object) : void
      {
         var newControlBarGroupProperties:Object = null;
         super.partRemoved(partName,instance);
         if(instance == this.controlBarGroup)
         {
            newControlBarGroupProperties = {};
            if(BitFlagUtil.isSet(this.controlBarGroupProperties as uint,CONTROLBAR_PROPERTY_FLAG))
            {
               newControlBarGroupProperties.controlBarContent = this.controlBarGroup.getMXMLContent();
            }
            if(BitFlagUtil.isSet(this.controlBarGroupProperties as uint,LAYOUT_PROPERTY_FLAG))
            {
               newControlBarGroupProperties.layout = this.controlBarGroup.layout;
            }
            if(BitFlagUtil.isSet(this.controlBarGroupProperties as uint,VISIBLE_PROPERTY_FLAG))
            {
               newControlBarGroupProperties.visible = this.controlBarGroup.visible;
            }
            this.controlBarGroupProperties = newControlBarGroupProperties;
            this.controlBarGroup.mxmlContent = null;
            this.controlBarGroup.layout = null;
         }
      }
      
      override protected function getCurrentSkinState() : String
      {
         var state:String = enabled ? "normal" : "disabled";
         if(Boolean(this.controlBarGroup))
         {
            if(Boolean(BitFlagUtil.isSet(this.controlBarGroupProperties as uint,CONTROLBAR_PROPERTY_FLAG)) && Boolean(BitFlagUtil.isSet(this.controlBarGroupProperties as uint,VISIBLE_PROPERTY_FLAG)))
            {
               state += "WithControlBar";
            }
         }
         else if(Boolean(this.controlBarGroupProperties.controlBarContent) && Boolean(this.controlBarGroupProperties.visible))
         {
            state += "WithControlBar";
         }
         return state;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         if(!styleProp || styleProp == "styleName" || styleProp == "interactionMode")
         {
            ToolTipManager.enabled = getStyle("interactionMode") != InteractionMode.TOUCH;
         }
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
               InteractiveObject(systemManager).contextMenu = contextMenu as ContextMenu;
            }
            return;
         }
         var defaultMenu:ContextMenu = new ContextMenu();
         defaultMenu.hideBuiltInItems();
         defaultMenu.builtInItems.print = true;
         if(Boolean(this._viewSourceURL))
         {
            caption = resourceManager.getString("components","viewSource");
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
      
      private function initResizeBehavior() : void
      {
         var version:Array = Capabilities.version.split(" ")[1].split(",");
         var versionPrefix:String = Capabilities.version.substr(0,3).toLowerCase();
         var runningOnMobile:Boolean = versionPrefix != "win" && versionPrefix != "mac" && versionPrefix != "lnx";
         this.synchronousResize = (parseFloat(version[0]) > 10 || parseFloat(version[0]) == 10 && parseFloat(version[1]) >= 1) && (Capabilities.playerType != "Desktop" || runningOnMobile);
      }
      
      private function softKeyboardActivateHandler(event:SoftKeyboardEvent) : void
      {
         var keyboardRect:Rectangle = null;
         var appHeight:Number = NaN;
         var appWidth:Number = NaN;
         if(this === FlexGlobals.topLevelApplication)
         {
            if(Boolean(this.softKeyboardTarget) && this.softKeyboardTarget != event.target)
            {
               this.clearSoftKeyboardTarget();
            }
            this.softKeyboardTarget = event.target;
            this.softKeyboardTarget.addEventListener(Event.REMOVED_FROM_STAGE,this.softKeyboardTarget_removeFromStageHandler,false,EventPriority.DEFAULT,true);
            if(this.isIOS)
            {
               this.softKeyboardTarget.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE,this.softKeyboardDeactivateHandler,false,EventPriority.DEFAULT,true);
            }
            keyboardRect = stage.softKeyboardRect;
            if(keyboardRect.height > 0)
            {
               this.isSoftKeyboardActive = true;
            }
            if(softKeyboardBehavior == "none" && this.resizeForSoftKeyboard)
            {
               appHeight = (stage.stageHeight - keyboardRect.height) / this.scaleFactor;
               appWidth = stage.stageWidth / this.scaleFactor;
               if(appHeight != height || appWidth != width)
               {
                  setActualSize(appWidth,appHeight);
                  validateNow();
               }
               if(this.keyboardActiveInOrientationChange)
               {
                  this.keyboardActiveInOrientationChange = false;
                  this.updateScreenSizeCache(appWidth,appHeight);
               }
            }
         }
      }
      
      private function softKeyboardDeactivateHandler(event:SoftKeyboardEvent) : void
      {
         if(this === FlexGlobals.topLevelApplication && this.isSoftKeyboardActive)
         {
            if(Boolean(this.softKeyboardTarget))
            {
               this.clearSoftKeyboardTarget();
            }
            this.isSoftKeyboardActive = false;
            if(softKeyboardBehavior == "none" && this.resizeForSoftKeyboard && !this.keyboardActiveInOrientationChange)
            {
               setActualSize(stage.stageWidth / this.scaleFactor,stage.stageHeight / this.scaleFactor);
               validateNow();
            }
         }
      }
      
      private function nativeApplication_deactivateHandler(event:Event) : void
      {
         if(this.isSoftKeyboardActive)
         {
            stage.focus = null;
            this.softKeyboardDeactivateHandler(null);
         }
      }
      
      private function softKeyboardTarget_removeFromStageHandler(event:Event) : void
      {
         if(stage.focus == this.softKeyboardTarget)
         {
            stage.focus = null;
         }
      }
      
      private function clearSoftKeyboardTarget() : void
      {
         if(Boolean(this.softKeyboardTarget))
         {
            if(this.isIOS)
            {
               this.softKeyboardTarget.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE,this.softKeyboardDeactivateHandler);
            }
            this.softKeyboardTarget.removeEventListener(Event.REMOVED_FROM_STAGE,this.softKeyboardTarget_removeFromStageHandler);
            this.softKeyboardTarget = null;
         }
      }
      
      private function resizeHandler(event:Event) : void
      {
         if(this.keyboardActiveInOrientationChange)
         {
            return;
         }
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
         if(this.keyboardActiveInOrientationChange)
         {
            return;
         }
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
               w = percentWidth * DisplayObject(systemManager).width / 100;
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
               h = percentHeight * DisplayObject(systemManager).height / 100;
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
      
      override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         if(type == UncaughtErrorEvent.UNCAUGHT_ERROR && Boolean(systemManager))
         {
            systemManager.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,this.uncaughtErrorRedispatcher);
         }
         super.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         super.removeEventListener(type,listener,useCapture);
         if(type == UncaughtErrorEvent.UNCAUGHT_ERROR && Boolean(systemManager))
         {
            systemManager.loaderInfo.uncaughtErrorEvents.removeEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,this.uncaughtErrorRedispatcher);
         }
      }
      
      private function uncaughtErrorRedispatcher(event:Event) : void
      {
         if(!dispatchEvent(event))
         {
            event.preventDefault();
         }
      }
   }
}

