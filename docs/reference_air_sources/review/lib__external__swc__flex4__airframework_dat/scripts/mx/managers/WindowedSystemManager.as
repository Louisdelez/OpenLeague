package mx.managers
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.InteractiveObject;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.system.ApplicationDomain;
   import flash.text.Font;
   import flash.text.TextFormat;
   import flash.ui.ContextMenu;
   import flash.utils.Dictionary;
   import mx.core.FlexSprite;
   import mx.core.IChildList;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModule;
   import mx.core.IUIComponent;
   import mx.core.IWindow;
   import mx.core.RSLData;
   import mx.core.Singleton;
   import mx.core.mx_internal;
   import mx.events.DynamicEvent;
   import mx.events.FlexEvent;
   import mx.events.Request;
   import mx.events.SandboxMouseEvent;
   import mx.managers.systemClasses.ChildManager;
   import mx.styles.ISimpleStyleClient;
   import mx.styles.IStyleClient;
   
   public class WindowedSystemManager extends MovieClip implements ISystemManager
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var topLevel:Boolean = true;
      
      private var initialized:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var topLevelWindow:IUIComponent;
      
      private var myWindow:IWindow;
      
      private var _topLevelSystemManager:ISystemManager;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var childManager:ISystemManagerChildManager;
      
      private var isStageRoot:Boolean = true;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var idleCounter:int = 0;
      
      private var isBootstrapRoot:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var nestLevel:int = 0;
      
      private var mouseCatcher:Sprite;
      
      private var _applicationIndex:int = 1;
      
      private var _allowDomainsInNewRSLs:Boolean = true;
      
      private var _allowInsecureDomainsInNewRSLs:Boolean = true;
      
      private var _cursorChildren:WindowedSystemChildrenList;
      
      private var _cursorIndex:int = 0;
      
      private var _document:Object;
      
      private var _fontList:Object = null;
      
      private var _focusPane:Sprite;
      
      private var _numModalWindows:int = 0;
      
      private var _popUpChildren:WindowedSystemChildrenList;
      
      private var _noTopMostIndex:int = 0;
      
      private var _rawChildren:WindowedSystemRawChildrenList;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _screen:Rectangle;
      
      private var _toolTipChildren:WindowedSystemChildrenList;
      
      private var _toolTipIndex:int = 0;
      
      private var _topMostIndex:int = 0;
      
      private var _width:Number;
      
      private var _window:IWindow = null;
      
      private var _height:Number;
      
      private var implMap:Object = {};
      
      private var isDispatchingResizeEvent:Boolean;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _mouseX:*;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _mouseY:*;
      
      public function WindowedSystemManager(rootObj:IUIComponent)
      {
         super();
         this._topLevelSystemManager = this;
         this.topLevelWindow = rootObj;
         SystemManagerGlobals.topLevelSystemManagers.push(this);
         this.childManager = new ChildManager(this);
         this.addEventListener(Event.ADDED,this.docFrameHandler);
      }
      
      private static function getChildListIndex(childList:IChildList, f:Object) : int
      {
         var index:int = -1;
         try
         {
            index = int(childList.getChildIndex(DisplayObject(f)));
         }
         catch(e:ArgumentError)
         {
         }
         return index;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get applicationIndex() : int
      {
         return this._applicationIndex;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set applicationIndex(value:int) : void
      {
         this._applicationIndex = value;
      }
      
      public function get allowDomainsInNewRSLs() : Boolean
      {
         return this._allowDomainsInNewRSLs;
      }
      
      public function set allowDomainsInNewRSLs(value:Boolean) : void
      {
         this._allowDomainsInNewRSLs = value;
      }
      
      public function get allowInsecureDomainsInNewRSLs() : Boolean
      {
         return this._allowInsecureDomainsInNewRSLs;
      }
      
      public function set allowInsecureDomainsInNewRSLs(value:Boolean) : void
      {
         this._allowInsecureDomainsInNewRSLs = value;
      }
      
      public function get cursorChildren() : IChildList
      {
         if(!this.topLevel)
         {
            return this._topLevelSystemManager.cursorChildren;
         }
         if(!this._cursorChildren)
         {
            this._cursorChildren = new WindowedSystemChildrenList(this,new QName(mx_internal,"toolTipIndex"),new QName(mx_internal,"cursorIndex"));
         }
         return this._cursorChildren;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get cursorIndex() : int
      {
         return this._cursorIndex;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set cursorIndex(value:int) : void
      {
         var delta:int = value - this._cursorIndex;
         this._cursorIndex = value;
      }
      
      public function get document() : Object
      {
         return this._document;
      }
      
      public function set document(value:Object) : void
      {
         this._document = value;
      }
      
      public function get embeddedFontList() : Object
      {
         var o:Object = null;
         var p:String = null;
         var fl:Object = null;
         if(this._fontList == null)
         {
            this._fontList = {};
            o = this.info()["fonts"];
            for(p in o)
            {
               this._fontList[p] = o[p];
            }
            if(!this.topLevel && Boolean(this._topLevelSystemManager))
            {
               fl = this._topLevelSystemManager.embeddedFontList;
               for(p in fl)
               {
                  this._fontList[p] = fl[p];
               }
            }
         }
         return this._fontList;
      }
      
      public function get focusPane() : Sprite
      {
         return this._focusPane;
      }
      
      public function set focusPane(value:Sprite) : void
      {
         if(Boolean(value))
         {
            this.addChild(value);
            value.x = 0;
            value.y = 0;
            value.scrollRect = null;
            this._focusPane = value;
         }
         else
         {
            this.removeChild(this._focusPane);
            this._focusPane = null;
         }
      }
      
      public function get isProxy() : Boolean
      {
         return false;
      }
      
      final §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get $numChildren() : int
      {
         return super.numChildren;
      }
      
      public function get numModalWindows() : int
      {
         return this._numModalWindows;
      }
      
      public function set numModalWindows(value:int) : void
      {
         this._numModalWindows = value;
      }
      
      public function get preloadedRSLs() : Dictionary
      {
         return null;
      }
      
      public function get popUpChildren() : IChildList
      {
         if(!this.topLevel)
         {
            return this._topLevelSystemManager.popUpChildren;
         }
         if(!this._popUpChildren)
         {
            this._popUpChildren = new WindowedSystemChildrenList(this,new QName(mx_internal,"noTopMostIndex"),new QName(mx_internal,"topMostIndex"));
         }
         return this._popUpChildren;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get noTopMostIndex() : int
      {
         return this._noTopMostIndex;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set noTopMostIndex(value:int) : void
      {
         var delta:int = value - this._noTopMostIndex;
         this._noTopMostIndex = value;
         this.topMostIndex += delta;
      }
      
      public function get rawChildren() : IChildList
      {
         if(!this.topLevel)
         {
            return this._topLevelSystemManager.rawChildren;
         }
         if(!this._rawChildren)
         {
            this._rawChildren = new WindowedSystemRawChildrenList(this);
         }
         return this._rawChildren;
      }
      
      public function get screen() : Rectangle
      {
         if(!this._screen)
         {
            this._screen = new Rectangle();
         }
         this._screen.x = 0;
         this._screen.y = 0;
         this._screen.width = stage.stageWidth;
         this._screen.height = stage.stageHeight;
         return this._screen;
      }
      
      public function get toolTipChildren() : IChildList
      {
         if(!this.topLevel)
         {
            return this._topLevelSystemManager.toolTipChildren;
         }
         if(!this._toolTipChildren)
         {
            this._toolTipChildren = new WindowedSystemChildrenList(this,new QName(mx_internal,"topMostIndex"),new QName(mx_internal,"toolTipIndex"));
         }
         return this._toolTipChildren;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get toolTipIndex() : int
      {
         return this._toolTipIndex;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set toolTipIndex(value:int) : void
      {
         var delta:int = value - this._toolTipIndex;
         this._toolTipIndex = value;
         this.cursorIndex += delta;
      }
      
      public function get topLevelSystemManager() : ISystemManager
      {
         if(this.topLevel)
         {
            return this;
         }
         return this._topLevelSystemManager;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get topMostIndex() : int
      {
         return this._topMostIndex;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set topMostIndex(value:int) : void
      {
         var delta:int = value - this._topMostIndex;
         this._topMostIndex = value;
         this.toolTipIndex += delta;
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get window() : IWindow
      {
         return this._window;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set window(value:IWindow) : void
      {
         this._window = value;
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
      
      public function get childAllowsParent() : Boolean
      {
         try
         {
            return loaderInfo.childAllowsParent;
         }
         catch(error:Error)
         {
         }
         return false;
      }
      
      public function get parentAllowsChild() : Boolean
      {
         try
         {
            return loaderInfo.parentAllowsChild;
         }
         catch(error:Error)
         {
         }
         return false;
      }
      
      final §§namespace("http://www.adobe.com/2006/flex/mx/internal") function $addChild(child:DisplayObject) : DisplayObject
      {
         return super.addChild(child);
      }
      
      final §§namespace("http://www.adobe.com/2006/flex/mx/internal") function $addChildAt(child:DisplayObject, index:int) : DisplayObject
      {
         return super.addChildAt(child,index);
      }
      
      final §§namespace("http://www.adobe.com/2006/flex/mx/internal") function $removeChild(child:DisplayObject) : DisplayObject
      {
         return super.removeChild(child);
      }
      
      final §§namespace("http://www.adobe.com/2006/flex/mx/internal") function $removeChildAt(index:int) : DisplayObject
      {
         return super.removeChildAt(index);
      }
      
      public function callInContext(fn:Function, thisArg:Object, argArray:Array, returns:Boolean = true) : *
      {
         if(returns)
         {
            return fn.apply(thisArg,argArray);
         }
         fn.apply(thisArg,argArray);
      }
      
      public function create(... params) : Object
      {
         var mainClassName:String = String(params[0]);
         var mainClass:Class = Class(this.getDefinitionByName(mainClassName));
         if(!mainClass)
         {
            throw new Error("Class \'" + mainClassName + "\' not found.");
         }
         var instance:Object = new mainClass();
         if(instance is IFlexModule)
         {
            IFlexModule(instance).moduleFactory = this;
         }
         return instance;
      }
      
      protected function docFrameHandler(event:Event = null) : void
      {
         var n:int = 0;
         var i:int = 0;
         var c:Class = null;
         this.removeEventListener(Event.ADDED,this.docFrameHandler);
         if(Boolean(stage))
         {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
         }
         var mixinList:Array = this.info()["mixins"];
         if(Boolean(mixinList) && mixinList.length > 0)
         {
            n = int(mixinList.length);
            for(i = 0; i < n; i++)
            {
               c = Class(this.getDefinitionByName(mixinList[i]));
               c["init"](this);
            }
         }
         c = Singleton.getClass("mx.managers::IActiveWindowManager");
         if(Boolean(c))
         {
            this.registerImplementation("mx.managers::IActiveWindowManager",new c(this));
         }
         c = Singleton.getClass("mx.managers::IMarshalSystemManager");
         if(Boolean(c))
         {
            this.registerImplementation("mx.managers::IMarshalSystemManager",new c(this));
         }
         this.initializeTopLevelWindow(null);
         if(Singleton.getClass("mx.managers::IDragManager").getInstance() is NativeDragManagerImpl)
         {
            NativeDragManagerImpl(Singleton.getClass("mx.managers::IDragManager").getInstance()).registerSystemManager(this);
         }
      }
      
      protected function initializeTopLevelWindow(event:Event) : void
      {
         var app:IUIComponent = null;
         var obj:DisplayObjectContainer = null;
         this.initialized = true;
         if(this.getSandboxRoot() == this)
         {
            this.addEventListener(MouseEvent.MOUSE_WHEEL,this.mouseEventHandler,true,1000);
            this.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseEventHandler,true,1000);
         }
         if(this.isTopLevelRoot() && Boolean(stage))
         {
            stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.mouseEventHandler,false,1000);
            stage.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseEventHandler,false,1000);
         }
         if(!parent)
         {
            return;
         }
         this.initContextMenu();
         if(!this.topLevel)
         {
            if(!parent)
            {
               return;
            }
            obj = parent.parent;
            if(!obj)
            {
               return;
            }
            while(Boolean(obj))
            {
               if(obj is IUIComponent)
               {
                  this._topLevelSystemManager = IUIComponent(obj).systemManager;
                  break;
               }
               obj = obj.parent;
            }
         }
         stage.addEventListener(Event.RESIZE,this.Stage_resizeHandler,false,0,true);
         this.document = app = this.topLevelWindow;
         if(Boolean(this.document))
         {
            if(this.topLevel && Boolean(stage))
            {
               this._width = stage.stageWidth;
               this._height = stage.stageHeight;
               IFlexDisplayObject(app).setActualSize(stage.stageWidth,stage.stageHeight);
            }
            else
            {
               IFlexDisplayObject(app).setActualSize(loaderInfo.width,loaderInfo.height);
            }
            this.addingChild(DisplayObject(app));
            this.childAdded(DisplayObject(app));
         }
         else
         {
            this.document = this;
         }
         this.addChildAndMouseCatcher();
      }
      
      private function addChildAndMouseCatcher() : void
      {
         var app:IUIComponent = this.topLevelWindow;
         this.mouseCatcher = new FlexSprite();
         this.mouseCatcher.name = "mouseCatcher";
         ++this.noTopMostIndex;
         super.addChildAt(this.mouseCatcher,0);
         this.resizeMouseCatcher();
         if(!this.topLevel)
         {
            this.mouseCatcher.visible = false;
            mask = this.mouseCatcher;
         }
         ++this.noTopMostIndex;
         super.addChild(DisplayObject(app));
      }
      
      public function info() : Object
      {
         return {"currentDomain":ApplicationDomain.currentDomain};
      }
      
      private function initContextMenu() : void
      {
         var defaultMenu:ContextMenu = new ContextMenu();
         defaultMenu.hideBuiltInItems();
         defaultMenu.builtInItems.print = true;
         contextMenu = defaultMenu;
      }
      
      public function isTopLevelRoot() : Boolean
      {
         return this.isStageRoot || this.isBootstrapRoot;
      }
      
      public function getTopLevelRoot() : DisplayObject
      {
         var sm:ISystemManager = null;
         var parent:DisplayObject = null;
         var lastParent:DisplayObject = null;
         try
         {
            sm = this;
            if(Boolean(sm.topLevelSystemManager))
            {
               sm = ISystemManager(sm.topLevelSystemManager);
            }
            parent = DisplayObject(sm).parent;
            lastParent = DisplayObject(sm);
            while(Boolean(parent))
            {
               if(parent is Stage)
               {
                  return lastParent;
               }
               lastParent = parent;
               parent = parent.parent;
            }
         }
         catch(error:SecurityError)
         {
         }
         return null;
      }
      
      public function getSandboxRoot() : DisplayObject
      {
         var parent:DisplayObject = null;
         var lastParent:DisplayObject = null;
         var loader:Loader = null;
         var loaderInfo:LoaderInfo = null;
         var sm:ISystemManager = this;
         try
         {
            if(Boolean(sm.topLevelSystemManager))
            {
               sm = ISystemManager(sm.topLevelSystemManager);
            }
            parent = DisplayObject(sm).parent;
            if(parent is Stage)
            {
               return DisplayObject(sm);
            }
            if(Boolean(parent) && !parent.dispatchEvent(new Event("mx.managers.SystemManager.isBootstrapRoot",false,true)))
            {
               return this;
            }
            lastParent = this;
            while(Boolean(parent))
            {
               if(parent is Stage)
               {
                  return lastParent;
               }
               if(!parent.dispatchEvent(new Event("mx.managers.SystemManager.isBootstrapRoot",false,true)))
               {
                  return lastParent;
               }
               if(parent is Loader)
               {
                  loader = Loader(parent);
                  loaderInfo = loader.contentLoaderInfo;
                  if(!loaderInfo.childAllowsParent)
                  {
                     return loaderInfo.content;
                  }
               }
               if(parent.hasEventListener("systemManagerRequest"))
               {
                  lastParent = parent;
               }
               parent = parent.parent;
            }
         }
         catch(error:Error)
         {
         }
         return lastParent != null ? lastParent : DisplayObject(sm);
      }
      
      public function registerImplementation(interfaceName:String, impl:Object) : void
      {
         var c:Object = this.implMap[interfaceName];
         if(!c)
         {
            this.implMap[interfaceName] = impl;
         }
      }
      
      public function getImplementation(interfaceName:String) : Object
      {
         return this.implMap[interfaceName];
      }
      
      public function getVisibleApplicationRect(bounds:Rectangle = null, skipToSandboxRoot:Boolean = false) : Rectangle
      {
         var s:Rectangle = null;
         var pt:Point = null;
         var obj:DisplayObjectContainer = null;
         var visibleRect:Rectangle = null;
         var request:Request = new Request("getVisibleApplicationRect",false,true);
         if(!dispatchEvent(request))
         {
            return Rectangle(request.value);
         }
         if(skipToSandboxRoot && !this.topLevel)
         {
            return this.topLevelSystemManager.getVisibleApplicationRect(bounds,skipToSandboxRoot);
         }
         if(!bounds)
         {
            bounds = getBounds(DisplayObject(this));
            s = this.screen;
            pt = new Point(Math.max(0,bounds.x),Math.max(0,bounds.y));
            pt = localToGlobal(pt);
            bounds.x = pt.x;
            bounds.y = pt.y;
            bounds.width = s.width;
            bounds.height = s.height;
         }
         if(!this.topLevel)
         {
            obj = parent.parent;
            if("getVisibleApplicationRect" in obj)
            {
               visibleRect = obj["getVisibleApplicationRect"](true);
               bounds = bounds.intersection(visibleRect);
            }
         }
         return bounds;
      }
      
      public function deployMouseShields(deploy:Boolean) : void
      {
         var dynamicEvent:DynamicEvent = new DynamicEvent("deployMouseShields");
         dynamicEvent.deploy = deploy;
         dispatchEvent(dynamicEvent);
      }
      
      public function addPreloadedRSL(loaderInfo:LoaderInfo, rsl:Vector.<RSLData>) : void
      {
      }
      
      public function allowDomain(... domains) : void
      {
      }
      
      public function allowInsecureDomain(... domains) : void
      {
      }
      
      public function isTopLevelWindow(object:DisplayObject) : Boolean
      {
         return object is IUIComponent && IUIComponent(object) == this.topLevelWindow;
      }
      
      public function getDefinitionByName(name:String) : Object
      {
         var definition:Object = null;
         var domain:ApplicationDomain = ApplicationDomain.currentDomain;
         if(!this.topLevel && parent is Loader)
         {
            Loader(parent).contentLoaderInfo.applicationDomain;
         }
         else
         {
            this.info()["currentDomain"] as ApplicationDomain;
         }
         if(domain.hasDefinition(name))
         {
            definition = domain.getDefinition(name);
         }
         return definition;
      }
      
      public function isTopLevel() : Boolean
      {
         return this.topLevel;
      }
      
      public function isFontFaceEmbedded(textFormat:TextFormat) : Boolean
      {
         var font:Font = null;
         var style:String = null;
         var fontName:String = textFormat.font;
         var fl:Array = Font.enumerateFonts();
         for(var f:int = 0; f < fl.length; f++)
         {
            font = Font(fl[f]);
            if(font.fontName == fontName)
            {
               style = "regular";
               if(Boolean(textFormat.bold) && Boolean(textFormat.italic))
               {
                  style = "boldItalic";
               }
               else if(Boolean(textFormat.bold))
               {
                  style = "bold";
               }
               else if(Boolean(textFormat.italic))
               {
                  style = "italic";
               }
               if(font.fontStyle == style)
               {
                  return true;
               }
            }
         }
         if(!fontName || !this.embeddedFontList || !this.embeddedFontList[fontName])
         {
            return false;
         }
         var info:Object = this.embeddedFontList[fontName];
         return !(Boolean(textFormat.bold) && !info.bold || Boolean(textFormat.italic) && !info.italic || !textFormat.bold && !textFormat.italic && !info.regular);
      }
      
      private function Stage_resizeHandler(event:Event = null) : void
      {
         var w:Number = stage.stageWidth;
         var h:Number = stage.stageHeight;
         var y:Number = 0;
         var x:Number = 0;
         if(!this._screen)
         {
            this._screen = new Rectangle();
         }
         this._screen.x = x;
         this._screen.y = y;
         this._screen.width = w;
         this._screen.height = h;
         this._width = stage.stageWidth;
         this._height = stage.stageHeight;
         if(Boolean(event))
         {
            this.resizeMouseCatcher();
            dispatchEvent(event);
         }
      }
      
      private function resizeMouseCatcher() : void
      {
         var g:Graphics = null;
         if(Boolean(this.mouseCatcher))
         {
            g = this.mouseCatcher.graphics;
            g.clear();
            g.beginFill(0,0);
            g.drawRect(0,0,stage.stageWidth,stage.stageHeight);
            g.endFill();
         }
      }
      
      final §§namespace("http://www.adobe.com/2006/flex/mx/internal") function $addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         super.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         var request:DynamicEvent = null;
         if(type == MouseEvent.MOUSE_MOVE || type == MouseEvent.MOUSE_UP || type == MouseEvent.MOUSE_DOWN || type == Event.ACTIVATE || type == Event.DEACTIVATE)
         {
            try
            {
               if(Boolean(stage))
               {
                  stage.addEventListener(type,this.stageEventHandler,false,0,true);
               }
            }
            catch(error:SecurityError)
            {
            }
         }
         if(hasEventListener("addEventListener"))
         {
            request = new DynamicEvent("addEventListener",false,true);
            request.eventType = type;
            request.listener = listener;
            request.useCapture = useCapture;
            request.priority = priority;
            request.useWeakReference = useWeakReference;
            if(!dispatchEvent(request))
            {
               return;
            }
         }
         if(type == SandboxMouseEvent.MOUSE_UP_SOMEWHERE)
         {
            try
            {
               if(Boolean(stage))
               {
                  stage.addEventListener(Event.MOUSE_LEAVE,this.mouseLeaveHandler,false,0,true);
               }
               else
               {
                  super.addEventListener(Event.MOUSE_LEAVE,this.mouseLeaveHandler,false,0,true);
               }
            }
            catch(error:SecurityError)
            {
               super.addEventListener(Event.MOUSE_LEAVE,mouseLeaveHandler,false,0,true);
            }
         }
         if(type == FlexEvent.RENDER || type == FlexEvent.ENTER_FRAME)
         {
            if(type == FlexEvent.RENDER)
            {
               type = Event.RENDER;
            }
            else
            {
               type = Event.ENTER_FRAME;
            }
            try
            {
               if(Boolean(stage))
               {
                  stage.addEventListener(type,listener,useCapture,priority,useWeakReference);
               }
               else
               {
                  super.addEventListener(type,listener,useCapture,priority,useWeakReference);
               }
            }
            catch(error:SecurityError)
            {
               super.addEventListener(type,listener,useCapture,priority,useWeakReference);
            }
            if(Boolean(stage) && type == Event.RENDER)
            {
               stage.invalidate();
            }
            return;
         }
         super.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      final §§namespace("http://www.adobe.com/2006/flex/mx/internal") function $removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         super.removeEventListener(type,listener,useCapture);
      }
      
      override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         var request:DynamicEvent = null;
         if(hasEventListener("removeEventListener"))
         {
            request = new DynamicEvent("removeEventListener",false,true);
            request.eventType = type;
            request.listener = listener;
            request.useCapture = useCapture;
            if(!dispatchEvent(request))
            {
               return;
            }
         }
         if(type == FlexEvent.RENDER || type == FlexEvent.ENTER_FRAME)
         {
            if(type == FlexEvent.RENDER)
            {
               type = Event.RENDER;
            }
            else
            {
               type = Event.ENTER_FRAME;
            }
            try
            {
               if(Boolean(stage))
               {
                  stage.removeEventListener(type,listener,useCapture);
               }
            }
            catch(error:SecurityError)
            {
            }
            super.removeEventListener(type,listener,useCapture);
            return;
         }
         super.removeEventListener(type,listener,useCapture);
         if(type == MouseEvent.MOUSE_MOVE || type == MouseEvent.MOUSE_UP || type == MouseEvent.MOUSE_DOWN || type == Event.ACTIVATE || type == Event.DEACTIVATE)
         {
            if(!hasEventListener(type))
            {
               try
               {
                  if(Boolean(stage))
                  {
                     stage.removeEventListener(type,this.stageEventHandler,false);
                  }
               }
               catch(error:SecurityError)
               {
               }
            }
         }
         if(type == SandboxMouseEvent.MOUSE_UP_SOMEWHERE)
         {
            if(!hasEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE))
            {
               try
               {
                  if(Boolean(stage))
                  {
                     stage.removeEventListener(Event.MOUSE_LEAVE,this.mouseLeaveHandler);
                  }
               }
               catch(error:SecurityError)
               {
               }
               super.removeEventListener(Event.MOUSE_LEAVE,this.mouseLeaveHandler);
            }
         }
      }
      
      override public function addChild(child:DisplayObject) : DisplayObject
      {
         ++this.noTopMostIndex;
         return this.rawChildren_addChildAt(child,this.noTopMostIndex - 1);
      }
      
      override public function get numChildren() : int
      {
         return this.noTopMostIndex - this.applicationIndex;
      }
      
      override public function addChildAt(child:DisplayObject, index:int) : DisplayObject
      {
         ++this.noTopMostIndex;
         return this.rawChildren_addChildAt(child,this.applicationIndex + index);
      }
      
      override public function removeChild(child:DisplayObject) : DisplayObject
      {
         --this.noTopMostIndex;
         return this.rawChildren_removeChild(child);
      }
      
      override public function removeChildAt(index:int) : DisplayObject
      {
         --this.noTopMostIndex;
         return this.rawChildren_removeChildAt(this.applicationIndex + index);
      }
      
      override public function getChildAt(index:int) : DisplayObject
      {
         return super.getChildAt(this.applicationIndex + index);
      }
      
      override public function getChildByName(name:String) : DisplayObject
      {
         return super.getChildByName(name);
      }
      
      override public function getChildIndex(child:DisplayObject) : int
      {
         return super.getChildIndex(child) - this.applicationIndex;
      }
      
      override public function setChildIndex(child:DisplayObject, newIndex:int) : void
      {
         super.setChildIndex(child,this.applicationIndex + newIndex);
      }
      
      override public function getObjectsUnderPoint(point:Point) : Array
      {
         var child:DisplayObject = null;
         var temp:Array = null;
         var children:Array = [];
         var n:int = this.topMostIndex;
         for(var i:int = 0; i < n; i++)
         {
            child = super.getChildAt(i);
            if(child is DisplayObjectContainer)
            {
               temp = DisplayObjectContainer(child).getObjectsUnderPoint(point);
               if(Boolean(temp))
               {
                  children = children.concat(temp);
               }
            }
         }
         return children;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function addingChild(child:DisplayObject) : void
      {
         var obj:DisplayObjectContainer = null;
         var newNestLevel:int = 1;
         if(!this.topLevel)
         {
            obj = parent.parent;
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
            IUIComponent(child).systemManager = this;
         }
         var uiComponentClassName:Class = Class(this.getDefinitionByName("mx.core.UIComponent"));
         if(child is IUIComponent && !IUIComponent(child).document)
         {
            IUIComponent(child).document = this.document;
         }
         if(child is ILayoutManagerClient)
         {
            ILayoutManagerClient(child).nestLevel = this.nestLevel + 1;
         }
         if(child is InteractiveObject)
         {
            if(doubleClickEnabled)
            {
               InteractiveObject(child).doubleClickEnabled = true;
            }
         }
         if(child is IUIComponent)
         {
            IUIComponent(child).parentChanged(this);
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
         if(Boolean(uiComponentClassName) && child is uiComponentClassName)
         {
            uiComponentClassName(child).initThemeColor();
         }
         if(Boolean(uiComponentClassName) && child is uiComponentClassName)
         {
            uiComponentClassName(child).stylesInitialized();
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function childAdded(child:DisplayObject) : void
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removingChild(child:DisplayObject) : void
      {
         if(child.hasEventListener(FlexEvent.REMOVE))
         {
            child.dispatchEvent(new FlexEvent(FlexEvent.REMOVE));
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function childRemoved(child:DisplayObject) : void
      {
         if(child is IUIComponent)
         {
            IUIComponent(child).parentChanged(null);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function rawChildren_addChild(child:DisplayObject) : DisplayObject
      {
         this.childManager.addingChild(child);
         super.addChild(child);
         this.childManager.childAdded(child);
         return child;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function rawChildren_addChildAt(child:DisplayObject, index:int) : DisplayObject
      {
         if(Boolean(this.childManager))
         {
            this.childManager.addingChild(child);
         }
         super.addChildAt(child,index);
         if(Boolean(this.childManager))
         {
            this.childManager.childAdded(child);
         }
         return child;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function rawChildren_removeChild(child:DisplayObject) : DisplayObject
      {
         this.childManager.removingChild(child);
         super.removeChild(child);
         this.childManager.childRemoved(child);
         return child;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function rawChildren_removeChildAt(index:int) : DisplayObject
      {
         var child:DisplayObject = super.getChildAt(index);
         this.childManager.removingChild(child);
         super.removeChildAt(index);
         this.childManager.childRemoved(child);
         return child;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function rawChildren_getChildAt(index:int) : DisplayObject
      {
         return super.getChildAt(index);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function rawChildren_getChildByName(name:String) : DisplayObject
      {
         return super.getChildByName(name);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function rawChildren_getChildIndex(child:DisplayObject) : int
      {
         return super.getChildIndex(child);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function rawChildren_setChildIndex(child:DisplayObject, newIndex:int) : void
      {
         super.setChildIndex(child,newIndex);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function rawChildren_getObjectsUnderPoint(pt:Point) : Array
      {
         return super.getObjectsUnderPoint(pt);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function rawChildren_contains(child:DisplayObject) : Boolean
      {
         return super.contains(child);
      }
      
      override public function get mouseX() : Number
      {
         if(this._mouseX === undefined)
         {
            return super.mouseX;
         }
         return this._mouseX;
      }
      
      override public function get mouseY() : Number
      {
         if(this._mouseY === undefined)
         {
            return super.mouseY;
         }
         return this._mouseY;
      }
      
      public function getFocus() : InteractiveObject
      {
         try
         {
            return stage.focus;
         }
         catch(e:SecurityError)
         {
         }
         return null;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function cleanup(e:Event) : void
      {
         if(Singleton.getClass("mx.managers::IDragManager").getInstance() is NativeDragManagerImpl)
         {
            NativeDragManagerImpl(Singleton.getClass("mx.managers::IDragManager").getInstance()).unregisterSystemManager(this);
         }
         SystemManagerGlobals.topLevelSystemManagers.splice(SystemManagerGlobals.topLevelSystemManagers.indexOf(this),1);
         this.myWindow.nativeWindow.removeEventListener(Event.CLOSE,this.cleanup);
         this.myWindow = null;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function addWindow(win:IWindow) : void
      {
         this.myWindow = win;
         this.myWindow.nativeWindow.addEventListener(Event.CLOSE,this.cleanup);
      }
      
      private function stageEventHandler(event:Event) : void
      {
         if(event.target is Stage)
         {
            dispatchEvent(event);
         }
      }
      
      private function mouseLeaveHandler(event:Event) : void
      {
         dispatchEvent(new SandboxMouseEvent(SandboxMouseEvent.MOUSE_UP_SOMEWHERE));
      }
      
      public function invalidateParentSizeAndDisplayList() : void
      {
      }
      
      private function mouseEventHandler(e:MouseEvent) : void
      {
         var cancelableEvent:MouseEvent = null;
         if(!e.cancelable)
         {
            e.stopImmediatePropagation();
            cancelableEvent = new MouseEvent(e.type,e.bubbles,true,e.localX,e.localY,e.relatedObject,e.ctrlKey,e.altKey,e.shiftKey,e.buttonDown,e.delta,e.commandKey,e.controlKey,e.clickCount);
            e.target.dispatchEvent(cancelableEvent);
         }
      }
   }
}

