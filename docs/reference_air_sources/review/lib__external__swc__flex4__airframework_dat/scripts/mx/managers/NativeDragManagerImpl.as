package mx.managers
{
   import flash.desktop.Clipboard;
   import flash.desktop.NativeDragManager;
   import flash.desktop.NativeDragOptions;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import flash.events.NativeDragEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.system.Capabilities;
   import flash.utils.getDefinitionByName;
   import mx.core.DragSource;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModule;
   import mx.core.IFlexModuleFactory;
   import mx.core.IUIComponent;
   import mx.core.UIComponentGlobals;
   import mx.events.DragEvent;
   import mx.events.FlexEvent;
   import mx.events.InterDragManagerEvent;
   import mx.events.InterManagerRequest;
   import mx.managers.dragClasses.DragProxy;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.IStyleManager2;
   import mx.styles.StyleManager;
   
   [ExcludeClass]
   public class NativeDragManagerImpl implements IDragManager
   {
      
      private static var sm:ISystemManager;
      
      private static var instance:IDragManager;
      
      public var dragProxy:DragProxy;
      
      private var mouseIsDown:Boolean = false;
      
      private var _action:String;
      
      private var _dragInitiator:IUIComponent;
      
      private var _clipboard:Clipboard;
      
      private var _dragImage:IFlexDisplayObject;
      
      private var _offset:Point;
      
      private var _allowedActions:NativeDragOptions;
      
      private var _allowMove:Boolean;
      
      private var _relatedObject:InteractiveObject;
      
      private var _imageAlpha:Number;
      
      private var sandboxRoot:IEventDispatcher;
      
      private var _dragAutomationHandlerClass:Class;
      
      public function NativeDragManagerImpl()
      {
         super();
         if(Boolean(instance))
         {
            throw new Error("Instance already exists.");
         }
         this.registerSystemManager(sm);
         this.sandboxRoot = sm.getSandboxRoot();
         this.sandboxRoot.addEventListener(InterDragManagerEvent.DISPATCH_DRAG_EVENT,this.marshalDispatchEventHandler,false,0,true);
         this.sandboxRoot.addEventListener(InterManagerRequest.DRAG_MANAGER_REQUEST,this.marshalDragManagerHandler,false,0,true);
         var me:InterManagerRequest = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
         me.name = "update";
         this.sandboxRoot.dispatchEvent(me);
      }
      
      public static function getInstance() : IDragManager
      {
         if(!instance)
         {
            sm = SystemManagerGlobals.topLevelSystemManagers[0];
            instance = new NativeDragManagerImpl();
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
         return NativeDragManager.isDragging;
      }
      
      public function doDrag(dragInitiator:IUIComponent, dragSource:DragSource, mouseEvent:MouseEvent, dragImage:IFlexDisplayObject = null, xOffset:Number = 0, yOffset:Number = 0, imageAlpha:Number = 0.5, allowMove:Boolean = true) : void
      {
         var proxyWidth:Number = NaN;
         var proxyHeight:Number = NaN;
         var format:String = null;
         var dataFetcher:DragDataFormatFetcher = null;
         var dragManagerStyleDeclaration:CSSStyleDeclaration = null;
         var dragImageClass:Class = null;
         if(Boolean(this.dragAutomationHandlerClass))
         {
            this.dragAutomationHandlerClass["storeAIRDragSourceDetails"](dragSource);
         }
         if(this.isDragging)
         {
            return;
         }
         if(!(mouseEvent.type == MouseEvent.MOUSE_DOWN || mouseEvent.type == MouseEvent.CLICK || this.mouseIsDown || mouseEvent.buttonDown))
         {
            return;
         }
         var me:InterManagerRequest = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
         me.name = "isDragging";
         me.value = true;
         this.sandboxRoot.dispatchEvent(me);
         me = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
         me.name = "mouseShield";
         me.value = true;
         this.sandboxRoot.dispatchEvent(me);
         this._clipboard = new Clipboard();
         this._dragInitiator = dragInitiator;
         this._offset = new Point(xOffset,yOffset);
         this._allowMove = allowMove;
         this._imageAlpha = imageAlpha;
         this._offset.y -= InteractiveObject(dragInitiator).mouseY;
         this._offset.x -= InteractiveObject(dragInitiator).mouseX;
         this._allowedActions = new NativeDragOptions();
         this._allowedActions.allowCopy = true;
         this._allowedActions.allowLink = true;
         this._allowedActions.allowMove = allowMove;
         for(var i:int = 0; i < dragSource.formats.length; i++)
         {
            format = dragSource.formats[i] as String;
            dataFetcher = new DragDataFormatFetcher();
            dataFetcher.dragSource = dragSource;
            dataFetcher.format = format;
            this._clipboard.setDataHandler(format,dataFetcher.getDragSourceData,false);
         }
         if(!dragImage)
         {
            dragManagerStyleDeclaration = getStyleManager(dragInitiator).getStyleDeclaration("mx.managers.DragManager");
            dragImageClass = dragManagerStyleDeclaration.getStyle("defaultDragImageSkin");
            dragImage = new dragImageClass();
            proxyWidth = Boolean(dragInitiator) ? Number(dragInitiator.width) : 0;
            proxyHeight = Boolean(dragInitiator) ? Number(dragInitiator.height) : 0;
            if(dragImage is IFlexDisplayObject)
            {
               IFlexDisplayObject(dragImage).setActualSize(proxyWidth,proxyHeight);
            }
         }
         else
         {
            proxyWidth = Number(dragImage.width);
            proxyHeight = Number(dragImage.height);
         }
         this._dragImage = dragImage;
         if(Boolean(this.dragAutomationHandlerClass))
         {
            this.dragAutomationHandlerClass["recordAutomatableDragStart1"](dragInitiator as IUIComponent,mouseEvent);
         }
         if(dragImage is IUIComponent && dragImage is ILayoutManagerClient && !ILayoutManagerClient(dragImage).initialized && Boolean(dragInitiator))
         {
            dragImage.addEventListener(FlexEvent.UPDATE_COMPLETE,this.initiateDrag);
            dragInitiator.systemManager.popUpChildren.addChild(DisplayObject(dragImage));
            if(dragImage is ILayoutManagerClient)
            {
               UIComponentGlobals.layoutManager.validateClient(ILayoutManagerClient(dragImage),true);
            }
            if(dragImage is IUIComponent)
            {
               dragImage.setActualSize(proxyWidth,proxyHeight);
               proxyWidth = Number((dragImage as IUIComponent).getExplicitOrMeasuredWidth());
               proxyHeight = Number((dragImage as IUIComponent).getExplicitOrMeasuredHeight());
            }
            else
            {
               proxyWidth = Number(dragImage.measuredWidth);
               proxyHeight = Number(dragImage.measuredHeight);
            }
            if(dragImage is ILayoutManagerClient)
            {
               UIComponentGlobals.layoutManager.validateClient(ILayoutManagerClient(dragImage));
            }
            return;
         }
         this.initiateDrag(null,false);
      }
      
      private function initiateDrag(event:FlexEvent, removeImage:Boolean = true) : void
      {
         var dragBitmap:BitmapData = null;
         if(removeImage)
         {
            this._dragImage.removeEventListener(FlexEvent.UPDATE_COMPLETE,this.initiateDrag);
         }
         if(Boolean(this._dragImage.width) && Boolean(this._dragImage.height))
         {
            dragBitmap = new BitmapData(this._dragImage.width,this._dragImage.height,true,0);
         }
         else
         {
            dragBitmap = new BitmapData(1,1,true,0);
         }
         var colorTransform:ColorTransform = new ColorTransform();
         colorTransform.alphaMultiplier = this._imageAlpha;
         dragBitmap.draw(this._dragImage,new Matrix(),colorTransform);
         if(removeImage && this._dragImage is IUIComponent && Boolean(this._dragInitiator))
         {
            this._dragInitiator.systemManager.popUpChildren.removeChild(DisplayObject(this._dragImage));
         }
         NativeDragManager.doDrag(InteractiveObject(this._dragInitiator),this._clipboard,dragBitmap,this._offset,this._allowedActions);
      }
      
      public function acceptDragDrop(target:IUIComponent) : void
      {
         var dispObj:InteractiveObject = null;
         var me:InterManagerRequest = null;
         if(this.isDragging)
         {
            dispObj = target as InteractiveObject;
            if(Boolean(dispObj))
            {
               NativeDragManager.acceptDragDrop(dispObj);
            }
         }
         else
         {
            me = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
            me.name = "acceptDragDrop";
            me.value = target;
            this.sandboxRoot.dispatchEvent(me);
         }
      }
      
      public function showFeedback(feedback:String) : void
      {
         var me:InterManagerRequest = null;
         if(this.isDragging)
         {
            if(feedback == DragManager.MOVE && !this._allowedActions.allowMove)
            {
               return;
            }
            if(feedback == DragManager.COPY && !this._allowedActions.allowCopy)
            {
               return;
            }
            if(feedback == DragManager.LINK && !this._allowedActions.allowLink)
            {
               return;
            }
            NativeDragManager.dropAction = feedback;
         }
         else
         {
            me = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
            me.name = "showFeedback";
            me.value = feedback;
            this.sandboxRoot.dispatchEvent(me);
         }
      }
      
      public function getFeedback() : String
      {
         var me:InterManagerRequest = null;
         if(!this.isDragging)
         {
            me = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
            me.name = "getFeedback";
            this.sandboxRoot.dispatchEvent(me);
            return me.value as String;
         }
         return NativeDragManager.dropAction;
      }
      
      public function endDrag() : void
      {
         var me:InterManagerRequest = null;
         me = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
         me.name = "mouseShield";
         me.value = false;
         this.sandboxRoot.dispatchEvent(me);
         me = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
         me.name = "isDragging";
         me.value = false;
         this.sandboxRoot.dispatchEvent(me);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function registerSystemManager(sm:ISystemManager) : void
      {
         if(sm.isTopLevel())
         {
            sm.addEventListener(MouseEvent.MOUSE_DOWN,this.sm_mouseDownHandler);
            sm.addEventListener(MouseEvent.MOUSE_UP,this.sm_mouseUpHandler);
         }
         sm.stage.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,this.nativeDragEventHandler,true);
         sm.stage.addEventListener(NativeDragEvent.NATIVE_DRAG_COMPLETE,this.nativeDragEventHandler,true);
         sm.stage.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,this.nativeDragEventHandler,true);
         sm.stage.addEventListener(NativeDragEvent.NATIVE_DRAG_EXIT,this.nativeDragEventHandler,true);
         sm.stage.addEventListener(NativeDragEvent.NATIVE_DRAG_OVER,this.nativeDragEventHandler,true);
         sm.stage.addEventListener(NativeDragEvent.NATIVE_DRAG_START,this.nativeDragEventHandler,true);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function unregisterSystemManager(sm:ISystemManager) : void
      {
         if(sm.isTopLevel())
         {
            sm.removeEventListener(MouseEvent.MOUSE_DOWN,this.sm_mouseDownHandler);
            sm.removeEventListener(MouseEvent.MOUSE_UP,this.sm_mouseUpHandler);
         }
         sm.stage.removeEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,this.nativeDragEventHandler,true);
         sm.stage.removeEventListener(NativeDragEvent.NATIVE_DRAG_COMPLETE,this.nativeDragEventHandler,true);
         sm.stage.removeEventListener(NativeDragEvent.NATIVE_DRAG_DROP,this.nativeDragEventHandler,true);
         sm.stage.removeEventListener(NativeDragEvent.NATIVE_DRAG_EXIT,this.nativeDragEventHandler,true);
         sm.stage.removeEventListener(NativeDragEvent.NATIVE_DRAG_OVER,this.nativeDragEventHandler,true);
         sm.stage.removeEventListener(NativeDragEvent.NATIVE_DRAG_START,this.nativeDragEventHandler,true);
      }
      
      private function get dragAutomationHandlerClass() : Class
      {
         if(!this._dragAutomationHandlerClass)
         {
            try
            {
               if(Boolean(sm))
               {
                  this._dragAutomationHandlerClass = Class(sm.getDefinitionByName("mx.automation.delegates.DragManagerAutomationImpl"));
               }
               else
               {
                  this._dragAutomationHandlerClass = Class(getDefinitionByName("mx.automation.delegates.DragManagerAutomationImpl"));
               }
            }
            catch(e:Error)
            {
               trace(e.message);
            }
         }
         return this._dragAutomationHandlerClass;
      }
      
      private function sm_mouseDownHandler(event:MouseEvent) : void
      {
         this.mouseIsDown = true;
      }
      
      private function sm_mouseUpHandler(event:MouseEvent) : void
      {
         this.mouseIsDown = false;
      }
      
      private function nativeDragEventHandler(event:NativeDragEvent) : void
      {
         var format:String = null;
         var data:Object = null;
         var me:InterManagerRequest = null;
         var i:int = 0;
         var dataFetcher:DragDataFormatFetcher = null;
         var newType:String = event.type.charAt(6).toLowerCase() + event.type.substr(7);
         var dragSource:DragSource = new DragSource();
         var target:DisplayObject = event.target as DisplayObject;
         var clipboard:Clipboard = event.clipboard;
         var origFormats:Array = clipboard.formats;
         var len:int = int(origFormats.length);
         this._allowedActions = event.allowedActions;
         var ctrlKey:Boolean = false;
         if(Capabilities.os.substring(0,3) == "Mac")
         {
            ctrlKey = Boolean(event.commandKey);
         }
         else
         {
            ctrlKey = Boolean(event.controlKey);
         }
         if(Boolean(NativeDragManager.dragInitiator) && event.type == NativeDragEvent.NATIVE_DRAG_START)
         {
            NativeDragManager.dropAction = ctrlKey || !this._allowMove ? DragManager.COPY : DragManager.MOVE;
         }
         if(event.type != NativeDragEvent.NATIVE_DRAG_EXIT)
         {
            for(i = 0; i < len; i++)
            {
               format = origFormats[i];
               if(clipboard.hasFormat(format))
               {
                  dataFetcher = new DragDataFormatFetcher();
                  dataFetcher.clipboard = clipboard;
                  dataFetcher.format = format;
                  dragSource.addHandler(dataFetcher.getClipboardData,format);
               }
            }
         }
         if(event.type == NativeDragEvent.NATIVE_DRAG_DROP)
         {
            this._relatedObject = event.target as InteractiveObject;
         }
         var dragEvent:DragEvent = new DragEvent(newType,false,event.cancelable,NativeDragManager.dragInitiator as IUIComponent,dragSource,event.dropAction,ctrlKey,event.altKey,event.shiftKey);
         dragEvent.buttonDown = event.buttonDown;
         dragEvent.delta = event.delta;
         dragEvent.localX = event.localX;
         dragEvent.localY = event.localY;
         if(newType == DragEvent.DRAG_COMPLETE)
         {
            dragEvent.relatedObject = this._relatedObject;
         }
         else
         {
            dragEvent.relatedObject = event.relatedObject;
         }
         if(Boolean(this.dragAutomationHandlerClass))
         {
            if(newType == DragEvent.DRAG_DROP)
            {
               this.dragAutomationHandlerClass["recordAutomatableDragDrop1"](target,dragEvent);
            }
            else if(newType == DragEvent.DRAG_COMPLETE)
            {
               this.dragAutomationHandlerClass["recordAutomatableDragCancel1"](NativeDragManager.dragInitiator as IUIComponent,dragEvent);
            }
         }
         this._dispatchDragEvent(target,dragEvent);
         if(newType == DragEvent.DRAG_COMPLETE)
         {
            if(sm == this.sandboxRoot)
            {
               this.endDrag();
            }
            else
            {
               me = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
               me.name = "endDrag";
               this.sandboxRoot.dispatchEvent(me);
            }
         }
      }
      
      private function _dispatchDragEvent(target:DisplayObject, event:DragEvent) : void
      {
         var me:InterManagerRequest = null;
         var mde:InterDragManagerEvent = null;
         if(this.isSameOrChildApplicationDomain(target))
         {
            target.dispatchEvent(event);
         }
         else
         {
            me = new InterManagerRequest(InterManagerRequest.INIT_MANAGER_REQUEST);
            me.name = "mx.managers.IDragManagerImpl";
            this.sandboxRoot.dispatchEvent(me);
            mde = new InterDragManagerEvent(InterDragManagerEvent.DISPATCH_DRAG_EVENT,false,false,event.localX,event.localY,event.relatedObject,event.ctrlKey,event.altKey,event.shiftKey,event.buttonDown,event.delta,target,event.type,event.dragInitiator,event.dragSource,event.action,event.draggedItem);
            this.sandboxRoot.dispatchEvent(mde);
         }
      }
      
      private function isSameOrChildApplicationDomain(target:Object) : Boolean
      {
         var swfRoot:DisplayObject = SystemManager.getSWFRoot(target);
         if(Boolean(swfRoot))
         {
            return true;
         }
         var me:InterManagerRequest = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST);
         me.name = "hasSWFBridges";
         this.sandboxRoot.dispatchEvent(me);
         if(!me.value)
         {
            return true;
         }
         return false;
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
         var dispObj:InteractiveObject = null;
         var me:InterManagerRequest = null;
         if(event is InterManagerRequest)
         {
            return;
         }
         var marshalEvent:Object = event;
         switch(marshalEvent.name)
         {
            case "isDragging":
               break;
            case "acceptDragDrop":
               if(this.isDragging)
               {
                  dispObj = marshalEvent.value as InteractiveObject;
                  if(Boolean(dispObj))
                  {
                     NativeDragManager.acceptDragDrop(dispObj);
                  }
               }
               break;
            case "showFeedback":
               if(this.isDragging)
               {
                  this.showFeedback(marshalEvent.value);
               }
               break;
            case "getFeedback":
               if(this.isDragging)
               {
                  marshalEvent.value = this.getFeedback();
               }
               break;
            case "endDrag":
               this.endDrag();
               break;
            case "update":
               if(this.isDragging)
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

import flash.desktop.Clipboard;
import mx.core.DragSource;

class DragDataFormatFetcher
{
   
   §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
   
   public var clipboard:Clipboard;
   
   public var dragSource:DragSource;
   
   public var format:String;
   
   public function DragDataFormatFetcher()
   {
      super();
   }
   
   public function getClipboardData() : Object
   {
      if(Boolean(this.clipboard))
      {
         return this.clipboard.getData(this.format);
      }
      return null;
   }
   
   public function getDragSourceData() : Object
   {
      if(Boolean(this.dragSource))
      {
         return this.dragSource.dataForFormat(this.format);
      }
      return null;
   }
}
