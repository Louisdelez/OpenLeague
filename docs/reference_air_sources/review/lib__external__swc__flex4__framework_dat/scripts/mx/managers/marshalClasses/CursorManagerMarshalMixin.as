package mx.managers.marshalClasses
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import flash.ui.Mouse;
   import mx.core.EventPriority;
   import mx.core.FlexSprite;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.InterManagerRequest;
   import mx.events.Request;
   import mx.events.SWFBridgeRequest;
   import mx.events.SandboxMouseEvent;
   import mx.managers.CursorManagerImpl;
   import mx.managers.IMarshalSystemManager;
   import mx.managers.ISystemManager;
   
   use namespace mx_internal;
   
   [Mixin]
   [ExcludeClass]
   public class CursorManagerMarshalMixin
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var cursorManager:CursorManagerImpl;
      
      private var mp:IMarshalSystemManager;
      
      public function CursorManagerMarshalMixin(owner:CursorManagerImpl = null)
      {
         super();
         if(!owner)
         {
            return;
         }
         this.cursorManager = owner;
         this.mp = IMarshalSystemManager(this.systemManager.getImplementation("mx.managers::IMarshalSystemManager"));
         this.sandboxRoot.addEventListener(InterManagerRequest.CURSOR_MANAGER_REQUEST,this.marshalCursorManagerHandler,false,0,true);
         var me:InterManagerRequest = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
         me.name = "update";
         this.sandboxRoot.dispatchEvent(me);
         this.cursorManager.addEventListener("currentCursorID",this.currentCursorIDHandler);
         this.cursorManager.addEventListener("currentCursorXOffset",this.currentCursorXOffsetHandler);
         this.cursorManager.addEventListener("currentCursorYOffset",this.currentCursorYOffsetHandler);
         this.cursorManager.addEventListener("showCursor",this.showCursorHandler);
         this.cursorManager.addEventListener("hideCursor",this.hideCursorHandler);
         this.cursorManager.addEventListener("setCursor",this.setCursorHandler);
         this.cursorManager.addEventListener("removeCursor",this.removeCursorHandler);
         this.cursorManager.addEventListener("removeAllCursors",this.removeAllCursorsHandler);
         this.cursorManager.addEventListener("setBusyCursor",this.setBusyCursorHandler);
         this.cursorManager.addEventListener("removeBusyCursor",this.removeBusyCursorHandler);
         this.cursorManager.addEventListener("initialize",this.initializeHandler);
         this.cursorManager.addEventListener("addMouseMoveListener",this.addMouseMoveListenerHandler);
         this.cursorManager.addEventListener("addMouseOutListener",this.addMouseOutListenerHandler);
         this.cursorManager.addEventListener("removeMouseMoveListener",this.removeMouseMoveListenerHandler);
         this.cursorManager.addEventListener("removeMouseOutListener",this.removeMouseOutListenerHandler);
         this.cursorManager.addEventListener("registerToUseBusyCursor",this.registerToUseBusyCursorHandler);
         this.cursorManager.addEventListener("unRegisterToUseBusyCursor",this.unRegisterToUseBusyCursorHandler);
         this.cursorManager.addEventListener("showCustomCursor",this.showCustomCursorHandler);
      }
      
      public static function init(fbs:IFlexModuleFactory) : void
      {
         if(!CursorManagerImpl.mixins)
         {
            CursorManagerImpl.mixins = [];
         }
         if(CursorManagerImpl.mixins.indexOf(CursorManagerMarshalMixin) == -1)
         {
            CursorManagerImpl.mixins.push(CursorManagerMarshalMixin);
         }
      }
      
      private function get initialized() : Boolean
      {
         return this.cursorManager.initialized;
      }
      
      private function get sandboxRoot() : DisplayObject
      {
         return this.cursorManager.systemManager.getSandboxRoot();
      }
      
      private function get systemManager() : ISystemManager
      {
         return this.cursorManager.systemManager;
      }
      
      private function get cursorHolder() : Sprite
      {
         return this.cursorManager.cursorHolder;
      }
      
      private function set cursorHolder(value:Sprite) : void
      {
         this.cursorManager.cursorHolder = value;
      }
      
      public function initializeHandler(event:Event) : void
      {
         this.cursorHolder = new FlexSprite();
         this.cursorHolder.name = "cursorHolder";
         this.cursorHolder.mouseEnabled = false;
         this.cursorHolder.mouseChildren = false;
         this.mp.addChildToSandboxRoot("cursorChildren",this.cursorHolder);
         var me:InterManagerRequest = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
         me.name = "initialized";
         this.sandboxRoot.dispatchEvent(me);
         event.preventDefault();
      }
      
      public function currentCursorIDHandler(event:Event) : void
      {
         var me:InterManagerRequest = null;
         if(!this.cursorHolder)
         {
            me = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
            me.name = "currentCursorID";
            me.value = this.cursorManager.currentCursorID;
            this.sandboxRoot.dispatchEvent(me);
         }
      }
      
      public function currentCursorXOffsetHandler(event:Event) : void
      {
         var me:InterManagerRequest = null;
         if(!this.cursorHolder)
         {
            me = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
            me.name = "currentCursorXOffset";
            me.value = this.cursorManager.currentCursorXOffset;
            this.sandboxRoot.dispatchEvent(me);
         }
      }
      
      public function currentCursorYOffsetHandler(event:Event) : void
      {
         var me:InterManagerRequest = null;
         if(!this.cursorHolder)
         {
            me = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
            me.name = "currentCursorYOffset";
            me.value = this.cursorManager.currentCursorYOffset;
            this.sandboxRoot.dispatchEvent(me);
         }
      }
      
      public function showCursorHandler(event:Event) : void
      {
         var me:InterManagerRequest = null;
         if(!this.cursorHolder)
         {
            me = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
            me.name = "showCursor";
            this.sandboxRoot.dispatchEvent(me);
         }
      }
      
      public function hideCursorHandler(event:Event) : void
      {
         var me:InterManagerRequest = null;
         if(!this.cursorHolder)
         {
            me = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
            me.name = "hideCursor";
            this.sandboxRoot.dispatchEvent(me);
         }
      }
      
      public function setCursorHandler(event:Request) : void
      {
         var me:InterManagerRequest = null;
         if(this.initialized && !this.cursorHolder)
         {
            me = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
            me.name = "setCursor";
            me.value = event.value;
            this.sandboxRoot.dispatchEvent(me);
            event.value = me.value;
            event.preventDefault();
         }
      }
      
      public function removeCursorHandler(event:Request) : void
      {
         var me:InterManagerRequest = null;
         if(this.initialized && !this.cursorHolder)
         {
            me = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
            me.name = "removeCursor";
            me.value = event.value;
            this.sandboxRoot.dispatchEvent(me);
            event.preventDefault();
         }
      }
      
      public function removeAllCursorsHandler(event:Event) : void
      {
         var me:InterManagerRequest = null;
         if(this.initialized && !this.cursorHolder)
         {
            me = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
            me.name = "removeAllCursors";
            this.sandboxRoot.dispatchEvent(me);
            event.preventDefault();
         }
      }
      
      public function setBusyCursorHandler(event:Event) : void
      {
         var me:InterManagerRequest = null;
         if(this.initialized && !this.cursorHolder)
         {
            me = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
            me.name = "setBusyCursor";
            this.sandboxRoot.dispatchEvent(me);
            event.preventDefault();
         }
      }
      
      public function removeBusyCursorHandler(event:Event) : void
      {
         var me:InterManagerRequest = null;
         if(this.initialized && !this.cursorHolder)
         {
            me = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
            me.name = "removeBusyCursor";
            this.sandboxRoot.dispatchEvent(me);
            event.preventDefault();
         }
      }
      
      public function registerToUseBusyCursorHandler(event:Request) : void
      {
         var me:InterManagerRequest = null;
         if(this.initialized && !this.cursorHolder)
         {
            me = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
            me.name = "registerToUseBusyCursor";
            me.value = event.value;
            this.sandboxRoot.dispatchEvent(me);
            event.preventDefault();
         }
      }
      
      public function unRegisterToUseBusyCursorHandler(event:Request) : void
      {
         var me:InterManagerRequest = null;
         if(this.initialized && !this.cursorHolder)
         {
            me = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
            me.name = "unRegisterToUseBusyCursor";
            me.value = event.value;
            this.sandboxRoot.dispatchEvent(me);
            event.preventDefault();
         }
      }
      
      public function addMouseOutListenerHandler(event:Event) : void
      {
         if(this.mp.useSWFBridge())
         {
            this.sandboxRoot.addEventListener(MouseEvent.MOUSE_OUT,this.cursorManager.mouseOutHandler,true,EventPriority.CURSOR_MANAGEMENT);
            event.preventDefault();
         }
      }
      
      public function addMouseMoveListenerHandler(event:Event) : void
      {
         if(this.mp.useSWFBridge())
         {
            this.sandboxRoot.addEventListener(MouseEvent.MOUSE_MOVE,this.cursorManager.mouseMoveHandler,true,EventPriority.CURSOR_MANAGEMENT);
            this.sandboxRoot.addEventListener(SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE,this.marshalMouseMoveHandler,false,EventPriority.CURSOR_MANAGEMENT);
            event.preventDefault();
         }
      }
      
      public function removeMouseMoveListenerHandler(event:Event) : void
      {
         if(this.mp.useSWFBridge())
         {
            this.sandboxRoot.removeEventListener(MouseEvent.MOUSE_MOVE,this.cursorManager.mouseMoveHandler,true);
            this.sandboxRoot.removeEventListener(SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE,this.marshalMouseMoveHandler,false);
            event.preventDefault();
         }
      }
      
      public function removeMouseOutListenerHandler(event:Event) : void
      {
         if(this.mp.useSWFBridge())
         {
            this.sandboxRoot.removeEventListener(MouseEvent.MOUSE_OUT,this.cursorManager.mouseOutHandler,true);
            event.preventDefault();
         }
      }
      
      private function marshalMouseMoveHandler(event:Event) : void
      {
         var cursorRequest:SWFBridgeRequest = null;
         var bridge:IEventDispatcher = null;
         if(this.cursorHolder.visible)
         {
            this.cursorHolder.visible = false;
            cursorRequest = new SWFBridgeRequest(SWFBridgeRequest.SHOW_MOUSE_CURSOR_REQUEST);
            if(this.mp.useSWFBridge())
            {
               bridge = this.mp.swfBridgeGroup.parentBridge;
            }
            else
            {
               bridge = this.systemManager;
            }
            cursorRequest.requestor = bridge;
            bridge.dispatchEvent(cursorRequest);
            if(Boolean(cursorRequest.data))
            {
               Mouse.show();
            }
         }
      }
      
      private function showCustomCursorHandler(event:Event) : void
      {
         var bridge:IEventDispatcher = null;
         var cursorRequest:SWFBridgeRequest = new SWFBridgeRequest(SWFBridgeRequest.HIDE_MOUSE_CURSOR_REQUEST);
         if(this.mp.useSWFBridge())
         {
            bridge = this.mp.swfBridgeGroup.parentBridge;
         }
         else
         {
            bridge = this.systemManager;
         }
         cursorRequest.requestor = bridge;
         bridge.dispatchEvent(cursorRequest);
      }
      
      private function marshalCursorManagerHandler(event:Event) : void
      {
         var me:InterManagerRequest = null;
         if(event is InterManagerRequest)
         {
            return;
         }
         var marshalEvent:Object = event;
         switch(marshalEvent.name)
         {
            case "initialized":
               this.cursorManager.initialized = marshalEvent.value;
               break;
            case "currentCursorID":
               this.cursorManager._currentCursorID = marshalEvent.value;
               break;
            case "currentCursorXOffset":
               this.cursorManager._currentCursorXOffset = marshalEvent.value;
               break;
            case "currentCursorYOffset":
               this.cursorManager._currentCursorYOffset = marshalEvent.value;
               break;
            case "showCursor":
               if(Boolean(this.cursorHolder))
               {
                  this.cursorHolder.visible = true;
               }
               break;
            case "hideCursor":
               if(Boolean(this.cursorHolder))
               {
                  this.cursorHolder.visible = false;
               }
               break;
            case "setCursor":
               if(Boolean(this.cursorHolder))
               {
                  marshalEvent.value = this.cursorManager.setCursor.apply(this.cursorManager,marshalEvent.value);
               }
               break;
            case "removeCursor":
               if(Boolean(this.cursorHolder))
               {
                  this.cursorManager.removeCursor.apply(this.cursorManager,[marshalEvent.value]);
               }
               break;
            case "removeAllCursors":
               if(Boolean(this.cursorHolder))
               {
                  this.cursorManager.removeAllCursors();
               }
               break;
            case "setBusyCursor":
               if(Boolean(this.cursorHolder))
               {
                  this.cursorManager.setBusyCursor();
               }
               break;
            case "removeBusyCursor":
               if(Boolean(this.cursorHolder))
               {
                  this.cursorManager.removeBusyCursor();
               }
               break;
            case "registerToUseBusyCursor":
               if(Boolean(this.cursorHolder))
               {
                  this.cursorManager.registerToUseBusyCursor.apply(this,marshalEvent.value);
               }
               break;
            case "unRegisterToUseBusyCursor":
               if(Boolean(this.cursorHolder))
               {
                  this.cursorManager.unRegisterToUseBusyCursor.apply(this,marshalEvent.value);
               }
               break;
            case "update":
               if(Boolean(this.cursorHolder))
               {
                  me = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
                  me.name = "initialized";
                  me.value = true;
                  this.sandboxRoot.dispatchEvent(me);
                  me = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
                  me.name = "currentCursorID";
                  me.value = this.cursorManager.currentCursorID;
                  this.sandboxRoot.dispatchEvent(me);
                  me = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
                  me.name = "currentCursorXOffset";
                  me.value = this.cursorManager.currentCursorXOffset;
                  this.sandboxRoot.dispatchEvent(me);
                  me = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
                  me.name = "currentCursorYOffset";
                  me.value = this.cursorManager.currentCursorYOffset;
                  this.sandboxRoot.dispatchEvent(me);
               }
         }
      }
   }
}

