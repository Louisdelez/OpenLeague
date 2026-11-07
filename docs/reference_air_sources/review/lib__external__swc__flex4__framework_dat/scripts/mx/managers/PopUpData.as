package mx.managers
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import mx.effects.Effect;
   
   [ExcludeClass]
   public class PopUpData
   {
      
      public var owner:DisplayObject;
      
      public var parent:DisplayObject;
      
      public var topMost:Boolean;
      
      public var modalWindow:DisplayObject;
      
      public var _mouseDownOutsideHandler:Function;
      
      public var _mouseWheelOutsideHandler:Function;
      
      public var fade:Effect;
      
      public var blur:Effect;
      
      public var blurTarget:Object;
      
      public var systemManager:ISystemManager;
      
      public function PopUpData()
      {
         super();
      }
      
      public function mouseDownOutsideHandler(event:MouseEvent) : void
      {
         this._mouseDownOutsideHandler(this.owner,event);
      }
      
      public function mouseWheelOutsideHandler(event:MouseEvent) : void
      {
         this._mouseWheelOutsideHandler(this.owner,event);
      }
      
      public function resizeHandler(event:Event) : void
      {
         var s:Rectangle = ISystemManager(event.target).screen;
         if(Boolean(this.modalWindow) && this.owner.stage == DisplayObject(event.target).stage)
         {
            this.modalWindow.width = s.width;
            this.modalWindow.height = s.height;
            this.modalWindow.x = s.x;
            this.modalWindow.y = s.y;
         }
      }
   }
}

