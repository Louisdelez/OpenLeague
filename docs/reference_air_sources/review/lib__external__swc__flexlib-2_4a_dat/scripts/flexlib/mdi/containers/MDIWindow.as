package flexlib.mdi.containers
{
   import flash.display.DisplayObject;
   import flash.events.ContextMenuEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.utils.getQualifiedClassName;
   import flexlib.mdi.events.MDIWindowEvent;
   import flexlib.mdi.managers.MDIManager;
   import mx.containers.Canvas;
   import mx.containers.Panel;
   import mx.controls.Button;
   import mx.core.Container;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.managers.CursorManager;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   [Style(name="resizeCursorTopRightBottomLeftYOffset",type="Number",inherit="no")]
   [Style(name="resizeCursorTopRightBottomLeftXOffset",type="Number",inherit="no")]
   [Style(name="resizeCursorTopRightBottomLeftSkin",type="Class",inherit="no")]
   [Style(name="resizeCursorTopLeftBottomRightYOffset",type="Number",inherit="no")]
   [Style(name="resizeCursorTopLeftBottomRightXOffset",type="Number",inherit="no")]
   [Style(name="resizeCursorTopLeftBottomRightSkin",type="Class",inherit="no")]
   [Style(name="resizeCursorVerticalYOffset",type="Number",inherit="no")]
   [Style(name="resizeCursorVerticalXOffset",type="Number",inherit="no")]
   [Style(name="resizeCursorVerticalSkin",type="Class",inherit="no")]
   [Style(name="resizeCursorHorizontalYOffset",type="Number",inherit="no")]
   [Style(name="resizeCursorHorizontalXOffset",type="Number",inherit="no")]
   [Style(name="resizeCursorHorizontalSkin",type="Class",inherit="no")]
   [Style(name="closeBtnStyleNameNoFocus",type="String",inherit="no")]
   [Style(name="closeBtnStyleName",type="String",inherit="no")]
   [Style(name="restoreBtnStyleNameNoFocus",type="String",inherit="no")]
   [Style(name="restoreBtnStyleName",type="String",inherit="no")]
   [Style(name="maximizeBtnStyleNameNoFocus",type="String",inherit="no")]
   [Style(name="maximizeBtnStyleName",type="String",inherit="no")]
   [Style(name="minimizeBtnStyleNameNoFocus",type="String",inherit="no")]
   [Style(name="minimizeBtnStyleName",type="String",inherit="no")]
   [Style(name="windowControlsClass",type="Class",inherit="no")]
   [Style(name="titleStyleNameNoFocus",type="String",inherit="no")]
   [Style(name="titleStyleNameFocus",type="String",inherit="no")]
   [Style(name="styleNameNoFocus",type="String",inherit="no")]
   [Style(name="styleNameFocus",type="String",inherit="no")]
   [Event(name="resizeEnd",type="flexlib.mdi.events.MDIWindowEvent")]
   [Event(name="resize",type="flexlib.mdi.events.MDIWindowEvent")]
   [Event(name="resizeStart",type="flexlib.mdi.events.MDIWindowEvent")]
   [Event(name="dragEnd",type="flexlib.mdi.events.MDIWindowEvent")]
   [Event(name="drag",type="flexlib.mdi.events.MDIWindowEvent")]
   [Event(name="dragStart",type="flexlib.mdi.events.MDIWindowEvent")]
   [Event(name="focusEnd",type="flexlib.mdi.events.MDIWindowEvent")]
   [Event(name="focusStart",type="flexlib.mdi.events.MDIWindowEvent")]
   [Event(name="close",type="flexlib.mdi.events.MDIWindowEvent")]
   [Event(name="maximize",type="flexlib.mdi.events.MDIWindowEvent")]
   [Event(name="restore",type="flexlib.mdi.events.MDIWindowEvent")]
   [Event(name="minimize",type="flexlib.mdi.events.MDIWindowEvent")]
   public class MDIWindow extends Panel
   {
      
      [Embed(source="/flexlib/mdi/assets/img/minimizeButton.png")]
      private static var DEFAULT_MINIMIZE_BUTTON:Class = MDIWindow_DEFAULT_MINIMIZE_BUTTON;
      
      [Embed(source="/flexlib/mdi/assets/img/maximizeButton.png")]
      private static var DEFAULT_MAXIMIZE_BUTTON:Class = MDIWindow_DEFAULT_MAXIMIZE_BUTTON;
      
      [Embed(source="/flexlib/mdi/assets/img/restoreButton.png")]
      private static var DEFAULT_RESTORE_BUTTON:Class = MDIWindow_DEFAULT_RESTORE_BUTTON;
      
      [Embed(source="/flexlib/mdi/assets/img/closeButton.png")]
      private static var DEFAULT_CLOSE_BUTTON:Class = MDIWindow_DEFAULT_CLOSE_BUTTON;
      
      [Embed(source="/flexlib/mdi/assets/img/resizeCursorH.gif")]
      private static var DEFAULT_RESIZE_CURSOR_HORIZONTAL:Class = MDIWindow_DEFAULT_RESIZE_CURSOR_HORIZONTAL;
      
      private static var DEFAULT_RESIZE_CURSOR_HORIZONTAL_X_OFFSET:Number = -10;
      
      private static var DEFAULT_RESIZE_CURSOR_HORIZONTAL_Y_OFFSET:Number = -10;
      
      [Embed(source="/flexlib/mdi/assets/img/resizeCursorV.gif")]
      private static var DEFAULT_RESIZE_CURSOR_VERTICAL:Class = MDIWindow_DEFAULT_RESIZE_CURSOR_VERTICAL;
      
      private static var DEFAULT_RESIZE_CURSOR_VERTICAL_X_OFFSET:Number = -10;
      
      private static var DEFAULT_RESIZE_CURSOR_VERTICAL_Y_OFFSET:Number = -10;
      
      [Embed(source="/flexlib/mdi/assets/img/resizeCursorTLBR.gif")]
      private static var DEFAULT_RESIZE_CURSOR_TL_BR:Class = MDIWindow_DEFAULT_RESIZE_CURSOR_TL_BR;
      
      private static var DEFAULT_RESIZE_CURSOR_TL_BR_X_OFFSET:Number = -10;
      
      private static var DEFAULT_RESIZE_CURSOR_TL_BR_Y_OFFSET:Number = -10;
      
      [Embed(source="/flexlib/mdi/assets/img/resizeCursorTRBL.gif")]
      private static var DEFAULT_RESIZE_CURSOR_TR_BL:Class = MDIWindow_DEFAULT_RESIZE_CURSOR_TR_BL;
      
      private static var DEFAULT_RESIZE_CURSOR_TR_BL_X_OFFSET:Number = -10;
      
      private static var DEFAULT_RESIZE_CURSOR_TR_BL_Y_OFFSET:Number = -10;
      
      private static var classConstructed:Boolean = classConstruct();
      
      public static const CONTEXT_MENU_LABEL_MINIMIZE:String = "Minimize";
      
      public static const CONTEXT_MENU_LABEL_MAXIMIZE:String = "Maximize";
      
      public static const CONTEXT_MENU_LABEL_RESTORE:String = "Restore";
      
      public static const CONTEXT_MENU_LABEL_CLOSE:String = "Close";
      
      public var edgeHandleSize:Number = 4;
      
      private var _prevWindowState:int;
      
      private var currentResizeHandle:Button;
      
      private var _styleNameFocus:String;
      
      private var _windowState:int;
      
      private var _windowControls:MDIWindowControlsContainer;
      
      public var titleBarOverlay:Canvas;
      
      private var resizeHandleBottom:Button;
      
      private var resizeHandleBL:Button;
      
      private var resizeHandleBR:Button;
      
      private var dragStartMouseY:Number;
      
      private var dragStartMouseX:Number;
      
      public var draggable:Boolean = true;
      
      public var windowManager:MDIManager;
      
      private var _showCloseButton:Boolean = true;
      
      private var _resizing:Boolean;
      
      private var resizeHandleLeft:Button;
      
      public var winContextMenu:ContextMenu = null;
      
      private var _styleNameNoFocus:String;
      
      private var _dragging:Boolean;
      
      public var resizable:Boolean = true;
      
      public var cornerHandleSize:Number = 10;
      
      private var dragMaxX:Number;
      
      private var dragMaxY:Number;
      
      private var dragAmountY:Number;
      
      private var dragAmountX:Number;
      
      private var resizeHandleTL:Button;
      
      private var resizeHandleRight:Button;
      
      private var backgroundAlphaRestore:Number = 1;
      
      private var _windowStyleName:Object;
      
      private var resizeHandleTR:Button;
      
      private var resizeHandleTop:Button;
      
      private var _hasFocus:Boolean;
      
      public var savedWindowRect:Rectangle;
      
      private var _minimizeHeight:Number;
      
      public function MDIWindow()
      {
         super();
         minWidth = minHeight = width = height = 200;
         windowState = MDIWindowState.NORMAL;
         doubleClickEnabled = true;
         windowControls = new MDIWindowControlsContainer();
         updateContextMenu();
      }
      
      private static function classConstruct() : Boolean
      {
         var selector:CSSStyleDeclaration = null;
         var styleNameFocus:String = null;
         var winFocusSelector:CSSStyleDeclaration = null;
         var styleNameNoFocus:String = null;
         var winNoFocusSelector:CSSStyleDeclaration = null;
         var titleStyleName:String = null;
         var winTitleSelector:CSSStyleDeclaration = null;
         var minimizeBtnStyleName:String = null;
         var minimizeBtnSelector:CSSStyleDeclaration = null;
         var maximizeBtnStyleName:String = null;
         var maximizeBtnSelector:CSSStyleDeclaration = null;
         var restoreBtnStyleName:String = null;
         var restoreBtnSelector:CSSStyleDeclaration = null;
         var closeBtnStyleName:String = null;
         var closeBtnSelector:CSSStyleDeclaration = null;
         selector = StyleManager.getStyleDeclaration("MDIWindow");
         if(!selector)
         {
            selector = new CSSStyleDeclaration();
         }
         selector.defaultFactory = function():void
         {
            this.styleNameFocus = "mdiWindowFocus";
            this.styleNameNoFocus = "mdiWindowNoFocus";
            this.titleStyleName = "mdiWindowTitleStyle";
            this.minimizeBtnStyleName = "mdiWindowMinimizeBtn";
            this.maximizeBtnStyleName = "mdiWindowMaximizeBtn";
            this.restoreBtnStyleName = "mdiWindowRestoreBtn";
            this.closeBtnStyleName = "mdiWindowCloseBtn";
            this.windowControlsClass = MDIWindowControlsContainer;
            this.resizeCursorHorizontalSkin = DEFAULT_RESIZE_CURSOR_HORIZONTAL;
            this.resizeCursorHorizontalXOffset = DEFAULT_RESIZE_CURSOR_HORIZONTAL_X_OFFSET;
            this.resizeCursorHorizontalYOffset = DEFAULT_RESIZE_CURSOR_HORIZONTAL_Y_OFFSET;
            this.resizeCursorVerticalSkin = DEFAULT_RESIZE_CURSOR_VERTICAL;
            this.resizeCursorVerticalXOffset = DEFAULT_RESIZE_CURSOR_VERTICAL_X_OFFSET;
            this.resizeCursorVerticalYOffset = DEFAULT_RESIZE_CURSOR_VERTICAL_Y_OFFSET;
            this.resizeCursorTopLeftBottomRightSkin = DEFAULT_RESIZE_CURSOR_TL_BR;
            this.resizeCursorTopLeftBottomRightXOffset = DEFAULT_RESIZE_CURSOR_TL_BR_X_OFFSET;
            this.resizeCursorTopLeftBottomRightYOffset = DEFAULT_RESIZE_CURSOR_TL_BR_Y_OFFSET;
            this.resizeCursorTopRightBottomLeftSkin = DEFAULT_RESIZE_CURSOR_TR_BL;
            this.resizeCursorTopRightBottomLeftXOffset = DEFAULT_RESIZE_CURSOR_TR_BL_X_OFFSET;
            this.resizeCursorTopRightBottomLeftYOffset = DEFAULT_RESIZE_CURSOR_TR_BL_Y_OFFSET;
         };
         styleNameFocus = selector.getStyle("styleNameFocus");
         winFocusSelector = StyleManager.getStyleDeclaration("." + styleNameFocus);
         if(!winFocusSelector)
         {
            winFocusSelector = new CSSStyleDeclaration();
         }
         winFocusSelector.defaultFactory = function():void
         {
            this.headerHeight = 26;
            this.roundedBottomCorners = true;
            this.borderColor = 13421772;
            this.borderThicknessTop = 0;
            this.borderThicknessRight = 3;
            this.borderThicknessBottom = 3;
            this.borderThicknessLeft = 3;
            this.borderAlpha = 1;
            this.backgroundAlpha = 1;
         };
         StyleManager.setStyleDeclaration("." + styleNameFocus,winFocusSelector,false);
         styleNameNoFocus = selector.getStyle("styleNameNoFocus");
         winNoFocusSelector = StyleManager.getStyleDeclaration("." + styleNameNoFocus);
         if(!winNoFocusSelector)
         {
            winNoFocusSelector = new CSSStyleDeclaration();
         }
         winNoFocusSelector.defaultFactory = function():void
         {
            this.headerHeight = 26;
            this.roundedBottomCorners = true;
            this.borderColor = 13421772;
            this.borderThicknessTop = 0;
            this.borderThicknessRight = 3;
            this.borderThicknessBottom = 3;
            this.borderThicknessLeft = 3;
            this.borderAlpha = 0.5;
            this.backgroundAlpha = 0.5;
         };
         StyleManager.setStyleDeclaration("." + styleNameNoFocus,winNoFocusSelector,false);
         titleStyleName = selector.getStyle("titleStyleName");
         winTitleSelector = StyleManager.getStyleDeclaration("." + titleStyleName);
         if(!winTitleSelector)
         {
            winTitleSelector = new CSSStyleDeclaration();
         }
         winTitleSelector.defaultFactory = function():void
         {
            this.fontFamily = "Arial";
            this.fontSize = 10;
            this.fontWeight = "bold";
            this.color = 0;
         };
         StyleManager.setStyleDeclaration("." + titleStyleName,winTitleSelector,false);
         minimizeBtnStyleName = selector.getStyle("minimizeBtnStyleName");
         minimizeBtnSelector = StyleManager.getStyleDeclaration("." + minimizeBtnStyleName);
         if(!minimizeBtnSelector)
         {
            minimizeBtnSelector = new CSSStyleDeclaration();
         }
         minimizeBtnSelector.defaultFactory = function():void
         {
            this.upSkin = DEFAULT_MINIMIZE_BUTTON;
            this.overSkin = DEFAULT_MINIMIZE_BUTTON;
            this.downSkin = DEFAULT_MINIMIZE_BUTTON;
            this.disabledSkin = DEFAULT_MINIMIZE_BUTTON;
         };
         StyleManager.setStyleDeclaration("." + minimizeBtnStyleName,minimizeBtnSelector,false);
         maximizeBtnStyleName = selector.getStyle("maximizeBtnStyleName");
         maximizeBtnSelector = StyleManager.getStyleDeclaration("." + maximizeBtnStyleName);
         if(!maximizeBtnSelector)
         {
            maximizeBtnSelector = new CSSStyleDeclaration();
         }
         maximizeBtnSelector.defaultFactory = function():void
         {
            this.upSkin = DEFAULT_MAXIMIZE_BUTTON;
            this.overSkin = DEFAULT_MAXIMIZE_BUTTON;
            this.downSkin = DEFAULT_MAXIMIZE_BUTTON;
            this.disabledSkin = DEFAULT_MAXIMIZE_BUTTON;
         };
         StyleManager.setStyleDeclaration("." + maximizeBtnStyleName,maximizeBtnSelector,false);
         restoreBtnStyleName = selector.getStyle("restoreBtnStyleName");
         restoreBtnSelector = StyleManager.getStyleDeclaration("." + restoreBtnStyleName);
         if(!restoreBtnSelector)
         {
            restoreBtnSelector = new CSSStyleDeclaration();
         }
         restoreBtnSelector.defaultFactory = function():void
         {
            this.upSkin = DEFAULT_RESTORE_BUTTON;
            this.overSkin = DEFAULT_RESTORE_BUTTON;
            this.downSkin = DEFAULT_RESTORE_BUTTON;
            this.disabledSkin = DEFAULT_RESTORE_BUTTON;
         };
         StyleManager.setStyleDeclaration("." + restoreBtnStyleName,restoreBtnSelector,false);
         closeBtnStyleName = selector.getStyle("closeBtnStyleName");
         closeBtnSelector = StyleManager.getStyleDeclaration("." + closeBtnStyleName);
         if(!closeBtnSelector)
         {
            closeBtnSelector = new CSSStyleDeclaration();
         }
         closeBtnSelector.defaultFactory = function():void
         {
            this.upSkin = DEFAULT_CLOSE_BUTTON;
            this.overSkin = DEFAULT_CLOSE_BUTTON;
            this.downSkin = DEFAULT_CLOSE_BUTTON;
            this.disabledSkin = DEFAULT_CLOSE_BUTTON;
         };
         StyleManager.setStyleDeclaration("." + closeBtnStyleName,closeBtnSelector,false);
         StyleManager.setStyleDeclaration("MDIWindow",selector,false);
         return true;
      }
      
      public function get showCloseButton() : Boolean
      {
         return _showCloseButton;
      }
      
      public function set showCloseButton(value:Boolean) : void
      {
         _showCloseButton = value;
         if(Boolean(closeBtn) && closeBtn.visible != value)
         {
            closeBtn.visible = value;
            invalidateDisplayList();
         }
      }
      
      private function windowControlClickHandler(event:MouseEvent) : void
      {
         if(Boolean(windowControls))
         {
            if(Boolean(windowControls.minimizeBtn) && event.target == windowControls.minimizeBtn)
            {
               minimize();
            }
            else if(Boolean(windowControls.maximizeRestoreBtn) && event.target == windowControls.maximizeRestoreBtn)
            {
               maximizeRestore();
            }
            else if(Boolean(windowControls.closeBtn) && event.target == windowControls.closeBtn)
            {
               close();
            }
         }
      }
      
      public function set hasFocus(value:Boolean) : void
      {
         if(_hasFocus == value)
         {
            return;
         }
         _hasFocus = value;
         updateStyles();
      }
      
      public function unMinimize(event:MouseEvent = null) : void
      {
         if(minimized)
         {
            showControls = true;
            if(_prevWindowState == MDIWindowState.NORMAL)
            {
               restore();
            }
            else
            {
               maximize();
            }
         }
      }
      
      public function get maximizeRestoreBtn() : Button
      {
         return windowControls.maximizeRestoreBtn;
      }
      
      private function set windowState(newState:int) : void
      {
         _prevWindowState = _windowState;
         _windowState = newState;
         updateContextMenu();
      }
      
      private function onMouseLeaveStage(event:Event) : void
      {
         onResizeButtonRelease();
         systemManager.stage.removeEventListener(Event.MOUSE_LEAVE,onMouseLeaveStage);
      }
      
      private function onTitleBarRelease(event:Event) : void
      {
         this.stopDrag();
         if(_dragging)
         {
            _dragging = false;
            dispatchEvent(new MDIWindowEvent(MDIWindowEvent.DRAG_END,this));
         }
         systemManager.removeEventListener(MouseEvent.MOUSE_MOVE,onWindowMove);
         systemManager.removeEventListener(MouseEvent.MOUSE_UP,onTitleBarRelease);
         systemManager.stage.removeEventListener(Event.MOUSE_LEAVE,onTitleBarRelease);
      }
      
      public function get closeBtn() : Button
      {
         return windowControls.closeBtn;
      }
      
      public function getTitleTextField() : UITextField
      {
         return titleTextField as UITextField;
      }
      
      private function onResizeButtonRollOut(event:MouseEvent) : void
      {
         if(!event.buttonDown)
         {
            CursorManager.removeCursor(CursorManager.currentCursorID);
         }
      }
      
      protected function getStyleByPriority(selectorList:Array, style:String) : Object
      {
         var n:int = 0;
         var i:int = 0;
         n = int(selectorList.length);
         for(i = 0; i < n; i++)
         {
            if(!(Boolean(selectorList[i] == this) && Boolean(selectorList[i].getStyle(style)) && this.getStyle(style) === selectorList[n - 1].getStyle(style)))
            {
               if(Boolean(selectorList[i].getStyle(style)))
               {
                  if(!(typeof selectorList[i].getStyle(style) == "string" && !StyleManager.getStyleDeclaration("." + selectorList[i].getStyle(style))))
                  {
                     return selectorList[i].getStyle(style);
                  }
               }
            }
         }
         return null;
      }
      
      private function bringToFrontProxy(event:Event) : void
      {
         windowManager.bringToFront(this);
      }
      
      public function set windowControls(controlsContainer:MDIWindowControlsContainer) : void
      {
         var cntnr:Container = null;
         if(Boolean(_windowControls))
         {
            cntnr = Container(windowControls);
            cntnr.removeAllChildren();
            rawChildren.removeChild(cntnr);
            _windowControls = null;
         }
         _windowControls = controlsContainer;
         _windowControls.window = this;
         rawChildren.addChild(UIComponent(_windowControls));
         if(windowState == MDIWindowState.MINIMIZED)
         {
            showControls = false;
         }
      }
      
      public function get minimized() : Boolean
      {
         return _windowState == MDIWindowState.MINIMIZED;
      }
      
      public function set showControls(value:Boolean) : void
      {
         Container(windowControls).visible = value;
      }
      
      private function updateWindowSize(event:Event) : void
      {
         if(windowState == MDIWindowState.NORMAL && resizable)
         {
            dragAmountX = parent.mouseX - dragStartMouseX;
            dragAmountY = parent.mouseY - dragStartMouseY;
            if(currentResizeHandle == resizeHandleTop && parent.mouseY > 0)
            {
               this.y = Math.min(savedWindowRect.y + dragAmountY,dragMaxY);
               this.height = Math.max(savedWindowRect.height - dragAmountY,minHeight);
            }
            else if(currentResizeHandle == resizeHandleRight && parent.mouseX < parent.width)
            {
               this.width = Math.max(savedWindowRect.width + dragAmountX,minWidth);
            }
            else if(currentResizeHandle == resizeHandleBottom && parent.mouseY < parent.height)
            {
               this.height = Math.max(savedWindowRect.height + dragAmountY,minHeight);
            }
            else if(currentResizeHandle == resizeHandleLeft && parent.mouseX > 0)
            {
               this.x = Math.min(savedWindowRect.x + dragAmountX,dragMaxX);
               this.width = Math.max(savedWindowRect.width - dragAmountX,minWidth);
            }
            else if(currentResizeHandle == resizeHandleTL && parent.mouseX > 0 && parent.mouseY > 0)
            {
               this.x = Math.min(savedWindowRect.x + dragAmountX,dragMaxX);
               this.y = Math.min(savedWindowRect.y + dragAmountY,dragMaxY);
               this.width = Math.max(savedWindowRect.width - dragAmountX,minWidth);
               this.height = Math.max(savedWindowRect.height - dragAmountY,minHeight);
            }
            else if(currentResizeHandle == resizeHandleTR && parent.mouseX < parent.width && parent.mouseY > 0)
            {
               this.y = Math.min(savedWindowRect.y + dragAmountY,dragMaxY);
               this.width = Math.max(savedWindowRect.width + dragAmountX,minWidth);
               this.height = Math.max(savedWindowRect.height - dragAmountY,minHeight);
            }
            else if(currentResizeHandle == resizeHandleBR && parent.mouseX < parent.width && parent.mouseY < parent.height)
            {
               this.width = Math.max(savedWindowRect.width + dragAmountX,minWidth);
               this.height = Math.max(savedWindowRect.height + dragAmountY,minHeight);
            }
            else if(currentResizeHandle == resizeHandleBL && parent.mouseX > 0 && parent.mouseY < parent.height)
            {
               this.x = Math.min(savedWindowRect.x + dragAmountX,dragMaxX);
               this.width = Math.max(savedWindowRect.width - dragAmountX,minWidth);
               this.height = Math.max(savedWindowRect.height + dragAmountY,minHeight);
            }
         }
      }
      
      public function get windowStyleName() : Object
      {
         return _windowStyleName;
      }
      
      public function close(event:MouseEvent = null) : void
      {
         dispatchEvent(new MDIWindowEvent(MDIWindowEvent.CLOSE,this));
      }
      
      public function get minimizeHeight() : Number
      {
         return titleBar.height;
      }
      
      public function maximizeRestore(event:MouseEvent = null) : void
      {
         if(windowState == MDIWindowState.NORMAL)
         {
            savePanel();
            maximize();
         }
         else
         {
            restore();
         }
      }
      
      public function saveStyle() : void
      {
      }
      
      public function get hasFocus() : Boolean
      {
         return _hasFocus;
      }
      
      private function savePanel() : void
      {
         savedWindowRect = new Rectangle(this.x,this.y,this.width,this.height);
      }
      
      private function get windowState() : int
      {
         return _windowState;
      }
      
      private function addListeners() : void
      {
         resizeHandleTop.addEventListener(MouseEvent.ROLL_OVER,onResizeButtonRollOver,false,0,true);
         resizeHandleTop.addEventListener(MouseEvent.ROLL_OUT,onResizeButtonRollOut,false,0,true);
         resizeHandleTop.addEventListener(MouseEvent.MOUSE_DOWN,onResizeButtonPress,false,0,true);
         resizeHandleRight.addEventListener(MouseEvent.ROLL_OVER,onResizeButtonRollOver,false,0,true);
         resizeHandleRight.addEventListener(MouseEvent.ROLL_OUT,onResizeButtonRollOut,false,0,true);
         resizeHandleRight.addEventListener(MouseEvent.MOUSE_DOWN,onResizeButtonPress,false,0,true);
         resizeHandleBottom.addEventListener(MouseEvent.ROLL_OVER,onResizeButtonRollOver,false,0,true);
         resizeHandleBottom.addEventListener(MouseEvent.ROLL_OUT,onResizeButtonRollOut,false,0,true);
         resizeHandleBottom.addEventListener(MouseEvent.MOUSE_DOWN,onResizeButtonPress,false,0,true);
         resizeHandleLeft.addEventListener(MouseEvent.ROLL_OVER,onResizeButtonRollOver,false,0,true);
         resizeHandleLeft.addEventListener(MouseEvent.ROLL_OUT,onResizeButtonRollOut,false,0,true);
         resizeHandleLeft.addEventListener(MouseEvent.MOUSE_DOWN,onResizeButtonPress,false,0,true);
         resizeHandleTL.addEventListener(MouseEvent.ROLL_OVER,onResizeButtonRollOver,false,0,true);
         resizeHandleTL.addEventListener(MouseEvent.ROLL_OUT,onResizeButtonRollOut,false,0,true);
         resizeHandleTL.addEventListener(MouseEvent.MOUSE_DOWN,onResizeButtonPress,false,0,true);
         resizeHandleTR.addEventListener(MouseEvent.ROLL_OVER,onResizeButtonRollOver,false,0,true);
         resizeHandleTR.addEventListener(MouseEvent.ROLL_OUT,onResizeButtonRollOut,false,0,true);
         resizeHandleTR.addEventListener(MouseEvent.MOUSE_DOWN,onResizeButtonPress,false,0,true);
         resizeHandleBR.addEventListener(MouseEvent.ROLL_OVER,onResizeButtonRollOver,false,0,true);
         resizeHandleBR.addEventListener(MouseEvent.ROLL_OUT,onResizeButtonRollOut,false,0,true);
         resizeHandleBR.addEventListener(MouseEvent.MOUSE_DOWN,onResizeButtonPress,false,0,true);
         resizeHandleBL.addEventListener(MouseEvent.ROLL_OVER,onResizeButtonRollOver,false,0,true);
         resizeHandleBL.addEventListener(MouseEvent.ROLL_OUT,onResizeButtonRollOut,false,0,true);
         resizeHandleBL.addEventListener(MouseEvent.MOUSE_DOWN,onResizeButtonPress,false,0,true);
         titleBarOverlay.addEventListener(MouseEvent.MOUSE_DOWN,onTitleBarPress,false,0,true);
         titleBarOverlay.addEventListener(MouseEvent.MOUSE_UP,onTitleBarRelease,false,0,true);
         titleBarOverlay.addEventListener(MouseEvent.DOUBLE_CLICK,maximizeRestore,false,0,true);
         titleBarOverlay.addEventListener(MouseEvent.CLICK,unMinimize,false,0,true);
         addEventListener(MouseEvent.CLICK,windowControlClickHandler,false,0,true);
         addEventListener(MouseEvent.MOUSE_DOWN,bringToFrontProxy);
         contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT,bringToFrontProxy);
      }
      
      private function onResizeButtonPress(event:MouseEvent) : void
      {
         if(windowState == MDIWindowState.NORMAL && resizable)
         {
            currentResizeHandle = event.target as Button;
            setCursor(currentResizeHandle);
            dragStartMouseX = parent.mouseX;
            dragStartMouseY = parent.mouseY;
            savePanel();
            dragMaxX = savedWindowRect.x + (savedWindowRect.width - minWidth);
            dragMaxY = savedWindowRect.y + (savedWindowRect.height - minHeight);
            systemManager.addEventListener(Event.ENTER_FRAME,updateWindowSize,false,0,true);
            systemManager.addEventListener(MouseEvent.MOUSE_MOVE,onResizeButtonDrag,false,0,true);
            systemManager.addEventListener(MouseEvent.MOUSE_UP,onResizeButtonRelease,false,0,true);
            systemManager.stage.addEventListener(Event.MOUSE_LEAVE,onMouseLeaveStage,false,0,true);
         }
      }
      
      public function get windowControls() : MDIWindowControlsContainer
      {
         return _windowControls;
      }
      
      public function restore() : void
      {
         windowState = MDIWindowState.NORMAL;
         updateStyles();
         dispatchEvent(new MDIWindowEvent(MDIWindowEvent.RESTORE,this));
      }
      
      public function minimize(event:MouseEvent = null) : void
      {
         if(windowState == MDIWindowState.NORMAL)
         {
            savePanel();
         }
         dispatchEvent(new MDIWindowEvent(MDIWindowEvent.MINIMIZE,this));
         windowState = MDIWindowState.MINIMIZED;
         showControls = false;
      }
      
      private function onResizeButtonRollOver(event:MouseEvent) : void
      {
         if(windowState == MDIWindowState.NORMAL && resizable && !event.buttonDown)
         {
            setCursor(event.target as Button);
         }
      }
      
      public function maximize() : void
      {
         if(windowState == MDIWindowState.NORMAL)
         {
            savePanel();
         }
         showControls = true;
         windowState = MDIWindowState.MAXIMIZED;
         updateStyles();
         dispatchEvent(new MDIWindowEvent(MDIWindowEvent.MAXIMIZE,this));
      }
      
      private function onTitleBarPress(event:MouseEvent) : void
      {
         if(this.windowState == MDIWindowState.NORMAL && draggable)
         {
            if(windowManager.enforceBoundaries)
            {
               this.startDrag(false,new Rectangle(0,0,parent.width - this.width,parent.height - this.height));
            }
            else
            {
               this.startDrag();
            }
            systemManager.addEventListener(MouseEvent.MOUSE_MOVE,onWindowMove);
            systemManager.addEventListener(MouseEvent.MOUSE_UP,onTitleBarRelease);
            systemManager.stage.addEventListener(Event.MOUSE_LEAVE,onTitleBarRelease);
         }
      }
      
      public function get minimizeBtn() : Button
      {
         return windowControls.minimizeBtn;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!titleBarOverlay)
         {
            titleBarOverlay = new Canvas();
            titleBarOverlay.width = this.width;
            titleBarOverlay.height = this.titleBar.height;
            titleBarOverlay.alpha = 0;
            titleBarOverlay.setStyle("backgroundColor",0);
            rawChildren.addChild(titleBarOverlay);
         }
         if(!resizeHandleTop)
         {
            resizeHandleTop = new Button();
            resizeHandleTop.x = cornerHandleSize * 0.5;
            resizeHandleTop.y = -(edgeHandleSize * 0.5);
            resizeHandleTop.height = edgeHandleSize;
            resizeHandleTop.alpha = 0;
            resizeHandleTop.focusEnabled = false;
            rawChildren.addChild(resizeHandleTop);
         }
         if(!resizeHandleRight)
         {
            resizeHandleRight = new Button();
            resizeHandleRight.y = cornerHandleSize * 0.5;
            resizeHandleRight.width = edgeHandleSize;
            resizeHandleRight.alpha = 0;
            resizeHandleRight.focusEnabled = false;
            rawChildren.addChild(resizeHandleRight);
         }
         if(!resizeHandleBottom)
         {
            resizeHandleBottom = new Button();
            resizeHandleBottom.x = cornerHandleSize * 0.5;
            resizeHandleBottom.height = edgeHandleSize;
            resizeHandleBottom.alpha = 0;
            resizeHandleBottom.focusEnabled = false;
            rawChildren.addChild(resizeHandleBottom);
         }
         if(!resizeHandleLeft)
         {
            resizeHandleLeft = new Button();
            resizeHandleLeft.x = -(edgeHandleSize * 0.5);
            resizeHandleLeft.y = cornerHandleSize * 0.5;
            resizeHandleLeft.width = edgeHandleSize;
            resizeHandleLeft.alpha = 0;
            resizeHandleLeft.focusEnabled = false;
            rawChildren.addChild(resizeHandleLeft);
         }
         if(!resizeHandleTL)
         {
            resizeHandleTL = new Button();
            resizeHandleTL.x = resizeHandleTL.y = -(cornerHandleSize * 0.3);
            resizeHandleTL.width = resizeHandleTL.height = cornerHandleSize;
            resizeHandleTL.alpha = 0;
            resizeHandleTL.focusEnabled = false;
            rawChildren.addChild(resizeHandleTL);
         }
         if(!resizeHandleTR)
         {
            resizeHandleTR = new Button();
            resizeHandleTR.width = resizeHandleTR.height = cornerHandleSize;
            resizeHandleTR.alpha = 0;
            resizeHandleTR.focusEnabled = false;
            rawChildren.addChild(resizeHandleTR);
         }
         if(!resizeHandleBR)
         {
            resizeHandleBR = new Button();
            resizeHandleBR.width = resizeHandleBR.height = cornerHandleSize;
            resizeHandleBR.alpha = 0;
            resizeHandleBR.focusEnabled = false;
            rawChildren.addChild(resizeHandleBR);
         }
         if(!resizeHandleBL)
         {
            resizeHandleBL = new Button();
            resizeHandleBL.width = resizeHandleBL.height = cornerHandleSize;
            resizeHandleBL.alpha = 0;
            resizeHandleBL.focusEnabled = false;
            rawChildren.addChild(resizeHandleBL);
         }
         rawChildren.setChildIndex(DisplayObject(windowControls),rawChildren.numChildren - 1);
         addListeners();
      }
      
      private function updateStyles() : void
      {
         var selectorList:Array = null;
         var clazz:Class = null;
         var classNameExisting:String = null;
         var classNameNew:String = null;
         selectorList = getSelectorList();
         if(Boolean(getStyleByPriority(selectorList,"windowControlsClass")))
         {
            clazz = getStyleByPriority(selectorList,"windowControlsClass") as Class;
            classNameExisting = getQualifiedClassName(windowControls);
            classNameNew = getQualifiedClassName(clazz);
            if(classNameExisting != classNameNew)
            {
               windowControls = new clazz();
               callLater(windowControls.invalidateDisplayList);
            }
         }
         if(hasFocus)
         {
            setStyle("styleName",getStyleByPriority(selectorList,"styleNameFocus"));
         }
         else
         {
            setStyle("styleName",getStyleByPriority(selectorList,"styleNameNoFocus"));
         }
         if(!hasFocus && Boolean(getStyleByPriority(selectorList,"titleStyleNameNoFocus")))
         {
            setStyle("titleStyleName",getStyleByPriority(selectorList,"titleStyleNameNoFocus"));
         }
         else if(Boolean(getStyleByPriority(selectorList,"titleStyleNameFocus")))
         {
            setStyle("titleStyleName",getStyleByPriority(selectorList,"titleStyleNameFocus"));
         }
         else
         {
            getStyleByPriority(selectorList,"titleStyleName");
         }
         if(Boolean(minimizeBtn))
         {
            if(!hasFocus && Boolean(getStyleByPriority(selectorList,"minimizeBtnStyleNameNoFocus")))
            {
               minimizeBtn.styleName = getStyleByPriority(selectorList,"minimizeBtnStyleNameNoFocus");
            }
            else
            {
               minimizeBtn.styleName = getStyleByPriority(selectorList,"minimizeBtnStyleName");
            }
         }
         if(Boolean(maximizeRestoreBtn))
         {
            if(maximized)
            {
               if(!hasFocus && Boolean(getStyleByPriority(selectorList,"restoreBtnStyleNameNoFocus")))
               {
                  maximizeRestoreBtn.styleName = getStyleByPriority(selectorList,"restoreBtnStyleNameNoFocus");
               }
               else
               {
                  maximizeRestoreBtn.styleName = getStyleByPriority(selectorList,"restoreBtnStyleName");
               }
            }
            else if(!hasFocus && Boolean(getStyleByPriority(selectorList,"maximizeBtnStyleNameNoFocus")))
            {
               maximizeRestoreBtn.styleName = getStyleByPriority(selectorList,"maximizeBtnStyleNameNoFocus");
            }
            else
            {
               maximizeRestoreBtn.styleName = getStyleByPriority(selectorList,"maximizeBtnStyleName");
            }
         }
         if(Boolean(closeBtn))
         {
            if(!hasFocus && Boolean(getStyleByPriority(selectorList,"closeBtnStyleNameNoFocus")))
            {
               closeBtn.styleName = getStyleByPriority(selectorList,"closeBtnStyleNameNoFocus");
            }
            else
            {
               closeBtn.styleName = getStyleByPriority(selectorList,"closeBtnStyleName");
            }
         }
      }
      
      private function onWindowMove(event:MouseEvent) : void
      {
         if(!_dragging)
         {
            _dragging = true;
            this.clearStyle("top");
            this.clearStyle("right");
            this.clearStyle("bottom");
            this.clearStyle("left");
            dispatchEvent(new MDIWindowEvent(MDIWindowEvent.DRAG_START,this));
         }
         dispatchEvent(new MDIWindowEvent(MDIWindowEvent.DRAG,this));
      }
      
      public function updateContextMenu() : void
      {
         var defaultContextMenu:ContextMenu = null;
         var minimizeItem:ContextMenuItem = null;
         var maximizeItem:ContextMenuItem = null;
         var restoreItem:ContextMenuItem = null;
         var closeItem:ContextMenuItem = null;
         var arrangeItem:ContextMenuItem = null;
         var arrangeFillItem:ContextMenuItem = null;
         var cascadeItem:ContextMenuItem = null;
         var showAllItem:ContextMenuItem = null;
         defaultContextMenu = new ContextMenu();
         defaultContextMenu.hideBuiltInItems();
         minimizeItem = new ContextMenuItem(MDIWindow.CONTEXT_MENU_LABEL_MINIMIZE);
         minimizeItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,menuItemSelectHandler);
         minimizeItem.enabled = windowState != MDIWindowState.MINIMIZED;
         defaultContextMenu.customItems.push(minimizeItem);
         maximizeItem = new ContextMenuItem(MDIWindow.CONTEXT_MENU_LABEL_MAXIMIZE);
         maximizeItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,menuItemSelectHandler);
         maximizeItem.enabled = windowState != MDIWindowState.MAXIMIZED;
         defaultContextMenu.customItems.push(maximizeItem);
         restoreItem = new ContextMenuItem(MDIWindow.CONTEXT_MENU_LABEL_RESTORE);
         restoreItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,menuItemSelectHandler);
         restoreItem.enabled = windowState != MDIWindowState.NORMAL;
         defaultContextMenu.customItems.push(restoreItem);
         closeItem = new ContextMenuItem(MDIWindow.CONTEXT_MENU_LABEL_CLOSE);
         closeItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,menuItemSelectHandler);
         defaultContextMenu.customItems.push(closeItem);
         arrangeItem = new ContextMenuItem(MDIManager.CONTEXT_MENU_LABEL_TILE);
         arrangeItem.separatorBefore = true;
         arrangeItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,menuItemSelectHandler);
         defaultContextMenu.customItems.push(arrangeItem);
         arrangeFillItem = new ContextMenuItem(MDIManager.CONTEXT_MENU_LABEL_TILE_FILL);
         arrangeFillItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,menuItemSelectHandler);
         defaultContextMenu.customItems.push(arrangeFillItem);
         cascadeItem = new ContextMenuItem(MDIManager.CONTEXT_MENU_LABEL_CASCADE);
         cascadeItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,menuItemSelectHandler);
         defaultContextMenu.customItems.push(cascadeItem);
         showAllItem = new ContextMenuItem(MDIManager.CONTEXT_MENU_LABEL_SHOW_ALL);
         showAllItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,menuItemSelectHandler);
         defaultContextMenu.customItems.push(showAllItem);
         this.contextMenu = defaultContextMenu;
      }
      
      private function setCursor(target:Button) : void
      {
         var styleStub:String = null;
         var selectorList:Array = null;
         switch(target)
         {
            case resizeHandleRight:
            case resizeHandleLeft:
               styleStub = "resizeCursorHorizontal";
               break;
            case resizeHandleTop:
            case resizeHandleBottom:
               styleStub = "resizeCursorVertical";
               break;
            case resizeHandleTL:
            case resizeHandleBR:
               styleStub = "resizeCursorTopLeftBottomRight";
               break;
            case resizeHandleTR:
            case resizeHandleBL:
               styleStub = "resizeCursorTopRightBottomLeft";
         }
         selectorList = getSelectorList();
         CursorManager.removeCursor(CursorManager.currentCursorID);
         CursorManager.setCursor(Class(getStyleByPriority(selectorList,styleStub + "Skin")),2,Number(getStyleByPriority(selectorList,styleStub + "XOffset")),Number(getStyleByPriority(selectorList,styleStub + "YOffset")));
      }
      
      public function get maximized() : Boolean
      {
         return _windowState == MDIWindowState.MAXIMIZED;
      }
      
      public function getTitleIconObject() : DisplayObject
      {
         return titleIconObject as DisplayObject;
      }
      
      private function onResizeButtonDrag(event:MouseEvent) : void
      {
         if(!_resizing)
         {
            _resizing = true;
            dispatchEvent(new MDIWindowEvent(MDIWindowEvent.RESIZE_START,this));
         }
         dispatchEvent(new MDIWindowEvent(MDIWindowEvent.RESIZE,this));
      }
      
      private function menuItemSelectHandler(event:ContextMenuEvent) : void
      {
         switch(event.target.caption)
         {
            case MDIWindow.CONTEXT_MENU_LABEL_MINIMIZE:
               minimize();
               break;
            case MDIWindow.CONTEXT_MENU_LABEL_MAXIMIZE:
               maximize();
               break;
            case MDIWindow.CONTEXT_MENU_LABEL_RESTORE:
               if(this.windowState == MDIWindowState.MINIMIZED)
               {
                  unMinimize();
               }
               else if(this.windowState == MDIWindowState.MAXIMIZED)
               {
                  maximizeRestore();
               }
               break;
            case MDIWindow.CONTEXT_MENU_LABEL_CLOSE:
               close();
               break;
            case MDIManager.CONTEXT_MENU_LABEL_TILE:
               this.windowManager.tile(false,this.windowManager.tilePadding);
               break;
            case MDIManager.CONTEXT_MENU_LABEL_TILE_FILL:
               this.windowManager.tile(true,this.windowManager.tilePadding);
               break;
            case MDIManager.CONTEXT_MENU_LABEL_CASCADE:
               this.windowManager.cascade();
               break;
            case MDIManager.CONTEXT_MENU_LABEL_SHOW_ALL:
               this.windowManager.showAllWindows();
         }
      }
      
      public function set windowStyleName(value:Object) : void
      {
         if(_windowStyleName === value)
         {
            return;
         }
         _windowStyleName = value;
         updateStyles();
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         if(!styleProp || styleProp == "styleName")
         {
            updateStyles();
         }
      }
      
      private function onResizeButtonRelease(event:MouseEvent = null) : void
      {
         if(windowState == MDIWindowState.NORMAL && resizable)
         {
            if(_resizing)
            {
               _resizing = false;
               dispatchEvent(new MDIWindowEvent(MDIWindowEvent.RESIZE_END,this));
            }
            currentResizeHandle = null;
            systemManager.removeEventListener(Event.ENTER_FRAME,updateWindowSize);
            systemManager.removeEventListener(MouseEvent.MOUSE_MOVE,onResizeButtonDrag);
            systemManager.removeEventListener(MouseEvent.MOUSE_UP,onResizeButtonRelease);
            systemManager.stage.removeEventListener(Event.MOUSE_LEAVE,onMouseLeaveStage);
            CursorManager.removeCursor(CursorManager.currentCursorID);
         }
      }
      
      public function restoreStyle() : void
      {
      }
      
      protected function getSelectorList() : Array
      {
         var selectorList:Array = null;
         var typeSelector:CSSStyleDeclaration = null;
         var classSelector:CSSStyleDeclaration = null;
         selectorList = new Array(this);
         if(Boolean(windowStyleName))
         {
            classSelector = StyleManager.getStyleDeclaration("." + windowStyleName);
            if(Boolean(classSelector))
            {
               selectorList.push(classSelector);
            }
         }
         typeSelector = StyleManager.getStyleDeclaration("MDIWindow");
         selectorList.push(typeSelector);
         return selectorList;
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         super.updateDisplayList(w,h);
         titleBarOverlay.width = this.width;
         titleBarOverlay.height = this.titleBar.height;
         resizeHandleTop.x = cornerHandleSize * 0.5;
         resizeHandleTop.y = -(edgeHandleSize * 0.5);
         resizeHandleTop.width = this.width - cornerHandleSize;
         resizeHandleTop.height = edgeHandleSize;
         resizeHandleRight.x = this.width - edgeHandleSize * 0.5;
         resizeHandleRight.y = cornerHandleSize * 0.5;
         resizeHandleRight.width = edgeHandleSize;
         resizeHandleRight.height = this.height - cornerHandleSize;
         resizeHandleBottom.x = cornerHandleSize * 0.5;
         resizeHandleBottom.y = this.height - edgeHandleSize * 0.5;
         resizeHandleBottom.width = this.width - cornerHandleSize;
         resizeHandleBottom.height = edgeHandleSize;
         resizeHandleLeft.x = -(edgeHandleSize * 0.5);
         resizeHandleLeft.y = cornerHandleSize * 0.5;
         resizeHandleLeft.width = edgeHandleSize;
         resizeHandleLeft.height = this.height - cornerHandleSize;
         resizeHandleTL.x = resizeHandleTL.y = -(cornerHandleSize * 0.5);
         resizeHandleTL.width = resizeHandleTL.height = cornerHandleSize;
         resizeHandleTR.x = this.width - cornerHandleSize * 0.5;
         resizeHandleTR.y = -(cornerHandleSize * 0.5);
         resizeHandleTR.width = resizeHandleTR.height = cornerHandleSize;
         resizeHandleBR.x = this.width - cornerHandleSize * 0.5;
         resizeHandleBR.y = this.height - cornerHandleSize * 0.5;
         resizeHandleBR.width = resizeHandleBR.height = cornerHandleSize;
         resizeHandleBL.x = -(cornerHandleSize * 0.5);
         resizeHandleBL.y = this.height - cornerHandleSize * 0.5;
         resizeHandleBL.width = resizeHandleBL.height = cornerHandleSize;
         UIComponent(windowControls).invalidateDisplayList();
      }
   }
}

