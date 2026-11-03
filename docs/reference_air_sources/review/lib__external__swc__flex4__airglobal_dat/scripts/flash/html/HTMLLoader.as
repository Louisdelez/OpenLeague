package flash.html
{
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.html.script.Package;
   import flash.net.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   
   use namespace AS3;
   
   [native(cls="HTMLLoaderClass",instance="HTMLLoaderObject",methods="IHTMLControlObject<HTMLLoaderObject>",construct="check")]
   [Event(name="htmlDOMInitialize",type="flash.events.Event")]
   [Event(name="uncaughtScriptException",type="flash.events.HTMLUncaughtScriptExceptionEvent")]
   [Event(name="scroll",type="flash.events.Event")]
   [Event(name="htmlBoundsChange",type="flash.events.Event")]
   [Event(name="locationChange",type="flash.events.LocationChangeEvent")]
   [Event(name="locationChange",type="flash.events.Event")]
   [Event(name="locationChanging",type="flash.events.LocationChangeEvent")]
   [Event(name="htmlRender",type="flash.events.Event")]
   [Event(name="complete",type="flash.events.Event")]
   public class HTMLLoader extends Sprite
   {
      
      private static var pageGroupSeq:uint = 0;
      
      private static const kNullPointerError:uint = 2007;
      
      private static const s_widthName:String = "width";
      
      private static const s_heightName:String = "height";
      
      private static const LeftButton:uint = 0;
      
      private static const MiddleButton:uint = 1;
      
      private static const RightButton:uint = 2;
      
      private const adobeAppProtocolPrefix:String = "app:/";
      
      private var m_savedMouseCursor:String;
      
      private var m_cursorSaved:Boolean = false;
      
      private var m_closing:Boolean = false;
      
      private var m_isStub:Boolean = false;
      
      private var m_isStageWebView:Boolean = false;
      
      private var m_isStageWebViewFocused:Boolean = false;
      
      private var m_stageWebViewParent:Sprite = null;
      
      private var m_eventSprite:Sprite = null;
      
      private const m_bitmap:Bitmap;
      
      private var m_currDirtyRect:Rectangle;
      
      private var m_Loaded:Boolean;
      
      private var m_paintTimer:Timer;
      
      private var m_LocationChangeTimer:Timer;
      
      private var m_htmlBoundsChangeTimer:Timer;
      
      private var m_completeTimer:Timer;
      
      private var m_PDFErrorTimer:Timer;
      
      private var m_PDFErrorNum:int;
      
      private var m_canLoad:Boolean;
      
      private var m_currentRepeatKeyboardEvent:KeyboardEvent;
      
      private var m_htmlHost:HTMLHost = null;
      
      private var m_rootPackage:Package;
      
      private var m_wkMethods:Object;
      
      private var m_activePopupWindow:HTMLPopupWindow;
      
      private var m_activePopupWindowDismissTimer:Timer;
      
      private var m_contextMenu:NativeMenu;
      
      private var m_invertBitmap:Boolean;
      
      private var m_shouldNavigateInSystemBrowser:Boolean;
      
      private var m_language:String;
      
      private var m_clipboard:JSClipboard;
      
      public function HTMLLoader()
      {
         this.m_bitmap = new Bitmap();
         this.m_language = Capabilities.language;
         super();
         if(this.m_isStub)
         {
            return;
         }
         this.m_BitmapData = null;
         this.m_invertBitmap = false;
         this.m_eventSprite = new Sprite();
         super.addChild(this.m_eventSprite);
         this.m_eventSprite.addChild(this.m_bitmap);
         if(this.m_isStageWebView)
         {
            this.m_eventSprite.tabEnabled = true;
            this.m_eventSprite = this.m_stageWebViewParent;
            if(HTMLLoader.isSupported == false)
            {
               this.userAgent = "Mozilla/5.0 (Linux; U; Android 2.2; en-us) AppleWebKit/533.19.4 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.19.4 AdobeAIR/" + NativeApplication.nativeApplication.runtimeVersion.substr(0,3);
            }
         }
         this.m_currDirtyRect = new Rectangle();
         this.m_rootPackage = null;
         this.initHTMLEngine(this.m_eventSprite);
         this.m_Width = 0;
         this.m_Height = 0;
         this.pageGroupName = "pg" + ++pageGroupSeq;
         this.m_eventSprite.doubleClickEnabled = true;
         this.m_eventSprite.addEventListener(MouseEvent.MOUSE_DOWN,this.onLeftMouseDown);
         this.m_eventSprite.addEventListener(MouseEvent.MOUSE_UP,this.onLeftMouseUp);
         this.m_eventSprite.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN,this.onMiddleMouseDown);
         this.m_eventSprite.addEventListener(MouseEvent.MIDDLE_MOUSE_UP,this.onMiddleMouseUp);
         this.m_eventSprite.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,this.onRightMouseDown);
         this.m_eventSprite.addEventListener(MouseEvent.RIGHT_MOUSE_UP,this.onRightMouseUp);
         this.m_eventSprite.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         this.m_eventSprite.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         this.m_eventSprite.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         this.m_eventSprite.addEventListener(MouseEvent.CONTEXT_MENU,this.onContextMenu);
         this.m_eventSprite.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         this.m_eventSprite.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         if(!this.m_isStageWebView)
         {
            this.m_eventSprite.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.onKeyFocusChange);
            this.m_eventSprite.addEventListener(FocusEvent.FOCUS_IN,this.onFocusIn);
            this.m_eventSprite.addEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
         }
         this.m_eventSprite.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,this.onNativeDragEnter);
         this.m_eventSprite.addEventListener(NativeDragEvent.NATIVE_DRAG_OVER,this.onNativeDragOver);
         this.m_eventSprite.addEventListener(NativeDragEvent.NATIVE_DRAG_EXIT,this.onNativeDragExit);
         this.m_eventSprite.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,this.onNativeDragDrop);
         this.m_eventSprite.addEventListener(NativeDragEvent.NATIVE_DRAG_START,this.onNativeDragStart);
         this.m_eventSprite.addEventListener(NativeDragEvent.NATIVE_DRAG_UPDATE,this.onNativeDragUpdate);
         this.m_eventSprite.addEventListener(NativeDragEvent.NATIVE_DRAG_COMPLETE,this.onNativeDragComplete);
         this.m_eventSprite.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.m_eventSprite.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this.m_eventSprite.addEventListener(Event.COPY,this.onCopy);
         this.m_eventSprite.addEventListener(Event.CUT,this.onCut);
         this.m_eventSprite.addEventListener(Event.PASTE,this.onPaste);
         this.m_eventSprite.addEventListener(Event.SELECT_ALL,this.onSelectAll);
         addEventListener(Event.COPY,this.onCopy);
         addEventListener(Event.CUT,this.onCut);
         addEventListener(Event.PASTE,this.onPaste);
         addEventListener(Event.SELECT_ALL,this.onSelectAll);
         this.m_eventSprite.addEventListener(TextEvent.TEXT_INPUT,this.onTextInput);
         addEventListener(TextEvent.TEXT_INPUT,this.onTextInput);
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         if(!this.m_isStageWebView)
         {
            addEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.onKeyFocusChange);
            addEventListener(FocusEvent.FOCUS_IN,this.onFocusIn);
            addEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
         }
         this.m_eventSprite.focusRect = focusRect = new Rectangle();
         tabEnabled = true;
         this.paintsDefaultBackground = true;
         this.m_Loaded = false;
         this.m_paintTimer = new Timer(1,0);
         this.m_paintTimer.addEventListener(TimerEvent.TIMER,this.onPaintTimer);
         this.m_LocationChangeTimer = new Timer(1,0);
         this.m_LocationChangeTimer.addEventListener(TimerEvent.TIMER,this.onLocationChangeTimer);
         this.m_PDFErrorNum = 0;
         this.m_PDFErrorTimer = new Timer(1,0);
         this.m_PDFErrorTimer.addEventListener(TimerEvent.TIMER,this.onPDFErrorTimer);
         this.m_htmlBoundsChangeTimer = new Timer(1,0);
         this.m_htmlBoundsChangeTimer.addEventListener(TimerEvent.TIMER,this.onHTMLBoundsChangeTimer);
         this.m_completeTimer = new Timer(1,0);
         this.m_completeTimer.addEventListener(TimerEvent.TIMER,this.onCompleteTimer);
         this.m_canLoad = true;
         this.m_currentRepeatKeyboardEvent = null;
         this.m_activePopupWindow = null;
         if(parent != null && parent == stage)
         {
            this.initBareHTMLWindow(true);
            this.onAddedToStage(null);
         }
         this.m_wkMethods = new Object();
         this.m_wkMethods["doDrag"] = function(clipboard:JSClipboard, dragImage:BitmapData, xOffset:Number, yOffset:Number):void
         {
            doDrag(clipboard,dragImage,xOffset,yOffset);
         };
         this.m_wkMethods["dragImageForLink"] = function(url:String, title:String):BitmapData
         {
            return dragImageForLink(url,title);
         };
         this.m_wkMethods["createClipboard"] = function(writable:Boolean, forDragging:Boolean, clipboard:Clipboard = null):JSClipboard
         {
            return createClipboard(writable,forDragging,clipboard,null);
         };
         this.m_contextMenu = new NativeMenu();
         this.m_eventSprite.contextMenu = this.m_contextMenu;
         this.m_shouldNavigateInSystemBrowser = false;
      }
      
      public static function createRootWindow(visible:Boolean = true, windowInitOptions:NativeWindowInitOptions = null, scrollBarsVisible:Boolean = true, bounds:Rectangle = null) : HTMLLoader
      {
         var windowBounds:Rectangle = null;
         if(!windowInitOptions)
         {
            windowInitOptions = new NativeWindowInitOptions();
         }
         var nativeWindow:NativeWindow = new NativeWindow(windowInitOptions);
         var htmlLoader:HTMLLoader = new HTMLLoader();
         nativeWindow.stage.addChild(htmlLoader);
         if(Boolean(bounds))
         {
            windowBounds = nativeWindow.bounds;
            if(!isNaN(bounds.x))
            {
               windowBounds.x = bounds.x;
            }
            if(!isNaN(bounds.y))
            {
               windowBounds.y = bounds.y;
            }
            if(!isNaN(bounds.width))
            {
               windowBounds.width = bounds.width;
            }
            if(!isNaN(bounds.height))
            {
               windowBounds.height = bounds.height;
            }
            nativeWindow.bounds = windowBounds;
         }
         htmlLoader.initBareHTMLWindow(scrollBarsVisible);
         if(visible)
         {
            nativeWindow.activate();
         }
         return htmlLoader;
      }
      
      private static function transformRect(theRect:Rectangle, theMatrix:Matrix) : Rectangle
      {
         var topLeft:Point = null;
         var bottomRight:Point = null;
         var transformedRectLeft:Number = NaN;
         var transformedRectWidth:Number = NaN;
         var transformedRectTop:Number = NaN;
         var transformedRectHeight:Number = NaN;
         topLeft = theRect.topLeft;
         var transformedTopLeft:Point = theMatrix.transformPoint(topLeft);
         bottomRight = theRect.bottomRight;
         var transformedBottomRight:Point = theMatrix.transformPoint(bottomRight);
         if(transformedTopLeft.x < transformedBottomRight.x)
         {
            transformedRectLeft = transformedTopLeft.x;
            transformedRectWidth = transformedBottomRight.x - transformedTopLeft.x;
         }
         else
         {
            transformedRectLeft = transformedBottomRight.x;
            transformedRectWidth = transformedTopLeft.x - transformedBottomRight.x;
         }
         if(transformedTopLeft.y < transformedBottomRight.y)
         {
            transformedRectTop = transformedTopLeft.y;
            transformedRectHeight = transformedBottomRight.y - transformedTopLeft.y;
         }
         else
         {
            transformedRectTop = transformedBottomRight.y;
            transformedRectHeight = transformedTopLeft.y - transformedBottomRight.y;
         }
         return new Rectangle(transformedRectLeft,transformedRectTop,transformedRectWidth,transformedRectHeight);
      }
      
      public static native function get pdfCapability() : int;
      
      [Version("air2.0")]
      public static function get swfCapability() : int
      {
         return HTMLSWFCapability.STATUS_OK;
      }
      
      [Version("air2.0")]
      public static native function get isSupported() : Boolean;
      
      private static function dragImageForLink(url:String, title:String) : BitmapData
      {
         var isWindows:Boolean = false;
         isWindows = Capabilities.os.substr(0,7) == "Windows";
         var BACKGROUND_COLOR:uint = isWindows ? 9211020 : 11776947;
         var ROUND_RECT_RADIUS:Number = 5;
         var BORDER_X:Number = 4;
         var BORDER_Y:Number = 2;
         var TEXT_FIELD_MARGIN:Number = 2;
         var MAX_WIDTH:Number = isWindows ? 192 : 320;
         var LABEL_FONT_SIZE:int = 11;
         var URL_FONT_SIZE:int = 10;
         var sprite:Sprite = new Sprite();
         var tf:TextField = new TextField();
         sprite.addChild(tf);
         tf.x = BORDER_X;
         tf.y = BORDER_Y;
         tf.defaultTextFormat = new TextFormat("_sans",LABEL_FONT_SIZE,null,true);
         tf.backgroundColor = BACKGROUND_COLOR;
         tf.appendText(title + "\n");
         tf.defaultTextFormat = new TextFormat("_sans",URL_FONT_SIZE,null,false);
         tf.appendText(url);
         tf.width = Math.min(MAX_WIDTH - 2 * TEXT_FIELD_MARGIN - 2 * BORDER_X,tf.textWidth) + 2 * TEXT_FIELD_MARGIN;
         tf.height = tf.textHeight + 2 * TEXT_FIELD_MARGIN;
         sprite.width = tf.width + 2 * BORDER_X;
         sprite.height = tf.height + 2 * BORDER_Y;
         sprite.graphics.beginFill(BACKGROUND_COLOR);
         sprite.graphics.drawRoundRect(0,0,sprite.width,sprite.height,2 * ROUND_RECT_RADIUS,2 * ROUND_RECT_RADIUS);
         var dragImage:BitmapData = new BitmapData(sprite.width,sprite.height,true,0);
         dragImage.draw(sprite);
         return dragImage;
      }
      
      private static native function createClipboard(param1:Boolean, param2:Boolean, param3:Clipboard, param4:NativeDragOptions) : JSClipboard;
      
      private function menuItemSelectHandler(event:Event) : void
      {
         var item:NativeMenuItem = event.currentTarget as NativeMenuItem;
         var itemData:* = item.data;
         this.nativeOnContextMenuItemSelect(itemData.action,itemData.title);
      }
      
      private function addSubMenuItems(contextMenu:NativeMenu, contextMenuItems:*) : void
      {
         var subMenu:NativeMenu = null;
         var item:NativeMenuItem = null;
         var nextIsSep:Boolean = false;
         for(var i:* = 0; i < contextMenuItems.length; i++)
         {
            if(Boolean(contextMenuItems[i].subMenu))
            {
               subMenu = new NativeMenu();
               this.addSubMenuItems(subMenu,contextMenuItems[i].subMenu);
               contextMenu.addSubmenu(subMenu,contextMenuItems[i].title);
            }
            else
            {
               item = new NativeMenuItem(contextMenuItems[i].title,contextMenuItems[i].separator);
               item.enabled = contextMenuItems[i].enabled;
               item.data = contextMenuItems[i];
               item.addEventListener(Event.SELECT,this.menuItemSelectHandler);
               contextMenu.addItem(item);
            }
         }
      }
      
      private function onContextMenu(event:MouseEvent) : void
      {
         var stagePoint:Point = null;
         var screenPoint:Point = null;
         var localX:int = int(Math.round(event.localX));
         var localY:int = int(Math.round(event.localY));
         stagePoint = new Point(event.stageX,event.stageY);
         screenPoint = this.nativeWindowGlobalToScreen(stagePoint);
         var screenX:int = int(Math.round(screenPoint.x));
         var screenY:int = int(Math.round(screenPoint.y));
         while(Boolean(this.m_contextMenu.numItems))
         {
            this.m_contextMenu.removeItemAt(0);
         }
         var handled:Boolean = Boolean(this.nativeOnContextMenu(localX,localY,screenX,screenY,0,0,0,0));
         if(!this.m_htmlContextMenuItems.length)
         {
            event.stopImmediatePropagation();
            return;
         }
         this.addSubMenuItems(this.m_contextMenu,this.m_htmlContextMenuItems);
      }
      
      private function canShowPlugins() : Boolean
      {
         var showPlugins:Boolean = this.stage != null && this.m_BitmapData != null && this.m_Width != 0 && this.m_Height != 0 && (this.stage.fullScreenSourceRect == null || this.stage.displayState == StageDisplayState.NORMAL) && Boolean(this._isSimpleMatrix());
         var currObj:DisplayObject = this;
         while(currObj != null && showPlugins)
         {
            showPlugins = currObj.visible && (currObj.filters == null || currObj.filters.length == 0) && currObj.alpha >= 1;
            currObj = currObj.parent;
         }
         return showPlugins;
      }
      
      private function _isSimpleMatrix() : Boolean
      {
         var values:Vector.<Number> = null;
         if(this.m_isStageWebView)
         {
            return true;
         }
         var matrix:Matrix = this.transform.concatenatedMatrix;
         if(Boolean(matrix))
         {
            return matrix.a == 1 && matrix.b == 0 && matrix.c == 0 && matrix.d == 1;
         }
         if(this.transform.hasOwnProperty("matrix3D"))
         {
            values = this.transform["matrix3D"].rawData;
            return values[0] == 1 && values[1] == 0 && values[2] == 0 && values[3] == 0 && values[4] == 0 && values[5] == 1 && values[6] == 0 && values[7] == 0 && values[8] == 0 && values[9] == 0 && values[10] == 1 && values[11] == 0 && values[14] == 0 && values[15] == 1;
         }
         return false;
      }
      
      private function createNewWindow(windowCreateOptions:HTMLWindowCreateOptions) : HTMLLoader
      {
         var htmlLoader:HTMLLoader = null;
         if(this.m_shouldNavigateInSystemBrowser)
         {
            htmlLoader = new HTMLLoader();
            htmlLoader.navigateInSystemBrowser = true;
            return htmlLoader;
         }
         if(Boolean(this.m_htmlHost))
         {
            return this.m_htmlHost.createWindow(windowCreateOptions);
         }
         return null;
      }
      
      private function initBareHTMLWindow(useScrollbars:Boolean) : void
      {
         if(useScrollbars)
         {
            this.nativeSetIsRootContentHtml(true);
            this.getFocusIfNeeded();
         }
         this.paintsDefaultBackground = !this.m_nativeWindow.transparent;
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
         stage.addEventListener(Event.RESIZE,this.onResizeRootContent);
         this.m_nativeWindow.addEventListener(Event.ACTIVATE,function(event:Event):void
         {
            getFocusIfNeeded();
         });
         this.htmlHost = new HTMLHost();
         this.onResizeRootContent(null);
      }
      
      private native function set pageGroupName(param1:String) : void;
      
      private native function get pageGroupName() : String;
      
      public function loadString(htmlContent:String) : void
      {
         if(this.m_isStub)
         {
            return;
         }
         if(this.m_canLoad)
         {
            this.m_canLoad = false;
            try
            {
               this.m_Loaded = false;
               if(htmlContent == null)
               {
                  Error.throwError(ArgumentError,kNullPointerError,"htmlContent");
               }
               this.loadHTMLString_impl(htmlContent);
            }
            finally
            {
               this.m_canLoad = true;
            }
         }
         else
         {
            this.throwIllegalLoad();
         }
      }
      
      public function load(urlRequestToLoad:URLRequest) : void
      {
         if(this.m_isStub)
         {
            return;
         }
         if(this.m_canLoad)
         {
            this.m_canLoad = false;
            try
            {
               this.m_Loaded = false;
               this.nativeLoadHTMLFromURLRequest(urlRequestToLoad);
            }
            finally
            {
               this.m_canLoad = true;
            }
         }
         else
         {
            this.throwIllegalLoad();
         }
      }
      
      public function get loaded() : Boolean
      {
         if(this.m_isStub)
         {
            return false;
         }
         return this.m_Loaded;
      }
      
      public native function reload() : void;
      
      public native function cancelLoad() : void;
      
      public native function get location() : String;
      
      public function get contentWidth() : Number
      {
         if(this.m_isStub)
         {
            return 0;
         }
         return this.m_contentWidth;
      }
      
      public function get contentHeight() : Number
      {
         if(this.m_isStub)
         {
            return 0;
         }
         return this.m_contentHeight;
      }
      
      override public function get width() : Number
      {
         if(this.m_isStub)
         {
            return 0;
         }
         return this.m_Width;
      }
      
      override public function set width(widthInPixels:Number) : void
      {
         var currContentWidth:uint = 0;
         var currScrollX:int = 0;
         var overScroll:int = 0;
         if(this.m_isStub)
         {
            return;
         }
         var widthAsUInt:uint = widthInPixels < 0 ? 0 : uint(widthInPixels);
         this.validateNewDimensions(widthAsUInt,this.m_Height);
         if(this.m_Width != widthAsUInt)
         {
            this.m_Width = widthAsUInt;
            currContentWidth = uint(this.m_contentWidth);
            currScrollX = int(this.m_scrollX);
            overScroll = currScrollX + widthInPixels - currContentWidth;
            if(overScroll > 0)
            {
               this.m_scrollX = currScrollX - overScroll;
            }
            this.invalidate();
         }
      }
      
      override public function get height() : Number
      {
         if(this.m_isStub)
         {
            return 0;
         }
         return this.m_Height;
      }
      
      override public function set height(heightInPixels:Number) : void
      {
         var currContentHeight:uint = 0;
         var currScrollY:int = 0;
         var overScroll:int = 0;
         if(this.m_isStub)
         {
            return;
         }
         var heightAsUInt:uint = heightInPixels < 0 ? 0 : uint(heightInPixels);
         this.validateNewDimensions(this.m_Width,heightAsUInt);
         if(this.m_Height != heightAsUInt)
         {
            this.m_Height = heightAsUInt;
            currContentHeight = uint(this.m_contentHeight);
            currScrollY = int(this.m_scrollY);
            overScroll = currScrollY + heightInPixels - currContentHeight;
            if(overScroll > 0)
            {
               this.m_scrollY = currScrollY - overScroll;
            }
            this.invalidate();
         }
      }
      
      public function get scrollH() : Number
      {
         if(this.m_isStub)
         {
            return 0;
         }
         return this.m_scrollX;
      }
      
      public function set scrollH(newScrollH:Number) : void
      {
         if(this.m_isStub)
         {
            return;
         }
         var newScrollHInt:int = int(this.covertNumberArgumentToInt(newScrollH,"scrollH"));
         if(newScrollHInt != this.m_scrollX)
         {
            this.closePopupWindowIfNeeded();
            this.m_scrollX = newScrollHInt;
            this.invalidate();
         }
      }
      
      public function get scrollV() : Number
      {
         if(this.m_isStub)
         {
            return 0;
         }
         return this.m_scrollY;
      }
      
      public function set scrollV(newScrollV:Number) : void
      {
         if(this.m_isStub)
         {
            return;
         }
         var newScrollVInt:int = int(this.covertNumberArgumentToInt(newScrollV,"scrollV"));
         if(newScrollVInt != this.m_scrollY)
         {
            this.closePopupWindowIfNeeded();
            this.m_scrollY = newScrollVInt;
            this.invalidate();
         }
      }
      
      public function get window() : Object
      {
         if(this.m_isStub)
         {
            return null;
         }
         return this.m_jsGlobalObj;
      }
      
      public native function get runtimeApplicationDomain() : ApplicationDomain;
      
      public native function set runtimeApplicationDomain(param1:ApplicationDomain) : void;
      
      public native function get userAgent() : String;
      
      public native function set userAgent(param1:String) : void;
      
      private native function get language() : String;
      
      private native function set language(param1:String) : void;
      
      public native function get manageCookies() : Boolean;
      
      public native function set manageCookies(param1:Boolean) : void;
      
      public native function get useCache() : Boolean;
      
      public native function set useCache(param1:Boolean) : void;
      
      public native function get cacheResponse() : Boolean;
      
      public native function set cacheResponse(param1:Boolean) : void;
      
      private native function _SetIdleTimeout(param1:Number) : void;
      
      [Version("air2.0")]
      public native function get idleTimeout() : Number;
      
      [Version("air2.0")]
      public function set idleTimeout(value:Number) : void
      {
         if(value < 0)
         {
            Error.throwError(RangeError,2006);
         }
         this._SetIdleTimeout(value);
      }
      
      public native function get authenticate() : Boolean;
      
      public native function set authenticate(param1:Boolean) : void;
      
      [API("663")]
      public native function get placeLoadStringContentInApplicationSandbox() : Boolean;
      
      [API("663")]
      public native function set placeLoadStringContentInApplicationSandbox(param1:Boolean) : void;
      
      public native function get paintsDefaultBackground() : Boolean;
      
      public native function set paintsDefaultBackground(param1:Boolean) : void;
      
      public native function get textEncodingOverride() : String;
      
      public native function set textEncodingOverride(param1:String) : void;
      
      public native function get textEncodingFallback() : String;
      
      public native function set textEncodingFallback(param1:String) : void;
      
      private native function get m_contentWidth() : uint;
      
      private native function get m_contentHeight() : uint;
      
      private function covertNumberArgumentToInt(numberArg:Number, argumentName:String) : int
      {
         try
         {
            return int(numberArg);
         }
         catch(exceptionValue:*)
         {
            throw new ArgumentError("The value of " + numberArg.toString() + " for " + argumentName + " could not be converted to an integer.");
         }
      }
      
      private function validateNewDimensions(width:uint, height:uint) : void
      {
         if(!this.validateDimensions(width,height))
         {
            throw new ArgumentError("Invalid HTMLLoader dimensions. width = " + width + ", height = " + height);
         }
      }
      
      private function ensureBitmap() : void
      {
         var vMirrorMatrix:Matrix = null;
         if(Boolean(this.m_BitmapData) && (this.m_Width != this.m_BitmapData.width || this.m_Height != this.m_BitmapData.height))
         {
            this.m_BitmapData = null;
         }
         if(this.m_BitmapData == null)
         {
            if(this.m_Width > 0 && this.m_Height > 0)
            {
               this.m_BitmapData = new BitmapData(this.m_Width,this.m_Height,true,0);
               this.m_bitmap.bitmapData = this.m_BitmapData;
               if(this.m_invertBitmap)
               {
                  vMirrorMatrix = new Matrix(1,0,0,-1,0,this.m_Height);
                  this.m_bitmap.transform.matrix = vMirrorMatrix;
               }
               this.m_currDirtyRect = new Rectangle(0,0,this.m_Width,this.m_Height);
               if(!this.m_paintTimer.running)
               {
                  this.m_paintTimer.start();
               }
            }
            else
            {
               this.m_currDirtyRect = new Rectangle(0,0,0,0);
            }
         }
      }
      
      private function onResizeRootContent(event:Event) : void
      {
         this.width = Math.max(stage.stageWidth,1);
         this.height = Math.max(stage.stageHeight,1);
      }
      
      private function windowOnClose(ev:Event) : void
      {
         this.pageGroupName = null;
         this.closePopupWindowIfNeeded();
         this.cancelLoad();
         this.close();
      }
      
      private native function loadHTMLString_impl(param1:String) : void;
      
      private native function nativeLoadHTMLFromURLRequest(param1:URLRequest) : void;
      
      private native function set m_Width(param1:uint) : void;
      
      private native function get m_Width() : uint;
      
      private native function set m_Height(param1:uint) : void;
      
      private native function get m_Height() : uint;
      
      private native function validateDimensions(param1:uint, param2:uint) : Boolean;
      
      private native function initHTMLEngine(param1:Sprite) : void;
      
      private native function nativeLayout() : void;
      
      private native function nativePaint(param1:Rectangle, param2:Rectangle) : void;
      
      private native function set m_BitmapData(param1:BitmapData) : *;
      
      private native function get m_BitmapData() : BitmapData;
      
      private function invalidate() : void
      {
         var dirtyRect:Rectangle = new Rectangle(0,0,this.m_Width,this.m_Height);
         this.m_currDirtyRect = new Rectangle();
         this.invalidateRect(dirtyRect);
      }
      
      private function invalidateRect(dirtyRect:Rectangle) : void
      {
         var newFrameDelay:Number = NaN;
         this.m_currDirtyRect = this.m_currDirtyRect.union(dirtyRect);
         if(!this.m_paintTimer.running)
         {
            newFrameDelay = 1;
            if(Boolean(stage) && stage.frameRate != 0)
            {
               newFrameDelay = 1000 / (3 * stage.frameRate);
               if(newFrameDelay < 1)
               {
                  newFrameDelay = 1;
               }
            }
            this.m_paintTimer.delay = newFrameDelay;
            this.m_paintTimer.start();
         }
      }
      
      private function paint(dirtyRect:Rectangle) : void
      {
         var bitmapDirtyRect:Rectangle = null;
         if(this.m_Width > 0 && this.m_Height > 0)
         {
            bitmapDirtyRect = transformRect(dirtyRect,this.m_bitmap.transform.matrix);
            this.nativePaint(dirtyRect,bitmapDirtyRect);
         }
         else
         {
            this.m_BitmapData = null;
            this.m_bitmap.bitmapData = null;
         }
      }
      
      private function onPaintTimer(ev:TimerEvent) : void
      {
         var htmlRenderEvent:Event = null;
         this.nativeLayout();
         this.ensureBitmap();
         this.m_paintTimer.stop();
         var dirtyRectToPaint:Rectangle = this.m_currDirtyRect;
         this.m_currDirtyRect = new Rectangle();
         this.paint(dirtyRectToPaint);
         if(this.m_currDirtyRect.isEmpty())
         {
            htmlRenderEvent = new Event(Event.HTML_RENDER);
            dispatchEvent(htmlRenderEvent);
         }
      }
      
      private function onHTMLBoundsChangeTimer(ev:TimerEvent) : void
      {
         this.m_htmlBoundsChangeTimer.stop();
         var contentBoundsChangedEvent:Event = new Event(Event.HTML_BOUNDS_CHANGE);
         dispatchEvent(contentBoundsChangedEvent);
      }
      
      private function closePopupWindowIfNeeded() : void
      {
         var window:NativeWindow = null;
         if(Boolean(stage) && Boolean(this.m_nativeWindow))
         {
            window = this.m_nativeWindow;
            window.removeEventListener(Event.DEACTIVATE,this.onDeactivate);
            window.removeEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING,this.onDeactivate);
            window.removeEventListener(NativeWindowBoundsEvent.RESIZING,this.onDeactivate);
            window.removeEventListener(NativeWindowBoundsEvent.MOVING,this.onDeactivate);
         }
         if(Boolean(stage))
         {
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.stageMouseDown);
         }
         if(Boolean(this.m_activePopupWindow))
         {
            this.m_activePopupWindow.close();
            this.m_activePopupWindow = null;
         }
      }
      
      private native function nativeOnMouseDown(param1:int, param2:int, param3:int, param4:int, param5:uint, param6:uint, param7:Boolean, param8:Boolean, param9:Boolean, param10:Boolean) : Boolean;
      
      private native function nativeOnMouseUp(param1:int, param2:int, param3:int, param4:int, param5:uint, param6:uint, param7:Boolean, param8:Boolean, param9:Boolean, param10:Boolean) : Boolean;
      
      private native function nativeOnMouseMove(param1:int, param2:int, param3:int, param4:int, param5:Boolean, param6:Boolean, param7:Boolean, param8:Boolean, param9:Boolean) : Boolean;
      
      private native function nativeOnMouseWheel(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:Boolean, param8:Boolean, param9:Boolean, param10:Boolean) : Boolean;
      
      private native function nativeOnContextMenuItemSelect(param1:int, param2:String) : void;
      
      private native function nativeOnContextMenu(param1:int, param2:int, param3:int, param4:int, param5:Boolean, param6:Boolean, param7:Boolean, param8:Boolean) : Boolean;
      
      private function onLeftMouseDown(evt:MouseEvent) : void
      {
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onLeftMouseUp);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         var handled:Boolean = Boolean(this.invokeMouseDownImpl(evt,LeftButton,evt.clickCount));
         if(handled)
         {
            evt.stopImmediatePropagation();
         }
      }
      
      private function onLeftMouseUp(evt:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onLeftMouseUp);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         var handled:Boolean = Boolean(this.invokeMouseUpImpl(evt,LeftButton));
         if(handled)
         {
            evt.stopImmediatePropagation();
         }
      }
      
      private function onMiddleMouseDown(evt:MouseEvent) : void
      {
         var handled:Boolean = Boolean(this.invokeMouseDownImpl(evt,MiddleButton,evt.clickCount));
         if(handled)
         {
            evt.stopImmediatePropagation();
         }
      }
      
      private function onMiddleMouseUp(evt:MouseEvent) : void
      {
         var handled:Boolean = Boolean(this.invokeMouseUpImpl(evt,MiddleButton));
         if(handled)
         {
            evt.stopImmediatePropagation();
         }
      }
      
      private function onRightMouseDown(evt:MouseEvent) : void
      {
         var handled:Boolean = Boolean(this.invokeMouseDownImpl(evt,RightButton,evt.clickCount));
         if(handled)
         {
            evt.stopImmediatePropagation();
         }
      }
      
      private function onRightMouseUp(evt:MouseEvent) : void
      {
         var handled:Boolean = Boolean(this.invokeMouseUpImpl(evt,RightButton));
         if(handled)
         {
            evt.stopImmediatePropagation();
         }
      }
      
      private function onMouseOut(evt:MouseEvent) : void
      {
         if(this.m_cursorSaved)
         {
            Mouse.cursor = this.m_savedMouseCursor;
            this.m_cursorSaved = false;
         }
      }
      
      private function onMouseMove(evt:MouseEvent) : void
      {
         var stagePoint:Point = null;
         var screenPoint:Point = null;
         var localX:int = int(Math.round(evt.localX));
         var localY:int = int(Math.round(evt.localY));
         stagePoint = new Point(evt.stageX,evt.stageY);
         screenPoint = this.nativeWindowGlobalToScreen(stagePoint);
         var screenX:int = int(Math.round(screenPoint.x));
         var screenY:int = int(Math.round(screenPoint.y));
         var shiftKey:Boolean = evt.shiftKey;
         var ctrlKey:Boolean = evt.controlKey;
         var altKey:Boolean = evt.altKey;
         var metaKey:Boolean = evt.commandKey;
         var buttonDown:Boolean = evt.buttonDown;
         if(!this.m_cursorSaved)
         {
            this.m_savedMouseCursor = Mouse.cursor;
            this.m_cursorSaved = true;
            Mouse.cursor = MouseCursor.AUTO;
         }
         var handled:Boolean = Boolean(this.nativeOnMouseMove(localX,localY,screenX,screenY,shiftKey,ctrlKey,altKey,metaKey,buttonDown));
         if(handled)
         {
            evt.stopImmediatePropagation();
         }
      }
      
      private function onMouseWheel(evt:MouseEvent) : void
      {
         var localX:int = 0;
         var localY:int = 0;
         var stagePoint:Point = null;
         var screenPoint:Point = null;
         var screenX:int = 0;
         var screenY:int = 0;
         var shiftKey:Boolean = false;
         var ctrlKey:Boolean = false;
         var altKey:Boolean = false;
         var metaKey:Boolean = false;
         var deltaX:int = 0;
         var deltaY:int = 0;
         localX = int(Math.round(evt.localX));
         localY = int(Math.round(evt.localY));
         stagePoint = new Point(evt.stageX,evt.stageY);
         screenPoint = this.nativeWindowGlobalToScreen(stagePoint);
         screenX = int(Math.round(screenPoint.x));
         screenY = int(Math.round(screenPoint.y));
         shiftKey = evt.shiftKey;
         ctrlKey = evt.controlKey;
         altKey = evt.altKey;
         metaKey = evt.commandKey;
         deltaX = 0;
         deltaY = evt.delta;
         this.closePopupWindowIfNeeded();
         var handled:Boolean = Boolean(this.nativeOnMouseWheel(localX,localY,screenX,screenY,deltaX,deltaY,shiftKey,ctrlKey,altKey,metaKey));
         if(handled)
         {
            evt.stopImmediatePropagation();
         }
      }
      
      private function invokeMouseDownImpl(evt:MouseEvent, mouseButton:uint, clickCount:uint) : Boolean
      {
         var stagePoint:Point = null;
         var screenPoint:Point = null;
         var localX:int = int(Math.round(evt.localX));
         var localY:int = int(Math.round(evt.localY));
         stagePoint = new Point(evt.stageX,evt.stageY);
         screenPoint = this.nativeWindowGlobalToScreen(stagePoint);
         var screenX:int = int(Math.round(screenPoint.x));
         var screenY:int = int(Math.round(screenPoint.y));
         var shiftKey:Boolean = evt.shiftKey;
         var ctrlKey:Boolean = evt.controlKey;
         var altKey:Boolean = evt.altKey;
         var metaKey:Boolean = evt.commandKey;
         if(mouseButton == LeftButton)
         {
            this.closePopupWindowIfNeeded();
         }
         var handled:Boolean = Boolean(this.nativeOnMouseDown(localX,localY,screenX,screenY,mouseButton,clickCount,shiftKey,ctrlKey,altKey,metaKey));
         this.getFocusIfNeeded();
         return handled;
      }
      
      private function invokeMouseUpImpl(evt:MouseEvent, mouseButton:uint) : Boolean
      {
         var stagePoint:Point = null;
         var screenPoint:Point = null;
         var localX:int = int(Math.round(evt.localX));
         var localY:int = int(Math.round(evt.localY));
         stagePoint = new Point(evt.stageX,evt.stageY);
         screenPoint = this.nativeWindowGlobalToScreen(stagePoint);
         var screenX:int = int(Math.round(screenPoint.x));
         var screenY:int = int(Math.round(screenPoint.y));
         var clickCount:uint = 0;
         var shiftKey:Boolean = evt.shiftKey;
         var ctrlKey:Boolean = evt.controlKey;
         var altKey:Boolean = evt.altKey;
         var metaKey:Boolean = evt.commandKey;
         return this.nativeOnMouseUp(localX,localY,screenX,screenY,mouseButton,clickCount,shiftKey,ctrlKey,altKey,metaKey);
      }
      
      private function onKeyDown(evt:KeyboardEvent) : void
      {
         if(evt.target != evt.currentTarget)
         {
            return;
         }
         var isAutoRepeat:Boolean = false;
         if(this.m_currentRepeatKeyboardEvent != null && this.m_currentRepeatKeyboardEvent.keyCode == evt.keyCode && this.m_currentRepeatKeyboardEvent.keyLocation == evt.keyLocation)
         {
            isAutoRepeat = true;
         }
         else
         {
            this.m_currentRepeatKeyboardEvent = evt;
            isAutoRepeat = false;
         }
         if(Boolean(this.m_activePopupWindow))
         {
            if(evt.charCode == Keyboard.ESCAPE || evt.charCode == Keyboard.ENTER)
            {
               this.closePopupWindowIfNeeded();
            }
         }
         var handled:Boolean = Boolean(this.nativeOnKeyDown(evt.charCode,evt.keyCode,evt.shiftKey,evt.controlKey,evt.altKey,evt.commandKey,isAutoRepeat));
         if(handled)
         {
            evt.stopImmediatePropagation();
            evt.preventDefault();
         }
      }
      
      private function onKeyUp(evt:KeyboardEvent) : *
      {
         if(evt.target != evt.currentTarget)
         {
            return;
         }
         if(this.m_currentRepeatKeyboardEvent != null && this.m_currentRepeatKeyboardEvent.keyCode == evt.keyCode && this.m_currentRepeatKeyboardEvent.keyLocation == evt.keyLocation)
         {
            this.m_currentRepeatKeyboardEvent = null;
         }
         var handled:Boolean = Boolean(this.nativeOnKeyUp(evt.charCode,evt.keyCode,evt.shiftKey,evt.controlKey,evt.altKey,evt.commandKey));
         if(handled)
         {
            evt.stopImmediatePropagation();
         }
      }
      
      private function onKeyFocusChange(evt:FocusEvent) : *
      {
         if(evt.target != evt.currentTarget)
         {
            return;
         }
         this.nativeOnKeyFocusChange(evt);
      }
      
      private native function nativeOnKeyFocusChange(param1:Event) : void;
      
      private native function nativeOnCopy() : Boolean;
      
      private native function nativeOnCut() : Boolean;
      
      private native function nativeOnPaste() : Boolean;
      
      private native function nativeOnSelectAll() : Boolean;
      
      private function onCopy(e:Event) : void
      {
         if(this.nativeOnCopy())
         {
            e.preventDefault();
            e.stopImmediatePropagation();
         }
      }
      
      private function onCut(e:Event) : void
      {
         if(this.nativeOnCut())
         {
            e.preventDefault();
            e.stopImmediatePropagation();
         }
      }
      
      private function onPaste(e:Event) : void
      {
         if(this.nativeOnPaste())
         {
            e.preventDefault();
            e.stopImmediatePropagation();
         }
      }
      
      private function onSelectAll(e:Event) : void
      {
         if(this.nativeOnSelectAll())
         {
            e.preventDefault();
            e.stopImmediatePropagation();
         }
      }
      
      private function onFocusIn(evt:FocusEvent) : void
      {
         if(evt.target != evt.currentTarget)
         {
            return;
         }
         this.m_nativeWindow.addEventListener(Event.ACTIVATE,this.onWindowActivateOrDeactivate);
         this.m_nativeWindow.addEventListener(Event.DEACTIVATE,this.onWindowActivateOrDeactivate);
         var relatedObject:InteractiveObject = evt.relatedObject;
         if(relatedObject != this && relatedObject != this.m_eventSprite)
         {
            this.nativeFocusIn(evt.direction);
         }
      }
      
      private native function nativeFocusIn(param1:String) : void;
      
      private function onFocusOut(evt:FocusEvent) : void
      {
         if(evt.target != evt.currentTarget)
         {
            return;
         }
         if(Boolean(stage))
         {
            this.m_nativeWindow.removeEventListener(Event.ACTIVATE,this.onWindowActivateOrDeactivate);
            this.m_nativeWindow.removeEventListener(Event.DEACTIVATE,this.onWindowActivateOrDeactivate);
         }
         var relatedObject:InteractiveObject = evt.relatedObject;
         if(relatedObject != this && relatedObject != this.m_eventSprite)
         {
            this.setUpActivePopupWindowDismissTimer();
            this.nativeFocusOut();
         }
      }
      
      private native function nativeFocusOut() : void;
      
      private function onWindowActivateOrDeactivate(e:Event) : void
      {
         if(e.type == Event.ACTIVATE)
         {
            this.onWindowActivate();
         }
         else if(e.type == Event.DEACTIVATE)
         {
            this.onWindowDeactivate();
         }
      }
      
      private native function onWindowActivate() : void;
      
      private native function onWindowDeactivate() : void;
      
      private native function onTextInput(param1:TextEvent) : void;
      
      private function onAddedToStage(e:Event) : void
      {
         if(Boolean(stage) && Boolean(this.m_nativeWindow))
         {
            this.m_nativeWindow.addEventListener(Event.CLOSE,this.windowOnClose);
            if(this.m_isStageWebView)
            {
               this.m_nativeWindow.addEventListener(Event.ACTIVATE,this.onWindowActivateOrDeactivate);
               this.m_nativeWindow.addEventListener(Event.DEACTIVATE,this.onWindowActivateOrDeactivate);
            }
         }
      }
      
      private function onRemovedFromStage(e:Event) : void
      {
         if(Boolean(stage))
         {
            this.m_nativeWindow.removeEventListener(Event.ACTIVATE,this.onWindowActivateOrDeactivate);
            this.m_nativeWindow.removeEventListener(Event.DEACTIVATE,this.onWindowActivateOrDeactivate);
            this.m_nativeWindow.removeEventListener(Event.CLOSE,this.windowOnClose);
         }
      }
      
      public native function get hasFocusableContent() : Boolean;
      
      private native function nativeOnKeyDown(param1:uint, param2:uint, param3:Boolean, param4:Boolean, param5:Boolean, param6:Boolean, param7:Boolean) : Boolean;
      
      private native function nativeOnKeyUp(param1:uint, param2:uint, param3:Boolean, param4:Boolean, param5:Boolean, param6:Boolean) : Boolean;
      
      private native function nativeSetIsRootContentHtml(param1:Boolean) : void;
      
      private native function get m_scrollX() : int;
      
      private native function set m_scrollX(param1:int) : void;
      
      private native function get m_scrollY() : int;
      
      private native function set m_scrollY(param1:int) : void;
      
      private function dispatchContentBoundsChangedEvent() : *
      {
         if(!this.m_htmlBoundsChangeTimer.running)
         {
            this.m_htmlBoundsChangeTimer.start();
         }
      }
      
      private function dispatchContentScrolledEvent() : *
      {
         var contentScrolledEvent:Event = null;
         this.m_canLoad = false;
         this.closePopupWindowIfNeeded();
         try
         {
            contentScrolledEvent = new Event(Event.SCROLL);
            dispatchEvent(contentScrolledEvent);
         }
         catch(error:*)
         {
         }
         finally
         {
            this.m_canLoad = true;
         }
      }
      
      public function get htmlHost() : HTMLHost
      {
         if(this.m_isStub)
         {
            return null;
         }
         return this.m_htmlHost;
      }
      
      public function set htmlHost(value:HTMLHost) : void
      {
         if(this.m_isStub)
         {
            return;
         }
         if(Boolean(this.m_htmlHost))
         {
            this.m_htmlHost.setHTMLControl(null);
         }
         this.m_htmlHost = value;
         if(Boolean(this.m_htmlHost))
         {
            this.m_htmlHost.setHTMLControl(this);
         }
      }
      
      public function get navigateInSystemBrowser() : Boolean
      {
         if(this.m_isStub)
         {
            return false;
         }
         return this.m_shouldNavigateInSystemBrowser;
      }
      
      public function set navigateInSystemBrowser(value:Boolean) : void
      {
         if(this.m_isStub)
         {
            return;
         }
         this.m_shouldNavigateInSystemBrowser = value;
      }
      
      private function navigateToStringURL(url:String) : void
      {
         var urlReq:URLRequest = new URLRequest(url);
         navigateToURL(urlReq);
      }
      
      private function onGetWindowRect(rect:Rectangle) : void
      {
         var windowRect:Rectangle = null;
         if(Boolean(this.m_htmlHost))
         {
            windowRect = this.m_htmlHost.windowRect;
            if(Boolean(windowRect))
            {
               rect.x = windowRect.x;
               rect.y = windowRect.y;
               rect.width = windowRect.width;
               rect.height = windowRect.height;
            }
         }
      }
      
      private function onSetWindowRect(rect:Rectangle) : void
      {
         if(Boolean(this.m_htmlHost))
         {
            this.m_htmlHost.windowRect = rect;
         }
      }
      
      private function onSetTitle(title:String) : void
      {
         if(Boolean(this.m_htmlHost))
         {
            this.m_htmlHost.updateTitle(title);
         }
      }
      
      private function onCloseWindow() : void
      {
         if(Boolean(this.m_htmlHost))
         {
            this.m_htmlHost.windowClose();
         }
      }
      
      private function onSetStatus(status:String) : void
      {
         if(Boolean(this.m_htmlHost))
         {
            this.m_htmlHost.updateStatus(status);
         }
      }
      
      private function onFocus() : void
      {
         if(Boolean(this.m_htmlHost))
         {
            this.m_htmlHost.windowFocus();
         }
      }
      
      private function onUnfocus() : void
      {
         if(Boolean(this.m_htmlHost))
         {
            this.m_htmlHost.windowBlur();
         }
      }
      
      private function createURLRequest(targetURL:String, method:String, userAgent:String) : URLRequest
      {
         var urlToDownload:String = null;
         var urlRequest:URLRequest = null;
         try
         {
            urlToDownload = targetURL;
            urlRequest = new URLRequest(urlToDownload);
            urlRequest.method = method;
            if(userAgent != null)
            {
               urlRequest.userAgent = userAgent;
            }
            return urlRequest;
         }
         catch(err:*)
         {
         }
         return null;
      }
      
      private function addHeaderToURLRequest(urlRequest:URLRequest, headerName:String, headerValue:String) : void
      {
         if(urlRequest.requestHeaders == null)
         {
            urlRequest.requestHeaders = new Array();
         }
         var header:URLRequestHeader = new URLRequestHeader(headerName,headerValue);
         urlRequest.requestHeaders.push(header);
      }
      
      private function handleOnLoadEvents() : void
      {
         this.m_Loaded = true;
         if(!this.m_completeTimer.running)
         {
            this.m_completeTimer.start();
         }
      }
      
      private function handleOnDocumentCreated() : void
      {
         var docCreatedEvent:Event = null;
         if(this.m_closing)
         {
            return;
         }
         this.m_canLoad = false;
         try
         {
            docCreatedEvent = new Event(Event.HTML_DOM_INITIALIZE);
            dispatchEvent(docCreatedEvent);
            if(Boolean(this.location) && this.location.toLowerCase().indexOf(this.adobeAppProtocolPrefix) == 0)
            {
               this.window.runtime = this.m_rootPackage;
            }
         }
         finally
         {
            this.m_canLoad = true;
         }
      }
      
      private function close() : void
      {
         if(this.m_isStageWebView)
         {
            return;
         }
         this.m_closing = true;
         try
         {
            this.loadString("");
         }
         catch(e:Error)
         {
         }
      }
      
      internal native function get pageApplicationDomain() : ApplicationDomain;
      
      private native function showExceptionDialog(param1:String) : void;
      
      private function uncaughtJSException(exceptionValue:*) : void
      {
         var eventToDispatch:HTMLUncaughtScriptExceptionEvent = null;
         var stackFrameStrings:Array = null;
         var stringForStackTrace:String = null;
         var stackFrame:* = undefined;
         var stackFrameString:String = null;
         var frameString:String = null;
         eventToDispatch = new HTMLUncaughtScriptExceptionEvent(exceptionValue);
         var doDefaultAction:Boolean = dispatchEvent(eventToDispatch);
         if(doDefaultAction)
         {
            stackFrameStrings = new Array();
            if("stackTrace" in exceptionValue)
            {
               for each(stackFrame in exceptionValue.stackTrace)
               {
                  stackFrameString = stackFrame["functionName"] + " at " + stackFrame.sourceURL + " : " + stackFrame.line;
                  stackFrameStrings.push(stackFrameString);
               }
            }
            else if("sourceURL" in exceptionValue && "line" in exceptionValue)
            {
               frameString = exceptionValue.sourceURL + " : " + exceptionValue.line;
               stackFrameStrings.push(frameString);
            }
            stringForStackTrace = exceptionValue.toString() + "\n" + stackFrameStrings.join("\n");
            trace(stringForStackTrace);
         }
      }
      
      private function onLocationChange() : void
      {
         try
         {
            if(!this.m_LocationChangeTimer.running)
            {
               this.m_LocationChangeTimer.start();
            }
         }
         catch(exceptionValue:*)
         {
         }
      }
      
      private function onLocationChangeTimer(ev:TimerEvent) : void
      {
         var locationChangeEvent:Event = null;
         this.m_LocationChangeTimer.stop();
         if(this.isAIR27orGreater)
         {
            locationChangeEvent = new LocationChangeEvent(LocationChangeEvent.LOCATION_CHANGE,false,false,this.location);
         }
         else
         {
            locationChangeEvent = new Event(Event.LOCATION_CHANGE);
         }
         dispatchEvent(locationChangeEvent);
         if(Boolean(this.m_htmlHost))
         {
            this.m_htmlHost.updateLocation(this.location);
         }
      }
      
      private native function get isAIR27orGreater() : Boolean;
      
      private function onPDFError(pdfErrorNum:int) : void
      {
         try
         {
            if(!this.m_PDFErrorTimer.running)
            {
               this.m_PDFErrorNum = pdfErrorNum;
               this.m_PDFErrorTimer.start();
            }
         }
         catch(exceptionValue:*)
         {
         }
      }
      
      private native function constructPopupWindow(param1:Function, param2:Function, param3:Number) : HTMLPopupWindow;
      
      private function onCreatePopupWindow(computedFontSize:Number) : HTMLPopupWindow
      {
         this.closePopupWindowIfNeeded();
         this.m_activePopupWindow = this.constructPopupWindow(this.closePopupWindowIfNeeded,this.setDeactivate,computedFontSize);
         if(Boolean(stage))
         {
            stage.addEventListener(MouseEvent.MOUSE_DOWN,this.stageMouseDown);
         }
         return this.m_activePopupWindow;
      }
      
      private function stageMouseDown(event:MouseEvent) : void
      {
         this.closePopupWindowIfNeeded();
      }
      
      private function setDeactivate() : void
      {
         var window:NativeWindow = null;
         if(Boolean(stage) && Boolean(this.m_nativeWindow))
         {
            window = this.m_nativeWindow;
            window.addEventListener(Event.DEACTIVATE,this.onDeactivate);
            window.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING,this.onDeactivate);
            window.addEventListener(NativeWindowBoundsEvent.RESIZING,this.onDeactivate);
            window.addEventListener(NativeWindowBoundsEvent.MOVING,this.onDeactivate);
         }
      }
      
      private function setUpActivePopupWindowDismissTimer() : *
      {
         if(Boolean(this.m_activePopupWindow))
         {
            if(!this.m_activePopupWindowDismissTimer || Boolean(this.m_activePopupWindowDismissTimer) && Boolean(!this.m_activePopupWindowDismissTimer.running))
            {
               this.m_activePopupWindowDismissTimer = new Timer(1,0);
               this.m_activePopupWindowDismissTimer.addEventListener(TimerEvent.TIMER,this.onActivePopupWindowDismissTimer);
               this.m_activePopupWindowDismissTimer.start();
            }
         }
      }
      
      private function onDeactivate(evt:Event) : void
      {
         var window:NativeWindow = null;
         if(Boolean(stage) && Boolean(this.m_nativeWindow))
         {
            window = this.m_nativeWindow;
            window.removeEventListener(evt.type,this.onDeactivate);
         }
         if(Boolean(this.m_activePopupWindow))
         {
            if(evt.type == Event.DEACTIVATE)
            {
               this.setUpActivePopupWindowDismissTimer();
            }
            else
            {
               this.closePopupWindowIfNeeded();
            }
         }
      }
      
      private function onActivePopupWindowDismissTimer(ev:TimerEvent) : *
      {
         this.m_activePopupWindowDismissTimer.stop();
         if(Boolean(this.m_activePopupWindow) && !this.m_activePopupWindow.isActive())
         {
            this.closePopupWindowIfNeeded();
         }
      }
      
      private function onPDFErrorTimer(ev:TimerEvent) : void
      {
         this.m_PDFErrorTimer.stop();
         var pdfErrorEvent:ErrorEvent = new ErrorEvent("error",false,false,"PDFError",this.m_PDFErrorNum);
         dispatchEvent(pdfErrorEvent);
      }
      
      private function onCompleteTimer(ev:TimerEvent) : void
      {
         this.m_completeTimer.stop();
         var completeEvent:Event = new Event(Event.COMPLETE);
         dispatchEvent(completeEvent);
      }
      
      private function throwIllegalLoad() : void
      {
         throw new Error("Illegal load operation");
      }
      
      private function throwIllegalMethod() : void
      {
         Error.throwError(IllegalOperationError,2037);
      }
      
      public function historyBack() : void
      {
         if(this.m_isStub)
         {
            return;
         }
         this.historyGo(-1);
      }
      
      public function historyForward() : void
      {
         if(this.m_isStub)
         {
            return;
         }
         this.historyGo(1);
      }
      
      public native function historyGo(param1:int) : void;
      
      public native function get historyLength() : uint;
      
      public native function get historyPosition() : uint;
      
      public native function set historyPosition(param1:uint) : void;
      
      public native function getHistoryAt(param1:uint) : HTMLHistoryItem;
      
      override public function get numChildren() : int
      {
         return 0;
      }
      
      override public function addChild(child:DisplayObject) : DisplayObject
      {
         this.throwIllegalMethod();
         return null;
      }
      
      override public function addChildAt(child:DisplayObject, index:int) : DisplayObject
      {
         this.throwIllegalMethod();
         return null;
      }
      
      override public function areInaccessibleObjectsUnderPoint(point:Point) : Boolean
      {
         this.throwIllegalMethod();
         return null;
      }
      
      override public function contains(child:DisplayObject) : Boolean
      {
         return false;
      }
      
      override public function getChildAt(index:int) : DisplayObject
      {
         this.throwIllegalMethod();
         return null;
      }
      
      override public function getChildByName(name:String) : DisplayObject
      {
         this.throwIllegalMethod();
         return null;
      }
      
      override public function getChildIndex(child:DisplayObject) : int
      {
         this.throwIllegalMethod();
         return -1;
      }
      
      override public function getObjectsUnderPoint(point:Point) : Array
      {
         this.throwIllegalMethod();
         return null;
      }
      
      override public function removeChild(child:DisplayObject) : DisplayObject
      {
         this.throwIllegalMethod();
         return null;
      }
      
      override public function removeChildAt(index:int) : DisplayObject
      {
         this.throwIllegalMethod();
         return null;
      }
      
      override public function setChildIndex(child:DisplayObject, index:int) : void
      {
         this.throwIllegalMethod();
      }
      
      override public function swapChildren(child1:DisplayObject, child2:DisplayObject) : void
      {
         this.throwIllegalMethod();
      }
      
      override public function swapChildrenAt(index1:int, index2:int) : void
      {
         this.throwIllegalMethod();
      }
      
      private function getFocusIfNeeded() : void
      {
         var existingFocus:InteractiveObject = null;
         if(Boolean(stage))
         {
            if(this.m_isStageWebView)
            {
               if(!this.m_isStageWebViewFocused)
               {
                  if(Boolean(parent) && Boolean(stage))
                  {
                     stage.focus = parent;
                     this.nativeFocusIn(FocusDirection.NONE);
                  }
               }
            }
            else
            {
               existingFocus = stage.focus;
               if(existingFocus != this && existingFocus != this.m_eventSprite)
               {
                  stage.focus = this.m_eventSprite;
               }
            }
         }
      }
      
      private native function get m_jsGlobalObj() : __HTMLScriptObject;
      
      private native function get m_htmlContextMenuItems() : Array;
      
      private native function nativeWindowGlobalToScreen(param1:Point) : Point;
      
      private native function get m_nativeWindow() : NativeWindow;
      
      private native function nativeOnNativeDragEnter(param1:int, param2:int, param3:int, param4:int, param5:Boolean, param6:Boolean, param7:Boolean, param8:Boolean, param9:JSClipboard) : void;
      
      private native function nativeOnNativeDragOver(param1:int, param2:int, param3:int, param4:int, param5:Boolean, param6:Boolean, param7:Boolean, param8:Boolean, param9:JSClipboard) : void;
      
      private native function nativeOnNativeDragDrop(param1:int, param2:int, param3:int, param4:int, param5:Boolean, param6:Boolean, param7:Boolean, param8:Boolean, param9:JSClipboard) : void;
      
      private native function nativeOnNativeDragExit(param1:int, param2:int, param3:int, param4:int, param5:Boolean, param6:Boolean, param7:Boolean, param8:Boolean, param9:JSClipboard) : void;
      
      private native function nativeOnNativeDragStart(param1:int, param2:int, param3:int, param4:int, param5:Boolean, param6:Boolean, param7:Boolean, param8:Boolean) : void;
      
      private native function nativeOnNativeDragUpdate(param1:int, param2:int, param3:int, param4:int, param5:Boolean, param6:Boolean, param7:Boolean, param8:Boolean) : void;
      
      private native function nativeOnNativeDragComplete(param1:int, param2:int, param3:int, param4:int, param5:Boolean, param6:Boolean, param7:Boolean, param8:Boolean, param9:String) : void;
      
      private function onNativeDragEnter(event:NativeDragEvent) : void
      {
         var stagePoint:Point = null;
         var screenPoint:Point = null;
         if(event.eventPhase != EventPhase.AT_TARGET)
         {
            return;
         }
         var localX:int = int(Math.round(event.localX));
         var localY:int = int(Math.round(event.localY));
         stagePoint = new Point(event.stageX,event.stageY);
         screenPoint = this.nativeWindowGlobalToScreen(stagePoint);
         var screenX:int = int(Math.round(screenPoint.x));
         var screenY:int = int(Math.round(screenPoint.y));
         this.m_clipboard = createClipboard(false,true,event.clipboard,event.allowedActions);
         this.m_clipboard.propagationStopped = false;
         this.nativeOnNativeDragEnter(localX,localY,screenX,screenY,event.shiftKey,event.controlKey,event.altKey,event.commandKey,this.m_clipboard);
         event.dropAction = this.m_clipboard.dropEffect;
         event.preventDefault();
         if(this.m_clipboard.propagationStopped)
         {
            event.stopPropagation();
         }
      }
      
      private function onNativeDragOver(event:NativeDragEvent) : void
      {
         var stagePoint:Point = null;
         var screenPoint:Point = null;
         if(event.eventPhase != EventPhase.AT_TARGET)
         {
            return;
         }
         var localX:int = int(Math.round(event.localX));
         var localY:int = int(Math.round(event.localY));
         stagePoint = new Point(event.stageX,event.stageY);
         screenPoint = this.nativeWindowGlobalToScreen(stagePoint);
         var screenX:int = int(Math.round(screenPoint.x));
         var screenY:int = int(Math.round(screenPoint.y));
         this.m_clipboard.dragOptions = event.allowedActions;
         this.m_clipboard.propagationStopped = false;
         this.nativeOnNativeDragOver(localX,localY,screenX,screenY,event.shiftKey,event.controlKey,event.altKey,event.commandKey,this.m_clipboard);
         event.dropAction = this.m_clipboard.dropEffect;
         event.preventDefault();
         if(this.m_clipboard.propagationStopped)
         {
            event.stopPropagation();
         }
      }
      
      private function onNativeDragDrop(event:NativeDragEvent) : void
      {
         var stagePoint:Point = null;
         var screenPoint:Point = null;
         if(event.eventPhase != EventPhase.AT_TARGET)
         {
            return;
         }
         var localX:int = int(Math.round(event.localX));
         var localY:int = int(Math.round(event.localY));
         stagePoint = new Point(event.stageX,event.stageY);
         screenPoint = this.nativeWindowGlobalToScreen(stagePoint);
         var screenX:int = int(Math.round(screenPoint.x));
         var screenY:int = int(Math.round(screenPoint.y));
         this.m_clipboard.propagationStopped = false;
         this.nativeOnNativeDragDrop(localX,localY,screenX,screenY,event.shiftKey,event.controlKey,event.altKey,event.commandKey,this.m_clipboard);
         if(this.m_clipboard.propagationStopped)
         {
            event.stopPropagation();
         }
         this.m_clipboard = null;
      }
      
      private function onNativeDragExit(event:NativeDragEvent) : void
      {
         var stagePoint:Point = null;
         var screenPoint:Point = null;
         if(event.eventPhase != EventPhase.AT_TARGET)
         {
            return;
         }
         var localX:int = int(Math.round(event.localX));
         var localY:int = int(Math.round(event.localY));
         stagePoint = new Point(event.stageX,event.stageY);
         screenPoint = this.nativeWindowGlobalToScreen(stagePoint);
         var screenX:int = int(Math.round(screenPoint.x));
         var screenY:int = int(Math.round(screenPoint.y));
         this.m_clipboard.propagationStopped = false;
         this.nativeOnNativeDragExit(localX,localY,screenX,screenY,event.shiftKey,event.controlKey,event.altKey,event.commandKey,this.m_clipboard);
         if(this.m_clipboard.propagationStopped)
         {
            event.stopPropagation();
         }
         this.m_clipboard = null;
      }
      
      private function onNativeDragStart(event:NativeDragEvent) : void
      {
         var stagePoint:Point = null;
         var screenPoint:Point = null;
         if(event.eventPhase != EventPhase.AT_TARGET)
         {
            return;
         }
         var localX:int = int(Math.round(event.localX));
         var localY:int = int(Math.round(event.localY));
         stagePoint = new Point(event.stageX,event.stageY);
         screenPoint = this.nativeWindowGlobalToScreen(stagePoint);
         var screenX:int = int(Math.round(screenPoint.x));
         var screenY:int = int(Math.round(screenPoint.y));
         this.nativeOnNativeDragStart(localX,localY,screenX,screenY,event.shiftKey,event.controlKey,event.altKey,event.commandKey);
      }
      
      private function onNativeDragUpdate(event:NativeDragEvent) : void
      {
         var stagePoint:Point = null;
         var screenPoint:Point = null;
         if(event.eventPhase != EventPhase.AT_TARGET)
         {
            return;
         }
         var localX:int = int(Math.round(event.localX));
         var localY:int = int(Math.round(event.localY));
         stagePoint = new Point(event.stageX,event.stageY);
         screenPoint = this.nativeWindowGlobalToScreen(stagePoint);
         var screenX:int = int(Math.round(screenPoint.x));
         var screenY:int = int(Math.round(screenPoint.y));
         this.nativeOnNativeDragUpdate(localX,localY,screenX,screenY,event.shiftKey,event.controlKey,event.altKey,event.commandKey);
      }
      
      private function onNativeDragComplete(event:NativeDragEvent) : void
      {
         var stagePoint:Point = null;
         var screenPoint:Point = null;
         if(event.eventPhase != EventPhase.AT_TARGET)
         {
            return;
         }
         var localX:int = int(Math.round(event.localX));
         var localY:int = int(Math.round(event.localY));
         stagePoint = new Point(event.stageX,event.stageY);
         screenPoint = this.nativeWindowGlobalToScreen(stagePoint);
         var screenX:int = int(Math.round(screenPoint.x));
         var screenY:int = int(Math.round(screenPoint.y));
         this.nativeOnNativeDragComplete(localX,localY,screenX,screenY,event.shiftKey,event.controlKey,event.altKey,event.commandKey,event.dropAction);
      }
      
      private function doDrag(clipboard:JSClipboard, dragImage:BitmapData, xOffset:Number, yOffset:Number) : void
      {
         NativeDragManager.doDrag(this.m_eventSprite,clipboard.clipboard,dragImage,new Point(xOffset,yOffset),clipboard.dragOptions);
      }
   }
}

