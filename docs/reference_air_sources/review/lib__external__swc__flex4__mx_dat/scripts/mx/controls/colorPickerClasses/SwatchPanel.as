package mx.controls.colorPickerClasses
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.EventPhase;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import mx.collections.ArrayList;
   import mx.collections.IList;
   import mx.controls.ColorPicker;
   import mx.controls.TextInput;
   import mx.core.FlexVersion;
   import mx.core.IFlexDisplayObject;
   import mx.core.ITextInput;
   import mx.core.UIComponent;
   import mx.events.ColorPickerEvent;
   import mx.managers.IFocusManagerContainer;
   import mx.skins.halo.SwatchPanelSkin;
   import mx.skins.halo.SwatchSkin;
   import mx.styles.StyleManager;
   
   [ExcludeClass]
   [Style(name="textInputClass",type="Class",inherit="no")]
   [Style(name="textFieldWidth",type="Number",format="Length",inherit="no")]
   [Style(name="textFieldStyleName",type="String",inherit="no")]
   [Style(name="swatchWidth",type="Number",format="Length",inherit="no")]
   [Style(name="swatchHighlightSize",type="Number",format="Length",inherit="no")]
   [Style(name="swatchHighlightColor",type="uint",format="Color",inherit="no")]
   [Style(name="swatchHeight",type="Number",format="Length",inherit="no")]
   [Style(name="swatchGridBackgroundColor",type="uint",format="Color",inherit="no")]
   [Style(name="swatchGridBorderSize",type="Number",format="Length",inherit="no")]
   [Style(name="swatchBorderColor",type="uint",format="Color",inherit="no")]
   [Style(name="swatchBorderSize",type="Number",format="Length",inherit="no")]
   [Style(name="previewWidth",type="Number",format="Length",inherit="no")]
   [Style(name="previewHeight",type="Number",format="Length",inherit="no")]
   [Style(name="shadowColor",type="uint",format="Color",inherit="yes",theme="halo, spark")]
   [Style(name="shadowCapColor",type="uint",format="Color",inherit="yes",theme="halo")]
   [Style(name="paddingBottom",type="Number",format="Length",inherit="no")]
   [Style(name="paddingTop",type="Number",format="Length",inherit="no")]
   [Style(name="highlightColor",type="uint",format="Color",inherit="yes",theme="halo, spark")]
   [Style(name="columnCount",type="int",inherit="no")]
   [Style(name="borderColor",type="uint",format="Color",inherit="no")]
   [Style(name="backgroundColor",type="uint",format="Color",inherit="no")]
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
   [Style(name="paddingRight",type="Number",format="Length",inherit="no")]
   [Style(name="paddingLeft",type="Number",format="Length",inherit="no")]
   [Style(name="verticalGap",type="Number",format="Length",inherit="no")]
   [Style(name="horizontalGap",type="Number",format="Length",inherit="no")]
   [Event(name="itemRollOut",type="mx.events.ColorPickerEvent")]
   [Event(name="itemRollOver",type="mx.events.ColorPickerEvent")]
   [Event(name="enter",type="flash.events.Event")]
   [Event(name="change",type="flash.events.Event")]
   public class SwatchPanel extends UIComponent implements IFocusManagerContainer
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var textInput:ITextInput;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var textInputClass:Class;
      
      private var border:SwatchPanelSkin;
      
      private var preview:SwatchSkin;
      
      private var swatches:SwatchSkin;
      
      private var highlight:SwatchSkin;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var isOverGrid:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var isOpening:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var focusedIndex:int = -1;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var tweenUp:Boolean = false;
      
      private var initializing:Boolean = true;
      
      private var indexFlag:Boolean = false;
      
      private var lastIndex:int = -1;
      
      private var grid:Rectangle;
      
      private var rows:int;
      
      private var horizontalGap:Number;
      
      private var verticalGap:Number;
      
      private var columnCount:int;
      
      private var paddingLeft:Number;
      
      private var paddingRight:Number;
      
      private var paddingTop:Number;
      
      private var paddingBottom:Number;
      
      private var textFieldWidth:Number;
      
      private var previewWidth:Number;
      
      private var previewHeight:Number;
      
      private var swatchWidth:Number;
      
      private var swatchHeight:Number;
      
      private var swatchGridBorderSize:Number;
      
      private var cellOffset:Number = 1;
      
      private var itemOffset:Number = 3;
      
      private var _colorField:String = "color";
      
      private var _dataProvider:IList;
      
      private var _editable:Boolean = true;
      
      private var _labelField:String = "label";
      
      private var _selectedColor:uint = 0;
      
      private var _selectedIndex:int = 0;
      
      private var _showTextField:Boolean = true;
      
      public function SwatchPanel()
      {
         super();
         addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
         addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
      }
      
      override public function get height() : Number
      {
         return getExplicitOrMeasuredHeight();
      }
      
      override public function set height(value:Number) : void
      {
      }
      
      override public function get width() : Number
      {
         return getExplicitOrMeasuredWidth();
      }
      
      override public function set width(value:Number) : void
      {
      }
      
      public function get colorField() : String
      {
         return this._colorField;
      }
      
      public function set colorField(value:String) : void
      {
         this._colorField = value;
      }
      
      public function get dataProvider() : Object
      {
         return this._dataProvider;
      }
      
      public function set dataProvider(value:Object) : void
      {
         var tmpDP:IList = null;
         if(value is IList)
         {
            this._dataProvider = IList(value);
         }
         else if(value is Array)
         {
            tmpDP = new ArrayList(value as Array);
            value = tmpDP;
         }
         else
         {
            this._dataProvider = null;
         }
         if(!this.initializing)
         {
            if(this.length == 0 || isNaN(this.length))
            {
               this.highlight.visible = false;
               this._selectedIndex = -1;
            }
            this.refresh();
         }
      }
      
      public function get editable() : Boolean
      {
         return this._editable;
      }
      
      public function set editable(value:Boolean) : void
      {
         this._editable = value;
         if(!this.initializing)
         {
            this.textInput.editable = value;
         }
      }
      
      public function get labelField() : String
      {
         return this._labelField;
      }
      
      public function set labelField(value:String) : void
      {
         this._labelField = value;
      }
      
      public function get length() : int
      {
         return Boolean(this._dataProvider) ? int(this._dataProvider.length) : 0;
      }
      
      public function get selectedColor() : uint
      {
         return this._selectedColor;
      }
      
      public function set selectedColor(value:uint) : void
      {
         var SI:int = 0;
         if(!this.indexFlag)
         {
            SI = this.findColorByName(value);
            if(SI != -1)
            {
               this.focusedIndex = this.findColorByName(value);
               this._selectedIndex = this.focusedIndex;
            }
            else
            {
               this.selectedIndex = -1;
            }
         }
         else
         {
            this.indexFlag = false;
         }
         if(value != this.selectedColor || !this.isOverGrid || this.isOpening)
         {
            this._selectedColor = value;
            this.updateColor(value);
            if(this.isOverGrid || this.isOpening)
            {
               this.setFocusOnSwatch(this.selectedIndex);
            }
            if(this.isOpening)
            {
               this.isOpening = false;
            }
         }
      }
      
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      public function set selectedIndex(value:int) : void
      {
         if(value != this.selectedIndex && !this.initializing)
         {
            this.focusedIndex = value;
            this._selectedIndex = this.focusedIndex;
            if(value >= 0)
            {
               this.indexFlag = true;
               this.selectedColor = this.getColor(value);
            }
         }
      }
      
      public function get selectedItem() : Object
      {
         return Boolean(this.dataProvider) ? this.dataProvider.getItemAt(this.selectedIndex) : null;
      }
      
      public function set selectedItem(value:Object) : void
      {
         var color:Number = NaN;
         if(value != this.selectedItem)
         {
            if(typeof value == "object")
            {
               color = Number(value[this.colorField]);
            }
            else if(typeof value == "number")
            {
               color = Number(value);
            }
            this.selectedIndex = this.findColorByName(color);
         }
      }
      
      public function get showTextField() : Boolean
      {
         return this._showTextField;
      }
      
      public function set showTextField(value:Boolean) : void
      {
         this._showTextField = value;
         if(!this.initializing)
         {
            this.textInput.visible = value;
         }
      }
      
      public function get defaultButton() : IFlexDisplayObject
      {
         return null;
      }
      
      public function set defaultButton(value:IFlexDisplayObject) : void
      {
      }
      
      override protected function createChildren() : void
      {
         var c:Class = null;
         super.createChildren();
         if(!this.border)
         {
            this.border = new SwatchPanelSkin();
            this.border.styleName = this;
            this.border.name = "swatchPanelBorder";
            addChild(this.border);
         }
         if(!this.preview)
         {
            this.preview = new SwatchSkin();
            this.preview.styleName = this;
            this.preview.color = this.selectedColor;
            this.preview.name = "swatchPreview";
            this.preview.setStyle("swatchBorderSize",0);
            addChild(this.preview);
         }
         if(!this.textInput)
         {
            c = getStyle("textInputClass");
            if(!c)
            {
               c = this.textInputClass;
            }
            if(!c || FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
            {
               this.textInput = new TextInput();
            }
            else
            {
               this.textInput = new this.textInputClass();
            }
            this.textInput.styleName = getStyle("textFieldStyleName");
            this.textInput.editable = this._editable;
            this.textInput.maxChars = 6;
            this.textInput.name = "inset";
            this.textInput.text = this.rgbToHex(this.selectedColor);
            this.textInput.restrict = "#xa-fA-F0-9";
            this.textInput.addEventListener(Event.CHANGE,this.textInput_changeHandler);
            this.textInput.addEventListener(KeyboardEvent.KEY_DOWN,this.textInput_keyDownHandler);
            addChild(DisplayObject(this.textInput));
         }
         if(!this.swatches)
         {
            this.swatches = new SwatchSkin();
            this.swatches.styleName = this;
            this.swatches.colorField = this.colorField;
            this.swatches.name = "swatchGrid";
            this.swatches.addEventListener(MouseEvent.CLICK,this.swatches_clickHandler);
            addChild(this.swatches);
         }
         if(!this.highlight)
         {
            this.highlight = new SwatchSkin();
            this.highlight.styleName = this;
            this.highlight.visible = false;
            this.highlight.name = "swatchHighlight";
            addChild(this.highlight);
         }
         this.refresh();
         this.initializing = false;
      }
      
      override protected function measure() : void
      {
         super.measure();
         this.swatches.updateGrid(IList(this.dataProvider));
         measuredWidth = Math.max(this.paddingLeft + this.paddingRight + this.swatches.width,100);
         measuredHeight = Math.max(this.paddingTop + this.previewHeight + this.itemOffset + this.paddingBottom + this.swatches.height,100);
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         this.preview.updateSkin(this.selectedColor);
         this.preview.move(this.paddingLeft,this.paddingTop);
         this.textInput.setActualSize(this.textFieldWidth,this.previewHeight);
         this.textInput.move(this.paddingLeft + this.previewWidth + this.itemOffset,this.paddingTop);
         this.swatches.updateGrid(IList(this.dataProvider));
         this.swatches.move(this.paddingLeft,this.paddingTop + this.previewHeight + this.itemOffset);
         this.highlight.updateSkin(0);
         this.border.setActualSize(unscaledWidth,unscaledHeight);
         if(!this.grid)
         {
            this.grid = new Rectangle();
         }
         this.grid.left = this.swatches.x + this.swatchGridBorderSize;
         this.grid.top = this.swatches.y + this.swatchGridBorderSize;
         this.grid.right = this.swatches.x + this.swatchGridBorderSize + (this.swatchWidth - 1) * this.columnCount + 1 + this.horizontalGap * (this.columnCount - 1);
         this.grid.bottom = this.swatches.y + this.swatchGridBorderSize + (this.swatchHeight - 1) * this.rows + 1 + this.verticalGap * (this.rows - 1);
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         if(!this.initializing)
         {
            this.refresh();
         }
      }
      
      override public function drawFocus(isFocused:Boolean) : void
      {
      }
      
      override public function setFocus() : void
      {
         if(this.showTextField && this.editable)
         {
            this.textInput.setFocus();
            this.textInput.text = this.rgbToHex(this.selectedColor);
         }
      }
      
      private function updateStyleCache() : void
      {
         this.horizontalGap = getStyle("horizontalGap");
         this.verticalGap = getStyle("verticalGap");
         this.columnCount = getStyle("columnCount");
         this.paddingLeft = getStyle("paddingLeft");
         this.paddingRight = getStyle("paddingRight");
         this.paddingTop = getStyle("paddingTop");
         this.paddingBottom = getStyle("paddingBottom");
         this.textFieldWidth = getStyle("textFieldWidth");
         this.previewWidth = getStyle("previewWidth");
         this.previewHeight = getStyle("previewHeight");
         this.swatchWidth = getStyle("swatchWidth");
         this.swatchHeight = getStyle("swatchHeight");
         this.swatchGridBorderSize = getStyle("swatchGridBorderSize");
         if(this.columnCount > this.length)
         {
            this.columnCount = this.length;
         }
         this.rows = Math.ceil(this.length / this.columnCount);
      }
      
      private function refresh() : void
      {
         this.updateStyleCache();
         this.updateDisplayList(unscaledWidth,unscaledHeight);
         invalidateSize();
      }
      
      private function updateColor(color:uint) : void
      {
         var label:String = null;
         var anchorPosition:int = 0;
         var activePosition:int = 0;
         if(this.initializing || isNaN(color))
         {
            return;
         }
         this.preview.updateSkin(color);
         if(this.isOverGrid)
         {
            label = null;
            if(this.focusedIndex >= 0 && typeof this.dataProvider.getItemAt(this.focusedIndex) == "object")
            {
               label = this.dataProvider.getItemAt(this.focusedIndex)[this.labelField];
            }
            if(!(this.textInput is TextInput))
            {
               anchorPosition = int(this.textInput.selectionAnchorPosition);
               activePosition = int(this.textInput.selectionActivePosition);
            }
            this.textInput.text = label != null && label.length != 0 ? label : this.rgbToHex(color);
            if(!(this.textInput is TextInput))
            {
               this.textInput.selectRange(anchorPosition,activePosition);
            }
         }
      }
      
      private function rgbToHex(color:uint) : String
      {
         var colorInHex:String = color.toString(16);
         var c:String = "00000" + colorInHex;
         var e:int = c.length;
         c = c.substring(e - 6,e);
         return c.toUpperCase();
      }
      
      private function findColorByName(name:Number) : int
      {
         if(name == this.getColor(this.selectedIndex))
         {
            return this.selectedIndex;
         }
         for(var i:int = 0; i < this.length; i++)
         {
            if(name == this.getColor(i))
            {
               return i;
            }
         }
         return -1;
      }
      
      private function getColor(index:int) : uint
      {
         if(!this.dataProvider || this.dataProvider.length < 1 || index < 0 || index >= this.length)
         {
            return StyleManager.NOT_A_COLOR;
         }
         return uint(typeof this.dataProvider.getItemAt(index) == "object" ? this.dataProvider.getItemAt(index)[this.colorField] : this.dataProvider.getItemAt(index));
      }
      
      private function setFocusOnSwatch(index:int) : void
      {
         if(index < 0 || index > this.length - 1)
         {
            this.highlight.visible = false;
            return;
         }
         var row:Number = Math.floor(index / this.columnCount);
         var column:Number = index - row * this.columnCount;
         var xPos:Number = this.swatchWidth * column + this.horizontalGap * column - this.cellOffset * column + this.paddingLeft + this.swatchGridBorderSize;
         var yPos:Number = this.swatchHeight * row + this.verticalGap * row - this.cellOffset * row + this.paddingTop + this.previewHeight + this.itemOffset + this.swatchGridBorderSize;
         this.highlight.move(xPos,yPos);
         this.highlight.visible = true;
         this.isOverGrid = true;
         this.updateColor(this.getColor(index));
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         if(event.eventPhase != EventPhase.AT_TARGET || !enabled)
         {
            return;
         }
         if(this.focusedIndex == -1 || isNaN(this.focusedIndex))
         {
            this.focusedIndex = 0;
         }
         var currentRow:int = Math.floor(this.focusedIndex / this.columnCount);
         var keyCode:uint = uint(mapKeycodeForLayoutDirection(event));
         switch(keyCode)
         {
            case Keyboard.UP:
               this.focusedIndex = this.focusedIndex - this.columnCount < 0 ? int((this.rows - 1) * this.columnCount + this.focusedIndex + 1) : int(this.focusedIndex - this.columnCount);
               this.isOverGrid = true;
               break;
            case Keyboard.DOWN:
               this.focusedIndex = this.focusedIndex + this.columnCount > this.length ? int(this.focusedIndex - 1 - (this.rows - 1) * this.columnCount) : int(this.focusedIndex + this.columnCount);
               this.isOverGrid = true;
               break;
            case Keyboard.LEFT:
               this.focusedIndex = this.focusedIndex < 1 ? int(this.length - 1) : int(this.focusedIndex - 1);
               this.isOverGrid = true;
               break;
            case Keyboard.RIGHT:
               this.focusedIndex = this.focusedIndex >= this.length - 1 ? 0 : int(this.focusedIndex + 1);
               this.isOverGrid = true;
               break;
            case Keyboard.PAGE_UP:
               this.focusedIndex -= currentRow * this.columnCount;
               this.isOverGrid = true;
               break;
            case Keyboard.PAGE_DOWN:
               this.focusedIndex = this.focusedIndex + (this.rows - 1) * this.columnCount - currentRow * this.columnCount;
               this.isOverGrid = true;
               break;
            case Keyboard.HOME:
               this.focusedIndex -= this.focusedIndex - currentRow * this.columnCount;
               this.isOverGrid = true;
               break;
            case Keyboard.END:
               this.focusedIndex = this.focusedIndex + (currentRow * this.columnCount - this.focusedIndex) + (this.columnCount - 1);
               this.isOverGrid = true;
         }
         if(this.focusedIndex < this.length && this.isOverGrid)
         {
            this.setFocusOnSwatch(this.focusedIndex);
            dispatchEvent(new Event("change"));
         }
      }
      
      private function mouseMoveHandler(event:MouseEvent) : void
      {
         var colorPickerEvent:ColorPickerEvent = null;
         var column:Number = NaN;
         var row:Number = NaN;
         var index:Number = NaN;
         if(ColorPicker(owner).isDown && Boolean(enabled))
         {
            if(mouseX > this.grid.left && mouseX < this.grid.right && mouseY > this.grid.top && mouseY < this.grid.bottom)
            {
               column = Math.floor((Math.floor(mouseX) - (this.grid.left + this.verticalGap)) / (this.swatchWidth + this.horizontalGap - this.cellOffset));
               row = Math.floor((Math.floor(mouseY) - this.grid.top) / (this.swatchHeight + this.verticalGap - this.cellOffset));
               index = row * this.columnCount + column;
               if(column == -1)
               {
                  index++;
               }
               else if(column > this.columnCount - 1)
               {
                  index--;
               }
               else if(row > this.rows - 1)
               {
                  index -= this.columnCount;
               }
               else if(index < 0)
               {
                  index += this.columnCount;
               }
               if((this.lastIndex != index || this.highlight.visible == false) && index < this.length)
               {
                  if(this.lastIndex != -1 && this.lastIndex != index)
                  {
                     colorPickerEvent = new ColorPickerEvent(ColorPickerEvent.ITEM_ROLL_OUT);
                     colorPickerEvent.index = this.lastIndex;
                     colorPickerEvent.color = this.getColor(this.lastIndex);
                     dispatchEvent(colorPickerEvent);
                  }
                  this.focusedIndex = index;
                  this.lastIndex = this.focusedIndex;
                  this.setFocusOnSwatch(this.focusedIndex);
                  colorPickerEvent = new ColorPickerEvent(ColorPickerEvent.ITEM_ROLL_OVER);
                  colorPickerEvent.index = this.focusedIndex;
                  colorPickerEvent.color = this.getColor(this.focusedIndex);
                  dispatchEvent(colorPickerEvent);
               }
            }
            else
            {
               if(this.highlight.visible == true && this.isOverGrid && this.lastIndex != -1)
               {
                  this.highlight.visible = false;
                  colorPickerEvent = new ColorPickerEvent(ColorPickerEvent.ITEM_ROLL_OUT);
                  colorPickerEvent.index = this.lastIndex;
                  colorPickerEvent.color = this.getColor(this.lastIndex);
                  dispatchEvent(colorPickerEvent);
               }
               this.isOverGrid = false;
            }
         }
      }
      
      private function swatches_clickHandler(event:MouseEvent) : void
      {
         var cpEvent:ColorPickerEvent = null;
         if(!enabled)
         {
            return;
         }
         if(mouseX > this.grid.left && mouseX < this.grid.right && mouseY > this.grid.top && mouseY < this.grid.bottom)
         {
            this.selectedIndex = this.focusedIndex;
            if(ColorPicker(owner).selectedIndex != this.selectedIndex)
            {
               ColorPicker(owner).selectedIndex = this.selectedIndex;
               cpEvent = new ColorPickerEvent(ColorPickerEvent.CHANGE);
               cpEvent.index = this.selectedIndex;
               cpEvent.color = this.getColor(this.selectedIndex);
               ColorPicker(owner).dispatchEvent(cpEvent);
            }
            ColorPicker(owner).close();
         }
      }
      
      private function textInput_keyDownHandler(event:KeyboardEvent) : void
      {
         ColorPicker(owner).dispatchEvent(event);
      }
      
      private function textInput_changeHandler(event:Event) : void
      {
         var color:String = ITextInput(event.target).text;
         if(color.charAt(0) == "#")
         {
            this.textInput.maxChars = 7;
            color = "0x" + color.substring(1);
         }
         else if(color.substring(0,2) == "0x")
         {
            this.textInput.maxChars = 8;
         }
         else
         {
            this.textInput.maxChars = 6;
            color = "0x" + color;
         }
         this.highlight.visible = false;
         this.isOverGrid = false;
         this.selectedColor = Number(color);
         dispatchEvent(new Event("change"));
      }
   }
}

