package spark.components
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flashx.textLayout.operations.CutOperation;
   import flashx.textLayout.operations.DeleteTextOperation;
   import flashx.textLayout.operations.FlowOperation;
   import mx.core.IIMESupport;
   import mx.events.FlexEvent;
   import spark.components.supportClasses.DropDownListBase;
   import spark.components.supportClasses.ListBase;
   import spark.events.DropDownEvent;
   import spark.events.TextOperationEvent;
   import spark.utils.LabelUtil;
   
   [DiscouragedForProfile("mobileDevice")]
   [IconFile("ComboBox.png")]
   [AccessibilityClass(implementation="spark.accessibility.ComboBoxAccImpl")]
   [Style(name="paddingTop",type="Number",format="Length",inherit="no")]
   [Style(name="paddingRight",type="Number",format="Length",inherit="no")]
   [Style(name="paddingLeft",type="Number",format="Length",inherit="no")]
   [Style(name="paddingBottom",type="Number",format="Length",inherit="no")]
   public class ComboBox extends DropDownListBase implements IIMESupport
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      public static const CUSTOM_SELECTED_ITEM:int = ListBase.CUSTOM_SELECTED_ITEM;
      
      private static var _skinParts:Object = {
         "dropIndicator":false,
         "scroller":false,
         "textInput":false,
         "dataGroup":false,
         "openButton":true,
         "dropDown":false
      };
      
      [SkinPart(required="false")]
      public var textInput:TextInput;
      
      private var isTextInputInFocus:Boolean;
      
      private var actualProposedSelectedIndex:Number = -1;
      
      private var userTypedIntoText:Boolean;
      
      private var previousTextInputText:String = "";
      
      public var itemMatchingFunction:Function = null;
      
      private var _labelToItemFunction:Function;
      
      private var labelToItemFunctionChanged:Boolean = false;
      
      private var _maxChars:int = 0;
      
      private var maxCharsChanged:Boolean = false;
      
      public var openOnInput:Boolean = true;
      
      private var _prompt:String;
      
      private var promptChanged:Boolean;
      
      private var _restrict:String;
      
      private var restrictChanged:Boolean;
      
      private var typicalItemChanged:Boolean = false;
      
      public function ComboBox()
      {
         super();
         addEventListener(KeyboardEvent.KEY_DOWN,this.capture_keyDownHandler,true);
         allowCustomSelectedItem = true;
      }
      
      public function set labelToItemFunction(value:Function) : void
      {
         if(value == this._labelToItemFunction)
         {
            return;
         }
         this._labelToItemFunction = value;
         this.labelToItemFunctionChanged = true;
         invalidateProperties();
      }
      
      public function get labelToItemFunction() : Function
      {
         return this._labelToItemFunction;
      }
      
      [Inspectable(category="General",defaultValue="0")]
      public function set maxChars(value:int) : void
      {
         if(value == this._maxChars)
         {
            return;
         }
         this._maxChars = value;
         this.maxCharsChanged = true;
         invalidateProperties();
      }
      
      public function get maxChars() : int
      {
         return this._maxChars;
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
      
      [Inspectable(category="General",defaultValue="")]
      public function set restrict(value:String) : void
      {
         if(value == this._restrict)
         {
            return;
         }
         this._restrict = value;
         this.restrictChanged = true;
         invalidateProperties();
      }
      
      public function get restrict() : String
      {
         return this._restrict;
      }
      
      override public function get baselinePosition() : Number
      {
         return getBaselinePositionForPart(this.textInput);
      }
      
      [Inspectable(category="General",defaultValue="-1")]
      override public function set selectedIndex(value:int) : void
      {
         super.selectedIndex = value;
         this.actualProposedSelectedIndex = value;
      }
      
      [Inspectable(category="Data")]
      override public function set typicalItem(value:Object) : void
      {
         if(value == typicalItem)
         {
            return;
         }
         super.typicalItem = value;
         this.typicalItemChanged = true;
         invalidateProperties();
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set userProposedSelectedIndex(value:Number) : void
      {
         super.userProposedSelectedIndex = value;
         this.actualProposedSelectedIndex = value;
      }
      
      private function processInputField() : void
      {
         var matchingItems:Vector.<int> = null;
         var typedLength:int = 0;
         var item:Object = null;
         var itemString:String = null;
         this.actualProposedSelectedIndex = CUSTOM_SELECTED_ITEM;
         if(!dataProvider || dataProvider.length <= 0)
         {
            return;
         }
         if(this.textInput.text != "")
         {
            if(this.itemMatchingFunction != null)
            {
               matchingItems = this.itemMatchingFunction(this,this.textInput.text);
            }
            else
            {
               matchingItems = this.findMatchingItems(this.textInput.text);
            }
            if(matchingItems.length > 0)
            {
               super.changeHighlightedSelection(matchingItems[0],true);
               typedLength = this.textInput.text.length;
               item = Boolean(dataProvider) ? dataProvider.getItemAt(matchingItems[0]) : undefined;
               if(Boolean(item))
               {
                  itemString = itemToLabel(item);
                  this.textInput.selectAll();
                  this.textInput.insertText(itemString);
                  this.textInput.selectRange(typedLength,itemString.length);
               }
            }
            else
            {
               super.changeHighlightedSelection(CUSTOM_SELECTED_ITEM);
            }
         }
         else
         {
            super.changeHighlightedSelection(NO_SELECTION);
         }
      }
      
      private function findMatchingItems(input:String) : Vector.<int>
      {
         var startIndex:int = 0;
         var stopIndex:int = 0;
         var retVal:int = 0;
         var retVector:Vector.<int> = new Vector.<int>();
         retVal = findStringLoop(input,0,dataProvider.length);
         if(retVal != -1)
         {
            retVector.push(retVal);
         }
         return retVector;
      }
      
      private function getCustomSelectedItem() : *
      {
         var input:String = this.textInput.text;
         if(input == "")
         {
            return undefined;
         }
         if(this.labelToItemFunction != null)
         {
            return this._labelToItemFunction(input);
         }
         return input;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function applySelection() : void
      {
         var itemFromInput:* = undefined;
         if(this.actualProposedSelectedIndex == CUSTOM_SELECTED_ITEM)
         {
            itemFromInput = this.getCustomSelectedItem();
            if(itemFromInput != undefined)
            {
               setSelectedItem(itemFromInput,true);
            }
            else
            {
               setSelectedIndex(NO_SELECTION,true);
            }
         }
         else
         {
            setSelectedIndex(this.actualProposedSelectedIndex,true);
         }
         if(Boolean(this.textInput))
         {
            this.textInput.selectRange(-1,-1);
         }
         this.userTypedIntoText = false;
      }
      
      override protected function initializeAccessibility() : void
      {
         if(ComboBox.createAccessibilityImplementation != null)
         {
            ComboBox.createAccessibilityImplementation(this);
         }
      }
      
      override protected function commitProperties() : void
      {
         var itemString:String = null;
         var selectedIndexChanged:Boolean = _proposedSelectedIndex != NO_PROPOSED_SELECTION;
         if(_proposedSelectedIndex == CUSTOM_SELECTED_ITEM && _pendingSelectedItem == undefined)
         {
            _proposedSelectedIndex = NO_PROPOSED_SELECTION;
         }
         super.commitProperties();
         if(Boolean(this.textInput))
         {
            if(this.maxCharsChanged)
            {
               this.textInput.maxChars = this._maxChars;
               this.maxCharsChanged = false;
            }
            if(this.promptChanged)
            {
               this.textInput.prompt = this._prompt;
               this.promptChanged = false;
            }
            if(this.restrictChanged)
            {
               this.textInput.restrict = this._restrict;
               this.restrictChanged = false;
            }
            if(this.typicalItemChanged)
            {
               if(typicalItem != null)
               {
                  itemString = LabelUtil.itemToLabel(typicalItem,labelField,labelFunction);
                  this.textInput.widthInChars = itemString.length;
               }
               else
               {
                  this.textInput.widthInChars = 10;
               }
               this.typicalItemChanged = false;
            }
         }
         if(selectedIndexChanged && selectedIndex == NO_SELECTION)
         {
            this.textInput.text = "";
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function updateLabelDisplay(displayItem:* = undefined) : void
      {
         super.updateLabelDisplay();
         if(Boolean(this.textInput))
         {
            if(displayItem == undefined)
            {
               displayItem = selectedItem;
            }
            if(displayItem != null && displayItem != undefined)
            {
               this.textInput.text = LabelUtil.itemToLabel(displayItem,labelField,labelFunction);
            }
         }
      }
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         super.partAdded(partName,instance);
         if(instance == this.textInput)
         {
            this.updateLabelDisplay();
            this.textInput.addEventListener(TextOperationEvent.CHANGE,this.textInput_changeHandler);
            this.textInput.addEventListener(TextOperationEvent.CHANGING,this.textInput_changingHandler);
            this.textInput.addEventListener(FocusEvent.FOCUS_IN,this.textInput_focusInHandler,true);
            this.textInput.addEventListener(FocusEvent.FOCUS_OUT,this.textInput_focusOutHandler,true);
            this.textInput.maxChars = this.maxChars;
            this.textInput.restrict = this.restrict;
            this.textInput.focusEnabled = false;
            if(this.textInput.textDisplay is RichEditableText)
            {
               RichEditableText(this.textInput.textDisplay).batchTextInput = false;
            }
         }
      }
      
      override protected function partRemoved(partName:String, instance:Object) : void
      {
         super.partRemoved(partName,instance);
         if(instance == this.textInput)
         {
            this.textInput.removeEventListener(TextOperationEvent.CHANGE,this.textInput_changeHandler);
            this.textInput.removeEventListener(TextOperationEvent.CHANGING,this.textInput_changingHandler);
            this.textInput.removeEventListener(FocusEvent.FOCUS_IN,this.textInput_focusInHandler,true);
            this.textInput.removeEventListener(FocusEvent.FOCUS_OUT,this.textInput_focusOutHandler,true);
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function changeHighlightedSelection(newIndex:int, scrollToTop:Boolean = false) : void
      {
         var item:Object = null;
         var itemString:String = null;
         super.changeHighlightedSelection(newIndex,scrollToTop);
         if(newIndex >= 0)
         {
            item = Boolean(dataProvider) ? dataProvider.getItemAt(newIndex) : undefined;
            if(Boolean(item) && Boolean(this.textInput))
            {
               itemString = itemToLabel(item);
               this.textInput.selectAll();
               this.textInput.insertText(itemString);
               this.textInput.selectAll();
               this.userTypedIntoText = false;
            }
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function findKey(eventCode:int) : Boolean
      {
         return false;
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         if(!this.isTextInputInFocus)
         {
            this.keyDownHandlerHelper(event);
         }
      }
      
      protected function capture_keyDownHandler(event:KeyboardEvent) : void
      {
         if(this.isTextInputInFocus)
         {
            this.keyDownHandlerHelper(event);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function keyDownHandlerHelper(event:KeyboardEvent) : void
      {
         super.keyDownHandler(event);
         if(event.keyCode == Keyboard.ENTER && !isDropDownOpen)
         {
            this.applySelection();
         }
         else if(event.keyCode == Keyboard.ESCAPE)
         {
            if(Boolean(this.textInput))
            {
               if(selectedItem != null)
               {
                  this.textInput.text = itemToLabel(selectedItem);
               }
               else
               {
                  this.textInput.text = "";
               }
            }
            this.changeHighlightedSelection(selectedIndex);
         }
      }
      
      override public function setFocus() : void
      {
         if(Boolean(stage) && Boolean(this.textInput))
         {
            stage.focus = this.textInput.textDisplay as InteractiveObject;
         }
      }
      
      override protected function isOurFocus(target:DisplayObject) : Boolean
      {
         if(!this.textInput)
         {
            return false;
         }
         return target == this.textInput.textDisplay;
      }
      
      override protected function focusInHandler(event:FocusEvent) : void
      {
         super.focusInHandler(event);
         if(Boolean(this.textInput) && (this.textInput.editable || this.textInput.selectable))
         {
            callLater(this.textInput.selectAll);
         }
         this.userTypedIntoText = false;
      }
      
      override protected function focusOutHandler(event:FocusEvent) : void
      {
         if(!isDropDownOpen)
         {
            if(Boolean(this.textInput) && (selectedItem == null && this.textInput.text != "" || this.textInput.text != itemToLabel(selectedItem)))
            {
               this.applySelection();
            }
         }
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
         super.focusOutHandler(event);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function dropDownController_openHandler(event:DropDownEvent) : void
      {
         super.dropDownController_openHandler(event);
         this.userProposedSelectedIndex = this.userTypedIntoText ? NO_SELECTION : selectedIndex;
      }
      
      override protected function dropDownController_closeHandler(event:DropDownEvent) : void
      {
         super.dropDownController_closeHandler(event);
         if(!event.isDefaultPrevented())
         {
            this.applySelection();
         }
      }
      
      override protected function itemRemoved(index:int) : void
      {
         if(index == selectedIndex)
         {
            this.updateLabelDisplay("");
         }
         super.itemRemoved(index);
      }
      
      private function textInput_focusInHandler(event:FocusEvent) : void
      {
         this.isTextInputInFocus = true;
      }
      
      private function textInput_focusOutHandler(event:FocusEvent) : void
      {
         this.isTextInputInFocus = false;
      }
      
      private function textInput_changingHandler(event:TextOperationEvent) : void
      {
         this.previousTextInputText = this.textInput.text;
      }
      
      protected function textInput_changeHandler(event:TextOperationEvent) : void
      {
         this.userTypedIntoText = true;
         var operation:FlowOperation = event.operation;
         if(operation is DeleteTextOperation || operation is CutOperation)
         {
            super.changeHighlightedSelection(CUSTOM_SELECTED_ITEM);
         }
         else if(this.previousTextInputText != this.textInput.text)
         {
            if(this.openOnInput)
            {
               if(!isDropDownOpen)
               {
                  openDropDown();
                  addEventListener(DropDownEvent.OPEN,this.editingOpenHandler);
                  return;
               }
            }
            this.processInputField();
         }
      }
      
      private function editingOpenHandler(event:DropDownEvent) : void
      {
         removeEventListener(DropDownEvent.OPEN,this.editingOpenHandler);
         this.processInputField();
      }
      
      public function get enableIME() : Boolean
      {
         if(Boolean(this.textInput))
         {
            return this.textInput.enableIME;
         }
         return false;
      }
      
      public function get imeMode() : String
      {
         if(Boolean(this.textInput))
         {
            return this.textInput.imeMode;
         }
         return null;
      }
      
      public function set imeMode(value:String) : void
      {
         if(Boolean(this.textInput))
         {
            this.textInput.imeMode = value;
            invalidateProperties();
         }
      }
   }
}

