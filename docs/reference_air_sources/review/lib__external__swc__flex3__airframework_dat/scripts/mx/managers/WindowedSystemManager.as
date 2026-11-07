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
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.system.ApplicationDomain;
   import flash.text.Font;
   import flash.text.TextFormat;
   import flash.ui.ContextMenu;
   import flash.utils.Dictionary;
   import mx.core.EventPriority;
   import mx.core.FlexSprite;
   import mx.core.IChildList;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModule;
   import mx.core.ISWFBridgeGroup;
   import mx.core.ISWFBridgeProvider;
   import mx.core.ISWFLoader;
   import mx.core.IUIComponent;
   import mx.core.SWFBridgeGroup;
   import mx.core.Singleton;
   import mx.core.Window;
   import mx.core.mx_internal;
   import mx.events.EventListenerRequest;
   import mx.events.FlexChangeEvent;
   import mx.events.FlexEvent;
   import mx.events.InterManagerRequest;
   import mx.events.SWFBridgeEvent;
   import mx.events.SWFBridgeRequest;
   import mx.events.SandboxMouseEvent;
   import mx.managers.systemClasses.EventProxy;
   import mx.managers.systemClasses.PlaceholderData;
   import mx.managers.systemClasses.RemotePopUp;
   import mx.styles.ISimpleStyleClient;
   import mx.styles.IStyleClient;
   import mx.utils.EventUtil;
   import mx.utils.NameUtil;
   import mx.utils.SecurityUtil;
   
   public class WindowedSystemManager extends MovieClip implements ISystemManager, ISWFBridgeProvider
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var nestLevel:int = 0;
      
      private var currentSandboxEvent:Event;
      
      private var originalSystemManager:SystemManager;
      
      private var forms:Array = [];
      
      private var mouseCatcher:Sprite;
      
      private var _height:Number;
      
      private var dispatchingToSystemManagers:Boolean = false;
      
      private var strongReferenceProxies:Dictionary = new Dictionary(false);
      
      private var _document:Object;
      
      private var _rawChildren:WindowedSystemRawChildrenList;
      
      private var _topLevelSystemManager:ISystemManager;
      
      private var _toolTipIndex:int = 0;
      
      private var _bridgeToFocusManager:Dictionary;
      
      private var idToPlaceholder:Object;
      
      private var _swfBridgeGroup:ISWFBridgeGroup;
      
      private var myWindow:Window;
      
      private var _toolTipChildren:WindowedSystemChildrenList;
      
      private var form:Object;
      
      private var _width:Number;
      
      private var initialized:Boolean = false;
      
      private var _focusPane:Sprite;
      
      private var _popUpChildren:WindowedSystemChildrenList;
      
      private var isStageRoot:Boolean = true;
      
      private var _fontList:Object = null;
      
      private var _window:Window = null;
      
      private var _topMostIndex:int = 0;
      
      private var topLevel:Boolean = true;
      
      private var weakReferenceProxies:Dictionary = new Dictionary(true);
      
      private var _cursorIndex:int = 0;
      
      private var isBootstrapRoot:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _mouseY:*;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _mouseX:*;
      
      private var _numModalWindows:int = 0;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var idleCounter:int = 0;
      
      private var _screen:Rectangle;
      
      private var _cursorChildren:WindowedSystemChildrenList;
      
      private var _noTopMostIndex:int = 0;
      
      private var _applicationIndex:int = 1;
      
      private var isDispatchingResizeEvent:Boolean;
      
      private var eventProxy:EventProxy;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var topLevelWindow:IUIComponent;
      
      public function WindowedSystemManager(rootObj:IUIComponent)
      {
         super();
         _topLevelSystemManager = this;
         topLevelWindow = rootObj;
         SystemManagerGlobals.topLevelSystemManagers.push(this);
         addEventListener(Event.ADDED,docFrameHandler);
      }
      
      private static function areRemotePopUpsEqual(form1:Object, form2:Object) : Boolean
      {
         if(!(form1 is RemotePopUp))
         {
            return false;
         }
         if(!(form2 is RemotePopUp))
         {
            return false;
         }
         var remotePopUp1:RemotePopUp = RemotePopUp(form1);
         var remotePopUp2:RemotePopUp = RemotePopUp(form2);
         if(Boolean(remotePopUp1.window == remotePopUp2.window) && Boolean(remotePopUp1.bridge) && Boolean(remotePopUp2.bridge))
         {
            return true;
         }
         return false;
      }
      
      private static function isRemotePopUp(form:Object) : Boolean
      {
         return !(form is IFocusManagerContainer);
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
      
      private function removeEventListenerFromSandboxes(type:String, listener:Function, useCapture:Boolean = false, skip:IEventDispatcher = null) : void
      {
         var i:int = 0;
         if(!swfBridgeGroup)
         {
            return;
         }
         var request:EventListenerRequest = new EventListenerRequest(EventListenerRequest.REMOVE_EVENT_LISTENER_REQUEST,false,false,type,useCapture);
         var parentBridge:IEventDispatcher = swfBridgeGroup.parentBridge;
         if(Boolean(parentBridge) && parentBridge != skip)
         {
            parentBridge.removeEventListener(type,listener,useCapture);
         }
         for(var children:Array = swfBridgeGroup.getChildBridges(); i < children.length; )
         {
            if(children[i] != skip)
            {
               IEventDispatcher(children[i]).removeEventListener(type,listener,useCapture);
            }
            i++;
         }
         dispatchEventFromSWFBridges(request,skip);
      }
      
      private function dispatchEventToOtherSystemManagers(event:Event) : void
      {
         SystemManagerGlobals.dispatchingEventToOtherSystemManagers = true;
         var arr:Array = SystemManagerGlobals.topLevelSystemManagers;
         var n:int = int(arr.length);
         for(var i:int = 0; i < n; i++)
         {
            if(arr[i] != this)
            {
               arr[i].dispatchEvent(event);
            }
         }
         SystemManagerGlobals.dispatchingEventToOtherSystemManagers = false;
      }
      
      private function initManagerHandler(event:Event) : void
      {
         var name:String;
         if(!SystemManagerGlobals.dispatchingEventToOtherSystemManagers)
         {
            dispatchEventToOtherSystemManagers(event);
         }
         if(event is InterManagerRequest)
         {
            return;
         }
         name = event["name"];
         try
         {
            Singleton.getInstance(name);
         }
         catch(e:Error)
         {
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function rawChildren_getObjectsUnderPoint(pt:Point) : Array
      {
         return super.getObjectsUnderPoint(pt);
      }
      
      public function get preloadedRSLs() : Dictionary
      {
         return null;
      }
      
      private function getSizeRequestHandler(event:Event) : void
      {
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function findFocusManagerContainer(smp:SystemManagerProxy) : IFocusManagerContainer
      {
         var child:DisplayObject = null;
         var children:IChildList = smp.rawChildren;
         var numChildren:int = int(children.numChildren);
         for(var i:int = 0; i < numChildren; i++)
         {
            child = children.getChildAt(i);
            if(child is IFocusManagerContainer)
            {
               return IFocusManagerContainer(child);
            }
         }
         return null;
      }
      
      private function addPlaceholderPopupRequestHandler(event:Event) : void
      {
         var remoteForm:RemotePopUp = null;
         var popUpRequest:SWFBridgeRequest = SWFBridgeRequest.marshal(event);
         if(event.target != this && event is SWFBridgeRequest)
         {
            return;
         }
         if(!forwardPlaceholderRequest(popUpRequest,true))
         {
            remoteForm = new RemotePopUp(popUpRequest.data.placeHolderId,popUpRequest.requestor);
            forms.push(remoteForm);
         }
      }
      
      private function activateApplicationSandboxEventHandler(event:Event) : void
      {
         if(!isTopLevelRoot())
         {
            swfBridgeGroup.parentBridge.dispatchEvent(event);
            return;
         }
         activateForm(document);
      }
      
      private function getVisibleRectRequestHandler(event:Event) : void
      {
         var localRect:Rectangle = null;
         var pt:Point = null;
         var bridge:IEventDispatcher = null;
         if(event is SWFBridgeRequest)
         {
            return;
         }
         var request:SWFBridgeRequest = SWFBridgeRequest.marshal(event);
         var rect:Rectangle = Rectangle(request.data);
         var owner:DisplayObject = DisplayObject(swfBridgeGroup.getChildBridgeProvider(request.requestor));
         var forwardRequest:Boolean = true;
         if(!DisplayObjectContainer(document).contains(owner))
         {
            forwardRequest = false;
         }
         if(owner is ISWFLoader)
         {
            localRect = ISWFLoader(owner).getVisibleApplicationRect();
         }
         else
         {
            localRect = owner.getBounds(this);
            pt = localToGlobal(localRect.topLeft);
            localRect.x = pt.x;
            localRect.y = pt.y;
         }
         rect = rect.intersection(localRect);
         request.data = rect;
         if(forwardRequest && useSWFBridge())
         {
            bridge = swfBridgeGroup.parentBridge;
            request.requestor = bridge;
            bridge.dispatchEvent(request);
         }
         Object(event).data = request.data;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function notifyStyleChangeInChildren(styleProp:String, recursive:Boolean) : void
      {
         var child:IStyleClient = null;
         var foundTopLevelWindow:Boolean = false;
         var n:int = int(rawChildren.numChildren);
         for(var i:int = 0; i < n; i++)
         {
            child = rawChildren.getChildAt(i) as IStyleClient;
            if(Boolean(child))
            {
               child.styleChanged(styleProp);
               child.notifyStyleChangeInChildren(styleProp,recursive);
            }
            if(isTopLevelWindow(DisplayObject(child)))
            {
               foundTopLevelWindow = true;
            }
            n = int(rawChildren.numChildren);
         }
         if(!foundTopLevelWindow && topLevelWindow is IStyleClient)
         {
            IStyleClient(topLevelWindow).styleChanged(styleProp);
            IStyleClient(topLevelWindow).notifyStyleChangeInChildren(styleProp,recursive);
         }
      }
      
      private function addEventListenerToOtherSystemManagers(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         var arr:Array = SystemManagerGlobals.topLevelSystemManagers;
         if(arr.length < 2)
         {
            return;
         }
         SystemManagerGlobals.changingListenersInOtherSystemManagers = true;
         var n:int = int(arr.length);
         for(var i:int = 0; i < n; i++)
         {
            if(arr[i] != this)
            {
               arr[i].addEventListener(type,listener,useCapture,priority,useWeakReference);
            }
         }
         SystemManagerGlobals.changingListenersInOtherSystemManagers = false;
      }
      
      private function modalWindowRequestHandler(event:Event) : void
      {
         if(event is SWFBridgeRequest)
         {
            return;
         }
         var request:SWFBridgeRequest = SWFBridgeRequest.marshal(event);
         if(!preProcessModalWindowRequest(request,getSandboxRoot()))
         {
            return;
         }
         Singleton.getInstance("mx.managers::IPopUpManager");
         dispatchEvent(request);
      }
      
      public function getDefinitionByName(name:String) : Object
      {
         var definition:Object = null;
         var domain:ApplicationDomain = ApplicationDomain.currentDomain;
         if(domain.hasDefinition(name))
         {
            definition = domain.getDefinition(name);
         }
         return definition;
      }
      
      public function removeChildFromSandboxRoot(layer:String, child:DisplayObject) : void
      {
         var me:InterManagerRequest = null;
         if(getSandboxRoot() == this)
         {
            this[layer].removeChild(child);
         }
         else
         {
            removingChild(child);
            me = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST);
            me.name = layer + ".removeChild";
            me.value = child;
            getSandboxRoot().dispatchEvent(me);
            childRemoved(child);
         }
      }
      
      private function removeEventListenerFromOtherSystemManagers(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         var arr:Array = SystemManagerGlobals.topLevelSystemManagers;
         if(arr.length < 2)
         {
            return;
         }
         SystemManagerGlobals.changingListenersInOtherSystemManagers = true;
         var n:int = int(arr.length);
         for(var i:int = 0; i < n; i++)
         {
            if(arr[i] != this)
            {
               arr[i].removeEventListener(type,listener,useCapture);
            }
         }
         SystemManagerGlobals.changingListenersInOtherSystemManagers = false;
      }
      
      public function set document(value:Object) : void
      {
         _document = value;
      }
      
      public function get embeddedFontList() : Object
      {
         var o:Object = null;
         var p:String = null;
         var fl:Object = null;
         if(_fontList == null)
         {
            _fontList = {};
            o = info()["fonts"];
            for(p in o)
            {
               _fontList[p] = o[p];
            }
            if(!topLevel && Boolean(_topLevelSystemManager))
            {
               fl = _topLevelSystemManager.embeddedFontList;
               for(p in fl)
               {
                  _fontList[p] = fl[p];
               }
            }
         }
         return _fontList;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set cursorIndex(value:int) : void
      {
         var delta:int = value - _cursorIndex;
         _cursorIndex = value;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function addChildBridgeListeners(bridge:IEventDispatcher) : void
      {
         if(!topLevel && Boolean(topLevelSystemManager))
         {
            SystemManager(topLevelSystemManager).addChildBridgeListeners(bridge);
            return;
         }
         bridge.addEventListener(SWFBridgeRequest.ADD_POP_UP_REQUEST,addPopupRequestHandler);
         bridge.addEventListener(SWFBridgeRequest.REMOVE_POP_UP_REQUEST,removePopupRequestHandler);
         bridge.addEventListener(SWFBridgeRequest.ADD_POP_UP_PLACE_HOLDER_REQUEST,addPlaceholderPopupRequestHandler);
         bridge.addEventListener(SWFBridgeRequest.REMOVE_POP_UP_PLACE_HOLDER_REQUEST,removePlaceholderPopupRequestHandler);
         bridge.addEventListener(SWFBridgeEvent.BRIDGE_WINDOW_ACTIVATE,activateFormSandboxEventHandler);
         bridge.addEventListener(SWFBridgeEvent.BRIDGE_WINDOW_DEACTIVATE,deactivateFormSandboxEventHandler);
         bridge.addEventListener(SWFBridgeEvent.BRIDGE_APPLICATION_ACTIVATE,activateApplicationSandboxEventHandler);
         bridge.addEventListener(EventListenerRequest.ADD_EVENT_LISTENER_REQUEST,eventListenerRequestHandler,false,0,true);
         bridge.addEventListener(EventListenerRequest.REMOVE_EVENT_LISTENER_REQUEST,eventListenerRequestHandler,false,0,true);
         bridge.addEventListener(SWFBridgeRequest.CREATE_MODAL_WINDOW_REQUEST,modalWindowRequestHandler);
         bridge.addEventListener(SWFBridgeRequest.SHOW_MODAL_WINDOW_REQUEST,modalWindowRequestHandler);
         bridge.addEventListener(SWFBridgeRequest.HIDE_MODAL_WINDOW_REQUEST,modalWindowRequestHandler);
         bridge.addEventListener(SWFBridgeRequest.GET_VISIBLE_RECT_REQUEST,getVisibleRectRequestHandler);
         bridge.addEventListener(SWFBridgeRequest.HIDE_MOUSE_CURSOR_REQUEST,hideMouseCursorRequestHandler);
         bridge.addEventListener(SWFBridgeRequest.SHOW_MOUSE_CURSOR_REQUEST,showMouseCursorRequestHandler);
         bridge.addEventListener(SWFBridgeRequest.RESET_MOUSE_CURSOR_REQUEST,resetMouseCursorRequestHandler);
      }
      
      private function findLastActiveForm(f:Object) : Object
      {
         var n:int = int(forms.length);
         for(var i:int = forms.length - 1; i >= 0; i--)
         {
            if(forms[i] != f && canActivatePopUp(forms[i]))
            {
               return forms[i];
            }
         }
         return null;
      }
      
      private function preProcessModalWindowRequest(request:SWFBridgeRequest, sbRoot:DisplayObject) : Boolean
      {
         var bridge:IEventDispatcher = null;
         var exclude:ISWFLoader = null;
         var excludeRect:Rectangle = null;
         if(Boolean(request.data.skip))
         {
            request.data.skip = false;
            if(useSWFBridge())
            {
               bridge = swfBridgeGroup.parentBridge;
               request.requestor = bridge;
               bridge.dispatchEvent(request);
            }
            return false;
         }
         if(this != sbRoot)
         {
            if(request.type == SWFBridgeRequest.CREATE_MODAL_WINDOW_REQUEST || request.type == SWFBridgeRequest.SHOW_MODAL_WINDOW_REQUEST)
            {
               exclude = swfBridgeGroup.getChildBridgeProvider(request.requestor) as ISWFLoader;
               if(Boolean(exclude))
               {
                  excludeRect = ISWFLoader(exclude).getVisibleApplicationRect();
                  request.data.excludeRect = excludeRect;
                  if(!DisplayObjectContainer(document).contains(DisplayObject(exclude)))
                  {
                     request.data.useExclude = false;
                  }
               }
            }
            bridge = swfBridgeGroup.parentBridge;
            request.requestor = bridge;
            if(request.type == SWFBridgeRequest.HIDE_MODAL_WINDOW_REQUEST)
            {
               sbRoot.dispatchEvent(request);
            }
            else
            {
               bridge.dispatchEvent(request);
            }
            return false;
         }
         request.data.skip = false;
         return true;
      }
      
      public function get rawChildren() : IChildList
      {
         if(!topLevel)
         {
            return _topLevelSystemManager.rawChildren;
         }
         if(!_rawChildren)
         {
            _rawChildren = new WindowedSystemRawChildrenList(this);
         }
         return _rawChildren;
      }
      
      override public function getChildAt(index:int) : DisplayObject
      {
         return super.getChildAt(applicationIndex + index);
      }
      
      private function multiWindowRedispatcher(event:Event) : void
      {
         if(!SystemManagerGlobals.dispatchingEventToOtherSystemManagers)
         {
            dispatchEventToOtherSystemManagers(event);
         }
      }
      
      public function deployMouseShields(deploy:Boolean) : void
      {
         var me:InterManagerRequest = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST,false,false,"mouseShield",deploy);
         getSandboxRoot().dispatchEvent(me);
      }
      
      override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         var actualType:String = null;
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
         if(type == MouseEvent.MOUSE_MOVE || type == MouseEvent.MOUSE_UP || type == MouseEvent.MOUSE_DOWN || type == Event.ACTIVATE || type == Event.DEACTIVATE)
         {
            try
            {
               if(Boolean(stage))
               {
                  stage.addEventListener(type,stageEventHandler,false,0,true);
               }
            }
            catch(error:SecurityError)
            {
            }
         }
         if(hasSWFBridges() || SystemManagerGlobals.topLevelSystemManagers.length > 1)
         {
            if(!eventProxy)
            {
               eventProxy = new EventProxy(this);
            }
            actualType = EventUtil.sandboxMouseEventMap[type];
            if(Boolean(actualType))
            {
               if(isTopLevelRoot())
               {
                  stage.addEventListener(MouseEvent.MOUSE_MOVE,resetMouseCursorTracking,true,EventPriority.CURSOR_MANAGEMENT + 1,true);
                  addEventListenerToSandboxes(SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE,resetMouseCursorTracking,true,EventPriority.CURSOR_MANAGEMENT + 1,true);
               }
               else
               {
                  super.addEventListener(MouseEvent.MOUSE_MOVE,resetMouseCursorTracking,true,EventPriority.CURSOR_MANAGEMENT + 1,true);
               }
               addEventListenerToSandboxes(type,sandboxMouseListener,useCapture,priority,useWeakReference);
               if(!SystemManagerGlobals.changingListenersInOtherSystemManagers)
               {
                  addEventListenerToOtherSystemManagers(type,otherSystemManagerMouseListener,useCapture,priority,useWeakReference);
               }
               if(getSandboxRoot() == this)
               {
                  super.addEventListener(actualType,eventProxy.marshalListener,useCapture,priority,useWeakReference);
                  if(actualType == MouseEvent.MOUSE_UP)
                  {
                     try
                     {
                        if(Boolean(stage))
                        {
                           stage.addEventListener(Event.MOUSE_LEAVE,eventProxy.marshalListener,useCapture,priority,useWeakReference);
                        }
                        else
                        {
                           super.addEventListener(Event.MOUSE_LEAVE,eventProxy.marshalListener,useCapture,priority,useWeakReference);
                        }
                     }
                     catch(e:SecurityError)
                     {
                        super.addEventListener(Event.MOUSE_LEAVE,eventProxy.marshalListener,useCapture,priority,useWeakReference);
                     }
                  }
               }
               super.addEventListener(type,listener,false,priority,useWeakReference);
               return;
            }
         }
         if(type == SandboxMouseEvent.MOUSE_UP_SOMEWHERE)
         {
            try
            {
               if(Boolean(stage))
               {
                  stage.addEventListener(Event.MOUSE_LEAVE,mouseLeaveHandler,false,0,true);
               }
               else
               {
                  super.addEventListener(Event.MOUSE_LEAVE,mouseLeaveHandler,false,0,true);
               }
            }
            catch(error:SecurityError)
            {
               super.addEventListener(Event.MOUSE_LEAVE,mouseLeaveHandler,false,0,true);
            }
         }
         super.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      final §§namespace("http://www.adobe.com/2006/flex/mx/internal") function $removeChild(child:DisplayObject) : DisplayObject
      {
         return super.removeChild(child);
      }
      
      private function Stage_resizeHandler(event:Event = null) : void
      {
         var w:Number = stage.stageWidth;
         var h:Number = stage.stageHeight;
         var y:Number = 0;
         var x:Number = 0;
         if(!_screen)
         {
            _screen = new Rectangle();
         }
         _screen.x = x;
         _screen.y = y;
         _screen.width = w;
         _screen.height = h;
         _width = stage.stageWidth;
         _height = stage.stageHeight;
         if(Boolean(event))
         {
            resizeMouseCatcher();
            dispatchEvent(event);
         }
      }
      
      private function activateForm(f:Object) : void
      {
         var z:IFocusManagerContainer = null;
         if(Boolean(form))
         {
            if(form != f && forms.length > 1)
            {
               if(isRemotePopUp(form))
               {
                  if(!areRemotePopUpsEqual(form,f))
                  {
                     deactivateRemotePopUp(form);
                  }
               }
               else
               {
                  z = IFocusManagerContainer(form);
                  z.focusManager.deactivate();
               }
            }
         }
         form = f;
         if(isRemotePopUp(f))
         {
            activateRemotePopUp(f);
         }
         else if(Boolean(f.focusManager))
         {
            f.focusManager.activate();
         }
         updateLastActiveForm();
      }
      
      public function removeFocusManager(f:IFocusManagerContainer) : void
      {
         var n:int = int(forms.length);
         for(var i:int = 0; i < n; i++)
         {
            if(forms[i] == f)
            {
               if(form == f)
               {
                  deactivate(f);
               }
               forms.splice(i,1);
               return;
            }
         }
      }
      
      override public function get mouseY() : Number
      {
         if(_mouseY === undefined)
         {
            return super.mouseY;
         }
         return _mouseY;
      }
      
      public function get focusPane() : Sprite
      {
         return _focusPane;
      }
      
      override public function get mouseX() : Number
      {
         if(_mouseX === undefined)
         {
            return super.mouseX;
         }
         return _mouseX;
      }
      
      private function mouseDownHandler(event:MouseEvent) : void
      {
         var n:int = 0;
         var p:DisplayObject = null;
         var isApplication:Boolean = false;
         var i:int = 0;
         var form_i:Object = null;
         var j:int = 0;
         var index:int = 0;
         var newIndex:int = 0;
         var childList:IChildList = null;
         var f:DisplayObject = null;
         var isRemotePopUp:Boolean = false;
         var fChildIndex:int = 0;
         idleCounter = 0;
         if(isDisplayObjectInABridgedApplication(event.target as DisplayObject))
         {
            if(isTopLevelRoot())
            {
               activateForm(document);
            }
            else
            {
               dispatchActivatedApplicationEvent();
            }
            return;
         }
         if(numModalWindows == 0)
         {
            if(forms.length > 1)
            {
               n = int(forms.length);
               p = DisplayObject(event.target);
               isApplication = Boolean(document.rawChildren.contains(p));
               loop0:
               while(Boolean(p))
               {
                  i = 0;
                  while(true)
                  {
                     if(i >= n)
                     {
                        p = p.parent;
                        continue loop0;
                     }
                     form_i = isRemotePopUp(forms[i]) ? forms[i].window : forms[i];
                     if(form_i == p)
                     {
                        break;
                     }
                     i++;
                  }
                  j = 0;
                  if(p != form && p is IFocusManagerContainer)
                  {
                     activate(IFocusManagerContainer(p));
                  }
                  if(popUpChildren.contains(p))
                  {
                     childList = popUpChildren;
                  }
                  else
                  {
                     childList = this;
                  }
                  index = int(childList.getChildIndex(p));
                  newIndex = index;
                  n = int(forms.length);
                  for(j = 0; j < n; j++)
                  {
                     isRemotePopUp = isRemotePopUp(forms[j]);
                     if(isRemotePopUp)
                     {
                        if(forms[j].window is String)
                        {
                           continue;
                        }
                        f = forms[j].window;
                     }
                     else
                     {
                        f = forms[j];
                     }
                     if(isRemotePopUp)
                     {
                        fChildIndex = getChildListIndex(childList,f);
                        if(fChildIndex > index)
                        {
                           newIndex = Math.max(fChildIndex,newIndex);
                        }
                     }
                     else if(childList.contains(f))
                     {
                        if(childList.getChildIndex(f) > index)
                        {
                           newIndex = Math.max(childList.getChildIndex(f),newIndex);
                        }
                     }
                  }
                  if(newIndex > index && !isApplication)
                  {
                     childList.setChildIndex(p,newIndex);
                  }
                  return;
               }
            }
         }
      }
      
      public function addChildBridge(bridge:IEventDispatcher, owner:DisplayObject) : void
      {
         var fm:IFocusManager = null;
         var o:DisplayObject = owner;
         while(Boolean(o))
         {
            if(o is IFocusManagerContainer)
            {
               fm = IFocusManagerContainer(o).focusManager;
               break;
            }
            o = o.parent;
         }
         if(!fm)
         {
            return;
         }
         if(!swfBridgeGroup)
         {
            swfBridgeGroup = new SWFBridgeGroup(this);
         }
         swfBridgeGroup.addChildBridge(bridge,ISWFBridgeProvider(owner));
         fm.addSWFBridge(bridge,owner);
         if(!bridgeToFocusManager)
         {
            bridgeToFocusManager = new Dictionary();
         }
         bridgeToFocusManager[bridge] = fm;
         addChildBridgeListeners(bridge);
         dispatchEvent(new FlexChangeEvent(FlexChangeEvent.ADD_CHILD_BRIDGE,false,false,bridge));
      }
      
      public function allowInsecureDomain(... domains) : void
      {
      }
      
      private function removePopupRequestHandler(event:Event) : void
      {
         var request:SWFBridgeRequest = null;
         var popUpRequest:SWFBridgeRequest = SWFBridgeRequest.marshal(event);
         if(Boolean(swfBridgeGroup.parentBridge) && Boolean(SecurityUtil.hasMutualTrustBetweenParentAndChild(this)))
         {
            popUpRequest.requestor = swfBridgeGroup.parentBridge;
            getSandboxRoot().dispatchEvent(popUpRequest);
            return;
         }
         if(popUpChildren.contains(popUpRequest.data.window))
         {
            popUpChildren.removeChild(popUpRequest.data.window);
         }
         else
         {
            removeChild(DisplayObject(popUpRequest.data.window));
         }
         if(Boolean(popUpRequest.data.modal))
         {
            --numModalWindows;
         }
         removeRemotePopUp(new RemotePopUp(popUpRequest.data.window,popUpRequest.requestor));
         if(!isTopLevelRoot() && Boolean(swfBridgeGroup))
         {
            request = new SWFBridgeRequest(SWFBridgeRequest.REMOVE_POP_UP_PLACE_HOLDER_REQUEST,false,false,popUpRequest.requestor,{"placeHolderId":NameUtil.displayObjectToString(popUpRequest.data.window)});
            dispatchEvent(request);
         }
      }
      
      public function get screen() : Rectangle
      {
         if(!_screen)
         {
            _screen = new Rectangle();
         }
         _screen.x = 0;
         _screen.y = 0;
         _screen.width = stage.stageWidth;
         _screen.height = stage.stageHeight;
         return _screen;
      }
      
      private function resetMouseCursorRequestHandler(event:Event) : void
      {
         var bridge:IEventDispatcher = null;
         if(!isTopLevelRoot() && event is SWFBridgeRequest)
         {
            return;
         }
         var request:SWFBridgeRequest = SWFBridgeRequest.marshal(event);
         if(!isTopLevelRoot())
         {
            bridge = swfBridgeGroup.parentBridge;
            request.requestor = bridge;
            bridge.dispatchEvent(request);
         }
         else if(Boolean(eventProxy))
         {
            SystemManagerGlobals.showMouseCursor = true;
         }
      }
      
      private function resetMouseCursorTracking(event:Event) : void
      {
         var cursorRequest:SWFBridgeRequest = null;
         var bridge:IEventDispatcher = null;
         if(isTopLevelRoot())
         {
            SystemManagerGlobals.showMouseCursor = true;
         }
         else if(Boolean(swfBridgeGroup.parentBridge))
         {
            cursorRequest = new SWFBridgeRequest(SWFBridgeRequest.RESET_MOUSE_CURSOR_REQUEST);
            bridge = swfBridgeGroup.parentBridge;
            cursorRequest.requestor = bridge;
            bridge.dispatchEvent(cursorRequest);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set topMostIndex(value:int) : void
      {
         var delta:int = value - _topMostIndex;
         _topMostIndex = value;
         toolTipIndex += delta;
      }
      
      protected function docFrameHandler(event:Event = null) : void
      {
         var n:int = 0;
         var i:int = 0;
         var c:Class = null;
         removeEventListener(Event.ADDED,docFrameHandler);
         getSandboxRoot().addEventListener(InterManagerRequest.INIT_MANAGER_REQUEST,initManagerHandler,false,0,true);
         if(getSandboxRoot() == this)
         {
            addEventListener(InterManagerRequest.SYSTEM_MANAGER_REQUEST,systemManagerHandler);
            addEventListener(InterManagerRequest.DRAG_MANAGER_REQUEST,multiWindowRedispatcher);
            addEventListener("dispatchDragEvent",multiWindowRedispatcher);
            addEventListener(SWFBridgeRequest.ADD_POP_UP_REQUEST,addPopupRequestHandler);
            addEventListener(SWFBridgeRequest.REMOVE_POP_UP_REQUEST,removePopupRequestHandler);
            addEventListener(SWFBridgeRequest.ADD_POP_UP_PLACE_HOLDER_REQUEST,addPlaceholderPopupRequestHandler);
            addEventListener(SWFBridgeRequest.REMOVE_POP_UP_PLACE_HOLDER_REQUEST,removePlaceholderPopupRequestHandler);
            addEventListener(SWFBridgeEvent.BRIDGE_WINDOW_ACTIVATE,activateFormSandboxEventHandler);
            addEventListener(SWFBridgeEvent.BRIDGE_WINDOW_DEACTIVATE,deactivateFormSandboxEventHandler);
            addEventListener(SWFBridgeRequest.HIDE_MOUSE_CURSOR_REQUEST,hideMouseCursorRequestHandler);
            addEventListener(SWFBridgeRequest.SHOW_MOUSE_CURSOR_REQUEST,showMouseCursorRequestHandler);
            addEventListener(SWFBridgeRequest.RESET_MOUSE_CURSOR_REQUEST,resetMouseCursorRequestHandler);
         }
         if(Boolean(stage))
         {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
         }
         var mixinList:Array = info()["mixins"];
         if(Boolean(mixinList) && mixinList.length > 0)
         {
            n = int(mixinList.length);
            for(i = 0; i < n; i++)
            {
               c = Class(getDefinitionByName(mixinList[i]));
               c["init"](this);
            }
         }
         initializeTopLevelWindow(null);
         if(Singleton.getClass("mx.managers::IDragManager").getInstance() is NativeDragManagerImpl)
         {
            NativeDragManagerImpl(Singleton.getClass("mx.managers::IDragManager").getInstance()).registerSystemManager(this);
         }
      }
      
      public function isTopLevel() : Boolean
      {
         return topLevel;
      }
      
      public function deactivate(f:IFocusManagerContainer) : void
      {
         deactivateForm(Object(f));
      }
      
      private function initContextMenu() : void
      {
         var defaultMenu:ContextMenu = new ContextMenu();
         defaultMenu.hideBuiltInItems();
         defaultMenu.builtInItems.print = true;
         contextMenu = defaultMenu;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function addParentBridgeListeners() : void
      {
         if(!topLevel && Boolean(topLevelSystemManager))
         {
            SystemManager(topLevelSystemManager).addParentBridgeListeners();
            return;
         }
         var bridge:IEventDispatcher = swfBridgeGroup.parentBridge;
         bridge.addEventListener(SWFBridgeRequest.SET_ACTUAL_SIZE_REQUEST,setActualSizeRequestHandler);
         bridge.addEventListener(SWFBridgeRequest.GET_SIZE_REQUEST,getSizeRequestHandler);
         bridge.addEventListener(SWFBridgeRequest.ACTIVATE_POP_UP_REQUEST,activateRequestHandler);
         bridge.addEventListener(SWFBridgeRequest.DEACTIVATE_POP_UP_REQUEST,deactivateRequestHandler);
         bridge.addEventListener(SWFBridgeRequest.IS_BRIDGE_CHILD_REQUEST,isBridgeChildHandler);
         bridge.addEventListener(EventListenerRequest.ADD_EVENT_LISTENER_REQUEST,eventListenerRequestHandler);
         bridge.addEventListener(EventListenerRequest.REMOVE_EVENT_LISTENER_REQUEST,eventListenerRequestHandler);
         bridge.addEventListener(SWFBridgeRequest.CAN_ACTIVATE_POP_UP_REQUEST,canActivateHandler);
      }
      
      private function showMouseCursorRequestHandler(event:Event) : void
      {
         var bridge:IEventDispatcher = null;
         if(!isTopLevelRoot() && event is SWFBridgeRequest)
         {
            return;
         }
         var request:SWFBridgeRequest = SWFBridgeRequest.marshal(event);
         if(!isTopLevelRoot())
         {
            bridge = swfBridgeGroup.parentBridge;
            request.requestor = bridge;
            bridge.dispatchEvent(request);
            Object(event).data = request.data;
         }
         else if(Boolean(eventProxy))
         {
            Object(event).data = SystemManagerGlobals.showMouseCursor;
         }
      }
      
      public function get swfBridgeGroup() : ISWFBridgeGroup
      {
         if(topLevel)
         {
            return _swfBridgeGroup;
         }
         if(Boolean(topLevelSystemManager))
         {
            return topLevelSystemManager.swfBridgeGroup;
         }
         return null;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removeParentBridgeListeners() : void
      {
         if(!topLevel && Boolean(topLevelSystemManager))
         {
            SystemManager(topLevelSystemManager).removeParentBridgeListeners();
            return;
         }
         var bridge:IEventDispatcher = swfBridgeGroup.parentBridge;
         bridge.removeEventListener(SWFBridgeRequest.SET_ACTUAL_SIZE_REQUEST,setActualSizeRequestHandler);
         bridge.removeEventListener(SWFBridgeRequest.GET_SIZE_REQUEST,getSizeRequestHandler);
         bridge.removeEventListener(SWFBridgeRequest.ACTIVATE_POP_UP_REQUEST,activateRequestHandler);
         bridge.removeEventListener(SWFBridgeRequest.DEACTIVATE_POP_UP_REQUEST,deactivateRequestHandler);
         bridge.removeEventListener(SWFBridgeRequest.IS_BRIDGE_CHILD_REQUEST,isBridgeChildHandler);
         bridge.removeEventListener(EventListenerRequest.ADD_EVENT_LISTENER_REQUEST,eventListenerRequestHandler);
         bridge.removeEventListener(EventListenerRequest.REMOVE_EVENT_LISTENER_REQUEST,eventListenerRequestHandler);
         bridge.removeEventListener(SWFBridgeRequest.CAN_ACTIVATE_POP_UP_REQUEST,canActivateHandler);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removeChildBridgeListeners(bridge:IEventDispatcher) : void
      {
         if(!topLevel && Boolean(topLevelSystemManager))
         {
            SystemManager(topLevelSystemManager).removeChildBridgeListeners(bridge);
            return;
         }
         bridge.removeEventListener(SWFBridgeRequest.ADD_POP_UP_REQUEST,addPopupRequestHandler);
         bridge.removeEventListener(SWFBridgeRequest.REMOVE_POP_UP_REQUEST,removePopupRequestHandler);
         bridge.removeEventListener(SWFBridgeRequest.ADD_POP_UP_PLACE_HOLDER_REQUEST,addPlaceholderPopupRequestHandler);
         bridge.removeEventListener(SWFBridgeRequest.REMOVE_POP_UP_PLACE_HOLDER_REQUEST,removePlaceholderPopupRequestHandler);
         bridge.removeEventListener(SWFBridgeEvent.BRIDGE_WINDOW_ACTIVATE,activateFormSandboxEventHandler);
         bridge.removeEventListener(SWFBridgeEvent.BRIDGE_WINDOW_DEACTIVATE,deactivateFormSandboxEventHandler);
         bridge.removeEventListener(SWFBridgeEvent.BRIDGE_APPLICATION_ACTIVATE,activateApplicationSandboxEventHandler);
         bridge.removeEventListener(EventListenerRequest.ADD_EVENT_LISTENER_REQUEST,eventListenerRequestHandler);
         bridge.removeEventListener(EventListenerRequest.REMOVE_EVENT_LISTENER_REQUEST,eventListenerRequestHandler);
         bridge.removeEventListener(SWFBridgeRequest.CREATE_MODAL_WINDOW_REQUEST,modalWindowRequestHandler);
         bridge.removeEventListener(SWFBridgeRequest.SHOW_MODAL_WINDOW_REQUEST,modalWindowRequestHandler);
         bridge.removeEventListener(SWFBridgeRequest.HIDE_MODAL_WINDOW_REQUEST,modalWindowRequestHandler);
         bridge.removeEventListener(SWFBridgeRequest.GET_VISIBLE_RECT_REQUEST,getVisibleRectRequestHandler);
         bridge.removeEventListener(SWFBridgeRequest.HIDE_MOUSE_CURSOR_REQUEST,hideMouseCursorRequestHandler);
         bridge.removeEventListener(SWFBridgeRequest.SHOW_MOUSE_CURSOR_REQUEST,showMouseCursorRequestHandler);
         bridge.removeEventListener(SWFBridgeRequest.RESET_MOUSE_CURSOR_REQUEST,resetMouseCursorRequestHandler);
      }
      
      override public function getChildByName(name:String) : DisplayObject
      {
         return super.getChildByName(name);
      }
      
      public function removeChildBridge(bridge:IEventDispatcher) : void
      {
         dispatchEvent(new FlexChangeEvent(FlexChangeEvent.REMOVE_CHILD_BRIDGE,false,false,bridge));
         var fm:IFocusManager = IFocusManager(bridgeToFocusManager[bridge]);
         fm.removeSWFBridge(bridge);
         swfBridgeGroup.removeChildBridge(bridge);
         delete bridgeToFocusManager[bridge];
         removeChildBridgeListeners(bridge);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function cleanup(e:Event) : void
      {
         if(Singleton.getClass("mx.managers::IDragManager").getInstance() is NativeDragManagerImpl)
         {
            NativeDragManagerImpl(Singleton.getClass("mx.managers::IDragManager").getInstance()).unregisterSystemManager(this);
         }
         SystemManagerGlobals.topLevelSystemManagers.splice(SystemManagerGlobals.topLevelSystemManagers.indexOf(this),1);
         myWindow.nativeWindow.removeEventListener(Event.CLOSE,cleanup);
         myWindow = null;
      }
      
      override public function addChildAt(child:DisplayObject, index:int) : DisplayObject
      {
         ++noTopMostIndex;
         return rawChildren_addChildAt(child,applicationIndex + index);
      }
      
      public function get swfBridge() : IEventDispatcher
      {
         if(Boolean(swfBridgeGroup))
         {
            return swfBridgeGroup.parentBridge;
         }
         return null;
      }
      
      private function findRemotePopUp(window:Object, bridge:IEventDispatcher) : RemotePopUp
      {
         var popUp:RemotePopUp = null;
         var n:int = int(forms.length);
         for(var i:int = 0; i < n; i++)
         {
            if(isRemotePopUp(forms[i]))
            {
               popUp = RemotePopUp(forms[i]);
               if(popUp.window == window && popUp.bridge == bridge)
               {
                  return popUp;
               }
            }
         }
         return null;
      }
      
      public function info() : Object
      {
         return {"currentDomain":ApplicationDomain.currentDomain};
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get toolTipIndex() : int
      {
         return _toolTipIndex;
      }
      
      private function removePlaceholderPopupRequestHandler(event:Event) : void
      {
         var n:int = 0;
         var i:int = 0;
         var popUpRequest:SWFBridgeRequest = SWFBridgeRequest.marshal(event);
         if(!forwardPlaceholderRequest(popUpRequest,false))
         {
            n = int(forms.length);
            for(i = 0; i < n; i++)
            {
               if(isRemotePopUp(forms[i]))
               {
                  if(forms[i].window == popUpRequest.data.placeHolderId && forms[i].bridge == popUpRequest.requestor)
                  {
                     forms.splice(i,1);
                     break;
                  }
               }
            }
         }
      }
      
      public function set focusPane(value:Sprite) : void
      {
         if(Boolean(value))
         {
            addChild(value);
            value.x = 0;
            value.y = 0;
            value.scrollRect = null;
            _focusPane = value;
         }
         else
         {
            removeChild(_focusPane);
            _focusPane = null;
         }
      }
      
      private function eventListenerRequestHandler(event:Event) : void
      {
         var actualType:String = null;
         if(event is EventListenerRequest)
         {
            return;
         }
         var request:EventListenerRequest = EventListenerRequest.marshal(event);
         if(event.type == EventListenerRequest.ADD_EVENT_LISTENER_REQUEST)
         {
            if(!eventProxy)
            {
               eventProxy = new EventProxy(this);
            }
            actualType = EventUtil.sandboxMouseEventMap[request.eventType];
            if(Boolean(actualType))
            {
               if(isTopLevelRoot())
               {
                  stage.addEventListener(MouseEvent.MOUSE_MOVE,resetMouseCursorTracking,true,EventPriority.CURSOR_MANAGEMENT + 1,true);
               }
               else
               {
                  super.addEventListener(MouseEvent.MOUSE_MOVE,resetMouseCursorTracking,true,EventPriority.CURSOR_MANAGEMENT + 1,true);
               }
               addEventListenerToSandboxes(request.eventType,sandboxMouseListener,true,request.priority,request.useWeakReference,event.target as IEventDispatcher);
               addEventListenerToOtherSystemManagers(request.eventType,otherSystemManagerMouseListener,true,request.priority,request.useWeakReference);
               if(getSandboxRoot() == this)
               {
                  if(isTopLevelRoot() && (actualType == MouseEvent.MOUSE_UP || actualType == MouseEvent.MOUSE_MOVE))
                  {
                     stage.addEventListener(actualType,eventProxy.marshalListener,false,request.priority,request.useWeakReference);
                  }
                  super.addEventListener(actualType,eventProxy.marshalListener,true,request.priority,request.useWeakReference);
               }
            }
         }
         else if(event.type == EventListenerRequest.REMOVE_EVENT_LISTENER_REQUEST)
         {
            actualType = EventUtil.sandboxMouseEventMap[request.eventType];
            if(Boolean(actualType))
            {
               removeEventListenerFromOtherSystemManagers(request.eventType,otherSystemManagerMouseListener,true);
               removeEventListenerFromSandboxes(request.eventType,sandboxMouseListener,true,event.target as IEventDispatcher);
               if(getSandboxRoot() == this)
               {
                  if(isTopLevelRoot() && (actualType == MouseEvent.MOUSE_UP || actualType == MouseEvent.MOUSE_MOVE))
                  {
                     stage.removeEventListener(actualType,eventProxy.marshalListener);
                  }
                  super.removeEventListener(actualType,eventProxy.marshalListener,true);
               }
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set applicationIndex(value:int) : void
      {
         _applicationIndex = value;
      }
      
      private function addPlaceholderId(id:String, previousId:String, bridge:IEventDispatcher, placeholder:Object) : void
      {
         if(!bridge)
         {
            throw new Error();
         }
         if(!idToPlaceholder)
         {
            idToPlaceholder = [];
         }
         idToPlaceholder[id] = new PlaceholderData(previousId,bridge,placeholder);
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
      
      public function dispatchEventFromSWFBridges(event:Event, skip:IEventDispatcher = null, trackClones:Boolean = false, toOtherSystemManagers:Boolean = false) : void
      {
         var clone:Event = null;
         if(toOtherSystemManagers)
         {
            dispatchEventToOtherSystemManagers(event);
         }
         if(!swfBridgeGroup)
         {
            return;
         }
         clone = event.clone();
         if(trackClones)
         {
            currentSandboxEvent = clone;
         }
         var parentBridge:IEventDispatcher = swfBridgeGroup.parentBridge;
         if(Boolean(parentBridge) && parentBridge != skip)
         {
            if(clone is SWFBridgeRequest)
            {
               SWFBridgeRequest(clone).requestor = parentBridge;
            }
            parentBridge.dispatchEvent(clone);
         }
         var children:Array = swfBridgeGroup.getChildBridges();
         for(var i:int = 0; i < children.length; i++)
         {
            if(children[i] != skip)
            {
               clone = event.clone();
               if(trackClones)
               {
                  currentSandboxEvent = clone;
               }
               if(clone is SWFBridgeRequest)
               {
                  SWFBridgeRequest(clone).requestor = IEventDispatcher(children[i]);
               }
               IEventDispatcher(children[i]).dispatchEvent(clone);
            }
         }
         currentSandboxEvent = null;
      }
      
      private function setActualSizeRequestHandler(event:Event) : void
      {
      }
      
      public function useSWFBridge() : Boolean
      {
         var sbRoot:DisplayObject;
         if(isStageRoot)
         {
            return false;
         }
         if(!topLevel && Boolean(topLevelSystemManager))
         {
            return topLevelSystemManager.useSWFBridge();
         }
         sbRoot = getSandboxRoot();
         if(topLevel && sbRoot != this)
         {
            return true;
         }
         if(sbRoot == this)
         {
            try
            {
               root.loaderInfo.parentAllowsChild;
               if(!(parentAllowsChild && childAllowsParent))
               {
                  return true;
               }
               try
               {
                  if(!parent.dispatchEvent(new Event("mx.managers.SystemManager.isStageRoot",false,true)))
                  {
                     return true;
                  }
               }
               catch(e:Error)
               {
               }
            }
            catch(e1:Error)
            {
               return false;
            }
         }
         return false;
      }
      
      private function canActivateHandler(event:Event) : void
      {
         var request:SWFBridgeRequest = null;
         var placeholder:PlaceholderData = null;
         var popUp:RemotePopUp = null;
         var smp:SystemManagerProxy = null;
         var f:IFocusManagerContainer = null;
         var bridge:IEventDispatcher = null;
         var eObj:Object = Object(event);
         var child:Object = eObj.data;
         var nextId:String = null;
         if(eObj.data is String)
         {
            placeholder = idToPlaceholder[eObj.data];
            child = placeholder.data;
            nextId = placeholder.id;
            if(nextId == null)
            {
               popUp = findRemotePopUp(child,placeholder.bridge);
               if(Boolean(popUp))
               {
                  request = new SWFBridgeRequest(SWFBridgeRequest.CAN_ACTIVATE_POP_UP_REQUEST,false,false,IEventDispatcher(popUp.bridge),popUp.window);
                  if(Boolean(popUp.bridge))
                  {
                     popUp.bridge.dispatchEvent(request);
                     eObj.data = request.data;
                  }
                  return;
               }
            }
         }
         if(child is SystemManagerProxy)
         {
            smp = SystemManagerProxy(child);
            f = findFocusManagerContainer(smp);
            eObj.data = smp && f && canActivateLocalComponent(f);
         }
         else if(child is IFocusManagerContainer)
         {
            eObj.data = canActivateLocalComponent(child);
         }
         else
         {
            if(!(child is IEventDispatcher))
            {
               throw new Error();
            }
            bridge = IEventDispatcher(child);
            request = new SWFBridgeRequest(SWFBridgeRequest.CAN_ACTIVATE_POP_UP_REQUEST,false,false,bridge,nextId);
            if(Boolean(bridge))
            {
               bridge.dispatchEvent(request);
               eObj.data = request.data;
            }
         }
      }
      
      private function addEventListenerToSandboxes(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false, skip:IEventDispatcher = null) : void
      {
         var i:int = 0;
         var childBridge:IEventDispatcher = null;
         if(!swfBridgeGroup)
         {
            return;
         }
         var request:EventListenerRequest = new EventListenerRequest(EventListenerRequest.ADD_EVENT_LISTENER_REQUEST,false,false,type,useCapture,priority,useWeakReference);
         var parentBridge:IEventDispatcher = swfBridgeGroup.parentBridge;
         if(Boolean(parentBridge) && parentBridge != skip)
         {
            parentBridge.addEventListener(type,listener,false,priority,useWeakReference);
         }
         for(var children:Array = swfBridgeGroup.getChildBridges(); i < children.length; )
         {
            childBridge = IEventDispatcher(children[i]);
            if(childBridge != skip)
            {
               childBridge.addEventListener(type,listener,false,priority,useWeakReference);
            }
            i++;
         }
         dispatchEventFromSWFBridges(request,skip);
      }
      
      private function forwardFormEvent(event:SWFBridgeEvent) : Boolean
      {
         var sbRoot:DisplayObject = null;
         if(isTopLevelRoot())
         {
            return false;
         }
         var bridge:IEventDispatcher = swfBridgeGroup.parentBridge;
         if(Boolean(bridge))
         {
            sbRoot = getSandboxRoot();
            event.data.notifier = bridge;
            if(sbRoot == this)
            {
               if(!(event.data.window is String))
               {
                  event.data.window = NameUtil.displayObjectToString(DisplayObject(event.data.window));
               }
               else
               {
                  event.data.window = NameUtil.displayObjectToString(DisplayObject(this)) + "." + event.data.window;
               }
               bridge.dispatchEvent(event);
            }
            else
            {
               if(event.data.window is String)
               {
                  event.data.window = NameUtil.displayObjectToString(DisplayObject(this)) + "." + event.data.window;
               }
               sbRoot.dispatchEvent(event);
            }
         }
         return true;
      }
      
      public function activate(f:IFocusManagerContainer) : void
      {
         activateForm(f);
      }
      
      private function sandboxMouseListener(event:Event) : void
      {
         if(event is SandboxMouseEvent)
         {
            return;
         }
         var marshaledEvent:Event = SandboxMouseEvent.marshal(event);
         dispatchEventFromSWFBridges(marshaledEvent,event.target as IEventDispatcher);
         var me:InterManagerRequest = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST);
         me.name = "sameSandbox";
         me.value = event;
         getSandboxRoot().dispatchEvent(me);
         if(!me.value)
         {
            dispatchEvent(marshaledEvent);
         }
      }
      
      override public function removeChild(child:DisplayObject) : DisplayObject
      {
         --noTopMostIndex;
         return rawChildren_removeChild(child);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function rawChildren_removeChild(child:DisplayObject) : DisplayObject
      {
         removingChild(child);
         super.removeChild(child);
         childRemoved(child);
         return child;
      }
      
      final §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get $numChildren() : int
      {
         return super.numChildren;
      }
      
      public function get toolTipChildren() : IChildList
      {
         if(!topLevel)
         {
            return _topLevelSystemManager.toolTipChildren;
         }
         if(!_toolTipChildren)
         {
            _toolTipChildren = new WindowedSystemChildrenList(this,new QName(mx_internal,"topMostIndex"),new QName(mx_internal,"toolTipIndex"));
         }
         return _toolTipChildren;
      }
      
      public function get popUpChildren() : IChildList
      {
         if(!topLevel)
         {
            return _topLevelSystemManager.popUpChildren;
         }
         if(!_popUpChildren)
         {
            _popUpChildren = new WindowedSystemChildrenList(this,new QName(mx_internal,"noTopMostIndex"),new QName(mx_internal,"topMostIndex"));
         }
         return _popUpChildren;
      }
      
      public function addFocusManager(f:IFocusManagerContainer) : void
      {
         forms.push(f);
      }
      
      public function isTopLevelRoot() : Boolean
      {
         return isStageRoot || isBootstrapRoot;
      }
      
      public function create(... params) : Object
      {
         var mainClassName:String = String(params[0]);
         var mainClass:Class = Class(getDefinitionByName(mainClassName));
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
      
      private function systemManagerHandler(event:Event) : void
      {
         if(event["name"] == "sameSandbox")
         {
            event["value"] = currentSandboxEvent == event["value"];
            return;
         }
         if(event["name"] == "hasSWFBridges")
         {
            event["value"] = hasSWFBridges();
            return;
         }
         if(event is InterManagerRequest)
         {
            return;
         }
         var name:String = event["name"];
         switch(name)
         {
            case "popUpChildren.addChild":
               popUpChildren.addChild(event["value"]);
               break;
            case "popUpChildren.removeChild":
               popUpChildren.removeChild(event["value"]);
               break;
            case "cursorChildren.addChild":
               cursorChildren.addChild(event["value"]);
               break;
            case "cursorChildren.removeChild":
               cursorChildren.removeChild(event["value"]);
               break;
            case "toolTipChildren.addChild":
               toolTipChildren.addChild(event["value"]);
               break;
            case "toolTipChildren.removeChild":
               toolTipChildren.removeChild(event["value"]);
               break;
            case "screen":
               event["value"] = screen;
               break;
            case "application":
               event["value"] = document;
               break;
            case "isTopLevelRoot":
               event["value"] = isTopLevelRoot();
               break;
            case "getVisibleApplicationRect":
               event["value"] = getVisibleApplicationRect();
               break;
            case "bringToFront":
               if(Boolean(event["value"].topMost))
               {
                  popUpChildren.setChildIndex(DisplayObject(event["value"].popUp),popUpChildren.numChildren - 1);
               }
               else
               {
                  setChildIndex(DisplayObject(event["value"].popUp),numChildren - 1);
               }
         }
      }
      
      private function removeRemotePopUp(form:RemotePopUp) : void
      {
         var n:int = int(forms.length);
         for(var i:int = 0; i < n; i++)
         {
            if(isRemotePopUp(forms[i]))
            {
               if(forms[i].window == form.window && forms[i].bridge == form.bridge)
               {
                  if(forms[i] == form)
                  {
                     deactivateForm(form);
                  }
                  forms.splice(i,1);
                  break;
               }
            }
         }
      }
      
      private function deactivateRemotePopUp(form:Object) : void
      {
         var request:SWFBridgeRequest = new SWFBridgeRequest(SWFBridgeRequest.DEACTIVATE_POP_UP_REQUEST,false,false,form.bridge,form.window);
         var bridge:Object = form.bridge;
         if(Boolean(bridge))
         {
            bridge.dispatchEvent(request);
         }
      }
      
      private function dispatchDeactivatedWindowEvent(window:DisplayObject) : void
      {
         var sbRoot:DisplayObject = null;
         var sendToSbRoot:Boolean = false;
         var bridgeEvent:SWFBridgeEvent = null;
         var bridge:IEventDispatcher = Boolean(swfBridgeGroup) ? swfBridgeGroup.parentBridge : null;
         if(Boolean(bridge))
         {
            sbRoot = getSandboxRoot();
            sendToSbRoot = sbRoot != this;
            bridgeEvent = new SWFBridgeEvent(SWFBridgeEvent.BRIDGE_WINDOW_DEACTIVATE,false,false,{
               "notifier":bridge,
               "window":(sendToSbRoot ? window : NameUtil.displayObjectToString(window))
            });
            if(sendToSbRoot)
            {
               sbRoot.dispatchEvent(bridgeEvent);
            }
            else
            {
               bridge.dispatchEvent(bridgeEvent);
            }
         }
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
               if(parent.hasEventListener(InterManagerRequest.SYSTEM_MANAGER_REQUEST))
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
      
      public function get document() : Object
      {
         return _document;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get cursorIndex() : int
      {
         return _cursorIndex;
      }
      
      private function resizeMouseCatcher() : void
      {
         var g:Graphics = null;
         if(Boolean(mouseCatcher))
         {
            g = mouseCatcher.graphics;
            g.clear();
            g.beginFill(0,0);
            g.drawRect(0,0,stage.stageWidth,stage.stageHeight);
            g.endFill();
         }
      }
      
      final §§namespace("http://www.adobe.com/2006/flex/mx/internal") function $addChild(child:DisplayObject) : DisplayObject
      {
         return super.addChild(child);
      }
      
      override public function getChildIndex(child:DisplayObject) : int
      {
         return super.getChildIndex(child) - applicationIndex;
      }
      
      override public function getObjectsUnderPoint(point:Point) : Array
      {
         var child:DisplayObject = null;
         var temp:Array = null;
         var children:Array = [];
         var n:int = topMostIndex;
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function rawChildren_contains(child:DisplayObject) : Boolean
      {
         return super.contains(child);
      }
      
      override public function get height() : Number
      {
         return _height;
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function rawChildren_getChildIndex(child:DisplayObject) : int
      {
         return super.getChildIndex(child);
      }
      
      private function addPopupRequestHandler(event:Event) : void
      {
         var topMost:Boolean = false;
         var children:IChildList = null;
         var bridgeProvider:ISWFBridgeProvider = null;
         var request:SWFBridgeRequest = null;
         if(event.target != this && event is SWFBridgeRequest)
         {
            return;
         }
         var popUpRequest:SWFBridgeRequest = SWFBridgeRequest.marshal(event);
         if(event.target != this)
         {
            bridgeProvider = swfBridgeGroup.getChildBridgeProvider(IEventDispatcher(event.target));
            if(!SecurityUtil.hasMutualTrustBetweenParentAndChild(bridgeProvider))
            {
               return;
            }
         }
         if(Boolean(swfBridgeGroup.parentBridge) && Boolean(SecurityUtil.hasMutualTrustBetweenParentAndChild(this)))
         {
            popUpRequest.requestor = swfBridgeGroup.parentBridge;
            getSandboxRoot().dispatchEvent(popUpRequest);
            return;
         }
         if(!popUpRequest.data.childList || popUpRequest.data.childList == PopUpManagerChildList.PARENT)
         {
            topMost = Boolean(popUpRequest.data.parent) && Boolean(popUpChildren.contains(popUpRequest.data.parent));
         }
         else
         {
            topMost = popUpRequest.data.childList == PopUpManagerChildList.POPUP;
         }
         children = topMost ? popUpChildren : this;
         children.addChild(DisplayObject(popUpRequest.data.window));
         if(Boolean(popUpRequest.data.modal))
         {
            ++numModalWindows;
         }
         var remoteForm:RemotePopUp = new RemotePopUp(popUpRequest.data.window,popUpRequest.requestor);
         forms.push(remoteForm);
         if(!isTopLevelRoot() && Boolean(swfBridgeGroup))
         {
            request = new SWFBridgeRequest(SWFBridgeRequest.ADD_POP_UP_PLACE_HOLDER_REQUEST,false,false,popUpRequest.requestor,{"window":popUpRequest.data.window});
            request.data.placeHolderId = NameUtil.displayObjectToString(DisplayObject(popUpRequest.data.window));
            dispatchEvent(request);
         }
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
            lastParent = parent;
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function regenerateStyleCache(recursive:Boolean) : void
      {
         var child:IStyleClient = null;
         var foundTopLevelWindow:Boolean = false;
         var n:int = int(rawChildren.numChildren);
         for(var i:int = 0; i < n; i++)
         {
            child = rawChildren.getChildAt(i) as IStyleClient;
            if(Boolean(child))
            {
               child.regenerateStyleCache(recursive);
            }
            if(isTopLevelWindow(DisplayObject(child)))
            {
               foundTopLevelWindow = true;
            }
            n = int(rawChildren.numChildren);
         }
         if(!foundTopLevelWindow && topLevelWindow is IStyleClient)
         {
            IStyleClient(topLevelWindow).regenerateStyleCache(recursive);
         }
      }
      
      private function activateRemotePopUp(form:Object) : void
      {
         var request:SWFBridgeRequest = new SWFBridgeRequest(SWFBridgeRequest.ACTIVATE_POP_UP_REQUEST,false,false,form.bridge,form.window);
         var bridge:Object = form.bridge;
         if(Boolean(bridge))
         {
            bridge.dispatchEvent(request);
         }
      }
      
      override public function addChild(child:DisplayObject) : DisplayObject
      {
         ++noTopMostIndex;
         return rawChildren_addChildAt(child,noTopMostIndex - 1);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set noTopMostIndex(value:int) : void
      {
         var delta:int = value - _noTopMostIndex;
         _noTopMostIndex = value;
         topMostIndex += delta;
      }
      
      public function set swfBridgeGroup(bridgeGroup:ISWFBridgeGroup) : void
      {
         if(topLevel)
         {
            _swfBridgeGroup = bridgeGroup;
         }
         else if(Boolean(topLevelSystemManager))
         {
            SystemManager(topLevelSystemManager).swfBridgeGroup = bridgeGroup;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function rawChildren_getChildAt(index:int) : DisplayObject
      {
         return super.getChildAt(index);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get topMostIndex() : int
      {
         return _topMostIndex;
      }
      
      private function addChildAndMouseCatcher() : void
      {
         var app:IUIComponent = topLevelWindow;
         mouseCatcher = new FlexSprite();
         mouseCatcher.name = "mouseCatcher";
         ++noTopMostIndex;
         super.addChildAt(mouseCatcher,0);
         resizeMouseCatcher();
         if(!topLevel)
         {
            mouseCatcher.visible = false;
            mask = mouseCatcher;
         }
         ++noTopMostIndex;
         super.addChild(DisplayObject(app));
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function rawChildren_setChildIndex(child:DisplayObject, newIndex:int) : void
      {
         super.setChildIndex(child,newIndex);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function childAdded(child:DisplayObject) : void
      {
         child.dispatchEvent(new FlexEvent(FlexEvent.ADD));
         if(child is IUIComponent)
         {
            IUIComponent(child).initialize();
         }
      }
      
      override public function setChildIndex(child:DisplayObject, newIndex:int) : void
      {
         super.setChildIndex(child,applicationIndex + newIndex);
      }
      
      private function deactivateFormSandboxEventHandler(event:Event) : void
      {
         if(event is SWFBridgeRequest)
         {
            return;
         }
         var bridgeEvent:SWFBridgeEvent = SWFBridgeEvent.marshal(event);
         if(!forwardFormEvent(bridgeEvent))
         {
            if(isRemotePopUp(form) && RemotePopUp(form).window == bridgeEvent.data.window && RemotePopUp(form).bridge == bridgeEvent.data.notifier)
            {
               deactivateForm(form);
            }
         }
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
         if(!fontName || !embeddedFontList || !embeddedFontList[fontName])
         {
            return false;
         }
         var info:Object = embeddedFontList[fontName];
         return !(Boolean(textFormat.bold) && !info.bold || Boolean(textFormat.italic) && !info.italic || !textFormat.bold && !textFormat.italic && !info.regular);
      }
      
      private function forwardPlaceholderRequest(request:SWFBridgeRequest, addPlaceholder:Boolean) : Boolean
      {
         if(isTopLevelRoot())
         {
            return false;
         }
         var refObj:Object = null;
         var oldId:String = null;
         if(Boolean(request.data.window))
         {
            refObj = request.data.window;
            request.data.window = null;
         }
         else
         {
            refObj = request.requestor;
            oldId = request.data.placeHolderId;
            request.data.placeHolderId = NameUtil.displayObjectToString(this) + "." + request.data.placeHolderId;
         }
         if(addPlaceholder)
         {
            addPlaceholderId(request.data.placeHolderId,oldId,request.requestor,refObj);
         }
         else
         {
            removePlaceholderId(request.data.placeHolderId);
         }
         var sbRoot:DisplayObject = getSandboxRoot();
         var bridge:IEventDispatcher = swfBridgeGroup.parentBridge;
         request.requestor = bridge;
         if(sbRoot == this)
         {
            bridge.dispatchEvent(request);
         }
         else
         {
            sbRoot.dispatchEvent(request);
         }
         return true;
      }
      
      private function updateLastActiveForm() : void
      {
         var n:int = int(forms.length);
         if(n < 2)
         {
            return;
         }
         var index:int = -1;
         for(var i:int = 0; i < n; i++)
         {
            if(areFormsEqual(form,forms[i]))
            {
               index = i;
               break;
            }
         }
         if(index >= 0)
         {
            forms.splice(index,1);
            forms.push(form);
         }
      }
      
      override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         var actualType:String = null;
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
         if(hasSWFBridges() || SystemManagerGlobals.topLevelSystemManagers.length > 1)
         {
            actualType = EventUtil.sandboxMouseEventMap[type];
            if(Boolean(actualType))
            {
               if(getSandboxRoot() == this && Boolean(eventProxy))
               {
                  super.removeEventListener(actualType,eventProxy.marshalListener,useCapture);
                  if(actualType == MouseEvent.MOUSE_UP)
                  {
                     try
                     {
                        if(Boolean(stage))
                        {
                           stage.removeEventListener(Event.MOUSE_LEAVE,eventProxy.marshalListener,useCapture);
                        }
                     }
                     catch(e:SecurityError)
                     {
                     }
                     super.removeEventListener(Event.MOUSE_LEAVE,eventProxy.marshalListener,useCapture);
                  }
               }
               if(!SystemManagerGlobals.changingListenersInOtherSystemManagers)
               {
                  removeEventListenerFromOtherSystemManagers(type,otherSystemManagerMouseListener,useCapture);
               }
               removeEventListenerFromSandboxes(type,sandboxMouseListener,useCapture);
               super.removeEventListener(type,listener,false);
               return;
            }
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
                     stage.removeEventListener(type,stageEventHandler,false);
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
                     stage.removeEventListener(Event.MOUSE_LEAVE,mouseLeaveHandler);
                  }
               }
               catch(error:SecurityError)
               {
               }
               super.removeEventListener(Event.MOUSE_LEAVE,mouseLeaveHandler);
            }
         }
      }
      
      override public function removeChildAt(index:int) : DisplayObject
      {
         --noTopMostIndex;
         return rawChildren_removeChildAt(applicationIndex + index);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function rawChildren_removeChildAt(index:int) : DisplayObject
      {
         var child:DisplayObject = super.getChildAt(index);
         removingChild(child);
         super.removeChildAt(index);
         childRemoved(child);
         return child;
      }
      
      private function deactivateRequestHandler(event:Event) : void
      {
         var placeholder:PlaceholderData = null;
         var popUp:RemotePopUp = null;
         var smp:SystemManagerProxy = null;
         var f:IFocusManagerContainer = null;
         var request:SWFBridgeRequest = SWFBridgeRequest.marshal(event);
         var child:Object = request.data;
         var nextId:String = null;
         if(request.data is String)
         {
            placeholder = idToPlaceholder[request.data];
            child = placeholder.data;
            nextId = placeholder.id;
            if(nextId == null)
            {
               popUp = findRemotePopUp(child,placeholder.bridge);
               if(Boolean(popUp))
               {
                  deactivateRemotePopUp(popUp);
                  return;
               }
            }
         }
         if(child is SystemManagerProxy)
         {
            smp = SystemManagerProxy(child);
            f = findFocusManagerContainer(smp);
            if(Boolean(smp) && Boolean(f))
            {
               smp.deactivateByProxy(f);
            }
         }
         else
         {
            if(!(child is IFocusManagerContainer))
            {
               if(child is IEventDispatcher)
               {
                  request.data = nextId;
                  request.requestor = IEventDispatcher(child);
                  IEventDispatcher(child).dispatchEvent(request);
                  return;
               }
               throw new Error();
            }
            IFocusManagerContainer(child).focusManager.deactivate();
         }
      }
      
      private function deactivateForm(f:Object) : void
      {
         if(Boolean(form))
         {
            if(form == f && forms.length > 1)
            {
               if(isRemotePopUp(form))
               {
                  deactivateRemotePopUp(form);
               }
               else
               {
                  form.focusManager.deactivate();
               }
               form = findLastActiveForm(f);
               if(Boolean(form))
               {
                  if(isRemotePopUp(form))
                  {
                     activateRemotePopUp(form);
                  }
                  else
                  {
                     form.focusManager.activate();
                  }
               }
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removingChild(child:DisplayObject) : void
      {
         child.dispatchEvent(new FlexEvent(FlexEvent.REMOVE));
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set toolTipIndex(value:int) : void
      {
         var delta:int = value - _toolTipIndex;
         _toolTipIndex = value;
         cursorIndex += delta;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get applicationIndex() : int
      {
         return _applicationIndex;
      }
      
      private function hasSWFBridges() : Boolean
      {
         if(Boolean(swfBridgeGroup))
         {
            return true;
         }
         return false;
      }
      
      private function stageEventHandler(event:Event) : void
      {
         if(event.target is Stage)
         {
            mouseCatcher.dispatchEvent(event);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set bridgeToFocusManager(bridgeToFMDictionary:Dictionary) : void
      {
         if(topLevel)
         {
            _bridgeToFocusManager = bridgeToFMDictionary;
         }
         else if(Boolean(topLevelSystemManager))
         {
            SystemManager(topLevelSystemManager).bridgeToFocusManager = bridgeToFMDictionary;
         }
      }
      
      public function get cursorChildren() : IChildList
      {
         if(!topLevel)
         {
            return _topLevelSystemManager.cursorChildren;
         }
         if(!_cursorChildren)
         {
            _cursorChildren = new WindowedSystemChildrenList(this,new QName(mx_internal,"toolTipIndex"),new QName(mx_internal,"cursorIndex"));
         }
         return _cursorChildren;
      }
      
      public function set numModalWindows(value:int) : void
      {
         _numModalWindows = value;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function rawChildren_getChildByName(name:String) : DisplayObject
      {
         return super.getChildByName(name);
      }
      
      private function isBridgeChildHandler(event:Event) : void
      {
         if(event is SWFBridgeRequest)
         {
            return;
         }
         var eObj:Object = Object(event);
         eObj.data = eObj.data && rawChildren.contains(eObj.data as DisplayObject);
      }
      
      public function allowDomain(... domains) : void
      {
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function rawChildren_addChildAt(child:DisplayObject, index:int) : DisplayObject
      {
         addingChild(child);
         super.addChildAt(child,index);
         childAdded(child);
         return child;
      }
      
      public function get topLevelSystemManager() : ISystemManager
      {
         if(topLevel)
         {
            return this;
         }
         return _topLevelSystemManager;
      }
      
      public function getVisibleApplicationRect(bounds:Rectangle = null) : Rectangle
      {
         var s:Rectangle = null;
         var pt:Point = null;
         var bridge:IEventDispatcher = null;
         var request:SWFBridgeRequest = null;
         if(!bounds)
         {
            bounds = getBounds(DisplayObject(this));
            s = screen;
            pt = new Point(Math.max(0,bounds.x),Math.max(0,bounds.y));
            pt = localToGlobal(pt);
            bounds.x = pt.x;
            bounds.y = pt.y;
            bounds.width = s.width;
            bounds.height = s.height;
         }
         if(useSWFBridge())
         {
            bridge = swfBridgeGroup.parentBridge;
            request = new SWFBridgeRequest(SWFBridgeRequest.GET_VISIBLE_RECT_REQUEST,false,false,bridge,bounds);
            bridge.dispatchEvent(request);
            bounds = Rectangle(request.data);
         }
         return bounds;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function dispatchActivatedWindowEvent(window:DisplayObject) : void
      {
         var sbRoot:DisplayObject = null;
         var sendToSbRoot:Boolean = false;
         var bridgeEvent:SWFBridgeEvent = null;
         var bridge:IEventDispatcher = Boolean(swfBridgeGroup) ? swfBridgeGroup.parentBridge : null;
         if(Boolean(bridge))
         {
            sbRoot = getSandboxRoot();
            sendToSbRoot = sbRoot != this;
            bridgeEvent = new SWFBridgeEvent(SWFBridgeEvent.BRIDGE_WINDOW_ACTIVATE,false,false,{
               "notifier":bridge,
               "window":(sendToSbRoot ? window : NameUtil.displayObjectToString(window))
            });
            if(sendToSbRoot)
            {
               sbRoot.dispatchEvent(bridgeEvent);
            }
            else
            {
               bridge.dispatchEvent(bridgeEvent);
            }
         }
      }
      
      private function canActivateLocalComponent(o:Object) : Boolean
      {
         if(o is Sprite && o is IUIComponent && Sprite(o).visible && Boolean(IUIComponent(o).enabled))
         {
            return true;
         }
         return false;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get noTopMostIndex() : int
      {
         return _noTopMostIndex;
      }
      
      private function activateRequestHandler(event:Event) : void
      {
         var placeholder:PlaceholderData = null;
         var popUp:RemotePopUp = null;
         var smp:SystemManagerProxy = null;
         var f:IFocusManagerContainer = null;
         var request:SWFBridgeRequest = SWFBridgeRequest.marshal(event);
         var child:Object = request.data;
         var nextId:String = null;
         if(request.data is String)
         {
            placeholder = idToPlaceholder[request.data];
            child = placeholder.data;
            nextId = placeholder.id;
            if(nextId == null)
            {
               popUp = findRemotePopUp(child,placeholder.bridge);
               if(Boolean(popUp))
               {
                  activateRemotePopUp(popUp);
                  return;
               }
            }
         }
         if(child is SystemManagerProxy)
         {
            smp = SystemManagerProxy(child);
            f = findFocusManagerContainer(smp);
            if(Boolean(smp) && Boolean(f))
            {
               smp.activateByProxy(f);
            }
         }
         else if(child is IFocusManagerContainer)
         {
            IFocusManagerContainer(child).focusManager.activate();
         }
         else
         {
            if(!(child is IEventDispatcher))
            {
               throw new Error();
            }
            request.data = nextId;
            request.requestor = IEventDispatcher(child);
            IEventDispatcher(child).dispatchEvent(request);
         }
      }
      
      public function addChildToSandboxRoot(layer:String, child:DisplayObject) : void
      {
         var me:InterManagerRequest = null;
         if(getSandboxRoot() == this)
         {
            this[layer].addChild(child);
         }
         else
         {
            addingChild(child);
            me = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST);
            me.name = layer + ".addChild";
            me.value = child;
            getSandboxRoot().dispatchEvent(me);
            childAdded(child);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function childRemoved(child:DisplayObject) : void
      {
         if(child is IUIComponent)
         {
            IUIComponent(child).parentChanged(null);
         }
      }
      
      final §§namespace("http://www.adobe.com/2006/flex/mx/internal") function $removeChildAt(index:int) : DisplayObject
      {
         return super.removeChildAt(index);
      }
      
      private function canActivatePopUp(f:Object) : Boolean
      {
         var remotePopUp:RemotePopUp = null;
         var event:SWFBridgeRequest = null;
         if(isRemotePopUp(f))
         {
            remotePopUp = RemotePopUp(f);
            event = new SWFBridgeRequest(SWFBridgeRequest.CAN_ACTIVATE_POP_UP_REQUEST,false,false,null,remotePopUp.window);
            IEventDispatcher(remotePopUp.bridge).dispatchEvent(event);
            return event.data;
         }
         if(canActivateLocalComponent(f))
         {
            return true;
         }
         return false;
      }
      
      override public function get numChildren() : int
      {
         return noTopMostIndex - applicationIndex;
      }
      
      protected function initializeTopLevelWindow(event:Event) : void
      {
         var app:IUIComponent = null;
         var obj:DisplayObjectContainer = null;
         initialized = true;
         if(!parent)
         {
            return;
         }
         initContextMenu();
         if(!topLevel)
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
                  _topLevelSystemManager = IUIComponent(obj).systemManager;
                  break;
               }
               obj = obj.parent;
            }
         }
         addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler,true);
         stage.addEventListener(Event.RESIZE,Stage_resizeHandler,false,0,true);
         document = app = topLevelWindow;
         if(Boolean(document))
         {
            if(topLevel && Boolean(stage))
            {
               _width = stage.stageWidth;
               _height = stage.stageHeight;
               IFlexDisplayObject(app).setActualSize(stage.stageWidth,stage.stageHeight);
            }
            else
            {
               IFlexDisplayObject(app).setActualSize(loaderInfo.width,loaderInfo.height);
            }
            addingChild(DisplayObject(app));
            childAdded(DisplayObject(app));
         }
         else
         {
            document = this;
         }
         addChildAndMouseCatcher();
      }
      
      final §§namespace("http://www.adobe.com/2006/flex/mx/internal") function $addChildAt(child:DisplayObject, index:int) : DisplayObject
      {
         return super.addChildAt(child,index);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get bridgeToFocusManager() : Dictionary
      {
         if(topLevel)
         {
            return _bridgeToFocusManager;
         }
         if(Boolean(topLevelSystemManager))
         {
            return SystemManager(topLevelSystemManager).bridgeToFocusManager;
         }
         return null;
      }
      
      private function areFormsEqual(form1:Object, form2:Object) : Boolean
      {
         if(form1 == form2)
         {
            return true;
         }
         if(form1 is RemotePopUp && form2 is RemotePopUp)
         {
            return areRemotePopUpsEqual(form1,form2);
         }
         return false;
      }
      
      public function get numModalWindows() : int
      {
         return _numModalWindows;
      }
      
      override public function get width() : Number
      {
         return _width;
      }
      
      private function dispatchActivatedApplicationEvent() : void
      {
         var bridgeEvent:SWFBridgeEvent = null;
         var bridge:IEventDispatcher = Boolean(swfBridgeGroup) ? swfBridgeGroup.parentBridge : null;
         if(Boolean(bridge))
         {
            bridgeEvent = new SWFBridgeEvent(SWFBridgeEvent.BRIDGE_APPLICATION_ACTIVATE,false,false);
            bridge.dispatchEvent(bridgeEvent);
         }
      }
      
      public function isTopLevelWindow(object:DisplayObject) : Boolean
      {
         return object is IUIComponent && IUIComponent(object) == topLevelWindow;
      }
      
      private function removePlaceholderId(id:String) : void
      {
         delete idToPlaceholder[id];
      }
      
      private function otherSystemManagerMouseListener(event:SandboxMouseEvent) : void
      {
         if(SystemManagerGlobals.dispatchingEventToOtherSystemManagers)
         {
            return;
         }
         dispatchEventFromSWFBridges(event);
         var me:InterManagerRequest = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST);
         me.name = "sameSandbox";
         me.value = event;
         getSandboxRoot().dispatchEvent(me);
         if(!me.value)
         {
            dispatchEvent(event);
         }
      }
      
      private function hideMouseCursorRequestHandler(event:Event) : void
      {
         var bridge:IEventDispatcher = null;
         if(!isTopLevelRoot() && event is SWFBridgeRequest)
         {
            return;
         }
         var request:SWFBridgeRequest = SWFBridgeRequest.marshal(event);
         if(!isTopLevelRoot())
         {
            bridge = swfBridgeGroup.parentBridge;
            request.requestor = bridge;
            bridge.dispatchEvent(request);
         }
         else if(Boolean(eventProxy))
         {
            SystemManagerGlobals.showMouseCursor = false;
         }
      }
      
      public function isDisplayObjectInABridgedApplication(displayObject:DisplayObject) : Boolean
      {
         var request:SWFBridgeRequest = null;
         var children:Array = null;
         var n:int = 0;
         var i:int = 0;
         var childBridge:IEventDispatcher = null;
         var bp:ISWFBridgeProvider = null;
         if(Boolean(swfBridgeGroup))
         {
            request = new SWFBridgeRequest(SWFBridgeRequest.IS_BRIDGE_CHILD_REQUEST,false,false,null,displayObject);
            children = swfBridgeGroup.getChildBridges();
            n = int(children.length);
            for(i = 0; i < n; i++)
            {
               childBridge = IEventDispatcher(children[i]);
               bp = swfBridgeGroup.getChildBridgeProvider(childBridge);
               if(SecurityUtil.hasMutualTrustBetweenParentAndChild(bp))
               {
                  childBridge.dispatchEvent(request);
                  if(request.data == true)
                  {
                     return true;
                  }
                  request.data = displayObject;
               }
            }
         }
         return false;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set window(value:Window) : void
      {
         _window = value;
      }
      
      private function activateFormSandboxEventHandler(event:Event) : void
      {
         var bridgeEvent:SWFBridgeEvent = SWFBridgeEvent.marshal(event);
         if(!forwardFormEvent(bridgeEvent))
         {
            activateForm(new RemotePopUp(bridgeEvent.data.window,bridgeEvent.data.notifier));
         }
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get window() : Window
      {
         return _window;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function addWindow(win:Window) : void
      {
         myWindow = win;
         myWindow.nativeWindow.addEventListener("close",cleanup);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function rawChildren_addChild(child:DisplayObject) : DisplayObject
      {
         addingChild(child);
         super.addChild(child);
         childAdded(child);
         return child;
      }
      
      private function mouseLeaveHandler(event:Event) : void
      {
         dispatchEvent(new SandboxMouseEvent(SandboxMouseEvent.MOUSE_UP_SOMEWHERE));
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function addingChild(child:DisplayObject) : void
      {
         var obj:DisplayObjectContainer = null;
         var newNestLevel:int = 1;
         if(!topLevel)
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
         nestLevel = newNestLevel;
         if(child is IUIComponent)
         {
            IUIComponent(child).systemManager = this;
         }
         var uiComponentClassName:Class = Class(getDefinitionByName("mx.core.UIComponent"));
         if(child is IUIComponent && !IUIComponent(child).document)
         {
            IUIComponent(child).document = document;
         }
         if(child is ILayoutManagerClient)
         {
            ILayoutManagerClient(child).nestLevel = nestLevel + 1;
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
   }
}

