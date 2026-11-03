package spark.components.supportClasses
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.collections.ArrayList;
   import mx.collections.IList;
   import mx.core.IVisualElement;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.FlexEvent;
   import spark.components.IItemRenderer;
   import spark.components.SkinnableDataContainer;
   import spark.events.IndexChangeEvent;
   import spark.events.ListEvent;
   import spark.events.RendererExistenceEvent;
   import spark.layouts.supportClasses.LayoutBase;
   import spark.utils.LabelUtil;
   
   [AccessibilityClass(implementation="spark.accessibility.ListBaseAccImpl")]
   [Event(name="caretChange",type="spark.events.IndexChangeEvent")]
   [Event(name="change",type="spark.events.IndexChangeEvent")]
   [Event(name="changing",type="spark.events.IndexChangeEvent")]
   [Event(name="itemRollOut",type="spark.events.ListEvent")]
   [Event(name="itemRollOver",type="spark.events.ListEvent")]
   public class ListBase extends SkinnableDataContainer
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public static const NO_SELECTION:int = -1;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const NO_PROPOSED_SELECTION:int = -2;
      
      private static const NO_CARET:int = -1;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var CUSTOM_SELECTED_ITEM:int = -3;
      
      private static const TYPE_MAP:Object = {
         "rollOver":"itemRollOver",
         "rollOut":"itemRollOut"
      };
      
      private static var _skinParts:Object = {"dataGroup":false};
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var allowCustomSelectedItem:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var dispatchChangeAfterSelection:Boolean = false;
      
      private var allowSelectionTransitions:Boolean = false;
      
      private var allowCaretTransitions:Boolean = false;
      
      private var inUpdateRenderer:Boolean;
      
      private var dataProviderChanged:Boolean;
      
      public var arrowKeysWrapFocus:Boolean;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _caretIndex:Number = -1;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var doingWholesaleChanges:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var caretItem:*;
      
      private var _labelField:String = "label";
      
      private var labelFieldOrFunctionChanged:Boolean;
      
      private var _labelFunction:Function;
      
      private var _requireSelection:Boolean = false;
      
      private var requireSelectionChanged:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _proposedSelectedIndex:int = -2;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var selectedIndexAdjusted:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var caretIndexAdjusted:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var changeCaretOnSelection:Boolean = true;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _selectedIndex:int = -1;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _pendingSelectedItem:*;
      
      private var _selectedItem:*;
      
      private var _useVirtualLayout:Boolean = false;
      
      public function ListBase()
      {
         super();
      }
      
      override public function get baselinePosition() : Number
      {
         var originalProvider:IList = null;
         var result:Number = NaN;
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         var isNull:Boolean = dataProvider == null;
         var isEmpty:Boolean = dataProvider != null && dataProvider.length == 0;
         if(isNull || isEmpty)
         {
            originalProvider = isEmpty ? dataProvider : null;
            this.dataProvider = new ArrayList([new Object()]);
            validateNow();
         }
         if(!dataGroup || dataGroup.numElements == 0)
         {
            return super.baselinePosition;
         }
         var listItem:Object = Boolean(dataGroup) ? dataGroup.getElementAt(0) : undefined;
         if(!listItem)
         {
            return super.baselinePosition;
         }
         if("baselinePosition" in listItem)
         {
            result = getSkinPartPosition(IVisualElement(listItem)).y + listItem.baselinePosition;
         }
         else
         {
            super.baselinePosition;
         }
         if(isNull || isEmpty)
         {
            if(isNull)
            {
               this.dataProvider = null;
            }
            else if(isEmpty)
            {
               this.dataProvider = originalProvider;
            }
            validateNow();
         }
         return result;
      }
      
      [Inspectable(category="Data")]
      override public function set dataProvider(value:IList) : void
      {
         if(Boolean(dataProvider))
         {
            dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.dataProvider_collectionChangeHandler);
         }
         this.dataProviderChanged = true;
         this.doingWholesaleChanges = true;
         if(Boolean(value))
         {
            value.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.dataProvider_collectionChangeHandler,false,0,true);
         }
         super.dataProvider = value;
         invalidateProperties();
      }
      
      override public function set layout(value:LayoutBase) : void
      {
         if(Boolean(value) && this.useVirtualLayout)
         {
            value.useVirtualLayout = true;
         }
         super.layout = value;
      }
      
      [Bindable("caretChange")]
      public function get caretIndex() : Number
      {
         return this._caretIndex;
      }
      
      [Inspectable(category="Data",defaultValue="label")]
      public function get labelField() : String
      {
         return this._labelField;
      }
      
      public function set labelField(value:String) : void
      {
         if(value == this._labelField)
         {
            return;
         }
         this._labelField = value;
         this.labelFieldOrFunctionChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(category="Data")]
      public function get labelFunction() : Function
      {
         return this._labelFunction;
      }
      
      public function set labelFunction(value:Function) : void
      {
         if(value == this._labelFunction)
         {
            return;
         }
         this._labelFunction = value;
         this.labelFieldOrFunctionChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(category="General",defaultValue="false")]
      public function get requireSelection() : Boolean
      {
         return this._requireSelection;
      }
      
      public function set requireSelection(value:Boolean) : void
      {
         if(value == this._requireSelection)
         {
            return;
         }
         this._requireSelection = value;
         if(value == true)
         {
            this.requireSelectionChanged = true;
            invalidateProperties();
         }
      }
      
      [Inspectable(category="General",defaultValue="-1")]
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get selectedIndex() : int
      {
         if(this._proposedSelectedIndex != NO_PROPOSED_SELECTION)
         {
            return this._proposedSelectedIndex;
         }
         return this._selectedIndex;
      }
      
      public function set selectedIndex(value:int) : void
      {
         this.setSelectedIndex(value,false);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setSelectedIndex(value:int, dispatchChangeEvent:Boolean = false, changeCaret:Boolean = true) : void
      {
         if(value == this.selectedIndex)
         {
            if(changeCaret)
            {
               this.setCurrentCaretIndex(this.selectedIndex);
            }
            return;
         }
         if(dispatchChangeEvent)
         {
            this.dispatchChangeAfterSelection = this.dispatchChangeAfterSelection || dispatchChangeEvent;
         }
         this.changeCaretOnSelection = changeCaret;
         this._proposedSelectedIndex = value;
         invalidateProperties();
      }
      
      [Inspectable(category="General",defaultValue="null")]
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get selectedItem() : *
      {
         if(this._pendingSelectedItem !== undefined)
         {
            return this._pendingSelectedItem;
         }
         if(this.allowCustomSelectedItem && this.selectedIndex == CUSTOM_SELECTED_ITEM)
         {
            return this._selectedItem;
         }
         if(this.selectedIndex == NO_SELECTION || dataProvider == null)
         {
            return undefined;
         }
         return dataProvider.length > this.selectedIndex ? dataProvider.getItemAt(this.selectedIndex) : undefined;
      }
      
      public function set selectedItem(value:*) : void
      {
         this.setSelectedItem(value,false);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setSelectedItem(value:*, dispatchChangeEvent:Boolean = false) : void
      {
         if(this.selectedItem === value)
         {
            return;
         }
         if(dispatchChangeEvent)
         {
            this.dispatchChangeAfterSelection = this.dispatchChangeAfterSelection || dispatchChangeEvent;
         }
         this._pendingSelectedItem = value;
         invalidateProperties();
      }
      
      public function get useVirtualLayout() : Boolean
      {
         return Boolean(layout) ? layout.useVirtualLayout : this._useVirtualLayout;
      }
      
      public function set useVirtualLayout(value:Boolean) : void
      {
         if(value == this.useVirtualLayout)
         {
            return;
         }
         this._useVirtualLayout = value;
         if(Boolean(layout))
         {
            layout.useVirtualLayout = value;
         }
      }
      
      override protected function initializeAccessibility() : void
      {
         if(ListBase.createAccessibilityImplementation != null)
         {
            ListBase.createAccessibilityImplementation(this);
         }
      }
      
      override protected function commitProperties() : void
      {
         var e:IndexChangeEvent = null;
         var itemIndex:int = 0;
         var n:int = 0;
         var changedSelection:Boolean = false;
         super.commitProperties();
         if(this.dataProviderChanged)
         {
            this.dataProviderChanged = false;
            this.doingWholesaleChanges = false;
            if(Boolean(this.selectedIndex >= 0) && Boolean(dataProvider) && this.selectedIndex < dataProvider.length)
            {
               this.itemSelected(this.selectedIndex,true);
            }
            else if(this.requireSelection)
            {
               this._proposedSelectedIndex = 0;
            }
            else
            {
               this.setSelectedIndex(-1,false);
            }
         }
         if(this.requireSelectionChanged)
         {
            this.requireSelectionChanged = false;
            if(Boolean(this.requireSelection && this.selectedIndex == NO_SELECTION) && Boolean(dataProvider) && dataProvider.length > 0)
            {
               this._proposedSelectedIndex = 0;
            }
         }
         if(this._pendingSelectedItem !== undefined)
         {
            if(Boolean(dataProvider))
            {
               this._proposedSelectedIndex = dataProvider.getItemIndex(this._pendingSelectedItem);
            }
            else
            {
               this._proposedSelectedIndex = NO_SELECTION;
            }
            if(this.allowCustomSelectedItem && this._proposedSelectedIndex == -1)
            {
               this._proposedSelectedIndex = CUSTOM_SELECTED_ITEM;
               this._selectedItem = this._pendingSelectedItem;
            }
            this._pendingSelectedItem = undefined;
         }
         if(this._proposedSelectedIndex != NO_PROPOSED_SELECTION)
         {
            changedSelection = this.commitSelection();
         }
         if(this.selectedIndexAdjusted)
         {
            this.selectedIndexAdjusted = false;
            if(!changedSelection)
            {
               dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
            }
         }
         if(this.caretIndexAdjusted)
         {
            this.caretIndexAdjusted = false;
            if(!changedSelection)
            {
               this.itemShowingCaret(this.selectedIndex,true);
               this._caretIndex = this.selectedIndex;
               e = new IndexChangeEvent(IndexChangeEvent.CARET_CHANGE);
               e.oldIndex = this.caretIndex;
               e.newIndex = this.caretIndex;
               dispatchEvent(e);
            }
         }
         if(this.labelFieldOrFunctionChanged)
         {
            if(Boolean(dataGroup))
            {
               if(Boolean(layout) && layout.useVirtualLayout)
               {
                  for each(itemIndex in dataGroup.getItemIndicesInView())
                  {
                     this.updateRendererLabelProperty(itemIndex);
                  }
               }
               else
               {
                  n = dataGroup.numElements;
                  for(itemIndex = 0; itemIndex < n; itemIndex++)
                  {
                     this.updateRendererLabelProperty(itemIndex);
                  }
               }
            }
            this.labelFieldOrFunctionChanged = false;
         }
      }
      
      private function updateRendererLabelProperty(itemIndex:int) : void
      {
         var renderer:IItemRenderer = dataGroup.getElementAt(itemIndex) as IItemRenderer;
         if(Boolean(renderer))
         {
            renderer.label = this.itemToLabel(renderer.data);
         }
      }
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         super.partAdded(partName,instance);
         if(instance == dataGroup)
         {
            if(Boolean(this._useVirtualLayout) && Boolean(dataGroup.layout) && dataGroup.layout.virtualLayoutSupported)
            {
               dataGroup.layout.useVirtualLayout = true;
            }
            dataGroup.addEventListener(RendererExistenceEvent.RENDERER_ADD,this.dataGroup_rendererAddHandler);
            dataGroup.addEventListener(RendererExistenceEvent.RENDERER_REMOVE,this.dataGroup_rendererRemoveHandler);
         }
      }
      
      override protected function partRemoved(partName:String, instance:Object) : void
      {
         super.partRemoved(partName,instance);
         if(instance == dataGroup)
         {
            dataGroup.removeEventListener(RendererExistenceEvent.RENDERER_ADD,this.dataGroup_rendererAddHandler);
            dataGroup.removeEventListener(RendererExistenceEvent.RENDERER_REMOVE,this.dataGroup_rendererRemoveHandler);
         }
      }
      
      override public function updateRenderer(renderer:IVisualElement, itemIndex:int, data:Object) : void
      {
         this.inUpdateRenderer = true;
         if(this.allowSelectionTransitions && !this.allowCaretTransitions)
         {
            if(renderer is ItemRenderer)
            {
               ItemRenderer(renderer).playTransitions = false;
            }
            this.itemShowingCaret(itemIndex,this.isItemIndexShowingCaret(itemIndex));
            if(renderer is ItemRenderer)
            {
               ItemRenderer(renderer).playTransitions = true;
            }
            this.itemSelected(itemIndex,this.isItemIndexSelected(itemIndex));
         }
         else
         {
            if(renderer is ItemRenderer)
            {
               ItemRenderer(renderer).playTransitions = this.allowSelectionTransitions;
            }
            this.itemSelected(itemIndex,this.isItemIndexSelected(itemIndex));
            if(renderer is ItemRenderer)
            {
               ItemRenderer(renderer).playTransitions = this.allowCaretTransitions;
            }
            this.itemShowingCaret(itemIndex,this.isItemIndexShowingCaret(itemIndex));
         }
         if(renderer is ItemRenderer)
         {
            ItemRenderer(renderer).playTransitions = true;
         }
         super.updateRenderer(renderer,itemIndex,data);
         this.inUpdateRenderer = false;
      }
      
      override public function itemToLabel(item:Object) : String
      {
         return LabelUtil.itemToLabel(item,this.labelField,this.labelFunction);
      }
      
      protected function itemSelected(index:int, selected:Boolean) : void
      {
         if(!this.inUpdateRenderer)
         {
            this.turnOnSelectionTransitionsForOneFrame();
         }
      }
      
      protected function itemShowingCaret(index:int, showsCaret:Boolean) : void
      {
         if(!this.inUpdateRenderer)
         {
            this.turnOnCaretTransitionsForOneFrame();
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function isItemIndexSelected(index:int) : Boolean
      {
         return index == this.selectedIndex;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function isItemIndexShowingCaret(index:int) : Boolean
      {
         return index == this.caretIndex;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setCurrentCaretIndex(value:Number) : void
      {
         var validIndex:Boolean = false;
         if(value == this.caretIndex)
         {
            return;
         }
         this.itemShowingCaret(this.caretIndex,false);
         this._caretIndex = value;
         if(this.caretIndex != CUSTOM_SELECTED_ITEM)
         {
            this.itemShowingCaret(this._caretIndex,true);
            validIndex = Boolean(dataProvider) && this._caretIndex >= 0 && this._caretIndex < dataProvider.length;
            this.caretItem = validIndex ? dataProvider.getItemAt(this._caretIndex) : undefined;
         }
      }
      
      protected function commitSelection(dispatchChangedEvents:Boolean = true) : Boolean
      {
         var e:IndexChangeEvent = null;
         var maxIndex:int = Boolean(dataProvider) ? int(dataProvider.length - 1) : -1;
         var oldSelectedIndex:int = this._selectedIndex;
         var oldCaretIndex:int = this._caretIndex;
         if(!this.allowCustomSelectedItem || this._proposedSelectedIndex != CUSTOM_SELECTED_ITEM)
         {
            if(this._proposedSelectedIndex < NO_SELECTION)
            {
               this._proposedSelectedIndex = NO_SELECTION;
            }
            if(this._proposedSelectedIndex > maxIndex)
            {
               this._proposedSelectedIndex = maxIndex;
            }
            if(Boolean(this.requireSelection && this._proposedSelectedIndex == NO_SELECTION) && Boolean(dataProvider) && dataProvider.length > 0)
            {
               this._proposedSelectedIndex = NO_PROPOSED_SELECTION;
               return false;
            }
         }
         var tmpProposedIndex:int = this._proposedSelectedIndex;
         if(this.dispatchChangeAfterSelection)
         {
            e = new IndexChangeEvent(IndexChangeEvent.CHANGING,false,true);
            e.oldIndex = this._selectedIndex;
            e.newIndex = this._proposedSelectedIndex;
            if(!dispatchEvent(e))
            {
               this.itemSelected(this._proposedSelectedIndex,false);
               this._proposedSelectedIndex = NO_PROPOSED_SELECTION;
               return false;
            }
         }
         this._selectedIndex = tmpProposedIndex;
         this._proposedSelectedIndex = NO_PROPOSED_SELECTION;
         if(oldSelectedIndex != NO_SELECTION)
         {
            this.itemSelected(oldSelectedIndex,false);
         }
         if(this._selectedIndex != NO_SELECTION && this._selectedIndex != CUSTOM_SELECTED_ITEM)
         {
            this.itemSelected(this._selectedIndex,true);
         }
         if(this.changeCaretOnSelection)
         {
            this.setCurrentCaretIndex(this._selectedIndex);
         }
         if(dispatchChangedEvents)
         {
            if(this.dispatchChangeAfterSelection)
            {
               e = new IndexChangeEvent(IndexChangeEvent.CHANGE);
               e.oldIndex = oldSelectedIndex;
               e.newIndex = this._selectedIndex;
               dispatchEvent(e);
               this.dispatchChangeAfterSelection = false;
            }
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
            if(this.changeCaretOnSelection)
            {
               e = new IndexChangeEvent(IndexChangeEvent.CARET_CHANGE);
               e.oldIndex = oldCaretIndex;
               e.newIndex = this.caretIndex;
               dispatchEvent(e);
            }
         }
         this.changeCaretOnSelection = true;
         return true;
      }
      
      protected function adjustSelection(newIndex:int, add:Boolean = false) : void
      {
         if(this._proposedSelectedIndex != NO_PROPOSED_SELECTION)
         {
            this._proposedSelectedIndex = newIndex;
         }
         else
         {
            this._selectedIndex = newIndex;
         }
         this.selectedIndexAdjusted = true;
         invalidateProperties();
      }
      
      protected function itemAdded(index:int) : void
      {
         if(this.doingWholesaleChanges)
         {
            return;
         }
         if(this.selectedIndex == NO_SELECTION)
         {
            if(this.requireSelection)
            {
               this.adjustSelection(index);
            }
         }
         else if(index <= this.selectedIndex)
         {
            this.adjustSelection(this.selectedIndex + 1);
         }
      }
      
      protected function itemRemoved(index:int) : void
      {
         if(this.selectedIndex == NO_SELECTION || this.doingWholesaleChanges)
         {
            return;
         }
         if(index == this.selectedIndex)
         {
            if(Boolean(this.requireSelection) && Boolean(dataProvider) && dataProvider.length > 0)
            {
               if(index == 0)
               {
                  this._proposedSelectedIndex = 0;
                  invalidateProperties();
               }
               else
               {
                  this.setSelectedIndex(0,false);
               }
            }
            else
            {
               this.adjustSelection(-1);
            }
         }
         else if(index < this.selectedIndex)
         {
            this.adjustSelection(this.selectedIndex - 1);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function dataProviderRefreshed() : void
      {
         this.setSelectedIndex(NO_SELECTION,false);
         this.setCurrentCaretIndex(NO_CARET);
      }
      
      private function turnOnSelectionTransitionsForOneFrame() : void
      {
         if(this.allowSelectionTransitions || !systemManager)
         {
            return;
         }
         this.allowSelectionTransitions = true;
         systemManager.addEventListener(Event.ENTER_FRAME,this.allowSelectionTransitions_enterFrameHandler,false,-100);
      }
      
      private function allowSelectionTransitions_enterFrameHandler(event:Event) : void
      {
         event.target.removeEventListener(Event.ENTER_FRAME,this.allowSelectionTransitions_enterFrameHandler);
         this.allowSelectionTransitions = false;
      }
      
      private function turnOnCaretTransitionsForOneFrame() : void
      {
         if(this.allowCaretTransitions || !systemManager)
         {
            return;
         }
         this.allowCaretTransitions = true;
         systemManager.addEventListener(Event.ENTER_FRAME,this.allowCaretTransitions_enterFrameHandler,false,-100);
      }
      
      private function allowCaretTransitions_enterFrameHandler(event:Event) : void
      {
         event.target.removeEventListener(Event.ENTER_FRAME,this.allowCaretTransitions_enterFrameHandler);
         this.allowCaretTransitions = false;
      }
      
      protected function dataGroup_rendererAddHandler(event:RendererExistenceEvent) : void
      {
         var renderer:IVisualElement = event.renderer;
         if(!renderer)
         {
            return;
         }
         renderer.addEventListener(MouseEvent.ROLL_OVER,this.item_mouseEventHandler);
         renderer.addEventListener(MouseEvent.ROLL_OUT,this.item_mouseEventHandler);
      }
      
      protected function dataGroup_rendererRemoveHandler(event:RendererExistenceEvent) : void
      {
         var renderer:IVisualElement = event.renderer;
         if(!renderer)
         {
            return;
         }
         renderer.removeEventListener(MouseEvent.ROLL_OVER,this.item_mouseEventHandler);
         renderer.removeEventListener(MouseEvent.ROLL_OUT,this.item_mouseEventHandler);
      }
      
      private function item_mouseEventHandler(event:MouseEvent) : void
      {
         var itemRenderer:IItemRenderer = null;
         var itemIndex:int = 0;
         var listEvent:ListEvent = null;
         var type:String = event.type;
         type = TYPE_MAP[type];
         if(hasEventListener(type))
         {
            itemRenderer = event.currentTarget as IItemRenderer;
            itemIndex = -1;
            if(Boolean(itemRenderer))
            {
               itemIndex = itemRenderer.itemIndex;
            }
            else
            {
               itemIndex = dataGroup.getElementIndex(event.currentTarget as IVisualElement);
            }
            listEvent = new ListEvent(type,false,false,event.localX,event.localY,event.relatedObject,event.ctrlKey,event.altKey,event.shiftKey,event.buttonDown,event.delta,itemIndex,dataProvider.getItemAt(itemIndex),itemRenderer);
            dispatchEvent(listEvent);
         }
      }
      
      protected function dataProvider_collectionChangeHandler(event:Event) : void
      {
         var ce:CollectionEvent = null;
         if(event is CollectionEvent)
         {
            ce = CollectionEvent(event);
            if(ce.kind == CollectionEventKind.ADD)
            {
               this.itemAdded(ce.location);
            }
            else if(ce.kind == CollectionEventKind.REMOVE)
            {
               this.itemRemoved(ce.location);
            }
            else if(ce.kind == CollectionEventKind.RESET)
            {
               if(dataProvider.length == 0)
               {
                  this.setSelectedIndex(NO_SELECTION,false);
                  this.setCurrentCaretIndex(NO_CARET);
               }
               else
               {
                  this.dataProviderChanged = true;
                  invalidateProperties();
               }
            }
            else if(ce.kind == CollectionEventKind.REFRESH)
            {
               this.dataProviderRefreshed();
            }
            else if(ce.kind == CollectionEventKind.REPLACE || ce.kind == CollectionEventKind.MOVE)
            {
            }
         }
      }
   }
}

