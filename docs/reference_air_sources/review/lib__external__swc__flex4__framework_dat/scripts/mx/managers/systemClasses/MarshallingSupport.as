package mx.managers.systemClasses
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import mx.core.EventPriority;
   import mx.core.IChildList;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModuleFactory;
   import mx.core.IRawChildrenContainer;
   import mx.core.ISWFBridgeGroup;
   import mx.core.ISWFBridgeProvider;
   import mx.core.ISWFLoader;
   import mx.core.IUIComponent;
   import mx.core.SWFBridgeGroup;
   import mx.core.Singleton;
   import mx.core.mx_internal;
   import mx.events.DynamicEvent;
   import mx.events.EventListenerRequest;
   import mx.events.FlexChangeEvent;
   import mx.events.InterManagerRequest;
   import mx.events.InvalidateRequestData;
   import mx.events.Request;
   import mx.events.SWFBridgeEvent;
   import mx.events.SWFBridgeRequest;
   import mx.events.SandboxMouseEvent;
   import mx.managers.IFocusManager;
   import mx.managers.IFocusManagerContainer;
   import mx.managers.IMarshalSystemManager;
   import mx.managers.ISystemManager;
   import mx.managers.ISystemManagerChildManager;
   import mx.managers.PopUpManagerChildList;
   import mx.managers.SystemManagerGlobals;
   import mx.managers.SystemManagerProxy;
   import mx.utils.EventUtil;
   import mx.utils.NameUtil;
   import mx.utils.SecurityUtil;
   
   use namespace mx_internal;
   
   [Mixin]
   [ExcludeClass]
   public class MarshallingSupport implements IMarshalSystemManager, ISWFBridgeProvider
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var systemManager:ISystemManager;
      
      private var childManager:ISystemManagerChildManager;
      
      private var _bridgeToFocusManager:Dictionary;
      
      private var _swfBridgeGroup:ISWFBridgeGroup;
      
      private var idToPlaceholder:Object;
      
      private var eventProxy:EventProxy;
      
      private var eventProxyRefCounts:Object = {};
      
      private var currentSandboxEvent:Event;
      
      public function MarshallingSupport(systemManager:ISystemManager = null)
      {
         var bridgeEvent:SWFBridgeEvent = null;
         super();
         if(!systemManager)
         {
            return;
         }
         this.systemManager = systemManager;
         systemManager.addEventListener("invalidateParentSizeAndDisplayList",this.invalidateParentSizeAndDisplayListHandler);
         systemManager.addEventListener("addEventListener",this.addEventListenerHandler);
         systemManager.addEventListener("removeEventListener",this.removeEventListenerHandler);
         systemManager.addEventListener("getVisibleApplicationRect",this.getVisibleApplicationRectHandler);
         systemManager.addEventListener("deployMouseShields",this.deployMouseShieldsHandler);
         systemManager.addEventListener("getScreen",this.Stage_resizeHandler);
         var awm:ActiveWindowManager = ActiveWindowManager(systemManager.getImplementation("mx.managers::IActiveWindowManager"));
         awm.addEventListener("removeFocusManager",this.removeFocusManagerHandler);
         awm.addEventListener("activateForm",this.activateFormHandler);
         awm.addEventListener("activatedForm",this.activatedFormHandler);
         awm.addEventListener("deactivateForm",this.deactivateFormHandler);
         awm.addEventListener("deactivatedForm",this.deactivatedFormHandler);
         awm.addEventListener("canActivateForm",this.canActivateFormHandler);
         awm.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         this.childManager = ISystemManagerChildManager(systemManager.getImplementation("mx.managers::ISystemManagerChildManager"));
         if(this.useSWFBridge())
         {
            this.swfBridgeGroup = new SWFBridgeGroup(systemManager);
            this.swfBridgeGroup.parentBridge = DisplayObject(systemManager).loaderInfo.sharedEvents;
            this.addParentBridgeListeners();
            bridgeEvent = new SWFBridgeEvent(SWFBridgeEvent.BRIDGE_NEW_APPLICATION);
            bridgeEvent.data = this.swfBridgeGroup.parentBridge;
            this.swfBridgeGroup.parentBridge.dispatchEvent(bridgeEvent);
            this.addEventListener(SWFBridgeRequest.ADD_POP_UP_PLACE_HOLDER_REQUEST,this.addPlaceholderPopupRequestHandler);
            DisplayObject(systemManager).root.loaderInfo.addEventListener(Event.UNLOAD,this.unloadHandler,false,0,true);
         }
         var sbRoot:DisplayObject = systemManager.getSandboxRoot();
         sbRoot.addEventListener(InterManagerRequest.INIT_MANAGER_REQUEST,this.initManagerHandler,false,0,true);
         if(sbRoot == systemManager)
         {
            sbRoot.addEventListener(InterManagerRequest.SYSTEM_MANAGER_REQUEST,this.systemManagerHandler);
            sbRoot.addEventListener(InterManagerRequest.DRAG_MANAGER_REQUEST,this.multiWindowRedispatcher);
            sbRoot.addEventListener("dispatchDragEvent",this.multiWindowRedispatcher);
            sbRoot.addEventListener(SWFBridgeRequest.ADD_POP_UP_REQUEST,this.addPopupRequestHandler);
            sbRoot.addEventListener(SWFBridgeRequest.REMOVE_POP_UP_REQUEST,this.removePopupRequestHandler);
            sbRoot.addEventListener(SWFBridgeRequest.ADD_POP_UP_PLACE_HOLDER_REQUEST,this.addPlaceholderPopupRequestHandler);
            sbRoot.addEventListener(SWFBridgeRequest.REMOVE_POP_UP_PLACE_HOLDER_REQUEST,this.removePlaceholderPopupRequestHandler);
            sbRoot.addEventListener(SWFBridgeEvent.BRIDGE_WINDOW_ACTIVATE,this.activateFormSandboxEventHandler);
            sbRoot.addEventListener(SWFBridgeEvent.BRIDGE_WINDOW_DEACTIVATE,this.deactivateFormSandboxEventHandler);
            sbRoot.addEventListener(SWFBridgeRequest.HIDE_MOUSE_CURSOR_REQUEST,this.hideMouseCursorRequestHandler);
            sbRoot.addEventListener(SWFBridgeRequest.SHOW_MOUSE_CURSOR_REQUEST,this.showMouseCursorRequestHandler);
            sbRoot.addEventListener(SWFBridgeRequest.RESET_MOUSE_CURSOR_REQUEST,this.resetMouseCursorRequestHandler);
         }
      }
      
      public static function init(fbs:IFlexModuleFactory) : void
      {
         Singleton.registerClass("mx.managers::IMarshalSystemManager",MarshallingSupport);
      }
      
      private static function weakDependency() : void
      {
      }
      
      private static function weakDependency2() : void
      {
      }
      
      private static function weakDependency3() : void
      {
      }
      
      private static function weakDependency4() : void
      {
      }
      
      private static function weakDependency5() : void
      {
      }
      
      private static function isRemotePopUp(form:Object) : Boolean
      {
         return !(form is IFocusManagerContainer);
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
      
      private static function getChildListIndex(childList:IChildList, f:Object) : int
      {
         var index:int = -1;
         try
         {
            index = childList.getChildIndex(DisplayObject(f));
         }
         catch(e:ArgumentError)
         {
         }
         return index;
      }
      
      mx_internal function get bridgeToFocusManager() : Dictionary
      {
         var topMP:MarshallingSupport = null;
         if(Boolean(Object(this.systemManager).topLevel))
         {
            return this._bridgeToFocusManager;
         }
         if(Boolean(this.systemManager.topLevelSystemManager))
         {
            topMP = MarshallingSupport(this.systemManager.topLevelSystemManager.getImplementation("mx.managers::IMarshalSystemManager"));
            return topMP.bridgeToFocusManager;
         }
         return null;
      }
      
      mx_internal function set bridgeToFocusManager(bridgeToFMDictionary:Dictionary) : void
      {
         var topMP:MarshallingSupport = null;
         if(Boolean(Object(this.systemManager).topLevel))
         {
            this._bridgeToFocusManager = bridgeToFMDictionary;
         }
         else if(Boolean(this.systemManager.topLevelSystemManager))
         {
            topMP = MarshallingSupport(this.systemManager.topLevelSystemManager.getImplementation("mx.managers::IMarshalSystemManager"));
            topMP.bridgeToFocusManager = bridgeToFMDictionary;
         }
      }
      
      public function get swfBridgeGroup() : ISWFBridgeGroup
      {
         var mp:IMarshalSystemManager = null;
         if(this.systemManager.isTopLevel())
         {
            return this._swfBridgeGroup;
         }
         if(Boolean(this.systemManager.topLevelSystemManager))
         {
            mp = IMarshalSystemManager(this.systemManager.topLevelSystemManager.getImplementation("mx.managers::IMarshalSystemManager"));
            return mp.swfBridgeGroup;
         }
         return null;
      }
      
      public function set swfBridgeGroup(bridgeGroup:ISWFBridgeGroup) : void
      {
         var mp:IMarshalSystemManager = null;
         if(this.systemManager.isTopLevel())
         {
            this._swfBridgeGroup = bridgeGroup;
         }
         else if(Boolean(this.systemManager.topLevelSystemManager))
         {
            mp = IMarshalSystemManager(this.systemManager.topLevelSystemManager.getImplementation("mx.managers::IMarshalSystemManager"));
            mp.swfBridgeGroup = bridgeGroup;
         }
      }
      
      public function get swfBridge() : IEventDispatcher
      {
         if(Boolean(this.swfBridgeGroup))
         {
            return this.swfBridgeGroup.parentBridge;
         }
         return null;
      }
      
      public function get childAllowsParent() : Boolean
      {
         try
         {
            return DisplayObject(this.systemManager).loaderInfo.childAllowsParent;
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
            return DisplayObject(this.systemManager).loaderInfo.parentAllowsChild;
         }
         catch(error:Error)
         {
         }
         return false;
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : Boolean
      {
         var actualType:String = null;
         if(this.hasSWFBridges() || SystemManagerGlobals.topLevelSystemManagers.length > 1)
         {
            if(!this.eventProxy)
            {
               this.eventProxy = new EventProxy(this.systemManager);
            }
            actualType = EventUtil.sandboxMouseEventMap[type];
            if(Boolean(actualType))
            {
               if(this.systemManager.isTopLevelRoot())
               {
                  this.systemManager.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.resetMouseCursorTracking,true,EventPriority.CURSOR_MANAGEMENT + 1,true);
                  this.addEventListenerToSandboxes(SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE,this.resetMouseCursorTracking,true,EventPriority.CURSOR_MANAGEMENT + 1,true);
               }
               else
               {
                  Object(this.systemManager).$addEventListener(MouseEvent.MOUSE_MOVE,this.resetMouseCursorTracking,true,EventPriority.CURSOR_MANAGEMENT + 1,true);
               }
               this.addEventListenerToSandboxes(type,this.sandboxMouseListener,useCapture,priority,useWeakReference);
               if(!SystemManagerGlobals.changingListenersInOtherSystemManagers)
               {
                  this.addEventListenerToOtherSystemManagers(type,this.otherSystemManagerMouseListener,useCapture,priority,useWeakReference);
               }
               if(this.systemManager.getSandboxRoot() == this.systemManager)
               {
                  if(this.eventProxyRefCounts[actualType] == null)
                  {
                     this.eventProxyRefCounts[actualType] = 1;
                  }
                  else
                  {
                     ++this.eventProxyRefCounts[actualType];
                  }
                  Object(this.systemManager).$addEventListener(actualType,this.eventProxy.marshalListener,useCapture,priority,useWeakReference);
                  if(actualType == MouseEvent.MOUSE_UP)
                  {
                     try
                     {
                        if(Boolean(this.systemManager.stage))
                        {
                           this.systemManager.stage.addEventListener(Event.MOUSE_LEAVE,this.eventProxy.marshalListener,useCapture,priority,useWeakReference);
                        }
                        else
                        {
                           Object(this.systemManager).$addEventListener(Event.MOUSE_LEAVE,this.eventProxy.marshalListener,useCapture,priority,useWeakReference);
                        }
                     }
                     catch(e:SecurityError)
                     {
                        Object(systemManager).$addEventListener(Event.MOUSE_LEAVE,eventProxy.marshalListener,useCapture,priority,useWeakReference);
                     }
                  }
               }
               Object(this.systemManager).$addEventListener(type,listener,false,priority,useWeakReference);
               return false;
            }
         }
         return true;
      }
      
      private function hasSWFBridges() : Boolean
      {
         return this.swfBridgeGroup != null;
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : Boolean
      {
         var actualType:String = null;
         if(this.hasSWFBridges() || SystemManagerGlobals.topLevelSystemManagers.length > 1)
         {
            actualType = EventUtil.sandboxMouseEventMap[type];
            if(Boolean(actualType))
            {
               if(this.systemManager.getSandboxRoot() == this.systemManager && Boolean(this.eventProxy))
               {
                  if(this.eventProxyRefCounts[actualType] != null)
                  {
                     --this.eventProxyRefCounts[actualType];
                  }
                  if(!(this.eventProxyRefCounts[actualType] == null || this.eventProxyRefCounts[actualType] == 0))
                  {
                     return false;
                  }
                  delete this.eventProxyRefCounts[actualType];
                  Object(this.systemManager).$removeEventListener(actualType,this.eventProxy.marshalListener,useCapture);
                  if(actualType == MouseEvent.MOUSE_UP)
                  {
                     try
                     {
                        if(Boolean(this.systemManager.stage))
                        {
                           this.systemManager.stage.removeEventListener(Event.MOUSE_LEAVE,this.eventProxy.marshalListener,useCapture);
                        }
                     }
                     catch(e:SecurityError)
                     {
                     }
                     Object(this.systemManager).$removeEventListener(Event.MOUSE_LEAVE,this.eventProxy.marshalListener,useCapture);
                  }
               }
               if(!SystemManagerGlobals.changingListenersInOtherSystemManagers)
               {
                  this.removeEventListenerFromOtherSystemManagers(type,this.otherSystemManagerMouseListener,useCapture);
               }
               this.removeEventListenerFromSandboxes(type,this.sandboxMouseListener,useCapture);
               Object(this.systemManager).$removeEventListener(type,listener,false);
               return false;
            }
         }
         return true;
      }
      
      private function activateFormHandler(event:DynamicEvent) : void
      {
         var awm:ActiveWindowManager = ActiveWindowManager(this.systemManager.getImplementation("mx.managers::IActiveWindowManager"));
         if(Boolean(awm.form))
         {
            if(awm.form != event.form && awm.forms.length > 1)
            {
               if(isRemotePopUp(awm.form))
               {
                  if(!areRemotePopUpsEqual(awm.form,event.form))
                  {
                     this.deactivateRemotePopUp(awm.form);
                  }
                  event.preventDefault();
               }
            }
         }
      }
      
      private function activatedFormHandler(event:DynamicEvent) : void
      {
         if(isRemotePopUp(event.form))
         {
            this.activateRemotePopUp(event.form);
            event.preventDefault();
         }
      }
      
      private function deactivateFormHandler(event:DynamicEvent) : void
      {
         var awm:ActiveWindowManager = ActiveWindowManager(this.systemManager.getImplementation("mx.managers::IActiveWindowManager"));
         if(Boolean(awm.form))
         {
            if(awm.form == event.form && awm.forms.length > 1)
            {
               if(isRemotePopUp(awm.form))
               {
                  this.deactivateRemotePopUp(awm.form);
                  event.preventDefault();
               }
            }
         }
      }
      
      private function deactivatedFormHandler(event:DynamicEvent) : void
      {
         if(isRemotePopUp(event.form))
         {
            this.activateRemotePopUp(event.form);
            event.preventDefault();
         }
      }
      
      private function canActivateFormHandler(request:Request) : void
      {
         var remotePopUp:RemotePopUp = null;
         var event:SWFBridgeRequest = null;
         if(isRemotePopUp(request.value))
         {
            remotePopUp = RemotePopUp(request.value);
            event = new SWFBridgeRequest(SWFBridgeRequest.CAN_ACTIVATE_POP_UP_REQUEST,false,false,null,remotePopUp.window);
            IEventDispatcher(remotePopUp.bridge).dispatchEvent(event);
            request.value = event.data;
            request.preventDefault();
         }
      }
      
      private function findRemotePopUp(window:Object, bridge:IEventDispatcher) : RemotePopUp
      {
         var popUp:RemotePopUp = null;
         var awm:ActiveWindowManager = ActiveWindowManager(this.systemManager.getImplementation("mx.managers::IActiveWindowManager"));
         var n:int = int(awm.forms.length);
         for(var i:int = 0; i < n; i++)
         {
            if(isRemotePopUp(awm.forms[i]))
            {
               popUp = RemotePopUp(awm.forms[i]);
               if(popUp.window == window && popUp.bridge == bridge)
               {
                  return popUp;
               }
            }
         }
         return null;
      }
      
      private function removeRemotePopUp(form:RemotePopUp) : void
      {
         var awm:ActiveWindowManager = ActiveWindowManager(this.systemManager.getImplementation("mx.managers::IActiveWindowManager"));
         var n:int = int(awm.forms.length);
         for(var i:int = 0; i < n; i++)
         {
            if(isRemotePopUp(awm.forms[i]))
            {
               if(awm.forms[i].window == form.window && awm.forms[i].bridge == form.bridge)
               {
                  if(awm.forms[i] == form)
                  {
                     awm.deactivate(IFocusManagerContainer(form));
                  }
                  awm.forms.splice(i,1);
                  break;
               }
            }
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
      
      private function deactivateRemotePopUp(form:Object) : void
      {
         var request:SWFBridgeRequest = new SWFBridgeRequest(SWFBridgeRequest.DEACTIVATE_POP_UP_REQUEST,false,false,form.bridge,form.window);
         var bridge:Object = form.bridge;
         if(Boolean(bridge))
         {
            bridge.dispatchEvent(request);
         }
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
      
      public function addFocusManager(f:IFocusManagerContainer) : void
      {
         var awm:ActiveWindowManager = ActiveWindowManager(this.systemManager.getImplementation("mx.managers::IActiveWindowManager"));
         awm.forms.push(f);
      }
      
      public function removeFocusManagerHandler(event:FocusEvent) : void
      {
         this.dispatchDeactivatedWindowEvent(DisplayObject(event.relatedObject));
      }
      
      private function dispatchInvalidateRequest() : void
      {
         var bridge:IEventDispatcher = this.swfBridgeGroup.parentBridge;
         var request:SWFBridgeRequest = new SWFBridgeRequest(SWFBridgeRequest.INVALIDATE_REQUEST,false,false,bridge,InvalidateRequestData.SIZE | InvalidateRequestData.DISPLAY_LIST);
         bridge.dispatchEvent(request);
      }
      
      private function mouseDownHandler(event:FocusEvent) : void
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
         var awm:ActiveWindowManager = ActiveWindowManager(this.systemManager.getImplementation("mx.managers::IActiveWindowManager"));
         event.preventDefault();
         var bridge:IEventDispatcher = this.getSWFBridgeOfDisplayObject(event.relatedObject as DisplayObject);
         if(Boolean(bridge) && this.bridgeToFocusManager[bridge] == this.systemManager.document.focusManager)
         {
            if(this.systemManager.isTopLevelRoot())
            {
               awm.activate(IFocusManagerContainer(this.systemManager.document));
            }
            else
            {
               this.dispatchActivatedApplicationEvent();
            }
            return;
         }
         if(awm.numModalWindows == 0)
         {
            if(!this.systemManager.isTopLevelRoot() || awm.forms.length > 1)
            {
               n = int(awm.forms.length);
               p = DisplayObject(event.relatedObject);
               isApplication = this.systemManager.document is IRawChildrenContainer ? IRawChildrenContainer(this.systemManager.document).rawChildren.contains(p) : Boolean(this.systemManager.document.contains(p));
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
                     form_i = isRemotePopUp(awm.forms[i]) ? awm.forms[i].window : awm.forms[i];
                     if(form_i == p)
                     {
                        break;
                     }
                     i++;
                  }
                  j = 0;
                  if(p != awm.form && p is IFocusManagerContainer || !this.systemManager.isTopLevelRoot() && p == awm.form)
                  {
                     if(this.systemManager.isTopLevelRoot())
                     {
                        awm.activate(IFocusManagerContainer(p));
                     }
                     if(p == this.systemManager.document)
                     {
                        this.dispatchActivatedApplicationEvent();
                     }
                     else if(p is DisplayObject)
                     {
                        this.dispatchActivatedWindowEvent(DisplayObject(p));
                     }
                  }
                  if(this.systemManager.popUpChildren.contains(p))
                  {
                     childList = this.systemManager.popUpChildren;
                  }
                  else
                  {
                     childList = this.systemManager;
                  }
                  index = childList.getChildIndex(p);
                  newIndex = index;
                  n = int(awm.forms.length);
                  for(j = 0; j < n; j++)
                  {
                     isRemotePopUp = isRemotePopUp(awm.forms[j]);
                     if(isRemotePopUp)
                     {
                        if(awm.forms[j].window is String)
                        {
                           continue;
                        }
                        f = awm.forms[j].window;
                     }
                     else
                     {
                        f = awm.forms[j];
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
            else
            {
               this.dispatchActivatedApplicationEvent();
            }
         }
      }
      
      private function beforeUnloadHandler(event:Event) : void
      {
         var sandboxRoot:DisplayObject = null;
         if(this.systemManager.isTopLevel() && Boolean(this.systemManager.stage))
         {
            sandboxRoot = this.systemManager.getSandboxRoot();
            if(sandboxRoot != DisplayObject(this.systemManager))
            {
               sandboxRoot.removeEventListener(Event.RESIZE,this.Stage_resizeHandler);
            }
         }
         this.removeParentBridgeListeners();
         this.systemManager.dispatchEvent(event);
      }
      
      private function addPopupRequestHandler(event:Event) : void
      {
         var topMost:Boolean = false;
         var children:IChildList = null;
         var bridgeProvider:ISWFBridgeProvider = null;
         var request:SWFBridgeRequest = null;
         if(event.target != this.systemManager && event is SWFBridgeRequest)
         {
            return;
         }
         var awm:ActiveWindowManager = ActiveWindowManager(this.systemManager.getImplementation("mx.managers::IActiveWindowManager"));
         var popUpRequest:SWFBridgeRequest = SWFBridgeRequest.marshal(event);
         if(event.target != this.systemManager)
         {
            bridgeProvider = this.swfBridgeGroup.getChildBridgeProvider(IEventDispatcher(event.target));
            if(!SecurityUtil.hasMutualTrustBetweenParentAndChild(bridgeProvider))
            {
               return;
            }
         }
         if(Boolean(this.swfBridgeGroup.parentBridge) && SecurityUtil.hasMutualTrustBetweenParentAndChild(this))
         {
            popUpRequest.requestor = this.swfBridgeGroup.parentBridge;
            this.systemManager.getSandboxRoot().dispatchEvent(popUpRequest);
            return;
         }
         if(!popUpRequest.data.childList || popUpRequest.data.childList == PopUpManagerChildList.PARENT)
         {
            topMost = Boolean(popUpRequest.data.parent) && this.systemManager.popUpChildren.contains(popUpRequest.data.parent);
         }
         else
         {
            topMost = popUpRequest.data.childList == PopUpManagerChildList.POPUP;
         }
         children = topMost ? this.systemManager.popUpChildren : this.systemManager;
         children.addChild(DisplayObject(popUpRequest.data.window));
         if(Boolean(popUpRequest.data.modal))
         {
            ++awm.numModalWindows;
         }
         var remoteForm:RemotePopUp = new RemotePopUp(popUpRequest.data.window,popUpRequest.requestor);
         awm.forms.push(remoteForm);
         if(!this.systemManager.isTopLevelRoot() && Boolean(this.swfBridgeGroup))
         {
            request = new SWFBridgeRequest(SWFBridgeRequest.ADD_POP_UP_PLACE_HOLDER_REQUEST,false,false,popUpRequest.requestor,{"window":popUpRequest.data.window});
            request.data.placeHolderId = NameUtil.displayObjectToString(DisplayObject(popUpRequest.data.window));
            this.systemManager.dispatchEvent(request);
         }
      }
      
      private function removePopupRequestHandler(event:Event) : void
      {
         var request:SWFBridgeRequest = null;
         var awm:ActiveWindowManager = ActiveWindowManager(this.systemManager.getImplementation("mx.managers::IActiveWindowManager"));
         var popUpRequest:SWFBridgeRequest = SWFBridgeRequest.marshal(event);
         if(Boolean(this.swfBridgeGroup.parentBridge) && SecurityUtil.hasMutualTrustBetweenParentAndChild(this))
         {
            popUpRequest.requestor = this.swfBridgeGroup.parentBridge;
            this.systemManager.getSandboxRoot().dispatchEvent(popUpRequest);
            return;
         }
         if(this.systemManager.popUpChildren.contains(popUpRequest.data.window))
         {
            this.systemManager.popUpChildren.removeChild(popUpRequest.data.window);
         }
         else
         {
            this.systemManager.removeChild(DisplayObject(popUpRequest.data.window));
         }
         if(Boolean(popUpRequest.data.modal))
         {
            --awm.numModalWindows;
         }
         this.removeRemotePopUp(new RemotePopUp(popUpRequest.data.window,popUpRequest.requestor));
         if(!this.systemManager.isTopLevelRoot() && Boolean(this.swfBridgeGroup))
         {
            request = new SWFBridgeRequest(SWFBridgeRequest.REMOVE_POP_UP_PLACE_HOLDER_REQUEST,false,false,popUpRequest.requestor,{"placeHolderId":NameUtil.displayObjectToString(popUpRequest.data.window)});
            this.systemManager.dispatchEvent(request);
         }
      }
      
      private function addPlaceholderPopupRequestHandler(event:Event) : void
      {
         var remoteForm:RemotePopUp = null;
         var popUpRequest:SWFBridgeRequest = SWFBridgeRequest.marshal(event);
         var awm:ActiveWindowManager = ActiveWindowManager(this.systemManager.getImplementation("mx.managers::IActiveWindowManager"));
         if(event.target != this.systemManager && event is SWFBridgeRequest)
         {
            return;
         }
         if(!this.forwardPlaceholderRequest(popUpRequest,true))
         {
            remoteForm = new RemotePopUp(popUpRequest.data.placeHolderId,popUpRequest.requestor);
            awm.forms.push(remoteForm);
         }
      }
      
      private function removePlaceholderPopupRequestHandler(event:Event) : void
      {
         var n:int = 0;
         var i:int = 0;
         var popUpRequest:SWFBridgeRequest = SWFBridgeRequest.marshal(event);
         var awm:ActiveWindowManager = ActiveWindowManager(this.systemManager.getImplementation("mx.managers::IActiveWindowManager"));
         if(!this.forwardPlaceholderRequest(popUpRequest,false))
         {
            n = int(awm.forms.length);
            for(i = 0; i < n; i++)
            {
               if(isRemotePopUp(awm.forms[i]))
               {
                  if(awm.forms[i].window == popUpRequest.data.placeHolderId && awm.forms[i].bridge == popUpRequest.requestor)
                  {
                     awm.forms.splice(i,1);
                     break;
                  }
               }
            }
         }
      }
      
      private function forwardFormEvent(event:SWFBridgeEvent) : Boolean
      {
         var sbRoot:DisplayObject = null;
         if(this.systemManager.isTopLevelRoot())
         {
            return false;
         }
         var bridge:IEventDispatcher = this.swfBridgeGroup.parentBridge;
         if(Boolean(bridge))
         {
            sbRoot = this.systemManager.getSandboxRoot();
            event.data.notifier = bridge;
            if(sbRoot == this.systemManager)
            {
               if(!(event.data.window is String))
               {
                  event.data.window = NameUtil.displayObjectToString(DisplayObject(event.data.window));
               }
               else
               {
                  event.data.window = NameUtil.displayObjectToString(DisplayObject(this.systemManager)) + "." + event.data.window;
               }
               bridge.dispatchEvent(event);
            }
            else
            {
               if(event.data.window is String)
               {
                  event.data.window = NameUtil.displayObjectToString(DisplayObject(this.systemManager)) + "." + event.data.window;
               }
               sbRoot.dispatchEvent(event);
            }
         }
         return true;
      }
      
      private function forwardPlaceholderRequest(request:SWFBridgeRequest, addPlaceholder:Boolean) : Boolean
      {
         if(this.systemManager.isTopLevelRoot())
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
            request.data.placeHolderId = NameUtil.displayObjectToString(DisplayObject(this.systemManager)) + "." + request.data.placeHolderId;
         }
         if(addPlaceholder)
         {
            this.addPlaceholderId(request.data.placeHolderId,oldId,request.requestor,refObj);
         }
         else
         {
            this.removePlaceholderId(request.data.placeHolderId);
         }
         var sbRoot:DisplayObject = this.systemManager.getSandboxRoot();
         var bridge:IEventDispatcher = this.swfBridgeGroup.parentBridge;
         request.requestor = bridge;
         if(sbRoot == this.systemManager)
         {
            bridge.dispatchEvent(request);
         }
         else
         {
            sbRoot.dispatchEvent(request);
         }
         return true;
      }
      
      private function deactivateFormSandboxEventHandler(event:Event) : void
      {
         var awm:ActiveWindowManager = ActiveWindowManager(this.systemManager.getImplementation("mx.managers::IActiveWindowManager"));
         if(event is SWFBridgeRequest)
         {
            return;
         }
         var bridgeEvent:SWFBridgeEvent = SWFBridgeEvent.marshal(event);
         if(!this.forwardFormEvent(bridgeEvent))
         {
            if(isRemotePopUp(awm.form) && RemotePopUp(awm.form).window == bridgeEvent.data.window && RemotePopUp(awm.form).bridge == bridgeEvent.data.notifier)
            {
               awm.deactivate(awm.form);
            }
         }
      }
      
      private function activateFormSandboxEventHandler(event:Event) : void
      {
         var awm:ActiveWindowManager = ActiveWindowManager(this.systemManager.getImplementation("mx.managers::IActiveWindowManager"));
         var bridgeEvent:SWFBridgeEvent = SWFBridgeEvent.marshal(event);
         if(!this.forwardFormEvent(bridgeEvent))
         {
            awm.activate(new RemotePopUp(bridgeEvent.data.window,bridgeEvent.data.notifier));
         }
      }
      
      private function activateApplicationSandboxEventHandler(event:Event) : void
      {
         var awm:ActiveWindowManager = ActiveWindowManager(this.systemManager.getImplementation("mx.managers::IActiveWindowManager"));
         if(!this.systemManager.isTopLevelRoot())
         {
            this.swfBridgeGroup.parentBridge.dispatchEvent(event);
            return;
         }
         awm.activate(IFocusManagerContainer(this.systemManager.document));
      }
      
      private function modalWindowRequestHandler(event:Event) : void
      {
         if(event is SWFBridgeRequest)
         {
            return;
         }
         var request:SWFBridgeRequest = SWFBridgeRequest.marshal(event);
         if(!this.preProcessModalWindowRequest(request,this.systemManager.getSandboxRoot()))
         {
            return;
         }
         Singleton.getInstance("mx.managers::IPopUpManager");
         this.systemManager.dispatchEvent(request);
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
         var owner:DisplayObject = DisplayObject(this.swfBridgeGroup.getChildBridgeProvider(request.requestor));
         var forwardRequest:Boolean = true;
         if(!DisplayObjectContainer(this.systemManager.document).contains(owner))
         {
            forwardRequest = false;
         }
         if(owner is ISWFLoader)
         {
            localRect = ISWFLoader(owner).getVisibleApplicationRect();
         }
         else
         {
            localRect = owner.getBounds(DisplayObject(this.systemManager));
            pt = DisplayObject(this.systemManager).localToGlobal(localRect.topLeft);
            localRect.x = pt.x;
            localRect.y = pt.y;
         }
         rect = rect.intersection(localRect);
         request.data = rect;
         if(forwardRequest && this.useSWFBridge())
         {
            bridge = this.swfBridgeGroup.parentBridge;
            request.requestor = bridge;
            bridge.dispatchEvent(request);
         }
         Object(event).data = request.data;
      }
      
      private function hideMouseCursorRequestHandler(event:Event) : void
      {
         var bridge:IEventDispatcher = null;
         if(!this.systemManager.isTopLevelRoot() && event is SWFBridgeRequest)
         {
            return;
         }
         var request:SWFBridgeRequest = SWFBridgeRequest.marshal(event);
         if(!this.systemManager.isTopLevelRoot())
         {
            bridge = this.swfBridgeGroup.parentBridge;
            request.requestor = bridge;
            bridge.dispatchEvent(request);
         }
         else if(Boolean(this.eventProxy))
         {
            SystemManagerGlobals.showMouseCursor = false;
         }
      }
      
      private function showMouseCursorRequestHandler(event:Event) : void
      {
         var bridge:IEventDispatcher = null;
         if(!this.systemManager.isTopLevelRoot() && event is SWFBridgeRequest)
         {
            return;
         }
         var request:SWFBridgeRequest = SWFBridgeRequest.marshal(event);
         if(!this.systemManager.isTopLevelRoot())
         {
            bridge = this.swfBridgeGroup.parentBridge;
            request.requestor = bridge;
            bridge.dispatchEvent(request);
            Object(event).data = request.data;
         }
         else if(Boolean(this.eventProxy))
         {
            Object(event).data = SystemManagerGlobals.showMouseCursor;
         }
      }
      
      private function resetMouseCursorRequestHandler(event:Event) : void
      {
         var bridge:IEventDispatcher = null;
         if(!this.systemManager.isTopLevelRoot() && event is SWFBridgeRequest)
         {
            return;
         }
         var request:SWFBridgeRequest = SWFBridgeRequest.marshal(event);
         if(!this.systemManager.isTopLevelRoot())
         {
            bridge = this.swfBridgeGroup.parentBridge;
            request.requestor = bridge;
            bridge.dispatchEvent(request);
         }
         else if(Boolean(this.eventProxy))
         {
            SystemManagerGlobals.showMouseCursor = true;
         }
      }
      
      private function resetMouseCursorTracking(event:Event) : void
      {
         var cursorRequest:SWFBridgeRequest = null;
         var bridge:IEventDispatcher = null;
         if(this.systemManager.isTopLevelRoot())
         {
            SystemManagerGlobals.showMouseCursor = true;
         }
         else if(Boolean(this.swfBridgeGroup.parentBridge))
         {
            cursorRequest = new SWFBridgeRequest(SWFBridgeRequest.RESET_MOUSE_CURSOR_REQUEST);
            bridge = this.swfBridgeGroup.parentBridge;
            cursorRequest.requestor = bridge;
            bridge.dispatchEvent(cursorRequest);
         }
      }
      
      private function setActualSizeRequestHandler(event:Event) : void
      {
         var eObj:Object = Object(event);
         IFlexDisplayObject(this.systemManager).setActualSize(eObj.data.width,eObj.data.height);
      }
      
      private function getSizeRequestHandler(event:Event) : void
      {
         var eObj:Object = Object(event);
         eObj.data = {
            "width":IFlexDisplayObject(this.systemManager).measuredWidth,
            "height":IFlexDisplayObject(this.systemManager).measuredHeight
         };
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
            placeholder = this.idToPlaceholder[request.data];
            child = placeholder.data;
            nextId = placeholder.id;
            if(nextId == null)
            {
               popUp = this.findRemotePopUp(child,placeholder.bridge);
               if(Boolean(popUp))
               {
                  this.activateRemotePopUp(popUp);
                  return;
               }
            }
         }
         if(child is SystemManagerProxy)
         {
            smp = SystemManagerProxy(child);
            f = this.findFocusManagerContainer(smp);
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
            placeholder = this.idToPlaceholder[request.data];
            child = placeholder.data;
            nextId = placeholder.id;
            if(nextId == null)
            {
               popUp = this.findRemotePopUp(child,placeholder.bridge);
               if(Boolean(popUp))
               {
                  this.deactivateRemotePopUp(popUp);
                  return;
               }
            }
         }
         if(child is SystemManagerProxy)
         {
            smp = SystemManagerProxy(child);
            f = this.findFocusManagerContainer(smp);
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
      
      private function isBridgeChildHandler(event:Event) : void
      {
         if(event is SWFBridgeRequest)
         {
            return;
         }
         var eObj:Object = Object(event);
         eObj.data = eObj.data && this.systemManager.rawChildren.contains(eObj.data as DisplayObject);
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
            placeholder = this.idToPlaceholder[eObj.data];
            child = placeholder.data;
            nextId = placeholder.id;
            if(nextId == null)
            {
               popUp = this.findRemotePopUp(child,placeholder.bridge);
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
            f = this.findFocusManagerContainer(smp);
            eObj.data = smp && f && this.canActivateLocalComponent(f);
         }
         else if(child is IFocusManagerContainer)
         {
            eObj.data = this.canActivateLocalComponent(child);
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
      
      private function canActivateLocalComponent(o:Object) : Boolean
      {
         if(o is Sprite && o is IUIComponent && Sprite(o).visible && IUIComponent(o).enabled)
         {
            return true;
         }
         return false;
      }
      
      public function isDisplayObjectInABridgedApplication(displayObject:DisplayObject) : Boolean
      {
         return this.getSWFBridgeOfDisplayObject(displayObject) != null;
      }
      
      private function getSWFBridgeOfDisplayObject(displayObject:DisplayObject) : IEventDispatcher
      {
         var request:SWFBridgeRequest = null;
         var children:Array = null;
         var n:int = 0;
         var i:int = 0;
         var childBridge:IEventDispatcher = null;
         var bp:ISWFBridgeProvider = null;
         if(Boolean(this.swfBridgeGroup))
         {
            request = new SWFBridgeRequest(SWFBridgeRequest.IS_BRIDGE_CHILD_REQUEST,false,false,null,displayObject);
            children = this.swfBridgeGroup.getChildBridges();
            n = int(children.length);
            for(i = 0; i < n; i++)
            {
               childBridge = IEventDispatcher(children[i]);
               bp = this.swfBridgeGroup.getChildBridgeProvider(childBridge);
               if(SecurityUtil.hasMutualTrustBetweenParentAndChild(bp))
               {
                  childBridge.dispatchEvent(request);
                  if(request.data == true)
                  {
                     return childBridge;
                  }
                  request.data = displayObject;
               }
            }
         }
         return null;
      }
      
      private function multiWindowRedispatcher(event:Event) : void
      {
         if(!SystemManagerGlobals.dispatchingEventToOtherSystemManagers)
         {
            this.dispatchEventToOtherSystemManagers(event);
         }
      }
      
      private function initManagerHandler(event:Event) : void
      {
         if(!SystemManagerGlobals.dispatchingEventToOtherSystemManagers)
         {
            this.dispatchEventToOtherSystemManagers(event);
         }
         if(event is InterManagerRequest)
         {
            return;
         }
         var name:String = event["name"];
         try
         {
            Singleton.getInstance(name);
         }
         catch(e:Error)
         {
         }
      }
      
      public function addChildToSandboxRoot(layer:String, child:DisplayObject) : void
      {
         var me:InterManagerRequest = null;
         if(this.systemManager.getSandboxRoot() == this.systemManager)
         {
            this.systemManager[layer].addChild(child);
         }
         else
         {
            this.childManager.addingChild(child);
            me = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST);
            me.name = layer + ".addChild";
            me.value = child;
            this.systemManager.getSandboxRoot().dispatchEvent(me);
            this.childManager.childAdded(child);
         }
      }
      
      public function removeChildFromSandboxRoot(layer:String, child:DisplayObject) : void
      {
         var me:InterManagerRequest = null;
         if(this.systemManager.getSandboxRoot() == this.systemManager)
         {
            this.systemManager[layer].removeChild(child);
         }
         else
         {
            this.childManager.removingChild(child);
            me = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST);
            me.name = layer + ".removeChild";
            me.value = child;
            this.systemManager.getSandboxRoot().dispatchEvent(me);
            this.childManager.childRemoved(child);
         }
      }
      
      private function systemManagerHandler(event:Event) : void
      {
         if(event["name"] == "sameSandbox")
         {
            event["value"] = this.currentSandboxEvent == event["value"];
            return;
         }
         if(event["name"] == "hasSWFBridges")
         {
            event["value"] = this.hasSWFBridges();
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
               this.systemManager.popUpChildren.addChild(event["value"]);
               break;
            case "popUpChildren.removeChild":
               this.systemManager.popUpChildren.removeChild(event["value"]);
               break;
            case "cursorChildren.addChild":
               this.systemManager.cursorChildren.addChild(event["value"]);
               break;
            case "cursorChildren.removeChild":
               this.systemManager.cursorChildren.removeChild(event["value"]);
               break;
            case "toolTipChildren.addChild":
               this.systemManager.toolTipChildren.addChild(event["value"]);
               break;
            case "toolTipChildren.removeChild":
               this.systemManager.toolTipChildren.removeChild(event["value"]);
               break;
            case "screen":
               event["value"] = this.systemManager.screen;
               break;
            case "application":
               event["value"] = this.systemManager.document;
               break;
            case "isTopLevelRoot":
               event["value"] = this.systemManager.isTopLevelRoot();
               break;
            case "getVisibleApplicationRect":
               event["value"] = this.getVisibleApplicationRect();
               break;
            case "bringToFront":
               if(Boolean(event["value"].topMost))
               {
                  this.systemManager.popUpChildren.setChildIndex(DisplayObject(event["value"].popUp),this.systemManager.popUpChildren.numChildren - 1);
               }
               else
               {
                  this.systemManager.setChildIndex(DisplayObject(event["value"].popUp),this.systemManager.numChildren - 1);
               }
         }
      }
      
      private function getSandboxScreen() : Rectangle
      {
         var sandboxScreen:Rectangle = null;
         var sm:DisplayObject = null;
         var me:InterManagerRequest = null;
         var sandboxRoot:DisplayObject = this.systemManager.getSandboxRoot();
         if(sandboxRoot == this.systemManager)
         {
            sandboxScreen = new Rectangle(0,0,IFlexDisplayObject(this.systemManager).width,IFlexDisplayObject(this.systemManager).height);
         }
         else if(sandboxRoot == this.systemManager.topLevelSystemManager)
         {
            sm = DisplayObject(this.systemManager.topLevelSystemManager);
            sandboxScreen = new Rectangle(0,0,sm.width,sm.height);
         }
         else
         {
            me = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST,false,false,"screen");
            sandboxRoot.dispatchEvent(me);
            sandboxScreen = Rectangle(me.value);
         }
         return sandboxScreen;
      }
      
      mx_internal function findFocusManagerContainer(smp:SystemManagerProxy) : IFocusManagerContainer
      {
         var child:DisplayObject = null;
         var children:IChildList = smp.rawChildren;
         var numChildren:int = children.numChildren;
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
      
      mx_internal function addChildBridgeListeners(bridge:IEventDispatcher) : void
      {
         var mp:MarshallingSupport = null;
         if(!this.systemManager.isTopLevel() && Boolean(this.systemManager.topLevelSystemManager))
         {
            mp = MarshallingSupport(this.systemManager.topLevelSystemManager.getImplementation("mx.managers::IMarshalSystemManager"));
            mp.addChildBridgeListeners(bridge);
            return;
         }
         bridge.addEventListener(SWFBridgeRequest.ADD_POP_UP_REQUEST,this.addPopupRequestHandler);
         bridge.addEventListener(SWFBridgeRequest.REMOVE_POP_UP_REQUEST,this.removePopupRequestHandler);
         bridge.addEventListener(SWFBridgeRequest.ADD_POP_UP_PLACE_HOLDER_REQUEST,this.addPlaceholderPopupRequestHandler);
         bridge.addEventListener(SWFBridgeRequest.REMOVE_POP_UP_PLACE_HOLDER_REQUEST,this.removePlaceholderPopupRequestHandler);
         bridge.addEventListener(SWFBridgeEvent.BRIDGE_WINDOW_ACTIVATE,this.activateFormSandboxEventHandler);
         bridge.addEventListener(SWFBridgeEvent.BRIDGE_WINDOW_DEACTIVATE,this.deactivateFormSandboxEventHandler);
         bridge.addEventListener(SWFBridgeEvent.BRIDGE_APPLICATION_ACTIVATE,this.activateApplicationSandboxEventHandler);
         bridge.addEventListener(EventListenerRequest.ADD_EVENT_LISTENER_REQUEST,this.eventListenerRequestHandler,false,0,true);
         bridge.addEventListener(EventListenerRequest.REMOVE_EVENT_LISTENER_REQUEST,this.eventListenerRequestHandler,false,0,true);
         bridge.addEventListener(SWFBridgeRequest.CREATE_MODAL_WINDOW_REQUEST,this.modalWindowRequestHandler);
         bridge.addEventListener(SWFBridgeRequest.SHOW_MODAL_WINDOW_REQUEST,this.modalWindowRequestHandler);
         bridge.addEventListener(SWFBridgeRequest.HIDE_MODAL_WINDOW_REQUEST,this.modalWindowRequestHandler);
         bridge.addEventListener(SWFBridgeRequest.GET_VISIBLE_RECT_REQUEST,this.getVisibleRectRequestHandler);
         bridge.addEventListener(SWFBridgeRequest.HIDE_MOUSE_CURSOR_REQUEST,this.hideMouseCursorRequestHandler);
         bridge.addEventListener(SWFBridgeRequest.SHOW_MOUSE_CURSOR_REQUEST,this.showMouseCursorRequestHandler);
         bridge.addEventListener(SWFBridgeRequest.RESET_MOUSE_CURSOR_REQUEST,this.resetMouseCursorRequestHandler);
      }
      
      mx_internal function removeChildBridgeListeners(bridge:IEventDispatcher) : void
      {
         var mp:MarshallingSupport = null;
         if(!this.systemManager.isTopLevel() && Boolean(this.systemManager.topLevelSystemManager))
         {
            mp = MarshallingSupport(this.systemManager.topLevelSystemManager.getImplementation("mx.managers::IMarshalSystemManager"));
            mp.removeChildBridgeListeners(bridge);
            return;
         }
         bridge.removeEventListener(SWFBridgeRequest.ADD_POP_UP_REQUEST,this.addPopupRequestHandler);
         bridge.removeEventListener(SWFBridgeRequest.REMOVE_POP_UP_REQUEST,this.removePopupRequestHandler);
         bridge.removeEventListener(SWFBridgeRequest.ADD_POP_UP_PLACE_HOLDER_REQUEST,this.addPlaceholderPopupRequestHandler);
         bridge.removeEventListener(SWFBridgeRequest.REMOVE_POP_UP_PLACE_HOLDER_REQUEST,this.removePlaceholderPopupRequestHandler);
         bridge.removeEventListener(SWFBridgeEvent.BRIDGE_WINDOW_ACTIVATE,this.activateFormSandboxEventHandler);
         bridge.removeEventListener(SWFBridgeEvent.BRIDGE_WINDOW_DEACTIVATE,this.deactivateFormSandboxEventHandler);
         bridge.removeEventListener(SWFBridgeEvent.BRIDGE_APPLICATION_ACTIVATE,this.activateApplicationSandboxEventHandler);
         bridge.removeEventListener(EventListenerRequest.ADD_EVENT_LISTENER_REQUEST,this.eventListenerRequestHandler);
         bridge.removeEventListener(EventListenerRequest.REMOVE_EVENT_LISTENER_REQUEST,this.eventListenerRequestHandler);
         bridge.removeEventListener(SWFBridgeRequest.CREATE_MODAL_WINDOW_REQUEST,this.modalWindowRequestHandler);
         bridge.removeEventListener(SWFBridgeRequest.SHOW_MODAL_WINDOW_REQUEST,this.modalWindowRequestHandler);
         bridge.removeEventListener(SWFBridgeRequest.HIDE_MODAL_WINDOW_REQUEST,this.modalWindowRequestHandler);
         bridge.removeEventListener(SWFBridgeRequest.GET_VISIBLE_RECT_REQUEST,this.getVisibleRectRequestHandler);
         bridge.removeEventListener(SWFBridgeRequest.HIDE_MOUSE_CURSOR_REQUEST,this.hideMouseCursorRequestHandler);
         bridge.removeEventListener(SWFBridgeRequest.SHOW_MOUSE_CURSOR_REQUEST,this.showMouseCursorRequestHandler);
         bridge.removeEventListener(SWFBridgeRequest.RESET_MOUSE_CURSOR_REQUEST,this.resetMouseCursorRequestHandler);
      }
      
      mx_internal function addParentBridgeListeners() : void
      {
         var mp:MarshallingSupport = null;
         if(!this.systemManager.isTopLevel() && Boolean(this.systemManager.topLevelSystemManager))
         {
            mp = MarshallingSupport(this.systemManager.topLevelSystemManager.getImplementation("mx.managers::IMarshalSystemManager"));
            mp.addParentBridgeListeners();
            return;
         }
         var bridge:IEventDispatcher = this.swfBridgeGroup.parentBridge;
         bridge.addEventListener(SWFBridgeRequest.SET_ACTUAL_SIZE_REQUEST,this.setActualSizeRequestHandler);
         bridge.addEventListener(SWFBridgeRequest.GET_SIZE_REQUEST,this.getSizeRequestHandler);
         bridge.addEventListener(SWFBridgeRequest.ACTIVATE_POP_UP_REQUEST,this.activateRequestHandler);
         bridge.addEventListener(SWFBridgeRequest.DEACTIVATE_POP_UP_REQUEST,this.deactivateRequestHandler);
         bridge.addEventListener(SWFBridgeRequest.IS_BRIDGE_CHILD_REQUEST,this.isBridgeChildHandler);
         bridge.addEventListener(EventListenerRequest.ADD_EVENT_LISTENER_REQUEST,this.eventListenerRequestHandler);
         bridge.addEventListener(EventListenerRequest.REMOVE_EVENT_LISTENER_REQUEST,this.eventListenerRequestHandler);
         bridge.addEventListener(SWFBridgeRequest.CAN_ACTIVATE_POP_UP_REQUEST,this.canActivateHandler);
         bridge.addEventListener(SWFBridgeEvent.BRIDGE_APPLICATION_UNLOADING,this.beforeUnloadHandler);
      }
      
      mx_internal function removeParentBridgeListeners() : void
      {
         var mp:MarshallingSupport = null;
         if(!this.systemManager.isTopLevel() && Boolean(this.systemManager.topLevelSystemManager))
         {
            mp = MarshallingSupport(this.systemManager.topLevelSystemManager.getImplementation("mx.managers::IMarshalSystemManager"));
            mp.removeParentBridgeListeners();
            return;
         }
         var bridge:IEventDispatcher = this.swfBridgeGroup.parentBridge;
         bridge.removeEventListener(SWFBridgeRequest.SET_ACTUAL_SIZE_REQUEST,this.setActualSizeRequestHandler);
         bridge.removeEventListener(SWFBridgeRequest.GET_SIZE_REQUEST,this.getSizeRequestHandler);
         bridge.removeEventListener(SWFBridgeRequest.ACTIVATE_POP_UP_REQUEST,this.activateRequestHandler);
         bridge.removeEventListener(SWFBridgeRequest.DEACTIVATE_POP_UP_REQUEST,this.deactivateRequestHandler);
         bridge.removeEventListener(SWFBridgeRequest.IS_BRIDGE_CHILD_REQUEST,this.isBridgeChildHandler);
         bridge.removeEventListener(EventListenerRequest.ADD_EVENT_LISTENER_REQUEST,this.eventListenerRequestHandler);
         bridge.removeEventListener(EventListenerRequest.REMOVE_EVENT_LISTENER_REQUEST,this.eventListenerRequestHandler);
         bridge.removeEventListener(SWFBridgeRequest.CAN_ACTIVATE_POP_UP_REQUEST,this.canActivateHandler);
         bridge.removeEventListener(SWFBridgeEvent.BRIDGE_APPLICATION_UNLOADING,this.beforeUnloadHandler);
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
         if(!this.swfBridgeGroup)
         {
            this.swfBridgeGroup = new SWFBridgeGroup(this.systemManager);
         }
         var event:DynamicEvent = new DynamicEvent("addChildBridge");
         event.bridge = bridge;
         event.owner = owner;
         fm.dispatchEvent(event);
         this.swfBridgeGroup.addChildBridge(bridge,ISWFBridgeProvider(owner));
         if(!this.bridgeToFocusManager)
         {
            this.bridgeToFocusManager = new Dictionary();
         }
         this.bridgeToFocusManager[bridge] = fm;
         this.addChildBridgeListeners(bridge);
         this.systemManager.dispatchEvent(new FlexChangeEvent(FlexChangeEvent.ADD_CHILD_BRIDGE,false,false,bridge));
      }
      
      public function removeChildBridge(bridge:IEventDispatcher) : void
      {
         this.systemManager.dispatchEvent(new FlexChangeEvent(FlexChangeEvent.REMOVE_CHILD_BRIDGE,false,false,bridge));
         var fm:IFocusManager = IFocusManager(this.bridgeToFocusManager[bridge]);
         var event:DynamicEvent = new DynamicEvent("removeChildBridge");
         event.bridge = bridge;
         fm.dispatchEvent(event);
         this.swfBridgeGroup.removeChildBridge(bridge);
         delete this.bridgeToFocusManager[bridge];
         this.removeChildBridgeListeners(bridge);
      }
      
      public function useSWFBridge() : Boolean
      {
         var sbRoot:DisplayObject;
         var mp:IMarshalSystemManager = null;
         if(this.systemManager.isTopLevelRoot())
         {
            return false;
         }
         if(!this.systemManager.isTopLevel() && Boolean(this.systemManager.topLevelSystemManager))
         {
            mp = IMarshalSystemManager(this.systemManager.topLevelSystemManager.getImplementation("mx.managers::IMarshalSystemManager"));
            return mp.useSWFBridge();
         }
         sbRoot = this.systemManager.getSandboxRoot();
         if(this.systemManager.isTopLevel() && sbRoot != this.systemManager)
         {
            return true;
         }
         if(sbRoot == this.systemManager)
         {
            try
            {
               if(!(this.parentAllowsChild && this.childAllowsParent))
               {
                  return true;
               }
               try
               {
                  if(!DisplayObject(this.systemManager).parent.dispatchEvent(new Event("mx.managers.SystemManager.isStageRoot",false,true)))
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
      
      public function getVisibleApplicationRectHandler(event:Request) : void
      {
         var screen:Rectangle = null;
         var request:InterManagerRequest = null;
         var skipToSandboxRoot:Boolean = Boolean(event.value.skipToSandboxRoot);
         var sbRoot:DisplayObject = this.systemManager.getSandboxRoot();
         if(skipToSandboxRoot && this.systemManager != sbRoot)
         {
            request = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST,false,false,"getVisibleApplicationRect");
            if(!sbRoot.dispatchEvent(request))
            {
               event.value = Rectangle(request.value);
               event.preventDefault();
            }
         }
         else
         {
            event.value = this.getVisibleApplicationRect(event.value.bounds as Rectangle);
            event.preventDefault();
         }
      }
      
      public function getVisibleApplicationRect(bounds:Rectangle = null) : Rectangle
      {
         var s:Rectangle = null;
         var pt:Point = null;
         var bridge:IEventDispatcher = null;
         var bridgeRequest:SWFBridgeRequest = null;
         var obj:DisplayObjectContainer = null;
         var visibleRect:Rectangle = null;
         if(!bounds)
         {
            bounds = DisplayObject(this.systemManager).getBounds(DisplayObject(this.systemManager));
            s = this.systemManager.screen;
            pt = new Point(Math.max(0,bounds.x),Math.max(0,bounds.y));
            pt = DisplayObject(this.systemManager).localToGlobal(pt);
            bounds.x = pt.x;
            bounds.y = pt.y;
            bounds.width = s.width;
            bounds.height = s.height;
         }
         if(this.useSWFBridge())
         {
            bridge = this.swfBridgeGroup.parentBridge;
            bridgeRequest = new SWFBridgeRequest(SWFBridgeRequest.GET_VISIBLE_RECT_REQUEST,false,false,bridge,bounds);
            bridge.dispatchEvent(bridgeRequest);
            bounds = Rectangle(bridgeRequest.data);
         }
         else if(!this.systemManager.isTopLevel())
         {
            obj = DisplayObject(this.systemManager).parent.parent;
            if("getVisibleApplicationRect" in obj)
            {
               visibleRect = obj["getVisibleApplicationRect"](true);
               bounds = bounds.intersection(visibleRect);
            }
         }
         return bounds;
      }
      
      public function deployMouseShieldsHandler(event:DynamicEvent) : void
      {
         var me:InterManagerRequest = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST,false,false,"mouseShield",event.deploy);
         this.systemManager.getSandboxRoot().dispatchEvent(me);
      }
      
      public function dispatchActivatedWindowEvent(window:DisplayObject) : void
      {
         var sbRoot:DisplayObject = null;
         var sendToSbRoot:Boolean = false;
         var bridgeEvent:SWFBridgeEvent = null;
         var bridge:IEventDispatcher = Boolean(this.swfBridgeGroup) ? this.swfBridgeGroup.parentBridge : null;
         if(Boolean(bridge))
         {
            sbRoot = this.systemManager.getSandboxRoot();
            sendToSbRoot = sbRoot != this.systemManager;
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
      
      private function dispatchDeactivatedWindowEvent(window:DisplayObject) : void
      {
         var sbRoot:DisplayObject = null;
         var sendToSbRoot:Boolean = false;
         var bridgeEvent:SWFBridgeEvent = null;
         var bridge:IEventDispatcher = Boolean(this.swfBridgeGroup) ? this.swfBridgeGroup.parentBridge : null;
         if(Boolean(bridge))
         {
            sbRoot = this.systemManager.getSandboxRoot();
            sendToSbRoot = sbRoot != this.systemManager;
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
      
      private function dispatchActivatedApplicationEvent() : void
      {
         var bridgeEvent:SWFBridgeEvent = null;
         var bridge:IEventDispatcher = Boolean(this.swfBridgeGroup) ? this.swfBridgeGroup.parentBridge : null;
         if(Boolean(bridge))
         {
            bridgeEvent = new SWFBridgeEvent(SWFBridgeEvent.BRIDGE_APPLICATION_ACTIVATE,false,false);
            bridge.dispatchEvent(bridgeEvent);
         }
      }
      
      private function updateLastActiveForm() : void
      {
         var awm:ActiveWindowManager = ActiveWindowManager(this.systemManager.getImplementation("mx.managers::IActiveWindowManager"));
         var n:int = int(awm.forms.length);
         if(n < 2)
         {
            return;
         }
         var index:int = -1;
         for(var i:int = 0; i < n; i++)
         {
            if(this.areFormsEqual(awm.form,awm.forms[i]))
            {
               index = i;
               break;
            }
         }
         if(index >= 0)
         {
            awm.forms.splice(index,1);
            awm.forms.push(awm.form);
         }
      }
      
      private function addPlaceholderId(id:String, previousId:String, bridge:IEventDispatcher, placeholder:Object) : void
      {
         if(!bridge)
         {
            throw new Error();
         }
         if(!this.idToPlaceholder)
         {
            this.idToPlaceholder = [];
         }
         this.idToPlaceholder[id] = new PlaceholderData(previousId,bridge,placeholder);
      }
      
      private function removePlaceholderId(id:String) : void
      {
         delete this.idToPlaceholder[id];
      }
      
      private function dispatchEventToOtherSystemManagers(event:Event) : void
      {
         SystemManagerGlobals.dispatchingEventToOtherSystemManagers = true;
         var arr:Array = SystemManagerGlobals.topLevelSystemManagers;
         var n:int = int(arr.length);
         for(var i:int = 0; i < n; i++)
         {
            if(arr[i] != this.systemManager)
            {
               arr[i].dispatchEvent(event);
            }
         }
         SystemManagerGlobals.dispatchingEventToOtherSystemManagers = false;
      }
      
      public function dispatchEventFromSWFBridges(event:Event, skip:IEventDispatcher = null, trackClones:Boolean = false, toOtherSystemManagers:Boolean = false) : void
      {
         var clone:Event = null;
         if(toOtherSystemManagers)
         {
            this.dispatchEventToOtherSystemManagers(event);
         }
         if(!this.swfBridgeGroup)
         {
            return;
         }
         clone = event.clone();
         if(trackClones)
         {
            this.currentSandboxEvent = clone;
         }
         var parentBridge:IEventDispatcher = this.swfBridgeGroup.parentBridge;
         if(Boolean(parentBridge) && parentBridge != skip)
         {
            if(clone is SWFBridgeRequest)
            {
               SWFBridgeRequest(clone).requestor = parentBridge;
            }
            parentBridge.dispatchEvent(clone);
         }
         var children:Array = this.swfBridgeGroup.getChildBridges();
         for(var i:int = 0; i < children.length; i++)
         {
            if(children[i] != skip)
            {
               clone = event.clone();
               if(trackClones)
               {
                  this.currentSandboxEvent = clone;
               }
               if(clone is SWFBridgeRequest)
               {
                  SWFBridgeRequest(clone).requestor = IEventDispatcher(children[i]);
               }
               IEventDispatcher(children[i]).dispatchEvent(clone);
            }
         }
         this.currentSandboxEvent = null;
      }
      
      private function addEventListenerToSandboxes(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false, skip:IEventDispatcher = null) : void
      {
         var i:int = 0;
         var childBridge:IEventDispatcher = null;
         if(!this.swfBridgeGroup)
         {
            return;
         }
         var request:EventListenerRequest = new EventListenerRequest(EventListenerRequest.ADD_EVENT_LISTENER_REQUEST,false,false,type,null,useCapture,priority,useWeakReference);
         var parentBridge:IEventDispatcher = this.swfBridgeGroup.parentBridge;
         if(Boolean(parentBridge) && parentBridge != skip)
         {
            parentBridge.addEventListener(type,listener,false,priority,useWeakReference);
         }
         for(var children:Array = this.swfBridgeGroup.getChildBridges(); i < children.length; )
         {
            childBridge = IEventDispatcher(children[i]);
            if(childBridge != skip)
            {
               childBridge.addEventListener(type,listener,false,priority,useWeakReference);
            }
            i++;
         }
         this.dispatchEventFromSWFBridges(request,skip);
      }
      
      private function removeEventListenerFromSandboxes(type:String, listener:Function, useCapture:Boolean = false, skip:IEventDispatcher = null) : void
      {
         var i:int = 0;
         if(!this.swfBridgeGroup)
         {
            return;
         }
         var request:EventListenerRequest = new EventListenerRequest(EventListenerRequest.REMOVE_EVENT_LISTENER_REQUEST,false,false,type,null,useCapture);
         var parentBridge:IEventDispatcher = this.swfBridgeGroup.parentBridge;
         if(Boolean(parentBridge) && parentBridge != skip)
         {
            parentBridge.removeEventListener(type,listener,useCapture);
         }
         for(var children:Array = this.swfBridgeGroup.getChildBridges(); i < children.length; )
         {
            if(children[i] != skip)
            {
               IEventDispatcher(children[i]).removeEventListener(type,listener,useCapture);
            }
            i++;
         }
         this.dispatchEventFromSWFBridges(request,skip);
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
            if(arr[i] != this.systemManager)
            {
               arr[i].addEventListener(type,listener,useCapture,priority,useWeakReference);
            }
         }
         SystemManagerGlobals.changingListenersInOtherSystemManagers = false;
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
            if(arr[i] != this.systemManager)
            {
               arr[i].removeEventListener(type,listener,useCapture);
            }
         }
         SystemManagerGlobals.changingListenersInOtherSystemManagers = false;
      }
      
      private function preProcessModalWindowRequest(request:SWFBridgeRequest, sbRoot:DisplayObject) : Boolean
      {
         var bridge:IEventDispatcher = null;
         var exclude:ISWFLoader = null;
         var excludeRect:Rectangle = null;
         if(Boolean(request.data.skip))
         {
            request.data.skip = false;
            if(this.useSWFBridge())
            {
               bridge = this.swfBridgeGroup.parentBridge;
               request.requestor = bridge;
               bridge.dispatchEvent(request);
            }
            return false;
         }
         if(this.systemManager != sbRoot)
         {
            if(request.type == SWFBridgeRequest.CREATE_MODAL_WINDOW_REQUEST || request.type == SWFBridgeRequest.SHOW_MODAL_WINDOW_REQUEST)
            {
               exclude = this.swfBridgeGroup.getChildBridgeProvider(request.requestor) as ISWFLoader;
               if(Boolean(exclude))
               {
                  excludeRect = ISWFLoader(exclude).getVisibleApplicationRect();
                  request.data.excludeRect = excludeRect;
                  if(!DisplayObjectContainer(this.systemManager.document).contains(DisplayObject(exclude)))
                  {
                     request.data.useExclude = false;
                  }
               }
            }
            bridge = this.swfBridgeGroup.parentBridge;
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
      
      private function otherSystemManagerMouseListener(event:SandboxMouseEvent) : void
      {
         if(SystemManagerGlobals.dispatchingEventToOtherSystemManagers)
         {
            return;
         }
         this.dispatchEventFromSWFBridges(event);
         var me:InterManagerRequest = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST);
         me.name = "sameSandbox";
         me.value = event;
         this.systemManager.getSandboxRoot().dispatchEvent(me);
         if(!me.value)
         {
            this.systemManager.dispatchEvent(event);
         }
      }
      
      private function sandboxMouseListener(event:Event) : void
      {
         if(event is SandboxMouseEvent)
         {
            return;
         }
         var marshaledEvent:Event = SandboxMouseEvent.marshal(event);
         this.dispatchEventFromSWFBridges(marshaledEvent,event.target as IEventDispatcher);
         var me:InterManagerRequest = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST);
         me.name = "sameSandbox";
         me.value = event;
         this.systemManager.getSandboxRoot().dispatchEvent(me);
         if(!me.value)
         {
            this.systemManager.dispatchEvent(marshaledEvent);
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
            if(!this.eventProxy)
            {
               this.eventProxy = new EventProxy(this.systemManager);
            }
            actualType = EventUtil.sandboxMouseEventMap[request.eventType];
            if(Boolean(actualType))
            {
               if(this.systemManager.isTopLevelRoot())
               {
                  this.systemManager.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.resetMouseCursorTracking,true,EventPriority.CURSOR_MANAGEMENT + 1,true);
               }
               else
               {
                  Object(this.systemManager).$addEventListener(MouseEvent.MOUSE_MOVE,this.resetMouseCursorTracking,true,EventPriority.CURSOR_MANAGEMENT + 1,true);
               }
               this.addEventListenerToSandboxes(request.eventType,this.sandboxMouseListener,true,request.priority,request.useWeakReference,event.target as IEventDispatcher);
               this.addEventListenerToOtherSystemManagers(request.eventType,this.otherSystemManagerMouseListener,true,request.priority,request.useWeakReference);
               if(this.systemManager.getSandboxRoot() == this.systemManager)
               {
                  if(this.systemManager.isTopLevelRoot() && (actualType == MouseEvent.MOUSE_UP || actualType == MouseEvent.MOUSE_MOVE))
                  {
                     if(Boolean(this.systemManager.stage))
                     {
                        this.systemManager.stage.addEventListener(actualType,this.eventProxy.marshalListener,false,request.priority,request.useWeakReference);
                     }
                  }
                  Object(this.systemManager).$addEventListener(actualType,this.eventProxy.marshalListener,true,request.priority,request.useWeakReference);
               }
            }
         }
         else if(event.type == EventListenerRequest.REMOVE_EVENT_LISTENER_REQUEST)
         {
            actualType = EventUtil.sandboxMouseEventMap[request.eventType];
            if(Boolean(actualType))
            {
               this.removeEventListenerFromOtherSystemManagers(request.eventType,this.otherSystemManagerMouseListener,true);
               this.removeEventListenerFromSandboxes(request.eventType,this.sandboxMouseListener,true,event.target as IEventDispatcher);
               if(this.systemManager.getSandboxRoot() == this.systemManager)
               {
                  if(this.systemManager.isTopLevelRoot() && (actualType == MouseEvent.MOUSE_UP || actualType == MouseEvent.MOUSE_MOVE))
                  {
                     if(Boolean(this.systemManager.stage))
                     {
                        this.systemManager.stage.removeEventListener(actualType,this.eventProxy.marshalListener);
                     }
                  }
                  Object(this.systemManager).$removeEventListener(actualType,this.eventProxy.marshalListener,true);
               }
            }
         }
      }
      
      private function Stage_resizeHandler(event:Event = null) : void
      {
         var sandboxScreen:Rectangle = this.getSandboxScreen();
         if(!Object(this.systemManager)._screen)
         {
            Object(this.systemManager)._screen = new Rectangle();
         }
         Object(this.systemManager)._screen.width = sandboxScreen.width;
         Object(this.systemManager)._screen.height = sandboxScreen.height;
      }
      
      private function invalidateParentSizeAndDisplayListHandler(event:Event) : void
      {
         if(this.systemManager.isTopLevel() && this.useSWFBridge())
         {
            this.dispatchInvalidateRequest();
         }
      }
      
      private function unloadHandler(event:Event) : void
      {
         this.systemManager.dispatchEvent(event);
      }
      
      private function addEventListenerHandler(request:DynamicEvent) : void
      {
         if(!this.addEventListener(request.eventType,request.listener,request.useCapture,request.priority,request.useWeakReference))
         {
            request.preventDefault();
         }
      }
      
      private function removeEventListenerHandler(request:DynamicEvent) : void
      {
         if(!this.removeEventListener(request.eventType,request.listener,request.useCapture))
         {
            request.preventDefault();
         }
      }
   }
}

