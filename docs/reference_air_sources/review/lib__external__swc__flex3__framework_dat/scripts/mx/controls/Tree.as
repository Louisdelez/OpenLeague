package mx.controls
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import flash.xml.XMLNode;
   import mx.collections.ArrayCollection;
   import mx.collections.CursorBookmark;
   import mx.collections.ICollectionView;
   import mx.collections.IViewCursor;
   import mx.collections.ItemResponder;
   import mx.collections.XMLListCollection;
   import mx.collections.errors.ItemPendingError;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.controls.listClasses.ListBaseSelectionDataPending;
   import mx.controls.listClasses.ListRowInfo;
   import mx.controls.treeClasses.DefaultDataDescriptor;
   import mx.controls.treeClasses.HierarchicalCollectionView;
   import mx.controls.treeClasses.HierarchicalViewCursor;
   import mx.controls.treeClasses.ITreeDataDescriptor;
   import mx.controls.treeClasses.ITreeDataDescriptor2;
   import mx.controls.treeClasses.TreeItemRenderer;
   import mx.controls.treeClasses.TreeListData;
   import mx.core.ClassFactory;
   import mx.core.EdgeMetrics;
   import mx.core.EventPriority;
   import mx.core.FlexShape;
   import mx.core.FlexSprite;
   import mx.core.IFactory;
   import mx.core.IFlexDisplayObject;
   import mx.core.IIMESupport;
   import mx.core.IInvalidating;
   import mx.core.UIComponent;
   import mx.core.UIComponentGlobals;
   import mx.core.mx_internal;
   import mx.effects.Tween;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.DragEvent;
   import mx.events.ListEvent;
   import mx.events.ListEventReason;
   import mx.events.ScrollEvent;
   import mx.events.TreeEvent;
   import mx.managers.DragManager;
   import mx.styles.StyleManager;
   
   use namespace mx_internal;
   
   [RequiresDataBinding("true")]
   [IconFile("Tree.png")]
   [DefaultTriggerEvent("change")]
   [DefaultProperty("dataProvider")]
   [DefaultBindingProperty(destination="dataProvider")]
   [AccessibilityClass(implementation="mx.accessibility.TreeAccImpl")]
   [Style(name="textSelectedColor",type="uint",format="Color",inherit="yes")]
   [Style(name="textRollOverColor",type="uint",format="Color",inherit="yes")]
   [Style(name="selectionEasingFunction",type="Function",inherit="no")]
   [Style(name="selectionDisabledColor",type="uint",format="Color",inherit="yes")]
   [Style(name="selectionColor",type="uint",format="Color",inherit="yes")]
   [Style(name="rollOverColor",type="uint",format="Color",inherit="yes")]
   [Style(name="openEasingFunction",type="Function",inherit="no")]
   [Style(name="openDuration",type="Number",format="Time",inherit="no")]
   [Style(name="indentation",type="Number",inherit="no")]
   [Style(name="folderClosedIcon",type="Class",format="EmbeddedFile",inherit="no")]
   [Style(name="folderOpenIcon",type="Class",format="EmbeddedFile",inherit="no")]
   [Style(name="disclosureClosedIcon",type="Class",format="EmbeddedFile",inherit="no")]
   [Style(name="disclosureOpenIcon",type="Class",format="EmbeddedFile",inherit="no")]
   [Style(name="defaultLeafIcon",type="Class",format="EmbeddedFile",inherit="no")]
   [Style(name="depthColors",type="Array",arrayType="uint",format="Color",inherit="yes")]
   [Style(name="alternatingItemColors",type="Array",arrayType="uint",format="Color",inherit="yes")]
   [Style(name="paddingRight",type="Number",format="Length",inherit="no")]
   [Style(name="paddingLeft",type="Number",format="Length",inherit="no")]
   [Event(name="itemOpening",type="mx.events.TreeEvent")]
   [Event(name="itemOpen",type="mx.events.TreeEvent")]
   [Event(name="itemClose",type="mx.events.TreeEvent")]
   public class Tree extends List implements IIMESupport
   {
      
      mx_internal static var createAccessibilityImplementation:Function;
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      mx_internal var wrappedCollection:ICollectionView;
      
      private var lastTreeSeekPending:TreeSeekPending;
      
      private var _openItems:Object = {};
      
      private var rowIndex:int;
      
      private var _dragMoveEnabled:Boolean = true;
      
      mx_internal var collectionLength:int;
      
      private var eventAfterTween:Object;
      
      private var rowsTweened:int;
      
      mx_internal var showRootChanged:Boolean = false;
      
      private var dontEdit:Boolean = false;
      
      private var openItemsChanged:Boolean = false;
      
      private var opening:Boolean;
      
      mx_internal var _hasRoot:Boolean = false;
      
      private var rowNameID:Number = 0;
      
      private var tween:Object;
      
      private var expandedItem:Object;
      
      private var bSelectedItemRemoved:Boolean = false;
      
      private var IS_NEW_ROW_STYLE:Object = {
         "depthColors":true,
         "indentation":true,
         "disclosureOpenIcon":true,
         "disclosureClosedIcon":true,
         "folderOpenIcon":true,
         "folderClosedIcon":true,
         "defaultLeafIcon":true
      };
      
      private var dataProviderChanged:Boolean = false;
      
      private var bFinishArrowKeySelection:Boolean = false;
      
      private var haveItemIndices:Boolean;
      
      mx_internal var collectionThrowsIPE:Boolean;
      
      mx_internal var _dropData:Object;
      
      private var eventPending:Object;
      
      private var rowList:Array;
      
      private var minScrollInterval:Number = 50;
      
      private var maskList:Array;
      
      public var itemIcons:Object;
      
      mx_internal var isOpening:Boolean = false;
      
      private var _editable:Boolean = false;
      
      private var _userMaxHorizontalScrollPosition:Number = 0;
      
      private var lastUserInteraction:Event;
      
      private var proposedSelectedItem:Object;
      
      mx_internal var _showRoot:Boolean = true;
      
      mx_internal var _dataDescriptor:ITreeDataDescriptor = new DefaultDataDescriptor();
      
      mx_internal var _rootModel:ICollectionView;
      
      private var oldLength:int = -1;
      
      private var _itemEditor:IFactory = new ClassFactory(TextInput);
      
      public function Tree()
      {
         super();
         itemRenderer = new ClassFactory(TreeItemRenderer);
         editorXOffset = 12;
         editorWidthOffset = -12;
         addEventListener(TreeEvent.ITEM_OPENING,mx_internal::expandItemHandler,false,EventPriority.DEFAULT_HANDLER);
      }
      
      override mx_internal function removeClipMask() : void
      {
      }
      
      override protected function dragOverHandler(event:DragEvent) : void
      {
         if(event.isDefaultPrevented())
         {
            return;
         }
         lastDragEvent = event;
         try
         {
            if(iteratorValid && event.dragSource.hasFormat("treeItems"))
            {
               if(collectionThrowsIPE)
               {
                  checkItemIndices(event);
               }
               DragManager.showFeedback(event.ctrlKey ? DragManager.COPY : DragManager.MOVE);
               showDropFeedback(event);
               return;
            }
         }
         catch(e:ItemPendingError)
         {
            if(!lastTreeSeekPending)
            {
               lastTreeSeekPending = new TreeSeekPending(event,dragOverHandler);
               e.addResponder(new ItemResponder(seekPendingDuringDragResultHandler,seekPendingDuringDragFailureHandler,lastTreeSeekPending));
            }
         }
         catch(e1:Error)
         {
         }
         hideDropFeedback(event);
         DragManager.showFeedback(DragManager.NONE);
      }
      
      override protected function mouseUpHandler(event:MouseEvent) : void
      {
         if(!tween)
         {
            super.mouseUpHandler(event);
         }
      }
      
      private function buildUpCollectionEvents(open:Boolean) : Array
      {
         var ce:CollectionEvent = null;
         var i:int = 0;
         var item:Object = null;
         var parentArray:Array = null;
         var children:ICollectionView = null;
         var cursor:IViewCursor = null;
         var push:Boolean = false;
         var stack:Array = null;
         var j:int = 0;
         var rowsAdded:Array = [];
         var rowsRemoved:Array = [];
         var retVal:Array = [];
         var itemIndex:int = getItemIndex(expandedItem);
         if(open)
         {
            children = getChildren(expandedItem,iterator.view);
            if(!children)
            {
               return [];
            }
            cursor = children.createCursor();
            push = true;
            while(!cursor.afterLast)
            {
               rowsAdded.push(cursor.current);
               cursor.moveNext();
            }
         }
         else
         {
            stack = [];
            j = 0;
            stack = getOpenChildrenStack(expandedItem,stack);
            while(j < stack.length)
            {
               for(i = 0; i < selectedItems.length; i++)
               {
                  if(selectedItems[i] == stack[j])
                  {
                     bSelectedItemRemoved = true;
                  }
               }
               rowsRemoved.push(stack[j]);
               j++;
            }
         }
         if(rowsAdded.length > 0)
         {
            ce = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            ce.kind = CollectionEventKind.ADD;
            ce.location = itemIndex + 1;
            ce.items = rowsAdded;
            retVal.push(ce);
         }
         if(rowsRemoved.length > 0)
         {
            ce = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            ce.kind = CollectionEventKind.REMOVE;
            ce.location = itemIndex + 1;
            ce.items = rowsRemoved;
            retVal.push(ce);
         }
         return retVal;
      }
      
      private function updateDropData(event:DragEvent) : void
      {
         var parent:Object = null;
         var index:int = 0;
         var rowCount:int = int(rowInfo.length);
         var rowNum:int = 0;
         var yy:int = int(rowInfo[rowNum].height);
         var pt:Point = globalToLocal(new Point(event.stageX,event.stageY));
         while(Boolean(rowInfo[rowNum]) && pt.y >= yy)
         {
            if(rowNum != rowInfo.length - 1)
            {
               rowNum++;
               yy += rowInfo[rowNum].height;
            }
            else
            {
               yy += rowInfo[rowNum].height;
               rowNum++;
            }
         }
         var lastRowY:Number = rowNum < rowInfo.length ? Number(rowInfo[rowNum].y) : rowInfo[rowNum - 1].y + rowInfo[rowNum - 1].height;
         var yOffset:Number = pt.y - lastRowY;
         var rowHeight:Number = rowNum < rowInfo.length ? Number(rowInfo[rowNum].height) : Number(rowInfo[rowNum - 1].height);
         rowNum += verticalScrollPosition;
         var emptyFolder:Boolean = false;
         var numItems:int = Boolean(collection) ? collection.length : 0;
         var topItem:Object = rowNum > _verticalScrollPosition && rowNum <= numItems ? listItems[rowNum - _verticalScrollPosition - 1][0].data : null;
         var bottomItem:Object = rowNum - verticalScrollPosition < rowInfo.length && rowNum < numItems ? listItems[rowNum - _verticalScrollPosition][0].data : null;
         var topParent:Object = Boolean(collection) ? getParentItem(topItem) : null;
         var bottomParent:Object = Boolean(collection) ? getParentItem(bottomItem) : null;
         if(yOffset > rowHeight * 0.5 && isItemOpen(bottomItem) && _dataDescriptor.isBranch(bottomItem,iterator.view) && (!_dataDescriptor.hasChildren(bottomItem,iterator.view) || _dataDescriptor.getChildren(bottomItem,iterator.view).length == 0))
         {
            parent = bottomItem;
            index = 0;
            emptyFolder = true;
         }
         else if(!topItem && !rowNum == rowCount)
         {
            parent = Boolean(collection) ? getParentItem(bottomItem) : null;
            index = Boolean(bottomItem) ? getChildIndexInParent(parent,bottomItem) : 0;
            rowNum = 0;
         }
         else if(Boolean(bottomItem) && bottomParent == topItem)
         {
            parent = topItem;
            index = 0;
         }
         else if(Boolean(topItem) && Boolean(bottomItem) && topParent == bottomParent)
         {
            parent = Boolean(collection) ? getParentItem(topItem) : null;
            index = Boolean(iterator) ? getChildIndexInParent(parent,bottomItem) : 0;
         }
         else if(Boolean(topItem) && yOffset < rowHeight * 0.5)
         {
            parent = topParent;
            index = getChildIndexInParent(parent,topItem) + 1;
         }
         else if(!bottomItem)
         {
            parent = null;
            if(rowNum - verticalScrollPosition == 0)
            {
               index = 0;
            }
            else if(Boolean(collection))
            {
               index = collection.length;
            }
            else
            {
               index = 0;
            }
         }
         else
         {
            parent = bottomParent;
            index = getChildIndexInParent(parent,bottomItem);
         }
         _dropData = {
            "parent":parent,
            "index":index,
            "localX":event.localX,
            "localY":event.localY,
            "emptyFolder":emptyFolder,
            "rowHeight":rowHeight,
            "rowIndex":rowNum
         };
      }
      
      mx_internal function removeChildItem(parent:Object, child:Object, index:Number) : Boolean
      {
         return _dataDescriptor.removeChildAt(parent,child,index,iterator.view);
      }
      
      public function set openItems(value:Object) : void
      {
         var uid:String = null;
         var item:* = undefined;
         if(value != null)
         {
            for(uid in _openItems)
            {
               delete _openItems[uid];
            }
            for each(item in value)
            {
               _openItems[itemToUID(item)] = item;
            }
            openItemsChanged = true;
            invalidateProperties();
         }
      }
      
      override protected function drawRowBackgrounds() : void
      {
         var i:int;
         var actualRow:int;
         var depthColors:Boolean;
         var curRow:int;
         var color:Object = null;
         var colors:Array = null;
         var n:int = 0;
         var d:int = 0;
         var rowColor:uint = 0;
         var rowBGs:Sprite = Sprite(listContent.getChildByName("rowBGs"));
         if(!rowBGs)
         {
            rowBGs = new FlexSprite();
            rowBGs.name = "rowBGs";
            rowBGs.mouseEnabled = false;
            listContent.addChildAt(rowBGs,0);
         }
         depthColors = false;
         colors = getStyle("depthColors");
         if(Boolean(colors))
         {
            depthColors = true;
         }
         else
         {
            colors = getStyle("alternatingItemColors");
         }
         color = getStyle("backgroundColor");
         if(!colors || colors.length == 0)
         {
            while(rowBGs.numChildren > n)
            {
               rowBGs.removeChildAt(rowBGs.numChildren - 1);
            }
            return;
         }
         StyleManager.getColorNames(colors);
         curRow = 0;
         actualRow = verticalScrollPosition;
         i = 0;
         n = int(listItems.length);
         while(curRow < n)
         {
            if(depthColors)
            {
               try
               {
                  if(Boolean(listItems[curRow][0]))
                  {
                     d = getItemDepth(listItems[curRow][0].data,curRow);
                     rowColor = Boolean(colors[d - 1]) ? uint(colors[d - 1]) : uint(color);
                     drawRowBackground(rowBGs,i++,rowInfo[curRow].y,rowInfo[curRow].height,rowColor,curRow);
                  }
                  else
                  {
                     drawRowBackground(rowBGs,i++,rowInfo[curRow].y,rowInfo[curRow].height,uint(color),curRow);
                  }
               }
               catch(e:Error)
               {
               }
            }
            else
            {
               drawRowBackground(rowBGs,i++,rowInfo[curRow].y,rowInfo[curRow].height,colors[actualRow % colors.length],actualRow);
            }
            curRow++;
            actualRow++;
         }
         while(rowBGs.numChildren > n)
         {
            rowBGs.removeChildAt(rowBGs.numChildren - 1);
         }
      }
      
      override public function showDropFeedback(event:DragEvent) : void
      {
         var depth:int = 0;
         super.showDropFeedback(event);
         var vm:EdgeMetrics = viewMetrics;
         var offset:int = 0;
         updateDropData(event);
         var indent:int = 0;
         if(Boolean(_dropData.parent))
         {
            offset = getItemIndex(iterator.current);
            depth = getItemDepth(_dropData.parent,Math.abs(offset - getItemIndex(_dropData.parent)));
            indent = (depth + 1) * getStyle("indentation");
         }
         else
         {
            indent = getStyle("indentation");
         }
         if(indent < 0)
         {
            indent = 0;
         }
         dropIndicator.width = listContent.width - indent;
         dropIndicator.x = indent + vm.left + 2;
         if(Boolean(_dropData.emptyFolder))
         {
            dropIndicator.y += _dropData.rowHeight / 2;
         }
      }
      
      mx_internal function dispatchTreeEvent(type:String, item:Object, renderer:IListItemRenderer, trigger:Event = null, opening:Boolean = true, animate:Boolean = true, dispatch:Boolean = true) : void
      {
         var event:TreeEvent = null;
         if(type == TreeEvent.ITEM_OPENING)
         {
            event = new TreeEvent(TreeEvent.ITEM_OPENING,false,true);
            event.opening = opening;
            event.animate = animate;
            event.dispatchEvent = dispatch;
         }
         if(!event)
         {
            event = new TreeEvent(type);
         }
         event.item = item;
         event.itemRenderer = renderer;
         event.triggerEvent = trigger;
         dispatchEvent(event);
      }
      
      private function finishArrowKeySelection() : void
      {
         var evt:ListEvent = null;
         var pt:Point = null;
         var dI:int = 0;
         bFinishArrowKeySelection = false;
         if(Boolean(proposedSelectedItem))
         {
            selectedItem = proposedSelectedItem;
         }
         if(selectedItem === proposedSelectedItem || !proposedSelectedItem)
         {
            evt = new ListEvent(ListEvent.CHANGE);
            evt.itemRenderer = indexToItemRenderer(selectedIndex);
            pt = itemRendererToIndices(evt.itemRenderer);
            if(Boolean(pt))
            {
               evt.rowIndex = pt.y;
               evt.columnIndex = pt.x;
            }
            dispatchEvent(evt);
            dI = getItemIndex(selectedItem);
            if(dI != caretIndex)
            {
               caretIndex = selectedIndex;
            }
            if(dI < _verticalScrollPosition)
            {
               verticalScrollPosition = dI;
            }
         }
         else
         {
            bFinishArrowKeySelection = true;
         }
      }
      
      override protected function layoutEditor(x:int, y:int, w:int, h:int) : void
      {
         var indent:int = int(rowMap[editedItemRenderer.name].indent);
         itemEditorInstance.move(x + indent,y);
         itemEditorInstance.setActualSize(w - indent,h);
      }
      
      public function isItemOpen(item:Object) : Boolean
      {
         var uid:String = itemToUID(item);
         return _openItems[uid] != null;
      }
      
      override mx_internal function addClipMask(layoutChanged:Boolean) : void
      {
         var vm:EdgeMetrics = viewMetrics;
         if(Boolean(horizontalScrollBar) && horizontalScrollBar.visible)
         {
            vm.bottom -= horizontalScrollBar.minHeight;
         }
         if(Boolean(verticalScrollBar) && verticalScrollBar.visible)
         {
            vm.right -= verticalScrollBar.minWidth;
         }
         listContent.scrollRect = new Rectangle(0,0,unscaledWidth - vm.left - vm.right,listContent.heightExcludingOffsets);
      }
      
      private function collapseSelectedItems() : Array
      {
         var item:Object = null;
         var stack:Array = null;
         var j:int = 0;
         var index:int = 0;
         var removed:Object = null;
         var collection:ArrayCollection = new ArrayCollection(selectedItems);
         for(var i:int = 0; i < selectedItems.length; i++)
         {
            item = selectedItems[i];
            stack = getParentStack(item);
            for(j = 0; j < stack.length; j++)
            {
               if(collection.contains(stack[j]))
               {
                  index = collection.getItemIndex(item);
                  removed = collection.removeItemAt(index);
                  break;
               }
            }
         }
         return collection.source;
      }
      
      override public function isItemVisible(item:Object) : Boolean
      {
         var uid:String = null;
         if(Boolean(visibleData[itemToUID(item)]))
         {
            return true;
         }
         var parentItem:Object = getParentItem(item);
         if(Boolean(parentItem))
         {
            uid = itemToUID(parentItem);
            if(Boolean(visibleData[uid]) && Boolean(_openItems[uid]))
            {
               return true;
            }
         }
         return false;
      }
      
      private function getIndexItem(index:int) : Object
      {
         var cursor:IViewCursor = collection.createCursor();
         var i:int = index;
         while(cursor.moveNext())
         {
            if(i == 0)
            {
               return cursor.current;
            }
            i--;
         }
         return null;
      }
      
      private function seekPendingDuringDragResultHandler(data:Object, info:TreeSeekPending) : void
      {
         lastTreeSeekPending = null;
         if(Boolean(lastDragEvent))
         {
            info.retryFunction(info.event);
         }
      }
      
      private function getChildIndexInParent(parent:Object, child:Object) : int
      {
         var cursor:IViewCursor = null;
         var children:ICollectionView = null;
         var index:int = 0;
         if(!parent)
         {
            cursor = ICollectionView(iterator.view).createCursor();
            while(!cursor.afterLast)
            {
               if(child === cursor.current)
               {
                  break;
               }
               index++;
               cursor.moveNext();
            }
         }
         else if(parent != null && _dataDescriptor.isBranch(parent,iterator.view) && _dataDescriptor.hasChildren(parent,iterator.view))
         {
            children = getChildren(parent,iterator.view);
            if(children.contains(child))
            {
               cursor = children.createCursor();
               while(!cursor.afterLast)
               {
                  if(child === cursor.current)
                  {
                     break;
                  }
                  cursor.moveNext();
                  index++;
               }
            }
         }
         return index;
      }
      
      [Inspectable(defaultValue="true")]
      override public function get dragMoveEnabled() : Boolean
      {
         return _dragMoveEnabled;
      }
      
      override protected function mouseDownHandler(event:MouseEvent) : void
      {
         if(!tween)
         {
            super.mouseDownHandler(event);
         }
      }
      
      override public function calculateDropIndex(event:DragEvent = null) : int
      {
         if(Boolean(event))
         {
            updateDropData(event);
         }
         return _dropData.rowIndex;
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         var evt:ListEvent = null;
         var pt:Point = null;
         var renderer:IListItemRenderer = null;
         var o:Boolean = false;
         var parentItem:Object = null;
         var children:ICollectionView = null;
         var cursor:IViewCursor = null;
         if(isOpening)
         {
            event.stopImmediatePropagation();
            return;
         }
         if(Boolean(itemEditorInstance))
         {
            return;
         }
         var item:Object = selectedItem;
         if(event.ctrlKey)
         {
            super.keyDownHandler(event);
         }
         else if(event.keyCode == Keyboard.SPACE)
         {
            if(caretIndex != selectedIndex)
            {
               renderer = indexToItemRenderer(caretIndex);
               if(Boolean(renderer))
               {
                  drawItem(renderer);
               }
               caretIndex = selectedIndex;
            }
            if(isBranch(item))
            {
               o = !isItemOpen(item);
               dispatchTreeEvent(TreeEvent.ITEM_OPENING,item,null,event,o,true,true);
            }
            event.stopImmediatePropagation();
         }
         else if(event.keyCode == Keyboard.LEFT)
         {
            if(isItemOpen(item))
            {
               dispatchTreeEvent(TreeEvent.ITEM_OPENING,item,null,event,false,true,true);
            }
            else
            {
               parentItem = getParentItem(item);
               if(Boolean(parentItem))
               {
                  proposedSelectedItem = parentItem;
                  finishArrowKeySelection();
               }
            }
            event.stopImmediatePropagation();
         }
         else if(event.keyCode == Keyboard.RIGHT)
         {
            if(isBranch(item))
            {
               if(isItemOpen(item))
               {
                  if(Boolean(item))
                  {
                     children = getChildren(item,iterator.view);
                     if(Boolean(children))
                     {
                        cursor = children.createCursor();
                        if(Boolean(cursor.current))
                        {
                           proposedSelectedItem = cursor.current;
                        }
                     }
                     else
                     {
                        proposedSelectedItem = null;
                     }
                  }
                  else
                  {
                     selectedItem = proposedSelectedItem = null;
                  }
                  finishArrowKeySelection();
               }
               else
               {
                  dispatchTreeEvent(TreeEvent.ITEM_OPENING,item,null,event,true,true,true);
               }
            }
            event.stopImmediatePropagation();
         }
         else if(event.keyCode == Keyboard.NUMPAD_MULTIPLY)
         {
            expandChildrenOf(item,!isItemOpen(item));
         }
         else if(event.keyCode == Keyboard.NUMPAD_ADD)
         {
            if(isBranch(item))
            {
               if(!isItemOpen(item))
               {
                  dispatchTreeEvent(TreeEvent.ITEM_OPENING,item,null,event,true,true,true);
               }
            }
         }
         else if(event.keyCode == Keyboard.NUMPAD_SUBTRACT)
         {
            if(isItemOpen(item))
            {
               dispatchTreeEvent(TreeEvent.ITEM_OPENING,item,null,event,false,true,true);
            }
         }
         else
         {
            super.keyDownHandler(event);
         }
      }
      
      mx_internal function onTweenEnd(value:Object) : void
      {
         var i:int = 0;
         var renderer:* = undefined;
         var dilir:IDropInListItemRenderer = null;
         var itemUID:* = undefined;
         var indicator:Object = null;
         var eventArr:Array = null;
         var firstDeletedRow:int = 0;
         var mask:DisplayObject = null;
         UIComponent.resumeBackgroundProcessing();
         onTweenUpdate(value);
         var rC:int = int(listItems.length);
         isOpening = false;
         if(Boolean(collection))
         {
            eventArr = opening ? buildUpCollectionEvents(true) : buildUpCollectionEvents(false);
            for(i = 0; i < eventArr.length; i++)
            {
               collection.dispatchEvent(eventArr[i]);
            }
         }
         if(opening)
         {
            firstDeletedRow = -1;
            for(i = rowIndex; i < rC; i++)
            {
               if(Boolean(listItems[i].length))
               {
                  renderer = listItems[i][0];
                  mask = renderer.mask;
                  if(Boolean(mask))
                  {
                     listContent.removeChild(mask);
                     renderer.mask = null;
                  }
                  rowMap[renderer.name].rowIndex = i;
                  if(renderer is IDropInListItemRenderer)
                  {
                     dilir = IDropInListItemRenderer(renderer);
                     if(Boolean(dilir.listData))
                     {
                        dilir.listData.rowIndex = i;
                        dilir.listData = dilir.listData;
                     }
                  }
                  if(renderer.y > listContent.height)
                  {
                     addToFreeItemRenderers(renderer);
                     itemUID = itemToUID(renderer.data);
                     if(Boolean(selectionIndicators[itemUID]))
                     {
                        indicator = selectionIndicators[itemUID];
                        if(Boolean(indicator))
                        {
                           mask = indicator.mask;
                           if(Boolean(mask))
                           {
                              listContent.removeChild(mask);
                              indicator.mask = null;
                           }
                        }
                        removeIndicators(itemUID);
                     }
                     delete rowMap[renderer.name];
                     if(firstDeletedRow < 0)
                     {
                        firstDeletedRow = i;
                     }
                  }
               }
               else if(rowInfo[i].y >= listContent.height)
               {
                  if(firstDeletedRow < 0)
                  {
                     firstDeletedRow = i;
                  }
               }
            }
            if(firstDeletedRow >= 0)
            {
               rowInfo.splice(firstDeletedRow);
               listItems.splice(firstDeletedRow);
            }
         }
         else
         {
            for(i = 0; i < rowList.length; i++)
            {
               mask = rowList[i].item.mask;
               if(Boolean(mask))
               {
                  listContent.removeChild(mask);
                  rowList[i].item.mask = null;
               }
               addToFreeItemRenderers(rowList[i].item);
               itemUID = itemToUID(rowList[i].item.data);
               if(Boolean(selectionIndicators[itemUID]))
               {
                  indicator = selectionIndicators[itemUID];
                  if(Boolean(indicator))
                  {
                     mask = indicator.mask;
                     if(Boolean(mask))
                     {
                        listContent.removeChild(mask);
                        indicator.mask = null;
                     }
                  }
                  removeIndicators(itemUID);
               }
               delete rowMap[rowList[i].item.name];
            }
            for(i = rowIndex; i < rC; i++)
            {
               if(Boolean(listItems[i].length))
               {
                  renderer = listItems[i][0];
                  rowMap[renderer.name].rowIndex = i;
                  if(renderer is IDropInListItemRenderer)
                  {
                     dilir = IDropInListItemRenderer(renderer);
                     if(Boolean(dilir.listData))
                     {
                        dilir.listData.rowIndex = i;
                        dilir.listData = dilir.listData;
                     }
                  }
               }
            }
         }
         if(Boolean(eventAfterTween))
         {
            dispatchTreeEvent(isItemOpen(eventAfterTween) ? TreeEvent.ITEM_OPEN : TreeEvent.ITEM_CLOSE,eventAfterTween,visibleData[itemToUID(eventAfterTween)],lastUserInteraction);
            lastUserInteraction = null;
            eventAfterTween = false;
         }
         itemsSizeChanged = true;
         invalidateDisplayList();
         tween = null;
      }
      
      override protected function adjustAfterRemove(items:Array, location:int, emitEvent:Boolean) : Boolean
      {
         var indicesLength:int = int(selectedItems.length);
         var requiresValueCommit:Boolean = emitEvent;
         var length:int = int(items.length);
         if(_selectedIndex > location)
         {
            _selectedIndex -= length;
            requiresValueCommit = true;
         }
         if(bSelectedItemRemoved && indicesLength < 1)
         {
            _selectedIndex = getItemIndex(expandedItem);
            requiresValueCommit = true;
            bSelectionChanged = true;
            bSelectedIndexChanged = true;
            invalidateDisplayList();
         }
         return requiresValueCommit;
      }
      
      [Inspectable(category="Data")]
      public function set dataDescriptor(value:ITreeDataDescriptor) : void
      {
         _dataDescriptor = value;
      }
      
      private function isBranch(item:Object) : Boolean
      {
         if(item != null)
         {
            return _dataDescriptor.isBranch(item,iterator.view);
         }
         return false;
      }
      
      private function getVisibleChildrenCount(item:Object) : int
      {
         var children:Object = null;
         var cursor:IViewCursor = null;
         var count:int = 0;
         if(item == null)
         {
            return count;
         }
         var uid:String = itemToUID(item);
         if(Boolean(_openItems[uid]) && Boolean(_dataDescriptor.isBranch(item,iterator.view)) && _dataDescriptor.hasChildren(item,iterator.view))
         {
            children = getChildren(item,iterator.view);
         }
         if(children != null)
         {
            cursor = children.createCursor();
            while(!cursor.afterLast)
            {
               count++;
               uid = itemToUID(cursor.current);
               if(Boolean(_openItems[uid]))
               {
                  count += getVisibleChildrenCount(cursor.current);
               }
               cursor.moveNext();
            }
         }
         return count;
      }
      
      mx_internal function getChildren(item:Object, view:Object) : ICollectionView
      {
         return _dataDescriptor.getChildren(item,view);
      }
      
      public function expandChildrenOf(item:Object, open:Boolean) : void
      {
         var childItems:ICollectionView = null;
         var cursor:IViewCursor = null;
         if(iterator == null)
         {
            return;
         }
         if(isBranch(item))
         {
            dispatchTreeEvent(TreeEvent.ITEM_OPENING,item,null,null,open,false,true);
            if(item != null && _dataDescriptor.isBranch(item,iterator.view) && _dataDescriptor.hasChildren(item,iterator.view))
            {
               childItems = getChildren(item,iterator.view);
            }
            if(Boolean(childItems))
            {
               cursor = childItems.createCursor();
               while(!cursor.afterLast)
               {
                  if(isBranch(cursor.current))
                  {
                     expandChildrenOf(cursor.current,open);
                  }
                  cursor.moveNext();
               }
            }
         }
      }
      
      [Inspectable(category="Data",defaultValue="null")]
      [Bindable("collectionChange")]
      override public function set dataProvider(value:Object) : void
      {
         var xl:XMLList = null;
         var tmp:Array = null;
         if(Boolean(_rootModel))
         {
            _rootModel.removeEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler);
         }
         if(typeof value == "string")
         {
            value = new XML(value);
         }
         else if(value is XMLNode)
         {
            value = new XML(XMLNode(value).toString());
         }
         else if(value is XMLList)
         {
            value = new XMLListCollection(value as XMLList);
         }
         if(value is XML)
         {
            _hasRoot = true;
            xl = new XMLList();
            xl += value;
            _rootModel = new XMLListCollection(xl);
         }
         else if(value is ICollectionView)
         {
            _rootModel = ICollectionView(value);
            if(_rootModel.length == 1)
            {
               _hasRoot = true;
            }
         }
         else if(value is Array)
         {
            _rootModel = new ArrayCollection(value as Array);
         }
         else if(value is Object)
         {
            _hasRoot = true;
            tmp = [];
            tmp.push(value);
            _rootModel = new ArrayCollection(tmp);
         }
         else
         {
            _rootModel = new ArrayCollection();
         }
         dataProviderChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(category="Data",enumeration="true,false",defaultValue="false")]
      public function get showRoot() : Boolean
      {
         return _showRoot;
      }
      
      override protected function collectionChangeHandler(event:Event) : void
      {
         var node:Object = null;
         var parent:Object = null;
         var ce:CollectionEvent = null;
         if(iterator == null)
         {
            return;
         }
         if(event is CollectionEvent)
         {
            ce = CollectionEvent(event);
            if(ce.kind == CollectionEventKind.EXPAND)
            {
               event.stopPropagation();
            }
            if(ce.kind == CollectionEventKind.UPDATE)
            {
               event.stopPropagation();
               itemsSizeChanged = true;
               invalidateDisplayList();
            }
            else
            {
               super.collectionChangeHandler(event);
            }
         }
      }
      
      override protected function makeListData(data:Object, uid:String, rowNum:int) : BaseListData
      {
         var treeListData:TreeListData = new TreeListData(itemToLabel(data),uid,this,rowNum);
         initListData(data,treeListData);
         return treeListData;
      }
      
      override public function itemToIcon(item:Object) : Class
      {
         var uid:String;
         var branch:Boolean;
         var open:Boolean;
         var iconClass:Class;
         var icon:* = undefined;
         if(item == null)
         {
            return null;
         }
         open = isItemOpen(item);
         branch = isBranch(item);
         uid = itemToUID(item);
         iconClass = Boolean(itemIcons) && Boolean(itemIcons[uid]) ? itemIcons[uid][open ? "iconID2" : "iconID"] : null;
         if(Boolean(iconClass))
         {
            return iconClass;
         }
         if(iconFunction != null)
         {
            return iconFunction(item);
         }
         if(branch)
         {
            return getStyle(open ? "folderOpenIcon" : "folderClosedIcon");
         }
         if(item is XML)
         {
            try
            {
               if(item[iconField].length() != 0)
               {
                  icon = String(item[iconField]);
               }
            }
            catch(e:Error)
            {
            }
         }
         else if(item is Object)
         {
            try
            {
               if(Boolean(iconField) && Boolean(item[iconField]))
               {
                  icon = item[iconField];
               }
               else if(Boolean(item.icon))
               {
                  icon = item.icon;
               }
            }
            catch(e:Error)
            {
            }
         }
         if(icon == null)
         {
            icon = getStyle("defaultLeafIcon");
         }
         if(icon is Class)
         {
            return icon;
         }
         if(icon is String)
         {
            iconClass = Class(systemManager.getDefinitionByName(String(icon)));
            if(Boolean(iconClass))
            {
               return iconClass;
            }
            return document[icon];
         }
         return Class(icon);
      }
      
      public function get openItems() : Object
      {
         var item:* = undefined;
         var openItemsArray:Array = [];
         for each(item in _openItems)
         {
            openItemsArray.push(item);
         }
         return openItemsArray;
      }
      
      override mx_internal function selectionDataPendingResultHandler(data:Object, info:ListBaseSelectionDataPending) : void
      {
         super.mx_internal::selectionDataPendingResultHandler(data,info);
         if(bFinishArrowKeySelection && selectedItem === proposedSelectedItem)
         {
            finishArrowKeySelection();
         }
      }
      
      override protected function initializeAccessibility() : void
      {
         if(Tree.createAccessibilityImplementation != null)
         {
            Tree.createAccessibilityImplementation(this);
         }
      }
      
      override protected function mouseOutHandler(event:MouseEvent) : void
      {
         if(!tween)
         {
            super.mouseOutHandler(event);
         }
      }
      
      public function get hasRoot() : Boolean
      {
         return _hasRoot;
      }
      
      override protected function dragEnterHandler(event:DragEvent) : void
      {
         if(event.isDefaultPrevented())
         {
            return;
         }
         lastDragEvent = event;
         haveItemIndices = false;
         try
         {
            if(iteratorValid && event.dragSource.hasFormat("treeItems"))
            {
               DragManager.acceptDragDrop(this);
               DragManager.showFeedback(event.ctrlKey ? DragManager.COPY : DragManager.MOVE);
               showDropFeedback(event);
               return;
            }
         }
         catch(e:ItemPendingError)
         {
            if(!lastTreeSeekPending)
            {
               lastTreeSeekPending = new TreeSeekPending(event,dragEnterHandler);
               e.addResponder(new ItemResponder(seekPendingDuringDragResultHandler,seekPendingDuringDragFailureHandler,lastTreeSeekPending));
            }
         }
         catch(e1:Error)
         {
         }
         hideDropFeedback(event);
         DragManager.showFeedback(DragManager.NONE);
      }
      
      protected function initListData(item:Object, treeListData:TreeListData) : void
      {
         if(item == null)
         {
            return;
         }
         var open:Boolean = isItemOpen(item);
         var branch:Boolean = isBranch(item);
         var uid:String = itemToUID(item);
         treeListData.disclosureIcon = getStyle(open ? "disclosureOpenIcon" : "disclosureClosedIcon");
         treeListData.open = open;
         treeListData.hasChildren = branch;
         treeListData.depth = getItemDepth(item,treeListData.rowIndex);
         treeListData.indent = (treeListData.depth - 1) * getStyle("indentation");
         treeListData.item = item;
         treeListData.icon = itemToIcon(item);
      }
      
      private function getIndent() : Number
      {
         var p:String = null;
         var depth:Number = 0;
         for(p in _openItems)
         {
            depth = Math.max(getParentStack(_openItems[p]).length + 1,depth);
         }
         return depth * getStyle("indentation");
      }
      
      public function setItemIcon(item:Object, iconID:Class, iconID2:Class) : void
      {
         if(!itemIcons)
         {
            itemIcons = {};
         }
         if(!iconID2)
         {
            iconID2 = iconID;
         }
         itemIcons[itemToUID(item)] = {
            "iconID":iconID,
            "iconID2":iconID2
         };
         itemsSizeChanged = true;
         invalidateDisplayList();
      }
      
      public function set firstVisibleItem(value:Object) : void
      {
         var pos:int = getItemIndex(value);
         if(pos < 0)
         {
            return;
         }
         verticalScrollPosition = Math.min(maxVerticalScrollPosition,pos);
         dispatchEvent(new Event("firstVisibleItemChanged"));
      }
      
      override protected function mouseWheelHandler(event:MouseEvent) : void
      {
         if(!tween)
         {
            super.mouseWheelHandler(event);
         }
      }
      
      mx_internal function onTweenUpdate(value:Object) : void
      {
         var renderer:IFlexDisplayObject = null;
         var n:int = 0;
         var i:int = 0;
         var deltaY:Number = NaN;
         var lastY:Number = NaN;
         var s:Sprite = null;
         n = int(listItems.length);
         for(i = rowIndex; i < n; i++)
         {
            if(Boolean(listItems[i].length))
            {
               renderer = IFlexDisplayObject(listItems[i][0]);
               lastY = renderer.y;
               renderer.move(renderer.x,rowInfo[i].itemOldY + value);
               deltaY = renderer.y - lastY;
            }
            s = selectionIndicators[rowInfo[i].uid];
            rowInfo[i].y += deltaY;
            if(Boolean(s))
            {
               s.y += deltaY;
            }
         }
         n = int(rowList.length);
         for(i = 0; i < n; i++)
         {
            s = null;
            renderer = IFlexDisplayObject(rowList[i].item);
            if(rowMap[renderer.name] != null)
            {
               s = selectionIndicators[BaseListData(rowMap[renderer.name]).uid];
            }
            lastY = renderer.y;
            renderer.move(renderer.x,rowList[i].itemOldY + value);
            deltaY = renderer.y - lastY;
            if(Boolean(s))
            {
               s.y += deltaY;
            }
         }
      }
      
      override public function set dragMoveEnabled(value:Boolean) : void
      {
         _dragMoveEnabled = value;
      }
      
      public function get dataDescriptor() : ITreeDataDescriptor
      {
         return ITreeDataDescriptor(_dataDescriptor);
      }
      
      override public function get dataProvider() : Object
      {
         if(Boolean(_rootModel))
         {
            return _rootModel;
         }
         return null;
      }
      
      override public function set maxHorizontalScrollPosition(value:Number) : void
      {
         _userMaxHorizontalScrollPosition = value;
         value += getIndent();
         super.maxHorizontalScrollPosition = value;
      }
      
      override protected function scrollHandler(event:Event) : void
      {
         if(isOpening)
         {
            return;
         }
         if(event is ScrollEvent)
         {
            super.scrollHandler(event);
         }
      }
      
      override protected function addDragData(ds:Object) : void
      {
         ds.addHandler(collapseSelectedItems,"treeItems");
      }
      
      mx_internal function getItemDepth(item:Object, offset:int) : int
      {
         if(!collection)
         {
            return 0;
         }
         if(!iterator)
         {
            listContent.iterator = collection.createCursor();
         }
         if(iterator.current == item)
         {
            return getCurrentCursorDepth();
         }
         var bookmark:CursorBookmark = iterator.bookmark;
         iterator.seek(bookmark,offset);
         var depth:int = getCurrentCursorDepth();
         iterator.seek(bookmark,0);
         return depth;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         if(styleProp == null || styleProp == "styleName" || Boolean(IS_NEW_ROW_STYLE[styleProp]))
         {
            itemsSizeChanged = true;
            invalidateDisplayList();
         }
         super.styleChanged(styleProp);
      }
      
      mx_internal function expandItemHandler(event:TreeEvent) : void
      {
         if(event.isDefaultPrevented())
         {
            return;
         }
         if(event.type == TreeEvent.ITEM_OPENING)
         {
            expandItem(event.item,event.opening,event.animate,event.dispatchEvent,event.triggerEvent);
         }
      }
      
      override protected function mouseDoubleClickHandler(event:MouseEvent) : void
      {
         if(!tween)
         {
            super.mouseDoubleClickHandler(event);
         }
      }
      
      mx_internal function addChildItem(parent:Object, child:Object, index:Number) : Boolean
      {
         return _dataDescriptor.addChildAt(parent,child,index,iterator.view);
      }
      
      private function getParentStack(item:Object) : Array
      {
         var stack:Array = [];
         if(item == null)
         {
            return stack;
         }
         var parent:* = getParentItem(item);
         while(Boolean(parent))
         {
            stack.push(parent);
            parent = getParentItem(parent);
         }
         return stack;
      }
      
      public function getItemIndex(item:Object) : int
      {
         var cursor:IViewCursor = collection.createCursor();
         var i:int = 0;
         while(cursor.current !== item)
         {
            i++;
            if(!cursor.moveNext())
            {
               break;
            }
         }
         cursor.seek(CursorBookmark.FIRST,0);
         return i;
      }
      
      public function expandItem(item:Object, open:Boolean, animate:Boolean = false, dispatchEvent:Boolean = false, cause:Event = null) : void
      {
         var dur:Number;
         var rC:int;
         var event:CollectionEvent;
         var bSelected:Boolean;
         var rowsToMove:int;
         var bookmark:CursorBookmark;
         var bCaret:Boolean;
         var uid:String;
         var bHighlight:Boolean;
         var i:int = 0;
         var newRowIndex:int = 0;
         var rowData:BaseListData = null;
         var tmpMask:DisplayObject = null;
         var tmpRowInfo:Object = null;
         var row:Array = null;
         var n:int = 0;
         var eventArr:Array = null;
         var renderer:IListItemRenderer = null;
         var xx:Number = NaN;
         var ww:Number = NaN;
         var yy:Number = NaN;
         var hh:Number = NaN;
         var delta:int = 0;
         var maxDist:Number = NaN;
         var oE:Function = null;
         var di:IDropInListItemRenderer = null;
         var treeListData:TreeListData = null;
         var data:Object = null;
         var referenceRowInfo:ListRowInfo = null;
         var rh:Number = NaN;
         var more:Boolean = false;
         var valid:Boolean = false;
         var startY:Number = NaN;
         var maskY:Number = NaN;
         var maskX:Number = NaN;
         var indicator:Object = null;
         if(iterator == null)
         {
            return;
         }
         if(Boolean(cause))
         {
            lastUserInteraction = cause;
         }
         expandedItem = item;
         listContent.allowItemSizeChangeNotification = false;
         bSelected = false;
         bHighlight = false;
         bCaret = false;
         uid = itemToUID(item);
         if(!isBranch(item) || isItemOpen(item) == open || isOpening)
         {
            return;
         }
         if(Boolean(itemEditorInstance))
         {
            endEdit(ListEventReason.OTHER);
         }
         oldLength = collectionLength;
         bookmark = iterator.bookmark;
         event = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,false,true,CollectionEventKind.EXPAND);
         event.items = [item];
         if(open)
         {
            _openItems[uid] = item;
            collection.dispatchEvent(event);
            rowsTweened = Math.abs(oldLength - collection.length);
         }
         else
         {
            delete _openItems[uid];
            collection.dispatchEvent(event);
            rowsTweened = Math.abs(oldLength - collection.length);
         }
         if(isItemVisible(item))
         {
            if(Boolean(visibleData[uid]))
            {
               n = int(listItems.length);
               for(rowIndex = 0; rowIndex < n; ++rowIndex)
               {
                  if(rowInfo[rowIndex].uid == uid)
                  {
                     ++rowIndex;
                     break;
                  }
               }
            }
            rC = int(listItems.length);
            rowsToMove = rowsTweened;
            dur = getStyle("openDuration");
            if(animate && rowIndex < rC && rowsToMove > 0 && rowsToMove < 20 && dur != 0)
            {
               if(Boolean(tween))
               {
                  tween.endTween();
               }
               renderer = listItems[rowIndex - 1][0];
               if(renderer is IDropInListItemRenderer)
               {
                  di = IDropInListItemRenderer(renderer);
                  treeListData = TreeListData(di.listData);
                  treeListData = TreeListData(makeListData(treeListData.item,treeListData.uid,treeListData.rowIndex));
                  di.listData = treeListData;
                  renderer.data = renderer.data;
               }
               opening = open;
               isOpening = true;
               maskList = [];
               rowList = [];
               xx = getStyle("paddingLeft") - horizontalScrollPosition;
               ww = Number(renderer.width);
               yy = 0;
               delta = rowIndex;
               maxDist = 0;
               if(open)
               {
                  newRowIndex = rowIndex;
                  maxDist = listContent.height - rowInfo[rowIndex].y;
                  iterator.seek(CursorBookmark.CURRENT,delta);
                  i = 0;
                  while(i < rowsToMove && yy < maxDist)
                  {
                     data = iterator.current;
                     if(Boolean(freeItemRenderers.length))
                     {
                        renderer = freeItemRenderers.pop();
                     }
                     else
                     {
                        renderer = createItemRenderer(data);
                        renderer.owner = this;
                        renderer.styleName = listContent;
                        listContent.addChild(DisplayObject(renderer));
                     }
                     uid = itemToUID(data);
                     rowData = makeListData(data,uid,rowIndex + i);
                     rowMap[renderer.name] = rowData;
                     if(renderer is IDropInListItemRenderer)
                     {
                        IDropInListItemRenderer(renderer).listData = Boolean(data) ? rowData : null;
                     }
                     renderer.data = data;
                     renderer.enabled = enabled;
                     if(Boolean(data))
                     {
                        visibleData[uid] = renderer;
                        renderer.visible = true;
                     }
                     else
                     {
                        renderer.visible = false;
                     }
                     renderer.explicitWidth = ww;
                     if(renderer is IInvalidating && (wordWrapChanged || variableRowHeight))
                     {
                        IInvalidating(renderer).invalidateSize();
                     }
                     UIComponentGlobals.layoutManager.validateClient(renderer,true);
                     hh = Math.ceil(variableRowHeight ? renderer.getExplicitOrMeasuredHeight() + cachedPaddingTop + cachedPaddingBottom : rowHeight);
                     rh = Number(renderer.getExplicitOrMeasuredHeight());
                     renderer.setActualSize(ww,variableRowHeight ? rh : rowHeight - cachedPaddingTop - cachedPaddingBottom);
                     renderer.move(xx,yy + cachedPaddingTop);
                     bSelected = selectedData[uid] != null;
                     bHighlight = highlightUID == uid;
                     bCaret = caretUID == uid;
                     tmpRowInfo = new ListRowInfo(yy,hh,uid,data);
                     if(Boolean(data))
                     {
                        drawItem(renderer,bSelected,bHighlight,bCaret);
                     }
                     yy += hh;
                     rowInfo.splice(rowIndex + i,0,tmpRowInfo);
                     row = [];
                     row.push(renderer);
                     listItems.splice(rowIndex + i,0,row);
                     if(i < rowsToMove - 1)
                     {
                        try
                        {
                           iterator.moveNext();
                        }
                        catch(e:ItemPendingError)
                        {
                           rowsToMove = i + 1;
                           break;
                        }
                     }
                     i++;
                  }
                  rowsTweened = i;
                  referenceRowInfo = rowInfo[rowIndex + rowsTweened];
                  for(i = 0; i < rowsTweened; i++)
                  {
                     renderer = listItems[rowIndex + i][0];
                     renderer.move(renderer.x,renderer.y - (yy - referenceRowInfo.y));
                     rowInfo[rowIndex + i].y -= yy - referenceRowInfo.y;
                     tmpMask = makeMask();
                     tmpMask.x = xx;
                     tmpMask.y = referenceRowInfo.y;
                     tmpMask.width = ww;
                     tmpMask.height = yy;
                     listItems[rowIndex + i][0].mask = tmpMask;
                  }
               }
               else
               {
                  more = true;
                  valid = true;
                  startY = yy = rowInfo[listItems.length - 1].y + rowInfo[listItems.length - 1].height;
                  i = rowIndex;
                  while(i < rowIndex + rowsToMove && i < rC)
                  {
                     maxDist += rowInfo[i].height;
                     rowList.push({"item":listItems[i][0]});
                     tmpMask = makeMask();
                     tmpMask.x = xx;
                     tmpMask.y = listItems[rowIndex][0].y;
                     tmpMask.width = ww;
                     tmpMask.height = maxDist;
                     listItems[i][0].mask = tmpMask;
                     i++;
                  }
                  rowsToMove = i - rowIndex;
                  rowInfo.splice(rowIndex,rowsToMove);
                  listItems.splice(rowIndex,rowsToMove);
                  iterator.seek(CursorBookmark.CURRENT,listItems.length);
                  more = iterator != null && !iterator.afterLast && iteratorValid;
                  maxDist += yy;
                  i = 0;
                  while(i < rowsToMove && yy < maxDist)
                  {
                     uid = null;
                     data = null;
                     renderer = null;
                     valid = more;
                     data = more ? iterator.current : null;
                     if(valid)
                     {
                        if(Boolean(freeItemRenderers.length))
                        {
                           renderer = freeItemRenderers.pop();
                        }
                        else
                        {
                           renderer = createItemRenderer(data);
                           renderer.owner = this;
                           renderer.styleName = listContent;
                           listContent.addChild(DisplayObject(renderer));
                        }
                        uid = itemToUID(data);
                        rowData = makeListData(data,uid,rC - rowsToMove + i);
                        rowMap[renderer.name] = rowData;
                        if(renderer is IDropInListItemRenderer)
                        {
                           IDropInListItemRenderer(renderer).listData = Boolean(data) ? rowData : null;
                        }
                        renderer.data = data;
                        renderer.enabled = enabled;
                        if(Boolean(data))
                        {
                           visibleData[uid] = renderer;
                           renderer.visible = true;
                        }
                        else
                        {
                           renderer.visible = false;
                        }
                        renderer.explicitWidth = ww;
                        if(renderer is IInvalidating && (wordWrapChanged || variableRowHeight))
                        {
                           IInvalidating(renderer).invalidateSize();
                        }
                        UIComponentGlobals.layoutManager.validateClient(renderer,true);
                        hh = Math.ceil(variableRowHeight ? renderer.getExplicitOrMeasuredHeight() + cachedPaddingTop + cachedPaddingBottom : rowHeight);
                        rh = Number(renderer.getExplicitOrMeasuredHeight());
                        renderer.setActualSize(ww,variableRowHeight ? rh : rowHeight - cachedPaddingTop - cachedPaddingBottom);
                        renderer.move(xx,yy + cachedPaddingTop);
                     }
                     else if(!variableRowHeight)
                     {
                        hh = rowIndex + i > 0 ? Number(rowInfo[rowIndex + i - 1].height) : rowHeight;
                     }
                     else if(Boolean(rowList[i]))
                     {
                        hh = Math.ceil(rowList[i].item.getExplicitOrMeasuredHeight() + cachedPaddingTop + cachedPaddingBottom);
                     }
                     else
                     {
                        hh = rowHeight;
                     }
                     bSelected = selectedData[uid] != null;
                     bHighlight = highlightUID == uid;
                     bCaret = caretUID == uid;
                     tmpRowInfo = new ListRowInfo(yy,hh,uid,data);
                     rowInfo.push(tmpRowInfo);
                     if(Boolean(data))
                     {
                        drawItem(renderer,bSelected,bHighlight,bCaret);
                     }
                     yy += hh;
                     if(valid)
                     {
                        row = [];
                        row.push(renderer);
                        listItems.push(row);
                     }
                     else
                     {
                        listItems.push([]);
                     }
                     if(more)
                     {
                        try
                        {
                           more = iterator.moveNext();
                        }
                        catch(e:ItemPendingError)
                        {
                           more = false;
                        }
                     }
                     i++;
                  }
                  maskY = rowList[0].item.y - getStyle("paddingTop");
                  maskX = rowList[0].item.x - getStyle("paddingLeft");
                  for(i = 0; i < rowList.length; i++)
                  {
                     indicator = selectionIndicators[itemToUID(rowList[i].item.data)];
                     if(Boolean(indicator))
                     {
                        tmpMask = makeMask();
                        tmpMask.x = maskX;
                        tmpMask.y = maskY;
                        tmpMask.width = rowList[i].item.width + getStyle("paddingLeft") + getStyle("paddingRight");
                        tmpMask.height = rowList[i].item.y + rowList[i].item.height + getStyle("paddingTop") + getStyle("paddingBottom") - maskY;
                        selectionIndicators[itemToUID(rowList[i].item.data)].mask = tmpMask;
                     }
                  }
               }
               iterator.seek(bookmark,0);
               rC = int(rowList.length);
               for(i = 0; i < rC; i++)
               {
                  rowList[i].itemOldY = rowList[i].item.y;
               }
               rC = int(listItems.length);
               for(i = rowIndex; i < rC; i++)
               {
                  if(Boolean(listItems[i].length))
                  {
                     rowInfo[i].itemOldY = listItems[i][0].y;
                  }
                  rowInfo[i].oldY = rowInfo[i].y;
               }
               dur *= Math.max(rowsToMove / 5,1);
               if(dispatchEvent)
               {
                  eventAfterTween = item;
               }
               tween = new Tween(this,0,open ? yy : startY - yy,dur,5);
               oE = getStyle("openEasingFunction") as Function;
               if(oE != null)
               {
                  tween.easingFunction = oE;
               }
               UIComponent.suspendBackgroundProcessing();
               UIComponentGlobals.layoutManager.validateNow();
            }
            else
            {
               if(dispatchEvent)
               {
                  dispatchTreeEvent(open ? TreeEvent.ITEM_OPEN : TreeEvent.ITEM_CLOSE,item,visibleData[itemToUID(item)],lastUserInteraction);
                  lastUserInteraction = null;
               }
               itemsSizeChanged = true;
               invalidateDisplayList();
            }
            if(!wordWrap && initialized)
            {
               super.maxHorizontalScrollPosition = _userMaxHorizontalScrollPosition > 0 ? _userMaxHorizontalScrollPosition + getIndent() : super.maxHorizontalScrollPosition;
            }
            listContent.allowItemSizeChangeNotification = variableRowHeight;
            return;
         }
         eventArr = open ? buildUpCollectionEvents(true) : buildUpCollectionEvents(false);
         for(i = 0; i < eventArr.length; i++)
         {
            collection.dispatchEvent(eventArr[i]);
         }
      }
      
      override protected function commitProperties() : void
      {
         var tmpCollection:ICollectionView = null;
         var rootItem:* = undefined;
         if(showRootChanged)
         {
            if(!_hasRoot)
            {
               showRootChanged = false;
            }
         }
         if(dataProviderChanged || showRootChanged || openItemsChanged)
         {
            dataProviderChanged = false;
            showRootChanged = false;
            if(!openItemsChanged)
            {
               _openItems = {};
            }
            if(Boolean(_rootModel) && Boolean(!_showRoot) && _hasRoot)
            {
               rootItem = _rootModel.createCursor().current;
               if(rootItem != null && _dataDescriptor.isBranch(rootItem,_rootModel) && _dataDescriptor.hasChildren(rootItem,_rootModel))
               {
                  tmpCollection = getChildren(rootItem,_rootModel);
               }
            }
            if(Boolean(_rootModel))
            {
               super.dataProvider = wrappedCollection = _dataDescriptor is ITreeDataDescriptor2 ? ITreeDataDescriptor2(_dataDescriptor).getHierarchicalCollectionAdaptor(tmpCollection != null ? tmpCollection : _rootModel,itemToUID,_openItems) : new HierarchicalCollectionView(tmpCollection != null ? tmpCollection : _rootModel,_dataDescriptor,itemToUID,_openItems);
               wrappedCollection.addEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler,false,EventPriority.DEFAULT_HANDLER,true);
            }
            else
            {
               super.dataProvider = null;
            }
         }
         super.commitProperties();
      }
      
      public function getParentItem(item:Object) : *
      {
         if(item == null)
         {
            return null;
         }
         if(Boolean(item) && Boolean(collection))
         {
            if(_dataDescriptor is ITreeDataDescriptor2)
            {
               return ITreeDataDescriptor2(_dataDescriptor).getParent(item,wrappedCollection,_rootModel);
            }
            return HierarchicalCollectionView(collection).getParentItem(item);
         }
         return null;
      }
      
      [Bindable("firstVisibleItemChanged")]
      public function get firstVisibleItem() : Object
      {
         if(listItems.length > 0 && listItems[0].length > 0)
         {
            return listItems[0][0].data;
         }
         return null;
      }
      
      private function getCurrentCursorDepth() : int
      {
         if(_dataDescriptor is ITreeDataDescriptor2)
         {
            return ITreeDataDescriptor2(_dataDescriptor).getNodeDepth(iterator.current,iterator,_rootModel);
         }
         return HierarchicalViewCursor(iterator).currentDepth;
      }
      
      override public function get maxHorizontalScrollPosition() : Number
      {
         return _userMaxHorizontalScrollPosition > 0 ? _userMaxHorizontalScrollPosition : super.maxHorizontalScrollPosition;
      }
      
      private function getOpenChildrenStack(item:Object, stack:Array) : Array
      {
         var curr:Object = null;
         if(item == null)
         {
            return stack;
         }
         var children:ICollectionView = getChildren(item,iterator.view);
         if(!children)
         {
            return [];
         }
         var cursor:IViewCursor = children.createCursor();
         while(!cursor.afterLast)
         {
            curr = cursor.current;
            stack.push(curr);
            if(isBranch(curr) && isItemOpen(curr))
            {
               getOpenChildrenStack(curr,stack);
            }
            cursor.moveNext();
         }
         return stack;
      }
      
      override protected function dragDropHandler(event:DragEvent) : void
      {
         var items:Array = null;
         var i:int = 0;
         var n:int = 0;
         var index:int = 0;
         var parent:* = undefined;
         var parentItem:* = undefined;
         var dropIndex:int = 0;
         var dropParentStack:Array = null;
         var item:Object = null;
         if(event.isDefaultPrevented())
         {
            return;
         }
         hideDropFeedback(event);
         if(event.dragSource.hasFormat("treeItems"))
         {
            items = event.dragSource.dataForFormat("treeItems") as Array;
            if(event.action == DragManager.MOVE && dragMoveEnabled)
            {
               if(event.dragInitiator == this)
               {
                  calculateDropIndex(event);
                  dropIndex = int(_dropData.index);
                  dropParentStack = getParentStack(_dropData.parent);
                  dropParentStack.unshift(_dropData.parent);
                  n = int(items.length);
                  loop0:
                  for(i = 0; i < n; )
                  {
                     parent = getParentItem(items[i]);
                     index = getChildIndexInParent(parent,items[i]);
                     var _loc11_:int = 0;
                     var _loc12_:* = dropParentStack;
                     do
                     {
                        for each(parentItem in _loc12_)
                        {
                        }
                        removeChildItem(parent,items[i],index);
                        if(parent == _dropData.parent && index < _dropData.index)
                        {
                           dropIndex--;
                        }
                        addChildItem(_dropData.parent,items[i],dropIndex);
                        i++;
                        continue loop0;
                     }
                     while(items[i] !== parentItem);
                     return;
                  }
                  return;
               }
            }
            if(event.action == DragManager.COPY)
            {
               if(!dataProvider)
               {
                  dataProvider = [];
                  validateNow();
               }
               n = int(items.length);
               for(i = 0; i < n; i++)
               {
                  item = copyItemWithUID(items[i]);
                  addChildItem(_dropData.parent,item,_dropData.index);
               }
            }
         }
         lastDragEvent = null;
      }
      
      private function checkItemIndices(event:DragEvent) : void
      {
         var items:Array = null;
         var n:int = 0;
         var i:int = 0;
         var parent:Object = null;
         if(haveItemIndices)
         {
            return;
         }
         if((event.action == DragManager.MOVE || event.action == DragManager.NONE) && dragMoveEnabled)
         {
            if(event.dragInitiator == this)
            {
               items = event.dragSource.dataForFormat("treeItems") as Array;
               n = int(items.length);
               for(i = 0; i < n; i++)
               {
                  parent = getParentItem(items[i]);
                  getChildIndexInParent(parent,items[i]);
               }
               haveItemIndices = true;
            }
         }
      }
      
      override protected function mouseClickHandler(event:MouseEvent) : void
      {
         if(!tween)
         {
            super.mouseClickHandler(event);
         }
      }
      
      override protected function mouseOverHandler(event:MouseEvent) : void
      {
         if(!tween)
         {
            super.mouseOverHandler(event);
         }
      }
      
      private function seekPendingDuringDragFailureHandler(data:Object, info:TreeSeekPending) : void
      {
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         if(Boolean(tween))
         {
            tween.endTween();
         }
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(Boolean(collection))
         {
            collectionLength = collection.length;
         }
      }
      
      private function makeMask() : DisplayObject
      {
         var tmpMask:Shape = new FlexShape();
         tmpMask.name = "mask";
         var g:Graphics = tmpMask.graphics;
         g.beginFill(16777215);
         g.moveTo(0,0);
         g.lineTo(0,10);
         g.lineTo(10,10);
         g.lineTo(10,0);
         g.lineTo(0,0);
         g.endFill();
         listContent.addChild(tmpMask);
         return tmpMask;
      }
      
      override protected function dragCompleteHandler(event:DragEvent) : void
      {
         var items:Array = null;
         var parent:* = undefined;
         var index:int = 0;
         var i:int = 0;
         var n:int = 0;
         var targetTree:Tree = null;
         var item:Object = null;
         isPressed = false;
         if(event.isDefaultPrevented())
         {
            return;
         }
         resetDragScrolling();
         try
         {
            if(event.dragSource.hasFormat("treeItems"))
            {
               if(event.action == DragManager.MOVE && dragMoveEnabled)
               {
                  if(event.relatedObject != this)
                  {
                     items = event.dragSource.dataForFormat("treeItems") as Array;
                     n = int(items.length);
                     for(i = 0; i < n; i++)
                     {
                        parent = getParentItem(items[i]);
                        index = getChildIndexInParent(parent,items[i]);
                        removeChildItem(parent,items[i],index);
                     }
                     if(event.relatedObject is Tree)
                     {
                        targetTree = Tree(event.relatedObject);
                        if(!targetTree.dataProvider)
                        {
                           targetTree.dataProvider = [];
                           targetTree.validateNow();
                        }
                        n = int(items.length);
                        for(i = 0; i < n; i++)
                        {
                           item = items[i];
                           targetTree.addChildItem(targetTree._dropData.parent,item,targetTree._dropData.index);
                        }
                     }
                  }
                  clearSelected(false);
               }
            }
         }
         catch(e:ItemPendingError)
         {
            e.addResponder(new ItemResponder(seekPendingDuringDragResultHandler,seekPendingDuringDragFailureHandler,new TreeSeekPending(event,dragCompleteHandler)));
         }
         lastDragEvent = null;
      }
      
      public function set showRoot(value:Boolean) : void
      {
         if(_showRoot != value)
         {
            _showRoot = value;
            showRootChanged = true;
            invalidateProperties();
         }
      }
   }
}

import mx.events.DragEvent;

class TreeSeekPending
{
   
   public var retryFunction:Function;
   
   public var event:DragEvent;
   
   public function TreeSeekPending(event:DragEvent, retryFunction:Function)
   {
      super();
      this.event = event;
      this.retryFunction = retryFunction;
   }
}
