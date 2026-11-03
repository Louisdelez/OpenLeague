package mx.managers.marshalClasses
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import mx.core.IUIComponent;
   import mx.core.mx_internal;
   import mx.events.SandboxMouseEvent;
   import mx.managers.PopUpData;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class MarshalPopUpData extends PopUpData
   {
      
      public var isRemoteModalWindow:Boolean;
      
      public var modalTransparencyDuration:Number;
      
      public var modalTransparency:Number;
      
      public var modalTransparencyBlur:Number;
      
      public var modalTransparencyColor:Number;
      
      public var exclude:IUIComponent;
      
      public var useExclude:Boolean;
      
      public var excludeRect:Rectangle;
      
      public var modalMask:Sprite;
      
      public function MarshalPopUpData()
      {
         super();
         this.useExclude = true;
      }
      
      public function marshalMouseOutsideHandler(event:Event) : void
      {
         if(!(event is SandboxMouseEvent))
         {
            event = SandboxMouseEvent.marshal(event);
         }
         if(Boolean(owner))
         {
            owner.dispatchEvent(event);
         }
      }
      
      override public function resizeHandler(event:Event) : void
      {
         var s:Rectangle = null;
         if(Boolean(owner) && Boolean(owner.stage == DisplayObject(event.target).stage) || Boolean(modalWindow) && Boolean(modalWindow.stage == DisplayObject(event.target).stage))
         {
            s = systemManager.screen;
            modalWindow.width = s.width;
            modalWindow.height = s.height;
            modalWindow.x = s.x;
            modalWindow.y = s.y;
            if(Boolean(this.modalMask))
            {
               PopUpManagerMarshalMixin.updateModalMask(systemManager,modalWindow,this.exclude,this.excludeRect,this.modalMask);
            }
         }
      }
   }
}

