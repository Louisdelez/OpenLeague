package flexlib.containers
{
   import flash.display.Graphics;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import mx.containers.HBox;
   import mx.containers.TitleWindow;
   import mx.controls.Image;
   import mx.core.UIComponent;
   import mx.managers.PopUpManager;
   
   [Style(name="dragStripIcon",type="String",inherit="no")]
   [Event(name="float",type="flash.events.Event")]
   [Event(name="dock",type="flash.events.Event")]
   public class DockableToolBar extends FlowContainer
   {
      
      public var initialPosition:String = "top";
      
      private var _isDocked:Boolean = true;
      
      public var draggable:Boolean = true;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var docker:Docker;
      
      private var dragStrip:Image;
      
      private var regY:Number;
      
      [Embed(source="../assets/dragStripIcon.png")]
      private var dragStripIconClass:Class = DockableToolBar_dragStripIconClass;
      
      private var regX:Number;
      
      private var estimatedWidth:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var rowCount:int = -1;
      
      protected var floatingWindow:TitleWindow;
      
      public function DockableToolBar()
      {
         super();
         horizontalScrollPolicy = "off";
         verticalScrollPolicy = "off";
      }
      
      public function get isDocked() : Boolean
      {
         return _isDocked;
      }
      
      override public function getExplicitOrMeasuredWidth() : Number
      {
         return Math.min(systemManager.screen.width,super.getExplicitOrMeasuredWidth());
      }
      
      protected function mouseMoveHandler(event:MouseEvent) : void
      {
         var overDockingArea:Boolean = false;
         var g:Graphics = null;
         var wrapFactor:Number = NaN;
         var dragObject:UIComponent = null;
         overDockingArea = docker.dragOver(this,event);
         g = docker.dragProxy.graphics;
         g.lineStyle(1,0,0.5);
         g.beginFill(16777215,0.45);
         wrapFactor = _isDocked && !overDockingArea ? measuredWidth / estimatedWidth : 1;
         dragObject = UIComponent(_isDocked ? this : parent);
         g.drawRect(event.stageX - regX / wrapFactor,event.stageY - regY,dragObject.width / wrapFactor,dragObject.height * wrapFactor);
         g.endFill();
      }
      
      protected function updateFloatingStatus(event:MouseEvent) : void
      {
         var pt:Point = null;
         if(_isDocked && Boolean(floatingWindow))
         {
            pt = localToGlobal(new Point(x,y));
            floatingWindow.x = event.stageX;
            floatingWindow.y = pt.y;
            floatingWindow.getTitleBar().removeEventListener("mouseDown",mouseDownHandler);
            PopUpManager.removePopUp(floatingWindow);
            floatingWindow = null;
            dragStrip.visible = dragStrip.includeInLayout = true;
            dispatchEvent(new Event("dock"));
         }
         else if(!_isDocked && !floatingWindow)
         {
            floatingWindow = new PopUpToolBar();
            floatingWindow.title = label;
            floatingWindow.horizontalScrollPolicy = "off";
            floatingWindow.verticalScrollPolicy = "off";
            pt = localToGlobal(new Point(0,0));
            floatingWindow.x = pt.x;
            floatingWindow.y = pt.y;
            floatingWindow.width = estimatedWidth;
            PopUpManager.addPopUp(floatingWindow,docker);
            if(parent is HBox && parent.numChildren == 1)
            {
               parent.parent.removeChild(parent);
            }
            parent.removeChild(this);
            dragStrip.visible = dragStrip.includeInLayout = false;
            floatingWindow.addChild(this);
            floatingWindow.validateNow();
            dispatchEvent(new Event("float"));
         }
      }
      
      protected function mouseUpHandler(event:MouseEvent) : void
      {
         var prevDocked:Boolean = false;
         var s:int = 0;
         prevDocked = _isDocked;
         _isDocked = docker.dragOver(this,event,true);
         updateFloatingStatus(event);
         UIComponent(parent).invalidateDisplayList();
         if(Boolean(floatingWindow))
         {
            s = prevDocked && !_isDocked ? 2 : 1;
            floatingWindow.x = event.stageX - regX / s;
            floatingWindow.y = event.stageY - regY;
            floatingWindow.getTitleBar().addEventListener("mouseDown",mouseDownHandler);
            if(floatingWindow.x < -floatingWindow.width / 2)
            {
               floatingWindow.x = -floatingWindow.width / 2;
            }
            if(floatingWindow.x > systemManager.screen.width - floatingWindow.width / 2)
            {
               floatingWindow.x = systemManager.screen.width - floatingWindow.width / 2;
            }
         }
         stopDragging(event);
      }
      
      protected function mouseDownHandler(event:MouseEvent) : void
      {
         var pt:Point = null;
         var area:int = 0;
         if(!docker)
         {
            return;
         }
         pt = (Boolean(floatingWindow) ? floatingWindow : this).globalToLocal(new Point(event.stageX,event.stageY));
         regX = pt.x;
         regY = pt.y;
         systemManager.addEventListener("mouseMove",mouseMoveHandler);
         systemManager.addEventListener("mouseUp",mouseUpHandler);
         systemManager.stage.addEventListener(Event.MOUSE_LEAVE,stopDragging);
         if(measuredWidth > 200 || !isNaN(percentWidth))
         {
            area = measuredHeight * measuredWidth;
            estimatedWidth = Math.max(Math.sqrt(area) * 1.6,measuredMinWidth);
         }
         else
         {
            estimatedWidth = measuredWidth;
         }
         event.stopPropagation();
      }
      
      override protected function createChildren() : void
      {
         var iconStyle:Object = null;
         super.createChildren();
         if(draggable)
         {
            if(!dragStrip)
            {
               dragStrip = new Image();
               iconStyle = getStyle("dragStripIcon");
               if(Boolean(iconStyle))
               {
                  dragStrip.source = iconStyle;
               }
               else
               {
                  dragStrip.source = dragStripIconClass;
               }
               dragStrip.toolTip = "Drag to move the Toolbar";
               addChildAt(dragStrip,0);
            }
            dragStrip.addEventListener("mouseDown",mouseDownHandler);
         }
      }
      
      protected function stopDragging(event:Event) : void
      {
         docker.dragProxy.graphics.clear();
         systemManager.removeEventListener("mouseUp",mouseUpHandler);
         systemManager.removeEventListener("mouseMove",mouseMoveHandler);
         systemManager.stage.removeEventListener(Event.MOUSE_LEAVE,stopDragging);
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         if(Boolean(dragStrip) && unscaledWidth < dragStrip.getExplicitOrMeasuredWidth())
         {
            return;
         }
         layoutObject.rowCount = isDocked ? (isNaN(explicitWidth) ? 1 : rowCount) : -1;
         layoutObject.modifyTargetHeight = !_isDocked;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
      }
   }
}

