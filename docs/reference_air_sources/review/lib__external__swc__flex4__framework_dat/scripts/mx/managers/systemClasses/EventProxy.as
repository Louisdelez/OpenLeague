package mx.managers.systemClasses
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import mx.events.SandboxMouseEvent;
   import mx.managers.IMarshalSystemManager;
   import mx.managers.ISystemManager;
   import mx.utils.EventUtil;
   
   [ExcludeClass]
   public class EventProxy extends EventDispatcher
   {
      
      private var marshalSystemManager:IMarshalSystemManager;
      
      private var systemManager:ISystemManager;
      
      public function EventProxy(systemManager:ISystemManager)
      {
         super();
         this.systemManager = systemManager;
      }
      
      public function marshalListener(event:Event) : void
      {
         var me:MouseEvent = null;
         var mme:SandboxMouseEvent = null;
         if(event is MouseEvent)
         {
            me = event as MouseEvent;
            mme = new SandboxMouseEvent(EventUtil.mouseEventMap[event.type],false,false,me.ctrlKey,me.altKey,me.shiftKey,me.buttonDown);
            if(!this.marshalSystemManager)
            {
               this.marshalSystemManager = IMarshalSystemManager(this.systemManager.getImplementation("mx.managers::IMarshalSystemManager"));
            }
            this.marshalSystemManager.dispatchEventFromSWFBridges(mme,null,true,true);
         }
         else if(event.type == Event.MOUSE_LEAVE)
         {
            mme = new SandboxMouseEvent(SandboxMouseEvent.MOUSE_UP_SOMEWHERE);
            if(!this.marshalSystemManager)
            {
               this.marshalSystemManager = IMarshalSystemManager(this.systemManager.getImplementation("mx.managers::IMarshalSystemManager"));
            }
            this.marshalSystemManager.dispatchEventFromSWFBridges(mme,null,true,true);
            this.systemManager.dispatchEvent(mme);
         }
      }
   }
}

