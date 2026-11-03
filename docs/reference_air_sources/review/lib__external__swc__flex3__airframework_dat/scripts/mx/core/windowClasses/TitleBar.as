package mx.core.windowClasses
{
   import flash.display.DisplayObject;
   import flash.display.NativeWindowDisplayState;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.system.Capabilities;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import mx.controls.Button;
   import mx.core.IFlexDisplayObject;
   import mx.core.IUITextField;
   import mx.core.IWindow;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.styles.ISimpleStyleClient;
   import mx.styles.IStyleClient;
   
   public class TitleBar extends UIComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.6.0.12937";
      
      public var closeButton:Button;
      
      private var minimizeButtonSkin:Class;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var titleIconObject:Object;
      
      public var titleTextField:IUITextField;
      
      private var _title:String = "";
      
      private var titleIconChanged:Boolean = false;
      
      public var maximizeButton:Button;
      
      private var closeButtonSkin:Class;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var titleBarBackground:IFlexDisplayObject;
      
      public var minimizeButton:Button;
      
      private var _titleIcon:Class;
      
      private var maximizeButtonSkin:Class;
      
      private var titleChanged:Boolean = false;
      
      private var restoreButtonSkin:Class;
      
      public function TitleBar()
      {
         super();
         doubleClickEnabled = true;
         addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
         addEventListener(MouseEvent.DOUBLE_CLICK,doubleClickHandler);
      }
      
      private static function isMac() : Boolean
      {
         return Capabilities.os.substring(0,3) == "Mac";
      }
      
      protected function placeButtons(align:String, unscaledWidth:Number, unscaledHeight:Number, leftOffset:Number, rightOffset:Number, cornerOffset:Number) : void
      {
         var pad:Number = Number(getStyle("buttonPadding"));
         var edgePad:Number = Number(getStyle("titleBarButtonPadding"));
         minimizeButton.setActualSize(minimizeButton.measuredWidth,minimizeButton.measuredHeight);
         maximizeButton.setActualSize(maximizeButton.measuredWidth,maximizeButton.measuredHeight);
         closeButton.setActualSize(closeButton.measuredWidth,closeButton.measuredHeight);
         if(align == "right")
         {
            minimizeButton.move(unscaledWidth - (minimizeButton.measuredWidth + maximizeButton.measuredWidth + closeButton.measuredWidth + 2 * pad) - cornerOffset - edgePad,(unscaledHeight - minimizeButton.measuredHeight) / 2);
            maximizeButton.move(unscaledWidth - (maximizeButton.measuredWidth + closeButton.measuredWidth + pad) - cornerOffset - edgePad,(unscaledHeight - maximizeButton.measuredHeight) / 2);
            closeButton.move(unscaledWidth - closeButton.measuredWidth - cornerOffset - edgePad,(unscaledHeight - closeButton.measuredHeight) / 2);
         }
         else
         {
            edgePad = Math.max(edgePad,leftOffset);
            closeButton.move(edgePad,(unscaledHeight - closeButton.measuredHeight) / 2);
            minimizeButton.move(pad + edgePad + closeButton.measuredWidth,(unscaledHeight - minimizeButton.measuredHeight) / 2);
            maximizeButton.move(edgePad + pad * 2 + closeButton.measuredWidth + minimizeButton.measuredWidth,(unscaledHeight - maximizeButton.measuredHeight) / 2);
         }
      }
      
      private function minimizeButton_clickHandler(event:Event) : void
      {
         window.minimize();
      }
      
      private function measureChromeText(textField:IUITextField) : Rectangle
      {
         var textWidth:Number = 20;
         var textHeight:Number = 14;
         if(Boolean(textField) && Boolean(textField.text))
         {
            textField.validateNow();
            textWidth = Number(textField.textWidth);
            textHeight = Number(textField.textHeight);
         }
         return new Rectangle(0,0,textWidth,textHeight);
      }
      
      override protected function createChildren() : void
      {
         var titleBackgroundUIComponent:IStyleClient = null;
         var titleBackgroundStyleable:ISimpleStyleClient = null;
         super.createChildren();
         var titleBarBackgroundClass:Class = getStyle("titleBarBackgroundSkin");
         if(Boolean(titleBarBackgroundClass))
         {
            if(!titleBarBackground)
            {
               titleBarBackground = new titleBarBackgroundClass();
               titleBackgroundUIComponent = titleBarBackground as IStyleClient;
               if(Boolean(titleBackgroundUIComponent))
               {
                  titleBackgroundUIComponent.setStyle("backgroundImage",undefined);
               }
               titleBackgroundStyleable = titleBarBackground as ISimpleStyleClient;
               if(Boolean(titleBackgroundStyleable))
               {
                  titleBackgroundStyleable.styleName = this;
               }
               addChild(DisplayObject(titleBarBackground));
            }
         }
         if(!titleTextField)
         {
            titleTextField = IUITextField(createInFontContext(UITextField));
            titleTextField.text = _title;
            titleTextField.styleName = getStyle("titleTextStyleName");
            titleTextField.enabled = true;
            addChild(DisplayObject(titleTextField));
         }
         if(!titleIconObject && Boolean(_titleIcon))
         {
            titleIconObject = new _titleIcon();
            addChild(DisplayObject(titleIconObject));
         }
         if(!minimizeButton)
         {
            minimizeButton = new Button();
            minimizeButtonSkin = getStyle("minimizeButtonSkin");
            if(Boolean(minimizeButtonSkin))
            {
               minimizeButton.setStyle("skin",minimizeButtonSkin);
            }
            minimizeButton.focusEnabled = false;
            minimizeButton.enabled = window.minimizable;
            minimizeButton.addEventListener(MouseEvent.MOUSE_DOWN,button_mouseDownHandler);
            minimizeButton.addEventListener(MouseEvent.CLICK,minimizeButton_clickHandler);
            addChild(minimizeButton);
         }
         if(!maximizeButton)
         {
            maximizeButton = new Button();
            maximizeButtonSkin = getStyle("maximizeButtonSkin");
            if(Boolean(maximizeButtonSkin))
            {
               maximizeButton.setStyle("skin",maximizeButtonSkin);
            }
            maximizeButton.focusEnabled = false;
            maximizeButton.enabled = window.maximizable;
            maximizeButton.addEventListener(MouseEvent.MOUSE_DOWN,button_mouseDownHandler);
            maximizeButton.addEventListener(MouseEvent.CLICK,maximizeButton_clickHandler);
            addChild(maximizeButton);
            restoreButtonSkin = isMac() ? null : getStyle("restoreButtonSkin");
         }
         if(!closeButton)
         {
            closeButton = new Button();
            closeButtonSkin = getStyle("closeButtonSkin");
            if(Boolean(closeButtonSkin))
            {
               closeButton.setStyle("skin",closeButtonSkin);
            }
            closeButton.focusEnabled = false;
            closeButton.addEventListener(MouseEvent.MOUSE_DOWN,button_mouseDownHandler);
            closeButton.addEventListener(MouseEvent.CLICK,closeButton_clickHandler);
            addChild(closeButton);
         }
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var titleBarBackgroundClass:Class = null;
         var titleBackgroundUIComponent:IStyleClient = null;
         var titleBackgroundStyleable:ISimpleStyleClient = null;
         super.styleChanged(styleProp);
         invalidateDisplayList();
         var allStyles:Boolean = !styleProp || styleProp == "styleName";
         if(allStyles || styleProp == "titleBarBackgroundSkin")
         {
            titleBarBackgroundClass = getStyle("titleBarBackgroundSkin");
            if(Boolean(titleBarBackgroundClass))
            {
               if(Boolean(titleBarBackground))
               {
                  removeChild(DisplayObject(titleBarBackground));
                  titleBarBackground = null;
               }
               titleBarBackground = new titleBarBackgroundClass();
               titleBackgroundUIComponent = titleBarBackground as IStyleClient;
               if(Boolean(titleBackgroundUIComponent))
               {
                  titleBackgroundUIComponent.setStyle("backgroundImage",undefined);
               }
               titleBackgroundStyleable = titleBarBackground as ISimpleStyleClient;
               if(Boolean(titleBackgroundStyleable))
               {
                  titleBackgroundStyleable.styleName = this;
               }
               addChildAt(DisplayObject(titleBarBackground),0);
            }
         }
         if(allStyles || styleProp == "titleTextStyleName")
         {
            if(Boolean(titleTextField))
            {
               titleTextField.styleName = getStyle("titleTextStyleName");
            }
         }
         if(allStyles || styleProp == "closeButtonSkin")
         {
            closeButtonSkin = getStyle("closeButtonSkin");
            if(Boolean(closeButtonSkin) && Boolean(closeButton))
            {
               closeButton.setStyle("skin",closeButtonSkin);
            }
         }
         if(allStyles || styleProp == "maximizeButtonSkin")
         {
            maximizeButtonSkin = getStyle("maximizeButtonSkin");
            if(Boolean(maximizeButtonSkin) && Boolean(maximizeButton))
            {
               maximizeButton.setStyle("skin",maximizeButtonSkin);
            }
         }
         if(allStyles || styleProp == "minimizeButtonSkin")
         {
            minimizeButtonSkin = getStyle("minimizeButtonSkin");
            if(Boolean(minimizeButtonSkin) && Boolean(minimizeButton))
            {
               minimizeButton.setStyle("skin",minimizeButtonSkin);
            }
         }
         if(allStyles || styleProp == "restoreButtonSkin")
         {
            restoreButtonSkin = getStyle("restoreButtonSkin");
         }
      }
      
      private function closeButton_clickHandler(event:Event) : void
      {
         window.close();
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(titleChanged)
         {
            titleTextField.text = _title;
            titleChanged = false;
         }
         if(titleIconChanged)
         {
            if(Boolean(titleIconObject))
            {
               removeChild(DisplayObject(titleIconObject));
               titleIconObject = null;
            }
            if(Boolean(_titleIcon))
            {
               titleIconObject = new _titleIcon();
               addChild(DisplayObject(titleIconObject));
            }
            titleIconChanged = false;
         }
      }
      
      protected function doubleClickHandler(event:MouseEvent) : void
      {
         if(isMac())
         {
            window.minimize();
         }
         else if(window.nativeWindow.displayState == NativeWindowDisplayState.MAXIMIZED)
         {
            window.restore();
         }
         else
         {
            window.maximize();
         }
      }
      
      public function get title() : String
      {
         return _title;
      }
      
      private function maximizeButton_clickHandler(event:Event) : void
      {
         if(window.nativeWindow.displayState == NativeWindowDisplayState.MAXIMIZED)
         {
            window.restore();
         }
         else
         {
            window.maximize();
            maximizeButton.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
         }
      }
      
      private function button_mouseDownHandler(event:MouseEvent) : void
      {
         event.stopPropagation();
      }
      
      public function set titleIcon(value:Class) : void
      {
         _titleIcon = value;
         titleIconChanged = true;
         invalidateProperties();
         invalidateSize();
      }
      
      private function mouseDownHandler(event:MouseEvent) : void
      {
         window.nativeWindow.startMove();
         event.stopPropagation();
      }
      
      override protected function measure() : void
      {
         super.measure();
         titleTextField.validateNow();
         if(titleTextField.textHeight == 0)
         {
            titleTextField.text = " ";
            titleTextField.validateNow();
         }
         measuredHeight = Math.max(titleTextField.textHeight + UITextField.TEXT_HEIGHT_PADDING,Math.max(maximizeButton.measuredHeight,minimizeButton.measuredHeight,closeButton.measuredHeight) + 12);
         measuredWidth = titleTextField.width + maximizeButton.measuredWidth + minimizeButton.measuredWidth + closeButton.measuredWidth;
         if(Boolean(titleIconObject))
         {
            measuredHeight = Math.max(measuredHeight,titleIconObject.height + 1);
            measuredWidth += titleIconObject.width;
         }
      }
      
      public function set title(value:String) : void
      {
         _title = value;
         titleChanged = true;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get titleIcon() : Class
      {
         return _titleIcon;
      }
      
      protected function placeTitle(titleAlign:String, leftOffset:Number, rightOffset:Number, buttonAlign:String) : void
      {
         var buttonsX:Number = NaN;
         var tf:TextFormat = null;
         var titleX:Number = NaN;
         var textWidth:Number = NaN;
         titleTextField.text = _title;
         titleTextField.validateNow();
         if(buttonAlign == "left")
         {
            buttonsX = Math.max(closeButton.x + closeButton.measuredWidth,minimizeButton.x + minimizeButton.measuredWidth,maximizeButton.x + maximizeButton.measuredWidth);
         }
         else
         {
            buttonsX = Math.min(closeButton.x,minimizeButton.x,maximizeButton.x);
         }
         if(titleAlign == "left")
         {
            if(buttonAlign == "left")
            {
               titleTextField.setActualSize(width - rightOffset - 2 - buttonsX,measureChromeText(titleTextField).height + UITextField.TEXT_HEIGHT_PADDING);
               titleTextField.move(buttonsX,(height - (measureChromeText(titleTextField).height + UITextField.TEXT_HEIGHT_PADDING)) / 2);
               titleTextField.truncateToFit();
            }
            else
            {
               titleTextField.setActualSize(Math.max(0,buttonsX) - 2,measureChromeText(titleTextField).height + UITextField.TEXT_HEIGHT_PADDING);
               titleTextField.move(leftOffset,(height - (measureChromeText(titleTextField).height + UITextField.TEXT_HEIGHT_PADDING)) / 2);
               titleTextField.truncateToFit();
            }
         }
         else
         {
            tf = new TextFormat();
            tf.align = TextFormatAlign.LEFT;
            titleTextField.setTextFormat(tf);
            textWidth = Number(titleTextField.getLineMetrics(0).width);
            titleTextField.truncateToFit();
            if(buttonAlign == "left")
            {
               titleTextField.setActualSize(width - rightOffset - buttonsX - 2,measureChromeText(titleTextField).height + UITextField.TEXT_HEIGHT_PADDING);
               titleX = Math.max(buttonsX,(width - leftOffset - rightOffset - textWidth) / 2);
               titleTextField.move(titleX,(height - (measureChromeText(titleTextField).height + UITextField.TEXT_HEIGHT_PADDING)) / 2);
            }
            else
            {
               titleTextField.setActualSize(width - leftOffset - rightOffset - (width - buttonsX) - 2,measureChromeText(titleTextField).height + UITextField.TEXT_HEIGHT_PADDING);
               titleX = Math.max(0,Math.min(buttonsX - textWidth - 2,(width - leftOffset - rightOffset - textWidth) / 2));
               titleTextField.move(titleX,(height - (measureChromeText(titleTextField).height + UITextField.TEXT_HEIGHT_PADDING)) / 2);
            }
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var h:int = 0;
         var offset:int = 0;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(window.nativeWindow.closed)
         {
            return;
         }
         var leftOffset:Number = 0;
         var rightOffset:Number = 5;
         var cornerOffset:int = getStyle("cornerRadius") / 2;
         if(Boolean(titleBarBackground))
         {
            titleBarBackground.move(0,0);
            IFlexDisplayObject(titleBarBackground).setActualSize(unscaledWidth,unscaledHeight);
         }
         if(Boolean(titleIconObject))
         {
            h = int(titleIconObject.height);
            offset = (height - h) / 2;
            titleIconObject.move(cornerOffset,offset);
            leftOffset += cornerOffset + titleIconObject.width + getStyle("buttonPadding");
         }
         if(!isMac())
         {
            if(window.nativeWindow.displayState == NativeWindowDisplayState.MAXIMIZED)
            {
               if(Boolean(restoreButtonSkin))
               {
                  maximizeButton.setStyle("skin",restoreButtonSkin);
               }
            }
            else
            {
               maximizeButton.setStyle("skin",maximizeButtonSkin);
            }
         }
         var buttonAlign:String = getStyle("buttonAlignment");
         if(buttonAlign == "right")
         {
            placeButtons(buttonAlign,width,height,leftOffset,rightOffset,cornerOffset);
         }
         else if(buttonAlign == "left")
         {
            placeButtons(buttonAlign,width,height,leftOffset,rightOffset,cornerOffset);
         }
         else if(isMac())
         {
            buttonAlign = "left";
            placeButtons("left",width,height,leftOffset,rightOffset,cornerOffset);
         }
         else
         {
            placeButtons("right",width,height,leftOffset,rightOffset,cornerOffset);
         }
         var titleAlign:String = String(getStyle("titleAlignment"));
         if(titleAlign == "center" || titleAlign == "left")
         {
            placeTitle(titleAlign,leftOffset,rightOffset,buttonAlign);
         }
         else if(isMac())
         {
            placeTitle("center",leftOffset,rightOffset,buttonAlign);
         }
         else
         {
            placeTitle("left",leftOffset,rightOffset,buttonAlign);
         }
      }
      
      private function get window() : IWindow
      {
         return IWindow(parent);
      }
   }
}

