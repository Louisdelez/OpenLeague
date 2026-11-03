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
   import flash.geom.Point;
   import flash.system.Capabilities;
   import mx.core.DragSource;
   import mx.core.IFlexDisplayObject;
   import mx.core.IUIComponent;
   import mx.core.UIComponentGlobals;
   import mx.events.DragEvent;
   import mx.events.FlexEvent;
   import mx.events.InterDragManagerEvent;
   import mx.events.InterManagerRequest;
   import mx.managers.dragClasses.DragProxy;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   [ExcludeClass]
   public class NativeDragManagerImpl implements IDragManager
   {
      
      private static var sm:ISystemManager;
      
      private static var instance:IDragManager;
      
      private var _dragImage:IFlexDisplayObject;
      
      private var sandboxRoot:IEventDispatcher;
      
      private var _relatedObject:InteractiveObject;
      
      private var _allowedActions:NativeDragOptions;
      
      private var _action:String;
      
      private var _clipboard:Clipboard;
      
      public var dragProxy:DragProxy;
      
      private var _dragInitiator:IUIComponent;
      
      private var mouseIsDown:Boolean = false;
      
      private var _offset:Point;
      
      private var _allowMove:Boolean;
      
      public function NativeDragManagerImpl()
      {
         super();
         if(Boolean(instance))
         {
            throw new Error("Instance already exists.");
         }
         registerSystemManager(sm);
         sandboxRoot = sm.getSandboxRoot();
         sandboxRoot.addEventListener(InterDragManagerEvent.DISPATCH_DRAG_EVENT,marshalDispatchEventHandler,false,0,true);
         sandboxRoot.addEventListener(InterManagerRequest.DRAG_MANAGER_REQUEST,marshalDragManagerHandler,false,0,true);
         var me:InterManagerRequest = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
         me.name = "update";
         sandboxRoot.dispatchEvent(me);
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
      
      public function getFeedback() : String
      {
         var me:InterManagerRequest = null;
         if(!isDragging)
         {
            me = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
            me.name = "getFeedback";
            sandboxRoot.dispatchEvent(me);
            return me.value as String;
         }
         return NativeDragManager.dropAction;
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
               if(isDragging)
               {
                  dispObj = marshalEvent.value as InteractiveObject;
                  if(Boolean(dispObj))
                  {
                     NativeDragManager.acceptDragDrop(dispObj);
                  }
               }
               break;
            case "showFeedback":
               if(isDragging)
               {
                  showFeedback(marshalEvent.value);
               }
               break;
            case "getFeedback":
               if(isDragging)
               {
                  marshalEvent.value = getFeedback();
               }
               break;
            case "endDrag":
               endDrag();
               break;
            case "update":
               if(isDragging)
               {
                  me = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
                  me.name = "isDragging";
                  me.value = true;
                  sandboxRoot.dispatchEvent(me);
               }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function unregisterSystemManager(sm:ISystemManager) : void
      {
         if(sm.isTopLevel())
         {
            sm.removeEventListener(MouseEvent.MOUSE_DOWN,sm_mouseDownHandler);
            sm.removeEventListener(MouseEvent.MOUSE_UP,sm_mouseUpHandler);
         }
         sm.stage.removeEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,nativeDragEventHandler,true);
         sm.stage.removeEventListener(NativeDragEvent.NATIVE_DRAG_COMPLETE,nativeDragEventHandler,true);
         sm.stage.removeEventListener(NativeDragEvent.NATIVE_DRAG_DROP,nativeDragEventHandler,true);
         sm.stage.removeEventListener(NativeDragEvent.NATIVE_DRAG_EXIT,nativeDragEventHandler,true);
         sm.stage.removeEventListener(NativeDragEvent.NATIVE_DRAG_OVER,nativeDragEventHandler,true);
         sm.stage.removeEventListener(NativeDragEvent.NATIVE_DRAG_START,nativeDragEventHandler,true);
      }
      
      public function get isDragging() : Boolean
      {
         return NativeDragManager.isDragging;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function registerSystemManager(sm:ISystemManager) : void
      {
         if(sm.isTopLevel())
         {
            sm.addEventListener(MouseEvent.MOUSE_DOWN,sm_mouseDownHandler);
            sm.addEventListener(MouseEvent.MOUSE_UP,sm_mouseUpHandler);
         }
         sm.stage.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,nativeDragEventHandler,true);
         sm.stage.addEventListener(NativeDragEvent.NATIVE_DRAG_COMPLETE,nativeDragEventHandler,true);
         sm.stage.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,nativeDragEventHandler,true);
         sm.stage.addEventListener(NativeDragEvent.NATIVE_DRAG_EXIT,nativeDragEventHandler,true);
         sm.stage.addEventListener(NativeDragEvent.NATIVE_DRAG_OVER,nativeDragEventHandler,true);
         sm.stage.addEventListener(NativeDragEvent.NATIVE_DRAG_START,nativeDragEventHandler,true);
      }
      
      private function sm_mouseUpHandler(event:MouseEvent) : void
      {
         mouseIsDown = false;
      }
      
      public function doDrag(dragInitiator:IUIComponent, dragSource:DragSource, mouseEvent:MouseEvent, dragImage:IFlexDisplayObject = null, xOffset:Number = 0, yOffset:Number = 0, imageAlpha:Number = 0.5, allowMove:Boolean = true) : void
      {
         var proxyWidth:Number = NaN;
         var proxyHeight:Number = NaN;
         var format:String = null;
         var dataFetcher:DragDataFormatFetcher = null;
         var dragManagerStyleDeclaration:CSSStyleDeclaration = null;
         var dragImageClass:Class = null;
         if(isDragging)
         {
            return;
         }
         if(!(mouseEvent.type == MouseEvent.MOUSE_DOWN || mouseEvent.type == MouseEvent.CLICK || mouseIsDown || mouseEvent.buttonDown))
         {
            return;
         }
         var me:InterManagerRequest = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
         me.name = "isDragging";
         me.value = true;
         sandboxRoot.dispatchEvent(me);
         me = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
         me.name = "mouseShield";
         me.value = true;
         sandboxRoot.dispatchEvent(me);
         _clipboard = new Clipboard();
         _dragInitiator = dragInitiator;
         _offset = new Point(xOffset,yOffset);
         _allowMove = allowMove;
         _offset.y -= InteractiveObject(dragInitiator).mouseY;
         _offset.x -= InteractiveObject(dragInitiator).mouseX;
         _allowedActions = new NativeDragOptions();
         _allowedActions.allowCopy = true;
         _allowedActions.allowLink = true;
         _allowedActions.allowMove = allowMove;
         for(var i:int = 0; i < dragSource.formats.length; i++)
         {
            format = dragSource.formats[i] as String;
            dataFetcher = new DragDataFormatFetcher();
            dataFetcher.dragSource = dragSource;
            dataFetcher.format = format;
            _clipboard.setDataHandler(format,dataFetcher.getDragSourceData,false);
         }
         if(!dragImage)
         {
            dragManagerStyleDeclaration = StyleManager.getStyleDeclaration("DragManager");
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
         _dragImage = dragImage;
         if(dragImage is IUIComponent && dragImage is ILayoutManagerClient && !ILayoutManagerClient(dragImage).initialized && Boolean(dragInitiator))
         {
            dragImage.addEventListener(FlexEvent.UPDATE_COMPLETE,initiateDrag);
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
         initiateDrag(null,false);
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
         sandboxRoot.dispatchEvent(me);
         if(!me.value)
         {
            return true;
         }
         return false;
      }
      
      public function showFeedback(feedback:String) : void
      {
         var me:InterManagerRequest = null;
         if(isDragging)
         {
            if(feedback == DragManager.MOVE && !_allowedActions.allowMove)
            {
               return;
            }
            if(feedback == DragManager.COPY && !_allowedActions.allowCopy)
            {
               return;
            }
            if(feedback == DragManager.LINK && !_allowedActions.allowLink)
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
            sandboxRoot.dispatchEvent(me);
         }
      }
      
      public function acceptDragDrop(target:IUIComponent) : void
      {
         var dispObj:InteractiveObject = null;
         var me:InterManagerRequest = null;
         if(isDragging)
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
            sandboxRoot.dispatchEvent(me);
         }
      }
      
      private function initiateDrag(event:FlexEvent, removeImage:Boolean = true) : void
      {
         var dragBitmap:BitmapData = null;
         if(removeImage)
         {
            _dragImage.removeEventListener(FlexEvent.UPDATE_COMPLETE,initiateDrag);
         }
         if(Boolean(_dragImage.width) && Boolean(_dragImage.height))
         {
            dragBitmap = new BitmapData(_dragImage.width,_dragImage.height,true,0);
         }
         else
         {
            dragBitmap = new BitmapData(1,1,true,0);
         }
         dragBitmap.draw(_dragImage);
         if(removeImage && _dragImage is IUIComponent && Boolean(_dragInitiator))
         {
            _dragInitiator.systemManager.popUpChildren.removeChild(DisplayObject(_dragImage));
         }
         NativeDragManager.doDrag(InteractiveObject(_dragInitiator),_clipboard,dragBitmap,_offset,_allowedActions);
      }
      
      public function endDrag() : void
      {
         var me:InterManagerRequest = null;
         me = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
         me.name = "mouseShield";
         me.value = false;
         sandboxRoot.dispatchEvent(me);
         me = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
         me.name = "isDragging";
         me.value = false;
         sandboxRoot.dispatchEvent(me);
      }
      
      private function sm_mouseDownHandler(event:MouseEvent) : void
      {
         mouseIsDown = true;
      }
      
      private function _dispatchDragEvent(target:DisplayObject, event:DragEvent) : void
      {
         var me:InterManagerRequest = null;
         var mde:InterDragManagerEvent = null;
         if(isSameOrChildApplicationDomain(target))
         {
            target.dispatchEvent(event);
         }
         else
         {
            me = new InterManagerRequest(InterManagerRequest.INIT_MANAGER_REQUEST);
            me.name = "mx.managers.IDragManagerImpl";
            sandboxRoot.dispatchEvent(me);
            mde = new InterDragManagerEvent(InterDragManagerEvent.DISPATCH_DRAG_EVENT,false,false,event.localX,event.localY,event.relatedObject,event.ctrlKey,event.altKey,event.shiftKey,event.buttonDown,event.delta,target,event.type,event.dragInitiator,event.dragSource,event.action,event.draggedItem);
            sandboxRoot.dispatchEvent(mde);
         }
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
         _allowedActions = event.allowedActions;
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
            NativeDragManager.dropAction = ctrlKey || !_allowMove ? DragManager.COPY : DragManager.MOVE;
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
            _relatedObject = event.target as InteractiveObject;
         }
         var dragEvent:DragEvent = new DragEvent(newType,false,event.cancelable,NativeDragManager.dragInitiator as IUIComponent,dragSource,event.dropAction,ctrlKey,event.altKey,event.shiftKey);
         dragEvent.buttonDown = event.buttonDown;
         dragEvent.delta = event.delta;
         dragEvent.localX = event.localX;
         dragEvent.localY = event.localY;
         if(newType == DragEvent.DRAG_COMPLETE)
         {
            dragEvent.relatedObject = _relatedObject;
         }
         else
         {
            dragEvent.relatedObject = event.relatedObject;
         }
         _dispatchDragEvent(target,dragEvent);
         if(newType == DragEvent.DRAG_COMPLETE)
         {
            if(sm == sandboxRoot)
            {
               endDrag();
            }
            else
            {
               me = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
               me.name = "endDrag";
               sandboxRoot.dispatchEvent(me);
            }
         }
      }
   }
}

import flash.desktop.Clipboard;
import mx.core.DragSource;

class DragDataFormatFetcher
{
   
   §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.6.0.12937";
   
   public var clipboard:Clipboard;
   
   public var format:String;
   
   public var dragSource:DragSource;
   
   public function DragDataFormatFetcher()
   {
      super();
   }
   
   public function getDragSourceData() : Object
   {
      if(Boolean(dragSource))
      {
         return dragSource.dataForFormat(format);
      }
      return null;
   }
   
   public function getClipboardData() : Object
   {
      if(Boolean(clipboard))
      {
         return clipboard.getData(format);
      }
      return null;
   }
}
