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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var titleBarBackground:IFlexDisplayObject;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var titleIconObject:Object;
      
      private var minimizeButtonSkin:Class;
      
      private var maximizeButtonSkin:Class;
      
      private var restoreButtonSkin:Class;
      
      private var closeButtonSkin:Class;
      
      public var closeButton:Button;
      
      public var maximizeButton:Button;
      
      public var minimizeButton:Button;
      
      private var _title:String = "";
      
      private var titleChanged:Boolean = false;
      
      private var _titleIcon:Class;
      
      private var titleIconChanged:Boolean = false;
      
      public var titleTextField:IUITextField;
      
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
         return IWindow(parent);
      }
      
      override protected function createChildren() : void
      {
         var titleBackgroundUIComponent:IStyleClient = null;
         var titleBackgroundStyleable:ISimpleStyleClient = null;
         super.createChildren();
         var titleBarBackgroundClass:Class = getStyle("titleBarBackgroundSkin");
         if(Boolean(titleBarBackgroundClass))
         {
            if(!this.titleBarBackground)
            {
               this.titleBarBackground = new titleBarBackgroundClass();
               titleBackgroundUIComponent = this.titleBarBackground as IStyleClient;
               if(Boolean(titleBackgroundUIComponent))
               {
                  titleBackgroundUIComponent.setStyle("backgroundImage",undefined);
               }
               titleBackgroundStyleable = this.titleBarBackground as ISimpleStyleClient;
               if(Boolean(titleBackgroundStyleable))
               {
                  titleBackgroundStyleable.styleName = this;
               }
               addChild(DisplayObject(this.titleBarBackground));
            }
         }
         if(!this.titleTextField)
         {
            this.titleTextField = IUITextField(createInFontContext(UITextField));
            this.titleTextField.text = this._title;
            this.titleTextField.styleName = getStyle("titleTextStyleName");
            this.titleTextField.enabled = true;
            addChild(DisplayObject(this.titleTextField));
         }
         if(!this.titleIconObject && Boolean(this._titleIcon))
         {
            this.titleIconObject = new this._titleIcon();
            addChild(DisplayObject(this.titleIconObject));
         }
         if(!this.minimizeButton)
         {
            this.minimizeButton = new Button();
            this.minimizeButtonSkin = getStyle("minimizeButtonSkin");
            if(Boolean(this.minimizeButtonSkin))
            {
               this.minimizeButton.setStyle("skin",this.minimizeButtonSkin);
            }
            this.minimizeButton.focusEnabled = false;
            this.minimizeButton.enabled = this.window.minimizable;
            this.minimizeButton.addEventListener(MouseEvent.MOUSE_DOWN,this.button_mouseDownHandler);
            this.minimizeButton.addEventListener(MouseEvent.CLICK,this.minimizeButton_clickHandler);
            addChild(this.minimizeButton);
         }
         if(!this.maximizeButton)
         {
            this.maximizeButton = new Button();
            this.maximizeButtonSkin = getStyle("maximizeButtonSkin");
            if(Boolean(this.maximizeButtonSkin))
            {
               this.maximizeButton.setStyle("skin",this.maximizeButtonSkin);
            }
            this.maximizeButton.focusEnabled = false;
            this.maximizeButton.enabled = this.window.maximizable;
            this.maximizeButton.addEventListener(MouseEvent.MOUSE_DOWN,this.button_mouseDownHandler);
            this.maximizeButton.addEventListener(MouseEvent.CLICK,this.maximizeButton_clickHandler);
            addChild(this.maximizeButton);
            this.restoreButtonSkin = isMac() ? null : getStyle("restoreButtonSkin");
         }
         if(!this.closeButton)
         {
            this.closeButton = new Button();
            this.closeButtonSkin = getStyle("closeButtonSkin");
            if(Boolean(this.closeButtonSkin))
            {
               this.closeButton.setStyle("skin",this.closeButtonSkin);
            }
            this.closeButton.focusEnabled = false;
            this.closeButton.addEventListener(MouseEvent.MOUSE_DOWN,this.button_mouseDownHandler);
            this.closeButton.addEventListener(MouseEvent.CLICK,this.closeButton_clickHandler);
            addChild(this.closeButton);
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.titleChanged)
         {
            this.titleTextField.text = this._title;
            this.titleChanged = false;
         }
         if(this.titleIconChanged)
         {
            if(Boolean(this.titleIconObject))
            {
               removeChild(DisplayObject(this.titleIconObject));
               this.titleIconObject = null;
            }
            if(Boolean(this._titleIcon))
            {
               this.titleIconObject = new this._titleIcon();
               addChild(DisplayObject(this.titleIconObject));
            }
            this.titleIconChanged = false;
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         this.titleTextField.validateNow();
         if(this.titleTextField.textHeight == 0)
         {
            this.titleTextField.text = " ";
            this.titleTextField.validateNow();
         }
         measuredHeight = Math.max(this.titleTextField.textHeight + UITextField.TEXT_HEIGHT_PADDING,Math.max(this.maximizeButton.measuredHeight,this.minimizeButton.measuredHeight,this.closeButton.measuredHeight) + 12);
         measuredWidth = this.titleTextField.width + this.maximizeButton.measuredWidth + this.minimizeButton.measuredWidth + this.closeButton.measuredWidth;
         if(Boolean(this.titleIconObject))
         {
            measuredHeight = Math.max(measuredHeight,this.titleIconObject.height + 1);
            measuredWidth += this.titleIconObject.width;
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var h:int = 0;
         var offset:int = 0;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(this.window.nativeWindow.closed)
         {
            return;
         }
         var leftOffset:Number = 0;
         var rightOffset:Number = 5;
         var cornerOffset:int = getStyle("cornerRadius") / 2;
         if(Boolean(this.titleBarBackground))
         {
            this.titleBarBackground.move(0,0);
            IFlexDisplayObject(this.titleBarBackground).setActualSize(unscaledWidth,unscaledHeight);
         }
         if(Boolean(this.titleIconObject))
         {
            h = int(this.titleIconObject.height);
            offset = (height - h) / 2;
            this.titleIconObject.move(cornerOffset,offset);
            leftOffset += cornerOffset + this.titleIconObject.width + getStyle("buttonPadding");
         }
         if(!isMac())
         {
            if(this.window.nativeWindow.displayState == NativeWindowDisplayState.MAXIMIZED)
            {
               if(Boolean(this.restoreButtonSkin))
               {
                  this.maximizeButton.setStyle("skin",this.restoreButtonSkin);
               }
            }
            else
            {
               this.maximizeButton.setStyle("skin",this.maximizeButtonSkin);
            }
         }
         var buttonAlign:String = getStyle("buttonAlignment");
         if(buttonAlign == "right")
         {
            this.placeButtons(buttonAlign,width,height,leftOffset,rightOffset,cornerOffset);
         }
         else if(buttonAlign == "left")
         {
            this.placeButtons(buttonAlign,width,height,leftOffset,rightOffset,cornerOffset);
         }
         else if(isMac())
         {
            buttonAlign = "left";
            this.placeButtons("left",width,height,leftOffset,rightOffset,cornerOffset);
         }
         else
         {
            this.placeButtons("right",width,height,leftOffset,rightOffset,cornerOffset);
         }
         var titleAlign:String = String(getStyle("titleAlignment"));
         if(titleAlign == "center" || titleAlign == "left")
         {
            this.placeTitle(titleAlign,leftOffset,rightOffset,buttonAlign);
         }
         else if(isMac())
         {
            this.placeTitle("center",leftOffset,rightOffset,buttonAlign);
         }
         else
         {
            this.placeTitle("left",leftOffset,rightOffset,buttonAlign);
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
               if(Boolean(this.titleBarBackground))
               {
                  removeChild(DisplayObject(this.titleBarBackground));
                  this.titleBarBackground = null;
               }
               this.titleBarBackground = new titleBarBackgroundClass();
               titleBackgroundUIComponent = this.titleBarBackground as IStyleClient;
               if(Boolean(titleBackgroundUIComponent))
               {
                  titleBackgroundUIComponent.setStyle("backgroundImage",undefined);
               }
               titleBackgroundStyleable = this.titleBarBackground as ISimpleStyleClient;
               if(Boolean(titleBackgroundStyleable))
               {
                  titleBackgroundStyleable.styleName = this;
               }
               addChildAt(DisplayObject(this.titleBarBackground),0);
            }
         }
         if(allStyles || styleProp == "titleTextStyleName")
         {
            if(Boolean(this.titleTextField))
            {
               this.titleTextField.styleName = getStyle("titleTextStyleName");
            }
         }
         if(allStyles || styleProp == "closeButtonSkin")
         {
            this.closeButtonSkin = getStyle("closeButtonSkin");
            if(Boolean(this.closeButtonSkin) && Boolean(this.closeButton))
            {
               this.closeButton.setStyle("skin",this.closeButtonSkin);
            }
         }
         if(allStyles || styleProp == "maximizeButtonSkin")
         {
            this.maximizeButtonSkin = getStyle("maximizeButtonSkin");
            if(Boolean(this.maximizeButtonSkin) && Boolean(this.maximizeButton))
            {
               this.maximizeButton.setStyle("skin",this.maximizeButtonSkin);
            }
         }
         if(allStyles || styleProp == "minimizeButtonSkin")
         {
            this.minimizeButtonSkin = getStyle("minimizeButtonSkin");
            if(Boolean(this.minimizeButtonSkin) && Boolean(this.minimizeButton))
            {
               this.minimizeButton.setStyle("skin",this.minimizeButtonSkin);
            }
         }
         if(allStyles || styleProp == "restoreButtonSkin")
         {
            this.restoreButtonSkin = getStyle("restoreButtonSkin");
         }
      }
      
      protected function placeButtons(align:String, unscaledWidth:Number, unscaledHeight:Number, leftOffset:Number, rightOffset:Number, cornerOffset:Number) : void
      {
         var pad:Number = Number(getStyle("buttonPadding"));
         var edgePad:Number = Number(getStyle("titleBarButtonPadding"));
         this.minimizeButton.setActualSize(this.minimizeButton.measuredWidth,this.minimizeButton.measuredHeight);
         this.maximizeButton.setActualSize(this.maximizeButton.measuredWidth,this.maximizeButton.measuredHeight);
         this.closeButton.setActualSize(this.closeButton.measuredWidth,this.closeButton.measuredHeight);
         if(align == "right")
         {
            this.minimizeButton.move(unscaledWidth - (this.minimizeButton.measuredWidth + this.maximizeButton.measuredWidth + this.closeButton.measuredWidth + 2 * pad) - cornerOffset - edgePad,(unscaledHeight - this.minimizeButton.measuredHeight) / 2);
            this.maximizeButton.move(unscaledWidth - (this.maximizeButton.measuredWidth + this.closeButton.measuredWidth + pad) - cornerOffset - edgePad,(unscaledHeight - this.maximizeButton.measuredHeight) / 2);
            this.closeButton.move(unscaledWidth - this.closeButton.measuredWidth - cornerOffset - edgePad,(unscaledHeight - this.closeButton.measuredHeight) / 2);
         }
         else
         {
            edgePad = Math.max(edgePad,leftOffset);
            this.closeButton.move(edgePad,(unscaledHeight - this.closeButton.measuredHeight) / 2);
            this.minimizeButton.move(pad + edgePad + this.closeButton.measuredWidth,(unscaledHeight - this.minimizeButton.measuredHeight) / 2);
            this.maximizeButton.move(edgePad + pad * 2 + this.closeButton.measuredWidth + this.minimizeButton.measuredWidth,(unscaledHeight - this.maximizeButton.measuredHeight) / 2);
         }
      }
      
      protected function placeTitle(titleAlign:String, leftOffset:Number, rightOffset:Number, buttonAlign:String) : void
      {
         var buttonsX:Number = NaN;
         var tf:TextFormat = null;
         var titleX:Number = NaN;
         var textWidth:Number = NaN;
         this.titleTextField.text = this._title;
         this.titleTextField.validateNow();
         if(buttonAlign == "left")
         {
            buttonsX = Math.max(this.closeButton.x + this.closeButton.measuredWidth,this.minimizeButton.x + this.minimizeButton.measuredWidth,this.maximizeButton.x + this.maximizeButton.measuredWidth);
         }
         else
         {
            buttonsX = Math.min(this.closeButton.x,this.minimizeButton.x,this.maximizeButton.x);
         }
         if(titleAlign == "left")
         {
            if(buttonAlign == "left")
            {
               this.titleTextField.setActualSize(width - rightOffset - 2 - buttonsX,this.measureChromeText(this.titleTextField).height + UITextField.TEXT_HEIGHT_PADDING);
               this.titleTextField.move(buttonsX,(height - (this.measureChromeText(this.titleTextField).height + UITextField.TEXT_HEIGHT_PADDING)) / 2);
               this.titleTextField.truncateToFit();
            }
            else
            {
               this.titleTextField.setActualSize(Math.max(0,buttonsX) - 2,this.measureChromeText(this.titleTextField).height + UITextField.TEXT_HEIGHT_PADDING);
               this.titleTextField.move(leftOffset,(height - (this.measureChromeText(this.titleTextField).height + UITextField.TEXT_HEIGHT_PADDING)) / 2);
               this.titleTextField.truncateToFit();
            }
         }
         else
         {
            tf = new TextFormat();
            tf.align = TextFormatAlign.LEFT;
            this.titleTextField.setTextFormat(tf);
            textWidth = Number(this.titleTextField.getLineMetrics(0).width);
            this.titleTextField.truncateToFit();
            if(buttonAlign == "left")
            {
               this.titleTextField.setActualSize(width - rightOffset - buttonsX - 2,this.measureChromeText(this.titleTextField).height + UITextField.TEXT_HEIGHT_PADDING);
               titleX = Math.max(buttonsX,(width - leftOffset - rightOffset - textWidth) / 2);
               this.titleTextField.move(titleX,(height - (this.measureChromeText(this.titleTextField).height + UITextField.TEXT_HEIGHT_PADDING)) / 2);
            }
            else
            {
               this.titleTextField.setActualSize(width - leftOffset - rightOffset - (width - buttonsX) - 2,this.measureChromeText(this.titleTextField).height + UITextField.TEXT_HEIGHT_PADDING);
               titleX = Math.max(0,Math.min(buttonsX - textWidth - 2,(width - leftOffset - rightOffset - textWidth) / 2));
               this.titleTextField.move(titleX,(height - (this.measureChromeText(this.titleTextField).height + UITextField.TEXT_HEIGHT_PADDING)) / 2);
            }
         }
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
   }
}

