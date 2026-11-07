package mx.controls.colorPickerClasses
{
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
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.ColorPickerEvent;
   import mx.managers.IFocusManagerContainer;
   import mx.skins.halo.SwatchPanelSkin;
   import mx.skins.halo.SwatchSkin;
   import mx.styles.StyleManager;
   
   use namespace mx_internal;
   
   [ExcludeClass]
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
   [Style(name="shadowColor",type="uint",format="Color",inherit="yes")]
   [Style(name="shadowCapColor",type="uint",format="Color",inherit="yes")]
   [Style(name="highlightColor",type="uint",format="Color",inherit="yes")]
   [Style(name="columnCount",type="int",inherit="no")]
   [Style(name="borderColor",type="uint",format="Color",inherit="no")]
   [Style(name="backgroundColor",type="uint",format="Color",inherit="no")]
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
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var _labelField:String = "label";
      
      private var horizontalGap:Number;
      
      private var previewHeight:Number;
      
      private var border:SwatchPanelSkin;
      
      private var grid:Rectangle;
      
      private var initializing:Boolean = true;
      
      private var _showTextField:Boolean = true;
      
      private var columnCount:int;
      
      private var indexFlag:Boolean = false;
      
      mx_internal var tweenUp:Boolean = false;
      
      private var verticalGap:Number;
      
      private var swatchHeight:Number;
      
      mx_internal var isOverGrid:Boolean = false;
      
      private var itemOffset:Number = 3;
      
      private var _selectedColor:uint = 0;
      
      private var paddingRight:Number;
      
      private var swatchGridBorderSize:Number;
      
      private var paddingTop:Number;
      
      private var cellOffset:Number = 1;
      
      mx_internal var focusedIndex:int = -1;
      
      mx_internal var textInput:TextInput;
      
      private var _dataProvider:IList;
      
      private var paddingBottom:Number;
      
      private var highlight:SwatchSkin;
      
      private var paddingLeft:Number;
      
      private var preview:SwatchSkin;
      
      private var _editable:Boolean = true;
      
      mx_internal var isOpening:Boolean = false;
      
      private var rows:int;
      
      private var lastIndex:int = -1;
      
      private var previewWidth:Number;
      
      private var swatchWidth:Number;
      
      private var swatches:SwatchSkin;
      
      private var _colorField:String = "color";
      
      private var _selectedIndex:int = 0;
      
      private var textFieldWidth:Number;
      
      public function SwatchPanel()
      {
         super();
         addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
         addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
      }
      
      public function set selectedColor(value:uint) : void
      {
         var SI:int = 0;
         if(!indexFlag)
         {
            SI = findColorByName(value);
            if(SI != -1)
            {
               focusedIndex = findColorByName(value);
               _selectedIndex = focusedIndex;
            }
            else
            {
               selectedIndex = -1;
            }
         }
         else
         {
            indexFlag = false;
         }
         if(value != selectedColor || !isOverGrid || isOpening)
         {
            _selectedColor = value;
            updateColor(value);
            if(isOverGrid || isOpening)
            {
               setFocusOnSwatch(selectedIndex);
            }
            if(isOpening)
            {
               isOpening = false;
            }
         }
      }
      
      private function updateColor(color:uint) : void
      {
         var label:String = null;
         if(initializing || isNaN(color))
         {
            return;
         }
         preview.updateSkin(color);
         if(isOverGrid)
         {
            label = null;
            if(focusedIndex >= 0 && typeof dataProvider.getItemAt(focusedIndex) == "object")
            {
               label = dataProvider.getItemAt(focusedIndex)[labelField];
            }
            textInput.text = label != null && label.length != 0 ? label : rgbToHex(color);
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!border)
         {
            border = new SwatchPanelSkin();
            border.styleName = this;
            border.name = "swatchPanelBorder";
            addChild(border);
         }
         if(!preview)
         {
            preview = new SwatchSkin();
            preview.styleName = this;
            preview.color = selectedColor;
            preview.name = "swatchPreview";
            preview.setStyle("swatchBorderSize",0);
            addChild(preview);
         }
         if(!textInput)
         {
            textInput = new TextInput();
            if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
            {
               textInput.styleName = this;
               textInput.setStyle("borderCapColor",9542041);
               textInput.setStyle("buttonColor",7305079);
               textInput.setStyle("highlightColor",12897484);
               textInput.setStyle("shadowColor",12);
               textInput.setStyle("shadowCapColor",14015965);
               textInput.setStyle("borderStyle","inset");
               textInput.setStyle("backgroundColor",16777215);
               textInput.setStyle("borderColor",14015965);
            }
            else
            {
               textInput.styleName = getStyle("textFieldStyleName");
            }
            textInput.editable = _editable;
            textInput.maxChars = 6;
            textInput.name = "inset";
            textInput.text = rgbToHex(selectedColor);
            textInput.restrict = "#xa-fA-F0-9";
            textInput.addEventListener(Event.CHANGE,textInput_changeHandler);
            textInput.addEventListener(KeyboardEvent.KEY_DOWN,textInput_keyDownHandler);
            addChild(textInput);
         }
         if(!swatches)
         {
            swatches = new SwatchSkin();
            swatches.styleName = this;
            swatches.colorField = colorField;
            swatches.name = "swatchGrid";
            swatches.addEventListener(MouseEvent.CLICK,swatches_clickHandler);
            addChild(swatches);
         }
         if(!highlight)
         {
            highlight = new SwatchSkin();
            highlight.styleName = this;
            highlight.visible = false;
            highlight.name = "swatchHighlight";
            addChild(highlight);
         }
         refresh();
         initializing = false;
      }
      
      override public function get height() : Number
      {
         return getExplicitOrMeasuredHeight();
      }
      
      private function textInput_keyDownHandler(event:KeyboardEvent) : void
      {
         ColorPicker(owner).dispatchEvent(event);
      }
      
      private function findColorByName(name:Number) : int
      {
         if(name == getColor(selectedIndex))
         {
            return selectedIndex;
         }
         for(var i:int = 0; i < length; i++)
         {
            if(name == getColor(i))
            {
               return i;
            }
         }
         return -1;
      }
      
      override public function set height(value:Number) : void
      {
      }
      
      public function get showTextField() : Boolean
      {
         return _showTextField;
      }
      
      private function mouseMoveHandler(event:MouseEvent) : void
      {
         var colorPickerEvent:ColorPickerEvent = null;
         var column:Number = NaN;
         var row:Number = NaN;
         var index:Number = NaN;
         if(ColorPicker(owner).isDown && enabled)
         {
            if(mouseX > grid.left && mouseX < grid.right && mouseY > grid.top && mouseY < grid.bottom)
            {
               column = Math.floor((Math.floor(mouseX) - (grid.left + verticalGap)) / (swatchWidth + horizontalGap - cellOffset));
               row = Math.floor((Math.floor(mouseY) - grid.top) / (swatchHeight + verticalGap - cellOffset));
               index = row * columnCount + column;
               if(column == -1)
               {
                  index++;
               }
               else if(column > columnCount - 1)
               {
                  index--;
               }
               else if(row > rows - 1)
               {
                  index -= columnCount;
               }
               else if(index < 0)
               {
                  index += columnCount;
               }
               if((lastIndex != index || highlight.visible == false) && index < length)
               {
                  if(lastIndex != -1 && lastIndex != index)
                  {
                     colorPickerEvent = new ColorPickerEvent(ColorPickerEvent.ITEM_ROLL_OUT);
                     colorPickerEvent.index = lastIndex;
                     colorPickerEvent.color = getColor(lastIndex);
                     dispatchEvent(colorPickerEvent);
                  }
                  focusedIndex = index;
                  lastIndex = focusedIndex;
                  setFocusOnSwatch(focusedIndex);
                  colorPickerEvent = new ColorPickerEvent(ColorPickerEvent.ITEM_ROLL_OVER);
                  colorPickerEvent.index = focusedIndex;
                  colorPickerEvent.color = getColor(focusedIndex);
                  dispatchEvent(colorPickerEvent);
               }
            }
            else
            {
               if(highlight.visible == true && isOverGrid && lastIndex != -1)
               {
                  highlight.visible = false;
                  colorPickerEvent = new ColorPickerEvent(ColorPickerEvent.ITEM_ROLL_OUT);
                  colorPickerEvent.index = lastIndex;
                  colorPickerEvent.color = getColor(lastIndex);
                  dispatchEvent(colorPickerEvent);
               }
               isOverGrid = false;
            }
         }
      }
      
      public function get colorField() : String
      {
         return _colorField;
      }
      
      public function get selectedItem() : Object
      {
         return Boolean(dataProvider) ? dataProvider.getItemAt(selectedIndex) : null;
      }
      
      private function textInput_changeHandler(event:Event) : void
      {
         var color:String = TextInput(event.target).text;
         if(color.charAt(0) == "#")
         {
            textInput.maxChars = 7;
            color = "0x" + color.substring(1);
         }
         else if(color.substring(0,2) == "0x")
         {
            textInput.maxChars = 8;
         }
         else
         {
            textInput.maxChars = 6;
            color = "0x" + color;
         }
         highlight.visible = false;
         isOverGrid = false;
         selectedColor = Number(color);
         dispatchEvent(new Event("change"));
      }
      
      public function get editable() : Boolean
      {
         return _editable;
      }
      
      override protected function measure() : void
      {
         super.measure();
         swatches.updateGrid(IList(dataProvider));
         measuredWidth = Math.max(paddingLeft + paddingRight + swatches.width,100);
         measuredHeight = Math.max(paddingTop + previewHeight + itemOffset + paddingBottom + swatches.height,100);
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         if(event.eventPhase != EventPhase.AT_TARGET || !enabled)
         {
            return;
         }
         if(focusedIndex == -1 || isNaN(focusedIndex))
         {
            focusedIndex = 0;
         }
         var currentRow:int = Math.floor(focusedIndex / columnCount);
         switch(event.keyCode)
         {
            case Keyboard.UP:
               focusedIndex = focusedIndex - columnCount < 0 ? int((rows - 1) * columnCount + focusedIndex + 1) : int(focusedIndex - columnCount);
               isOverGrid = true;
               break;
            case Keyboard.DOWN:
               focusedIndex = focusedIndex + columnCount > length ? int(focusedIndex - 1 - (rows - 1) * columnCount) : int(focusedIndex + columnCount);
               isOverGrid = true;
               break;
            case Keyboard.LEFT:
               focusedIndex = focusedIndex < 1 ? int(length - 1) : int(focusedIndex - 1);
               isOverGrid = true;
               break;
            case Keyboard.RIGHT:
               focusedIndex = focusedIndex >= length - 1 ? 0 : int(focusedIndex + 1);
               isOverGrid = true;
               break;
            case Keyboard.PAGE_UP:
               focusedIndex -= currentRow * columnCount;
               isOverGrid = true;
               break;
            case Keyboard.PAGE_DOWN:
               focusedIndex = focusedIndex + (rows - 1) * columnCount - currentRow * columnCount;
               isOverGrid = true;
               break;
            case Keyboard.HOME:
               focusedIndex -= focusedIndex - currentRow * columnCount;
               isOverGrid = true;
               break;
            case Keyboard.END:
               focusedIndex = focusedIndex + (currentRow * columnCount - focusedIndex) + (columnCount - 1);
               isOverGrid = true;
         }
         if(focusedIndex < length && isOverGrid)
         {
            setFocusOnSwatch(focusedIndex);
            dispatchEvent(new Event("change"));
         }
      }
      
      public function get labelField() : String
      {
         return _labelField;
      }
      
      public function set dataProvider(value:Object) : void
      {
         var tmpDP:IList = null;
         if(value is IList)
         {
            _dataProvider = IList(value);
         }
         else if(value is Array)
         {
            tmpDP = new ArrayList(value as Array);
            value = tmpDP;
         }
         else
         {
            _dataProvider = null;
         }
         if(!initializing)
         {
            if(length == 0 || isNaN(length))
            {
               highlight.visible = false;
               _selectedIndex = -1;
            }
            refresh();
         }
      }
      
      public function get selectedColor() : uint
      {
         return _selectedColor;
      }
      
      override public function setFocus() : void
      {
         if(showTextField && editable)
         {
            textInput.setFocus();
            textInput.text = rgbToHex(selectedColor);
         }
      }
      
      public function set showTextField(value:Boolean) : void
      {
         _showTextField = value;
         if(!initializing)
         {
            textInput.visible = value;
         }
      }
      
      override public function set width(value:Number) : void
      {
      }
      
      public function set selectedItem(value:Object) : void
      {
         var color:Number = NaN;
         if(value != selectedItem)
         {
            if(typeof value == "object")
            {
               color = Number(value[colorField]);
            }
            else if(typeof value == "number")
            {
               color = Number(value);
            }
            selectedIndex = findColorByName(color);
         }
      }
      
      private function getColor(index:int) : uint
      {
         if(!dataProvider || dataProvider.length < 1 || index < 0 || index >= length)
         {
            return StyleManager.NOT_A_COLOR;
         }
         return uint(typeof dataProvider.getItemAt(index) == "object" ? dataProvider.getItemAt(index)[colorField] : dataProvider.getItemAt(index));
      }
      
      public function set colorField(value:String) : void
      {
         _colorField = value;
      }
      
      private function setFocusOnSwatch(index:int) : void
      {
         if(index < 0 || index > length - 1)
         {
            highlight.visible = false;
            return;
         }
         var row:Number = Math.floor(index / columnCount);
         var column:Number = index - row * columnCount;
         var xPos:Number = swatchWidth * column + horizontalGap * column - cellOffset * column + paddingLeft + swatchGridBorderSize;
         var yPos:Number = swatchHeight * row + verticalGap * row - cellOffset * row + paddingTop + previewHeight + itemOffset + swatchGridBorderSize;
         highlight.move(xPos,yPos);
         highlight.visible = true;
         isOverGrid = true;
         updateColor(getColor(index));
      }
      
      public function get dataProvider() : Object
      {
         return _dataProvider;
      }
      
      override public function get width() : Number
      {
         return getExplicitOrMeasuredWidth();
      }
      
      public function set editable(value:Boolean) : void
      {
         _editable = value;
         if(!initializing)
         {
            textInput.editable = value;
         }
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         if(!initializing)
         {
            refresh();
         }
      }
      
      public function set labelField(value:String) : void
      {
         _labelField = value;
      }
      
      private function swatches_clickHandler(event:MouseEvent) : void
      {
         var cpEvent:ColorPickerEvent = null;
         if(!enabled)
         {
            return;
         }
         if(mouseX > grid.left && mouseX < grid.right && mouseY > grid.top && mouseY < grid.bottom)
         {
            selectedIndex = focusedIndex;
            if(ColorPicker(owner).selectedIndex != selectedIndex)
            {
               ColorPicker(owner).selectedIndex = selectedIndex;
               cpEvent = new ColorPickerEvent(ColorPickerEvent.CHANGE);
               cpEvent.index = selectedIndex;
               cpEvent.color = getColor(selectedIndex);
               ColorPicker(owner).dispatchEvent(cpEvent);
            }
            ColorPicker(owner).close();
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
      
      private function refresh() : void
      {
         updateStyleCache();
         updateDisplayList(unscaledWidth,unscaledHeight);
         invalidateSize();
      }
      
      public function get length() : int
      {
         return Boolean(_dataProvider) ? _dataProvider.length : 0;
      }
      
      public function set selectedIndex(value:int) : void
      {
         if(value != selectedIndex && !initializing)
         {
            focusedIndex = value;
            _selectedIndex = focusedIndex;
            if(value >= 0)
            {
               indexFlag = true;
               selectedColor = getColor(value);
            }
         }
      }
      
      override public function drawFocus(isFocused:Boolean) : void
      {
      }
      
      public function get selectedIndex() : int
      {
         return _selectedIndex;
      }
      
      private function updateStyleCache() : void
      {
         horizontalGap = getStyle("horizontalGap");
         verticalGap = getStyle("verticalGap");
         columnCount = getStyle("columnCount");
         paddingLeft = getStyle("paddingLeft");
         paddingRight = getStyle("paddingRight");
         paddingTop = getStyle("paddingTop");
         paddingBottom = getStyle("paddingBottom");
         textFieldWidth = getStyle("textFieldWidth");
         previewWidth = getStyle("previewWidth");
         previewHeight = getStyle("previewHeight");
         swatchWidth = getStyle("swatchWidth");
         swatchHeight = getStyle("swatchHeight");
         swatchGridBorderSize = getStyle("swatchGridBorderSize");
         if(columnCount > length)
         {
            columnCount = length;
         }
         rows = Math.ceil(length / columnCount);
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         preview.updateSkin(selectedColor);
         preview.move(paddingLeft,paddingTop);
         textInput.setActualSize(textFieldWidth,previewHeight);
         textInput.move(paddingLeft + previewWidth + itemOffset,paddingTop);
         swatches.updateGrid(IList(dataProvider));
         swatches.move(paddingLeft,paddingTop + previewHeight + itemOffset);
         highlight.updateSkin(0);
         border.setActualSize(unscaledWidth,unscaledHeight);
         if(!grid)
         {
            grid = new Rectangle();
         }
         grid.left = swatches.x + swatchGridBorderSize;
         grid.top = swatches.y + swatchGridBorderSize;
         grid.right = swatches.x + swatchGridBorderSize + (swatchWidth - 1) * columnCount + 1 + horizontalGap * (columnCount - 1);
         grid.bottom = swatches.y + swatchGridBorderSize + (swatchHeight - 1) * rows + 1 + verticalGap * (rows - 1);
      }
   }
}

