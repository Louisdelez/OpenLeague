package mx.controls
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.text.StyleSheet;
   import flash.text.TextLineMetrics;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.IDataRenderer;
   import mx.core.IFlexModuleFactory;
   import mx.core.IFontContextComponent;
   import mx.core.IUITextField;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.events.FlexEvent;
   
   [Alternative(replacement="spark.components.Label",since="4.0")]
   [IconFile("Label.png")]
   [DefaultBindingProperty(destination="text")]
   [AccessibilityClass(implementation="mx.accessibility.LabelAccImpl")]
   [Exclude(name="setFocus",kind="method")]
   [Exclude(name="themeColor",kind="style")]
   [Exclude(name="focusThickness",kind="style")]
   [Exclude(name="focusSkin",kind="style")]
   [Exclude(name="focusBlendMode",kind="style")]
   [Exclude(name="chromeColor",kind="style")]
   [Exclude(name="tabEnabled",kind="property")]
   [Exclude(name="mouseFocusEnabled",kind="property")]
   [Exclude(name="focusPane",kind="property")]
   [Exclude(name="focusEnabled",kind="property")]
   [Style(name="paddingTop",type="Number",format="Length",inherit="no")]
   [Style(name="paddingBottom",type="Number",format="Length",inherit="no")]
   [Style(name="paddingRight",type="Number",format="Length",inherit="no")]
   [Style(name="paddingLeft",type="Number",format="Length",inherit="no")]
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
   [Event(name="link",type="flash.events.TextEvent")]
   [Event(name="dataChange",type="mx.events.FlexEvent")]
   public class Label extends UIComponent implements IDataRenderer, IDropInListItemRenderer, IListItemRenderer, IFontContextComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var textSet:Boolean;
      
      private var enabledChanged:Boolean = false;
      
      protected var textField:IUITextField;
      
      private var toolTipSet:Boolean = false;
      
      private var _condenseWhite:Boolean = false;
      
      private var condenseWhiteChanged:Boolean = false;
      
      private var _data:Object;
      
      private var _htmlText:String = "";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var htmlTextChanged:Boolean = false;
      
      private var explicitHTMLText:String = null;
      
      private var _listData:BaseListData;
      
      private var _selectable:Boolean = false;
      
      private var selectableChanged:Boolean;
      
      private var styleSheetChanged:Boolean = false;
      
      private var _styleSheet:StyleSheet;
      
      private var _tabIndex:int = -1;
      
      private var _text:String = "";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var textChanged:Boolean = false;
      
      private var _textHeight:Number;
      
      private var _textWidth:Number;
      
      public var truncateToFit:Boolean = true;
      
      public function Label()
      {
         super();
      }
      
      override public function get baselinePosition() : Number
      {
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         return this.textField.y + this.textField.baselinePosition;
      }
      
      [Inspectable(category="General")]
      override public function set enabled(value:Boolean) : void
      {
         if(value == enabled)
         {
            return;
         }
         super.enabled = value;
         this.enabledChanged = true;
         invalidateProperties();
      }
      
      override public function set toolTip(value:String) : void
      {
         super.toolTip = value;
         this.toolTipSet = value != null;
      }
      
      [Inspectable(category="General",defaultValue="false")]
      [Bindable("condenseWhiteChanged")]
      public function get condenseWhite() : Boolean
      {
         return this._condenseWhite;
      }
      
      public function set condenseWhite(value:Boolean) : void
      {
         if(value == this._condenseWhite)
         {
            return;
         }
         this._condenseWhite = value;
         this.condenseWhiteChanged = true;
         if(this.isHTML)
         {
            this.htmlTextChanged = true;
         }
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new Event("condenseWhiteChanged"));
      }
      
      [Inspectable(environment="none")]
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(value:Object) : void
      {
         var newText:* = undefined;
         this._data = value;
         if(Boolean(this._listData))
         {
            newText = this._listData.label;
         }
         else if(this._data != null)
         {
            if(this._data is String)
            {
               newText = String(this._data);
            }
            else
            {
               newText = this._data.toString();
            }
         }
         if(newText !== undefined && !this.textSet)
         {
            this.text = newText;
            this.textSet = false;
         }
         dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
      }
      
      public function get fontContext() : IFlexModuleFactory
      {
         return moduleFactory;
      }
      
      public function set fontContext(moduleFactory:IFlexModuleFactory) : void
      {
         this.moduleFactory = moduleFactory;
      }
      
      [Inspectable(category="General",defaultValue="")]
      [CollapseWhiteSpace]
      [Bindable("htmlTextChanged")]
      public function get htmlText() : String
      {
         return this._htmlText;
      }
      
      public function set htmlText(value:String) : void
      {
         this.textSet = true;
         if(!value)
         {
            value = "";
         }
         if(this.isHTML && value == this.explicitHTMLText)
         {
            return;
         }
         this._htmlText = value;
         this.htmlTextChanged = true;
         this._text = null;
         this.explicitHTMLText = value;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new Event("htmlTextChanged"));
      }
      
      private function get isHTML() : Boolean
      {
         return this.explicitHTMLText != null;
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
      
      [Inspectable(category="General",defaultValue="true")]
      public function get selectable() : Boolean
      {
         return this._selectable;
      }
      
      public function set selectable(value:Boolean) : void
      {
         if(value == this.selectable)
         {
            return;
         }
         this._selectable = value;
         this.selectableChanged = true;
         invalidateProperties();
      }
      
      public function get styleSheet() : StyleSheet
      {
         return this._styleSheet;
      }
      
      public function set styleSheet(value:StyleSheet) : void
      {
         this._styleSheet = value;
         this.styleSheetChanged = true;
         this.htmlTextChanged = true;
         invalidateProperties();
      }
      
      override public function get tabIndex() : int
      {
         return this._tabIndex;
      }
      
      override public function set tabIndex(value:int) : void
      {
         this._tabIndex = value;
         invalidateProperties();
      }
      
      [Inspectable(category="General",defaultValue="")]
      [CollapseWhiteSpace]
      [Bindable("valueCommit")]
      public function get text() : String
      {
         return this._text;
      }
      
      public function set text(value:String) : void
      {
         this.textSet = true;
         if(!value)
         {
            value = "";
         }
         if(!this.isHTML && value == this._text)
         {
            return;
         }
         this._text = value;
         this.textChanged = true;
         this._htmlText = null;
         this.explicitHTMLText = null;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      public function get textHeight() : Number
      {
         return this._textHeight;
      }
      
      public function get textWidth() : Number
      {
         return this._textWidth;
      }
      
      override protected function initializeAccessibility() : void
      {
         if(Label.createAccessibilityImplementation != null)
         {
            Label.createAccessibilityImplementation(this);
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!this.textField)
         {
            this.createTextField(-1);
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(Boolean(hasFontContextChanged()) && this.textField != null)
         {
            this.removeTextField();
            this.condenseWhiteChanged = true;
            this.enabledChanged = true;
            this.selectableChanged = true;
            this.textChanged = true;
         }
         if(!this.textField)
         {
            this.createTextField(-1);
         }
         if(this.condenseWhiteChanged)
         {
            this.textField.condenseWhite = this._condenseWhite;
            this.condenseWhiteChanged = false;
         }
         this.textField.tabIndex = this.tabIndex;
         if(this.enabledChanged)
         {
            this.textField.enabled = enabled;
            this.enabledChanged = false;
         }
         if(this.selectableChanged)
         {
            this.textField.selectable = this._selectable;
            this.selectableChanged = false;
         }
         if(this.styleSheetChanged)
         {
            this.textField.styleSheet = this._styleSheet;
            this.styleSheetChanged = false;
         }
         if(this.textChanged || this.htmlTextChanged)
         {
            if(this.isHTML)
            {
               this.textField.htmlText = this.explicitHTMLText;
            }
            else
            {
               this.textField.text = this._text;
            }
            this.textFieldChanged(false);
            this.textChanged = false;
            this.htmlTextChanged = false;
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         var t:String = this.isHTML ? this.explicitHTMLText : this.text;
         t = this.getMinimumText(t);
         var textFieldBounds:Rectangle = this.measureTextFieldBounds(t);
         measuredMinWidth = measuredWidth = textFieldBounds.width + getStyle("paddingLeft") + getStyle("paddingRight");
         measuredMinHeight = measuredHeight = textFieldBounds.height + getStyle("paddingTop") + getStyle("paddingBottom");
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var truncated:Boolean = false;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var paddingLeft:Number = Number(getStyle("paddingLeft"));
         var paddingTop:Number = Number(getStyle("paddingTop"));
         var paddingRight:Number = Number(getStyle("paddingRight"));
         var paddingBottom:Number = Number(getStyle("paddingBottom"));
         this.textField.setActualSize(unscaledWidth - paddingLeft - paddingRight,unscaledHeight - paddingTop - paddingBottom);
         this.textField.x = paddingLeft;
         this.textField.y = paddingTop;
         var t:String = this.isHTML ? this.explicitHTMLText : this.text;
         var textFieldBounds:Rectangle = this.measureTextFieldBounds(t);
         if(this.truncateToFit)
         {
            if(this.isHTML)
            {
               truncated = textFieldBounds.width > this.textField.width;
            }
            else
            {
               this.textField.text = this._text;
               truncated = Boolean(this.textField.truncateToFit());
            }
            if(!this.toolTipSet)
            {
               super.toolTip = truncated ? this.text : null;
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createTextField(childIndex:int) : void
      {
         if(!this.textField)
         {
            this.textField = IUITextField(createInFontContext(UITextField));
            this.textField.enabled = enabled;
            this.textField.ignorePadding = true;
            this.textField.selectable = this.selectable;
            this.textField.styleName = this;
            this.textField.addEventListener("textFieldStyleChange",this.textField_textFieldStyleChangeHandler);
            this.textField.addEventListener("textInsert",this.textField_textModifiedHandler);
            this.textField.addEventListener("textReplace",this.textField_textModifiedHandler);
            this.textField.addEventListener("textFieldWidthChange",this.textField_textFieldWidthChangeHandler);
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
            this.textField.removeEventListener("textFieldStyleChange",this.textField_textFieldStyleChangeHandler);
            this.textField.removeEventListener("textInsert",this.textField_textModifiedHandler);
            this.textField.removeEventListener("textReplace",this.textField_textModifiedHandler);
            this.textField.removeEventListener("textFieldWidthChange",this.textField_textFieldWidthChangeHandler);
            removeChild(DisplayObject(this.textField));
            this.textField = null;
         }
      }
      
      public function getLineMetrics(lineIndex:int) : TextLineMetrics
      {
         return Boolean(this.textField) ? this.textField.getLineMetrics(lineIndex) : null;
      }
      
      private function textFieldChanged(styleChangeOnly:Boolean) : void
      {
         var changed1:Boolean = false;
         var changed2:Boolean = false;
         if(!styleChangeOnly)
         {
            changed1 = this._text != this.textField.text;
            this._text = this.textField.text;
         }
         changed2 = this._htmlText != this.textField.htmlText;
         this._htmlText = this.textField.htmlText;
         if(changed1)
         {
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
         }
         if(changed2)
         {
            dispatchEvent(new Event("htmlTextChanged"));
         }
         this._textWidth = this.textField.textWidth;
         this._textHeight = this.textField.textHeight;
      }
      
      private function measureTextFieldBounds(s:String) : Rectangle
      {
         var lineMetrics:TextLineMetrics = this.isHTML ? measureHTMLText(s) : measureText(s);
         return new Rectangle(0,0,lineMetrics.width + UITextField.TEXT_WIDTH_PADDING,lineMetrics.height + UITextField.TEXT_HEIGHT_PADDING);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getTextField() : IUITextField
      {
         return this.textField;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getMinimumText(t:String) : String
      {
         if(!t || t.length < 2)
         {
            t = "Wj";
         }
         return t;
      }
      
      private function textField_textFieldStyleChangeHandler(event:Event) : void
      {
         this.textFieldChanged(true);
      }
      
      private function textField_textModifiedHandler(event:Event) : void
      {
         this.textFieldChanged(false);
      }
      
      private function textField_textFieldWidthChangeHandler(event:Event) : void
      {
         this.textFieldChanged(true);
      }
   }
}

