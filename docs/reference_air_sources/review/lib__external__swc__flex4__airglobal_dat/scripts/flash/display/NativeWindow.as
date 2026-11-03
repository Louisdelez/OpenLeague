package flash.display
{
   import flash.errors.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.utils.*;
   
   [API("661")]
   [native(cls="WindowClass",instance="WindowObject",methods="auto")]
   [Event(name="deactivate",type="flash.events.Event")]
   [Event(name="activate",type="flash.events.Event")]
   [Event(name="close",type="flash.events.Event")]
   [Event(name="closing",type="flash.events.Event")]
   [Event(name="displayStateChange",type="flash.events.NativeWindowDisplayStateEvent")]
   [Event(name="displayStateChanging",type="flash.events.NativeWindowDisplayStateEvent")]
   [Event(name="resize",type="flash.events.NativeWindowBoundsEvent")]
   [Event(name="resizing",type="flash.events.NativeWindowBoundsEvent")]
   [Event(name="move",type="flash.events.NativeWindowBoundsEvent")]
   [Event(name="moving",type="flash.events.NativeWindowBoundsEvent")]
   public class NativeWindow extends EventDispatcher
   {
      
      private static const _supportsMenu:Boolean = initSupportsMenu();
      
      private static const _supportsNotifyUser:Boolean = initSupportsNotifyUser();
      
      private static const _systemMinSize:Point = initSystemMinSize();
      
      private static var _skipEnsureZOrder:Boolean = false;
      
      private var bRequestedVisibility:Boolean = false;
      
      public function NativeWindow(initOptions:NativeWindowInitOptions)
      {
         super();
         if(!initOptions)
         {
            Error.throwError(ArgumentError,2007,"initOptions");
         }
         if(initOptions.transparent == true && initOptions.systemChrome != NativeWindowSystemChrome.NONE)
         {
            throw new Error("Illegal window settings.  Transparent windows are only supported when systemChrome is set to \"none\".");
         }
         if(initOptions.type == NativeWindowType.LIGHTWEIGHT && initOptions.systemChrome != NativeWindowSystemChrome.NONE)
         {
            throw new Error("Illegal window settings.  Lightweight windows are only supported when systemChrome is set to \"none\".");
         }
         if(initOptions.owner != null && initOptions.owner.closed == true)
         {
            throw new Error("Illegal window settings.  Owner windows cannot be closed.");
         }
         this._init(initOptions,false);
         if(initOptions.owner != null)
         {
            this.alwaysInFront = initOptions.owner.alwaysInFront;
            this._owner = initOptions.owner;
            this.owner.addOwnedWindow(this);
         }
      }
      
      [Version("air2.0")]
      public static function get isSupported() : Boolean
      {
         return true;
      }
      
      public static function get supportsMenu() : Boolean
      {
         _checkAccess();
         return _supportsMenu;
      }
      
      private static native function initSupportsMenu() : Boolean;
      
      public static function get supportsNotification() : Boolean
      {
         _checkAccess();
         return _supportsNotifyUser;
      }
      
      private static native function initSupportsNotifyUser() : Boolean;
      
      public static function get supportsTransparency() : Boolean
      {
         _checkAccess();
         return _supportsTransparency;
      }
      
      private static native function get _supportsTransparency() : Boolean;
      
      public static function get systemMinSize() : Point
      {
         _checkAccess();
         var newPt:Point = new Point();
         newPt.x = _systemMinSize.x;
         newPt.y = _systemMinSize.y;
         return newPt;
      }
      
      private static native function initSystemMinSize() : Point;
      
      public static native function get systemMaxSize() : Point;
      
      private static native function _checkAccess() : void;
      
      private static native function _restoreIsAsync() : Boolean;
      
      private native function _init(param1:NativeWindowInitOptions, param2:Boolean) : void;
      
      public native function get stage() : Stage;
      
      public function get title() : String
      {
         if(this.closed)
         {
            Error.throwError(IllegalOperationError,3200);
         }
         return this._title;
      }
      
      public function set title(value:String) : void
      {
         if(this.closed)
         {
            Error.throwError(IllegalOperationError,3200);
         }
         this._title = value;
      }
      
      public function get bounds() : Rectangle
      {
         if(this.closed)
         {
            Error.throwError(IllegalOperationError,3200);
         }
         return this._bounds;
      }
      
      public function set bounds(rect:Rectangle) : void
      {
         var setMyBounds:Function = null;
         if(rect == null)
         {
            Error.throwError(ArgumentError,2007,"rect");
         }
         if(Boolean(isNaN(rect.x)) || Boolean(isNaN(rect.y)) || Boolean(isNaN(rect.width)) || Boolean(isNaN(rect.height)))
         {
            Error.throwError(ArgumentError,2004);
         }
         if(this.closed)
         {
            Error.throwError(IllegalOperationError,3200);
         }
         if(Boolean(this.displayState == NativeWindowDisplayState.MINIMIZED) && Boolean(rect.height) && Boolean(rect.width))
         {
            if(Boolean(_restoreIsAsync))
            {
               setMyBounds = function(event:*):void
               {
                  removeEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE,setMyBounds);
                  _bounds = rect;
               };
               addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE,setMyBounds);
               this.restore();
               return;
            }
            this.restore();
         }
         else if(this.stage.displayState == StageDisplayState.FULL_SCREEN || this.stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE)
         {
            this.stage.displayState = StageDisplayState.NORMAL;
         }
         this._bounds = rect;
      }
      
      public function get displayState() : String
      {
         if(this.closed)
         {
            Error.throwError(IllegalOperationError,3200);
         }
         return this._displayState;
      }
      
      public function minimize() : void
      {
         if(this.closed)
         {
            Error.throwError(IllegalOperationError,3200);
         }
         if(this.stage.displayState == StageDisplayState.FULL_SCREEN || this.stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE)
         {
            this.stage.displayState = StageDisplayState.NORMAL;
         }
         _skipEnsureZOrder = true;
         this._minimize();
         _skipEnsureZOrder = false;
      }
      
      public function maximize() : void
      {
         if(this.closed)
         {
            Error.throwError(IllegalOperationError,3200);
         }
         if(!this._ownerChainIsDisplayed())
         {
            return;
         }
         if(this.stage.displayState == StageDisplayState.FULL_SCREEN || this.stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE)
         {
            this.stage.displayState = StageDisplayState.NORMAL;
         }
         this._maximize();
      }
      
      public function restore() : void
      {
         if(this.closed)
         {
            Error.throwError(IllegalOperationError,3200);
         }
         if(!this._ownerChainIsDisplayed())
         {
            return;
         }
         if(this.stage.displayState == StageDisplayState.FULL_SCREEN || this.stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE)
         {
            this.stage.displayState = StageDisplayState.NORMAL;
         }
         this._restore();
      }
      
      public native function close() : void;
      
      public native function get closed() : Boolean;
      
      private function _isDisplayed() : Boolean
      {
         return !this.closed && Boolean(this.actualVisibility()) && !this._minimized;
      }
      
      private native function get _minimized() : Boolean;
      
      private function actualVisibility() : Boolean
      {
         if(this.closed)
         {
            Error.throwError(IllegalOperationError,3200);
         }
         return this._visible;
      }
      
      public function get visible() : Boolean
      {
         if(this.closed)
         {
            Error.throwError(IllegalOperationError,3200);
         }
         return this.bRequestedVisibility;
      }
      
      public function set visible(value:Boolean) : void
      {
         var wantVisibility:Boolean = false;
         if(this.closed)
         {
            Error.throwError(IllegalOperationError,3200);
         }
         this.bRequestedVisibility = value;
         var hasVisibility:Boolean = Boolean(this._visible);
         if(this.bRequestedVisibility != hasVisibility)
         {
            wantVisibility = Boolean(this.bRequestedVisibility);
            if(this._owner != null)
            {
               wantVisibility &&= Boolean(this._owner._isDisplayed());
            }
            if(wantVisibility != hasVisibility)
            {
               this._showHide(wantVisibility);
            }
         }
      }
      
      private function _showHide(desiredVisibility:Boolean) : void
      {
         var windowToOrderInFrontOf:NativeWindow = null;
         var i:int = 0;
         var zOrderedOwnedWindowsOfOwner:Vector.<NativeWindow> = null;
         var effectiveVisibility:Boolean = Boolean(this.bRequestedVisibility) && desiredVisibility;
         if(effectiveVisibility != this._visible)
         {
            windowToOrderInFrontOf = this._owner;
            if(effectiveVisibility && this._owner != null)
            {
               if(this._owner._ownedWindows.length > 0)
               {
                  zOrderedOwnedWindowsOfOwner = this._getOwnedWindowsInFrontToBackZOrder(this._owner);
                  if(zOrderedOwnedWindowsOfOwner.length > 0)
                  {
                     windowToOrderInFrontOf = zOrderedOwnedWindowsOfOwner[0];
                  }
               }
            }
            this._visible = effectiveVisibility;
            if(Boolean(this._visible) && this._owner != null)
            {
               this._orderInFrontOf(windowToOrderInFrontOf);
            }
            for(i = 0; i < this._ownedWindows.length; i++)
            {
               if(this._ownedWindows[i].displayState != NativeWindowDisplayState.MINIMIZED)
               {
                  this._ownedWindows[i]._showHide(effectiveVisibility);
               }
            }
         }
      }
      
      public function get systemChrome() : String
      {
         if(this.closed)
         {
            Error.throwError(IllegalOperationError,3200);
         }
         return this._systemChrome;
      }
      
      public function get transparent() : Boolean
      {
         if(this.closed)
         {
            Error.throwError(IllegalOperationError,3200);
         }
         return this._transparent;
      }
      
      public function get type() : String
      {
         if(this.closed)
         {
            Error.throwError(IllegalOperationError,3200);
         }
         return this._type;
      }
      
      public function get minimizable() : Boolean
      {
         if(this.closed)
         {
            Error.throwError(IllegalOperationError,3200);
         }
         return this._minimizable;
      }
      
      public function get maximizable() : Boolean
      {
         if(this.closed)
         {
            Error.throwError(IllegalOperationError,3200);
         }
         return this._maximizable;
      }
      
      public function get resizable() : Boolean
      {
         if(this.closed)
         {
            Error.throwError(IllegalOperationError,3200);
         }
         return this._resizable;
      }
      
      public function startMove() : Boolean
      {
         if(this.closed)
         {
            Error.throwError(IllegalOperationError,3200);
         }
         return this._startMove();
      }
      
      public function startResize(edgeOrCorner:String = "BR") : Boolean
      {
         if(this.closed)
         {
            Error.throwError(IllegalOperationError,3200);
         }
         return this._startResize(edgeOrCorner);
      }
      
      public function get minSize() : Point
      {
         if(this.closed)
         {
            Error.throwError(IllegalOperationError,3200);
         }
         return this._minSize;
      }
      
      public function set minSize(size:Point) : void
      {
         if(size == null)
         {
            Error.throwError(ArgumentError,2007,"size");
         }
         if(Boolean(isNaN(size.x)) || Boolean(isNaN(size.y)))
         {
            Error.throwError(ArgumentError,2004);
         }
         if(this.closed)
         {
            Error.throwError(IllegalOperationError,3200);
         }
         this._minSize = size;
      }
      
      public function get maxSize() : Point
      {
         if(this.closed)
         {
            Error.throwError(IllegalOperationError,3200);
         }
         return this._maxSize;
      }
      
      public function set maxSize(size:Point) : void
      {
         if(size == null)
         {
            Error.throwError(ArgumentError,2007,"size");
         }
         if(Boolean(isNaN(size.x)) || Boolean(isNaN(size.y)))
         {
            Error.throwError(ArgumentError,2004);
         }
         if(this.closed)
         {
            Error.throwError(IllegalOperationError,3200);
         }
         this._maxSize = size;
         var currMax:Point = this._maxSize;
         var rect:Rectangle = this.bounds;
         if(currMax.x < rect.width || currMax.y < rect.height)
         {
            if(currMax.x < rect.width)
            {
               rect.width = currMax.x;
            }
            if(currMax.y < rect.height)
            {
               rect.height = currMax.y;
            }
            this.bounds = rect;
         }
      }
      
      public function orderToFront() : Boolean
      {
         if(this.owner == null && this._ownedWindows.length == 0)
         {
            return this._orderToFront();
         }
         this._implOrderToFront();
         return true;
      }
      
      private native function _orderToFront() : Boolean;
      
      public function orderToBack() : Boolean
      {
         if(this.owner == null && this._ownedWindows.length == 0)
         {
            return this._orderToBack();
         }
         this._implOrderToBack();
         return true;
      }
      
      private native function _orderToBack() : Boolean;
      
      public function orderInFrontOf(window:NativeWindow) : Boolean
      {
         var currentOwnedWindows:Vector.<NativeWindow> = null;
         var j:int = 0;
         var commonOwner:NativeWindow = null;
         var subtreeToMove:Vector.<NativeWindow> = null;
         var isAllowed:Boolean = Boolean(this._isDisplayed()) && Boolean(window._isDisplayed());
         if(!isAllowed)
         {
            return false;
         }
         var subtree:Vector.<NativeWindow> = new Vector.<NativeWindow>();
         subtree.push(this);
         for(var i:int = 0; i < subtree.length; i++)
         {
            if(subtree[i] == window)
            {
               isAllowed = false;
               break;
            }
            currentOwnedWindows = subtree[i]._ownedWindows;
            for(j = 0; j < currentOwnedWindows.length; j++)
            {
               subtree.push(currentOwnedWindows[j]);
            }
         }
         if(isAllowed)
         {
            commonOwner = this._findCommonOwner(this,window);
            window = this._findWindowWithHighestZ(window,commonOwner);
            _skipEnsureZOrder = true;
            subtreeToMove = this._getSubtreeInFrontToBackZOrder(this,commonOwner);
            for(j = 0; j < subtreeToMove.length; j++)
            {
               if(subtreeToMove[j]._orderInFrontOf(window) == false)
               {
                  _skipEnsureZOrder = false;
                  return false;
               }
            }
            _skipEnsureZOrder = false;
            return true;
         }
         return false;
      }
      
      private native function _orderInFrontOf(param1:NativeWindow) : Boolean;
      
      public function orderInBackOf(window:NativeWindow) : Boolean
      {
         var commonOwner:NativeWindow = null;
         var subtreeToMove:Vector.<NativeWindow> = null;
         var j:int = 0;
         var isAllowed:Boolean = Boolean(this._isDisplayed()) && Boolean(window._isDisplayed());
         var testWindow:NativeWindow = this.owner;
         while(Boolean(testWindow) && isAllowed)
         {
            if(window == testWindow)
            {
               isAllowed = false;
            }
            testWindow = testWindow.owner;
         }
         if(isAllowed)
         {
            commonOwner = this._findCommonOwner(this,window);
            window = this._findWindowWithLowestZ(window,commonOwner);
            _skipEnsureZOrder = true;
            subtreeToMove = this._getSubtreeInFrontToBackZOrder(this,commonOwner);
            subtreeToMove.reverse();
            for(j = 0; j < subtreeToMove.length; j++)
            {
               if(subtreeToMove[j]._orderInBackOf(window) == false)
               {
                  _skipEnsureZOrder = false;
                  return false;
               }
            }
            _skipEnsureZOrder = false;
            return true;
         }
         return false;
      }
      
      private native function _orderInBackOf(param1:NativeWindow) : Boolean;
      
      public native function get alwaysInFront() : Boolean;
      
      public native function set alwaysInFront(param1:Boolean) : void;
      
      public function get active() : Boolean
      {
         if(this.closed)
         {
            Error.throwError(IllegalOperationError,3200);
         }
         return this._active;
      }
      
      public function activate() : void
      {
         var i:int = 0;
         if(this.closed)
         {
            Error.throwError(IllegalOperationError,3200);
         }
         if(!this._ownerChainIsDisplayed())
         {
            return;
         }
         this._activate();
         if(!this.bRequestedVisibility)
         {
            this.bRequestedVisibility = true;
            for(i = 0; i < this._ownedWindows.length; i++)
            {
               if(this._ownedWindows[i].displayState != NativeWindowDisplayState.MINIMIZED)
               {
                  this._ownedWindows[i]._showHide(true);
               }
            }
         }
      }
      
      public native function globalToScreen(param1:Point) : Point;
      
      public native function get menu() : NativeMenu;
      
      public function set menu(value:NativeMenu) : void
      {
         if(this.systemChrome != NativeWindowSystemChrome.STANDARD)
         {
            throw new Error("Illegal window settings.  Window menus are only supported when systemChrome is set to \"standard\".");
         }
         this._menu = value;
      }
      
      private native function set _menu(param1:NativeMenu) : void;
      
      public function get width() : Number
      {
         var rect:Rectangle = this.bounds;
         return rect.width;
      }
      
      public function set width(value:Number) : void
      {
         if(isNaN(value))
         {
            Error.throwError(ArgumentError,2004);
         }
         if(this.closed)
         {
            Error.throwError(IllegalOperationError,3200);
         }
         if(Boolean(this.displayState == NativeWindowDisplayState.MINIMIZED) && Boolean(value) && Boolean(this.bounds.height))
         {
            this.restore();
         }
         else if(this.stage.displayState == StageDisplayState.FULL_SCREEN || this.stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE)
         {
            this.stage.displayState = StageDisplayState.NORMAL;
         }
         this._width = value;
      }
      
      public function get height() : Number
      {
         var rect:Rectangle = this.bounds;
         return rect.height;
      }
      
      public function set height(value:Number) : void
      {
         if(isNaN(value))
         {
            Error.throwError(ArgumentError,2004);
         }
         if(this.closed)
         {
            Error.throwError(IllegalOperationError,3200);
         }
         if(Boolean(this.displayState == NativeWindowDisplayState.MINIMIZED) && Boolean(this.bounds.width) && Boolean(value))
         {
            this.restore();
         }
         else if(this.stage.displayState == StageDisplayState.FULL_SCREEN || this.stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE)
         {
            this.stage.displayState = StageDisplayState.NORMAL;
         }
         this._height = value;
      }
      
      public function get x() : Number
      {
         var rect:Rectangle = this.bounds;
         return rect.x;
      }
      
      public function set x(value:Number) : void
      {
         if(isNaN(value))
         {
            Error.throwError(ArgumentError,2004);
         }
         if(this.closed)
         {
            Error.throwError(IllegalOperationError,3200);
         }
         if(Boolean(this.displayState == NativeWindowDisplayState.MINIMIZED) && Boolean(this.bounds.width) && Boolean(this.bounds.height))
         {
            this.restore();
         }
         else if(this.stage.displayState == StageDisplayState.FULL_SCREEN || this.stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE)
         {
            this.stage.displayState = StageDisplayState.NORMAL;
         }
         this._x = value;
      }
      
      public native function notifyUser(param1:String) : void;
      
      public function get y() : Number
      {
         var rect:Rectangle = this.bounds;
         return rect.y;
      }
      
      public function set y(value:Number) : void
      {
         if(isNaN(value))
         {
            Error.throwError(ArgumentError,2004);
         }
         if(this.closed)
         {
            Error.throwError(IllegalOperationError,3200);
         }
         if(Boolean(this.displayState == NativeWindowDisplayState.MINIMIZED) && Boolean(this.bounds.width) && Boolean(this.bounds.height))
         {
            this.restore();
         }
         else if(this.stage.displayState == StageDisplayState.FULL_SCREEN || this.stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE)
         {
            this.stage.displayState = StageDisplayState.NORMAL;
         }
         this._y = value;
      }
      
      [API("671")]
      public function get owner() : NativeWindow
      {
         return this._owner;
      }
      
      private native function get _owner() : NativeWindow;
      
      private native function set _owner(param1:NativeWindow) : void;
      
      [API("671")]
      public function listOwnedWindows() : Vector.<NativeWindow>
      {
         var numOwnedWindows:int = int(this._ownedWindows.length);
         var snapshot:Vector.<NativeWindow> = new Vector.<NativeWindow>(numOwnedWindows,true);
         for(var i:int = 0; i < numOwnedWindows; i++)
         {
            snapshot[i] = this._ownedWindows[i];
         }
         return snapshot;
      }
      
      private native function get _ownedWindows() : Vector.<NativeWindow>;
      
      private function listOwnedWindowsOnScreen() : Vector.<NativeWindow>
      {
         var numOwnedWindows:int = int(this._ownedWindows.length);
         var snapshot:Vector.<NativeWindow> = new Vector.<NativeWindow>(numOwnedWindows,false);
         var nbActualWindowsOnScreen:int = 0;
         for(var i:int = 0; i < numOwnedWindows; i++)
         {
            if(this._ownedWindows[i]._isDisplayed())
            {
               snapshot[nbActualWindowsOnScreen] = this._ownedWindows[i];
               nbActualWindowsOnScreen++;
            }
         }
         snapshot.length = nbActualWindowsOnScreen;
         return snapshot;
      }
      
      private function addOwnedWindow(ownedWindow:NativeWindow) : void
      {
         if(this._ownedWindows.length == 0)
         {
            addEventListener(Event.CLOSE,this.closedOwnerWindow);
            addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE,this.displayStateChangeForOwnerWindow);
         }
         ownedWindow.addEventListener(Event.CLOSE,function(e:Event):void
         {
            removeOwnedWindow(ownedWindow);
         });
         ownedWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE,ownedWindow.displayStateChangeForOwnedWindow);
         this._ownedWindows.push(ownedWindow);
      }
      
      private function removeOwnedWindow(ownedWindow:NativeWindow) : void
      {
         var i:int = int(this._ownedWindows.indexOf(ownedWindow));
         if(i >= 0)
         {
            this._ownedWindows.splice(i,1);
         }
         ownedWindow.removeEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE,ownedWindow.displayStateChangeForOwnedWindow);
         if(this._ownedWindows.length == 0)
         {
            removeEventListener(Event.CLOSE,this.closedOwnerWindow);
            removeEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE,this.displayStateChangeForOwnerWindow);
         }
      }
      
      private function closedOwnerWindow(e:Event) : void
      {
         var i:int = 0;
         var owned:Vector.<NativeWindow> = this.listOwnedWindows();
         for(i = 0; i < owned.length; i++)
         {
            owned[i].close();
         }
      }
      
      private function displayStateChangeForOwnedWindow(e:NativeWindowDisplayStateEvent) : void
      {
         if(e.beforeDisplayState == NativeWindowDisplayState.MINIMIZED)
         {
            if(this._owner != null && !this._owner.closed && (!this._owner.actualVisibility() || this._owner.displayState == NativeWindowDisplayState.MINIMIZED))
            {
               this._showHide(false);
            }
         }
      }
      
      private function displayStateChangeForOwnerWindow(e:NativeWindowDisplayStateEvent) : void
      {
         var i:int = 0;
         if(e.beforeDisplayState == NativeWindowDisplayState.MINIMIZED)
         {
            if(!(this._owner != null && !this._owner.closed && (!this._owner.actualVisibility() || this._owner.displayState == NativeWindowDisplayState.MINIMIZED)))
            {
               for(i = 0; i < this._ownedWindows.length; i++)
               {
                  if(this._ownedWindows[i].displayState != NativeWindowDisplayState.MINIMIZED)
                  {
                     this._ownedWindows[i]._showHide(true);
                  }
                  else
                  {
                     this._ownedWindows[i].minimize();
                  }
               }
            }
         }
         else if(e.afterDisplayState == NativeWindowDisplayState.MINIMIZED)
         {
            for(i = 0; i < this._ownedWindows.length; i++)
            {
               this._ownedWindows[i]._showHide(false);
            }
         }
      }
      
      private function _findCommonOwner(thisWindow:NativeWindow, thatWindow:NativeWindow) : NativeWindow
      {
         var thatParent:NativeWindow = null;
         if(thisWindow != null && thisWindow == thatWindow)
         {
            return thisWindow.owner;
         }
         var thisParent:NativeWindow = thisWindow;
         loop0:
         while(thisParent != null)
         {
            thatParent = thatWindow;
            while(true)
            {
               if(thatParent == null)
               {
                  thisParent = thisParent.owner;
                  continue loop0;
               }
               if(thisParent == thatParent)
               {
                  break;
               }
               thatParent = thatParent.owner;
            }
            return thisParent;
         }
         return null;
      }
      
      private function _getOwnedWindowsInFrontToBackZOrder(thisWindow:NativeWindow, zOrderInfo:Dictionary = null) : Vector.<NativeWindow>
      {
         var sortedOwnedWindows:Vector.<NativeWindow>;
         if(zOrderInfo == null)
         {
            zOrderInfo = this._buildZOrderInfoDictionary();
         }
         sortedOwnedWindows = thisWindow.listOwnedWindowsOnScreen();
         sortedOwnedWindows.sort(function(x:NativeWindow, y:NativeWindow):Number
         {
            return zOrderInfo[x] > zOrderInfo[y] ? 1 : -1;
         });
         return sortedOwnedWindows;
      }
      
      private function _getSubtreeInFrontToBackZOrder(window:NativeWindow, rootOwner:NativeWindow) : Vector.<NativeWindow>
      {
         var rootOfSubtree:NativeWindow = window;
         if(rootOfSubtree != rootOwner)
         {
            while(rootOfSubtree.owner != rootOwner)
            {
               rootOfSubtree = rootOfSubtree.owner;
            }
         }
         var zOrderInfo:Dictionary = this._buildZOrderInfoDictionary();
         var zOrderedSubTree:Vector.<NativeWindow> = new Vector.<NativeWindow>();
         this._buildWindowTreeRecursive(rootOfSubtree,zOrderedSubTree,zOrderInfo);
         zOrderedSubTree.reverse();
         return zOrderedSubTree;
      }
      
      private function _findWindowWithHighestZ(window:NativeWindow, rootOwner:NativeWindow) : NativeWindow
      {
         var zOrderedSubtree:Vector.<NativeWindow> = this._getSubtreeInFrontToBackZOrder(window,rootOwner);
         return zOrderedSubtree.shift();
      }
      
      private function _findWindowWithLowestZ(window:NativeWindow, rootOwner:NativeWindow) : NativeWindow
      {
         var result:NativeWindow = window;
         while(result.owner != rootOwner)
         {
            result = result.owner;
         }
         return result;
      }
      
      private function _traceWindowList(windows:Vector.<NativeWindow>, message:String = null) : void
      {
         var m:String = "";
         if(Boolean(message))
         {
            m = message;
         }
         for(var j:int = 0; j < windows.length; j++)
         {
            m += " | " + windows[j].title;
         }
         trace(m);
      }
      
      private function _traceZOrderWindowList(message:String) : void
      {
         var zOrderedWindows:Vector.<NativeWindow> = this._listDisplayedWindowsInFrontToBackZOrder();
         this._traceWindowList(zOrderedWindows,message);
      }
      
      private native function _listDisplayedWindowsInFrontToBackZOrder() : Vector.<NativeWindow>;
      
      private function _buildZOrderInfoDictionary() : Dictionary
      {
         var zOrderInfo:Dictionary = new Dictionary();
         var zOrderedWindows:Vector.<NativeWindow> = this._listDisplayedWindowsInFrontToBackZOrder();
         for(var i:int = 0; i < zOrderedWindows.length; i++)
         {
            zOrderInfo[zOrderedWindows[i]] = i;
         }
         return zOrderInfo;
      }
      
      private function _ensureZOrder() : void
      {
         if(_skipEnsureZOrder)
         {
            return;
         }
         this._implOrderToFront();
      }
      
      private function _implOrderToFront() : void
      {
         if(!this._isDisplayed())
         {
            return;
         }
         var rootWindow:NativeWindow = this;
         var ownerWindows:Dictionary = new Dictionary();
         ownerWindows[rootWindow] = true;
         while(!rootWindow.closed && Boolean(rootWindow.owner))
         {
            rootWindow = rootWindow.owner;
            ownerWindows[rootWindow] = true;
         }
         if(rootWindow.closed)
         {
            return;
         }
         var zOrderInfo:Dictionary = this._buildZOrderInfoDictionary();
         var windowList:Vector.<NativeWindow> = new Vector.<NativeWindow>();
         this._buildWindowTreeRecursiveOrderToFront(rootWindow,windowList,zOrderInfo,ownerWindows);
         var visibleWindowCount:int = 0;
         for(var i:int = 0; i < windowList.length; i++)
         {
            if(windowList[i]._isDisplayed())
            {
               visibleWindowCount++;
            }
         }
         _skipEnsureZOrder = true;
         var zOrderedAppWindows:Vector.<NativeWindow> = this._listDisplayedWindowsInFrontToBackZOrder();
         var foundMissMatch:Boolean = false;
         var zk:int = visibleWindowCount - 1;
         if(zk >= zOrderedAppWindows.length)
         {
            zk = zOrderedAppWindows.length - 1;
         }
         var k:int = 0;
         while(k < windowList.length && zk >= 0)
         {
            if(windowList[k]._isDisplayed())
            {
               if(!foundMissMatch && zOrderedAppWindows[zk] != windowList[k])
               {
                  foundMissMatch = true;
               }
               zk--;
               if(foundMissMatch)
               {
                  windowList[k]._orderToFront();
               }
            }
            k++;
         }
         _skipEnsureZOrder = false;
      }
      
      private function _implOrderToBack() : void
      {
         if(!this._isDisplayed())
         {
            return;
         }
         var rootWindow:NativeWindow = this;
         var ownerWindows:Dictionary = new Dictionary();
         ownerWindows[rootWindow] = true;
         while(!rootWindow.closed && Boolean(rootWindow.owner))
         {
            rootWindow = rootWindow.owner;
            ownerWindows[rootWindow] = true;
         }
         if(rootWindow.closed)
         {
            return;
         }
         var zOrderInfo:Dictionary = this._buildZOrderInfoDictionary();
         var windowList:Vector.<NativeWindow> = new Vector.<NativeWindow>();
         this._buildWindowTreeRecursiveOrderToBack(rootWindow,windowList,zOrderInfo,ownerWindows);
         windowList.reverse();
         _skipEnsureZOrder = true;
         for(var k:int = 0; k < windowList.length; k++)
         {
            if(windowList[k]._isDisplayed())
            {
               windowList[k]._orderToBack();
            }
         }
         _skipEnsureZOrder = false;
      }
      
      private function _buildWindowTreeRecursive(thisWindow:NativeWindow, windowList:Vector.<NativeWindow>, zOrderInfo:Dictionary) : void
      {
         windowList.push(thisWindow);
         var zOrderedOwnedWindows:Vector.<NativeWindow> = this._getOwnedWindowsInFrontToBackZOrder(thisWindow,zOrderInfo);
         for(var i:int = zOrderedOwnedWindows.length - 1; i >= 0; i--)
         {
            this._buildWindowTreeRecursive(zOrderedOwnedWindows[i],windowList,zOrderInfo);
         }
      }
      
      private function _buildWindowTreeRecursiveOrderToFront(thisWindow:NativeWindow, windowList:Vector.<NativeWindow>, zOrderInfo:Dictionary, ownerWindows:Dictionary) : void
      {
         windowList.push(thisWindow);
         var zOrderedOwnedWindows:Vector.<NativeWindow> = this._getOwnedWindowsInFrontToBackZOrder(thisWindow,zOrderInfo);
         var windowToFront:NativeWindow = null;
         for(var i:int = zOrderedOwnedWindows.length - 1; i >= 0; i--)
         {
            if(!ownerWindows[zOrderedOwnedWindows[i]])
            {
               this._buildWindowTreeRecursiveOrderToFront(zOrderedOwnedWindows[i],windowList,zOrderInfo,ownerWindows);
            }
            else
            {
               windowToFront = zOrderedOwnedWindows[i];
            }
         }
         if(Boolean(windowToFront))
         {
            this._buildWindowTreeRecursiveOrderToFront(windowToFront,windowList,zOrderInfo,ownerWindows);
         }
      }
      
      private function _buildWindowTreeRecursiveOrderToBack(thisWindow:NativeWindow, windowList:Vector.<NativeWindow>, zOrderInfo:Dictionary, ownerWindows:Dictionary) : void
      {
         windowList.push(thisWindow);
         var zOrderedOwnedWindows:Vector.<NativeWindow> = this._getOwnedWindowsInFrontToBackZOrder(thisWindow,zOrderInfo);
         var windowToBack:NativeWindow = null;
         for(var k:int = zOrderedOwnedWindows.length - 1; k >= 0; k--)
         {
            if(ownerWindows[zOrderedOwnedWindows[k]] == true)
            {
               windowToBack = zOrderedOwnedWindows[k];
               break;
            }
         }
         if(Boolean(windowToBack))
         {
            this._buildWindowTreeRecursiveOrderToBack(windowToBack,windowList,zOrderInfo,ownerWindows);
         }
         for(var i:int = zOrderedOwnedWindows.length - 1; i >= 0; i--)
         {
            if(zOrderedOwnedWindows[i] != windowToBack)
            {
               this._buildWindowTreeRecursiveOrderToBack(zOrderedOwnedWindows[i],windowList,zOrderInfo,ownerWindows);
            }
         }
      }
      
      private function _ownerChainIsDisplayed() : Boolean
      {
         var ownerToCheck:NativeWindow = this.owner;
         while(ownerToCheck != null)
         {
            if(ownerToCheck._isDisplayed() == false)
            {
               return false;
            }
            ownerToCheck = ownerToCheck.owner;
         }
         return true;
      }
      
      [API("675")]
      public function get renderMode() : String
      {
         if(this.closed)
         {
            Error.throwError(IllegalOperationError,3200);
         }
         return this._renderMode;
      }
      
      private native function get _renderMode() : String;
      
      private native function set _title(param1:String) : void;
      
      private native function get _title() : String;
      
      private native function set _bounds(param1:Rectangle) : void;
      
      private native function get _bounds() : Rectangle;
      
      private native function set _x(param1:Number) : void;
      
      private native function set _y(param1:Number) : void;
      
      private native function set _width(param1:Number) : void;
      
      private native function set _height(param1:Number) : void;
      
      private native function set _minSize(param1:Point) : void;
      
      private native function get _minSize() : Point;
      
      private native function set _maxSize(param1:Point) : void;
      
      private native function get _maxSize() : Point;
      
      private native function get _displayState() : String;
      
      private native function _minimize() : void;
      
      private native function _maximize() : void;
      
      private native function _restore() : void;
      
      private native function get _active() : Boolean;
      
      private native function _activate() : void;
      
      private native function get _type() : String;
      
      private native function get _systemChrome() : String;
      
      private native function get _transparent() : Boolean;
      
      private native function set _visible(param1:Boolean) : void;
      
      private native function get _visible() : Boolean;
      
      private native function get _minimizable() : Boolean;
      
      private native function get _maximizable() : Boolean;
      
      private native function get _resizable() : Boolean;
      
      private native function _startMove() : Boolean;
      
      private native function _startResize(param1:String = "BR") : Boolean;
   }
}

