package mx.controls
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import mx.controls.colorPickerClasses.SwatchPanel;
   import mx.controls.colorPickerClasses.WebSafePalette;
   import mx.core.FlexVersion;
   import mx.core.UIComponent;
   import mx.core.UIComponentGlobals;
   import mx.core.mx_internal;
   import mx.effects.Tween;
   import mx.events.ColorPickerEvent;
   import mx.events.DropdownEvent;
   import mx.events.FlexEvent;
   import mx.events.FlexMouseEvent;
   import mx.events.InterManagerRequest;
   import mx.events.SandboxMouseEvent;
   import mx.managers.IFocusManager;
   import mx.managers.ISystemManager;
   import mx.managers.PopUpManager;
   import mx.skins.halo.SwatchSkin;
   import mx.styles.StyleProxy;
   
   use namespace mx_internal;
   
   [IconFile("ColorPicker.png")]
   [DefaultTriggerEvent("change")]
   [DefaultBindingProperty(source="selectedItem",destination="dataProvider")]
   [DataBindingInfo("{ dataProvider: { label: &quot;String&quot; } }")]
   [AccessibilityClass(implementation="mx.accessibility.ColorPickerAccImpl")]
   [Exclude(name="highlightAlphas",kind="style")]
   [Exclude(name="fillColors",kind="style")]
   [Exclude(name="fillAlphas",kind="style")]
   [Exclude(name="text",kind="property")]
   [Style(name="verticalGap",type="Number",format="Length",inherit="no",deprecatedReplacement="swatchPanelStyleName",deprecatedSince="3.0")]
   [Style(name="textFieldWidth",type="Number",format="Length",inherit="no",deprecatedReplacement="swatchPanelStyleName",deprecatedSince="3.0")]
   [Style(name="textFieldStyleName",type="String",inherit="no",deprecatedReplacement="swatchPanelStyleName",deprecatedSince="3.0")]
   [Style(name="swatchWidth",type="Number",format="Length",inherit="no",deprecatedReplacement="swatchPanelStyleName",deprecatedSince="3.0")]
   [Style(name="swatchPanelStyleName",type="String",inherit="no")]
   [Style(name="swatchHighlightSize",type="Number",format="Length",inherit="no",deprecatedReplacement="swatchPanelStyleName",deprecatedSince="3.0")]
   [Style(name="swatchHighlightColor",type="uint",format="Color",inherit="no",deprecatedReplacement="swatchPanelStyleName",deprecatedSince="3.0")]
   [Style(name="swatchHeight",type="Number",format="Length",inherit="no",deprecatedReplacement="swatchPanelStyleName",deprecatedSince="3.0")]
   [Style(name="swatchGridBorderSize",type="Number",format="Length",inherit="no",deprecatedReplacement="swatchPanelStyleName",deprecatedSince="3.0")]
   [Style(name="swatchGridBackgroundColor",type="uint",format="Color",inherit="no",deprecatedReplacement="swatchPanelStyleName",deprecatedSince="3.0")]
   [Style(name="swatchBorderSize",type="Number",format="Length",inherit="no")]
   [Style(name="swatchBorderColor",type="uint",format="Color",inherit="no")]
   [Style(name="previewWidth",type="Number",format="Length",inherit="no",deprecatedReplacement="swatchPanelStyleName",deprecatedSince="3.0")]
   [Style(name="previewHeight",type="Number",format="Length",inherit="no",deprecatedReplacement="swatchPanelStyleName",deprecatedSince="3.0")]
   [Style(name="paddingTop",type="Number",format="Length",inherit="no")]
   [Style(name="paddingRight",type="Number",format="Length",inherit="no")]
   [Style(name="paddingLeft",type="Number",format="Length",inherit="no")]
   [Style(name="paddingBottom",type="Number",format="Length",inherit="no")]
   [Style(name="openEasingFunction",type="Function",inherit="no")]
   [Style(name="openDuration",type="Number",format="Time",inherit="no")]
   [Style(name="horizontalGap",type="Number",format="Length",inherit="no",deprecatedReplacement="swatchPanelStyleName",deprecatedSince="3.0")]
   [Style(name="highlightAlphas",type="Array",arrayType="Number",inherit="no")]
   [Style(name="fillColors",type="Array",arrayType="uint",format="Color",inherit="no")]
   [Style(name="fillAlphas",type="Array",arrayType="Number",inherit="no")]
   [Style(name="columnCount",type="int",inherit="no",deprecatedReplacement="swatchPanelStyleName",deprecatedSince="3.0")]
   [Style(name="closeEasingFunction",type="Function",inherit="no")]
   [Style(name="closeDuration",type="Number",format="Time",inherit="no")]
   [Style(name="borderColor",type="uint",format="Color",inherit="no")]
   [Style(name="backgroundColor",type="uint",format="Color",inherit="no",deprecatedReplacement="swatchPanelStyleName",deprecatedSince="3.0")]
   [Style(name="textIndent",type="Number",format="Length",inherit="yes")]
   [Style(name="textDecoration",type="String",enumeration="none,underline",inherit="yes")]
   [Style(name="textAlign",type="String",enumeration="left,center,right",inherit="yes")]
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
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   [Style(name="leading",type="Number",format="Length",inherit="yes")]
   [Style(name="disabledIconColor",type="uint",format="Color",inherit="yes")]
   [Style(name="iconColor",type="uint",format="Color",inherit="yes")]
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
      
      mx_internal static var createAccessibilityImplementation:Function;
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static const _swatchStyleFilters:Object = {
         "swatchBorderColor":"swatchBorderColor",
         "swatchBorderSize":"swatchBorderSize"
      };
      
      private var dropdownGap:Number = 6;
      
      private var _selectedColor:uint = 0;
      
      private var _labelField:String = "label";
      
      mx_internal var showingDropdown:Boolean = false;
      
      private var swatchPreview:SwatchSkin;
      
      private var dropdownSwatch:SwatchPanel;
      
      private var isModelInited:Boolean = false;
      
      private var collectionChanged:Boolean = false;
      
      private var triggerEvent:Event;
      
      [Inspectable(category="General",defaultValue="true")]
      [Bindable("editableChanged")]
      private var _editable:Boolean = true;
      
      private var initializing:Boolean = true;
      
      mx_internal var isOpening:Boolean = false;
      
      private var _showTextField:Boolean = true;
      
      private var indexFlag:Boolean = false;
      
      mx_internal var isDown:Boolean = false;
      
      private var _colorField:String = "color";
      
      public function ColorPicker()
      {
         super();
         if(!isModelInited)
         {
            loadDefaultPalette();
         }
         super.editable = false;
         addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
      }
      
      private function loadDefaultPalette() : void
      {
         var wsp:WebSafePalette = null;
         if(!dataProvider || dataProvider.length < 1)
         {
            wsp = new WebSafePalette();
            dataProvider = wsp.getList();
         }
         selectedIndex = findColorByName(selectedColor);
      }
      
      private function dropdownSwatch_itemRollOverHandler(event:ColorPickerEvent) : void
      {
         dispatchEvent(event);
      }
      
      mx_internal function getDropdown() : SwatchPanel
      {
         var swatchPanelStyleName:Object = null;
         if(initializing)
         {
            return null;
         }
         if(!dropdownSwatch)
         {
            dropdownSwatch = new SwatchPanel();
            dropdownSwatch.owner = this;
            dropdownSwatch.editable = editable;
            dropdownSwatch.colorField = colorField;
            dropdownSwatch.labelField = labelField;
            dropdownSwatch.dataProvider = dataProvider;
            dropdownSwatch.showTextField = showTextField;
            dropdownSwatch.selectedColor = selectedColor;
            dropdownSwatch.selectedIndex = selectedIndex;
            swatchPanelStyleName = getStyle("swatchPanelStyleName");
            if(Boolean(swatchPanelStyleName))
            {
               dropdownSwatch.styleName = swatchPanelStyleName;
            }
            else if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
            {
               dropdownSwatch.styleName = this;
            }
            dropdownSwatch.addEventListener(ColorPickerEvent.ITEM_ROLL_OVER,dropdownSwatch_itemRollOverHandler);
            dropdownSwatch.addEventListener(ColorPickerEvent.ITEM_ROLL_OUT,dropdownSwatch_itemRollOutHandler);
            dropdownSwatch.cacheAsBitmap = true;
            dropdownSwatch.scrollRect = new Rectangle(0,0,0,0);
         }
         dropdownSwatch.scaleX = scaleX;
         dropdownSwatch.scaleY = scaleY;
         return dropdownSwatch;
      }
      
      [Inspectable(category="General",defaultValue="0",format="Color")]
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get selectedColor() : uint
      {
         return _selectedColor;
      }
      
      public function set selectedColor(value:uint) : void
      {
         if(!indexFlag)
         {
            super.selectedIndex = findColorByName(value);
         }
         else
         {
            indexFlag = false;
         }
         if(value != selectedColor)
         {
            _selectedColor = value;
            updateColor(value);
            if(Boolean(dropdownSwatch))
            {
               dropdownSwatch.selectedColor = value;
            }
         }
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      mx_internal function get dropdown() : SwatchPanel
      {
         return dropdownSwatch;
      }
      
      override protected function downArrowButton_buttonDownHandler(event:FlexEvent) : void
      {
         displayDropdown(!showingDropdown,event);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!swatchPreview)
         {
            swatchPreview = new SwatchSkin();
            swatchPreview.styleName = new StyleProxy(this,swatchStyleFilters);
            swatchPreview.color = selectedColor;
            swatchPreview.name = "colorPickerSwatch";
            if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
            {
               swatchPreview.setStyle("swatchBorderSize",0);
            }
            addChild(swatchPreview);
         }
         setChildIndex(swatchPreview,getChildIndex(downArrowButton));
         textInput.visible = false;
         if(!enabled)
         {
            super.enabled = enabled;
         }
         initializing = false;
      }
      
      override protected function initializeAccessibility() : void
      {
         if(ColorPicker.createAccessibilityImplementation != null)
         {
            ColorPicker.createAccessibilityImplementation(this);
         }
      }
      
      public function set showTextField(value:Boolean) : void
      {
         _showTextField = value;
         if(Boolean(dropdownSwatch))
         {
            dropdownSwatch.showTextField = value;
         }
      }
      
      private function updateColor(color:Number) : void
      {
         if(initializing || isNaN(color))
         {
            return;
         }
         swatchPreview.updateSkin(color);
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
               selectedColor = Number(value[colorField]);
            }
            else if(typeof value == "number")
            {
               selectedColor = Number(value);
            }
            indexFlag = true;
            if(Boolean(dropdownSwatch))
            {
               dropdownSwatch.selectedItem = value;
            }
         }
      }
      
      private function dropdownSwatch_mouseDownOutsideHandler(event:Event) : void
      {
         var mouseEvent:MouseEvent = null;
         if(event is MouseEvent)
         {
            mouseEvent = MouseEvent(event);
            if(!hitTestPoint(mouseEvent.stageX,mouseEvent.stageY,true))
            {
               close(event);
            }
         }
         else if(event is SandboxMouseEvent)
         {
            close(event);
         }
      }
      
      public function set colorField(value:String) : void
      {
         _colorField = value;
         if(Boolean(dropdownSwatch))
         {
            dropdownSwatch.colorField = value;
         }
         dispatchEvent(new Event("colorFieldChanged"));
      }
      
      private function getColor(location:int) : Number
      {
         if(!dataProvider || dataProvider.length < 1 || location < 0 || location >= dataProvider.length)
         {
            return -1;
         }
         return Number(typeof dataProvider.getItemAt(location) == "object" ? dataProvider.getItemAt(location)[colorField] : dataProvider.getItemAt(location));
      }
      
      private function dropdownSwatch_itemRollOutHandler(event:ColorPickerEvent) : void
      {
         dispatchEvent(event);
      }
      
      mx_internal function onTweenUpdate(value:Number) : void
      {
         dropdownSwatch.scrollRect = new Rectangle(0,value,dropdownSwatch.width,dropdownSwatch.height);
      }
      
      override public function set editable(value:Boolean) : void
      {
         _editable = value;
         if(Boolean(dropdownSwatch))
         {
            dropdownSwatch.editable = value;
         }
         dispatchEvent(new Event("editableChanged"));
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(collectionChanged)
         {
            if(findColorByName(selectedColor) == -1)
            {
               if(dataProvider.length > 0 && selectedIndex > dataProvider.length)
               {
                  selectedIndex = 0;
               }
               if(getColor(selectedIndex) >= 0)
               {
                  selectedColor = getColor(selectedIndex);
                  swatchPreview.color = selectedColor;
               }
               else if(Boolean(dropdownSwatch))
               {
                  swatchPreview.color = dropdownSwatch.selectedColor;
               }
            }
            else
            {
               selectedIndex = findColorByName(selectedColor);
            }
            collectionChanged = false;
         }
      }
      
      public function set labelField(value:String) : void
      {
         _labelField = value;
         if(Boolean(dropdownSwatch))
         {
            dropdownSwatch.labelField = value;
         }
         dispatchEvent(new Event("labelFieldChanged"));
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get showTextField() : Boolean
      {
         return _showTextField;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var swatchPanelStyleName:Object = null;
         if(Boolean(dropdownSwatch))
         {
            if(FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0)
            {
               if(styleProp == "swatchPanelStyleName")
               {
                  swatchPanelStyleName = getStyle("swatchPanelStyleName");
                  if(Boolean(swatchPanelStyleName))
                  {
                     dropdownSwatch.styleName = swatchPanelStyleName;
                  }
               }
            }
            dropdownSwatch.styleChanged(styleProp);
         }
         super.styleChanged(styleProp);
         invalidateDisplayList();
      }
      
      private function findColorByName(name:Number) : int
      {
         if(name == getColor(selectedIndex))
         {
            return selectedIndex;
         }
         var n:int = int(dataProvider.length);
         for(var i:int = 0; i < dataProvider.length; i++)
         {
            if(name == getColor(i))
            {
               return i;
            }
         }
         return -1;
      }
      
      [Inspectable(category="Data",defaultValue="color")]
      [Bindable("colorFieldChanged")]
      public function get colorField() : String
      {
         return _colorField;
      }
      
      public function open() : void
      {
         displayDropdown(true);
      }
      
      override public function get editable() : Boolean
      {
         return _editable;
      }
      
      override protected function measure() : void
      {
         measuredMinWidth = measuredWidth = DEFAULT_MEASURED_MIN_HEIGHT;
         measuredMinHeight = measuredHeight = DEFAULT_MEASURED_MIN_HEIGHT;
      }
      
      [Inspectable(category="Data",defaultValue="label")]
      [Bindable("labelFieldChanged")]
      public function get labelField() : String
      {
         return _labelField;
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         var cpEvent:ColorPickerEvent = null;
         if(event.ctrlKey && event.keyCode == Keyboard.DOWN)
         {
            displayDropdown(true,event);
         }
         else if(event.ctrlKey && event.keyCode == Keyboard.UP || event.keyCode == Keyboard.ESCAPE)
         {
            if(Boolean(dropdownSwatch) && dropdownSwatch.enabled)
            {
               close(event);
            }
         }
         else if(showingDropdown && event.keyCode == Keyboard.ENTER && dropdownSwatch.enabled)
         {
            if(!dropdownSwatch.isOverGrid && editable)
            {
               if(selectedColor != dropdownSwatch.selectedColor)
               {
                  selectedColor = dropdownSwatch.selectedColor;
                  cpEvent = new ColorPickerEvent(ColorPickerEvent.CHANGE);
                  cpEvent.index = selectedIndex;
                  cpEvent.color = selectedColor;
                  dispatchEvent(cpEvent);
                  cpEvent = new ColorPickerEvent(ColorPickerEvent.ENTER);
                  cpEvent.color = selectedColor;
                  dispatchEvent(cpEvent);
               }
            }
            else if(selectedIndex != dropdownSwatch.focusedIndex)
            {
               dropdownSwatch.selectedIndex = dropdownSwatch.focusedIndex;
               selectedIndex = dropdownSwatch.selectedIndex;
               cpEvent = new ColorPickerEvent(ColorPickerEvent.CHANGE);
               cpEvent.index = selectedIndex;
               cpEvent.color = selectedColor;
               dispatchEvent(cpEvent);
            }
            close();
            event.stopPropagation();
         }
         else if(showingDropdown && (event.keyCode == Keyboard.HOME || event.keyCode == Keyboard.END || event.keyCode == Keyboard.PAGE_UP || event.keyCode == Keyboard.PAGE_DOWN || event.keyCode == Keyboard.LEFT || event.keyCode == Keyboard.RIGHT || event.keyCode == Keyboard.UP || event.keyCode == Keyboard.DOWN))
         {
            dropdownSwatch.dispatchEvent(event);
         }
         else if(event.keyCode == Keyboard.LEFT)
         {
            if(selectedIndex == -1)
            {
               selectedIndex = findColorByName(selectedColor);
            }
            if(selectedIndex - 1 >= 0)
            {
               --selectedIndex;
               cpEvent = new ColorPickerEvent(ColorPickerEvent.CHANGE);
               cpEvent.index = selectedIndex;
               cpEvent.color = selectedColor;
               dispatchEvent(cpEvent);
            }
         }
         else if(event.keyCode == Keyboard.RIGHT)
         {
            if(selectedIndex == -1)
            {
               selectedIndex = findColorByName(selectedColor);
            }
            if(selectedIndex + 1 < dataProvider.length)
            {
               ++selectedIndex;
               cpEvent = new ColorPickerEvent(ColorPickerEvent.CHANGE);
               cpEvent.index = selectedIndex;
               cpEvent.color = selectedColor;
               dispatchEvent(cpEvent);
            }
         }
      }
      
      protected function get swatchStyleFilters() : Object
      {
         return _swatchStyleFilters;
      }
      
      [Inspectable(defaultValue="0")]
      [Bindable("collectionChange")]
      [Bindable("change")]
      override public function set selectedIndex(value:int) : void
      {
         if((selectedIndex != -1 || !isNaN(selectedColor)) && value != selectedIndex)
         {
            if(value >= 0)
            {
               indexFlag = true;
               selectedColor = getColor(value);
               super.selectedIndex = value;
            }
            if(Boolean(dropdownSwatch))
            {
               dropdownSwatch.selectedIndex = value;
            }
         }
      }
      
      mx_internal function onTweenEnd(value:Number) : void
      {
         if(showingDropdown)
         {
            dropdownSwatch.scrollRect = null;
         }
         else
         {
            onTweenUpdate(value);
            dropdownSwatch.visible = false;
            isOpening = false;
         }
         UIComponent.resumeBackgroundProcessing();
         if(showingDropdown && showTextField)
         {
            dropdownSwatch.setFocus();
         }
         else
         {
            setFocus();
         }
         dropdownSwatch.enabled = true;
         dispatchEvent(new DropdownEvent(showingDropdown ? DropdownEvent.OPEN : DropdownEvent.CLOSE,false,false,triggerEvent));
      }
      
      override protected function focusInHandler(event:FocusEvent) : void
      {
         var fm:IFocusManager = focusManager;
         if(Boolean(fm))
         {
            fm.showFocusIndicator = true;
         }
         if(isDown && !isOpening)
         {
            close();
         }
         else if(isOpening)
         {
            isOpening = false;
         }
         super.focusInHandler(event);
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         swatchPreview.color = selectedColor;
         swatchPreview.setActualSize(unscaledWidth,unscaledHeight);
         downArrowButton.move(0,0);
         downArrowButton.setActualSize(unscaledWidth,unscaledHeight);
         if(Boolean(dropdownSwatch))
         {
            dropdownSwatch.setActualSize(dropdownSwatch.getExplicitOrMeasuredWidth(),dropdownSwatch.getExplicitOrMeasuredHeight());
         }
      }
      
      public function close(trigger:Event = null) : void
      {
         displayDropdown(false,trigger);
      }
      
      mx_internal function displayDropdown(show:Boolean, trigger:Event = null) : void
      {
         var initY:Number = NaN;
         var endY:Number = NaN;
         var easingFunction:Function = null;
         var duration:Number = NaN;
         var sm:ISystemManager = null;
         var sbRoot:DisplayObject = null;
         var screen:Rectangle = null;
         var request:InterManagerRequest = null;
         if(show == showingDropdown)
         {
            return;
         }
         var point:Point = new Point(0,0);
         point = localToGlobal(point);
         var tween:Tween = null;
         triggerEvent = trigger;
         if(show)
         {
            getDropdown();
            if(dropdownSwatch.parent == null)
            {
               PopUpManager.addPopUp(dropdownSwatch,parent,false);
            }
            else
            {
               PopUpManager.bringToFront(dropdownSwatch);
            }
            dropdownSwatch.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE,dropdownSwatch_mouseDownOutsideHandler);
            dropdownSwatch.addEventListener(FlexMouseEvent.MOUSE_WHEEL_OUTSIDE,dropdownSwatch_mouseDownOutsideHandler);
            dropdownSwatch.addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,dropdownSwatch_mouseDownOutsideHandler);
            dropdownSwatch.addEventListener(SandboxMouseEvent.MOUSE_WHEEL_SOMEWHERE,dropdownSwatch_mouseDownOutsideHandler);
            dropdownSwatch.isOpening = true;
            dropdownSwatch.showTextField = showTextField;
            dropdownSwatch.selectedColor = selectedColor;
            dropdownSwatch.owner = this;
            sm = systemManager.topLevelSystemManager;
            sbRoot = sm.getSandboxRoot();
            if(sm != sbRoot)
            {
               request = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST,false,false,"getVisibleApplicationRect");
               sbRoot.dispatchEvent(request);
               screen = Rectangle(request.value);
            }
            else
            {
               screen = sm.getVisibleApplicationRect();
            }
            if(point.y + height + dropdownGap + dropdownSwatch.height > screen.bottom && point.y > screen.top + dropdownGap + dropdownSwatch.height)
            {
               point.y -= dropdownGap + dropdownSwatch.height;
               initY = -dropdownSwatch.height / scaleY;
               dropdownSwatch.tweenUp = true;
            }
            else
            {
               point.y += dropdownGap + height;
               initY = dropdownSwatch.height / scaleY;
               dropdownSwatch.tweenUp = false;
            }
            if(point.x + dropdownSwatch.width > screen.right && point.x > screen.left + dropdownSwatch.width)
            {
               point.x -= dropdownSwatch.width - width;
            }
            point = dropdownSwatch.parent.globalToLocal(point);
            dropdownSwatch.move(point.x,point.y);
            isDown = true;
            isOpening = true;
            endY = 0;
            duration = getStyle("openDuration");
            easingFunction = getStyle("openEasingFunction") as Function;
            showingDropdown = show;
         }
         else
         {
            initY = 0;
            endY = dropdownSwatch.tweenUp ? -dropdownSwatch.height / scaleY : dropdownSwatch.height / scaleY;
            isDown = false;
            duration = getStyle("closeDuration");
            easingFunction = getStyle("closeEasingFunction") as Function;
            showingDropdown = show;
            dropdownSwatch.removeEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE,dropdownSwatch_mouseDownOutsideHandler);
            dropdownSwatch.removeEventListener(FlexMouseEvent.MOUSE_WHEEL_OUTSIDE,dropdownSwatch_mouseDownOutsideHandler);
            dropdownSwatch.removeEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,dropdownSwatch_mouseDownOutsideHandler);
            dropdownSwatch.removeEventListener(SandboxMouseEvent.MOUSE_WHEEL_SOMEWHERE,dropdownSwatch_mouseDownOutsideHandler);
            PopUpManager.removePopUp(dropdownSwatch);
         }
         if(Boolean(dropdownSwatch))
         {
            dropdownSwatch.visible = true;
            dropdownSwatch.enabled = false;
         }
         UIComponentGlobals.layoutManager.validateNow();
         UIComponent.suspendBackgroundProcessing();
         tween = new Tween(this,initY,endY,duration);
         if(easingFunction != null)
         {
            tween.easingFunction = easingFunction;
         }
      }
      
      override protected function collectionChangeHandler(event:Event) : void
      {
         if(!initializing)
         {
            if(dataProvider.length > 0)
            {
               invalidateProperties();
            }
            else
            {
               selectedColor = 0;
               selectedIndex = -1;
            }
            collectionChanged = true;
         }
         if(Boolean(dropdownSwatch))
         {
            dropdownSwatch.dataProvider = dataProvider;
         }
      }
      
      [Inspectable(category="Data")]
      [Bindable("collectionChange")]
      override public function set dataProvider(value:Object) : void
      {
         super.dataProvider = value;
         isModelInited = true;
         if(Boolean(dropdownSwatch))
         {
            dropdownSwatch.dataProvider = value;
         }
      }
   }
}

