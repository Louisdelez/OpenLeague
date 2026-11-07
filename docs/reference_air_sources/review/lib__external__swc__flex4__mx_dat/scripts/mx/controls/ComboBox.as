package mx.controls
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextLineMetrics;
   import flash.ui.Keyboard;
   import mx.collections.ArrayCollection;
   import mx.collections.CursorBookmark;
   import mx.controls.dataGridClasses.DataGridListData;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.controls.listClasses.ListBase;
   import mx.controls.listClasses.ListData;
   import mx.core.ClassFactory;
   import mx.core.EdgeMetrics;
   import mx.core.IDataRenderer;
   import mx.core.IFactory;
   import mx.core.LayoutDirection;
   import mx.core.ScrollPolicy;
   import mx.core.UIComponent;
   import mx.core.UIComponentGlobals;
   import mx.effects.Tween;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.DropdownEvent;
   import mx.events.FlexEvent;
   import mx.events.FlexMouseEvent;
   import mx.events.ListEvent;
   import mx.events.SandboxMouseEvent;
   import mx.events.ScrollEvent;
   import mx.events.ScrollEventDetail;
   import mx.managers.ISystemManager;
   import mx.managers.PopUpManager;
   import mx.utils.MatrixUtil;
   
   [Alternative(replacement="spark.components.ComboBox",since="4.0")]
   [Alternative(replacement="spark.components.DropDownList",since="4.0")]
   [IconFile("ComboBox.png")]
   [DefaultTriggerEvent("change")]
   [DefaultProperty("dataProvider")]
   [DefaultBindingProperty(source="selectedItem",destination="dataProvider")]
   [DataBindingInfo("{ dataProvider: { label: &quot;String&quot; } }")]
   [AccessibilityClass(implementation="mx.accessibility.ComboBoxAccImpl")]
   [Style(name="textSelectedColor",type="uint",format="Color",inherit="yes")]
   [Style(name="textRollOverColor",type="uint",format="Color",inherit="yes")]
   [Style(name="selectionEasingFunction",type="Function",inherit="no")]
   [Style(name="selectionDuration",type="uint",format="Time",inherit="no")]
   [Style(name="selectionColor",type="uint",format="Color",inherit="yes")]
   [Style(name="rollOverColor",type="uint",format="Color",inherit="yes")]
   [Style(name="paddingTop",type="Number",format="Length",inherit="no")]
   [Style(name="paddingBottom",type="Number",format="Length",inherit="no")]
   [Style(name="openEasingFunction",type="Function",inherit="no")]
   [Style(name="openDuration",type="Number",format="Time",inherit="no")]
   [Style(name="dropdownStyleName",type="String",inherit="no")]
   [Style(name="dropDownStyleName",type="String",inherit="no",deprecatedReplacement="dropdownStyleName")]
   [Style(name="dropdownBorderColor",type="uint",format="Color",inherit="yes",theme="halo")]
   [Style(name="closeEasingFunction",type="Function",inherit="no")]
   [Style(name="closeDuration",type="Number",format="Time",inherit="no")]
   [Style(name="borderThickness",type="Number",format="Length",inherit="no")]
   [Style(name="arrowButtonWidth",type="Number",format="Length",inherit="no")]
   [Style(name="alternatingItemColors",type="Array",arrayType="uint",format="Color",inherit="yes")]
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
   [Style(name="highlightAlphas",type="Array",arrayType="Number",inherit="no",theme="halo")]
   [Style(name="fillColors",type="Array",arrayType="uint",format="Color",inherit="no",theme="halo")]
   [Style(name="fillAlphas",type="Array",arrayType="Number",inherit="no",theme="halo")]
   [Style(name="cornerRadius",type="Number",format="Length",inherit="no",theme="halo, spark")]
   [Style(name="borderColor",type="uint",format="Color",inherit="no",theme="halo")]
   [Style(name="paddingRight",type="Number",format="Length",inherit="no")]
   [Style(name="paddingLeft",type="Number",format="Length",inherit="no")]
   [Style(name="leading",type="Number",format="Length",inherit="yes")]
   [Style(name="disabledIconColor",type="uint",format="Color",inherit="yes",theme="halo")]
   [Style(name="iconColor",type="uint",format="Color",inherit="yes",theme="halo")]
   [Style(name="focusRoundedCorners",type="String",inherit="no")]
   [Style(name="focusAlpha",type="Number",inherit="no")]
   [Event(name="scroll",type="mx.events.ScrollEvent")]
   [Event(name="open",type="mx.events.DropdownEvent")]
   [Event(name="itemRollOver",type="mx.events.ListEvent")]
   [Event(name="itemRollOut",type="mx.events.ListEvent")]
   [Event(name="enter",type="mx.events.FlexEvent")]
   [Event(name="dataChange",type="mx.events.FlexEvent")]
   [Event(name="close",type="mx.events.DropdownEvent")]
   [Event(name="change",type="mx.events.ListEvent")]
   public class ComboBox extends ComboBase implements IDataRenderer, IDropInListItemRenderer, IListItemRenderer
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var _dropdown:ListBase;
      
      private var _oldIndex:int;
      
      private var tween:Tween = null;
      
      private var tweenUp:Boolean = false;
      
      private var preferredDropdownWidth:Number;
      
      private var dropdownBorderStyle:String = "solid";
      
      private var _showingDropdown:Boolean = false;
      
      private var _selectedIndexOnDropdown:int = -1;
      
      private var bRemoveDropdown:Boolean = true;
      
      private var inTween:Boolean = false;
      
      private var bInKeyDown:Boolean = false;
      
      private var selectedItemSet:Boolean;
      
      private var triggerEvent:Event;
      
      private var explicitText:Boolean;
      
      private var _data:Object;
      
      private var _listData:BaseListData;
      
      private var collectionChanged:Boolean = false;
      
      private var _itemRenderer:IFactory;
      
      private var _dropdownFactory:IFactory = new ClassFactory(List);
      
      private var _dropdownWidth:Number = 100;
      
      private var _labelField:String = "label";
      
      private var labelFieldChanged:Boolean;
      
      private var _labelFunction:Function;
      
      private var labelFunctionChanged:Boolean;
      
      private var promptChanged:Boolean = false;
      
      private var _prompt:String;
      
      private var _rowCount:int = 5;
      
      private var implicitSelectedIndex:Boolean = false;
      
      public function ComboBox()
      {
         super();
         this.dataProvider = new ArrayCollection();
         useFullDropdownSkin = true;
         wrapDownArrowButton = false;
         addEventListener("unload",this.unloadHandler);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStageHandler);
      }
      
      [Inspectable(environment="none")]
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(value:Object) : void
      {
         var newSelectedItem:* = undefined;
         this._data = value;
         if(Boolean(this._listData) && this._listData is DataGridListData)
         {
            newSelectedItem = this._data[DataGridListData(this._listData).dataField];
         }
         else if(this._listData is ListData && ListData(this._listData).labelField in this._data)
         {
            newSelectedItem = this._data[ListData(this._listData).labelField];
         }
         else
         {
            newSelectedItem = this._data;
         }
         if(newSelectedItem !== undefined && !this.selectedItemSet)
         {
            this.selectedItem = newSelectedItem;
            this.selectedItemSet = false;
         }
         dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
      }
      
      [Inspectable(environment="none")]
      [Bindable("dataChange")]
      public function get listData() : BaseListData
      {
         return this._listData;
      }
      
      public function set listData(value:BaseListData) : void
      {
         this._listData = value;
      }
      
      [Inspectable(category="Data",arrayType="Object")]
      [Bindable("collectionChange")]
      override public function set dataProvider(value:Object) : void
      {
         selectionChanged = true;
         super.dataProvider = value;
         this.destroyDropdown();
         invalidateProperties();
         invalidateSize();
      }
      
      [Inspectable(category="Data")]
      public function get itemRenderer() : IFactory
      {
         return this._itemRenderer;
      }
      
      public function set itemRenderer(value:IFactory) : void
      {
         this._itemRenderer = value;
         if(Boolean(this._dropdown))
         {
            this._dropdown.itemRenderer = value;
         }
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new Event("itemRendererChanged"));
      }
      
      [Inspectable(category="General",defaultValue="0")]
      [Bindable("valueCommit")]
      [Bindable("collectionChange")]
      [Bindable("change")]
      override public function set selectedIndex(value:int) : void
      {
         super.selectedIndex = value;
         if(value >= 0)
         {
            selectionChanged = true;
         }
         this.implicitSelectedIndex = false;
         invalidateDisplayList();
         if(Boolean(textInput) && Boolean(!textChanged) && value >= 0)
         {
            textInput.text = this.selectedLabel;
         }
         else if(Boolean(textInput) && Boolean(this.prompt))
         {
            textInput.text = this.prompt;
         }
      }
      
      [Bindable("valueCommit")]
      [Bindable("collectionChange")]
      [Bindable("change")]
      override public function set selectedItem(value:Object) : void
      {
         this.selectedItemSet = true;
         this.implicitSelectedIndex = false;
         super.selectedItem = value;
      }
      
      override public function set showInAutomationHierarchy(value:Boolean) : void
      {
      }
      
      public function get dropdown() : ListBase
      {
         return this.getDropdown();
      }
      
      [Bindable("dropdownFactoryChanged")]
      public function get dropdownFactory() : IFactory
      {
         return this._dropdownFactory;
      }
      
      public function set dropdownFactory(value:IFactory) : void
      {
         this._dropdownFactory = value;
         dispatchEvent(new Event("dropdownFactoryChanged"));
      }
      
      protected function get dropDownStyleFilters() : Object
      {
         return null;
      }
      
      [Inspectable(category="Size",defaultValue="100")]
      [Bindable("dropdownWidthChanged")]
      public function get dropdownWidth() : Number
      {
         return this._dropdownWidth;
      }
      
      public function set dropdownWidth(value:Number) : void
      {
         this._dropdownWidth = value;
         this.preferredDropdownWidth = value;
         if(Boolean(this._dropdown))
         {
            this._dropdown.setActualSize(value,this._dropdown.height);
         }
         dispatchEvent(new Event("dropdownWidthChanged"));
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
         this.labelFieldChanged = true;
         invalidateDisplayList();
         dispatchEvent(new Event("labelFieldChanged"));
      }
      
      [Inspectable(category="Data")]
      [Bindable("labelFunctionChanged")]
      public function get labelFunction() : Function
      {
         return this._labelFunction;
      }
      
      public function set labelFunction(value:Function) : void
      {
         this._labelFunction = value;
         this.labelFunctionChanged = true;
         invalidateDisplayList();
         dispatchEvent(new Event("labelFunctionChanged"));
      }
      
      [Inspectable(category="General")]
      public function get prompt() : String
      {
         return this._prompt;
      }
      
      public function set prompt(value:String) : void
      {
         this._prompt = value;
         this.promptChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(category="General",defaultValue="5")]
      [Bindable("resize")]
      public function get rowCount() : int
      {
         return Math.max(1,Math.min(collection.length,this._rowCount));
      }
      
      public function set rowCount(value:int) : void
      {
         this._rowCount = value;
         if(Boolean(this._dropdown))
         {
            this._dropdown.rowCount = value;
         }
      }
      
      public function get selectedLabel() : String
      {
         var item:Object = selectedItem;
         return this.itemToLabel(item);
      }
      
      override protected function initializeAccessibility() : void
      {
         if(ComboBox.createAccessibilityImplementation != null)
         {
            ComboBox.createAccessibilityImplementation(this);
         }
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         this.destroyDropdown();
         super.styleChanged(styleProp);
      }
      
      override protected function measure() : void
      {
         super.measure();
         measuredMinWidth = Math.max(measuredWidth,DEFAULT_MEASURED_MIN_WIDTH);
         var textHeight:Number = measureText("M").height + 6;
         var bm:EdgeMetrics = borderMetrics;
         measuredMinHeight = measuredHeight = Math.max(textHeight + bm.top + bm.bottom,DEFAULT_MEASURED_MIN_HEIGHT);
         measuredMinHeight = measuredHeight = measuredHeight + (getStyle("paddingTop") + getStyle("paddingBottom"));
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(Boolean(this._dropdown) && !this.inTween)
         {
            if(!this._showingDropdown)
            {
               this.destroyDropdown();
            }
         }
         else if(this._showingDropdown)
         {
            this.bRemoveDropdown = false;
         }
         var ddw:Number = this.preferredDropdownWidth;
         if(isNaN(ddw))
         {
            ddw = this._dropdownWidth = unscaledWidth;
         }
         if(this.labelFieldChanged)
         {
            if(Boolean(this._dropdown))
            {
               this._dropdown.labelField = this._labelField;
            }
            selectionChanged = true;
            if(!this.explicitText)
            {
               textInput.text = this.selectedLabel;
            }
            this.labelFieldChanged = false;
         }
         if(this.labelFunctionChanged)
         {
            selectionChanged = true;
            if(!this.explicitText)
            {
               textInput.text = this.selectedLabel;
            }
            this.labelFunctionChanged = false;
         }
         if(selectionChanged)
         {
            if(!textChanged)
            {
               if(selectedIndex == -1 && Boolean(this.prompt))
               {
                  textInput.text = this.prompt;
               }
               else if(!this.explicitText)
               {
                  textInput.text = this.selectedLabel;
               }
            }
            textInput.invalidateDisplayList();
            textInput.validateNow();
            if(editable)
            {
               textInput.selectRange(0,textInput.text.length);
               textInput.horizontalScrollPosition = 0;
            }
            if(Boolean(this._dropdown))
            {
               this._dropdown.selectedIndex = selectedIndex;
            }
            selectionChanged = false;
         }
         if(Boolean(this._dropdown) && this._dropdown.rowCount != this.rowCount)
         {
            this._dropdown.rowCount = this.rowCount;
         }
      }
      
      override protected function commitProperties() : void
      {
         this.explicitText = textChanged;
         super.commitProperties();
         if(this.collectionChanged)
         {
            if(selectedIndex == -1 && this.implicitSelectedIndex && this._prompt == null)
            {
               this.selectedIndex = 0;
            }
            selectedIndexChanged = true;
            this.collectionChanged = false;
         }
         if(this.promptChanged && this.prompt != null && selectedIndex == -1)
         {
            this.promptChanged = false;
            textInput.text = this.prompt;
         }
      }
      
      public function itemToLabel(item:Object, ... rest) : String
      {
         if(item == null)
         {
            return "";
         }
         if(this.labelFunction != null)
         {
            return this.labelFunction(item);
         }
         if(typeof item == "object")
         {
            try
            {
               if(item[this.labelField] != null)
               {
                  item = item[this.labelField];
               }
            }
            catch(e:Error)
            {
            }
         }
         else if(typeof item == "xml")
         {
            try
            {
               if(item[this.labelField].length() != 0)
               {
                  item = item[this.labelField];
               }
            }
            catch(e:Error)
            {
            }
         }
         if(typeof item == "string")
         {
            return String(item);
         }
         try
         {
            return item.toString();
         }
         catch(e:Error)
         {
         }
         return " ";
      }
      
      public function open() : void
      {
         this.displayDropdown(true);
      }
      
      public function close(trigger:Event = null) : void
      {
         if(this._showingDropdown)
         {
            if(Boolean(this._dropdown) && selectedIndex != this._dropdown.selectedIndex)
            {
               this.selectedIndex = this._dropdown.selectedIndex;
            }
            this.displayDropdown(false,trigger);
            this.dispatchChangeEvent(new Event("dummy"),this._selectedIndexOnDropdown,selectedIndex);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function hasDropdown() : Boolean
      {
         return this._dropdown != null;
      }
      
      private function getDropdown() : ListBase
      {
         var dropDownStyleName:String = null;
         if(!initialized)
         {
            return null;
         }
         if(!this.hasDropdown())
         {
            dropDownStyleName = getStyle("dropDownStyleName");
            if(dropDownStyleName == null)
            {
               dropDownStyleName = getStyle("dropdownStyleName");
            }
            this._dropdown = this.dropdownFactory.newInstance();
            this._dropdown.visible = false;
            this._dropdown.focusEnabled = false;
            this._dropdown.owner = this;
            if(Boolean(this.itemRenderer))
            {
               this._dropdown.itemRenderer = this.itemRenderer;
            }
            if(Boolean(dropDownStyleName))
            {
               this._dropdown.styleName = dropDownStyleName;
            }
            PopUpManager.addPopUp(this._dropdown,this);
            this._dropdown.setStyle("selectionDuration",0);
            if(!dataProvider)
            {
               this.dataProvider = new ArrayCollection();
            }
            this._dropdown.dataProvider = dataProvider;
            this._dropdown.rowCount = this.rowCount;
            this._dropdown.width = this._dropdownWidth;
            this._dropdown.selectedIndex = selectedIndex;
            this._oldIndex = selectedIndex;
            this._dropdown.verticalScrollPolicy = ScrollPolicy.AUTO;
            this._dropdown.labelField = this._labelField;
            this._dropdown.labelFunction = this.itemToLabel;
            this._dropdown.allowDragSelection = true;
            this._dropdown.addEventListener("change",this.dropdown_changeHandler);
            this._dropdown.addEventListener(ScrollEvent.SCROLL,this.dropdown_scrollHandler);
            this._dropdown.addEventListener(ListEvent.ITEM_ROLL_OVER,this.dropdown_itemRollOverHandler);
            this._dropdown.addEventListener(ListEvent.ITEM_ROLL_OUT,this.dropdown_itemRollOutHandler);
            this._dropdown.addEventListener(ListEvent.ITEM_CLICK,this.dropdown_itemClickHandler);
            UIComponentGlobals.layoutManager.validateClient(this._dropdown,true);
            this._dropdown.setActualSize(this._dropdownWidth,this._dropdown.getExplicitOrMeasuredHeight());
            this._dropdown.validateDisplayList();
            this._dropdown.cacheAsBitmap = true;
            systemManager.addEventListener(Event.RESIZE,this.stage_resizeHandler,false,0,true);
         }
         var m:Matrix = MatrixUtil.getConcatenatedMatrix(this,systemManager.getSandboxRoot());
         this._dropdown.scaleX = m.a;
         this._dropdown.scaleY = m.d;
         return this._dropdown;
      }
      
      private function displayDropdown(show:Boolean, trigger:Event = null, playEffect:Boolean = true) : void
      {
         var initY:Number = NaN;
         var endY:Number = NaN;
         var duration:Number = NaN;
         var easingFunction:Function = null;
         var sel:int = 0;
         var pos:Number = NaN;
         if(!initialized || show == this._showingDropdown)
         {
            return;
         }
         if(this.inTween)
         {
            this.tween.endTween();
         }
         var point:Point = new Point(0,unscaledHeight);
         point = localToGlobal(point);
         var sm:ISystemManager = systemManager.topLevelSystemManager;
         var screen:Rectangle = sm.getVisibleApplicationRect(null,true);
         if(show)
         {
            this._selectedIndexOnDropdown = selectedIndex;
            this.getDropdown();
            this._dropdown.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE,this.dropdown_mouseOutsideHandler);
            this._dropdown.addEventListener(FlexMouseEvent.MOUSE_WHEEL_OUTSIDE,this.dropdown_mouseOutsideHandler);
            this._dropdown.addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,this.dropdown_mouseOutsideHandler);
            this._dropdown.addEventListener(SandboxMouseEvent.MOUSE_WHEEL_SOMEWHERE,this.dropdown_mouseOutsideHandler);
            if(this._dropdown.parent == null)
            {
               PopUpManager.addPopUp(this._dropdown,this);
            }
            else
            {
               PopUpManager.bringToFront(this._dropdown);
            }
            if(point.y + this._dropdown.height > screen.bottom && point.y > screen.top + this._dropdown.height)
            {
               point.y -= unscaledHeight + this._dropdown.height;
               initY = -this._dropdown.height;
               this.tweenUp = true;
            }
            else
            {
               initY = Number(this._dropdown.height);
               this.tweenUp = false;
            }
            point = this._dropdown.parent.globalToLocal(point);
            if(layoutDirection == LayoutDirection.RTL)
            {
               point.x -= this._dropdown.width;
            }
            sel = this._dropdown.selectedIndex;
            if(sel == -1)
            {
               sel = 0;
            }
            pos = this._dropdown.verticalScrollPosition;
            pos = sel - 1;
            pos = Math.min(Math.max(pos,0),this._dropdown.maxVerticalScrollPosition);
            this._dropdown.verticalScrollPosition = pos;
            if(this._dropdown.x != point.x || this._dropdown.y != point.y)
            {
               this._dropdown.move(point.x,point.y);
            }
            this._dropdown.scrollRect = new Rectangle(0,initY,this._dropdown.width,this._dropdown.height);
            if(!this._dropdown.visible)
            {
               this._dropdown.visible = true;
            }
            this.bRemoveDropdown = false;
            this._showingDropdown = show;
            duration = Number(getStyle("openDuration"));
            endY = 0;
            easingFunction = getStyle("openEasingFunction") as Function;
         }
         else if(Boolean(this._dropdown))
         {
            endY = point.y + this._dropdown.height > screen.bottom || this.tweenUp ? -this._dropdown.height : Number(this._dropdown.height);
            this._showingDropdown = show;
            initY = 0;
            duration = Number(getStyle("closeDuration"));
            easingFunction = getStyle("closeEasingFunction") as Function;
            this._dropdown.resetDragScrolling();
         }
         this.inTween = true;
         if(playEffect || show)
         {
            UIComponentGlobals.layoutManager.validateNow();
         }
         UIComponent.suspendBackgroundProcessing();
         if(Boolean(this._dropdown))
         {
            this._dropdown.enabled = false;
         }
         duration = Math.max(1,duration);
         if(!playEffect)
         {
            duration = 1;
         }
         this.tween = new Tween(this,initY,endY,duration);
         if(easingFunction != null && Boolean(this.tween))
         {
            this.tween.easingFunction = easingFunction;
         }
         this.triggerEvent = trigger;
      }
      
      private function dispatchChangeEvent(oldEvent:Event, prevValue:int, newValue:int) : void
      {
         var newEvent:Event = null;
         if(prevValue != newValue)
         {
            newEvent = oldEvent is ListEvent ? oldEvent : new ListEvent("change");
            dispatchEvent(newEvent);
         }
      }
      
      private function destroyDropdown() : void
      {
         if(this.inTween)
         {
            this.tween.endTween();
         }
         this.displayDropdown(false,null,false);
      }
      
      override protected function collectionChangeHandler(event:Event) : void
      {
         var ce:CollectionEvent = null;
         var curSelectedIndex:int = selectedIndex;
         super.collectionChangeHandler(event);
         if(event is CollectionEvent)
         {
            ce = CollectionEvent(event);
            if(collection.length == 0)
            {
               if(!selectedIndexChanged && !selectedItemChanged)
               {
                  if(super.selectedIndex != -1)
                  {
                     super.selectedIndex = -1;
                  }
                  this.implicitSelectedIndex = true;
                  invalidateDisplayList();
               }
               if(Boolean(textInput) && !editable)
               {
                  textInput.text = "";
               }
            }
            else if(ce.kind == CollectionEventKind.ADD)
            {
               if(collection.length != ce.items.length)
               {
                  return;
               }
               if(selectedIndex == -1 && this._prompt == null)
               {
                  this.selectedIndex = 0;
               }
            }
            else if(ce.kind == CollectionEventKind.UPDATE)
            {
               if(ce.location == selectedIndex || ce.items[0].source == selectedItem)
               {
                  selectionChanged = true;
               }
            }
            else
            {
               if(ce.kind == CollectionEventKind.REPLACE)
               {
                  return;
               }
               if(ce.kind == CollectionEventKind.RESET)
               {
                  this.collectionChanged = true;
                  if(!selectedIndexChanged && !selectedItemChanged)
                  {
                     this.selectedIndex = Boolean(this.prompt) ? -1 : 0;
                  }
                  invalidateProperties();
               }
            }
            invalidateDisplayList();
            this.destroyDropdown();
         }
      }
      
      override protected function textInput_changeHandler(event:Event) : void
      {
         super.textInput_changeHandler(event);
         this.dispatchChangeEvent(event,-1,-2);
      }
      
      override protected function downArrowButton_buttonDownHandler(event:FlexEvent) : void
      {
         if(this._showingDropdown)
         {
            this.close(event);
         }
         else
         {
            this.displayDropdown(true,event);
         }
      }
      
      private function dropdown_mouseOutsideHandler(event:Event) : void
      {
         var mouseEvent:MouseEvent = null;
         if(event is MouseEvent)
         {
            mouseEvent = MouseEvent(event);
            if(mouseEvent.target != this._dropdown)
            {
               return;
            }
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
      
      private function dropdown_itemClickHandler(event:ListEvent) : void
      {
         if(this._showingDropdown)
         {
            this.close();
         }
      }
      
      override protected function focusOutHandler(event:FocusEvent) : void
      {
         if(Boolean(this._showingDropdown) && Boolean(this._dropdown) && Boolean(this.contains(DisplayObject(event.target))))
         {
            if(!event.relatedObject || !this._dropdown.contains(event.relatedObject))
            {
               this.close();
            }
         }
         super.focusOutHandler(event);
      }
      
      private function stage_resizeHandler(event:Event) : void
      {
         this.destroyDropdown();
      }
      
      private function dropdown_scrollHandler(event:Event) : void
      {
         var se:ScrollEvent = null;
         if(event is ScrollEvent)
         {
            se = ScrollEvent(event);
            if(se.detail == ScrollEventDetail.THUMB_TRACK || se.detail == ScrollEventDetail.THUMB_POSITION || se.detail == ScrollEventDetail.LINE_UP || se.detail == ScrollEventDetail.LINE_DOWN)
            {
               dispatchEvent(se);
            }
         }
      }
      
      private function dropdown_itemRollOverHandler(event:Event) : void
      {
         dispatchEvent(event);
      }
      
      private function dropdown_itemRollOutHandler(event:Event) : void
      {
         dispatchEvent(event);
      }
      
      private function dropdown_changeHandler(event:Event) : void
      {
         var prevValue:int = selectedIndex;
         if(Boolean(this._dropdown))
         {
            this.selectedIndex = this._dropdown.selectedIndex;
         }
         if(!this._showingDropdown)
         {
            this.dispatchChangeEvent(event,prevValue,selectedIndex);
         }
         else if(!this.bInKeyDown)
         {
            this.close();
         }
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         var oldIndex:int = 0;
         if(!enabled)
         {
            return;
         }
         if(event.target == textInput)
         {
            return;
         }
         if(event.ctrlKey && event.keyCode == Keyboard.DOWN)
         {
            this.displayDropdown(true,event);
            event.stopPropagation();
         }
         else if(event.ctrlKey && event.keyCode == Keyboard.UP)
         {
            this.close(event);
            event.stopPropagation();
         }
         else if(event.keyCode == Keyboard.ESCAPE)
         {
            if(this._showingDropdown)
            {
               if(this._oldIndex != this._dropdown.selectedIndex)
               {
                  this.selectedIndex = this._oldIndex;
               }
               this.displayDropdown(false);
               event.stopPropagation();
            }
         }
         else if(event.keyCode == Keyboard.ENTER)
         {
            if(this._showingDropdown)
            {
               this.close();
               event.stopPropagation();
            }
         }
         else if(!editable || event.keyCode == Keyboard.UP || event.keyCode == Keyboard.DOWN || event.keyCode == Keyboard.PAGE_UP || event.keyCode == Keyboard.PAGE_DOWN)
         {
            oldIndex = selectedIndex;
            this.bInKeyDown = this._showingDropdown;
            this.dropdown.dispatchEvent(event.clone());
            event.stopPropagation();
            this.bInKeyDown = false;
         }
      }
      
      private function unloadHandler(event:Event) : void
      {
         if(this.inTween)
         {
            UIComponent.resumeBackgroundProcessing();
            this.inTween = false;
         }
         if(Boolean(this._dropdown))
         {
            this._dropdown.parent.removeChild(this._dropdown);
         }
      }
      
      private function removedFromStageHandler(event:Event) : void
      {
         this.destroyDropdown();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function onTweenUpdate(value:Number) : void
      {
         if(Boolean(this._dropdown))
         {
            this._dropdown.scrollRect = new Rectangle(0,value,this._dropdown.width,this._dropdown.height);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function onTweenEnd(value:Number) : void
      {
         if(Boolean(this._dropdown))
         {
            this._dropdown.scrollRect = null;
            this.inTween = false;
            this._dropdown.enabled = true;
            this._dropdown.visible = this._showingDropdown;
            if(this.bRemoveDropdown)
            {
               this._dropdown.removeEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE,this.dropdown_mouseOutsideHandler);
               this._dropdown.removeEventListener(FlexMouseEvent.MOUSE_WHEEL_OUTSIDE,this.dropdown_mouseOutsideHandler);
               this._dropdown.removeEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,this.dropdown_mouseOutsideHandler);
               this._dropdown.removeEventListener(SandboxMouseEvent.MOUSE_WHEEL_SOMEWHERE,this.dropdown_mouseOutsideHandler);
               PopUpManager.removePopUp(this._dropdown);
               this._dropdown = null;
            }
         }
         this.bRemoveDropdown = true;
         UIComponent.resumeBackgroundProcessing();
         var cbdEvent:DropdownEvent = new DropdownEvent(this._showingDropdown ? DropdownEvent.OPEN : DropdownEvent.CLOSE);
         cbdEvent.triggerEvent = this.triggerEvent;
         dispatchEvent(cbdEvent);
      }
      
      override protected function calculatePreferredSizeFromData(count:int) : Object
      {
         var lineMetrics:TextLineMetrics = null;
         var data:Object = null;
         var txt:String = null;
         var maxW:Number = 0;
         var maxH:Number = 0;
         var bookmark:CursorBookmark = Boolean(iterator) ? iterator.bookmark : null;
         iterator.seek(CursorBookmark.FIRST,0);
         var more:Boolean = iterator != null;
         for(var i:int = 0; i < count; i++)
         {
            if(more)
            {
               data = Boolean(iterator) ? iterator.current : null;
            }
            else
            {
               data = null;
            }
            txt = this.itemToLabel(data);
            lineMetrics = measureText(txt);
            maxW = Math.max(maxW,lineMetrics.width);
            maxH = Math.max(maxH,lineMetrics.height);
            if(Boolean(iterator))
            {
               iterator.moveNext();
            }
         }
         if(Boolean(this.prompt))
         {
            lineMetrics = measureText(this.prompt);
            maxW = Math.max(maxW,lineMetrics.width);
            maxH = Math.max(maxH,lineMetrics.height);
         }
         maxW += getStyle("paddingLeft") + getStyle("paddingRight");
         if(Boolean(iterator))
         {
            iterator.seek(bookmark,0);
         }
         return {
            "width":maxW,
            "height":maxH
         };
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get isShowingDropdown() : Boolean
      {
         return this._showingDropdown;
      }
   }
}

