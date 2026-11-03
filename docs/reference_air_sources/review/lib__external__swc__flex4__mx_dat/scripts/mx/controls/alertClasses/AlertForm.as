package mx.controls.alertClasses
{
   import flash.display.DisplayObject;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextLineMetrics;
   import flash.ui.Keyboard;
   import mx.controls.Alert;
   import mx.controls.Button;
   import mx.core.IFlexModuleFactory;
   import mx.core.IFontContextComponent;
   import mx.core.IUITextField;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.events.CloseEvent;
   import mx.managers.IActiveWindowManager;
   import mx.managers.IFocusManagerContainer;
   import mx.managers.ISystemManager;
   import mx.managers.PopUpManager;
   
   [ExcludeClass]
   [Style(name="textIndent",type="Number",format="Length",inherit="yes")]
   [Style(name="textFieldClass",type="Class",inherit="no")]
   [Style(name="textDecoration",type="String",enumeration="none,underline",inherit="yes")]
   [Style(name="textAlign",type="String",enumeration="left,center,right",inherit="yes")]
   [Style(name="locale",type="String",inherit="yes")]
   [Style(name="letterSpacing",type="Number",inherit="yes")]
   [Style(name="kerning",type="Boolean",inherit="yes")]
   [Style(name="fontWeight",type="String",enumeration="normal,bold",inherit="yes")]
   [Style(name="fontThickness",type="Number",inherit="yes")]
   [Style(name="fontStyle",type="String",enumeration="normal,italic",inherit="yes")]
   [Style(name="fontSize",type="Number",format="Length",inherit="yes")]
   [Style(name="fontSharpness",type="Number",inherit="yes")]
   [Style(name="fontGridFitType",type="String",enumeration="none,pixel,subpixel",inherit="yes")]
   [Style(name="fontFamily",type="String",inherit="yes")]
   [Style(name="fontAntiAliasType",type="String",enumeration="normal,advanced",inherit="yes")]
   [Style(name="disabledColor",type="uint",format="Color",inherit="yes")]
   [Style(name="direction",type="String",enumeration="ltr,rtl,inherit",inherit="yes")]
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   [Style(name="leading",type="Number",format="Length",inherit="yes")]
   public class AlertForm extends UIComponent implements IFontContextComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var textField:IUITextField;
      
      private var textWidth:Number;
      
      private var textHeight:Number;
      
      private var icon:DisplayObject;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var buttons:Array = [];
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var defaultButton:Button;
      
      private var defaultButtonChanged:Boolean = false;
      
      public function AlertForm()
      {
         super();
      }
      
      public function get fontContext() : IFlexModuleFactory
      {
         return moduleFactory;
      }
      
      public function set fontContext(moduleFactory:IFlexModuleFactory) : void
      {
         this.moduleFactory = moduleFactory;
      }
      
      override protected function createChildren() : void
      {
         var label:String = null;
         var button:Button = null;
         super.createChildren();
         this.createTextField(-1);
         var iconClass:Class = Alert(parent).iconClass;
         if(Boolean(iconClass) && !this.icon)
         {
            this.icon = new iconClass();
            addChild(this.icon);
         }
         var alert:Alert = Alert(parent);
         var buttonFlags:uint = alert.buttonFlags;
         var defaultButtonFlag:uint = alert.defaultButtonFlag;
         if(Boolean(buttonFlags & Alert.OK))
         {
            label = String(Alert.okLabel);
            button = this.createButton(label,"OK");
            if(defaultButtonFlag == Alert.OK)
            {
               this.defaultButton = button;
            }
         }
         if(Boolean(buttonFlags & Alert.YES))
         {
            label = String(Alert.yesLabel);
            button = this.createButton(label,"YES");
            if(defaultButtonFlag == Alert.YES)
            {
               this.defaultButton = button;
            }
         }
         if(Boolean(buttonFlags & Alert.NO))
         {
            label = String(Alert.noLabel);
            button = this.createButton(label,"NO");
            if(defaultButtonFlag == Alert.NO)
            {
               this.defaultButton = button;
            }
         }
         if(Boolean(buttonFlags & Alert.CANCEL))
         {
            label = String(Alert.cancelLabel);
            button = this.createButton(label,"CANCEL");
            if(defaultButtonFlag == Alert.CANCEL)
            {
               this.defaultButton = button;
            }
         }
         if(!this.defaultButton && Boolean(this.buttons.length))
         {
            this.defaultButton = this.buttons[0];
         }
         if(Boolean(this.defaultButton))
         {
            this.defaultButtonChanged = true;
            invalidateProperties();
         }
      }
      
      override protected function commitProperties() : void
      {
         var index:int = 0;
         var sm:ISystemManager = null;
         var awm:IActiveWindowManager = null;
         super.commitProperties();
         if(Boolean(hasFontContextChanged()) && this.textField != null)
         {
            index = int(getChildIndex(DisplayObject(this.textField)));
            this.removeTextField();
            this.createTextField(index);
         }
         if(this.defaultButtonChanged && Boolean(this.defaultButton))
         {
            this.defaultButtonChanged = false;
            Alert(parent).defaultButton = this.defaultButton;
            if(parent is IFocusManagerContainer)
            {
               sm = Alert(parent).systemManager;
               awm = IActiveWindowManager(sm.getImplementation("mx.managers::IActiveWindowManager"));
               if(Boolean(awm))
               {
                  awm.activate(IFocusManagerContainer(parent));
               }
            }
            this.defaultButton.setFocus();
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         var title:String = Alert(parent).title;
         var lineMetrics:TextLineMetrics = Alert(parent).getTitleTextField().getUITextFormat().measureText(title);
         var numButtons:int = Math.max(this.buttons.length,2);
         var buttonWidth:Number = numButtons * this.buttons[0].width + (numButtons - 1) * 8;
         var buttonAndTitleWidth:Number = Math.max(buttonWidth,lineMetrics.width);
         this.textField.width = 2 * buttonAndTitleWidth;
         this.textWidth = this.textField.textWidth + UITextField.TEXT_WIDTH_PADDING;
         var prefWidth:Number = Math.max(buttonAndTitleWidth,this.textWidth);
         prefWidth = Math.min(prefWidth,2 * buttonAndTitleWidth);
         if(this.textWidth < prefWidth && this.textField.multiline == true)
         {
            this.textField.multiline = false;
            this.textField.wordWrap = false;
         }
         else if(this.textField.multiline == false)
         {
            this.textField.wordWrap = true;
            this.textField.multiline = true;
         }
         prefWidth += 16;
         if(Boolean(this.icon))
         {
            prefWidth += this.icon.width + 8;
         }
         this.textHeight = this.textField.textHeight + UITextField.TEXT_HEIGHT_PADDING;
         var prefHeight:Number = this.textHeight;
         if(Boolean(this.icon))
         {
            prefHeight = Math.max(prefHeight,this.icon.height);
         }
         prefHeight = Math.min(prefHeight,screen.height * 0.75);
         prefHeight += this.buttons[0].height + 3 * 8;
         measuredWidth = prefWidth;
         measuredHeight = prefHeight;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var newX:Number = NaN;
         var newY:Number = NaN;
         var newWidth:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         newY = unscaledHeight - this.buttons[0].height;
         newWidth = this.buttons.length * (this.buttons[0].width + 8) - 8;
         newX = Math.round((unscaledWidth - newWidth) / 2);
         for(var i:int = 0; i < this.buttons.length; i++)
         {
            this.buttons[i].move(newX,newY);
            this.buttons[i].tabIndex = i + 1;
            newX += this.buttons[i].width + 8;
         }
         newWidth = this.textWidth;
         if(Boolean(this.icon))
         {
            newWidth += this.icon.width + 8;
         }
         newX = Math.round((unscaledWidth - newWidth) / 2);
         if(Boolean(this.icon))
         {
            this.icon.x = newX;
            this.icon.y = (newY - this.icon.height) / 2;
            newX += this.icon.width + 8;
         }
         var newHeight:Number = Number(this.textField.getExplicitOrMeasuredHeight());
         this.textField.move(newX,Math.round((newY - newHeight) / 2));
         this.textField.setActualSize(this.textWidth + 5,newHeight);
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var buttonStyleName:String = null;
         var n:int = 0;
         var i:int = 0;
         super.styleChanged(styleProp);
         if(!styleProp || styleProp == "styleName" || styleProp == "buttonStyleName")
         {
            if(Boolean(this.buttons))
            {
               buttonStyleName = getStyle("buttonStyleName");
               n = int(this.buttons.length);
               for(i = 0; i < n; i++)
               {
                  this.buttons[i].styleName = buttonStyleName;
               }
            }
         }
      }
      
      override protected function resourcesChanged() : void
      {
         var b:Button = null;
         super.resourcesChanged();
         b = Button(getChildByName("OK"));
         if(Boolean(b))
         {
            b.label = String(Alert.okLabel);
         }
         b = Button(getChildByName("CANCEL"));
         if(Boolean(b))
         {
            b.label = String(Alert.cancelLabel);
         }
         b = Button(getChildByName("YES"));
         if(Boolean(b))
         {
            b.label = String(Alert.yesLabel);
         }
         b = Button(getChildByName("NO"));
         if(Boolean(b))
         {
            b.label = String(Alert.noLabel);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createTextField(childIndex:int) : void
      {
         if(!this.textField)
         {
            this.textField = IUITextField(createInFontContext(UITextField));
            this.textField.styleName = this;
            this.textField.text = Alert(parent).text;
            this.textField.multiline = true;
            this.textField.wordWrap = true;
            this.textField.selectable = true;
            if(childIndex == -1)
            {
               addChild(DisplayObject(this.textField));
            }
            else
            {
               addChildAt(DisplayObject(this.textField),childIndex);
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removeTextField() : void
      {
         if(Boolean(this.textField))
         {
            removeChild(DisplayObject(this.textField));
            this.textField = null;
         }
      }
      
      private function createButton(label:String, name:String) : Button
      {
         var button:Button = new Button();
         button.label = label;
         button.name = name;
         var buttonStyleName:String = getStyle("buttonStyleName");
         if(Boolean(buttonStyleName))
         {
            button.styleName = buttonStyleName;
         }
         button.addEventListener(MouseEvent.CLICK,this.clickHandler);
         button.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
         button.owner = parent;
         addChild(button);
         button.setActualSize(Alert.buttonWidth,Alert.buttonHeight);
         this.buttons.push(button);
         return button;
      }
      
      private function removeAlert(buttonPressed:String) : void
      {
         var alert:Alert = Alert(parent);
         alert.visible = false;
         var closeEvent:CloseEvent = new CloseEvent(CloseEvent.CLOSE);
         if(buttonPressed == "YES")
         {
            closeEvent.detail = Alert.YES;
         }
         else if(buttonPressed == "NO")
         {
            closeEvent.detail = Alert.NO;
         }
         else if(buttonPressed == "OK")
         {
            closeEvent.detail = Alert.OK;
         }
         else if(buttonPressed == "CANCEL")
         {
            closeEvent.detail = Alert.CANCEL;
         }
         alert.dispatchEvent(closeEvent);
         PopUpManager.removePopUp(alert);
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         var buttonFlags:uint = Alert(parent).buttonFlags;
         if(event.keyCode == Keyboard.ESCAPE)
         {
            if(Boolean(buttonFlags & Alert.CANCEL) || !(buttonFlags & Alert.NO))
            {
               this.removeAlert("CANCEL");
            }
            else if(Boolean(buttonFlags & Alert.NO))
            {
               this.removeAlert("NO");
            }
         }
      }
      
      private function clickHandler(event:MouseEvent) : void
      {
         var name:String = Button(event.currentTarget).name;
         this.removeAlert(name);
      }
   }
}

