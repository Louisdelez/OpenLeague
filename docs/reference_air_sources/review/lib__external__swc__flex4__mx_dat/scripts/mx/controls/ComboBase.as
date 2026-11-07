package mx.controls
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import mx.collections.ArrayCollection;
   import mx.collections.CursorBookmark;
   import mx.collections.ICollectionView;
   import mx.collections.IList;
   import mx.collections.IViewCursor;
   import mx.collections.ListCollectionView;
   import mx.collections.XMLListCollection;
   import mx.core.EdgeMetrics;
   import mx.core.FlexVersion;
   import mx.core.IFlexDisplayObject;
   import mx.core.IIMESupport;
   import mx.core.IRectangularBorder;
   import mx.core.ITextInput;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.FlexEvent;
   import mx.managers.IFocusManager;
   import mx.managers.IFocusManagerComponent;
   import mx.styles.ISimpleStyleClient;
   import mx.styles.StyleProxy;
   import mx.utils.UIDUtil;
   
   [AccessibilityClass(implementation="mx.accessibility.ComboBaseAccImpl")]
   [Style(name="textInputStyleName",type="String",inherit="no")]
   [Style(name="textInputClass",type="Class",inherit="no")]
   [Style(name="editableDisabledSkin",type="Class",inherit="no")]
   [Style(name="editableDownSkin",type="Class",inherit="no")]
   [Style(name="editableOverSkin",type="Class",inherit="no")]
   [Style(name="editableUpSkin",type="Class",inherit="no")]
   [Style(name="editableSkin",type="Class",inherit="no")]
   [Style(name="disabledSkin",type="Class",inherit="no")]
   [Style(name="downSkin",type="Class",inherit="no")]
   [Style(name="overSkin",type="Class",inherit="no")]
   [Style(name="upSkin",type="Class",inherit="no")]
   [Style(name="skin",type="Class",inherit="no",states=" up, over, down, disabled,  editableUp, editableOver, editableDown, editableDisabled")]
   [Style(name="symbolColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="focusColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="contentBackgroundColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="contentBackgroundAlpha",type="Number",inherit="yes",theme="spark")]
   public class ComboBase extends UIComponent implements IIMESupport, IFocusManagerComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var _textInputStyleFilters:Object = {
         "backgroundAlpha":"backgroundAlpha",
         "backgroundColor":"backgroundColor",
         "backgroundImage":"backgroundImage",
         "backgroundDisabledColor":"backgroundDisabledColor",
         "backgroundSize":"backgroundSize",
         "borderAlpha":"borderAlpha",
         "borderColor":"borderColor",
         "borderSides":"borderSides",
         "borderStyle":"borderStyle",
         "borderThickness":"borderThickness",
         "dropShadowColor":"dropShadowColor",
         "dropShadowEnabled":"dropShadowEnabled",
         "embedFonts":"embedFonts",
         "focusAlpha":"focusAlpha",
         "focusBlendMode":"focusBlendMode",
         "focusRoundedCorners":"focusRoundedCorners",
         "focusThickness":"focusThickness",
         "leading":"leading",
         "paddingLeft":"paddingLeft",
         "paddingRight":"paddingRight",
         "shadowDirection":"shadowDirection",
         "shadowDistance":"shadowDistance",
         "textDecoration":"textDecoration"
      };
      
      protected var collection:ICollectionView;
      
      protected var iterator:IViewCursor;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var collectionIterator:IViewCursor;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var border:IFlexDisplayObject;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var downArrowButton:Button;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var wrapDownArrowButton:Boolean = true;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var useFullDropdownSkin:Boolean = false;
      
      private var selectedUID:String;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var selectionChanged:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var selectedIndexChanged:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var selectedItemChanged:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var oldBorderStyle:String;
      
      private var _enabled:Boolean = false;
      
      private var enabledChanged:Boolean = false;
      
      private var _editable:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var editableChanged:Boolean = true;
      
      private var _imeMode:String = null;
      
      private var _restrict:String;
      
      private var _selectedIndex:int = -1;
      
      private var _selectedItem:Object;
      
      private var _text:String = "";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var textChanged:Boolean;
      
      protected var textInput:ITextInput;
      
      public function ComboBase()
      {
         super();
         tabEnabled = true;
         tabFocusEnabled = true;
      }
      
      override public function get baselinePosition() : Number
      {
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         return this.textInput.y + this.textInput.baselinePosition;
      }
      
      [Inspectable(category="General",enumeration="true,false",defaultValue="true")]
      override public function set enabled(value:Boolean) : void
      {
         super.enabled = value;
         this._enabled = value;
         this.enabledChanged = true;
         invalidateProperties();
      }
      
      protected function get arrowButtonStyleFilters() : Object
      {
         return null;
      }
      
      protected function get borderMetrics() : EdgeMetrics
      {
         if(Boolean(this.border) && this.border is IRectangularBorder)
         {
            return IRectangularBorder(this.border).borderMetrics;
         }
         return EdgeMetrics.EMPTY;
      }
      
      [Inspectable(category="Data")]
      [Bindable("collectionChange")]
      public function get dataProvider() : Object
      {
         return this.collection;
      }
      
      public function set dataProvider(value:Object) : void
      {
         var tmp:Array = null;
         if(value is Array)
         {
            this.collection = new ArrayCollection(value as Array);
         }
         else if(value is ICollectionView)
         {
            this.collection = ICollectionView(value);
         }
         else if(value is IList)
         {
            this.collection = new ListCollectionView(IList(value));
         }
         else if(value is XMLList)
         {
            this.collection = new XMLListCollection(value as XMLList);
         }
         else
         {
            tmp = [value];
            this.collection = new ArrayCollection(tmp);
         }
         this.iterator = this.collection.createCursor();
         this.collectionIterator = this.collection.createCursor();
         this.collection.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.collectionChangeHandler,false,0,true);
         var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
         event.kind = CollectionEventKind.RESET;
         this.collectionChangeHandler(event);
         dispatchEvent(event);
         invalidateSize();
         invalidateDisplayList();
      }
      
      [Inspectable(category="General",defaultValue="false")]
      [Bindable("editableChanged")]
      public function get editable() : Boolean
      {
         return this._editable;
      }
      
      public function set editable(value:Boolean) : void
      {
         this._editable = value;
         this.editableChanged = true;
         invalidateProperties();
         dispatchEvent(new Event("editableChanged"));
      }
      
      public function get enableIME() : Boolean
      {
         return this.editable;
      }
      
      public function get imeMode() : String
      {
         return this._imeMode;
      }
      
      public function set imeMode(value:String) : void
      {
         this._imeMode = value;
         if(Boolean(this.textInput))
         {
            this.textInput.imeMode = this._imeMode;
         }
      }
      
      [Inspectable(category="Other")]
      [Bindable("restrictChanged")]
      public function get restrict() : String
      {
         return this._restrict;
      }
      
      public function set restrict(value:String) : void
      {
         this._restrict = value;
         invalidateProperties();
         dispatchEvent(new Event("restrictChanged"));
      }
      
      [Inspectable(category="General",defaultValue="-1")]
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      public function set selectedIndex(value:int) : void
      {
         var bookmark:CursorBookmark = null;
         var len:int = 0;
         var data:Object = null;
         var uid:String = null;
         this._selectedIndex = value;
         if(value == -1)
         {
            this._selectedItem = null;
            this.selectedUID = null;
         }
         if(!this.collection || this.collection.length == 0)
         {
            this.selectedIndexChanged = true;
         }
         else if(value != -1)
         {
            value = Math.min(value,this.collection.length - 1);
            bookmark = this.iterator.bookmark;
            len = value;
            this.iterator.seek(CursorBookmark.FIRST,len);
            data = this.iterator.current;
            uid = this.itemToUID(data);
            this.iterator.seek(bookmark,0);
            this._selectedIndex = value;
            this._selectedItem = data;
            this.selectedUID = uid;
         }
         this.selectionChanged = true;
         invalidateDisplayList();
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      [Inspectable(category="General",defaultValue="null")]
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get selectedItem() : Object
      {
         return this._selectedItem;
      }
      
      public function set selectedItem(data:Object) : void
      {
         this.setSelectedItem(data);
      }
      
      private function setSelectedItem(data:Object, clearFirst:Boolean = true) : void
      {
         if(!this.collection || this.collection.length == 0)
         {
            this._selectedItem = data;
            this.selectedItemChanged = true;
            invalidateDisplayList();
            return;
         }
         var found:Boolean = false;
         var listCursor:IViewCursor = this.collection.createCursor();
         var i:int = 0;
         do
         {
            if(data == listCursor.current)
            {
               this._selectedIndex = i;
               this._selectedItem = data;
               this.selectedUID = this.itemToUID(data);
               this.selectionChanged = true;
               found = true;
               break;
            }
            i++;
         }
         while(listCursor.moveNext());
         if(!found)
         {
            this.selectedIndex = -1;
            this._selectedItem = null;
            this.selectedUID = null;
         }
         invalidateDisplayList();
      }
      
      [NonCommittingChangeEvent("change")]
      [Inspectable(category="General",defaultValue="")]
      [Bindable("valueCommit")]
      [Bindable("collectionChange")]
      public function get text() : String
      {
         return this._text;
      }
      
      public function set text(value:String) : void
      {
         this._text = value;
         this.textChanged = true;
         invalidateProperties();
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      protected function get textInputStyleFilters() : Object
      {
         return _textInputStyleFilters;
      }
      
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get value() : Object
      {
         if(this._editable)
         {
            return this.text;
         }
         var item:Object = this.selectedItem;
         if(item == null || typeof item != "object")
         {
            return item;
         }
         return item.data != null ? item.data : item.label;
      }
      
      override protected function initializeAccessibility() : void
      {
         if(ComboBase.createAccessibilityImplementation != null)
         {
            ComboBase.createAccessibilityImplementation(this);
         }
      }
      
      override protected function createChildren() : void
      {
         var borderClass:Class = null;
         var textInputStyleName:Object = null;
         var textInputClass:Class = null;
         super.createChildren();
         if(!this.border)
         {
            borderClass = getStyle("borderSkin");
            if(Boolean(borderClass))
            {
               this.border = new borderClass();
               if(this.border is IFocusManagerComponent)
               {
                  IFocusManagerComponent(this.border).focusEnabled = false;
               }
               if(this.border is ISimpleStyleClient)
               {
                  ISimpleStyleClient(this.border).styleName = this;
               }
               addChild(DisplayObject(this.border));
               if(FlexVersion.compatibilityVersion >= FlexVersion.VERSION_4_0)
               {
                  this.border.visible = false;
               }
            }
         }
         if(!this.downArrowButton)
         {
            this.downArrowButton = new Button();
            this.downArrowButton.styleName = new StyleProxy(this,this.arrowButtonStyleFilters);
            this.downArrowButton.focusEnabled = false;
            this.downArrowButton.tabEnabled = false;
            addChild(this.downArrowButton);
            this.downArrowButton.addEventListener(FlexEvent.BUTTON_DOWN,this.downArrowButton_buttonDownHandler);
         }
         if(!this.textInput)
         {
            textInputStyleName = getStyle("textInputStyleName");
            if(!textInputStyleName)
            {
               textInputStyleName = new StyleProxy(this,this.textInputStyleFilters);
            }
            textInputClass = getStyle("textInputClass");
            if(!textInputClass || FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
            {
               this.textInput = new TextInput();
            }
            else
            {
               this.textInput = new textInputClass();
            }
            this.textInput.editable = this._editable;
            this.editableChanged = true;
            this.textInput.restrict = "^\x1b";
            this.textInput.focusEnabled = false;
            this.textInput.mouseEnabled = this.textInput.mouseChildren = this._editable;
            this.textInput.imeMode = this._imeMode;
            this.textInput.styleName = textInputStyleName;
            this.textInput.addEventListener(Event.CHANGE,this.textInput_changeHandler);
            this.textInput.addEventListener(FlexEvent.ENTER,this.textInput_enterHandler);
            this.textInput.addEventListener(FocusEvent.FOCUS_IN,this.focusInHandler);
            this.textInput.addEventListener(FocusEvent.FOCUS_OUT,this.focusOutHandler);
            this.textInput.addEventListener(FlexEvent.VALUE_COMMIT,this.textInput_valueCommitHandler);
            addChild(DisplayObject(this.textInput));
            this.textInput.move(0,0);
            this.textInput.parentDrawsFocus = true;
         }
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         if(Boolean(this.downArrowButton))
         {
            this.downArrowButton.styleChanged(styleProp);
         }
         if(Boolean(this.textInput))
         {
            this.textInput.styleChanged(styleProp);
         }
         if(Boolean(this.border) && this.border is ISimpleStyleClient)
         {
            ISimpleStyleClient(this.border).styleChanged(styleProp);
         }
         super.styleChanged(styleProp);
      }
      
      override protected function commitProperties() : void
      {
         var e:Boolean = false;
         super.commitProperties();
         this.textInput.restrict = this._restrict;
         if(this.textChanged)
         {
            this.textInput.text = this._text;
            this.textChanged = false;
         }
         if(this.enabledChanged)
         {
            this.textInput.enabled = this._enabled;
            this.editableChanged = true;
            this.downArrowButton.enabled = this._enabled;
            this.enabledChanged = false;
         }
         if(this.editableChanged)
         {
            this.editableChanged = false;
            e = this._editable;
            if(this.wrapDownArrowButton == false)
            {
               if(e)
               {
                  if(Boolean(this.oldBorderStyle))
                  {
                     setStyle("borderStyle",this.oldBorderStyle);
                  }
               }
               else
               {
                  this.oldBorderStyle = getStyle("borderStyle");
                  setStyle("borderStyle","comboNonEdit");
               }
            }
            if(this.useFullDropdownSkin)
            {
               if(e && getStyle("editableSkin") != null)
               {
                  this.downArrowButton.skinName = "editableSkin";
               }
               else
               {
                  this.downArrowButton.skinName = "skin";
               }
               this.downArrowButton.upSkinName = e ? "editableUpSkin" : "upSkin";
               this.downArrowButton.overSkinName = e ? "editableOverSkin" : "overSkin";
               this.downArrowButton.downSkinName = e ? "editableDownSkin" : "downSkin";
               this.downArrowButton.disabledSkinName = e ? "editableDisabledSkin" : "disabledSkin";
               this.downArrowButton.changeSkins();
               this.downArrowButton.invalidateDisplayList();
            }
            if(Boolean(this.textInput))
            {
               this.textInput.editable = e;
               this.textInput.selectable = e;
               if(e)
               {
                  this.textInput.removeEventListener(MouseEvent.MOUSE_DOWN,this.textInput_mouseEventHandler);
                  this.textInput.removeEventListener(MouseEvent.MOUSE_UP,this.textInput_mouseEventHandler);
                  this.textInput.removeEventListener(MouseEvent.ROLL_OVER,this.textInput_mouseEventHandler);
                  this.textInput.removeEventListener(MouseEvent.ROLL_OUT,this.textInput_mouseEventHandler);
                  this.textInput.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
               }
               else
               {
                  this.textInput.addEventListener(MouseEvent.MOUSE_DOWN,this.textInput_mouseEventHandler);
                  this.textInput.addEventListener(MouseEvent.MOUSE_UP,this.textInput_mouseEventHandler);
                  this.textInput.addEventListener(MouseEvent.ROLL_OVER,this.textInput_mouseEventHandler);
                  this.textInput.addEventListener(MouseEvent.ROLL_OUT,this.textInput_mouseEventHandler);
                  this.textInput.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
               }
            }
         }
      }
      
      override protected function measure() : void
      {
         var prefSize:Object = null;
         var bm:EdgeMetrics = null;
         var textWidth:Number = NaN;
         var textHeight:Number = NaN;
         super.measure();
         var buttonWidth:Number = Number(getStyle("arrowButtonWidth"));
         var buttonHeight:Number = Number(this.downArrowButton.getExplicitOrMeasuredHeight());
         if(Boolean(this.collection) && this.collection.length > 0)
         {
            prefSize = this.calculatePreferredSizeFromData(this.collection.length);
            bm = this.borderMetrics;
            textWidth = prefSize.width + bm.left + bm.right + 8;
            textHeight = prefSize.height + bm.top + bm.bottom + UITextField.TEXT_HEIGHT_PADDING;
            measuredMinWidth = measuredWidth = textWidth + buttonWidth;
            measuredMinHeight = measuredHeight = Math.max(textHeight,buttonHeight);
         }
         else
         {
            measuredMinWidth = DEFAULT_MEASURED_MIN_WIDTH;
            measuredWidth = DEFAULT_MEASURED_WIDTH;
            measuredMinHeight = DEFAULT_MEASURED_MIN_HEIGHT;
            measuredHeight = DEFAULT_MEASURED_HEIGHT;
         }
         var padding:Number = getStyle("paddingTop") + getStyle("paddingBottom");
         measuredMinHeight += padding;
         measuredHeight += padding;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var vm:EdgeMetrics = null;
         var wh:Number = NaN;
         var paddingTop:Number = NaN;
         var paddingBottom:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var w:Number = unscaledWidth;
         var h:Number = unscaledHeight;
         var arrowWidth:Number = Number(getStyle("arrowButtonWidth"));
         var textInputHeight:Number = Number(this.textInput.getExplicitOrMeasuredHeight());
         if(isNaN(arrowWidth))
         {
            arrowWidth = 0;
         }
         if(this.wrapDownArrowButton)
         {
            vm = this.borderMetrics;
            wh = h - vm.top - vm.bottom;
            this.downArrowButton.setActualSize(wh,wh);
            this.downArrowButton.move(w - arrowWidth - vm.right,vm.top);
            if(Boolean(this.border))
            {
               this.border.setActualSize(w,h);
            }
            this.textInput.setActualSize(w - arrowWidth,textInputHeight);
         }
         else if(!this._editable && this.useFullDropdownSkin)
         {
            paddingTop = Number(getStyle("paddingTop"));
            paddingBottom = Number(getStyle("paddingBottom"));
            this.downArrowButton.move(0,0);
            if(Boolean(this.border))
            {
               this.border.setActualSize(w,h);
            }
            this.textInput.setActualSize(w - arrowWidth,textInputHeight);
            this.textInput.showBorderAndBackground(false);
            this.textInput.move(this.textInput.x,(h - textInputHeight - paddingTop - paddingBottom) / 2 + paddingTop);
            this.downArrowButton.setActualSize(unscaledWidth,unscaledHeight);
         }
         else
         {
            this.downArrowButton.move(w - arrowWidth,0);
            if(Boolean(this.border))
            {
               this.border.setActualSize(w - arrowWidth,h);
            }
            this.textInput.setActualSize(w - arrowWidth,h);
            this.downArrowButton.setActualSize(arrowWidth,unscaledHeight);
            this.textInput.showBorderAndBackground(true);
         }
         if(this.selectedItemChanged)
         {
            this.selectedItem = this.selectedItem;
            this.selectedItemChanged = false;
            this.selectedIndexChanged = false;
         }
         if(this.selectedIndexChanged)
         {
            this.selectedIndex = this.selectedIndex;
            this.selectedIndexChanged = false;
         }
      }
      
      override public function setFocus() : void
      {
         if(Boolean(this.textInput) && this._editable)
         {
            this.textInput.setFocus();
         }
         else
         {
            super.setFocus();
         }
      }
      
      override protected function isOurFocus(target:DisplayObject) : Boolean
      {
         return target == this.textInput || Boolean(super.isOurFocus(target));
      }
      
      protected function calculatePreferredSizeFromData(numItems:int) : Object
      {
         return null;
      }
      
      protected function itemToUID(data:Object) : String
      {
         if(!data)
         {
            return "null";
         }
         return UIDUtil.getUID(data);
      }
      
      override protected function focusInHandler(event:FocusEvent) : void
      {
         super.focusInHandler(event);
      }
      
      override protected function focusOutHandler(event:FocusEvent) : void
      {
         super.focusOutHandler(event);
         var fm:IFocusManager = focusManager;
         if(Boolean(fm) && event.target == this)
         {
            fm.defaultButtonEnabled = true;
         }
         if(this._editable)
         {
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
         }
      }
      
      protected function collectionChangeHandler(event:Event) : void
      {
         var requiresValueCommit:Boolean = false;
         var len:Number = NaN;
         var ind:Object = null;
         var ce:CollectionEvent = null;
         var i:int = 0;
         var uid:String = null;
         if(event is CollectionEvent)
         {
            requiresValueCommit = false;
            ce = CollectionEvent(event);
            if(ce.kind == CollectionEventKind.ADD)
            {
               if(this.selectedIndex >= ce.location)
               {
                  ++this._selectedIndex;
               }
            }
            if(ce.kind == CollectionEventKind.REMOVE)
            {
               for(i = 0; i < ce.items.length; i++)
               {
                  uid = this.itemToUID(ce.items[i]);
                  if(this.selectedUID == uid)
                  {
                     this.selectionChanged = true;
                  }
               }
               if(this.selectionChanged)
               {
                  if(this._selectedIndex >= this.collection.length)
                  {
                     this._selectedIndex = this.collection.length - 1;
                  }
                  this.selectedIndexChanged = true;
                  requiresValueCommit = true;
                  invalidateDisplayList();
               }
               else if(this.selectedIndex >= ce.location)
               {
                  --this._selectedIndex;
                  this.selectedIndexChanged = true;
                  requiresValueCommit = true;
                  invalidateDisplayList();
               }
            }
            if(ce.kind == CollectionEventKind.REFRESH)
            {
               this.selectedItemChanged = true;
               requiresValueCommit = true;
            }
            invalidateDisplayList();
            if(requiresValueCommit)
            {
               dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
            }
         }
      }
      
      private function textInput_mouseEventHandler(event:Event) : void
      {
         this.downArrowButton.dispatchEvent(event);
      }
      
      protected function textInput_changeHandler(event:Event) : void
      {
         this._text = this.textInput.text;
         if(this._selectedIndex != -1)
         {
            this._selectedIndex = -1;
            this._selectedItem = null;
            this.selectedUID = null;
         }
      }
      
      private function textInput_valueCommitHandler(event:FlexEvent) : void
      {
         this._text = this.textInput.text;
         dispatchEvent(event);
      }
      
      private function textInput_enterHandler(event:FlexEvent) : void
      {
         dispatchEvent(event);
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      protected function downArrowButton_buttonDownHandler(event:FlexEvent) : void
      {
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getTextInput() : ITextInput
      {
         return this.textInput;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get ComboDownArrowButton() : Button
      {
         return this.downArrowButton;
      }
   }
}

