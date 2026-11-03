package mx.managers
{
   import flash.accessibility.Accessibility;
   import flash.accessibility.AccessibilityProperties;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.system.Capabilities;
   import mx.automation.IAutomationObject;
   import mx.core.FlexGlobals;
   import mx.core.FlexSprite;
   import mx.core.FlexVersion;
   import mx.core.IChildList;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModule;
   import mx.core.IFlexModuleFactory;
   import mx.core.IInvalidating;
   import mx.core.ILayoutDirectionElement;
   import mx.core.IUIComponent;
   import mx.core.LayoutDirection;
   import mx.core.UIComponent;
   import mx.core.UIComponentGlobals;
   import mx.core.mx_internal;
   import mx.effects.Blur;
   import mx.effects.Fade;
   import mx.effects.IEffect;
   import mx.events.DynamicEvent;
   import mx.events.EffectEvent;
   import mx.events.FlexEvent;
   import mx.events.FlexMouseEvent;
   import mx.events.Request;
   import mx.styles.IStyleClient;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class PopUpManagerImpl extends EventDispatcher implements IPopUpManager
   {
      
      private static var instance:IPopUpManager;
      
      public static var mixins:Array;
      
      mx_internal static var popUpInfoClass:Class;
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      mx_internal var modalWindowClass:Class;
      
      mx_internal var popupInfo:Array = [];
      
      public function PopUpManagerImpl()
      {
         var n:int = 0;
         var i:int = 0;
         super();
         if(Boolean(mixins))
         {
            n = int(mixins.length);
            for(i = 0; i < n; i++)
            {
               new mixins[i](this);
            }
         }
         if(hasEventListener("initialize"))
         {
            dispatchEvent(new Event("initialize"));
         }
      }
      
      mx_internal static function createPopUpData() : PopUpData
      {
         if(!popUpInfoClass)
         {
            return new PopUpData();
         }
         return new popUpInfoClass() as PopUpData;
      }
      
      private static function weakDependency() : void
      {
      }
      
      public static function getInstance() : IPopUpManager
      {
         if(!instance)
         {
            instance = new PopUpManagerImpl();
         }
         return instance;
      }
      
      private static function nonmodalMouseDownOutsideHandler(owner:DisplayObject, evt:MouseEvent) : void
      {
         if(!owner.hitTestPoint(evt.stageX,evt.stageY,true))
         {
            if(owner is IUIComponent)
            {
               if(IUIComponent(owner).owns(DisplayObject(evt.target)))
               {
                  return;
               }
            }
            dispatchMouseDownOutsideEvent(owner,evt);
         }
      }
      
      private static function nonmodalMouseWheelOutsideHandler(owner:DisplayObject, evt:MouseEvent) : void
      {
         if(!owner.hitTestPoint(evt.stageX,evt.stageY,true))
         {
            if(owner is IUIComponent)
            {
               if(IUIComponent(owner).owns(DisplayObject(evt.target)))
               {
                  return;
               }
            }
            dispatchMouseWheelOutsideEvent(owner,evt);
         }
      }
      
      private static function dispatchMouseWheelOutsideEvent(owner:DisplayObject, evt:MouseEvent) : void
      {
         if(!owner)
         {
            return;
         }
         var event:MouseEvent = new FlexMouseEvent(FlexMouseEvent.MOUSE_WHEEL_OUTSIDE);
         var pt:Point = owner.globalToLocal(new Point(evt.stageX,evt.stageY));
         event.localX = pt.x;
         event.localY = pt.y;
         event.buttonDown = evt.buttonDown;
         event.shiftKey = evt.shiftKey;
         event.altKey = evt.altKey;
         event.ctrlKey = evt.ctrlKey;
         event.delta = evt.delta;
         event.relatedObject = InteractiveObject(evt.target);
         owner.dispatchEvent(event);
      }
      
      private static function dispatchMouseDownOutsideEvent(owner:DisplayObject, evt:MouseEvent) : void
      {
         if(!owner)
         {
            return;
         }
         var event:MouseEvent = new FlexMouseEvent(FlexMouseEvent.MOUSE_DOWN_OUTSIDE);
         var pt:Point = owner.globalToLocal(new Point(evt.stageX,evt.stageY));
         event.localX = pt.x;
         event.localY = pt.y;
         event.buttonDown = evt.buttonDown;
         event.shiftKey = evt.shiftKey;
         event.altKey = evt.altKey;
         event.ctrlKey = evt.ctrlKey;
         event.delta = evt.delta;
         event.relatedObject = InteractiveObject(evt.target);
         owner.dispatchEvent(event);
      }
      
      public function createPopUp(parent:DisplayObject, className:Class, modal:Boolean = false, childList:String = null, moduleFactory:IFlexModuleFactory = null) : IFlexDisplayObject
      {
         var window:IUIComponent = new className();
         this.addPopUp(window,parent,modal,childList,moduleFactory);
         return window;
      }
      
      public function addPopUp(window:IFlexDisplayObject, parent:DisplayObject, modal:Boolean = false, childList:String = null, moduleFactory:IFlexModuleFactory = null) : void
      {
         var children:IChildList = null;
         var topMost:Boolean = false;
         var request:Request = null;
         var event:DynamicEvent = null;
         var visibleFlag:Boolean = window.visible;
         if(parent is IUIComponent && window is IUIComponent && IUIComponent(window).document == null)
         {
            IUIComponent(window).document = IUIComponent(parent).document;
         }
         if(window is IFlexModule && IFlexModule(window).moduleFactory == null)
         {
            if(Boolean(moduleFactory))
            {
               IFlexModule(window).moduleFactory = moduleFactory;
            }
            else if(parent is IUIComponent && IUIComponent(parent).document is IFlexModule)
            {
               IFlexModule(window).moduleFactory = IFlexModule(IUIComponent(parent).document).moduleFactory;
            }
         }
         var sm:ISystemManager = this.getTopLevelSystemManager(parent);
         if(!sm)
         {
            sm = ISystemManager(SystemManagerGlobals.topLevelSystemManagers[0]);
            if(sm.getSandboxRoot() != parent)
            {
               return;
            }
         }
         var smp:ISystemManager = sm;
         if(hasEventListener("addPopUp"))
         {
            request = new Request("addPopUp",false,true,{
               "parent":parent,
               "sm":sm,
               "modal":modal,
               "childList":childList
            });
            if(!dispatchEvent(request))
            {
               smp = request.value as ISystemManager;
            }
         }
         if(window is IUIComponent)
         {
            IUIComponent(window).isPopUp = true;
         }
         if(!childList || childList == PopUpManagerChildList.PARENT)
         {
            topMost = smp.popUpChildren.contains(parent);
         }
         else
         {
            topMost = childList == PopUpManagerChildList.POPUP;
         }
         children = topMost ? smp.popUpChildren : smp;
         if(DisplayObject(window).parent != children)
         {
            children.addChild(DisplayObject(window));
         }
         window.visible = false;
         var o:PopUpData = createPopUpData();
         o.owner = DisplayObject(window);
         o.topMost = topMost;
         o.systemManager = smp;
         this.popupInfo.push(o);
         var awm:IActiveWindowManager = IActiveWindowManager(smp.getImplementation("mx.managers::IActiveWindowManager"));
         if(window is IFocusManagerContainer)
         {
            if(Boolean(IFocusManagerContainer(window).focusManager))
            {
               awm.addFocusManager(IFocusManagerContainer(window));
            }
            else
            {
               IFocusManagerContainer(window).focusManager = new FocusManager(IFocusManagerContainer(window),true);
            }
         }
         if(hasEventListener("addPlaceHolder"))
         {
            event = new DynamicEvent("addPlaceHolder");
            event.sm = sm;
            event.window = window;
            dispatchEvent(event);
         }
         if(window is IAutomationObject)
         {
            IAutomationObject(window).showInAutomationHierarchy = true;
         }
         if(window is ILayoutManagerClient)
         {
            UIComponentGlobals.layoutManager.validateClient(ILayoutManagerClient(window),true);
         }
         o.parent = parent;
         if(window is IUIComponent)
         {
            IUIComponent(window).setActualSize(IUIComponent(window).getExplicitOrMeasuredWidth(),IUIComponent(window).getExplicitOrMeasuredHeight());
         }
         if(FlexVersion.compatibilityVersion >= FlexVersion.VERSION_4_0)
         {
            if(window is ILayoutDirectionElement)
            {
               ILayoutDirectionElement(window).invalidateLayoutDirection();
            }
         }
         if(modal)
         {
            if(Capabilities.hasAccessibility && Accessibility.active)
            {
               window.addEventListener(FlexEvent.CREATION_COMPLETE,this.modalPopUpCreationCompleteHandler,false,0,true);
            }
            this.createModalWindow(parent,o,children,visibleFlag,smp,smp.getSandboxRoot());
         }
         else
         {
            o._mouseDownOutsideHandler = nonmodalMouseDownOutsideHandler;
            o._mouseWheelOutsideHandler = nonmodalMouseWheelOutsideHandler;
            window.visible = visibleFlag;
         }
         o.owner.addEventListener(FlexEvent.SHOW,this.showOwnerHandler);
         o.owner.addEventListener(FlexEvent.HIDE,this.hideOwnerHandler);
         this.addMouseOutEventListeners(o);
         window.addEventListener(Event.REMOVED,this.popupRemovedHandler);
         if(window is IFocusManagerContainer && visibleFlag)
         {
            if(hasEventListener("addedPopUp"))
            {
               event = new DynamicEvent("addedPopUp",false,true);
               event.window = window;
               event.systemManager = smp;
               dispatchEvent(event);
            }
            else
            {
               awm.activate(IFocusManagerContainer(window));
            }
         }
      }
      
      mx_internal function getTopLevelSystemManager(parent:DisplayObject) : ISystemManager
      {
         var localRoot:DisplayObjectContainer = null;
         var sm:ISystemManager = null;
         var request:Request = null;
         if(hasEventListener("topLevelSystemManager"))
         {
            request = new Request("topLevelSystemManager",false,true);
            request.value = parent;
            if(!dispatchEvent(request))
            {
               localRoot = request.value as DisplayObjectContainer;
            }
         }
         if(!localRoot)
         {
            localRoot = DisplayObjectContainer(parent.root);
         }
         if((!localRoot || localRoot is Stage) && parent is IUIComponent)
         {
            localRoot = DisplayObjectContainer(IUIComponent(parent).systemManager);
         }
         if(localRoot is ISystemManager)
         {
            sm = ISystemManager(localRoot);
            if(!sm.isTopLevel())
            {
               sm = sm.topLevelSystemManager;
            }
         }
         return sm;
      }
      
      public function centerPopUp(popUp:IFlexDisplayObject) : void
      {
         var systemManager:ISystemManager = null;
         var x:Number = NaN;
         var y:Number = NaN;
         var appWidth:Number = NaN;
         var appHeight:Number = NaN;
         var parentWidth:Number = NaN;
         var parentHeight:Number = NaN;
         var rect:Rectangle = null;
         var clippingOffset:Point = null;
         var pt:Point = null;
         var isTopLevelRoot:Boolean = false;
         var sbRoot:DisplayObject = null;
         var request:Request = null;
         var screen:Rectangle = null;
         var offset:Point = null;
         var popUpLDE:ILayoutDirectionElement = null;
         var parentLDE:ILayoutDirectionElement = null;
         if(popUp is IInvalidating)
         {
            IInvalidating(popUp).validateNow();
         }
         var o:PopUpData = this.findPopupInfoByOwner(popUp);
         var popUpParent:DisplayObject = Boolean(o) && Boolean(o.parent) && Boolean(o.parent.stage) ? o.parent : popUp.parent;
         if(Boolean(popUpParent))
         {
            systemManager = o.systemManager;
            clippingOffset = new Point();
            sbRoot = systemManager.getSandboxRoot();
            if(hasEventListener("isTopLevelRoot"))
            {
               request = new Request("isTopLevelRoot",false,true);
            }
            if(Boolean(request) && !dispatchEvent(request))
            {
               isTopLevelRoot = Boolean(request.value);
            }
            else
            {
               isTopLevelRoot = systemManager.isTopLevelRoot();
            }
            if(isTopLevelRoot && FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_6)
            {
               screen = systemManager.screen;
               appWidth = screen.width;
               appHeight = screen.height;
            }
            else
            {
               rect = systemManager.getVisibleApplicationRect();
               rect.topLeft = DisplayObject(systemManager).globalToLocal(rect.topLeft);
               rect.bottomRight = DisplayObject(systemManager).globalToLocal(rect.bottomRight);
               clippingOffset = rect.topLeft.clone();
               appWidth = rect.width;
               appHeight = rect.height;
            }
            if(popUpParent is UIComponent)
            {
               rect = UIComponent(popUpParent).getVisibleRect();
               if(UIComponent(popUpParent).systemManager != sbRoot)
               {
                  rect = UIComponent(popUpParent).systemManager.getVisibleApplicationRect(rect);
               }
               offset = popUpParent.globalToLocal(rect.topLeft);
               clippingOffset.x += offset.x;
               clippingOffset.y += offset.y;
               parentWidth = rect.width;
               parentHeight = rect.height;
            }
            else
            {
               parentWidth = popUpParent.width;
               parentHeight = popUpParent.height;
            }
            x = Math.max(0,(Math.min(appWidth,parentWidth) - popUp.width) / 2);
            y = Math.max(0,(Math.min(appHeight,parentHeight) - popUp.height) / 2);
            if(FlexVersion.compatibilityVersion >= FlexVersion.VERSION_4_0)
            {
               popUpLDE = popUp as ILayoutDirectionElement;
               parentLDE = popUpParent as ILayoutDirectionElement;
               if(Boolean(popUpLDE) && (Boolean(parentLDE && parentLDE.layoutDirection != popUpLDE.layoutDirection) || Boolean(!parentLDE && popUpLDE.layoutDirection == LayoutDirection.RTL)))
               {
                  x = -x - popUp.width;
               }
            }
            pt = new Point(clippingOffset.x,clippingOffset.y);
            pt = popUpParent.localToGlobal(pt);
            pt = popUp.parent.globalToLocal(pt);
            popUp.move(Math.round(x) + pt.x,Math.round(y) + pt.y);
         }
      }
      
      public function removePopUp(popUp:IFlexDisplayObject) : void
      {
         var o:PopUpData = null;
         var sm:ISystemManager = null;
         var iui:IUIComponent = null;
         if(Boolean(popUp) && Boolean(popUp.parent))
         {
            o = this.findPopupInfoByOwner(popUp);
            if(Boolean(o))
            {
               sm = o.systemManager;
               if(!sm)
               {
                  iui = popUp as IUIComponent;
                  if(!Boolean(iui))
                  {
                     return;
                  }
                  sm = ISystemManager(iui.systemManager);
               }
               if(o.topMost)
               {
                  sm.popUpChildren.removeChild(DisplayObject(popUp));
               }
               else
               {
                  sm.removeChild(DisplayObject(popUp));
               }
            }
         }
      }
      
      public function bringToFront(popUp:IFlexDisplayObject) : void
      {
         var o:PopUpData = null;
         var sm:ISystemManager = null;
         var dynamicEvent:DynamicEvent = null;
         if(Boolean(popUp) && Boolean(popUp.parent))
         {
            o = this.findPopupInfoByOwner(popUp);
            if(Boolean(o))
            {
               if(hasEventListener("bringToFront"))
               {
                  dynamicEvent = new DynamicEvent("bringToFront",false,true);
                  dynamicEvent.popUpData = o;
                  dynamicEvent.popUp = popUp;
                  if(!dispatchEvent(dynamicEvent))
                  {
                     return;
                  }
               }
               sm = ISystemManager(popUp.parent);
               if(o.topMost)
               {
                  sm.popUpChildren.setChildIndex(DisplayObject(popUp),sm.popUpChildren.numChildren - 1);
               }
               else
               {
                  sm.setChildIndex(DisplayObject(popUp),sm.numChildren - 1);
               }
            }
         }
      }
      
      mx_internal function createModalWindow(parentReference:DisplayObject, o:PopUpData, childrenList:IChildList, visibleFlag:Boolean, sm:ISystemManager, sbRoot:DisplayObject) : void
      {
         var popup:IFlexDisplayObject = null;
         var modalWindow:Sprite = null;
         var dynamicEvent:DynamicEvent = null;
         popup = IFlexDisplayObject(o.owner);
         var popupStyleClient:IStyleClient = popup as IStyleClient;
         var duration:Number = 0;
         if(Boolean(this.modalWindowClass))
         {
            modalWindow = new this.modalWindowClass();
         }
         else
         {
            modalWindow = new FlexSprite();
            modalWindow.name = "modalWindow";
         }
         if(!sm && Boolean(parentReference))
         {
            sm = IUIComponent(parentReference).systemManager;
         }
         var awm:IActiveWindowManager = IActiveWindowManager(sm.getImplementation("mx.managers::IActiveWindowManager"));
         ++awm.numModalWindows;
         if(Boolean(popup))
         {
            childrenList.addChildAt(modalWindow,childrenList.getChildIndex(DisplayObject(popup)));
         }
         else
         {
            childrenList.addChild(modalWindow);
         }
         if(popup is IAutomationObject)
         {
            IAutomationObject(popup).showInAutomationHierarchy = true;
         }
         o.modalWindow = modalWindow;
         if(Boolean(popupStyleClient))
         {
            modalWindow.alpha = popupStyleClient.getStyle("modalTransparency");
         }
         else
         {
            modalWindow.alpha = 0;
         }
         modalWindow.tabEnabled = false;
         var screen:Rectangle = sm.screen;
         var g:Graphics = modalWindow.graphics;
         var c:Number = 16777215;
         if(Boolean(popupStyleClient))
         {
            c = popupStyleClient.getStyle("modalTransparencyColor");
         }
         if(hasEventListener("createModalWindow"))
         {
            dynamicEvent = new DynamicEvent("createModalWindow",false,true);
            dynamicEvent.popUpData = o;
            dynamicEvent.popUp = popup;
            dynamicEvent.color = c;
            dynamicEvent.visibleFlag = visibleFlag;
            dynamicEvent.childrenList = childrenList;
            if(!dispatchEvent(dynamicEvent))
            {
               c = Number(dynamicEvent.color);
            }
         }
         g.clear();
         g.beginFill(c,100);
         g.drawRect(screen.x,screen.y,screen.width,screen.height);
         g.endFill();
         if(hasEventListener("updateModalMask"))
         {
            dynamicEvent = new DynamicEvent("updateModalMask");
            dynamicEvent.popUpData = o;
            dynamicEvent.popUp = popup;
            dynamicEvent.childrenList = childrenList;
            dispatchEvent(dynamicEvent);
         }
         o._mouseDownOutsideHandler = dispatchMouseDownOutsideEvent;
         o._mouseWheelOutsideHandler = dispatchMouseWheelOutsideEvent;
         sm.addEventListener(Event.RESIZE,o.resizeHandler);
         if(Boolean(popup))
         {
            popup.addEventListener(FlexEvent.SHOW,this.popupShowHandler);
            popup.addEventListener(FlexEvent.HIDE,this.popupHideHandler);
         }
         if(visibleFlag)
         {
            this.showModalWindow(o,sm,false);
         }
         else
         {
            popup.visible = visibleFlag;
         }
         if(hasEventListener("createdModalWindow"))
         {
            dynamicEvent = new DynamicEvent("createdModalWindow");
            dynamicEvent.popUpData = o;
            dynamicEvent.popUp = popup;
            dynamicEvent.visibleFlag = visibleFlag;
            dynamicEvent.childrenList = childrenList;
            dispatchEvent(dynamicEvent);
         }
      }
      
      private function endEffects(o:PopUpData) : void
      {
         if(Boolean(o.fade))
         {
            o.fade.end();
            o.fade = null;
         }
         if(Boolean(o.blur))
         {
            o.blur.end();
            o.blur = null;
         }
      }
      
      mx_internal function showModalWindow(o:PopUpData, sm:ISystemManager, sendRequest:Boolean = true) : void
      {
         var dynamicEvent:DynamicEvent = null;
         var popUpStyleClient:IStyleClient = o.owner as IStyleClient;
         var duration:Number = 0;
         var alpha:Number = 0;
         if(Boolean(popUpStyleClient))
         {
            duration = popUpStyleClient.getStyle("modalTransparencyDuration");
         }
         if(Boolean(popUpStyleClient))
         {
            alpha = popUpStyleClient.getStyle("modalTransparency");
         }
         var blurAmount:Number = 0;
         if(Boolean(popUpStyleClient))
         {
            blurAmount = popUpStyleClient.getStyle("modalTransparencyBlur");
         }
         var transparencyColor:Number = 16777215;
         if(Boolean(popUpStyleClient))
         {
            transparencyColor = popUpStyleClient.getStyle("modalTransparencyColor");
         }
         var sbRoot:DisplayObject = sm.getSandboxRoot();
         if(hasEventListener("showModalWindow"))
         {
            dynamicEvent = new DynamicEvent("showModalWindow",false,true);
            dynamicEvent.popUpData = o;
            dynamicEvent.sendRequest = sendRequest;
            dynamicEvent.alpha = alpha;
            dynamicEvent.blurAmount = blurAmount;
            dynamicEvent.duration = duration;
            dynamicEvent.systemManager = sm;
            dynamicEvent.transparencyColor = transparencyColor;
            if(!dispatchEvent(dynamicEvent))
            {
               alpha = Number(dynamicEvent.alpha);
               blurAmount = Number(dynamicEvent.blurAmount);
               duration = Number(dynamicEvent.duration);
               transparencyColor = Number(dynamicEvent.transparencyColor);
            }
         }
         o.modalWindow.alpha = alpha;
         this.showModalWindowInternal(o,duration,alpha,transparencyColor,blurAmount,sm,sbRoot);
      }
      
      private function setModalPopupVisible(popup:DisplayObject, value:Boolean) : void
      {
         popup.removeEventListener(FlexEvent.SHOW,this.popupShowHandler);
         popup.removeEventListener(FlexEvent.HIDE,this.popupHideHandler);
         popup.visible = value;
         popup.addEventListener(FlexEvent.SHOW,this.popupShowHandler);
         popup.addEventListener(FlexEvent.HIDE,this.popupHideHandler);
      }
      
      private function showModalWindowInternal(o:PopUpData, transparencyDuration:Number, transparency:Number, transparencyColor:Number, transparencyBlur:Number, sm:ISystemManager, sbRoot:DisplayObject) : void
      {
         var fade:Fade = null;
         var blurAmount:Number = NaN;
         var blur:Blur = null;
         var sbRootApp:Object = null;
         var request:Request = null;
         this.endEffects(o);
         if(Boolean(transparencyDuration))
         {
            fade = new Fade(o.modalWindow);
            fade.alphaFrom = 0;
            fade.alphaTo = transparency;
            fade.duration = transparencyDuration;
            fade.addEventListener(EffectEvent.EFFECT_END,this.fadeInEffectEndHandler);
            o.modalWindow.alpha = 0;
            o.modalWindow.visible = true;
            o.fade = fade;
            if(Boolean(o.owner))
            {
               this.setModalPopupVisible(o.owner,false);
            }
            fade.play();
            blurAmount = transparencyBlur;
            if(Boolean(blurAmount))
            {
               if(DisplayObject(sm).parent is Stage)
               {
                  o.blurTarget = sm.document;
               }
               else if(sm != sbRoot)
               {
                  if(hasEventListener("blurTarget"))
                  {
                     request = new Request("blurTarget",false,true,{"popUpData":o});
                     if(!dispatchEvent(request))
                     {
                        o.blurTarget = request.value;
                     }
                  }
               }
               else
               {
                  o.blurTarget = FlexGlobals.topLevelApplication;
               }
               blur = new Blur(o.blurTarget);
               blur.blurXFrom = blur.blurYFrom = 0;
               blur.blurXTo = blur.blurYTo = blurAmount;
               blur.duration = transparencyDuration;
               blur.addEventListener(EffectEvent.EFFECT_END,this.effectEndHandler);
               o.blur = blur;
               blur.play();
            }
         }
         else
         {
            if(Boolean(o.owner))
            {
               this.setModalPopupVisible(o.owner,true);
            }
            o.modalWindow.visible = true;
         }
      }
      
      mx_internal function hideModalWindow(o:PopUpData, destroy:Boolean = false) : void
      {
         var fade:Fade = null;
         var blurAmount:Number = NaN;
         var blur:Blur = null;
         var dynamicEvent:DynamicEvent = null;
         var popUpStyleClient:IStyleClient = o.owner as IStyleClient;
         var duration:Number = 0;
         if(Boolean(popUpStyleClient))
         {
            duration = popUpStyleClient.getStyle("modalTransparencyDuration");
         }
         this.endEffects(o);
         if(Boolean(duration))
         {
            fade = new Fade(o.modalWindow);
            fade.alphaFrom = o.modalWindow.alpha;
            fade.alphaTo = 0;
            fade.duration = duration;
            fade.addEventListener(EffectEvent.EFFECT_END,destroy ? this.fadeOutDestroyEffectEndHandler : this.fadeOutCloseEffectEndHandler);
            o.modalWindow.visible = true;
            o.fade = fade;
            fade.play();
            blurAmount = popUpStyleClient.getStyle("modalTransparencyBlur");
            if(Boolean(blurAmount))
            {
               blur = new Blur(o.blurTarget);
               blur.blurXFrom = blur.blurYFrom = blurAmount;
               blur.blurXTo = blur.blurYTo = 0;
               blur.duration = duration;
               blur.addEventListener(EffectEvent.EFFECT_END,this.effectEndHandler);
               o.blur = blur;
               blur.play();
            }
         }
         else
         {
            o.modalWindow.visible = false;
         }
         if(hasEventListener("hideModalWindow"))
         {
            dynamicEvent = new DynamicEvent("hideModalWindow",false,false);
            dynamicEvent.popUpData = o;
            dynamicEvent.destroy = destroy;
            dispatchEvent(dynamicEvent);
         }
      }
      
      private function findPopupInfoIndexByOwner(owner:Object) : int
      {
         var o:PopUpData = null;
         var n:int = int(this.popupInfo.length);
         for(var i:int = 0; i < n; i++)
         {
            o = this.popupInfo[i];
            if(o.owner == owner)
            {
               return i;
            }
         }
         return -1;
      }
      
      private function findPopupInfoByOwner(owner:Object) : PopUpData
      {
         var index:int = this.findPopupInfoIndexByOwner(owner);
         return index > -1 ? this.popupInfo[index] : null;
      }
      
      private function addMouseOutEventListeners(o:PopUpData) : void
      {
         var dynamicEvent:DynamicEvent = null;
         var sbRoot:DisplayObject = o.systemManager.getSandboxRoot();
         if(Boolean(o.modalWindow))
         {
            o.modalWindow.addEventListener(MouseEvent.MOUSE_DOWN,o.mouseDownOutsideHandler);
            o.modalWindow.addEventListener(MouseEvent.MOUSE_WHEEL,o.mouseWheelOutsideHandler,true);
         }
         else
         {
            sbRoot.addEventListener(MouseEvent.MOUSE_DOWN,o.mouseDownOutsideHandler);
            sbRoot.addEventListener(MouseEvent.MOUSE_WHEEL,o.mouseWheelOutsideHandler,true);
         }
         if(hasEventListener("addMouseOutEventListeners"))
         {
            dynamicEvent = new DynamicEvent("addMouseOutEventListeners",false,false);
            dynamicEvent.popUpData = o;
            dispatchEvent(dynamicEvent);
         }
      }
      
      private function removeMouseOutEventListeners(o:PopUpData) : void
      {
         var dynamicEvent:DynamicEvent = null;
         var sbRoot:DisplayObject = o.systemManager.getSandboxRoot();
         if(Boolean(o.modalWindow))
         {
            o.modalWindow.removeEventListener(MouseEvent.MOUSE_DOWN,o.mouseDownOutsideHandler);
            o.modalWindow.removeEventListener(MouseEvent.MOUSE_WHEEL,o.mouseWheelOutsideHandler,true);
         }
         else
         {
            sbRoot.removeEventListener(MouseEvent.MOUSE_DOWN,o.mouseDownOutsideHandler);
            sbRoot.removeEventListener(MouseEvent.MOUSE_WHEEL,o.mouseWheelOutsideHandler,true);
         }
         if(hasEventListener("removeMouseOutEventListeners"))
         {
            dynamicEvent = new DynamicEvent("removeMouseOutEventListeners",false,false);
            dynamicEvent.popUpData = o;
            dispatchEvent(dynamicEvent);
         }
      }
      
      private function popupShowHandler(event:FlexEvent) : void
      {
         var o:PopUpData = this.findPopupInfoByOwner(event.target);
         if(Boolean(o))
         {
            this.showModalWindow(o,this.getTopLevelSystemManager(o.parent));
         }
      }
      
      private function popupHideHandler(event:FlexEvent) : void
      {
         var o:PopUpData = this.findPopupInfoByOwner(event.target);
         if(Boolean(o))
         {
            this.hideModalWindow(o);
         }
      }
      
      private function showOwnerHandler(event:FlexEvent) : void
      {
         var o:PopUpData = this.findPopupInfoByOwner(event.target);
         if(Boolean(o))
         {
            this.addMouseOutEventListeners(o);
         }
      }
      
      private function hideOwnerHandler(event:FlexEvent) : void
      {
         var o:PopUpData = this.findPopupInfoByOwner(event.target);
         if(Boolean(o))
         {
            this.removeMouseOutEventListeners(o);
         }
      }
      
      private function popupRemovedHandler(event:Event) : void
      {
         var o:PopUpData = null;
         var popUp:DisplayObject = null;
         var popUpParent:DisplayObject = null;
         var modalWindow:DisplayObject = null;
         var sm:ISystemManager = null;
         var awm:IActiveWindowManager = null;
         var event2:DynamicEvent = null;
         var n:int = int(this.popupInfo.length);
         for(var i:int = 0; i < n; i++)
         {
            o = this.popupInfo[i];
            popUp = o.owner;
            if(popUp == event.target)
            {
               popUpParent = o.parent;
               modalWindow = o.modalWindow;
               sm = o.systemManager;
               if(!sm.isTopLevel())
               {
                  sm = sm.topLevelSystemManager;
               }
               if(popUp is IUIComponent)
               {
                  IUIComponent(popUp).isPopUp = false;
               }
               awm = IActiveWindowManager(sm.getImplementation("mx.managers::IActiveWindowManager"));
               if(popUp is IFocusManagerContainer)
               {
                  awm.removeFocusManager(IFocusManagerContainer(popUp));
               }
               popUp.removeEventListener(Event.REMOVED,this.popupRemovedHandler);
               if(hasEventListener("removeMouseOutEventListeners"))
               {
                  event2 = new DynamicEvent("popUpRemoved");
                  event2.popUpData = o;
                  dispatchEvent(event2);
               }
               if(Boolean(o.owner))
               {
                  o.owner.removeEventListener(FlexEvent.SHOW,this.showOwnerHandler);
                  o.owner.removeEventListener(FlexEvent.HIDE,this.hideOwnerHandler);
               }
               this.removeMouseOutEventListeners(o);
               if(Boolean(modalWindow))
               {
                  this.removeModalPopUpAccessibility(popUp);
                  sm.removeEventListener(Event.RESIZE,o.resizeHandler);
                  popUp.removeEventListener(FlexEvent.SHOW,this.popupShowHandler);
                  popUp.removeEventListener(FlexEvent.HIDE,this.popupHideHandler);
                  this.hideModalWindow(o,true);
                  --awm.numModalWindows;
               }
               this.popupInfo.splice(i,1);
               break;
            }
         }
      }
      
      private function fadeInEffectEndHandler(event:EffectEvent) : void
      {
         var o:PopUpData = null;
         this.effectEndHandler(event);
         var n:int = int(this.popupInfo.length);
         for(var i:int = 0; i < n; i++)
         {
            o = this.popupInfo[i];
            if(Boolean(o.owner) && o.modalWindow == event.effectInstance.target)
            {
               this.setModalPopupVisible(o.owner,true);
               break;
            }
         }
      }
      
      private function fadeOutDestroyEffectEndHandler(event:EffectEvent) : void
      {
         var sm:ISystemManager = null;
         this.effectEndHandler(event);
         var obj:DisplayObject = DisplayObject(event.effectInstance.target);
         var modalMask:DisplayObject = obj.mask;
         if(Boolean(modalMask))
         {
            obj.mask = null;
            sm.popUpChildren.removeChild(modalMask);
         }
         if(obj.parent is ISystemManager)
         {
            sm = ISystemManager(obj.parent);
            if(sm.popUpChildren.contains(obj))
            {
               sm.popUpChildren.removeChild(obj);
            }
            else
            {
               sm.removeChild(obj);
            }
         }
         else if(Boolean(obj.parent))
         {
            obj.parent.removeChild(obj);
         }
      }
      
      private function fadeOutCloseEffectEndHandler(event:EffectEvent) : void
      {
         this.effectEndHandler(event);
         DisplayObject(event.effectInstance.target).visible = false;
      }
      
      private function effectEndHandler(event:EffectEvent) : void
      {
         var o:PopUpData = null;
         var e:IEffect = null;
         var n:int = int(this.popupInfo.length);
         for(var i:int = 0; i < n; i++)
         {
            o = this.popupInfo[i];
            e = event.effectInstance.effect;
            if(e == o.fade)
            {
               o.fade = null;
            }
            else if(e == o.blur)
            {
               o.blur = null;
            }
         }
      }
      
      private function modalPopUpCreationCompleteHandler(event:FlexEvent) : void
      {
         event.target.removeEventListener(FlexEvent.CREATION_COMPLETE,this.modalPopUpCreationCompleteHandler);
         this.addModalPopUpAccessibility(event.currentTarget as DisplayObject);
      }
      
      private function addModalPopUpAccessibility(popUp:DisplayObject) : Boolean
      {
         var p:PopUpData = null;
         var n:int = 0;
         var i:int = 0;
         var sbRoot:Object = null;
         var o:PopUpData = null;
         if(Capabilities.hasAccessibility && Accessibility.active)
         {
            p = this.findPopupInfoByOwner(popUp);
            if(Boolean(p))
            {
               n = int(this.popupInfo.length);
               for(i = 0; i < n; i++)
               {
                  o = this.popupInfo[i];
                  if(Boolean(o) && o != p)
                  {
                     o.owner.accessibilityProperties.silent = true;
                  }
               }
               sbRoot = p.systemManager.getSandboxRoot();
               if(!sbRoot.document.accessibilityProperties)
               {
                  sbRoot.document.accessibilityProperties = new AccessibilityProperties();
               }
               sbRoot.document.accessibilityProperties.silent = true;
               Accessibility.updateProperties();
            }
            return true;
         }
         return false;
      }
      
      private function removeModalPopUpAccessibility(popUp:DisplayObject) : Boolean
      {
         var p:PopUpData = null;
         var sbRoot:Object = null;
         if(Capabilities.hasAccessibility && Accessibility.active)
         {
            p = this.findPopupInfoByOwner(popUp);
            if(Boolean(p))
            {
               this.handleAccessibilityForNestedPopups(popUp);
               if(this.popupInfo.length <= 1)
               {
                  sbRoot = p.systemManager.getSandboxRoot();
                  sbRoot.document.accessibilityProperties.silent = false;
               }
               Accessibility.updateProperties();
            }
            return true;
         }
         return false;
      }
      
      private function handleAccessibilityForNestedPopups(popUpBeingVisited:DisplayObject) : void
      {
         var underneathPopUpData:PopUpData = null;
         var sm:ISystemManager = null;
         var sbRoot:Object = null;
         if(!popUpBeingVisited)
         {
            return;
         }
         var index:int = this.findPopupInfoIndexByOwner(popUpBeingVisited);
         var popupData:PopUpData = index > -1 ? this.popupInfo[index] : null;
         if(index == 0)
         {
            sm = this.getTopLevelSystemManager(popupData.parent);
            if(Boolean(sm))
            {
               sm.document.accessibilityProperties.silent = false;
               sbRoot = popupData.systemManager.getSandboxRoot();
               sbRoot.document.accessibilityProperties.silent = false;
            }
         }
         else if(index > 0)
         {
            underneathPopUpData = this.popupInfo[index - 1];
            underneathPopUpData.owner.accessibilityProperties.silent = false;
            if(Boolean(underneathPopUpData.modalWindow))
            {
               return;
            }
            this.handleAccessibilityForNestedPopups(underneathPopUpData.owner);
         }
      }
   }
}

