package spark.components
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import mx.events.CloseEvent;
   import mx.events.FlexEvent;
   import mx.events.SandboxMouseEvent;
   import mx.utils.BitFlagUtil;
   import spark.events.TitleWindowBoundsEvent;
   
   [DiscouragedForProfile("mobileDevice")]
   [AccessibilityClass(implementation="spark.accessibility.TitleWindowAccImpl")]
   [IconFile("TitleWindow.png")]
   [SkinState("inactiveWithControlBar")]
   [SkinState("inactive")]
   [Event(name="windowMoveEnd",type="spark.events.TitleWindowBoundsEvent")]
   [Event(name="windowMove",type="spark.events.TitleWindowBoundsEvent")]
   [Event(name="windowMoving",type="spark.events.TitleWindowBoundsEvent")]
   [Event(name="windowMoveStart",type="spark.events.TitleWindowBoundsEvent")]
   [Event(name="close",type="mx.events.CloseEvent")]
   public class TitleWindow extends Panel
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var _skinParts:Object = {
         "moveArea":false,
         "contentGroup":false,
         "controlBarGroup":false,
         "titleDisplay":false,
         "closeButton":false
      };
      
      private var addedHandlers:Boolean = false;
      
      private var active:Boolean = false;
      
      private var offsetX:Number;
      
      private var offsetY:Number;
      
      private var startBounds:Rectangle;
      
      [SkinPart(required="false")]
      public var closeButton:Button;
      
      [SkinPart(required="false")]
      public var moveArea:InteractiveObject;
      
      public function TitleWindow()
      {
         super();
      }
      
      override protected function initializeAccessibility() : void
      {
         if(TitleWindow.createAccessibilityImplementation != null)
         {
            TitleWindow.createAccessibilityImplementation(this);
         }
      }
      
      override public function parentChanged(p:DisplayObjectContainer) : void
      {
         if(Boolean(focusManager))
         {
            focusManager.removeEventListener(FlexEvent.FLEX_WINDOW_ACTIVATE,this.activateHandler);
            focusManager.removeEventListener(FlexEvent.FLEX_WINDOW_DEACTIVATE,this.deactivateHandler);
         }
         super.parentChanged(p);
         if(Boolean(focusManager))
         {
            this.addActivateHandlers();
         }
         else if(Boolean(systemManager))
         {
            systemManager.getSandboxRoot().addEventListener(FlexEvent.ADD_FOCUS_MANAGER,this.addFocusManagerHandler,true,0,true);
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler);
         }
      }
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         super.partAdded(partName,instance);
         if(instance == this.moveArea)
         {
            this.moveArea.addEventListener(MouseEvent.MOUSE_DOWN,this.moveArea_mouseDownHandler);
         }
         else if(instance == this.closeButton)
         {
            this.closeButton.focusEnabled = false;
            this.closeButton.addEventListener(MouseEvent.CLICK,this.closeButton_clickHandler);
         }
      }
      
      override protected function partRemoved(partName:String, instance:Object) : void
      {
         super.partRemoved(partName,instance);
         if(instance == this.moveArea)
         {
            this.moveArea.removeEventListener(MouseEvent.MOUSE_DOWN,this.moveArea_mouseDownHandler);
         }
         else if(instance == this.closeButton)
         {
            this.closeButton.removeEventListener(MouseEvent.CLICK,this.closeButton_clickHandler);
         }
      }
      
      override protected function getCurrentSkinState() : String
      {
         var state:String = null;
         if(enabled && Boolean(isPopUp) && !this.active)
         {
            state = "inactive";
            if(Boolean(controlBarGroup))
            {
               if(Boolean(BitFlagUtil.isSet(controlBarGroupProperties as uint,CONTROLBAR_PROPERTY_FLAG)) && Boolean(BitFlagUtil.isSet(controlBarGroupProperties as uint,VISIBLE_PROPERTY_FLAG)))
               {
                  state += "WithControlBar";
               }
            }
            else if(Boolean(controlBarGroupProperties.controlBarContent) && Boolean(controlBarGroupProperties.visible))
            {
               state += "WithControlBar";
            }
            return state;
         }
         return super.getCurrentSkinState();
      }
      
      override public function move(x:Number, y:Number) : void
      {
         var beforeBounds:Rectangle = new Rectangle(this.x,this.y,width,height);
         super.move(x,y);
         var afterBounds:Rectangle = new Rectangle(this.x,this.y,width,height);
         var e2:TitleWindowBoundsEvent = new TitleWindowBoundsEvent(TitleWindowBoundsEvent.WINDOW_MOVE,false,false,beforeBounds,afterBounds);
         dispatchEvent(e2);
      }
      
      protected function closeButton_clickHandler(event:MouseEvent) : void
      {
         dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
      }
      
      protected function moveArea_mouseDownHandler(event:MouseEvent) : void
      {
         var sbRoot:DisplayObject = null;
         if(enabled && Boolean(isPopUp))
         {
            this.offsetX = event.stageX - x;
            this.offsetY = event.stageY - y;
            sbRoot = systemManager.getSandboxRoot();
            sbRoot.addEventListener(MouseEvent.MOUSE_MOVE,this.moveArea_mouseMoveHandler,true);
            sbRoot.addEventListener(MouseEvent.MOUSE_UP,this.moveArea_mouseUpHandler,true);
            sbRoot.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.moveArea_mouseUpHandler);
            systemManager.deployMouseShields(true);
         }
      }
      
      protected function moveArea_mouseMoveHandler(event:MouseEvent) : void
      {
         var startEvent:TitleWindowBoundsEvent = null;
         var sbRoot:DisplayObject = null;
         if(!this.startBounds)
         {
            this.startBounds = new Rectangle(x,y,width,height);
            startEvent = new TitleWindowBoundsEvent(TitleWindowBoundsEvent.WINDOW_MOVE_START,false,true,this.startBounds,null);
            dispatchEvent(startEvent);
            if(startEvent.isDefaultPrevented())
            {
               sbRoot = systemManager.getSandboxRoot();
               sbRoot.removeEventListener(MouseEvent.MOUSE_MOVE,this.moveArea_mouseMoveHandler,true);
               sbRoot.removeEventListener(MouseEvent.MOUSE_UP,this.moveArea_mouseUpHandler,true);
               sbRoot.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.moveArea_mouseUpHandler);
               systemManager.deployMouseShields(false);
               this.offsetX = NaN;
               this.offsetY = NaN;
               this.startBounds = null;
               return;
            }
         }
         var beforeBounds:Rectangle = new Rectangle(x,y,width,height);
         var afterBounds:Rectangle = new Rectangle(Math.round(event.stageX - this.offsetX),Math.round(event.stageY - this.offsetY),width,height);
         var e1:TitleWindowBoundsEvent = new TitleWindowBoundsEvent(TitleWindowBoundsEvent.WINDOW_MOVING,false,true,beforeBounds,afterBounds);
         dispatchEvent(e1);
         if(!e1.isDefaultPrevented())
         {
            this.move(afterBounds.x,afterBounds.y);
         }
         event.updateAfterEvent();
      }
      
      protected function moveArea_mouseUpHandler(event:Event) : void
      {
         var endEvent:TitleWindowBoundsEvent = null;
         var sbRoot:DisplayObject = systemManager.getSandboxRoot();
         sbRoot.removeEventListener(MouseEvent.MOUSE_MOVE,this.moveArea_mouseMoveHandler,true);
         sbRoot.removeEventListener(MouseEvent.MOUSE_UP,this.moveArea_mouseUpHandler,true);
         sbRoot.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.moveArea_mouseUpHandler);
         systemManager.deployMouseShields(false);
         if(Boolean(this.startBounds))
         {
            endEvent = new TitleWindowBoundsEvent(TitleWindowBoundsEvent.WINDOW_MOVE_END,false,false,this.startBounds,new Rectangle(x,y,width,height));
            dispatchEvent(endEvent);
            this.startBounds = null;
         }
         this.offsetX = NaN;
         this.offsetY = NaN;
      }
      
      private function activateHandler(event:Event) : void
      {
         this.active = true;
         invalidateSkinState();
      }
      
      private function deactivateHandler(event:Event) : void
      {
         this.active = false;
         invalidateSkinState();
      }
      
      private function addActivateHandlers() : void
      {
         focusManager.addEventListener(FlexEvent.FLEX_WINDOW_ACTIVATE,this.activateHandler,false,0,true);
         focusManager.addEventListener(FlexEvent.FLEX_WINDOW_DEACTIVATE,this.deactivateHandler,false,0,true);
      }
      
      private function addedToStageHandler(event:Event) : void
      {
         if(event.target == this)
         {
            removeEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler);
            callLater(this.addActivateHandlers);
         }
      }
      
      private function addFocusManagerHandler(event:Event) : void
      {
         if(focusManager == event.target["focusManager"])
         {
            systemManager.getSandboxRoot().removeEventListener(FlexEvent.ADD_FOCUS_MANAGER,this.addFocusManagerHandler,true);
            this.addActivateHandlers();
         }
      }
   }
}

