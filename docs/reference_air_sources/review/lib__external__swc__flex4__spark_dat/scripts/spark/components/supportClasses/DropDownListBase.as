package spark.components.supportClasses
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import mx.collections.IList;
   import mx.events.CollectionEvent;
   import mx.events.FlexEvent;
   import spark.components.List;
   import spark.core.NavigationUnit;
   import spark.events.DropDownEvent;
   import spark.events.IndexChangeEvent;
   
   [AccessibilityClass(implementation="spark.accessibility.DropDownListBaseAccImpl")]
   [Exclude(name="selectedItems",kind="property")]
   [Exclude(name="selectedIndices",kind="property")]
   [Exclude(name="dropEnabled",kind="property")]
   [Exclude(name="dragMoveEnabled",kind="property")]
   [Exclude(name="dragEnabled",kind="property")]
   [Exclude(name="allowMultipleSelection",kind="property")]
   [SkinState("open")]
   [Event(name="open",type="spark.events.DropDownEvent")]
   [Event(name="close",type="spark.events.DropDownEvent")]
   [Style(name="dropShadowVisible",type="Boolean",inherit="no",theme="spark")]
   [Style(name="cornerRadius",type="Number",format="Length",inherit="no",theme="spark")]
   public class DropDownListBase extends List
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var PAGE_SIZE:int = 5;
      
      private static var _skinParts:Object = {
         "scroller":false,
         "dropIndicator":false,
         "dataGroup":false,
         "dropDown":false,
         "openButton":true
      };
      
      [SkinPart(required="false")]
      public var dropDown:DisplayObject;
      
      [SkinPart(required="true")]
      public var openButton:ButtonBase;
      
      private var labelChanged:Boolean = false;
      
      private var _dropDownController:DropDownController;
      
      private var _userProposedSelectedIndex:Number = -1;
      
      public function DropDownListBase()
      {
         super();
         this.dropDownController = new DropDownController();
      }
      
      override public function set allowMultipleSelection(value:Boolean) : void
      {
      }
      
      [Inspectable(category="Data")]
      override public function set dataProvider(value:IList) : void
      {
         if(dataProvider === value)
         {
            return;
         }
         super.dataProvider = value;
         this.labelChanged = true;
         invalidateProperties();
      }
      
      override public function set dragEnabled(value:Boolean) : void
      {
      }
      
      override public function set dragMoveEnabled(value:Boolean) : void
      {
      }
      
      override public function set dropEnabled(value:Boolean) : void
      {
      }
      
      [Inspectable(category="Data",defaultValue="label")]
      override public function set labelField(value:String) : void
      {
         if(labelField == value)
         {
            return;
         }
         super.labelField = value;
         this.labelChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(category="Data")]
      override public function set labelFunction(value:Function) : void
      {
         if(labelFunction == value)
         {
            return;
         }
         super.labelFunction = value;
         this.labelChanged = true;
         invalidateProperties();
      }
      
      protected function get dropDownController() : DropDownController
      {
         return this._dropDownController;
      }
      
      protected function set dropDownController(value:DropDownController) : void
      {
         if(this._dropDownController == value)
         {
            return;
         }
         this._dropDownController = value;
         this._dropDownController.addEventListener(DropDownEvent.OPEN,this.dropDownController_openHandler);
         this._dropDownController.addEventListener(DropDownEvent.CLOSE,this.dropDownController_closeHandler);
         if(Boolean(this.openButton))
         {
            this._dropDownController.openButton = this.openButton;
         }
         if(Boolean(this.dropDown))
         {
            this._dropDownController.dropDown = this.dropDown;
         }
      }
      
      public function get isDropDownOpen() : Boolean
      {
         if(Boolean(this.dropDownController))
         {
            return this.dropDownController.isOpen;
         }
         return false;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set userProposedSelectedIndex(value:Number) : void
      {
         this._userProposedSelectedIndex = value;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get userProposedSelectedIndex() : Number
      {
         return this._userProposedSelectedIndex;
      }
      
      override protected function initializeAccessibility() : void
      {
         if(DropDownListBase.createAccessibilityImplementation != null)
         {
            DropDownListBase.createAccessibilityImplementation(this);
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.labelChanged)
         {
            this.labelChanged = false;
            this.updateLabelDisplay();
         }
      }
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         super.partAdded(partName,instance);
         if(instance == this.openButton)
         {
            if(Boolean(this.dropDownController))
            {
               this.dropDownController.openButton = this.openButton;
            }
         }
         else if(instance == this.dropDown && Boolean(this.dropDownController))
         {
            this.dropDownController.dropDown = this.dropDown;
         }
      }
      
      override protected function partRemoved(partName:String, instance:Object) : void
      {
         if(Boolean(this.dropDownController))
         {
            if(instance == this.openButton)
            {
               this.dropDownController.openButton = null;
            }
            if(instance == this.dropDown)
            {
               this.dropDownController.dropDown = null;
            }
         }
         super.partRemoved(partName,instance);
      }
      
      override protected function getCurrentSkinState() : String
      {
         return !enabled ? "disabled" : (this.isDropDownOpen ? "open" : "normal");
      }
      
      override protected function commitSelection(dispatchChangedEvents:Boolean = true) : Boolean
      {
         var retVal:Boolean = super.commitSelection(dispatchChangedEvents);
         this.updateLabelDisplay();
         return retVal;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function isItemIndexSelected(index:int) : Boolean
      {
         return this.userProposedSelectedIndex == index;
      }
      
      public function openDropDown() : void
      {
         this.dropDownController.openDropDown();
      }
      
      public function closeDropDown(commit:Boolean) : void
      {
         this.dropDownController.closeDropDown(commit);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function updateLabelDisplay(displayItem:* = undefined) : void
      {
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function changeHighlightedSelection(newIndex:int, scrollToTop:Boolean = false) : void
      {
         itemSelected(this.userProposedSelectedIndex,false);
         this.userProposedSelectedIndex = newIndex;
         itemSelected(this.userProposedSelectedIndex,true);
         this.positionIndexInView(this.userProposedSelectedIndex,scrollToTop ? 0 : NaN);
         var e:IndexChangeEvent = new IndexChangeEvent(IndexChangeEvent.CARET_CHANGE);
         e.oldIndex = caretIndex;
         setCurrentCaretIndex(this.userProposedSelectedIndex);
         e.newIndex = caretIndex;
         dispatchEvent(e);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function positionIndexInView(index:int, topOffset:Number = NaN, bottomOffset:Number = NaN, leftOffset:Number = NaN, rightOffset:Number = NaN) : void
      {
         if(!layout)
         {
            return;
         }
         var spDelta:Point = dataGroup.layout.getScrollPositionDeltaToElementHelper(index,topOffset,bottomOffset,leftOffset,rightOffset);
         if(Boolean(spDelta))
         {
            dataGroup.horizontalScrollPosition += spDelta.x;
            dataGroup.verticalScrollPosition += spDelta.y;
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function findKey(eventCode:int) : Boolean
      {
         var matchingIndex:Number = NaN;
         var keyString:String = null;
         var startIndex:int = 0;
         if(!dataProvider || dataProvider.length == 0)
         {
            return false;
         }
         if(eventCode >= 33 && eventCode <= 126)
         {
            keyString = String.fromCharCode(eventCode);
            startIndex = this.isDropDownOpen ? int(this.userProposedSelectedIndex + 1) : int(selectedIndex + 1);
            startIndex = Math.max(0,startIndex);
            matchingIndex = findStringLoop(keyString,startIndex,dataProvider.length);
            if(matchingIndex == -1)
            {
               matchingIndex = findStringLoop(keyString,0,startIndex);
            }
            if(matchingIndex != -1)
            {
               if(this.isDropDownOpen)
               {
                  this.changeHighlightedSelection(matchingIndex);
               }
               else
               {
                  setSelectedIndex(matchingIndex,true);
               }
               return true;
            }
         }
         return false;
      }
      
      override protected function dataProvider_collectionChangeHandler(event:Event) : void
      {
         super.dataProvider_collectionChangeHandler(event);
         if(event is CollectionEvent)
         {
            this.labelChanged = true;
            invalidateProperties();
         }
      }
      
      override protected function item_mouseDownHandler(event:MouseEvent) : void
      {
         super.item_mouseDownHandler(event);
         this.userProposedSelectedIndex = selectedIndex;
         this.closeDropDown(true);
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         var navigationUnit:uint = 0;
         var proposedNewIndex:int = 0;
         var currentIndex:int = 0;
         var maxIndex:int = 0;
         if(!enabled)
         {
            return;
         }
         if(!this.dropDownController.processKeyDown(event))
         {
            navigationUnit = uint(mapKeycodeForLayoutDirection(event));
            if(this.findKey(event.charCode))
            {
               event.preventDefault();
               return;
            }
            if(!NavigationUnit.isNavigationUnit(navigationUnit))
            {
               return;
            }
            proposedNewIndex = NO_SELECTION;
            if(this.isDropDownOpen)
            {
               currentIndex = this.userProposedSelectedIndex < NO_SELECTION ? NO_SELECTION : int(this.userProposedSelectedIndex);
               proposedNewIndex = layout.getNavigationDestinationIndex(currentIndex,navigationUnit,arrowKeysWrapFocus);
               if(proposedNewIndex != NO_SELECTION)
               {
                  this.changeHighlightedSelection(proposedNewIndex);
                  event.preventDefault();
               }
            }
            else if(Boolean(dataProvider))
            {
               maxIndex = dataProvider.length - 1;
               currentIndex = caretIndex < NO_SELECTION ? NO_SELECTION : int(caretIndex);
               switch(navigationUnit)
               {
                  case NavigationUnit.UP:
                     if(arrowKeysWrapFocus && (currentIndex == 0 || currentIndex == NO_SELECTION || currentIndex == CUSTOM_SELECTED_ITEM))
                     {
                        proposedNewIndex = maxIndex;
                     }
                     else
                     {
                        proposedNewIndex = currentIndex - 1;
                     }
                     event.preventDefault();
                     break;
                  case NavigationUnit.DOWN:
                     if(arrowKeysWrapFocus && (currentIndex == maxIndex || currentIndex == NO_SELECTION || currentIndex == CUSTOM_SELECTED_ITEM))
                     {
                        proposedNewIndex = 0;
                     }
                     else
                     {
                        proposedNewIndex = currentIndex + 1;
                     }
                     event.preventDefault();
                     break;
                  case NavigationUnit.PAGE_UP:
                     proposedNewIndex = currentIndex == NO_SELECTION ? NO_SELECTION : int(Math.max(currentIndex - PAGE_SIZE,0));
                     event.preventDefault();
                     break;
                  case NavigationUnit.PAGE_DOWN:
                     proposedNewIndex = currentIndex == NO_SELECTION ? PAGE_SIZE : int(currentIndex + PAGE_SIZE);
                     event.preventDefault();
                     break;
                  case NavigationUnit.HOME:
                     proposedNewIndex = 0;
                     event.preventDefault();
                     break;
                  case NavigationUnit.END:
                     proposedNewIndex = maxIndex;
                     event.preventDefault();
               }
               proposedNewIndex = Math.min(proposedNewIndex,maxIndex);
               if(proposedNewIndex >= 0)
               {
                  this.userProposedSelectedIndex = proposedNewIndex;
                  setSelectedIndex(proposedNewIndex,true);
               }
            }
         }
         else
         {
            event.preventDefault();
         }
      }
      
      override protected function focusOutHandler(event:FocusEvent) : void
      {
         if(isOurFocus(DisplayObject(event.target)))
         {
            this.dropDownController.processFocusOut(event);
         }
         super.focusOutHandler(event);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function dropDownController_openHandler(event:DropDownEvent) : void
      {
         addEventListener(FlexEvent.UPDATE_COMPLETE,this.open_updateCompleteHandler);
         this.userProposedSelectedIndex = selectedIndex;
         invalidateSkinState();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function open_updateCompleteHandler(event:FlexEvent) : void
      {
         removeEventListener(FlexEvent.UPDATE_COMPLETE,this.open_updateCompleteHandler);
         this.positionIndexInView(selectedIndex,0);
         dispatchEvent(new DropDownEvent(DropDownEvent.OPEN));
      }
      
      protected function dropDownController_closeHandler(event:DropDownEvent) : void
      {
         addEventListener(FlexEvent.UPDATE_COMPLETE,this.close_updateCompleteHandler);
         invalidateSkinState();
         if(!event.isDefaultPrevented())
         {
            setSelectedIndex(this.userProposedSelectedIndex,true);
         }
         else
         {
            this.changeHighlightedSelection(selectedIndex);
         }
      }
      
      private function close_updateCompleteHandler(event:FlexEvent) : void
      {
         removeEventListener(FlexEvent.UPDATE_COMPLETE,this.close_updateCompleteHandler);
         dispatchEvent(new DropDownEvent(DropDownEvent.CLOSE));
      }
   }
}

