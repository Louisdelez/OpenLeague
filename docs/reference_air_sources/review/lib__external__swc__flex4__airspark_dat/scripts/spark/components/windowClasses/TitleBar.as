package spark.components.windowClasses
{
   import flash.display.DisplayObject;
   import flash.display.NativeWindowDisplayState;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.NativeWindowDisplayStateEvent;
   import flash.system.Capabilities;
   import mx.core.IWindow;
   import spark.components.Button;
   import spark.components.supportClasses.SkinnableComponent;
   import spark.components.supportClasses.TextBase;
   import spark.events.SkinPartEvent;
   import spark.primitives.BitmapImage;
   import spark.skins.spark.windowChrome.MacTitleBarSkin;
   import spark.skins.spark.windowChrome.TitleBarSkin;
   
   [Exclude(name="focusThickness",kind="style")]
   [Exclude(name="focusBlendMode",kind="style")]
   [SkinState("disabledAndMaximized")]
   [SkinState("normalAndMaximized")]
   public class TitleBar extends SkinnableComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var _skinParts:Object = {
         "titleIconImage":false,
         "minimizeButton":false,
         "closeButton":true,
         "titleText":false,
         "maximizeButton":false
      };
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var titleIconObject:Object;
      
      [SkinPart(required="true")]
      public var closeButton:Button;
      
      [SkinPart(required="false")]
      public var maximizeButton:Button;
      
      [SkinPart(required="false")]
      public var minimizeButton:Button;
      
      [SkinPart(required="false")]
      public var titleIconImage:BitmapImage;
      
      [SkinPart(required="false")]
      public var titleText:TextBase;
      
      private var _title:String = "";
      
      private var titleChanged:Boolean = false;
      
      private var _titleIcon:Class;
      
      private var titleIconChanged:Boolean = false;
      
      public function TitleBar()
      {
         super();
         doubleClickEnabled = true;
         addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         addEventListener(MouseEvent.DOUBLE_CLICK,this.doubleClickHandler);
      }
      
      private static function isMac() : Boolean
      {
         return Capabilities.os.substring(0,3) == "Mac";
      }
      
      public function get title() : String
      {
         return this._title;
      }
      
      public function set title(value:String) : void
      {
         this._title = value;
         this.titleChanged = true;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get titleIcon() : Class
      {
         return this._titleIcon;
      }
      
      public function set titleIcon(value:Class) : void
      {
         this._titleIcon = value;
         this.titleIconChanged = true;
         invalidateProperties();
         invalidateSize();
      }
      
      private function get window() : IWindow
      {
         var p:DisplayObject = parent;
         while(Boolean(p) && !(p is IWindow))
         {
            p = p.parent;
         }
         return IWindow(p);
      }
      
      override protected function attachSkin() : void
      {
         if(isMac() && getStyle("skinClass") == TitleBarSkin)
         {
            setStyle("skinClass",MacTitleBarSkin);
         }
         super.attachSkin();
      }
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         var targetWindow:DisplayObject = null;
         super.partAdded(partName,instance);
         if(instance == this.titleText)
         {
            this.titleText.text = this.title;
         }
         else if(instance == this.closeButton)
         {
            this.closeButton.focusEnabled = false;
            this.closeButton.addEventListener(MouseEvent.MOUSE_DOWN,this.button_mouseDownHandler);
            this.closeButton.addEventListener(MouseEvent.CLICK,this.closeButton_clickHandler);
         }
         else if(instance == this.minimizeButton)
         {
            this.minimizeButton.focusEnabled = false;
            this.minimizeButton.enabled = this.window.minimizable;
            this.minimizeButton.addEventListener(MouseEvent.MOUSE_DOWN,this.button_mouseDownHandler);
            this.minimizeButton.addEventListener(MouseEvent.CLICK,this.minimizeButton_clickHandler);
         }
         else if(instance == this.maximizeButton)
         {
            this.maximizeButton.focusEnabled = false;
            this.maximizeButton.enabled = this.window.maximizable;
            this.maximizeButton.addEventListener(MouseEvent.MOUSE_DOWN,this.button_mouseDownHandler);
            this.maximizeButton.addEventListener(MouseEvent.CLICK,this.maximizeButton_clickHandler);
            targetWindow = DisplayObject(this.window);
            targetWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE,this.window_displayStateChangeHandler,false,0,true);
            targetWindow.addEventListener(SkinPartEvent.PART_REMOVED,this.partRemovedHandler,false,0,true);
         }
      }
      
      override protected function partRemoved(partName:String, instance:Object) : void
      {
         var targetWindow:DisplayObject = null;
         super.partRemoved(partName,instance);
         if(instance == this.closeButton)
         {
            this.closeButton.removeEventListener(MouseEvent.CLICK,this.closeButton_clickHandler);
         }
         else if(instance == this.minimizeButton)
         {
            this.minimizeButton.removeEventListener(MouseEvent.MOUSE_DOWN,this.button_mouseDownHandler);
            this.minimizeButton.removeEventListener(MouseEvent.CLICK,this.minimizeButton_clickHandler);
         }
         else if(instance == this.maximizeButton)
         {
            this.maximizeButton.removeEventListener(MouseEvent.MOUSE_DOWN,this.button_mouseDownHandler);
            this.maximizeButton.removeEventListener(MouseEvent.CLICK,this.maximizeButton_clickHandler);
            targetWindow = DisplayObject(this.window);
            targetWindow.removeEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE,this.window_displayStateChangeHandler);
            targetWindow.removeEventListener(SkinPartEvent.PART_REMOVED,this.partRemovedHandler);
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.titleChanged)
         {
            this.titleText.text = this._title;
            this.titleChanged = false;
         }
         if(this.titleIconChanged)
         {
            if(Boolean(this.titleIconObject))
            {
               this.titleIconImage.source = null;
               this.titleIconObject = null;
            }
            if(Boolean(this._titleIcon) && Boolean(this.titleIconImage))
            {
               this.titleIconObject = new this._titleIcon();
               this.titleIconImage.source = this.titleIconObject;
            }
            this.titleIconChanged = false;
         }
      }
      
      override protected function getCurrentSkinState() : String
      {
         if(!this.window.nativeWindow.closed && this.window.nativeWindow.displayState == NativeWindowDisplayState.MAXIMIZED)
         {
            return enabled ? "normalAndMaximized" : "disabledAndMaximized";
         }
         return enabled ? "normal" : "disabled";
      }
      
      private function mouseDownHandler(event:MouseEvent) : void
      {
         this.window.nativeWindow.startMove();
         event.stopPropagation();
      }
      
      protected function doubleClickHandler(event:MouseEvent) : void
      {
         if(isMac())
         {
            this.window.minimize();
         }
         else if(this.window.nativeWindow.displayState == NativeWindowDisplayState.MAXIMIZED)
         {
            this.window.restore();
         }
         else
         {
            this.window.maximize();
         }
      }
      
      private function button_mouseDownHandler(event:MouseEvent) : void
      {
         event.stopPropagation();
      }
      
      private function minimizeButton_clickHandler(event:Event) : void
      {
         this.window.minimize();
      }
      
      private function maximizeButton_clickHandler(event:Event) : void
      {
         if(this.window.nativeWindow.displayState == NativeWindowDisplayState.MAXIMIZED)
         {
            this.window.restore();
         }
         else
         {
            this.window.maximize();
         }
         this.maximizeButton.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
      }
      
      private function closeButton_clickHandler(event:Event) : void
      {
         this.window.close();
      }
      
      private function window_displayStateChangeHandler(event:NativeWindowDisplayStateEvent) : void
      {
         if(event.afterDisplayState == NativeWindowDisplayState.MAXIMIZED || event.afterDisplayState == NativeWindowDisplayState.NORMAL)
         {
            invalidateSkinState();
         }
      }
      
      private function partRemovedHandler(event:SkinPartEvent) : void
      {
         var targetWindow:DisplayObject = null;
         if(event.instance == this)
         {
            targetWindow = DisplayObject(this.window);
            targetWindow.removeEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE,this.window_displayStateChangeHandler);
            targetWindow.removeEventListener(SkinPartEvent.PART_REMOVED,this.partRemovedHandler);
         }
      }
   }
}

