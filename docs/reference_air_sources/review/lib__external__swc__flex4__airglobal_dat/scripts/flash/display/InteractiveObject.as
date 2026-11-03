package flash.display
{
   import flash.accessibility.AccessibilityImplementation;
   import flash.events.*;
   import flash.geom.Rectangle;
   import flash.net.*;
   import flash.ui.*;
   
   [native(cls="InteractiveObjectClass",gc="exact",instance="InteractiveObject",methods="auto",construct="abstract-restricted")]
   [Event(name="softKeyboardDeactivate",type="flash.events.SoftKeyboardEvent")]
   [Event(name="softKeyboardActivate",type="flash.events.SoftKeyboardEvent")]
   [Event(name="softKeyboardActivating",type="flash.events.SoftKeyboardEvent")]
   [Event(name="textInput",type="flash.events.TextEvent")]
   [Event(name="imeStartComposition",type="flash.events.IMEEvent")]
   [Event(name="contextMenu",type="flash.events.MouseEvent")]
   [Event(name="nativeDragComplete",type="flash.events.NativeDragEvent")]
   [Event(name="nativeDragUpdate",type="flash.events.NativeDragEvent")]
   [Event(name="nativeDragStart",type="flash.events.NativeDragEvent")]
   [Event(name="nativeDragExit",type="flash.events.NativeDragEvent")]
   [Event(name="nativeDragDrop",type="flash.events.NativeDragEvent")]
   [Event(name="nativeDragOver",type="flash.events.NativeDragEvent")]
   [Event(name="nativeDragEnter",type="flash.events.NativeDragEvent")]
   [Event(name="tabIndexChange",type="flash.events.Event")]
   [Event(name="tabEnabledChange",type="flash.events.Event")]
   [Event(name="tabChildrenChange",type="flash.events.Event")]
   [Event(name="keyUp",type="flash.events.KeyboardEvent")]
   [Event(name="keyDown",type="flash.events.KeyboardEvent")]
   [Event(name="rightMouseUp",type="flash.events.MouseEvent")]
   [Event(name="rightMouseDown",type="flash.events.MouseEvent")]
   [Event(name="rightClick",type="flash.events.MouseEvent")]
   [Event(name="middleMouseUp",type="flash.events.MouseEvent")]
   [Event(name="middleMouseDown",type="flash.events.MouseEvent")]
   [Event(name="middleClick",type="flash.events.MouseEvent")]
   [Event(name="gestureSwipe",type="flash.events.TransformGestureEvent")]
   [Event(name="gestureZoom",type="flash.events.TransformGestureEvent")]
   [Event(name="gestureRotate",type="flash.events.TransformGestureEvent")]
   [Event(name="gesturePressAndTap",type="flash.events.PressAndTapGestureEvent")]
   [Event(name="gesturePan",type="flash.events.TransformGestureEvent")]
   [Event(name="gestureTwoFingerTap",type="flash.events.GestureEvent")]
   [Event(name="touchTap",type="flash.events.TouchEvent")]
   [Event(name="touchRollOver",type="flash.events.TouchEvent")]
   [Event(name="touchRollOut",type="flash.events.TouchEvent")]
   [Event(name="touchOver",type="flash.events.TouchEvent")]
   [Event(name="touchOut",type="flash.events.TouchEvent")]
   [Event(name="proximityRollOver",type="flash.events.TouchEvent")]
   [Event(name="proximityRollOut",type="flash.events.TouchEvent")]
   [Event(name="proximityOver",type="flash.events.TouchEvent")]
   [Event(name="proximityOut",type="flash.events.TouchEvent")]
   [Event(name="proximityMove",type="flash.events.TouchEvent")]
   [Event(name="proximityEnd",type="flash.events.TouchEvent")]
   [Event(name="proximityBegin",type="flash.events.TouchEvent")]
   [Event(name="touchMove",type="flash.events.TouchEvent")]
   [Event(name="touchEnd",type="flash.events.TouchEvent")]
   [Event(name="touchBegin",type="flash.events.TouchEvent")]
   [Event(name="rollOver",type="flash.events.MouseEvent")]
   [Event(name="rollOut",type="flash.events.MouseEvent")]
   [Event(name="mouseWheel",type="flash.events.MouseEvent")]
   [Event(name="mouseUp",type="flash.events.MouseEvent")]
   [Event(name="mouseOver",type="flash.events.MouseEvent")]
   [Event(name="mouseOut",type="flash.events.MouseEvent")]
   [Event(name="mouseMove",type="flash.events.MouseEvent")]
   [Event(name="mouseDown",type="flash.events.MouseEvent")]
   [Event(name="doubleClick",type="flash.events.MouseEvent")]
   [Event(name="click",type="flash.events.MouseEvent")]
   [Event(name="mouseFocusChange",type="flash.events.FocusEvent")]
   [Event(name="keyFocusChange",type="flash.events.FocusEvent")]
   [Event(name="focusOut",type="flash.events.FocusEvent")]
   [Event(name="focusIn",type="flash.events.FocusEvent")]
   [Event(name="selectAll",type="flash.events.Event")]
   [Event(name="paste",type="flash.events.Event")]
   [Event(name="cut",type="flash.events.Event")]
   [Event(name="copy",type="flash.events.Event")]
   [Event(name="clear",type="flash.events.Event")]
   public class InteractiveObject extends DisplayObject
   {
      
      private var m_contextMenu:NativeMenu = null;
      
      private var _cutItem:NativeMenuItem;
      
      private var _copyItem:NativeMenuItem;
      
      private var _deleteItem:NativeMenuItem;
      
      private var _pasteItem:NativeMenuItem;
      
      private var _selectAllItem:NativeMenuItem;
      
      public function InteractiveObject()
      {
         super();
         if(this is DisplayObjectContainer)
         {
            return;
         }
         addEventListener(MouseEvent.CONTEXT_MENU,this.onContextMenuEvent,false,-1,true);
      }
      
      public native function get tabEnabled() : Boolean;
      
      public native function set tabEnabled(param1:Boolean) : void;
      
      public native function get tabIndex() : int;
      
      public native function set tabIndex(param1:int) : void;
      
      public native function get focusRect() : Object;
      
      public native function set focusRect(param1:Object) : void;
      
      public native function get mouseEnabled() : Boolean;
      
      public native function set mouseEnabled(param1:Boolean) : void;
      
      public native function get doubleClickEnabled() : Boolean;
      
      public native function set doubleClickEnabled(param1:Boolean) : void;
      
      [Inspectable(environment="none")]
      public native function get accessibilityImplementation() : AccessibilityImplementation;
      
      public native function set accessibilityImplementation(param1:AccessibilityImplementation) : void;
      
      [API("670")]
      public native function get softKeyboardInputAreaOfInterest() : Rectangle;
      
      [API("670")]
      public native function set softKeyboardInputAreaOfInterest(param1:Rectangle) : void;
      
      [API("670")]
      public native function get needsSoftKeyboard() : Boolean;
      
      [API("670")]
      public native function set needsSoftKeyboard(param1:Boolean) : void;
      
      [API("670")]
      public native function requestSoftKeyboard() : Boolean;
      
      public function get contextMenu() : NativeMenu
      {
         var testMenu:ContextMenu = null;
         var ctxtMenuObj:Object = null;
         var thisObj:Object = null;
         if(Boolean(this._isRichTextEditor()) && this.m_contextMenu == null)
         {
            testMenu = new ContextMenu();
            if(testMenu.hasOwnProperty("clipboardItems"))
            {
               this.m_contextMenu = testMenu;
               ctxtMenuObj = this.m_contextMenu as Object;
               thisObj = this as Object;
               ctxtMenuObj["clipboardItems"] = thisObj["clipboardItems"];
               ctxtMenuObj["clipboardMenu"] = true;
               thisObj["configureClipboardItems"].call(this,ctxtMenuObj["clipboardItems"]);
            }
            else
            {
               this.m_contextMenu = this._defaultFP9ContextMenu();
            }
         }
         return this.m_contextMenu;
      }
      
      public function set contextMenu(cm:NativeMenu) : void
      {
         addEventListener(MouseEvent.CONTEXT_MENU,this.onContextMenuEvent,false,-1,true);
         this.m_contextMenu = cm;
      }
      
      private native function _getEditString(param1:String) : String;
      
      private native function _doCommand(param1:String) : void;
      
      private function _defaultFP9ContextMenu() : NativeMenu
      {
         var contextMenu:NativeMenu = new NativeMenu();
         this._cutItem = new NativeMenuItem(this._getEditString("EDIT__CUT"));
         contextMenu.addItem(this._cutItem);
         this._cutItem.addEventListener(Event.SELECT,function(event:Event):void
         {
            _doCommand("cut");
         });
         this._cutItem.enabled = this._textCanCut();
         this._copyItem = new NativeMenuItem(this._getEditString("EDIT__COPY"));
         contextMenu.addItem(this._copyItem);
         this._copyItem.addEventListener(Event.SELECT,function(event:Event):void
         {
            _doCommand("copy");
         });
         this._copyItem.enabled = this._textCanCopy();
         this._pasteItem = new NativeMenuItem(this._getEditString("EDIT__PASTE"));
         contextMenu.addItem(this._pasteItem);
         this._pasteItem.addEventListener(Event.SELECT,function(event:Event):void
         {
            _doCommand("paste");
         });
         this._pasteItem.enabled = this._textCanPaste();
         this._deleteItem = new NativeMenuItem(this._getEditString("EDIT__DELETE"));
         contextMenu.addItem(this._deleteItem);
         this._deleteItem.addEventListener(Event.SELECT,function(event:Event):void
         {
            _doCommand("clear");
         });
         this._deleteItem.enabled = this._textCanClear();
         this._selectAllItem = new NativeMenuItem(this._getEditString("EDIT__SELECT_ALL"));
         contextMenu.addItem(this._selectAllItem);
         this._selectAllItem.addEventListener(Event.SELECT,function(event:Event):void
         {
            _doCommand("selectAll");
         });
         this._selectAllItem.enabled = true;
         return contextMenu;
      }
      
      private function onContextMenuEvent(event:MouseEvent) : void
      {
         var menu:NativeMenu = null;
         var testMenu:ContextMenu = null;
         var ctxtMenuObj:Object = null;
         var thisObj:Object = null;
         var linkStr:String = null;
         if(!event.isDefaultPrevented())
         {
            menu = this.contextMenu;
            if(menu != null)
            {
               this._setContextMenuOwner();
               if(this._isRichTextEditor())
               {
                  testMenu = new ContextMenu();
                  if(testMenu.hasOwnProperty("clipboardItems"))
                  {
                     ctxtMenuObj = this.m_contextMenu as Object;
                     thisObj = this as Object;
                     if(ctxtMenuObj["clipboardItems"] != null)
                     {
                        thisObj["configureClipboardItems"].call(this,ctxtMenuObj["clipboardItems"]);
                     }
                     linkStr = this._getTextLinkAtMouse(event);
                     ctxtMenuObj["link"] = Boolean(linkStr) ? new URLRequest(linkStr) : null;
                  }
                  else if(Boolean(this._cutItem))
                  {
                     this._cutItem.enabled = this._textCanCut();
                     this._copyItem.enabled = this._textCanCopy();
                     this._pasteItem.enabled = this._textCanPaste();
                     this._deleteItem.enabled = this._textCanClear();
                     this._selectAllItem.enabled = true;
                  }
               }
               menu.dispatchContextMenuSelect(event);
               menu.display(stage,event.stageX,event.stageY);
               event.stopPropagation();
            }
         }
      }
      
      private native function _setContextMenuOwner() : void;
      
      private native function _isRichTextEditor() : Boolean;
      
      private native function _getTextLinkAtMouse(param1:MouseEvent) : String;
      
      private function get clipboardItems() : ContextMenuClipboardItems
      {
         return new ContextMenuClipboardItems();
      }
      
      private function configureClipboardItems(items:ContextMenuClipboardItems) : *
      {
         items.cut = this._textCanCut();
         items.copy = this._textCanCopy();
         items.paste = this._textCanPaste();
         items.clear = this._textCanClear();
         items.selectAll = true;
      }
      
      private native function _textCanCut() : Boolean;
      
      private native function _textCanCopy() : Boolean;
      
      private native function _textCanPaste() : Boolean;
      
      private native function _textCanClear() : Boolean;
   }
}

