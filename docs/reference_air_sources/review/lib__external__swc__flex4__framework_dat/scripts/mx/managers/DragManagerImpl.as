package mx.managers
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import mx.core.DragSource;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModule;
   import mx.core.IFlexModuleFactory;
   import mx.core.ILayoutDirectionElement;
   import mx.core.IUIComponent;
   import mx.core.LayoutDirection;
   import mx.core.UIComponentGlobals;
   import mx.core.mx_internal;
   import mx.events.DragEvent;
   import mx.events.Request;
   import mx.managers.dragClasses.DragProxy;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.IStyleManager2;
   import mx.styles.StyleManager;
   import mx.utils.MatrixUtil;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class DragManagerImpl extends EventDispatcher implements IDragManager
   {
      
      private static var sm:ISystemManager;
      
      private static var instance:IDragManager;
      
      public static var mixins:Array;
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var sandboxRoot:IEventDispatcher;
      
      private var dragInitiator:IUIComponent;
      
      public var dragProxy:DragProxy;
      
      public var bDoingDrag:Boolean = false;
      
      private var mouseIsDown:Boolean = false;
      
      public function DragManagerImpl()
      {
         var n:int = 0;
         var i:int = 0;
         super();
         if(Boolean(instance))
         {
            throw new Error("Instance already exists.");
         }
         if(Boolean(mixins))
         {
            n = int(mixins.length);
            for(i = 0; i < n; i++)
            {
               new mixins[i](this);
            }
         }
         this.sandboxRoot = sm.getSandboxRoot();
         if(sm.isTopLevelRoot())
         {
            sm.addEventListener(MouseEvent.MOUSE_DOWN,this.sm_mouseDownHandler,false,0,true);
            sm.addEventListener(MouseEvent.MOUSE_UP,this.sm_mouseUpHandler,false,0,true);
         }
         if(hasEventListener("initialize"))
         {
            dispatchEvent(new Event("initialize"));
         }
      }
      
      public static function getInstance() : IDragManager
      {
         if(!instance)
         {
            sm = SystemManagerGlobals.topLevelSystemManagers[0];
            instance = new DragManagerImpl();
         }
         return instance;
      }
      
      private static function getStyleManager(dragInitiator:IUIComponent) : IStyleManager2
      {
         if(dragInitiator is IFlexModule)
         {
            return StyleManager.getStyleManager(IFlexModule(dragInitiator).moduleFactory);
         }
         return StyleManager.getStyleManager(sm as IFlexModuleFactory);
      }
      
      public function get isDragging() : Boolean
      {
         return this.bDoingDrag;
      }
      
      public function doDrag(dragInitiator:IUIComponent, dragSource:DragSource, mouseEvent:MouseEvent, dragImage:IFlexDisplayObject = null, xOffset:Number = 0, yOffset:Number = 0, imageAlpha:Number = 0.5, allowMove:Boolean = true) : void
      {
         var proxyWidth:Number = NaN;
         var proxyHeight:Number = NaN;
         var e:Event = null;
         var dragManagerStyleDeclaration:CSSStyleDeclaration = null;
         var dragImageClass:Class = null;
         if(this.bDoingDrag)
         {
            return;
         }
         if(!(mouseEvent.type == MouseEvent.MOUSE_DOWN || mouseEvent.type == MouseEvent.CLICK || this.mouseIsDown || mouseEvent.buttonDown))
         {
            return;
         }
         this.bDoingDrag = true;
         if(hasEventListener("doDrag"))
         {
            dispatchEvent(new Event("doDrag"));
         }
         this.dragInitiator = dragInitiator;
         this.dragProxy = new DragProxy(dragInitiator,dragSource);
         if(hasEventListener("popUpChildren"))
         {
            e = new DragEvent("popUpChildren",false,true,this.dragProxy);
         }
         if(!e || dispatchEvent(e))
         {
            sm.popUpChildren.addChild(this.dragProxy);
         }
         if(!dragImage)
         {
            dragManagerStyleDeclaration = getStyleManager(dragInitiator).getMergedStyleDeclaration("mx.managers.DragManager");
            dragImageClass = dragManagerStyleDeclaration.getStyle("defaultDragImageSkin");
            dragImage = new dragImageClass();
            this.dragProxy.addChild(DisplayObject(dragImage));
            proxyWidth = Number(dragInitiator.width);
            proxyHeight = Number(dragInitiator.height);
         }
         else
         {
            this.dragProxy.addChild(DisplayObject(dragImage));
            if(dragImage is ILayoutManagerClient)
            {
               UIComponentGlobals.layoutManager.validateClient(ILayoutManagerClient(dragImage),true);
            }
            if(dragImage is IUIComponent)
            {
               proxyWidth = (dragImage as IUIComponent).getExplicitOrMeasuredWidth();
               proxyHeight = (dragImage as IUIComponent).getExplicitOrMeasuredHeight();
            }
            else
            {
               proxyWidth = dragImage.measuredWidth;
               proxyHeight = dragImage.measuredHeight;
            }
         }
         if(dragInitiator is ILayoutDirectionElement && ILayoutDirectionElement(dragInitiator).layoutDirection == LayoutDirection.RTL)
         {
            this.dragProxy.layoutDirection = LayoutDirection.RTL;
         }
         dragImage.setActualSize(proxyWidth,proxyHeight);
         this.dragProxy.setActualSize(proxyWidth,proxyHeight);
         this.dragProxy.alpha = imageAlpha;
         this.dragProxy.allowMove = allowMove;
         var concatenatedMatrix:Matrix = MatrixUtil.getConcatenatedMatrix(DisplayObject(dragInitiator),DisplayObject(this.sandboxRoot));
         concatenatedMatrix.tx = 0;
         concatenatedMatrix.ty = 0;
         var m:Matrix = dragImage.transform.matrix;
         if(Boolean(m))
         {
            concatenatedMatrix.concat(dragImage.transform.matrix);
            dragImage.transform.matrix = concatenatedMatrix;
         }
         var nonNullTarget:Object = mouseEvent.target;
         if(nonNullTarget == null)
         {
            nonNullTarget = dragInitiator;
         }
         var point:Point = new Point(mouseEvent.localX,mouseEvent.localY);
         point = DisplayObject(nonNullTarget).localToGlobal(point);
         point = DisplayObject(this.sandboxRoot).globalToLocal(point);
         var mouseX:Number = point.x;
         var mouseY:Number = point.y;
         var proxyOrigin:Point = DisplayObject(dragInitiator).localToGlobal(new Point(-xOffset,-yOffset));
         proxyOrigin = DisplayObject(this.sandboxRoot).globalToLocal(proxyOrigin);
         this.dragProxy.xOffset = mouseX - proxyOrigin.x;
         this.dragProxy.yOffset = mouseY - proxyOrigin.y;
         this.dragProxy.x = proxyOrigin.x;
         this.dragProxy.y = proxyOrigin.y;
         this.dragProxy.startX = this.dragProxy.x;
         this.dragProxy.startY = this.dragProxy.y;
         if(dragImage is DisplayObject)
         {
            DisplayObject(dragImage).cacheAsBitmap = true;
         }
         var delegate:Object = this.dragProxy.automationDelegate;
         if(Boolean(delegate))
         {
            delegate.recordAutomatableDragStart(dragInitiator,mouseEvent);
         }
      }
      
      public function acceptDragDrop(target:IUIComponent) : void
      {
         if(Boolean(this.dragProxy))
         {
            this.dragProxy.target = target as DisplayObject;
         }
         if(hasEventListener("acceptDragDrop"))
         {
            dispatchEvent(new Request("acceptDragDrop",false,false,target));
         }
      }
      
      public function showFeedback(feedback:String) : void
      {
         if(Boolean(this.dragProxy))
         {
            if(feedback == DragManager.MOVE && !this.dragProxy.allowMove)
            {
               feedback = DragManager.COPY;
            }
            this.dragProxy.action = feedback;
         }
         if(hasEventListener("showFeedback"))
         {
            dispatchEvent(new Request("showFeedback",false,false,feedback));
         }
      }
      
      public function getFeedback() : String
      {
         var request:Request = null;
         if(hasEventListener("getFeedback"))
         {
            request = new Request("getFeedback",false,true);
            if(!dispatchEvent(request))
            {
               return request.value as String;
            }
         }
         return Boolean(this.dragProxy) ? this.dragProxy.action : DragManager.NONE;
      }
      
      public function endDrag() : void
      {
         var e:Event = null;
         if(hasEventListener("endDrag"))
         {
            e = new Event("endDrag",false,true);
         }
         if(!e || dispatchEvent(e))
         {
            if(Boolean(this.dragProxy))
            {
               sm.popUpChildren.removeChild(this.dragProxy);
               if(this.dragProxy.numChildren > 0)
               {
                  this.dragProxy.removeChildAt(0);
               }
               this.dragProxy = null;
            }
         }
         this.dragInitiator = null;
         this.bDoingDrag = false;
      }
      
      private function sm_mouseDownHandler(event:MouseEvent) : void
      {
         this.mouseIsDown = true;
      }
      
      private function sm_mouseUpHandler(event:MouseEvent) : void
      {
         this.mouseIsDown = false;
      }
   }
}

