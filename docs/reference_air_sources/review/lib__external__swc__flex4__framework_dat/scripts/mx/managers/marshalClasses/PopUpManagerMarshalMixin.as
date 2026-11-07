package mx.managers.marshalClasses
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.core.FlexGlobals;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModuleFactory;
   import mx.core.ISWFLoader;
   import mx.core.IUIComponent;
   import mx.core.mx_internal;
   import mx.events.DynamicEvent;
   import mx.events.InterManagerRequest;
   import mx.events.MoveEvent;
   import mx.events.Request;
   import mx.events.SWFBridgeRequest;
   import mx.events.SandboxMouseEvent;
   import mx.managers.IActiveWindowManager;
   import mx.managers.IFocusManagerContainer;
   import mx.managers.IMarshalSystemManager;
   import mx.managers.ISystemManager;
   import mx.managers.PopUpData;
   import mx.managers.PopUpManagerImpl;
   import mx.managers.SystemManagerGlobals;
   import mx.managers.SystemManagerProxy;
   import mx.styles.IStyleClient;
   import mx.utils.NameUtil;
   
   use namespace mx_internal;
   
   [Mixin]
   [ExcludeClass]
   public class PopUpManagerMarshalMixin
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var popUpManager:PopUpManagerImpl;
      
      private var sm:ISystemManager;
      
      public function PopUpManagerMarshalMixin(owner:PopUpManagerImpl = null)
      {
         super();
         if(!owner)
         {
            return;
         }
         this.popUpManager = owner;
         this.sm = ISystemManager(SystemManagerGlobals.topLevelSystemManagers[0]);
         this.popUpManager.addEventListener("initialize",this.initializeHandler);
         this.popUpManager.addEventListener("addPopUp",this.addPopUpHandler);
         this.popUpManager.addEventListener("addPlaceHolder",this.addPlaceHolderHandler);
         this.popUpManager.addEventListener("addedPopUp",this.addedPopUpHandler);
         this.popUpManager.addEventListener("topLevelSystemManager",this.topLevelSystemManagerHandler);
         this.popUpManager.addEventListener("isTopLevelRoot",this.isTopLevelRootHandler);
         this.popUpManager.addEventListener("bringToFront",this.bringToFrontHandler);
         this.popUpManager.addEventListener("createModalWindow",this.createModalWindowHandler);
         this.popUpManager.addEventListener("updateModalMask",this.updateModalMaskHandler);
         this.popUpManager.addEventListener("createdModalWindow",this.createdModalWindowHandler);
         this.popUpManager.addEventListener("showModalWindow",this.showModalWindowHandler);
         this.popUpManager.addEventListener("blurTarget",this.blurTargetHandler);
         this.popUpManager.addEventListener("hideModalWindow",this.hideModalWindowHandler);
         this.popUpManager.addEventListener("addMouseOutEventListeners",this.addMouseOutEventListenersHandler);
         this.popUpManager.addEventListener("removeMouseOutEventListeners",this.removeMouseOutEventListenersHandler);
         this.popUpManager.addEventListener("popUpRemoved",this.popUpRemovedHandler);
      }
      
      public static function init(fbs:IFlexModuleFactory) : void
      {
         if(!PopUpManagerImpl.mixins)
         {
            PopUpManagerImpl.mixins = [];
         }
         if(PopUpManagerImpl.mixins.indexOf(PopUpManagerMarshalMixin) == -1)
         {
            PopUpManagerImpl.mixins.push(PopUpManagerMarshalMixin);
            PopUpManagerImpl.popUpInfoClass = MarshalPopUpData;
         }
      }
      
      mx_internal static function updateModalMask(sm:ISystemManager, modalWindow:DisplayObject, exclude:IUIComponent, excludeRect:Rectangle, mask:Sprite) : void
      {
         var excludeBounds:Rectangle = null;
         var pt:Point = null;
         var rect:Rectangle = null;
         var modalBounds:Rectangle = modalWindow.getBounds(DisplayObject(sm));
         if(exclude is ISWFLoader)
         {
            excludeBounds = ISWFLoader(exclude).getVisibleApplicationRect();
            pt = new Point(excludeBounds.x,excludeBounds.y);
            pt = DisplayObject(sm).globalToLocal(pt);
            excludeBounds.x = pt.x;
            excludeBounds.y = pt.y;
         }
         else if(!exclude)
         {
            excludeBounds = modalBounds.clone();
         }
         else
         {
            excludeBounds = DisplayObject(exclude).getBounds(DisplayObject(sm));
         }
         if(Boolean(excludeRect))
         {
            pt = new Point(excludeRect.x,excludeRect.y);
            pt = DisplayObject(sm).globalToLocal(pt);
            rect = new Rectangle(pt.x,pt.y,excludeRect.width,excludeRect.height);
            excludeBounds = excludeBounds.intersection(rect);
         }
         mask.graphics.clear();
         mask.graphics.beginFill(0);
         if(excludeBounds.y > modalBounds.y)
         {
            mask.graphics.drawRect(modalBounds.x,modalBounds.y,modalBounds.width,excludeBounds.y - modalBounds.y);
         }
         if(modalBounds.x < excludeBounds.x)
         {
            mask.graphics.drawRect(modalBounds.x,excludeBounds.y,excludeBounds.x - modalBounds.x,excludeBounds.height);
         }
         if(modalBounds.x + modalBounds.width > excludeBounds.x + excludeBounds.width)
         {
            mask.graphics.drawRect(excludeBounds.x + excludeBounds.width,excludeBounds.y,modalBounds.x + modalBounds.width - excludeBounds.x - excludeBounds.width,excludeBounds.height);
         }
         if(excludeBounds.y + excludeBounds.height < modalBounds.y + modalBounds.height)
         {
            mask.graphics.drawRect(modalBounds.x,excludeBounds.y + excludeBounds.height,modalBounds.width,modalBounds.y + modalBounds.height - excludeBounds.y - excludeBounds.height);
         }
         mask.graphics.endFill();
      }
      
      public function initializeHandler(event:Event) : void
      {
         this.sm.addEventListener(SWFBridgeRequest.CREATE_MODAL_WINDOW_REQUEST,this.createModalWindowRequestHandler,false,0,true);
         this.sm.addEventListener(SWFBridgeRequest.SHOW_MODAL_WINDOW_REQUEST,this.showModalWindowRequest,false,0,true);
         this.sm.addEventListener(SWFBridgeRequest.HIDE_MODAL_WINDOW_REQUEST,this.hideModalWindowRequest,false,0,true);
      }
      
      public function addPopUpHandler(event:Request) : void
      {
         var smp:SystemManagerProxy = null;
         var sm:ISystemManager = event.value.sm as ISystemManager;
         var parent:DisplayObjectContainer = event.value.parent as DisplayObjectContainer;
         if(!sm)
         {
            sm = ISystemManager(SystemManagerGlobals.topLevelSystemManagers[0]);
            if(sm.getSandboxRoot() != parent)
            {
               return;
            }
         }
         var sbRoot:DisplayObject = sm.getSandboxRoot();
         var request:SWFBridgeRequest = null;
         var mp:IMarshalSystemManager = IMarshalSystemManager(sm.getImplementation("mx.managers::IMarshalSystemManager"));
         if(mp.useSWFBridge())
         {
            if(sbRoot != sm)
            {
               smp = new SystemManagerProxy(sm);
               request = new SWFBridgeRequest(SWFBridgeRequest.ADD_POP_UP_REQUEST,false,false,mp.swfBridgeGroup.parentBridge,{
                  "window":DisplayObject(smp),
                  "parent":parent,
                  "modal":event.value.modal,
                  "childList":event.value.childList
               });
               sbRoot.dispatchEvent(request);
               event.value = smp;
               event.preventDefault();
            }
         }
      }
      
      public function addPlaceHolderHandler(event:DynamicEvent) : void
      {
         var request:SWFBridgeRequest = null;
         var sm:ISystemManager = event.sm as ISystemManager;
         var window:IFlexDisplayObject = event.window as IFlexDisplayObject;
         var sbRoot:DisplayObject = sm.getSandboxRoot();
         var mp:IMarshalSystemManager = IMarshalSystemManager(sm.getImplementation("mx.managers::IMarshalSystemManager"));
         if(Boolean(!sm.isTopLevelRoot()) && Boolean(sbRoot) && DisplayObject(sm) == sbRoot)
         {
            request = new SWFBridgeRequest(SWFBridgeRequest.ADD_POP_UP_PLACE_HOLDER_REQUEST,false,false,null,{"window":DisplayObject(window)});
            request.requestor = mp.swfBridgeGroup.parentBridge;
            request.data.placeHolderId = NameUtil.displayObjectToString(DisplayObject(window));
            sm.dispatchEvent(request);
         }
      }
      
      public function addedPopUpHandler(event:DynamicEvent) : void
      {
         var smp:ISystemManager = ISystemManager(event.systemManager);
         var awm:IActiveWindowManager = IActiveWindowManager(smp.getImplementation("mx.managers::IActiveWindowManager"));
         var mp:IMarshalSystemManager = IMarshalSystemManager(smp.getImplementation("mx.managers::IMarshalSystemManager"));
         if(!(smp is SystemManagerProxy) && mp.useSWFBridge())
         {
            mp.dispatchActivatedWindowEvent(DisplayObject(event.window));
         }
         else
         {
            awm.activate(IFocusManagerContainer(event.window));
         }
      }
      
      public function topLevelSystemManagerHandler(event:Request) : void
      {
         var localRoot:DisplayObjectContainer = null;
         var parent:DisplayObjectContainer = event.value as DisplayObjectContainer;
         if(parent.parent is SystemManagerProxy)
         {
            localRoot = DisplayObjectContainer(SystemManagerProxy(parent.parent).systemManager);
         }
         else if(parent is IUIComponent && IUIComponent(parent).systemManager is SystemManagerProxy)
         {
            localRoot = DisplayObjectContainer(SystemManagerProxy(IUIComponent(parent).systemManager).systemManager);
         }
         if(Boolean(localRoot))
         {
            event.value = localRoot;
            event.preventDefault();
         }
      }
      
      public function isTopLevelRootHandler(event:Request) : void
      {
         var request:InterManagerRequest = null;
         if(this.sm != this.sm.getSandboxRoot())
         {
            request = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST,false,false,"isTopLevelRoot");
            this.sm.getSandboxRoot().dispatchEvent(request);
            event.value = Boolean(request.value);
            event.preventDefault();
         }
      }
      
      public function bringToFrontHandler(event:DynamicEvent) : void
      {
         var popUp:IFlexDisplayObject = null;
         var request:InterManagerRequest = null;
         var o:PopUpData = event.popUpData;
         popUp = event.popUp;
         var sm:ISystemManager = ISystemManager(popUp.parent);
         if(sm is SystemManagerProxy)
         {
            request = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST,false,false,"bringToFront",{
               "topMost":o.topMost,
               "popUp":sm
            });
            sm.getSandboxRoot().dispatchEvent(request);
            event.preventDefault();
         }
      }
      
      public function createModalWindowHandler(event:DynamicEvent) : void
      {
         var o:MarshalPopUpData = event.popUpData;
         var popUp:IFlexDisplayObject = event.popUp;
         var popupStyleClient:IStyleClient = popUp as IStyleClient;
         if(!isNaN(o.modalTransparency))
         {
            o.modalWindow.alpha = o.modalTransparency;
         }
         o.modalTransparency = o.modalWindow.alpha;
         if(!isNaN(o.modalTransparencyColor))
         {
            event.color = o.modalTransparencyColor;
         }
         o.modalTransparencyColor = event.color;
         event.preventDefault();
      }
      
      public function updateModalMaskHandler(event:DynamicEvent) : void
      {
         var o:MarshalPopUpData = event.popUpData;
         if(Boolean(o.exclude))
         {
            o.modalMask = new Sprite();
            updateModalMask(this.sm,o.modalWindow,o.useExclude ? o.exclude : null,o.excludeRect,o.modalMask);
            o.modalWindow.mask = o.modalMask;
            event.childrenList.addChild(o.modalMask);
            o.exclude.addEventListener(Event.RESIZE,o.resizeHandler);
            o.exclude.addEventListener(MoveEvent.MOVE,o.resizeHandler);
         }
      }
      
      public function createdModalWindowHandler(event:DynamicEvent) : void
      {
         var o:MarshalPopUpData = event.popUpData;
         var popUp:IFlexDisplayObject = event.popUp;
         var popupStyleClient:IStyleClient = popUp as IStyleClient;
         var mp:IMarshalSystemManager = IMarshalSystemManager(this.sm.getImplementation("mx.managers::IMarshalSystemManager"));
         if(mp.useSWFBridge())
         {
            if(Boolean(popupStyleClient))
            {
               o.modalTransparencyDuration = popupStyleClient.getStyle("modalTransparencyDuration");
               o.modalTransparencyBlur = popupStyleClient.getStyle("modalTransparencyBlur");
            }
            this.dispatchModalWindowRequest(SWFBridgeRequest.CREATE_MODAL_WINDOW_REQUEST,this.sm,this.sm.getSandboxRoot(),o,event.visibleFlag);
         }
      }
      
      private function dispatchModalWindowRequest(type:String, sm:ISystemManager, sbRoot:DisplayObject, o:MarshalPopUpData, visibleFlag:Boolean) : void
      {
         var request:InterManagerRequest = null;
         if(!o.isRemoteModalWindow && sm != sbRoot)
         {
            request = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST,false,false,"isTopLevelRoot");
            sbRoot.dispatchEvent(request);
            if(Boolean(request.value))
            {
               return;
            }
         }
         var mp:IMarshalSystemManager = IMarshalSystemManager(sm.getImplementation("mx.managers::IMarshalSystemManager"));
         var modalRequest:SWFBridgeRequest = new SWFBridgeRequest(type,false,false,null,{
            "skip":!o.isRemoteModalWindow && sm != sbRoot,
            "useExclude":o.useExclude,
            "show":visibleFlag,
            "remove":false,
            "transparencyDuration":o.modalTransparencyDuration,
            "transparency":o.modalTransparency,
            "transparencyColor":o.modalTransparencyColor,
            "transparencyBlur":o.modalTransparencyBlur
         });
         var bridge:IEventDispatcher = mp.swfBridgeGroup.parentBridge;
         modalRequest.requestor = bridge;
         bridge.dispatchEvent(modalRequest);
      }
      
      public function showModalWindowHandler(event:DynamicEvent) : void
      {
         event.preventDefault();
         var o:MarshalPopUpData = event.popUpData;
         var popUp:IFlexDisplayObject = o.owner as IFlexDisplayObject;
         var sm:ISystemManager = event.systemManager;
         if(!isNaN(o.modalTransparencyDuration))
         {
            event.duration = o.modalTransparencyDuration;
         }
         o.modalTransparencyDuration = event.duration;
         if(!isNaN(o.modalTransparency))
         {
            event.alpha = o.modalTransparency;
         }
         o.modalTransparency = event.alpha;
         if(!isNaN(o.modalTransparencyBlur))
         {
            event.blurAmount = o.modalTransparencyBlur;
         }
         o.modalTransparencyBlur = event.blurAmount;
         if(!isNaN(o.modalTransparencyColor))
         {
            event.transparencyColor = o.modalTransparencyColor;
         }
         o.modalTransparencyColor = event.transparencyColor;
         var mp:IMarshalSystemManager = IMarshalSystemManager(sm.getImplementation("mx.managers::IMarshalSystemManager"));
         if(sm is SystemManagerProxy)
         {
            sm = SystemManagerProxy(sm).systemManager;
         }
         if(Boolean(event.sendRequest) && mp.useSWFBridge())
         {
            this.dispatchModalWindowRequest(SWFBridgeRequest.SHOW_MODAL_WINDOW_REQUEST,sm,sm.getSandboxRoot(),o,true);
         }
      }
      
      public function blurTargetHandler(event:Request) : void
      {
         var popUp:IFlexDisplayObject = null;
         var o:PopUpData = event.value.popUpData;
         popUp = o.owner as IFlexDisplayObject;
         var sm:ISystemManager = ISystemManager(popUp.parent);
         var sbRoot:DisplayObject = sm.getSandboxRoot();
         var applicationRequest:InterManagerRequest = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST,false,false,"application",sbRoot);
         sbRoot.dispatchEvent(applicationRequest);
         event.value = applicationRequest.value;
         event.preventDefault();
      }
      
      public function hideModalWindowHandler(event:DynamicEvent) : void
      {
         var sbRoot:DisplayObject = null;
         var modalRequest:SWFBridgeRequest = null;
         var bridge:IEventDispatcher = null;
         var target:IEventDispatcher = null;
         var request:InterManagerRequest = null;
         var o:MarshalPopUpData = event.popUpData;
         var destroy:Boolean = Boolean(event.destroy);
         if(destroy && Boolean(o.exclude))
         {
            o.exclude.removeEventListener(Event.RESIZE,o.resizeHandler);
            o.exclude.removeEventListener(MoveEvent.MOVE,o.resizeHandler);
         }
         var sm:ISystemManager = ISystemManager(FlexGlobals.topLevelApplication.systemManager);
         var mp:IMarshalSystemManager = IMarshalSystemManager(sm.getImplementation("mx.managers::IMarshalSystemManager"));
         if(mp.useSWFBridge())
         {
            sbRoot = sm.getSandboxRoot();
            if(!o.isRemoteModalWindow && sm != sbRoot)
            {
               request = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST,false,false,"isTopLevelRoot");
               sbRoot.dispatchEvent(request);
               if(Boolean(request.value))
               {
                  return;
               }
            }
            modalRequest = new SWFBridgeRequest(SWFBridgeRequest.HIDE_MODAL_WINDOW_REQUEST,false,false,null,{
               "skip":!o.isRemoteModalWindow && sm != sbRoot,
               "show":false,
               "remove":destroy
            });
            bridge = mp.swfBridgeGroup.parentBridge;
            modalRequest.requestor = bridge;
            bridge.dispatchEvent(modalRequest);
         }
      }
      
      private function createModalWindowRequestHandler(event:Event) : void
      {
         var request:SWFBridgeRequest = null;
         if(event is SWFBridgeRequest)
         {
            request = SWFBridgeRequest(event);
         }
         else
         {
            request = SWFBridgeRequest.marshal(event);
         }
         var sm:ISystemManager = this.popUpManager.getTopLevelSystemManager(DisplayObject(FlexGlobals.topLevelApplication));
         var mp:IMarshalSystemManager = IMarshalSystemManager(sm.getImplementation("mx.managers::IMarshalSystemManager"));
         var sbRoot:DisplayObject = sm.getSandboxRoot();
         var popUpData:MarshalPopUpData = MarshalPopUpData(PopUpManagerImpl.createPopUpData());
         popUpData.isRemoteModalWindow = true;
         popUpData.systemManager = sm;
         popUpData.modalTransparency = request.data.transparency;
         popUpData.modalTransparencyBlur = 0;
         popUpData.modalTransparencyColor = request.data.transparencyColor;
         popUpData.modalTransparencyDuration = request.data.transparencyDuration;
         popUpData.exclude = mp.swfBridgeGroup.getChildBridgeProvider(request.requestor) as IUIComponent;
         popUpData.useExclude = request.data.useExclude;
         popUpData.excludeRect = Rectangle(request.data.excludeRect);
         this.popUpManager.popupInfo.push(popUpData);
         this.popUpManager.createModalWindow(null,popUpData,sm.popUpChildren,request.data.show,sm,sbRoot);
      }
      
      private function showModalWindowRequest(event:Event) : void
      {
         var request:SWFBridgeRequest = SWFBridgeRequest.marshal(event);
         if(event is SWFBridgeRequest)
         {
            request = SWFBridgeRequest(event);
         }
         else
         {
            request = SWFBridgeRequest.marshal(event);
         }
         var sm:ISystemManager = this.popUpManager.getTopLevelSystemManager(DisplayObject(FlexGlobals.topLevelApplication));
         var mp:IMarshalSystemManager = IMarshalSystemManager(sm.getImplementation("mx.managers::IMarshalSystemManager"));
         var sbRoot:DisplayObject = sm.getSandboxRoot();
         var popUpData:MarshalPopUpData = this.findHighestRemoteModalPopupInfo();
         popUpData.excludeRect = Rectangle(request.data);
         popUpData.modalTransparency = request.data.transparency;
         popUpData.modalTransparencyBlur = 0;
         popUpData.modalTransparencyColor = request.data.transparencyColor;
         popUpData.modalTransparencyDuration = request.data.transparencyDuration;
         if(Boolean(popUpData.owner) || Boolean(popUpData.parent))
         {
            throw new Error();
         }
         this.popUpManager.showModalWindow(popUpData,sm);
      }
      
      private function hideModalWindowRequest(event:Event) : void
      {
         var request:SWFBridgeRequest = null;
         var awm:IActiveWindowManager = null;
         if(event is SWFBridgeRequest)
         {
            request = SWFBridgeRequest(event);
         }
         else
         {
            request = SWFBridgeRequest.marshal(event);
         }
         var sm:ISystemManager = this.popUpManager.getTopLevelSystemManager(DisplayObject(FlexGlobals.topLevelApplication));
         var sbRoot:DisplayObject = sm.getSandboxRoot();
         var popUpData:MarshalPopUpData = this.findHighestRemoteModalPopupInfo();
         if(Boolean(!popUpData) || Boolean(popUpData.owner) || Boolean(popUpData.parent))
         {
            throw new Error();
         }
         this.popUpManager.hideModalWindow(popUpData,request.data.remove);
         if(Boolean(request.data.remove))
         {
            this.popUpManager.popupInfo.splice(this.popUpManager.popupInfo.indexOf(popUpData),1);
            awm = IActiveWindowManager(sm.getImplementation("mx.managers::IActiveWindowManager"));
            --awm.numModalWindows;
         }
      }
      
      private function popUpRemovedHandler(event:DynamicEvent) : void
      {
         var parentBridge:IEventDispatcher = null;
         var request:SWFBridgeRequest = null;
         var o:PopUpData = event.popUpData;
         var popUp:IFlexDisplayObject = o.owner as IFlexDisplayObject;
         var sm:ISystemManager = o.systemManager;
         var mp:IMarshalSystemManager = IMarshalSystemManager(sm.getImplementation("mx.managers::IMarshalSystemManager"));
         if(sm is SystemManagerProxy)
         {
            parentBridge = mp.swfBridgeGroup.parentBridge;
            request = new SWFBridgeRequest(SWFBridgeRequest.REMOVE_POP_UP_REQUEST,false,false,parentBridge,{
               "window":DisplayObject(sm),
               "parent":o.parent,
               "modal":o.modalWindow != null
            });
            sm.getSandboxRoot().dispatchEvent(request);
         }
         else if(mp.useSWFBridge())
         {
            request = new SWFBridgeRequest(SWFBridgeRequest.REMOVE_POP_UP_PLACE_HOLDER_REQUEST,false,false,null,{"window":DisplayObject(popUp)});
            request.requestor = mp.swfBridgeGroup.parentBridge;
            request.data.placeHolderId = NameUtil.displayObjectToString(DisplayObject(popUp));
            sm.dispatchEvent(request);
         }
      }
      
      public function addMouseOutEventListenersHandler(event:DynamicEvent) : void
      {
         var o:MarshalPopUpData = event.popUpData;
         var sbRoot:DisplayObject = o.systemManager.getSandboxRoot();
         sbRoot.addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,o.marshalMouseOutsideHandler);
         sbRoot.addEventListener(SandboxMouseEvent.MOUSE_WHEEL_SOMEWHERE,o.marshalMouseOutsideHandler,true);
      }
      
      public function removeMouseOutEventListenersHandler(event:DynamicEvent) : void
      {
         var o:MarshalPopUpData = event.popUpData;
         var sbRoot:DisplayObject = o.systemManager.getSandboxRoot();
         sbRoot.removeEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,o.marshalMouseOutsideHandler);
         sbRoot.removeEventListener(SandboxMouseEvent.MOUSE_WHEEL_SOMEWHERE,o.marshalMouseOutsideHandler,true);
      }
      
      private function findHighestRemoteModalPopupInfo() : MarshalPopUpData
      {
         var o:MarshalPopUpData = null;
         var n:int = this.popUpManager.popupInfo.length - 1;
         for(var i:int = n; i >= 0; i--)
         {
            o = this.popUpManager.popupInfo[i];
            if(o.isRemoteModalWindow)
            {
               return o;
            }
         }
         return null;
      }
   }
}

