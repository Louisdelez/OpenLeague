package mx.controls
{
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import mx.controls.colorPickerClasses.SwatchPanel;
   import mx.controls.colorPickerClasses.WebSafePalette;
   import mx.core.LayoutDirection;
   import mx.core.UIComponent;
   import mx.core.UIComponentGlobals;
   import mx.effects.Tween;
   import mx.events.ColorPickerEvent;
   import mx.events.DropdownEvent;
   import mx.events.FlexEvent;
   import mx.events.FlexMouseEvent;
   import mx.events.SandboxMouseEvent;
   import mx.managers.IFocusManager;
   import mx.managers.ISystemManager;
   import mx.managers.PopUpManager;
   import mx.skins.halo.SwatchSkin;
   import mx.styles.StyleProxy;
   
   [IconFile("ColorPicker.png")]
   [DefaultTriggerEvent("change")]
   [DefaultBindingProperty(source="selectedItem",destination="dataProvider")]
   [DataBindingInfo("{ dataProvider: { label: &quot;String&quot; } }")]
   [AccessibilityClass(implementation="mx.accessibility.ColorPickerAccImpl")]
   [Exclude(name="highlightAlphas",kind="style")]
   [Exclude(name="fillColors",kind="style")]
   [Exclude(name="fillAlphas",kind="style")]
   [Exclude(name="text",kind="property")]
   [Style(name="swatchPanelStyleName",type="String",inherit="no")]
   [Style(name="swatchBorderSize",type="Number",format="Length",inherit="no")]
   [Style(name="swatchBorderColor",type="uint",format="Color",inherit="no",theme="halo")]
   [Style(name="paddingTop",type="Number",format="Length",inherit="no")]
   [Style(name="paddingRight",type="Number",format="Length",inherit="no")]
   [Style(name="paddingLeft",type="Number",format="Length",inherit="no")]
   [Style(name="paddingBottom",type="Number",format="Length",inherit="no")]
   [Style(name="openEasingFunction",type="Function",inherit="no")]
   [Style(name="openDuration",type="Number",format="Time",inherit="no")]
   [Style(name="highlightAlphas",type="Array",arrayType="Number",inherit="no",theme="halo")]
   [Style(name="fillColors",type="Array",arrayType="uint",format="Color",inherit="no",theme="halo")]
   [Style(name="fillAlphas",type="Array",arrayType="Number",inherit="no",theme="halo")]
   [Style(name="closeEasingFunction",type="Function",inherit="no")]
   [Style(name="closeDuration",type="Number",format="Time",inherit="no")]
   [Style(name="borderColor",type="uint",format="Color",inherit="no",theme="halo")]
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
   [Style(name="disabledIconColor",type="uint",format="Color",inherit="yes",theme="halo")]
   [Style(name="iconColor",type="uint",format="Color",inherit="yes",theme="halo")]
   [Style(name="focusRoundedCorners",type="String",inherit="no")]
   [Style(name="focusAlpha",type="Number",inherit="no")]
   [Event(name="open",type="mx.events.DropdownEvent")]
   [Event(name="itemRollOver",type="mx.events.ColorPickerEvent")]
   [Event(name="itemRollOut",type="mx.events.ColorPickerEvent")]
   [Event(name="enter",type="mx.events.ColorPickerEvent")]
   [Event(name="close",type="mx.events.DropdownEvent")]
   [Event(name="change",type="mx.events.ColorPickerEvent")]
   public class ColorPicker extends ComboBase
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const _swatchStyleFilters:Object = {
         "swatchBorderColor":"swatchBorderColor",
         "swatchBorderSize":"swatchBorderSize"
      };
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var showingDropdown:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var isDown:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var isOpening:Boolean = false;
      
      private var dropdownGap:Number = 6;
      
      private var indexFlag:Boolean = false;
      
      private var initializing:Boolean = true;
      
      private var isModelInited:Boolean = false;
      
      private var collectionChanged:Boolean = false;
      
      private var swatchPreview:SwatchSkin;
      
      private var dropdownSwatch:SwatchPanel;
      
      private var triggerEvent:Event;
      
      [Inspectable(category="General",defaultValue="true")]
      [Bindable("editableChanged")]
      private var _editable:Boolean = true;
      
      private var _colorField:String = "color";
      
      private var _labelField:String = "label";
      
      private var _selectedColor:uint = 0;
      
      private var _showTextField:Boolean = true;
      
      public function ColorPicker()
      {
         super();
         if(!this.isModelInited)
         {
            this.loadDefaultPalette();
         }
         super.editable = false;
         addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
      }
      
      [Inspectable(category="Data")]
      [Bindable("collectionChange")]
      override public function set dataProvider(value:Object) : void
      {
         super.dataProvider = value;
         this.isModelInited = true;
         if(Boolean(this.dropdownSwatch))
         {
            this.dropdownSwatch.dataProvider = value;
         }
      }
      
      override public function get editable() : Boolean
      {
         return this._editable;
      }
      
      override public function set editable(value:Boolean) : void
      {
         this._editable = value;
         if(Boolean(this.dropdownSwatch))
         {
            this.dropdownSwatch.editable = value;
         }
         dispatchEvent(new Event("editableChanged"));
      }
      
      [Inspectable(defaultValue="0")]
      [Bindable("collectionChange")]
      [Bindable("change")]
      override public function set selectedIndex(value:int) : void
      {
         if((selectedIndex != -1 || !isNaN(this.selectedColor)) && value != selectedIndex)
         {
            if(value >= 0)
            {
               this.indexFlag = true;
               this.selectedColor = this.getColor(value);
               super.selectedIndex = value;
            }
            if(Boolean(this.dropdownSwatch))
            {
               this.dropdownSwatch.selectedIndex = value;
            }
         }
      }
      
      [Inspectable(defaultValue="0")]
      [Bindable("collectionChange")]
      [Bindable("change")]
      override public function set selectedItem(value:Object) : void
      {
         if(value != selectedItem)
         {
            super.selectedItem = value;
            if(typeof value == "object")
            {
               this.selectedColor = Number(value[this.colorField]);
            }
            else if(typeof value == "number")
            {
               this.selectedColor = Number(value);
            }
            this.indexFlag = true;
            if(Boolean(this.dropdownSwatch))
            {
               this.dropdownSwatch.selectedItem = value;
            }
         }
      }
      
      [Inspectable(category="Data",defaultValue="color")]
      [Bindable("colorFieldChanged")]
      public function get colorField() : String
      {
         return this._colorField;
      }
      
      public function set colorField(value:String) : void
      {
         this._colorField = value;
         if(Boolean(this.dropdownSwatch))
         {
            this.dropdownSwatch.colorField = value;
         }
         dispatchEvent(new Event("colorFieldChanged"));
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get dropdown() : SwatchPanel
      {
         return this.dropdownSwatch;
      }
      
      [Inspectable(category="Data",defaultValue="label")]
      [Bindable("labelFieldChanged")]
      public function get labelField() : String
      {
         return this._labelField;
      }
      
      public function set labelField(value:String) : void
      {
         this._labelField = value;
         if(Boolean(this.dropdownSwatch))
         {
            this.dropdownSwatch.labelField = value;
         }
         dispatchEvent(new Event("labelFieldChanged"));
      }
      
      [Inspectable(category="General",defaultValue="0",format="Color")]
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get selectedColor() : uint
      {
         return this._selectedColor;
      }
      
      public function set selectedColor(value:uint) : void
      {
         if(!this.indexFlag)
         {
            super.selectedIndex = this.findColorByName(value);
         }
         else
         {
            this.indexFlag = false;
         }
         if(value != this.selectedColor)
         {
            this._selectedColor = value;
            this.updateColor(value);
            if(Boolean(this.dropdownSwatch))
            {
               this.dropdownSwatch.selectedColor = value;
            }
         }
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get showTextField() : Boolean
      {
         return this._showTextField;
      }
      
      public function set showTextField(value:Boolean) : void
      {
         this._showTextField = value;
         if(Boolean(this.dropdownSwatch))
         {
            this.dropdownSwatch.showTextField = value;
         }
      }
      
      protected function get swatchStyleFilters() : Object
      {
         return _swatchStyleFilters;
      }
      
      override protected function initializeAccessibility() : void
      {
         if(ColorPicker.createAccessibilityImplementation != null)
         {
            ColorPicker.createAccessibilityImplementation(this);
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!this.swatchPreview)
         {
            this.swatchPreview = new SwatchSkin();
            this.swatchPreview.styleName = new StyleProxy(this,this.swatchStyleFilters);
            this.swatchPreview.color = this.selectedColor;
            this.swatchPreview.name = "colorPickerSwatch";
            addChild(this.swatchPreview);
         }
         setChildIndex(this.swatchPreview,getChildIndex(downArrowButton));
         textInput.visible = false;
         if(!enabled)
         {
            super.enabled = enabled;
         }
         this.initializing = false;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.collectionChanged)
         {
            if(this.findColorByName(this.selectedColor) == -1)
            {
               if(dataProvider.length > 0 && selectedIndex > dataProvider.length)
               {
                  this.selectedIndex = 0;
               }
               if(this.getColor(selectedIndex) >= 0)
               {
                  this.selectedColor = this.getColor(selectedIndex);
                  this.swatchPreview.color = this.selectedColor;
               }
               else if(Boolean(this.dropdownSwatch))
               {
                  this.swatchPreview.color = this.dropdownSwatch.selectedColor;
               }
            }
            else
            {
               this.selectedIndex = this.findColorByName(this.selectedColor);
            }
            this.collectionChanged = false;
         }
      }
      
      override protected function measure() : void
      {
         measuredMinWidth = measuredWidth = DEFAULT_MEASURED_MIN_HEIGHT;
         measuredMinHeight = measuredHeight = DEFAULT_MEASURED_MIN_HEIGHT;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         this.swatchPreview.color = this.selectedColor;
         this.swatchPreview.setActualSize(unscaledWidth,unscaledHeight);
         downArrowButton.move(0,0);
         downArrowButton.setActualSize(unscaledWidth,unscaledHeight);
         if(Boolean(this.dropdownSwatch))
         {
            this.dropdownSwatch.setActualSize(this.dropdownSwatch.getExplicitOrMeasuredWidth(),this.dropdownSwatch.getExplicitOrMeasuredHeight());
         }
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var swatchPanelStyleName:Object = null;
         if(Boolean(this.dropdownSwatch))
         {
            if(styleProp == "swatchPanelStyleName")
            {
               swatchPanelStyleName = getStyle("swatchPanelStyleName");
               if(Boolean(swatchPanelStyleName))
               {
                  this.dropdownSwatch.styleName = swatchPanelStyleName;
               }
            }
            this.dropdownSwatch.styleChanged(styleProp);
         }
         super.styleChanged(styleProp);
         invalidateDisplayList();
      }
      
      public function open() : void
      {
         this.displayDropdown(true);
      }
      
      public function close(trigger:Event = null) : void
      {
         this.displayDropdown(false,trigger);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getDropdown() : SwatchPanel
      {
         var swatchPanelStyleName:Object = null;
         if(this.initializing)
         {
            return null;
         }
         if(!this.dropdownSwatch)
         {
            this.dropdownSwatch = new SwatchPanel();
            this.dropdownSwatch.owner = this;
            this.dropdownSwatch.editable = this.editable;
            this.dropdownSwatch.colorField = this.colorField;
            this.dropdownSwatch.labelField = this.labelField;
            this.dropdownSwatch.dataProvider = dataProvider;
            this.dropdownSwatch.showTextField = this.showTextField;
            this.dropdownSwatch.selectedColor = this.selectedColor;
            this.dropdownSwatch.selectedIndex = selectedIndex;
            this.dropdownSwatch.textInputClass = getStyle("textInputClass");
            swatchPanelStyleName = getStyle("swatchPanelStyleName");
            if(Boolean(swatchPanelStyleName))
            {
               this.dropdownSwatch.styleName = swatchPanelStyleName;
            }
            this.dropdownSwatch.addEventListener(ColorPickerEvent.ITEM_ROLL_OVER,this.dropdownSwatch_itemRollOverHandler);
            this.dropdownSwatch.addEventListener(ColorPickerEvent.ITEM_ROLL_OUT,this.dropdownSwatch_itemRollOutHandler);
            this.dropdownSwatch.cacheAsBitmap = true;
            this.dropdownSwatch.scrollRect = new Rectangle(0,0,0,0);
            PopUpManager.addPopUp(this.dropdownSwatch,this);
            UIComponentGlobals.layoutManager.validateClient(this.dropdownSwatch,true);
            this.dropdownSwatch.setActualSize(this.dropdownSwatch.getExplicitOrMeasuredWidth(),this.dropdownSwatch.getExplicitOrMeasuredHeight());
            this.dropdownSwatch.validateDisplayList();
         }
         this.dropdownSwatch.layoutDirection = layoutDirection;
         this.dropdownSwatch.scaleX = scaleX;
         this.dropdownSwatch.scaleY = scaleY;
         return this.dropdownSwatch;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function displayDropdown(show:Boolean, trigger:Event = null) : void
      {
         var initY:Number = NaN;
         var endY:Number = NaN;
         var easingFunction:Function = null;
         var duration:Number = NaN;
         var point:Point = null;
         var sm:ISystemManager = null;
         var screen:Rectangle = null;
         if(show == this.showingDropdown)
         {
            return;
         }
         var tween:Tween = null;
         this.triggerEvent = trigger;
         if(show)
         {
            this.getDropdown();
            point = new Point(layoutDirection == LayoutDirection.RTL ? Number(this.dropdownSwatch.getExplicitOrMeasuredWidth()) : 0,0);
            point = localToGlobal(point);
            if(this.dropdownSwatch.parent == null)
            {
               PopUpManager.addPopUp(this.dropdownSwatch,this,false);
            }
            else
            {
               PopUpManager.bringToFront(this.dropdownSwatch);
            }
            this.dropdownSwatch.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE,this.dropdownSwatch_mouseDownOutsideHandler);
            this.dropdownSwatch.addEventListener(FlexMouseEvent.MOUSE_WHEEL_OUTSIDE,this.dropdownSwatch_mouseDownOutsideHandler);
            this.dropdownSwatch.addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,this.dropdownSwatch_mouseDownOutsideHandler);
            this.dropdownSwatch.addEventListener(SandboxMouseEvent.MOUSE_WHEEL_SOMEWHERE,this.dropdownSwatch_mouseDownOutsideHandler);
            this.dropdownSwatch.isOpening = true;
            this.dropdownSwatch.showTextField = this.showTextField;
            this.dropdownSwatch.selectedColor = this.selectedColor;
            this.dropdownSwatch.owner = this;
            sm = systemManager.topLevelSystemManager;
            screen = sm.getVisibleApplicationRect(null,true);
            if(point.y + height + this.dropdownGap + this.dropdownSwatch.height > screen.bottom && point.y > screen.top + this.dropdownGap + this.dropdownSwatch.height)
            {
               point.y -= this.dropdownGap + this.dropdownSwatch.height;
               initY = -this.dropdownSwatch.height / scaleY;
               this.dropdownSwatch.tweenUp = true;
            }
            else
            {
               point.y += this.dropdownGap + height;
               initY = this.dropdownSwatch.height / scaleY;
               this.dropdownSwatch.tweenUp = false;
            }
            if(point.x + this.dropdownSwatch.width > screen.right && point.x > screen.left + this.dropdownSwatch.width)
            {
               point.x -= this.dropdownSwatch.width - width;
            }
            point.x = Math.max(point.x,0);
            point = this.dropdownSwatch.parent.globalToLocal(point);
            this.dropdownSwatch.move(point.x,point.y);
            this.isDown = true;
            this.isOpening = true;
            endY = 0;
            duration = Number(getStyle("openDuration"));
            easingFunction = getStyle("openEasingFunction") as Function;
            this.showingDropdown = show;
         }
         else
         {
            initY = 0;
            endY = this.dropdownSwatch.tweenUp ? -this.dropdownSwatch.height / scaleY : this.dropdownSwatch.height / scaleY;
            this.isDown = false;
            duration = Number(getStyle("closeDuration"));
            easingFunction = getStyle("closeEasingFunction") as Function;
            this.showingDropdown = show;
            this.dropdownSwatch.removeEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE,this.dropdownSwatch_mouseDownOutsideHandler);
            this.dropdownSwatch.removeEventListener(FlexMouseEvent.MOUSE_WHEEL_OUTSIDE,this.dropdownSwatch_mouseDownOutsideHandler);
            this.dropdownSwatch.removeEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,this.dropdownSwatch_mouseDownOutsideHandler);
            this.dropdownSwatch.removeEventListener(SandboxMouseEvent.MOUSE_WHEEL_SOMEWHERE,this.dropdownSwatch_mouseDownOutsideHandler);
            PopUpManager.removePopUp(this.dropdownSwatch);
         }
         if(Boolean(this.dropdownSwatch))
         {
            this.dropdownSwatch.visible = true;
            this.dropdownSwatch.enabled = false;
         }
         UIComponentGlobals.layoutManager.validateNow();
         UIComponent.suspendBackgroundProcessing();
         tween = new Tween(this,initY,endY,duration);
         if(easingFunction != null)
         {
            tween.easingFunction = easingFunction;
         }
      }
      
      private function loadDefaultPalette() : void
      {
         var wsp:WebSafePalette = null;
         if(!dataProvider || dataProvider.length < 1)
         {
            wsp = new WebSafePalette();
            this.dataProvider = wsp.getList();
         }
         this.selectedIndex = this.findColorByName(this.selectedColor);
      }
      
      private function updateColor(color:Number) : void
      {
         if(this.initializing || isNaN(color))
         {
            return;
         }
         this.swatchPreview.updateSkin(color);
      }
      
      private function findColorByName(name:Number) : int
      {
         if(name == this.getColor(selectedIndex))
         {
            return selectedIndex;
         }
         var n:int = int(dataProvider.length);
         for(var i:int = 0; i < dataProvider.length; i++)
         {
            if(name == this.getColor(i))
            {
               return i;
            }
         }
         return -1;
      }
      
      private function getColor(location:int) : Number
      {
         if(!dataProvider || dataProvider.length < 1 || location < 0 || location >= dataProvider.length)
         {
            return -1;
         }
         return Number(typeof dataProvider.getItemAt(location) == "object" ? dataProvider.getItemAt(location)[this.colorField] : dataProvider.getItemAt(location));
      }
      
      override protected function focusInHandler(event:FocusEvent) : void
      {
         var fm:IFocusManager = focusManager;
         if(Boolean(fm))
         {
            fm.showFocusIndicator = true;
         }
         if(this.isDown && !this.isOpening)
         {
            this.close();
         }
         else if(this.isOpening)
         {
            this.isOpening = false;
         }
         super.focusInHandler(event);
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         var cpEvent:ColorPickerEvent = null;
         var keyCode:uint = uint(mapKeycodeForLayoutDirection(event));
         if(event.ctrlKey && keyCode == Keyboard.DOWN)
         {
            this.displayDropdown(true,event);
         }
         else if(event.ctrlKey && keyCode == Keyboard.UP || keyCode == Keyboard.ESCAPE)
         {
            if(Boolean(this.dropdownSwatch) && Boolean(this.dropdownSwatch.enabled))
            {
               this.close(event);
            }
         }
         else if(this.showingDropdown && keyCode == Keyboard.ENTER && Boolean(this.dropdownSwatch.enabled))
         {
            if(!this.dropdownSwatch.isOverGrid && this.editable)
            {
               if(this.selectedColor != this.dropdownSwatch.selectedColor)
               {
                  this.selectedColor = this.dropdownSwatch.selectedColor;
                  cpEvent = new ColorPickerEvent(ColorPickerEvent.CHANGE);
                  cpEvent.index = selectedIndex;
                  cpEvent.color = this.selectedColor;
                  dispatchEvent(cpEvent);
                  cpEvent = new ColorPickerEvent(ColorPickerEvent.ENTER);
                  cpEvent.color = this.selectedColor;
                  dispatchEvent(cpEvent);
               }
            }
            else if(selectedIndex != this.dropdownSwatch.focusedIndex)
            {
               this.dropdownSwatch.selectedIndex = this.dropdownSwatch.focusedIndex;
               this.selectedIndex = this.dropdownSwatch.selectedIndex;
               cpEvent = new ColorPickerEvent(ColorPickerEvent.CHANGE);
               cpEvent.index = selectedIndex;
               cpEvent.color = this.selectedColor;
               dispatchEvent(cpEvent);
            }
            this.close();
            event.stopPropagation();
         }
         else if(this.showingDropdown && (keyCode == Keyboard.HOME || keyCode == Keyboard.END || keyCode == Keyboard.PAGE_UP || keyCode == Keyboard.PAGE_DOWN || keyCode == Keyboard.LEFT || keyCode == Keyboard.RIGHT || keyCode == Keyboard.UP || keyCode == Keyboard.DOWN))
         {
            this.dropdownSwatch.dispatchEvent(event);
         }
         else if(keyCode == Keyboard.LEFT)
         {
            if(selectedIndex == -1)
            {
               this.selectedIndex = this.findColorByName(this.selectedColor);
            }
            if(selectedIndex - 1 >= 0)
            {
               --selectedIndex;
               cpEvent = new ColorPickerEvent(ColorPickerEvent.CHANGE);
               cpEvent.index = selectedIndex;
               cpEvent.color = this.selectedColor;
               dispatchEvent(cpEvent);
            }
         }
         else if(keyCode == Keyboard.RIGHT)
         {
            if(selectedIndex == -1)
            {
               this.selectedIndex = this.findColorByName(this.selectedColor);
            }
            if(selectedIndex + 1 < dataProvider.length)
            {
               ++selectedIndex;
               cpEvent = new ColorPickerEvent(ColorPickerEvent.CHANGE);
               cpEvent.index = selectedIndex;
               cpEvent.color = this.selectedColor;
               dispatchEvent(cpEvent);
            }
         }
      }
      
      override protected function collectionChangeHandler(event:Event) : void
      {
         if(!this.initializing)
         {
            if(dataProvider.length > 0)
            {
               invalidateProperties();
            }
            else
            {
               this.selectedColor = 0;
               this.selectedIndex = -1;
            }
            this.collectionChanged = true;
         }
         if(Boolean(this.dropdownSwatch))
         {
            this.dropdownSwatch.dataProvider = dataProvider;
         }
      }
      
      override protected function downArrowButton_buttonDownHandler(event:FlexEvent) : void
      {
         this.displayDropdown(!this.showingDropdown,event);
      }
      
      private function dropdownSwatch_itemRollOverHandler(event:ColorPickerEvent) : void
      {
         dispatchEvent(event);
      }
      
      private function dropdownSwatch_itemRollOutHandler(event:ColorPickerEvent) : void
      {
         dispatchEvent(event);
      }
      
      private function dropdownSwatch_mouseDownOutsideHandler(event:Event) : void
      {
         var mouseEvent:MouseEvent = null;
         if(event is MouseEvent)
         {
            mouseEvent = MouseEvent(event);
            if(!hitTestPoint(mouseEvent.stageX,mouseEvent.stageY,true))
            {
               this.close(event);
            }
         }
         else if(event is SandboxMouseEvent)
         {
            this.close(event);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function onTweenUpdate(value:Number) : void
      {
         this.dropdownSwatch.scrollRect = new Rectangle(0,value,this.dropdownSwatch.width,this.dropdownSwatch.height);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function onTweenEnd(value:Number) : void
      {
         if(this.showingDropdown)
         {
            this.dropdownSwatch.scrollRect = null;
         }
         else
         {
            this.onTweenUpdate(value);
            this.dropdownSwatch.visible = false;
            this.isOpening = false;
         }
         UIComponent.resumeBackgroundProcessing();
         if(this.showingDropdown && this.showTextField)
         {
            this.dropdownSwatch.callLater(this.dropdownSwatch.setFocus);
         }
         else
         {
            setFocus();
         }
         this.dropdownSwatch.enabled = true;
         dispatchEvent(new DropdownEvent(this.showingDropdown ? DropdownEvent.OPEN : DropdownEvent.CLOSE,false,false,this.triggerEvent));
      }
   }
}

