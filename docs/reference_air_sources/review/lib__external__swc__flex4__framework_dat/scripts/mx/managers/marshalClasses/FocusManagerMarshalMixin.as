package mx.managers.marshalClasses
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.IEventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import mx.core.IFlexModuleFactory;
   import mx.core.ISWFBridgeProvider;
   import mx.core.ISWFLoader;
   import mx.core.SWFBridgeGroup;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.FocusRequestDirection;
   import mx.events.SWFBridgeEvent;
   import mx.events.SWFBridgeRequest;
   import mx.managers.FocusManager;
   import mx.managers.IMarshalSystemManager;
   import mx.managers.ISystemManager;
   import mx.managers.SystemManagerProxy;
   
   use namespace mx_internal;
   
   [Mixin]
   [ExcludeClass]
   public class FocusManagerMarshalMixin
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var focusSetLocally:Boolean;
      
      private var focusManager:FocusManager;
      
      private var marshalSystemManager:IMarshalSystemManager;
      
      private var swfBridgeGroup:SWFBridgeGroup;
      
      private var lastActiveFocusManager:FocusManager;
      
      private var skipBridge:IEventDispatcher;
      
      public function FocusManagerMarshalMixin(owner:FocusManager = null)
      {
         super();
         if(!owner)
         {
            return;
         }
         this.focusManager = owner;
         this.marshalSystemManager = IMarshalSystemManager(this.focusManager.form.systemManager.getImplementation("mx.managers::IMarshalSystemManager"));
         this.focusManager.addEventListener("initialize",this.initializeHandler);
         this.focusManager.addEventListener("showFocusIndicator",this.showFocusIndicatorHandler);
         this.focusManager.addEventListener("setFocus",this.setFocusHandler);
         this.focusManager.addEventListener(FocusEvent.FOCUS_IN,this.focusInHandler);
         this.focusManager.addEventListener("activateFM",this.activateHandler);
         this.focusManager.addEventListener("deactivateFM",this.deactivateHandler);
         this.focusManager.addEventListener("focusWrapping",this.focusWrappingHandler);
         this.focusManager.addEventListener("setFocusToComponent",this.setFocusToComponentHandler);
         this.focusManager.addEventListener("setFocusToNextIndex",this.focusWrappingHandler);
         this.focusManager.addEventListener("getTopLevelFocusTarget",this.getTopLevelFocusTargetHandler);
         this.focusManager.addEventListener("keyFocusChange",this.keyFocusChangeHandler);
         this.focusManager.addEventListener("browserFocusComponent",this.browserFocusComponentHandler);
         this.focusManager.addEventListener("keyDownFM",this.keyDownHandler);
         this.focusManager.addEventListener("defaultButtonKeyHandler",this.defaultButtonKeyHandler);
         this.focusManager.addEventListener("mouseDownFM",this.mouseDownHandler);
         this.focusManager.addEventListener("addChildBridge",this.addChildBridgeHandler);
         this.focusManager.addEventListener("removeChildBridge",this.removeChildBridgeHandler);
         this.focusManager.addEventListener(FlexEvent.FLEX_WINDOW_ACTIVATE,this.forwardWindowActivationEventsToChildrenHandler);
         this.focusManager.addEventListener(FlexEvent.FLEX_WINDOW_DEACTIVATE,this.forwardWindowActivationEventsToChildrenHandler);
      }
      
      public static function init(fbs:IFlexModuleFactory) : void
      {
         if(!FocusManager.mixins)
         {
            FocusManager.mixins = [];
         }
         if(FocusManager.mixins.indexOf(FocusManagerMarshalMixin) == -1)
         {
            FocusManager.mixins.push(FocusManagerMarshalMixin);
         }
      }
      
      public function initializeHandler(event:Event) : void
      {
         var sm:ISystemManager = null;
         var bridge:IEventDispatcher = null;
         try
         {
            sm = this.focusManager.form.systemManager;
            this.swfBridgeGroup = new SWFBridgeGroup(sm);
            if(!this.focusManager.popup)
            {
               this.swfBridgeGroup.parentBridge = this.marshalSystemManager.swfBridgeGroup.parentBridge;
            }
            if(this.marshalSystemManager.useSWFBridge())
            {
               sm.addEventListener(SWFBridgeEvent.BRIDGE_APPLICATION_UNLOADING,this.removeFromParentBridge);
               bridge = this.swfBridgeGroup.parentBridge;
               if(Boolean(bridge))
               {
                  bridge.addEventListener(SWFBridgeRequest.MOVE_FOCUS_REQUEST,this.focusRequestMoveHandler);
                  bridge.addEventListener(SWFBridgeRequest.SET_SHOW_FOCUS_INDICATOR_REQUEST,this.setShowFocusIndicatorRequestHandler);
                  bridge.addEventListener(SWFBridgeEvent.BRIDGE_AIR_WINDOW_ACTIVATE,this.windowActivationEventHandler);
                  bridge.addEventListener(SWFBridgeEvent.BRIDGE_AIR_WINDOW_DEACTIVATE,this.windowActivationEventHandler);
               }
               if(Boolean(bridge) && !(this.focusManager.form.systemManager is SystemManagerProxy))
               {
                  bridge.addEventListener(SWFBridgeRequest.ACTIVATE_FOCUS_REQUEST,this.focusRequestActivateHandler);
                  bridge.addEventListener(SWFBridgeRequest.DEACTIVATE_FOCUS_REQUEST,this.focusRequestDeactivateHandler);
                  bridge.addEventListener(SWFBridgeEvent.BRIDGE_FOCUS_MANAGER_ACTIVATE,this.bridgeEventActivateHandler);
               }
               this.focusManager.form.addEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function addedToStageHandler(event:Event) : void
      {
         this.focusManager.form.removeEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler);
         if(this.focusManager.focusableObjects.length == 0)
         {
            this.focusManager.addFocusables(DisplayObject(this.focusManager.form));
            this.focusManager.calculateCandidates = true;
         }
      }
      
      private function setFocusHandler(event:Event) : void
      {
         this.focusSetLocally = true;
      }
      
      public function showFocusIndicatorHandler(event:Event) : void
      {
         if(!this.focusManager.popup && Boolean(this.swfBridgeGroup))
         {
            this.dispatchSetShowFocusIndicatorRequest(this.focusManager.showFocusIndicator,null);
         }
      }
      
      public function focusInHandler(event:FocusEvent) : void
      {
         if(this.marshalSystemManager.isDisplayObjectInABridgedApplication(DisplayObject(event.relatedObject)))
         {
            event.preventDefault();
         }
      }
      
      public function activateHandler(event:Event) : void
      {
         this.dispatchEventFromSWFBridges(new SWFBridgeRequest(SWFBridgeRequest.ACTIVATE_FOCUS_REQUEST),this.skipBridge);
      }
      
      public function deactivateHandler(event:Event) : void
      {
         this.dispatchEventFromSWFBridges(new SWFBridgeRequest(SWFBridgeRequest.DEACTIVATE_FOCUS_REQUEST),this.skipBridge);
      }
      
      public function focusWrappingHandler(event:FocusEvent) : void
      {
         if(Boolean(this.getParentBridge()))
         {
            this.moveFocusToParent(event.shiftKey);
            event.preventDefault();
         }
      }
      
      public function setFocusToComponentHandler(event:FocusEvent) : void
      {
         var request:SWFBridgeRequest = null;
         var sandboxBridge:IEventDispatcher = null;
         var o:Object = event.relatedObject;
         if(o is ISWFLoader && Boolean(ISWFLoader(o).swfBridge))
         {
            request = new SWFBridgeRequest(SWFBridgeRequest.MOVE_FOCUS_REQUEST,false,true,null,event.shiftKey ? FocusRequestDirection.BOTTOM : FocusRequestDirection.TOP);
            sandboxBridge = ISWFLoader(o).swfBridge;
            if(Boolean(sandboxBridge))
            {
               sandboxBridge.dispatchEvent(request);
               this.focusManager.focusChanged = request.data;
            }
            event.preventDefault();
         }
      }
      
      public function getTopLevelFocusTargetHandler(event:FocusEvent) : void
      {
         var o:Object = event.relatedObject;
         if(o is ISWFLoader)
         {
            if(Boolean(ISWFLoader(o).swfBridge))
            {
               event.preventDefault();
            }
         }
      }
      
      public function keyFocusChangeHandler(event:FocusEvent) : void
      {
         var o:Object = event.relatedObject;
         if(this.marshalSystemManager.isDisplayObjectInABridgedApplication(DisplayObject(o)))
         {
            event.preventDefault();
         }
      }
      
      public function browserFocusComponentHandler(event:FocusEvent) : void
      {
         if(this.marshalSystemManager.useSWFBridge())
         {
            this.moveFocusToParent(event.shiftKey);
            if(this.focusManager.focusChanged)
            {
               event.preventDefault();
            }
         }
      }
      
      public function keyDownHandler(event:FocusEvent) : void
      {
         if(this.marshalSystemManager.isDisplayObjectInABridgedApplication(DisplayObject(event.relatedObject)))
         {
            event.preventDefault();
         }
      }
      
      public function defaultButtonKeyHandler(event:FocusEvent) : void
      {
         if(this.marshalSystemManager.isDisplayObjectInABridgedApplication(DisplayObject(event.relatedObject)))
         {
            event.preventDefault();
         }
      }
      
      public function mouseDownHandler(event:FocusEvent) : void
      {
         var o:Object = event.relatedObject;
         if(!this.focusManager.lastFocus && o is IEventDispatcher && this.marshalSystemManager.useSWFBridge())
         {
            IEventDispatcher(o).dispatchEvent(new FocusEvent(FocusEvent.FOCUS_IN));
         }
         this.dispatchActivatedFocusManagerEvent(null);
         this.lastActiveFocusManager = this.focusManager;
      }
      
      private function focusRequestMoveHandler(event:Event) : void
      {
         var startingPosition:DisplayObject = null;
         if(event is SWFBridgeRequest)
         {
            return;
         }
         this.focusSetLocally = false;
         var request:SWFBridgeRequest = SWFBridgeRequest.marshal(event);
         if(request.data == FocusRequestDirection.TOP || request.data == FocusRequestDirection.BOTTOM)
         {
            if(this.focusManager.focusableObjects.length == 0)
            {
               this.moveFocusToParent(request.data == FocusRequestDirection.TOP ? false : true);
               event["data"] = this.focusManager.focusChanged;
               return;
            }
            if(request.data == FocusRequestDirection.TOP)
            {
               this.setFocusToTop();
            }
            else
            {
               this.setFocusToBottom();
            }
            event["data"] = this.focusManager.focusChanged;
         }
         else
         {
            startingPosition = DisplayObject(this.swfBridgeGroup.getChildBridgeProvider(IEventDispatcher(event.target)));
            this.moveFocus(request.data as String,startingPosition);
            event["data"] = this.focusManager.focusChanged;
         }
         if(this.focusSetLocally)
         {
            this.dispatchActivatedFocusManagerEvent(null);
            this.lastActiveFocusManager = this.focusManager;
         }
      }
      
      private function focusRequestActivateHandler(event:Event) : void
      {
         this.skipBridge = IEventDispatcher(event.target);
         this.focusManager.activate();
         this.skipBridge = null;
      }
      
      private function focusRequestDeactivateHandler(event:Event) : void
      {
         this.skipBridge = IEventDispatcher(event.target);
         this.focusManager.deactivate();
         this.skipBridge = null;
      }
      
      private function bridgeEventActivateHandler(event:Event) : void
      {
         if(event is SWFBridgeEvent)
         {
            return;
         }
         this.lastActiveFocusManager = null;
         this.focusManager.lastFocus = null;
         this.dispatchActivatedFocusManagerEvent(IEventDispatcher(event.target));
      }
      
      private function setShowFocusIndicatorRequestHandler(event:Event) : void
      {
         if(event is SWFBridgeRequest)
         {
            return;
         }
         var request:SWFBridgeRequest = SWFBridgeRequest.marshal(event);
         this.focusManager._showFocusIndicator = request.data;
         this.dispatchSetShowFocusIndicatorRequest(this.focusManager.showFocusIndicator,IEventDispatcher(event.target));
      }
      
      public function addSWFBridge(bridge:IEventDispatcher, owner:DisplayObject) : void
      {
         if(!owner)
         {
            return;
         }
         var sm:ISystemManager = this.focusManager.form.systemManager;
         if(this.focusManager.focusableObjects.indexOf(owner) == -1)
         {
            this.focusManager.focusableObjects.push(owner);
            this.focusManager.calculateCandidates = true;
         }
         this.swfBridgeGroup.addChildBridge(bridge,ISWFBridgeProvider(owner));
         bridge.addEventListener(SWFBridgeRequest.MOVE_FOCUS_REQUEST,this.focusRequestMoveHandler);
         bridge.addEventListener(SWFBridgeRequest.SET_SHOW_FOCUS_INDICATOR_REQUEST,this.setShowFocusIndicatorRequestHandler);
         bridge.addEventListener(SWFBridgeEvent.BRIDGE_FOCUS_MANAGER_ACTIVATE,this.bridgeEventActivateHandler);
      }
      
      public function removeSWFBridge(bridge:IEventDispatcher) : void
      {
         var index:int = 0;
         var sm:ISystemManager = this.focusManager.form.systemManager;
         var displayObject:DisplayObject = DisplayObject(this.swfBridgeGroup.getChildBridgeProvider(bridge));
         if(Boolean(displayObject))
         {
            index = this.focusManager.focusableObjects.indexOf(displayObject);
            if(index != -1)
            {
               this.focusManager.focusableObjects.splice(index,1);
               this.focusManager.calculateCandidates = true;
            }
            bridge.removeEventListener(SWFBridgeEvent.BRIDGE_AIR_WINDOW_ACTIVATE,this.windowActivationEventHandler);
            bridge.removeEventListener(SWFBridgeEvent.BRIDGE_AIR_WINDOW_DEACTIVATE,this.windowActivationEventHandler);
            bridge.removeEventListener(SWFBridgeRequest.MOVE_FOCUS_REQUEST,this.focusRequestMoveHandler);
            bridge.removeEventListener(SWFBridgeRequest.SET_SHOW_FOCUS_INDICATOR_REQUEST,this.setShowFocusIndicatorRequestHandler);
            bridge.removeEventListener(SWFBridgeEvent.BRIDGE_FOCUS_MANAGER_ACTIVATE,this.bridgeEventActivateHandler);
            this.swfBridgeGroup.removeChildBridge(bridge);
            return;
         }
         throw new Error();
      }
      
      private function removeFromParentBridge(event:Event) : void
      {
         var bridge:IEventDispatcher = null;
         var sm:ISystemManager = this.focusManager.form.systemManager;
         if(this.marshalSystemManager.useSWFBridge())
         {
            sm.removeEventListener(SWFBridgeEvent.BRIDGE_APPLICATION_UNLOADING,this.removeFromParentBridge);
            bridge = this.swfBridgeGroup.parentBridge;
            if(Boolean(bridge))
            {
               bridge.removeEventListener(SWFBridgeRequest.MOVE_FOCUS_REQUEST,this.focusRequestMoveHandler);
               bridge.removeEventListener(SWFBridgeRequest.SET_SHOW_FOCUS_INDICATOR_REQUEST,this.setShowFocusIndicatorRequestHandler);
            }
            if(Boolean(bridge) && !(this.focusManager.form.systemManager is SystemManagerProxy))
            {
               bridge.removeEventListener(SWFBridgeRequest.ACTIVATE_FOCUS_REQUEST,this.focusRequestActivateHandler);
               bridge.removeEventListener(SWFBridgeRequest.DEACTIVATE_FOCUS_REQUEST,this.focusRequestDeactivateHandler);
               bridge.removeEventListener(SWFBridgeEvent.BRIDGE_FOCUS_MANAGER_ACTIVATE,this.bridgeEventActivateHandler);
            }
         }
      }
      
      private function moveFocusToParent(shiftKey:Boolean) : Boolean
      {
         var request:SWFBridgeRequest = new SWFBridgeRequest(SWFBridgeRequest.MOVE_FOCUS_REQUEST,false,true,null,shiftKey ? FocusRequestDirection.BACKWARD : FocusRequestDirection.FORWARD);
         var sandboxBridge:IEventDispatcher = this.marshalSystemManager.swfBridgeGroup.parentBridge;
         sandboxBridge.dispatchEvent(request);
         this.focusManager.focusChanged = request.data;
         return this.focusManager.focusChanged;
      }
      
      private function getParentBridge() : IEventDispatcher
      {
         if(Boolean(this.swfBridgeGroup))
         {
            return this.swfBridgeGroup.parentBridge;
         }
         return null;
      }
      
      private function dispatchSetShowFocusIndicatorRequest(value:Boolean, skip:IEventDispatcher) : void
      {
         var request:SWFBridgeRequest = new SWFBridgeRequest(SWFBridgeRequest.SET_SHOW_FOCUS_INDICATOR_REQUEST,false,false,null,value);
         this.dispatchEventFromSWFBridges(request,skip);
      }
      
      private function dispatchActivatedFocusManagerEvent(skip:IEventDispatcher = null) : void
      {
         if(this.lastActiveFocusManager == this.focusManager)
         {
            return;
         }
         var event:SWFBridgeEvent = new SWFBridgeEvent(SWFBridgeEvent.BRIDGE_FOCUS_MANAGER_ACTIVATE);
         this.dispatchEventFromSWFBridges(event,skip);
      }
      
      private function dispatchEventFromSWFBridges(event:Event, skip:IEventDispatcher = null) : void
      {
         var clone:Event = null;
         var parentBridge:IEventDispatcher = null;
         var sm:ISystemManager = this.focusManager.form.systemManager;
         if(!this.focusManager.popup)
         {
            parentBridge = this.swfBridgeGroup.parentBridge;
            if(Boolean(parentBridge) && parentBridge != skip)
            {
               clone = event.clone();
               if(clone is SWFBridgeRequest)
               {
                  SWFBridgeRequest(clone).requestor = parentBridge;
               }
               parentBridge.dispatchEvent(clone);
            }
         }
         var children:Array = this.swfBridgeGroup.getChildBridges();
         for(var i:int = 0; i < children.length; i++)
         {
            if(children[i] != skip)
            {
               clone = event.clone();
               if(clone is SWFBridgeRequest)
               {
                  SWFBridgeRequest(clone).requestor = IEventDispatcher(children[i]);
               }
               IEventDispatcher(children[i]).dispatchEvent(clone);
            }
         }
      }
      
      public function moveFocus(direction:String, fromDisplayObject:DisplayObject = null) : void
      {
         if(direction == FocusRequestDirection.TOP)
         {
            this.setFocusToTop();
            return;
         }
         if(direction == FocusRequestDirection.BOTTOM)
         {
            this.setFocusToBottom();
            return;
         }
         var keyboardEvent:KeyboardEvent = new KeyboardEvent(KeyboardEvent.KEY_DOWN);
         keyboardEvent.keyCode = Keyboard.TAB;
         keyboardEvent.shiftKey = direction == FocusRequestDirection.FORWARD ? false : true;
         this.focusManager.fauxFocus = fromDisplayObject;
         this.focusManager.keyDownHandler(keyboardEvent);
         var focusEvent:FocusEvent = new FocusEvent(FocusEvent.KEY_FOCUS_CHANGE);
         focusEvent.keyCode = Keyboard.TAB;
         focusEvent.shiftKey = direction == FocusRequestDirection.FORWARD ? false : true;
         this.focusManager.keyFocusChangeHandler(focusEvent);
         this.focusManager.fauxFocus = null;
      }
      
      private function setFocusToTop() : void
      {
         this.focusManager.setFocusToNextIndex(-1,false);
      }
      
      private function setFocusToBottom() : void
      {
         this.focusManager.setFocusToNextIndex(this.focusManager.focusableObjects.length,true);
      }
      
      private function addChildBridgeHandler(event:Event) : void
      {
         var bridge:IEventDispatcher = event["bridge"];
         this.addSWFBridge(bridge,event["owner"]);
      }
      
      private function removeChildBridgeHandler(event:Event) : void
      {
         var bridge:IEventDispatcher = event["bridge"];
         this.removeSWFBridge(bridge);
      }
      
      private function forwardWindowActivationEventsToChildrenHandler(event:Event) : void
      {
         var ourEvent:SWFBridgeEvent = null;
         if(event.type == FlexEvent.FLEX_WINDOW_ACTIVATE)
         {
            ourEvent = new SWFBridgeEvent(SWFBridgeEvent.BRIDGE_AIR_WINDOW_ACTIVATE);
         }
         else if(event.type == FlexEvent.FLEX_WINDOW_DEACTIVATE)
         {
            ourEvent = new SWFBridgeEvent(SWFBridgeEvent.BRIDGE_AIR_WINDOW_DEACTIVATE);
         }
         this.dispatchEventFromSWFBridges(ourEvent,this.swfBridgeGroup.parentBridge);
      }
      
      private function windowActivationEventHandler(event:Event) : void
      {
         var ourEvent:FlexEvent = null;
         if(event.type == SWFBridgeEvent.BRIDGE_AIR_WINDOW_ACTIVATE)
         {
            ourEvent = new FlexEvent(FlexEvent.FLEX_WINDOW_ACTIVATE);
         }
         else if(event.type == SWFBridgeEvent.BRIDGE_AIR_WINDOW_DEACTIVATE)
         {
            ourEvent = new FlexEvent(FlexEvent.FLEX_WINDOW_DEACTIVATE);
         }
         this.focusManager.dispatchEvent(ourEvent);
         if(Boolean(this.focusManager.lastFocus) && !this.focusManager.browserMode)
         {
            this.focusManager.lastFocus.setFocus();
         }
         this.focusManager.lastAction = "ACTIVATE";
      }
   }
}

