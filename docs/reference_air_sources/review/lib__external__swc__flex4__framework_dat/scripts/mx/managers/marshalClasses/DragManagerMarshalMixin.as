package mx.managers.marshalClasses
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import mx.core.DragSource;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.DragEvent;
   import mx.events.InterDragManagerEvent;
   import mx.events.InterManagerRequest;
   import mx.events.Request;
   import mx.managers.DragManagerImpl;
   import mx.managers.IMarshalSystemManager;
   import mx.managers.ISystemManager;
   import mx.managers.SystemManager;
   import mx.managers.SystemManagerGlobals;
   
   use namespace mx_internal;
   
   [Mixin]
   [ExcludeClass]
   public class DragManagerMarshalMixin
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var sm:ISystemManager;
      
      private var sandboxRoot:IEventDispatcher;
      
      private var dragManager:DragManagerImpl;
      
      public function DragManagerMarshalMixin(owner:DragManagerImpl = null)
      {
         super();
         if(!owner)
         {
            return;
         }
         this.dragManager = owner;
         this.dragManager.addEventListener("initialize",this.initializeHandler);
         this.dragManager.addEventListener("doDrag",this.doDragHandler);
         this.dragManager.addEventListener("popUpChildren",this.popUpChildrenHandler);
         this.dragManager.addEventListener("acceptDragDrop",this.acceptDragDropHandler);
         this.dragManager.addEventListener("showFeedback",this.showFeedbackHandler);
         this.dragManager.addEventListener("getFeedback",this.getFeedbackHandler);
         this.dragManager.addEventListener("endDrag",this.endDragHandler);
      }
      
      public static function init(fbs:IFlexModuleFactory) : void
      {
         if(!DragManagerImpl.mixins)
         {
            DragManagerImpl.mixins = [];
         }
         if(DragManagerImpl.mixins.indexOf(DragManagerMarshalMixin) == -1)
         {
            DragManagerImpl.mixins.push(DragManagerMarshalMixin);
         }
      }
      
      public function initializeHandler(event:Event) : void
      {
         var ed:IEventDispatcher = null;
         this.sm = SystemManagerGlobals.topLevelSystemManagers[0];
         if(!this.sm.isTopLevelRoot())
         {
            this.sandboxRoot = this.sm.getSandboxRoot();
            this.sandboxRoot.addEventListener(InterDragManagerEvent.DISPATCH_DRAG_EVENT,this.marshalDispatchEventHandler,false,0,true);
         }
         else
         {
            ed = this.sm;
            this.sandboxRoot = this.sm;
            this.sandboxRoot.addEventListener(InterDragManagerEvent.DISPATCH_DRAG_EVENT,this.marshalDispatchEventHandler,false,0,true);
         }
         this.sandboxRoot.addEventListener(InterManagerRequest.DRAG_MANAGER_REQUEST,this.marshalDragManagerHandler,false,0,true);
         var me:InterManagerRequest = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
         me.name = "update";
         this.sandboxRoot.dispatchEvent(me);
      }
      
      public function doDragHandler(event:Event) : void
      {
         var me:InterManagerRequest = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
         me.name = "isDragging";
         me.value = true;
         this.sandboxRoot.dispatchEvent(me);
         me = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
         me.name = "mouseShield";
         me.value = true;
         this.sandboxRoot.dispatchEvent(me);
      }
      
      public function acceptDragDropHandler(event:Request) : void
      {
         var me:InterManagerRequest = null;
         if(this.dragManager.isDragging)
         {
            me = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
            me.name = "acceptDragDrop";
            me.value = event.value;
            this.sandboxRoot.dispatchEvent(me);
         }
      }
      
      public function showFeedbackHandler(event:Request) : void
      {
         var me:InterManagerRequest = null;
         if(this.dragManager.isDragging)
         {
            me = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
            me.name = "showFeedback";
            me.value = event.value;
            this.sandboxRoot.dispatchEvent(me);
         }
      }
      
      public function getFeedbackHandler(event:Request) : void
      {
         var me:InterManagerRequest = null;
         if(!this.dragManager.dragProxy && this.dragManager.isDragging)
         {
            me = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
            me.name = "getFeedback";
            this.sandboxRoot.dispatchEvent(me);
            event.preventDefault();
            event.value = me.value;
         }
      }
      
      public function popUpChildrenHandler(event:Event) : void
      {
         var mp:IMarshalSystemManager = IMarshalSystemManager(this.sm.getImplementation("mx.managers::IMarshalSystemManager"));
         mp.addChildToSandboxRoot("popUpChildren",this.dragManager.dragProxy);
         event.preventDefault();
      }
      
      public function endDragHandler(event:Event) : void
      {
         var me:InterManagerRequest = null;
         var mp:IMarshalSystemManager = null;
         if(Boolean(this.dragManager.dragProxy))
         {
            mp = IMarshalSystemManager(this.sm.getImplementation("mx.managers::IMarshalSystemManager"));
            mp.removeChildFromSandboxRoot("popUpChildren",this.dragManager.dragProxy);
            this.dragManager.dragProxy.removeChildAt(0);
            this.dragManager.dragProxy = null;
         }
         else if(this.dragManager.isDragging)
         {
            me = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
            me.name = "endDrag";
            this.sandboxRoot.dispatchEvent(me);
         }
         me = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
         me.name = "mouseShield";
         me.value = false;
         this.sandboxRoot.dispatchEvent(me);
         me = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
         me.name = "isDragging";
         me.value = false;
         this.sandboxRoot.dispatchEvent(me);
         event.preventDefault();
      }
      
      private function marshalDispatchEventHandler(event:Event) : void
      {
         if(event is InterDragManagerEvent)
         {
            return;
         }
         var marshalEvent:Object = event;
         var swfRoot:DisplayObject = SystemManager.getSWFRoot(marshalEvent.dropTarget);
         if(!swfRoot)
         {
            return;
         }
         var dragEvent:DragEvent = new DragEvent(marshalEvent.dragEventType,marshalEvent.bubbles,marshalEvent.cancelable);
         dragEvent.localX = marshalEvent.localX;
         dragEvent.localY = marshalEvent.localY;
         dragEvent.action = marshalEvent.action;
         dragEvent.ctrlKey = marshalEvent.ctrlKey;
         dragEvent.altKey = marshalEvent.altKey;
         dragEvent.shiftKey = marshalEvent.shiftKey;
         dragEvent.draggedItem = marshalEvent.draggedItem;
         dragEvent.dragSource = new DragSource();
         var formats:Array = marshalEvent.dragSource.formats;
         var n:int = int(formats.length);
         for(var i:int = 0; i < n; i++)
         {
            dragEvent.dragSource.addData(marshalEvent.dragSource.dataForFormat(formats[i]),formats[i]);
         }
         if(!marshalEvent.dropTarget.dispatchEvent(dragEvent))
         {
            event.preventDefault();
         }
      }
      
      private function marshalDragManagerHandler(event:Event) : void
      {
         var me:InterManagerRequest = null;
         if(event is InterManagerRequest)
         {
            return;
         }
         var marshalEvent:Object = event;
         switch(marshalEvent.name)
         {
            case "isDragging":
               this.dragManager.bDoingDrag = marshalEvent.value;
               break;
            case "acceptDragDrop":
               if(Boolean(this.dragManager.dragProxy))
               {
                  this.dragManager.dragProxy.target = marshalEvent.value;
               }
               break;
            case "showFeedback":
               if(Boolean(this.dragManager.dragProxy))
               {
                  this.dragManager.showFeedback(marshalEvent.value);
               }
               break;
            case "getFeedback":
               if(Boolean(this.dragManager.dragProxy))
               {
                  marshalEvent.value = this.dragManager.getFeedback();
               }
               break;
            case "endDrag":
               this.dragManager.endDrag();
               break;
            case "update":
               if(Boolean(this.dragManager.dragProxy) && this.dragManager.isDragging)
               {
                  me = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
                  me.name = "isDragging";
                  me.value = true;
                  this.sandboxRoot.dispatchEvent(me);
               }
         }
      }
   }
}

