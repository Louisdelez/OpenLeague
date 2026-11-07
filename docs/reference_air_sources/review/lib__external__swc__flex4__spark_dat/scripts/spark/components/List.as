package spark.components
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.system.ApplicationDomain;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.core.DragSource;
   import mx.core.EventPriority;
   import mx.core.IFactory;
   import mx.core.IFlexDisplayObject;
   import mx.core.IUID;
   import mx.core.IVisualElement;
   import mx.core.InteractionMode;
   import mx.core.ScrollPolicy;
   import mx.core.UIComponentGlobals;
   import mx.events.DragEvent;
   import mx.events.FlexEvent;
   import mx.events.SandboxMouseEvent;
   import mx.events.TouchInteractionEvent;
   import mx.managers.DragManager;
   import mx.managers.IFocusManagerComponent;
   import mx.utils.ObjectUtil;
   import mx.utils.UIDUtil;
   import spark.components.supportClasses.ListBase;
   import spark.core.NavigationUnit;
   import spark.events.IndexChangeEvent;
   import spark.events.RendererExistenceEvent;
   import spark.layouts.supportClasses.DropLocation;
   
   [IconFile("List.png")]
   [DefaultTriggerEvent("change")]
   [AccessibilityClass(implementation="spark.accessibility.ListAccImpl")]
   [Style(name="verticalScrollPolicy",type="String",inherit="no",enumeration="off,on,auto")]
   [Style(name="touchDelay",type="Number",format="Time",inherit="yes",minValue="0.0")]
   [Style(name="symbolColor",type="uint",format="Color",inherit="yes",theme="spark, mobile")]
   [Style(name="selectionColor",type="uint",format="Color",inherit="yes",theme="spark, mobile")]
   [Style(name="rollOverColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="horizontalScrollPolicy",type="String",inherit="no",enumeration="off,on,auto")]
   [Style(name="dropIndicatorSkin",type="Class",inherit="no")]
   [Style(name="dragIndicatorClass",type="Class",inherit="no")]
   [Style(name="downColor",type="uint",format="Color",inherit="yes",theme="mobile")]
   [Style(name="contentBackgroundColor",type="uint",format="Color",inherit="yes",theme="spark, mobile")]
   [Style(name="contentBackgroundAlpha",type="Number",inherit="yes",theme="spark, mobile",minValue="0.0",maxValue="1.0")]
   [Style(name="borderVisible",type="Boolean",inherit="no",theme="spark, mobile")]
   [Style(name="borderColor",type="uint",format="Color",inherit="no",theme="spark, mobile")]
   [Style(name="borderAlpha",type="Number",inherit="no",theme="spark, mobile",minValue="0.0",maxValue="1.0")]
   [Style(name="alternatingItemColors",type="Array",arrayType="uint",format="Color",inherit="yes",theme="spark, mobile")]
   public class List extends ListBase implements IFocusManagerComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var _skinParts:Object = {
         "dropIndicator":false,
         "scroller":false,
         "dataGroup":false
      };
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var mouseDownPoint:Point;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var mouseDownIndex:int = -1;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var mouseDownObject:DisplayObject;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var pendingSelectionOnMouseUp:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var pendingSelectionShiftKey:Boolean;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var pendingSelectionCtrlKey:Boolean;
      
      private var richEditableTextClass:Class;
      
      [SkinPart(required="false",type="flash.display.DisplayObject")]
      public var dropIndicator:IFactory;
      
      [SkinPart(required="false")]
      public var scroller:Scroller;
      
      private var _allowMultipleSelection:Boolean = false;
      
      private var _dragEnabled:Boolean = false;
      
      private var _dragMoveEnabled:Boolean = false;
      
      private var _dropEnabled:Boolean = false;
      
      private var _selectedIndices:Vector.<int> = new Vector.<int>();
      
      private var _proposedSelectedIndices:Vector.<int> = new Vector.<int>();
      
      private var multipleSelectionChanged:Boolean;
      
      private var _pageScrollingEnabled:Boolean = false;
      
      private var _scrollSnappingMode:String = "none";
      
      public function List()
      {
         super();
         this.useVirtualLayout = true;
         if(ApplicationDomain.currentDomain.hasDefinition("spark.components.RichEditableText"))
         {
            this.richEditableTextClass = Class(ApplicationDomain.currentDomain.getDefinition("spark.components.RichEditableText"));
         }
         addEventListener(TouchInteractionEvent.TOUCH_INTERACTION_START,this.touchInteractionStartHandler);
      }
      
      override public function set hasFocusableChildren(value:Boolean) : void
      {
         super.hasFocusableChildren = value;
         if(Boolean(this.scroller))
         {
            this.scroller.hasFocusableChildren = value;
         }
      }
      
      override public function get useVirtualLayout() : Boolean
      {
         return super.useVirtualLayout;
      }
      
      override public function set useVirtualLayout(value:Boolean) : void
      {
         super.useVirtualLayout = value;
      }
      
      [Inspectable(category="Data")]
      override public function set dataProvider(value:IList) : void
      {
         if(!this.isEmpty(this._proposedSelectedIndices) || !this.isEmpty(this.selectedIndices))
         {
            this._proposedSelectedIndices.length = 0;
            this.multipleSelectionChanged = true;
            invalidateProperties();
            UIComponentGlobals.layoutManager.validateClient(this,true);
         }
         super.dataProvider = value;
      }
      
      [Inspectable(category="General",defaultValue="false")]
      public function get allowMultipleSelection() : Boolean
      {
         return this._allowMultipleSelection;
      }
      
      public function set allowMultipleSelection(value:Boolean) : void
      {
         if(value == this._allowMultipleSelection)
         {
            return;
         }
         this._allowMultipleSelection = value;
      }
      
      [Inspectable(defaultValue="false")]
      public function get dragEnabled() : Boolean
      {
         return this._dragEnabled;
      }
      
      public function set dragEnabled(value:Boolean) : void
      {
         if(value == this._dragEnabled)
         {
            return;
         }
         this._dragEnabled = value;
         if(this._dragEnabled)
         {
            addEventListener(DragEvent.DRAG_START,this.dragStartHandler,false,EventPriority.DEFAULT_HANDLER);
            addEventListener(DragEvent.DRAG_COMPLETE,this.dragCompleteHandler,false,EventPriority.DEFAULT_HANDLER);
         }
         else
         {
            removeEventListener(DragEvent.DRAG_START,this.dragStartHandler,false);
            removeEventListener(DragEvent.DRAG_COMPLETE,this.dragCompleteHandler,false);
         }
      }
      
      [Inspectable(defaultValue="false")]
      public function get dragMoveEnabled() : Boolean
      {
         return this._dragMoveEnabled;
      }
      
      public function set dragMoveEnabled(value:Boolean) : void
      {
         this._dragMoveEnabled = value;
      }
      
      [Inspectable(defaultValue="false")]
      public function get dropEnabled() : Boolean
      {
         return this._dropEnabled;
      }
      
      public function set dropEnabled(value:Boolean) : void
      {
         if(value == this._dropEnabled)
         {
            return;
         }
         this._dropEnabled = value;
         if(this._dropEnabled)
         {
            addEventListener(DragEvent.DRAG_ENTER,this.dragEnterHandler,false,EventPriority.DEFAULT_HANDLER);
            addEventListener(DragEvent.DRAG_EXIT,this.dragExitHandler,false,EventPriority.DEFAULT_HANDLER);
            addEventListener(DragEvent.DRAG_OVER,this.dragOverHandler,false,EventPriority.DEFAULT_HANDLER);
            addEventListener(DragEvent.DRAG_DROP,this.dragDropHandler,false,EventPriority.DEFAULT_HANDLER);
         }
         else
         {
            removeEventListener(DragEvent.DRAG_ENTER,this.dragEnterHandler,false);
            removeEventListener(DragEvent.DRAG_EXIT,this.dragExitHandler,false);
            removeEventListener(DragEvent.DRAG_OVER,this.dragOverHandler,false);
            removeEventListener(DragEvent.DRAG_DROP,this.dragDropHandler,false);
         }
      }
      
      [Inspectable(category="General")]
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get selectedIndices() : Vector.<int>
      {
         return this._selectedIndices;
      }
      
      public function set selectedIndices(value:Vector.<int>) : void
      {
         this.setSelectedIndices(value,false);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setSelectedIndices(value:Vector.<int>, dispatchChangeEvent:Boolean = false, changeCaret:Boolean = true) : void
      {
         if(this._proposedSelectedIndices == value || Boolean(value && value.length == 1 && this.selectedIndices && this.selectedIndices.length == 1) && Boolean(value[0] == this.selectedIndices[0]))
         {
            if(changeCaret)
            {
               setCurrentCaretIndex(selectedIndex);
            }
            return;
         }
         if(dispatchChangeEvent)
         {
            dispatchChangeAfterSelection = dispatchChangeAfterSelection || dispatchChangeEvent;
         }
         if(Boolean(value))
         {
            this._proposedSelectedIndices = value;
         }
         else
         {
            this._proposedSelectedIndices = new Vector.<int>();
         }
         this.multipleSelectionChanged = true;
         changeCaretOnSelection = changeCaret;
         invalidateProperties();
      }
      
      [Inspectable(category="General")]
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get selectedItems() : Vector.<Object>
      {
         var count:int = 0;
         var i:int = 0;
         var result:Vector.<Object> = new Vector.<Object>();
         if(Boolean(this.selectedIndices))
         {
            count = int(this.selectedIndices.length);
            for(i = 0; i < count; i++)
            {
               result[i] = dataProvider.getItemAt(this.selectedIndices[i]);
            }
         }
         return result;
      }
      
      public function set selectedItems(value:Vector.<Object>) : void
      {
         var count:int = 0;
         var i:int = 0;
         var index:int = 0;
         var indices:Vector.<int> = new Vector.<int>();
         if(Boolean(value))
         {
            count = int(value.length);
            for(i = 0; i < count; i++)
            {
               index = int(dataProvider.getItemIndex(value[i]));
               if(index != -1)
               {
                  indices.splice(0,0,index);
               }
               if(index == -1)
               {
                  indices = new Vector.<int>();
                  break;
               }
            }
         }
         this._proposedSelectedIndices = indices;
         this.multipleSelectionChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(category="General",defaultValue="false")]
      public function get pageScrollingEnabled() : Boolean
      {
         if(Boolean(this.scroller))
         {
            return this.scroller.pageScrollingEnabled;
         }
         return this._pageScrollingEnabled;
      }
      
      public function set pageScrollingEnabled(value:Boolean) : void
      {
         if(Boolean(this.scroller))
         {
            this.scroller.pageScrollingEnabled = value;
         }
         this._pageScrollingEnabled = value;
      }
      
      [Inspectable(category="General",enumeration="none,leadingEdge,center,trailingEdge",defaultValue="none")]
      public function get scrollSnappingMode() : String
      {
         if(Boolean(this.scroller))
         {
            return this.scroller.scrollSnappingMode;
         }
         return this._scrollSnappingMode;
      }
      
      public function set scrollSnappingMode(value:String) : void
      {
         if(Boolean(this.scroller))
         {
            this.scroller.scrollSnappingMode = value;
         }
         this._scrollSnappingMode = value;
      }
      
      override protected function initializeAccessibility() : void
      {
         if(List.createAccessibilityImplementation != null)
         {
            List.createAccessibilityImplementation(this);
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.multipleSelectionChanged)
         {
            this.commitSelection();
         }
      }
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         var vsp:String = null;
         var hsp:String = null;
         super.partAdded(partName,instance);
         if(instance == this.scroller)
         {
            this.scroller.hasFocusableChildren = hasFocusableChildren;
            vsp = getStyle("verticalScrollPolicy");
            if(Boolean(vsp) && vsp !== ScrollPolicy.AUTO)
            {
               this.scroller.setStyle("verticalScrollPolicy",vsp);
            }
            hsp = getStyle("horizontalScrollPolicy");
            if(Boolean(hsp) && hsp !== ScrollPolicy.AUTO)
            {
               this.scroller.setStyle("horizontalScrollPolicy",hsp);
            }
            this.scroller.pageScrollingEnabled = this._pageScrollingEnabled;
            this.scroller.scrollSnappingMode = this._scrollSnappingMode;
         }
      }
      
      override protected function itemAdded(index:int) : void
      {
         this.adjustSelection(index,true);
      }
      
      override protected function itemRemoved(index:int) : void
      {
         this.adjustSelection(index,false);
      }
      
      private function isValidIndex(item:int, index:int, v:Vector.<int>) : Boolean
      {
         return dataProvider != null && item >= 0 && item < dataProvider.length;
      }
      
      override protected function commitSelection(dispatchChangedEvents:Boolean = true) : Boolean
      {
         var temp:Vector.<int> = null;
         var e:IndexChangeEvent = null;
         this.multipleSelectionChanged = false;
         var oldSelectedIndex:Number = _selectedIndex;
         var oldCaretIndex:Number = _caretIndex;
         this._proposedSelectedIndices = this._proposedSelectedIndices.filter(this.isValidIndex);
         if(!this.allowMultipleSelection && !this.isEmpty(this._proposedSelectedIndices))
         {
            temp = new Vector.<int>();
            temp.push(this._proposedSelectedIndices[0]);
            this._proposedSelectedIndices = temp;
         }
         if(!this.isEmpty(this._proposedSelectedIndices))
         {
            _proposedSelectedIndex = this.getFirstItemValue(this._proposedSelectedIndices);
         }
         var currentChangeCaretOnSelection:Boolean = changeCaretOnSelection;
         var retVal:Boolean = super.commitSelection(false);
         if(!retVal)
         {
            return false;
         }
         if(selectedIndex > NO_SELECTION)
         {
            if(Boolean(this._proposedSelectedIndices) && this._proposedSelectedIndices.indexOf(selectedIndex) == -1)
            {
               this._proposedSelectedIndices.push(selectedIndex);
            }
         }
         this.commitMultipleSelection();
         if(currentChangeCaretOnSelection)
         {
            setCurrentCaretIndex(selectedIndex);
         }
         if(dispatchChangedEvents && retVal)
         {
            if(dispatchChangeAfterSelection)
            {
               e = new IndexChangeEvent(IndexChangeEvent.CHANGE);
               e.oldIndex = oldSelectedIndex;
               e.newIndex = _selectedIndex;
               dispatchEvent(e);
               dispatchChangeAfterSelection = false;
            }
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
            if(currentChangeCaretOnSelection)
            {
               e = new IndexChangeEvent(IndexChangeEvent.CARET_CHANGE);
               e.oldIndex = oldCaretIndex;
               e.newIndex = caretIndex;
               dispatchEvent(e);
            }
         }
         return retVal;
      }
      
      protected function commitMultipleSelection() : void
      {
         var i:int = 0;
         var count:int = 0;
         var removedItems:Vector.<int> = new Vector.<int>();
         var addedItems:Vector.<int> = new Vector.<int>();
         if(!this.isEmpty(this._selectedIndices) && !this.isEmpty(this._proposedSelectedIndices))
         {
            count = int(this._proposedSelectedIndices.length);
            for(i = 0; i < count; i++)
            {
               if(this._selectedIndices.indexOf(this._proposedSelectedIndices[i]) < 0)
               {
                  addedItems.push(this._proposedSelectedIndices[i]);
               }
            }
            count = int(this._selectedIndices.length);
            for(i = 0; i < count; i++)
            {
               if(this._proposedSelectedIndices.indexOf(this._selectedIndices[i]) < 0)
               {
                  removedItems.push(this._selectedIndices[i]);
               }
            }
         }
         else if(!this.isEmpty(this._selectedIndices))
         {
            removedItems = this._selectedIndices;
         }
         else if(!this.isEmpty(this._proposedSelectedIndices))
         {
            addedItems = this._proposedSelectedIndices;
         }
         this._selectedIndices = this._proposedSelectedIndices;
         if(removedItems.length > 0)
         {
            count = int(removedItems.length);
            for(i = 0; i < count; i++)
            {
               this.itemSelected(removedItems[i],false);
            }
         }
         if(!this.isEmpty(this._proposedSelectedIndices))
         {
            count = int(this._proposedSelectedIndices.length);
            for(i = 0; i < count; i++)
            {
               this.itemSelected(this._proposedSelectedIndices[i],true);
            }
         }
         this._proposedSelectedIndices = new Vector.<int>();
      }
      
      override protected function itemSelected(index:int, selected:Boolean) : void
      {
         super.itemSelected(index,selected);
         var renderer:Object = Boolean(dataGroup) ? dataGroup.getElementAt(index) : null;
         if(renderer is IItemRenderer)
         {
            IItemRenderer(renderer).selected = selected;
         }
      }
      
      override protected function itemShowingCaret(index:int, showsCaret:Boolean) : void
      {
         super.itemShowingCaret(index,showsCaret);
         var renderer:Object = Boolean(dataGroup) ? dataGroup.getElementAt(index) : null;
         if(renderer is IItemRenderer)
         {
            IItemRenderer(renderer).showsCaret = showsCaret;
         }
      }
      
      private function ensureCaretVisibility(newCaretIndex:int) : void
      {
         setSelectedIndex(newCaretIndex,false);
         this.ensureIndexIsVisible(newCaretIndex);
      }
      
      private function restoreCaretScrollPosition(newCaretIndex:int, offsetX:Number, offsetY:Number) : void
      {
         var caretItemRenderer:IVisualElement = dataGroup.getElementAt(newCaretIndex);
         if(!caretItemRenderer)
         {
            return;
         }
         var newOffsetX:Number = caretItemRenderer.getLayoutBoundsX() - dataGroup.horizontalScrollPosition;
         var newOffsetY:Number = caretItemRenderer.getLayoutBoundsY() - dataGroup.verticalScrollPosition;
         dataGroup.verticalScrollPosition += newOffsetY - offsetY;
         dataGroup.horizontalScrollPosition += newOffsetX - offsetX;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function dataProviderRefreshed() : void
      {
         var newCaretIndex:int = 0;
         var caretItemRenderer:IVisualElement = null;
         var caretItemRendererX:Number = NaN;
         var caretItemRendererY:Number = NaN;
         var caretOffsetX:Number = NaN;
         var caretOffsetY:Number = NaN;
         var updateCompleteListenerA:Function = null;
         var updateCompleteListenerB:Function = null;
         if(Boolean(caretItem !== undefined) && Boolean(dataGroup) && Boolean(dataGroup.dataProvider))
         {
            newCaretIndex = int(dataGroup.dataProvider.getItemIndex(caretItem));
            caretItemRenderer = dataGroup.getElementAt(caretIndex);
            if(newCaretIndex != -1 && dataGroup.isElementVisible(caretItemRenderer))
            {
               caretItemRendererX = Number(caretItemRenderer.getLayoutBoundsX());
               caretItemRendererY = Number(caretItemRenderer.getLayoutBoundsY());
               caretOffsetX = caretItemRendererX - dataGroup.horizontalScrollPosition;
               caretOffsetY = caretItemRendererY - dataGroup.verticalScrollPosition;
               updateCompleteListenerA = function():void
               {
                  dataGroup.removeEventListener(FlexEvent.UPDATE_COMPLETE,updateCompleteListenerA);
                  ensureCaretVisibility(newCaretIndex);
                  dataGroup.addEventListener(FlexEvent.UPDATE_COMPLETE,updateCompleteListenerB);
               };
               updateCompleteListenerB = function():void
               {
                  dataGroup.removeEventListener(FlexEvent.UPDATE_COMPLETE,updateCompleteListenerB);
                  restoreCaretScrollPosition(newCaretIndex,caretOffsetX,caretOffsetY);
               };
               dataGroup.addEventListener(FlexEvent.UPDATE_COMPLETE,updateCompleteListenerA);
               return;
            }
         }
         super.dataProviderRefreshed();
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function isItemIndexSelected(index:int) : Boolean
      {
         if(this.allowMultipleSelection && this.selectedIndices != null)
         {
            return this.selectedIndices.indexOf(index) != -1;
         }
         return super.isItemIndexSelected(index);
      }
      
      override public function styleChanged(styleName:String) : void
      {
         var vsp:String = null;
         var hsp:String = null;
         super.styleChanged(styleName);
         var allStyles:Boolean = styleName == null || styleName == "styleName";
         if(Boolean(this.scroller))
         {
            vsp = getStyle("verticalScrollPolicy");
            if(styleName == "verticalScrollPolicy")
            {
               this.scroller.setStyle("verticalScrollPolicy",vsp);
            }
            else if(Boolean(allStyles) && Boolean(vsp) && vsp !== ScrollPolicy.AUTO)
            {
               this.scroller.setStyle("verticalScrollPolicy",vsp);
            }
            hsp = getStyle("horizontalScrollPolicy");
            if(styleName == "horizontalScrollPolicy")
            {
               this.scroller.setStyle("horizontalScrollPolicy",hsp);
            }
            else if(Boolean(allStyles) && Boolean(hsp) && hsp !== ScrollPolicy.AUTO)
            {
               this.scroller.setStyle("horizontalScrollPolicy",hsp);
            }
         }
      }
      
      private function getLastSelectedIndex() : int
      {
         if(Boolean(this.selectedIndices) && this.selectedIndices.length > 0)
         {
            return this.selectedIndices[this.selectedIndices.length - 1];
         }
         return 0;
      }
      
      private function getFirstItemValue(v:Vector.<int>) : int
      {
         if(Boolean(v) && v.length > 0)
         {
            return v[0];
         }
         return -1;
      }
      
      private function isEmpty(v:Vector.<int>) : Boolean
      {
         return v == null || v.length == 0;
      }
      
      protected function calculateSelectedIndices(index:int, shiftKey:Boolean, ctrlKey:Boolean) : Vector.<int>
      {
         var i:int = 0;
         var found:Boolean = false;
         var start:int = 0;
         var end:int = 0;
         var interval:Vector.<int> = new Vector.<int>();
         if(!shiftKey)
         {
            if(ctrlKey || getStyle("interactionMode") == InteractionMode.TOUCH)
            {
               if(!this.isEmpty(this.selectedIndices))
               {
                  if(this.selectedIndices.length == 1 && this.selectedIndices[0] == index)
                  {
                     if(!requireSelection)
                     {
                        return interval;
                     }
                     interval.splice(0,0,this.selectedIndices[0]);
                     return interval;
                  }
                  found = false;
                  for(i = 0; i < this._selectedIndices.length; i++)
                  {
                     if(this._selectedIndices[i] == index)
                     {
                        found = true;
                     }
                     else if(this._selectedIndices[i] != index)
                     {
                        interval.splice(0,0,this._selectedIndices[i]);
                     }
                  }
                  if(!found)
                  {
                     interval.splice(0,0,index);
                  }
                  return interval;
               }
               interval.splice(0,0,index);
               return interval;
            }
            interval.splice(0,0,index);
            return interval;
         }
         start = !this.isEmpty(this.selectedIndices) ? this.selectedIndices[this.selectedIndices.length - 1] : 0;
         end = index;
         if(start < end)
         {
            for(i = start; i <= end; i++)
            {
               interval.splice(0,0,i);
            }
         }
         else
         {
            for(i = start; i >= end; i--)
            {
               interval.splice(0,0,i);
            }
         }
         return interval;
      }
      
      protected function dragStartHandler(event:DragEvent) : void
      {
         if(event.isDefaultPrevented())
         {
            return;
         }
         var dragSource:DragSource = new DragSource();
         this.addDragData(dragSource);
         DragManager.doDrag(this,dragSource,event,this.createDragIndicator(),0,0,0.5,this.dragMoveEnabled);
      }
      
      private function compareValues(a:int, b:int) : int
      {
         return a - b;
      }
      
      protected function dragCompleteHandler(event:DragEvent) : void
      {
         if(event.isDefaultPrevented())
         {
            return;
         }
         if(!this.dragMoveEnabled || event.action != DragManager.MOVE || event.relatedObject == this)
         {
            return;
         }
         var movedIndices:Vector.<int> = this.selectedIndices;
         this.setSelectedIndices(new Vector.<int>(),true);
         validateProperties();
         movedIndices.sort(this.compareValues);
         var count:int = int(movedIndices.length);
         for(var i:int = count - 1; i >= 0; i--)
         {
            dataProvider.removeItemAt(movedIndices[i]);
         }
      }
      
      public function createDragIndicator() : IFlexDisplayObject
      {
         var dragIndicator:IFlexDisplayObject = null;
         var dragIndicatorClass:Class = Class(getStyle("dragIndicatorClass"));
         if(Boolean(dragIndicatorClass))
         {
            dragIndicator = new dragIndicatorClass();
            if(dragIndicator is IVisualElement)
            {
               IVisualElement(dragIndicator).owner = this;
            }
         }
         return dragIndicator;
      }
      
      public function addDragData(dragSource:DragSource) : void
      {
         dragSource.addHandler(this.copySelectedItemsForDragDrop,"itemsByIndex");
         var caretIndex:int = 0;
         var draggedIndices:Vector.<int> = this.selectedIndices;
         var count:int = int(draggedIndices.length);
         for(var i:int = 0; i < count; i++)
         {
            if(this.mouseDownIndex > draggedIndices[i])
            {
               caretIndex++;
            }
         }
         dragSource.addData(caretIndex,"caretIndex");
      }
      
      private function copySelectedItemsForDragDrop() : Vector.<Object>
      {
         var draggedIndices:Vector.<int> = this.selectedIndices.slice(0,this.selectedIndices.length);
         var result:Vector.<Object> = new Vector.<Object>(draggedIndices.length);
         draggedIndices.sort(this.compareValues);
         var count:int = int(draggedIndices.length);
         for(var i:int = 0; i < count; i++)
         {
            result[i] = dataProvider.getItemAt(draggedIndices[i]);
         }
         return result;
      }
      
      protected function item_mouseDownHandler(event:MouseEvent) : void
      {
         var newIndex:int = 0;
         if(event.isDefaultPrevented())
         {
            return;
         }
         if(event.currentTarget is IItemRenderer)
         {
            newIndex = IItemRenderer(event.currentTarget).itemIndex;
         }
         else
         {
            newIndex = dataGroup.getElementIndex(event.currentTarget as IVisualElement);
         }
         if(!this.allowMultipleSelection)
         {
            if(event.ctrlKey && selectedIndex == newIndex || getStyle("interactionMode") == InteractionMode.TOUCH)
            {
               if(!this.dragEnabled && getStyle("interactionMode") != InteractionMode.TOUCH)
               {
                  setSelectedIndex(NO_SELECTION,true);
               }
               else
               {
                  this.pendingSelectionOnMouseUp = true;
                  this.pendingSelectionCtrlKey = event.ctrlKey;
                  this.pendingSelectionShiftKey = event.shiftKey;
               }
            }
            else
            {
               setSelectedIndex(newIndex,true);
            }
         }
         else if(this.isItemIndexSelected(newIndex) || getStyle("interactionMode") == InteractionMode.TOUCH)
         {
            this.pendingSelectionOnMouseUp = true;
            this.pendingSelectionShiftKey = event.shiftKey;
            this.pendingSelectionCtrlKey = event.ctrlKey;
         }
         else
         {
            this.setSelectedIndices(this.calculateSelectedIndices(newIndex,event.shiftKey,event.ctrlKey),true);
         }
         if(!this.pendingSelectionOnMouseUp)
         {
            validateProperties();
         }
         this.mouseDownPoint = event.target.localToGlobal(new Point(event.localX,event.localY));
         this.mouseDownObject = event.target as DisplayObject;
         this.mouseDownIndex = newIndex;
         var listenForDrag:Boolean = this.dragEnabled && getStyle("interactionMode") == InteractionMode.MOUSE && Boolean(this.selectedIndices) && this.selectedIndices.indexOf(newIndex) != -1;
         if(listenForDrag)
         {
            systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler,false,0,true);
         }
         if(this.pendingSelectionOnMouseUp || listenForDrag)
         {
            systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.mouseUpHandler,false,0,true);
            systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler,false,0,true);
         }
      }
      
      protected function mouseMoveHandler(event:MouseEvent) : void
      {
         var dragEvent:DragEvent = null;
         var localMouseDownPoint:Point = null;
         if(!this.mouseDownPoint || !this.dragEnabled)
         {
            return;
         }
         var pt:Point = new Point(event.localX,event.localY);
         pt = DisplayObject(event.target).localToGlobal(pt);
         var DRAG_THRESHOLD:int = 5;
         if(Math.abs(this.mouseDownPoint.x - pt.x) > DRAG_THRESHOLD || Math.abs(this.mouseDownPoint.y - pt.y) > DRAG_THRESHOLD)
         {
            dragEvent = new DragEvent(DragEvent.DRAG_START);
            dragEvent.dragInitiator = this;
            localMouseDownPoint = this.globalToLocal(this.mouseDownPoint);
            dragEvent.localX = localMouseDownPoint.x;
            dragEvent.localY = localMouseDownPoint.y;
            dragEvent.buttonDown = true;
            dispatchEvent(dragEvent);
            this.removeMouseHandlersForDragStart(event);
         }
      }
      
      private function removeMouseHandlersForDragStart(event:Event) : void
      {
         var selectionChange:Boolean = false;
         if(this.pendingSelectionOnMouseUp && !DragManager.isDragging)
         {
            if(getStyle("interactionMode") == InteractionMode.TOUCH)
            {
               selectionChange = event.target == this.mouseDownObject || this.mouseDownObject is DisplayObjectContainer && DisplayObjectContainer(this.mouseDownObject).contains(event.target as DisplayObject);
               if(selectionChange)
               {
                  if(this.allowMultipleSelection)
                  {
                     this.setSelectedIndices(this.calculateSelectedIndices(this.mouseDownIndex,this.pendingSelectionShiftKey,this.pendingSelectionCtrlKey),true);
                  }
                  else
                  {
                     setSelectedIndex(this.mouseDownIndex,true);
                  }
               }
            }
            else if(this.allowMultipleSelection)
            {
               this.setSelectedIndices(this.calculateSelectedIndices(this.mouseDownIndex,this.pendingSelectionShiftKey,this.pendingSelectionCtrlKey),true);
            }
            else
            {
               setSelectedIndex(NO_SELECTION,true);
            }
         }
         this.pendingSelectionOnMouseUp = false;
         this.mouseDownPoint = null;
         this.mouseDownObject = null;
         this.mouseDownIndex = -1;
         systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler,false);
         systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler,false);
         systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.mouseUpHandler,false);
      }
      
      protected function mouseUpHandler(event:Event) : void
      {
         this.removeMouseHandlersForDragStart(event);
      }
      
      private function calculateDropLocation(event:DragEvent) : DropLocation
      {
         if(!enabled || !event.dragSource.hasFormat("itemsByIndex"))
         {
            return null;
         }
         return layout.calculateDropLocation(event);
      }
      
      public function createDropIndicator() : DisplayObject
      {
         var dropIndicatorInstance:DisplayObject = null;
         var dropIndicatorClass:Class = null;
         if(Boolean(layout.dropIndicator))
         {
            return layout.dropIndicator;
         }
         if(Boolean(this.dropIndicator))
         {
            dropIndicatorInstance = DisplayObject(createDynamicPartInstance("dropIndicator"));
         }
         else
         {
            dropIndicatorClass = Class(getStyle("dropIndicatorSkin"));
            if(Boolean(dropIndicatorClass))
            {
               dropIndicatorInstance = new dropIndicatorClass();
            }
         }
         if(dropIndicatorInstance is IVisualElement)
         {
            IVisualElement(dropIndicatorInstance).owner = this;
         }
         layout.dropIndicator = dropIndicatorInstance;
         return dropIndicatorInstance;
      }
      
      public function destroyDropIndicator() : DisplayObject
      {
         var dropIndicatorInstance:DisplayObject = layout.dropIndicator;
         if(!dropIndicatorInstance)
         {
            return null;
         }
         layout.dropIndicator = null;
         var count:int = numDynamicParts("dropIndicator");
         for(var i:int = 0; i < count; i++)
         {
            if(dropIndicatorInstance == getDynamicPartAt("dropIndicator",i))
            {
               removeDynamicPartInstance("dropIndicator",dropIndicatorInstance);
               break;
            }
         }
         return dropIndicatorInstance;
      }
      
      protected function dragEnterHandler(event:DragEvent) : void
      {
         if(event.isDefaultPrevented())
         {
            return;
         }
         var dropLocation:DropLocation = this.calculateDropLocation(event);
         if(Boolean(dropLocation))
         {
            DragManager.acceptDragDrop(this);
            this.createDropIndicator();
            drawFocusAnyway = true;
            drawFocus(true);
            DragManager.showFeedback(event.ctrlKey ? DragManager.COPY : DragManager.MOVE);
            layout.showDropIndicator(dropLocation);
         }
         else
         {
            DragManager.showFeedback(DragManager.NONE);
         }
      }
      
      protected function dragOverHandler(event:DragEvent) : void
      {
         if(event.isDefaultPrevented())
         {
            return;
         }
         var dropLocation:DropLocation = this.calculateDropLocation(event);
         if(Boolean(dropLocation))
         {
            drawFocusAnyway = true;
            drawFocus(true);
            DragManager.showFeedback(event.ctrlKey ? DragManager.COPY : DragManager.MOVE);
            layout.showDropIndicator(dropLocation);
         }
         else
         {
            layout.hideDropIndicator();
            drawFocus(false);
            drawFocusAnyway = false;
            DragManager.showFeedback(DragManager.NONE);
         }
      }
      
      protected function dragExitHandler(event:DragEvent) : void
      {
         if(event.isDefaultPrevented())
         {
            return;
         }
         layout.hideDropIndicator();
         drawFocus(false);
         drawFocusAnyway = false;
         this.destroyDropIndicator();
      }
      
      private function touchInteractionStartHandler(event:TouchInteractionEvent) : void
      {
         this.mouseDownIndex = -1;
         this.mouseDownObject = null;
         this.mouseDownPoint = null;
         this.pendingSelectionOnMouseUp = false;
      }
      
      protected function dragDropHandler(event:DragEvent) : void
      {
         var i:int = 0;
         var item:Object = null;
         var delta:Point = null;
         var loopCount:int = 0;
         if(event.isDefaultPrevented())
         {
            return;
         }
         layout.hideDropIndicator();
         this.destroyDropIndicator();
         drawFocus(false);
         drawFocusAnyway = false;
         var dropLocation:DropLocation = this.calculateDropLocation(event);
         if(!dropLocation)
         {
            return;
         }
         var dropIndex:int = dropLocation.dropIndex;
         DragManager.showFeedback(event.ctrlKey ? DragManager.COPY : DragManager.MOVE);
         var dragSource:DragSource = event.dragSource;
         var items:Vector.<Object> = dragSource.dataForFormat("itemsByIndex") as Vector.<Object>;
         var caretIndex:int = -1;
         if(dragSource.hasFormat("caretIndex"))
         {
            caretIndex = event.dragSource.dataForFormat("caretIndex") as int;
         }
         var indices:Vector.<int> = this.selectedIndices;
         this.setSelectedIndices(new Vector.<int>(),false);
         validateProperties();
         if(this.dragMoveEnabled && event.action == DragManager.MOVE && event.dragInitiator == this)
         {
            indices.sort(this.compareValues);
            for(i = indices.length - 1; i >= 0; i--)
            {
               if(indices[i] < dropIndex)
               {
                  dropIndex--;
               }
               dataProvider.removeItemAt(indices[i]);
            }
         }
         var newSelection:Vector.<int> = new Vector.<int>();
         if(caretIndex != -1)
         {
            newSelection.push(dropIndex + caretIndex);
         }
         if(!dataProvider)
         {
            this.dataProvider = new ArrayCollection();
         }
         var copyItems:Boolean = event.action == DragManager.COPY;
         for(i = 0; i < items.length; i++)
         {
            item = items[i];
            if(copyItems)
            {
               item = this.copyItemWithUID(item);
            }
            dataProvider.addItemAt(item,dropIndex + i);
            if(i != caretIndex)
            {
               newSelection.push(dropIndex + i);
            }
         }
         this.setSelectedIndices(newSelection,false);
         if(caretIndex != -1)
         {
            loopCount = 0;
            while(loopCount++ < 10)
            {
               validateNow();
               delta = layout.getScrollPositionDeltaToElement(dropIndex + caretIndex);
               if(!delta || delta.x == 0 && delta.y == 0)
               {
                  break;
               }
               layout.horizontalScrollPosition += delta.x;
               layout.verticalScrollPosition += delta.y;
            }
         }
      }
      
      protected function copyItemWithUID(item:Object) : Object
      {
         var copyObj:Object = ObjectUtil.copy(item);
         if(copyObj is IUID)
         {
            IUID(copyObj).uid = UIDUtil.createUID();
         }
         else if(copyObj is Object && "mx_internal_uid" in copyObj)
         {
            copyObj.mx_internal_uid = UIDUtil.createUID();
         }
         return copyObj;
      }
      
      override protected function dataGroup_rendererAddHandler(event:RendererExistenceEvent) : void
      {
         super.dataGroup_rendererAddHandler(event);
         var renderer:IVisualElement = event.renderer;
         if(!renderer)
         {
            return;
         }
         renderer.addEventListener(MouseEvent.MOUSE_DOWN,this.item_mouseDownHandler);
      }
      
      override protected function dataGroup_rendererRemoveHandler(event:RendererExistenceEvent) : void
      {
         super.dataGroup_rendererRemoveHandler(event);
         var renderer:Object = event.renderer;
         if(!renderer)
         {
            return;
         }
         renderer.removeEventListener(MouseEvent.MOUSE_DOWN,this.item_mouseDownHandler);
      }
      
      public function ensureIndexIsVisible(index:int) : void
      {
         if(!layout)
         {
            return;
         }
         var spDelta:Point = dataGroup.layout.getScrollPositionDeltaToElement(index);
         if(Boolean(spDelta))
         {
            dataGroup.horizontalScrollPosition += spDelta.x;
            dataGroup.verticalScrollPosition += spDelta.y;
         }
      }
      
      override protected function adjustSelection(index:int, add:Boolean = false) : void
      {
         var i:int = 0;
         var curr:Number = NaN;
         var e:IndexChangeEvent = null;
         var oldIndex:Number = NaN;
         var newInterval:Vector.<int> = new Vector.<int>();
         if(selectedIndex == NO_SELECTION || doingWholesaleChanges)
         {
            if(Boolean(dataProvider) && Boolean(dataProvider.length == 1) && requireSelection)
            {
               newInterval.push(0);
               this._selectedIndices = newInterval;
               _selectedIndex = 0;
               this.itemShowingCaret(0,true);
               dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
               e = new IndexChangeEvent(IndexChangeEvent.CARET_CHANGE);
               e.oldIndex = -1;
               e.newIndex = _caretIndex;
               dispatchEvent(e);
            }
            return;
         }
         if(!this.selectedIndices && selectedIndex > NO_SELECTION || selectedIndex > NO_SELECTION && this.selectedIndices.indexOf(selectedIndex) == -1)
         {
            this.commitSelection();
         }
         if(add)
         {
            for(i = 0; i < this.selectedIndices.length; i++)
            {
               curr = this.selectedIndices[i];
               if(curr >= index)
               {
                  newInterval.push(curr + 1);
               }
               else
               {
                  newInterval.push(curr);
               }
            }
         }
         else if(!this.isEmpty(this.selectedIndices) && this.selectedIndices.length == 1 && index == selectedIndex && requireSelection)
         {
            if(dataProvider.length == 0)
            {
               newInterval = new Vector.<int>();
            }
            else
            {
               _proposedSelectedIndex = 0;
               invalidateProperties();
               if(index == 0)
               {
                  return;
               }
               newInterval.push(0);
            }
         }
         else
         {
            for(i = 0; i < this.selectedIndices.length; i++)
            {
               curr = this.selectedIndices[i];
               if(curr > index)
               {
                  newInterval.push(curr - 1);
               }
               else if(curr < index)
               {
                  newInterval.push(curr);
               }
            }
         }
         if(caretIndex == selectedIndex)
         {
            oldIndex = caretIndex;
            _caretIndex = this.getFirstItemValue(newInterval);
            e = new IndexChangeEvent(IndexChangeEvent.CARET_CHANGE);
            e.oldIndex = oldIndex;
            e.newIndex = caretIndex;
            dispatchEvent(e);
         }
         else
         {
            this.itemShowingCaret(caretIndex,false);
            caretIndexAdjusted = true;
            invalidateProperties();
         }
         var oldIndices:Vector.<int> = this.selectedIndices;
         this._selectedIndices = newInterval;
         _selectedIndex = this.getFirstItemValue(newInterval);
         if(this._selectedIndices != oldIndices)
         {
            selectedIndexAdjusted = true;
            invalidateProperties();
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function findKey(eventCode:int) : Boolean
      {
         var tmpCode:int = eventCode;
         return tmpCode >= 33 && tmpCode <= 126 && this.findString(String.fromCharCode(tmpCode));
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function findString(str:String) : Boolean
      {
         var startIndex:int = 0;
         var stopIndex:int = 0;
         var retVal:Number = NaN;
         if(!dataProvider || dataProvider.length == 0)
         {
            return false;
         }
         if(selectedIndex == NO_SELECTION || selectedIndex == CUSTOM_SELECTED_ITEM)
         {
            startIndex = 0;
            stopIndex = int(dataProvider.length);
            retVal = this.findStringLoop(str,startIndex,stopIndex);
         }
         else
         {
            startIndex = selectedIndex + 1;
            stopIndex = int(dataProvider.length);
            retVal = this.findStringLoop(str,startIndex,stopIndex);
            if(retVal == -1)
            {
               retVal = this.findStringLoop(str,0,selectedIndex);
            }
         }
         if(retVal != -1)
         {
            setSelectedIndex(retVal,true);
            this.ensureIndexIsVisible(retVal);
            return true;
         }
         return false;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function findStringLoop(str:String, startIndex:int, stopIndex:int) : Number
      {
         for(var itmStr:String = null; startIndex != stopIndex; )
         {
            itmStr = itemToLabel(dataProvider.getItemAt(startIndex));
            itmStr = itmStr.substring(0,str.length);
            if(str == itmStr || str.toUpperCase() == itmStr.toUpperCase())
            {
               return startIndex;
            }
            startIndex++;
         }
         return -1;
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         super.keyDownHandler(event);
         if(!dataProvider || !layout || event.isDefaultPrevented())
         {
            return;
         }
         if(this.isEditableTarget(event.target))
         {
            return;
         }
         var touchMode:Boolean = getStyle("interactionMode") == InteractionMode.TOUCH;
         if(event.keyCode == Keyboard.SPACE || touchMode && event.keyCode == Keyboard.ENTER)
         {
            if(this.allowMultipleSelection)
            {
               this.setSelectedIndices(this.calculateSelectedIndices(caretIndex,event.shiftKey,event.ctrlKey),true,false);
            }
            else if(caretIndex == selectedIndex && (event.ctrlKey || touchMode))
            {
               setSelectedIndex(NO_SELECTION,true,false);
            }
            else
            {
               setSelectedIndex(caretIndex,true,false);
            }
            event.preventDefault();
            return;
         }
         if(this.findKey(event.charCode))
         {
            event.preventDefault();
            return;
         }
         this.adjustSelectionAndCaretUponNavigation(event);
      }
      
      protected function adjustSelectionAndCaretUponNavigation(event:KeyboardEvent) : void
      {
         var startIndex:Number = NaN;
         var newInterval:Vector.<int> = null;
         var i:int = 0;
         var oldCaretIndex:Number = NaN;
         var e:IndexChangeEvent = null;
         var navigationUnit:uint = uint(mapKeycodeForLayoutDirection(event));
         if(!NavigationUnit.isNavigationUnit(event.keyCode))
         {
            return;
         }
         var proposedNewIndex:int = layout.getNavigationDestinationIndex(caretIndex,navigationUnit,arrowKeysWrapFocus);
         if(proposedNewIndex == -1)
         {
            return;
         }
         event.preventDefault();
         if(this.allowMultipleSelection && event.shiftKey && Boolean(this.selectedIndices))
         {
            startIndex = this.getLastSelectedIndex();
            newInterval = new Vector.<int>();
            if(startIndex <= proposedNewIndex)
            {
               for(i = startIndex; i <= proposedNewIndex; i++)
               {
                  newInterval.splice(0,0,i);
               }
            }
            else
            {
               for(i = startIndex; i >= proposedNewIndex; i--)
               {
                  newInterval.splice(0,0,i);
               }
            }
            this.setSelectedIndices(newInterval,true);
            this.ensureIndexIsVisible(proposedNewIndex);
         }
         else if(event.ctrlKey || getStyle("interactionMode") == InteractionMode.TOUCH)
         {
            oldCaretIndex = caretIndex;
            setCurrentCaretIndex(proposedNewIndex);
            e = new IndexChangeEvent(IndexChangeEvent.CARET_CHANGE);
            e.oldIndex = oldCaretIndex;
            e.newIndex = caretIndex;
            dispatchEvent(e);
            this.ensureIndexIsVisible(proposedNewIndex);
         }
         else
         {
            setSelectedIndex(proposedNewIndex,true);
            this.ensureIndexIsVisible(proposedNewIndex);
         }
      }
      
      protected function isEditableTarget(target:Object) : Boolean
      {
         var focusObj:Object = getFocus();
         return focusObj is TextField && focusObj.type == "input" || this.richEditableTextClass && focusObj is this.richEditableTextClass && focusObj.editable == true;
      }
   }
}

