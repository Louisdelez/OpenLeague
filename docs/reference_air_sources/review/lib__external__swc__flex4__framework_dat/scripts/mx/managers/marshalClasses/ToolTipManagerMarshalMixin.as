package mx.managers.marshalClasses
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import mx.core.IFlexModuleFactory;
   import mx.core.IToolTip;
   import mx.core.mx_internal;
   import mx.events.DynamicEvent;
   import mx.events.InterManagerRequest;
   import mx.events.ToolTipEvent;
   import mx.managers.IMarshalSystemManager;
   import mx.managers.ISystemManager;
   import mx.managers.SystemManagerGlobals;
   import mx.managers.ToolTipManagerImpl;
   
   use namespace mx_internal;
   
   [Mixin]
   [ExcludeClass]
   public class ToolTipManagerMarshalMixin
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var toolTipManager:ToolTipManagerImpl;
      
      private var systemManager:ISystemManager;
      
      private var sandboxRoot:DisplayObject;
      
      private var mp:IMarshalSystemManager;
      
      public function ToolTipManagerMarshalMixin(owner:ToolTipManagerImpl = null)
      {
         super();
         if(!owner)
         {
            return;
         }
         this.toolTipManager = owner;
         this.toolTipManager.addEventListener("initialize",this.initializeHandler);
         this.toolTipManager.addEventListener("currentToolTip",this.currentToolTipHandler);
         this.toolTipManager.addEventListener(ToolTipEvent.TOOL_TIP_HIDE,this.toolTipHideHandler);
         this.toolTipManager.addEventListener("createTip",this.createTipHandler);
         this.toolTipManager.addEventListener("removeChild",this.removeChildHandler);
         this.toolTipManager.addEventListener("addChild",this.addChildHandler);
      }
      
      public static function init(fbs:IFlexModuleFactory) : void
      {
         if(!ToolTipManagerImpl.mixins)
         {
            ToolTipManagerImpl.mixins = [];
         }
         if(ToolTipManagerImpl.mixins.indexOf(ToolTipManagerMarshalMixin) == -1)
         {
            ToolTipManagerImpl.mixins.push(ToolTipManagerMarshalMixin);
         }
      }
      
      public function initializeHandler(event:Event) : void
      {
         this.systemManager = SystemManagerGlobals.topLevelSystemManagers[0] as ISystemManager;
         this.mp = IMarshalSystemManager(this.systemManager.getImplementation("mx.managers::IMarshalSystemManager"));
         this.sandboxRoot = this.systemManager.getSandboxRoot();
         this.sandboxRoot.addEventListener(InterManagerRequest.TOOLTIP_MANAGER_REQUEST,this.marshalToolTipManagerHandler,false,0,true);
         var me:InterManagerRequest = new InterManagerRequest(InterManagerRequest.TOOLTIP_MANAGER_REQUEST);
         me.name = "update";
         this.sandboxRoot.dispatchEvent(me);
      }
      
      public function currentToolTipHandler(event:Event) : void
      {
         var me:InterManagerRequest = new InterManagerRequest(InterManagerRequest.TOOLTIP_MANAGER_REQUEST);
         me.name = "currentToolTip";
         me.value = this.toolTipManager.currentToolTip;
         this.sandboxRoot.dispatchEvent(me);
      }
      
      public function toolTipHideHandler(event:Event) : void
      {
         var me:InterManagerRequest = new InterManagerRequest(InterManagerRequest.TOOLTIP_MANAGER_REQUEST);
         me.name = ToolTipEvent.TOOL_TIP_HIDE;
         this.sandboxRoot.dispatchEvent(me);
      }
      
      public function createTipHandler(event:Event) : void
      {
         var sm:ISystemManager = this.toolTipManager.getSystemManager(this.toolTipManager.currentTarget) as ISystemManager;
         this.mp = IMarshalSystemManager(sm.topLevelSystemManager.getImplementation("mx.managers::IMarshalSystemManager"));
         this.mp.addChildToSandboxRoot("toolTipChildren",this.toolTipManager.currentToolTip as DisplayObject);
         event.preventDefault();
      }
      
      public function removeChildHandler(event:DynamicEvent) : void
      {
         var sm:ISystemManager = event.sm;
         this.mp = IMarshalSystemManager(sm.topLevelSystemManager.getImplementation("mx.managers::IMarshalSystemManager"));
         this.mp.removeChildFromSandboxRoot("toolTipChildren",event.toolTip as DisplayObject);
         event.preventDefault();
      }
      
      public function addChildHandler(event:DynamicEvent) : void
      {
         var sm:ISystemManager = event.sm;
         this.mp = IMarshalSystemManager(sm.topLevelSystemManager.getImplementation("mx.managers::IMarshalSystemManager"));
         this.mp.addChildToSandboxRoot("toolTipChildren",event.toolTip as DisplayObject);
         event.preventDefault();
      }
      
      private function marshalToolTipManagerHandler(event:Event) : void
      {
         var me:InterManagerRequest = null;
         if(event is InterManagerRequest)
         {
            return;
         }
         var marshalEvent:Object = event;
         switch(marshalEvent.name)
         {
            case "currentToolTip":
               this.toolTipManager._currentToolTip = marshalEvent.value;
               break;
            case ToolTipEvent.TOOL_TIP_HIDE:
               if(this.toolTipManager._currentToolTip is IToolTip)
               {
                  this.toolTipManager.hideTip();
               }
               break;
            case "update":
               event.stopImmediatePropagation();
               me = new InterManagerRequest(InterManagerRequest.TOOLTIP_MANAGER_REQUEST);
               me.name = "currentToolTip";
               me.value = this.toolTipManager._currentToolTip;
               this.sandboxRoot.dispatchEvent(me);
         }
      }
   }
}

