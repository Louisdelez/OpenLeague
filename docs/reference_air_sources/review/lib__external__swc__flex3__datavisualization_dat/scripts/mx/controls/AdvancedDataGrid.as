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
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import mx.collections.ArrayCollection;
   import mx.collections.CursorBookmark;
   import mx.collections.HierarchicalCollectionView;
   import mx.collections.HierarchicalCollectionViewCursor;
   import mx.collections.HierarchicalData;
   import mx.collections.ICollectionView;
   import mx.collections.IGroupingCollection;
   import mx.collections.IHierarchicalCollectionView;
   import mx.collections.IHierarchicalData;
   import mx.collections.IViewCursor;
   import mx.collections.ItemResponder;
   import mx.collections.Sort;
   import mx.collections.SortField;
   import mx.collections.SummaryObject;
   import mx.collections.errors.ItemPendingError;
   import mx.controls.advancedDataGridClasses.AdvancedDataGridBaseSelectionData;
   import mx.controls.advancedDataGridClasses.AdvancedDataGridBaseSelectionPending;
   import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
   import mx.controls.advancedDataGridClasses.AdvancedDataGridColumnGroup;
   import mx.controls.advancedDataGridClasses.AdvancedDataGridGroupItemRenderer;
   import mx.controls.advancedDataGridClasses.AdvancedDataGridHeaderInfo;
   import mx.controls.advancedDataGridClasses.AdvancedDataGridListData;
   import mx.controls.advancedDataGridClasses.AdvancedDataGridRendererDescription;
   import mx.controls.advancedDataGridClasses.IAdvancedDataGridRendererProvider;
   import mx.controls.advancedDataGridClasses.SortInfo;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.controls.listClasses.ListBaseSeekPending;
   import mx.controls.listClasses.ListRowInfo;
   import mx.core.ClassFactory;
   import mx.core.EdgeMetrics;
   import mx.core.EventPriority;
   import mx.core.FlexShape;
   import mx.core.FlexSprite;
   import mx.core.IDataRenderer;
   import mx.core.IFactory;
   import mx.core.IFlexDisplayObject;
   import mx.core.IInvalidating;
   import mx.core.IUITextField;
   import mx.core.ScrollPolicy;
   import mx.core.SpriteAsset;
   import mx.core.UIComponent;
   import mx.core.UIComponentGlobals;
   import mx.effects.Tween;
   import mx.events.AdvancedDataGridEvent;
   import mx.events.AdvancedDataGridEventReason;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.DragEvent;
   import mx.events.FlexEvent;
   import mx.events.IndexChangedEvent;
   import mx.events.ListEvent;
   import mx.events.ListEventReason;
   import mx.events.ScrollEvent;
   import mx.events.ScrollEventDetail;
   import mx.events.ScrollEventDirection;
   import mx.events.TweenEvent;
   import mx.managers.DragManager;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.styles.ISimpleStyleClient;
   import mx.styles.IStyleClient;
   import mx.styles.StyleManager;
   import mx.utils.UIDUtil;
   
   [ResourceBundle("datamanagement")]
   [AccessibilityClass(implementation="mx.accessibility.AdvancedDataGridAccImpl")]
   [Style(name="sortFontWeight",type="String",enumeration="normal,bold",inherit="yes")]
   [Style(name="sortFontStyle",type="String",enumeration="normal,italic",inherit="yes")]
   [Style(name="sortFontSize",type="Number",format="Length",inherit="yes")]
   [Style(name="sortFontFamily",type="String",inherit="yes")]
   [Style(name="textSelectedColor",type="uint",format="Color",inherit="yes")]
   [Style(name="textRollOverColor",type="uint",format="Color",inherit="yes")]
   [Style(name="selectionEasingFunction",type="Function",inherit="no")]
   [Style(name="selectionDisabledColor",type="uint",format="Color",inherit="yes")]
   [Style(name="headerHorizontalSeparatorSkin",type="Class",inherit="no")]
   [Style(name="headerSortSeparatorSkin",type="Class",inherit="no")]
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
   [Event(name="headerDropOutside",type="mx.events.AdvancedDataGridEvent")]
   [Event(name="headerDragOutside",type="mx.events.AdvancedDataGridEvent")]
   [Event(name="itemOpening",type="mx.events.AdvancedDataGridEvent")]
   [Event(name="itemOpen",type="mx.events.AdvancedDataGridEvent")]
   [Event(name="itemClose",type="mx.events.AdvancedDataGridEvent")]
   public class AdvancedDataGrid extends AdvancedDataGridBaseEx
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      public static const HEADER_TEXT_PART:String = "headerTextPart";
      
      public static const HEADER_ICON_PART:String = "headerIconPart";
      
      private static var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      private var _groupRowHeight:Number = -1;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var columnsToInfo:Dictionary = new Dictionary();
      
      private var designViewDataTypeChanged:Boolean = false;
      
      private var columnsChanged:Boolean = false;
      
      private var eventAfterTween:Object;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var cellSelectionIndicators:Object = {};
      
      private var _treeColumn:AdvancedDataGridColumn = null;
      
      private var dropInfo:AdvancedDataGridEvent;
      
      private var rowsTweened:int;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var firstCellSelectionData:AdvancedDataGridBaseSelectionData;
      
      private var groupLabelField:String;
      
      private var headerSelected:Boolean = true;
      
      protected var cellSelectionTweens:Object = {};
      
      private var numSeparators:int = 0;
      
      private var selectedCellsChanged:Boolean = false;
      
      protected var tween:Object;
      
      private var bSelectedItemRemoved:Boolean = false;
      
      private var headerItemsList:Array;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var columnGrouping:Boolean = false;
      
      private var isMeasuringHeader:Boolean;
      
      private var _displayDisclosureIcon:Boolean = true;
      
      private var lastHeaderInfos:Array;
      
      private var dataProviderChanged:Boolean = false;
      
      private var _groupItemRenderer:IFactory;
      
      private var _rendererProviders:Array = [];
      
      private var eventItemRenderer:IListItemRenderer;
      
      private var _groupedColumns:Array;
      
      private var hierarchicalCollectionInstance:IHierarchicalCollectionView;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _dropData:Object;
      
      private var _temporary_selectedCells:Array = null;
      
      private var visualSortInfo:Dictionary = new Dictionary();
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var isOpening:Boolean = false;
      
      private var _userMaxHorizontalScrollPosition:Number = 0;
      
      private var designViewDataFlag:Boolean = false;
      
      private var designViewDataTreeType:String = "tree";
      
      private var _groupIconFunction:Function;
      
      protected var movingSelectionLayer:Sprite;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var cellSelectionData:Object = {};
      
      private var groupedColumnsChanged:Boolean = false;
      
      private var rowIndex:int;
      
      private var horizontalLockedSeparators:Array;
      
      protected var anchorColumnIndex:int = -1;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var collectionLength:int;
      
      private var _designViewDataType:String = designViewDataTreeType;
      
      private var designViewDataFlatType:String = "flat";
      
      private var _groupLabelFunction:Function;
      
      private var opening:Boolean;
      
      private var rendererDescriptionMap:Dictionary;
      
      private var expandedItem:Object;
      
      private var horizontalSeparators:Array;
      
      private var _columnsValue:Array;
      
      protected var _selectedCells:Array = [];
      
      protected var visibleCellRenderers:Object = {};
      
      private var _movingColumnIndex:int;
      
      protected var selectedColumnIndex:int = -1;
      
      private var _lockedColumnCountVal:int;
      
      protected var caretColumnIndex:int = -1;
      
      private var lastColumnWidth:Number = NaN;
      
      private var rowList:Array;
      
      private var headerDraggedOutside:Boolean = false;
      
      private var maskList:Array;
      
      private var displayItemsExpandedChanged:Boolean = false;
      
      private var lockedColumnCountChanged:Boolean = false;
      
      [Inspectable(category="Data")]
      public var itemIcons:Object;
      
      protected var highlightColumnIndex:int = -1;
      
      private var lastUserInteraction:Event;
      
      private var _displayItemsExpanded:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _rootModel:IHierarchicalData;
      
      private var oldStyles:Dictionary;
      
      private var _hierarchicalCollectionView:IHierarchicalCollectionView = new HierarchicalCollectionView();
      
      private var oldLength:int = -1;
      
      public function AdvancedDataGrid()
      {
         super();
         rendererDescriptionMap = new Dictionary(true);
         groupItemRenderer = new ClassFactory(AdvancedDataGridGroupItemRenderer);
         addEventListener(AdvancedDataGridEvent.ITEM_OPENING,expandItemHandler,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(FlexEvent.UPDATE_COMPLETE,updateCompleteHandler);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getRendererDescription(itemData:Object, c:AdvancedDataGridColumn, forDragProxy:Boolean = false) : AdvancedDataGridRendererDescription
      {
         var adgDescription:AdvancedDataGridRendererDescription = new AdvancedDataGridRendererDescription();
         var index:int = 0;
         var depth:int = 0;
         if(rendererProviders.length != 0)
         {
            if(forDragProxy)
            {
               index = getItemIndex(itemData);
            }
            depth = getItemDepth(itemData,index);
         }
         for(var i:int = 0; i < rendererProviders.length; i++)
         {
            IAdvancedDataGridRendererProvider(rendererProviders[i]).describeRendererForItem(itemData,depth,c,adgDescription);
            if(Boolean(adgDescription.renderer))
            {
               return adgDescription;
            }
         }
         return adgDescription;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get dataType() : String
      {
         if(Boolean(dataProvider))
         {
            return dataProvider is IHierarchicalCollectionView ? designViewDataTreeType : designViewDataFlatType;
         }
         return designViewDataTreeType;
      }
      
      override protected function dragOverHandler(event:DragEvent) : void
      {
         if(isCellSelectionMode())
         {
            return;
         }
         if(!(_rootModel is IHierarchicalData) && Boolean(event.dragSource.hasFormat("items")))
         {
            super.dragOverHandler(event);
            return;
         }
         if(event.isDefaultPrevented())
         {
            return;
         }
         if((!_rootModel || _rootModel is IHierarchicalData) && Boolean(event.dragSource.hasFormat("treeDataGridItems")))
         {
            DragManager.showFeedback(event.ctrlKey ? DragManager.COPY : DragManager.MOVE);
            showDropFeedback(event);
            return;
         }
         hideDropFeedback(event);
         DragManager.showFeedback(DragManager.NONE);
      }
      
      protected function drawHeaderHorizontalSeparators() : void
      {
         var childIndex:int = 0;
         var unlockedHeaderInfos:Array = null;
         var lockedHeaderInfos:Array = null;
         var lockedHeaderHorizontalLines:UIComponent = null;
         var vHeaderLines:UIComponent = null;
         var lockedContent:Sprite = null;
         var lockedHeaderLines:UIComponent = null;
         if(!horizontalSeparators)
         {
            horizontalSeparators = [];
            horizontalLockedSeparators = [];
         }
         var lines:Sprite = Sprite(listSubContent.getChildByName("lines"));
         var headerHorizontalLines:UIComponent = UIComponent(lines.getChildByName("headerHorizontalLines"));
         if(!headerHorizontalLines)
         {
            headerHorizontalLines = new UIComponent();
            headerHorizontalLines.name = "headerHorizontalLines";
            lines.addChild(headerHorizontalLines);
         }
         if(lines.numChildren > 1)
         {
            vHeaderLines = UIComponent(lines.getChildByName("header"));
            if(Boolean(vHeaderLines))
            {
               childIndex = lines.getChildIndex(vHeaderLines);
               if(childIndex + 1 < lines.numChildren)
               {
                  lines.setChildIndex(headerHorizontalLines,childIndex + 1);
               }
            }
         }
         numSeparators = 0;
         if(Boolean(visibleHeaderInfos))
         {
            if(!isNaN(_lockedColumnCountVal) && _lockedColumnCountVal > 0)
            {
               lockedHeaderInfos = visibleHeaderInfos.slice(0,_lockedColumnCountVal);
               unlockedHeaderInfos = visibleHeaderInfos.slice(_lockedColumnCountVal);
            }
            else
            {
               unlockedHeaderInfos = visibleHeaderInfos;
            }
            createHeaderHorizontalSeparators(unlockedHeaderInfos,horizontalSeparators,headerHorizontalLines);
         }
         while(headerHorizontalLines.numChildren > numSeparators)
         {
            headerHorizontalLines.removeChildAt(headerHorizontalLines.numChildren - 1);
            horizontalSeparators.pop();
         }
         numSeparators = 0;
         if(lockedColumnCount > 0)
         {
            lockedContent = getLockedContent();
            lockedHeaderHorizontalLines = UIComponent(lockedContent.getChildByName("lockedHeaderHorizontalLines"));
            if(!lockedHeaderHorizontalLines)
            {
               lockedHeaderHorizontalLines = new UIComponent();
               lockedHeaderHorizontalLines.name = "lockedHeaderHorizontalLines";
               lockedContent.addChild(lockedHeaderHorizontalLines);
            }
            if(lockedContent.numChildren > 1)
            {
               lockedHeaderLines = UIComponent(lockedContent.getChildByName("lockedHeaderLines"));
               if(Boolean(lockedHeaderLines))
               {
                  childIndex = lockedContent.getChildIndex(lockedHeaderLines);
                  if(childIndex + 1 < lines.numChildren)
                  {
                     lockedContent.setChildIndex(lockedHeaderHorizontalLines,childIndex + 1);
                  }
               }
            }
            createHeaderHorizontalSeparators(lockedHeaderInfos,horizontalLockedSeparators,lockedHeaderHorizontalLines);
         }
         if(Boolean(lockedHeaderHorizontalLines))
         {
            while(lockedHeaderHorizontalLines.numChildren > numSeparators)
            {
               lockedHeaderHorizontalLines.removeChildAt(lockedHeaderHorizontalLines.numChildren - 1);
               horizontalLockedSeparators.pop();
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get movingColumnIndex() : int
      {
         return _movingColumnIndex;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function addClipMask(layoutChanged:Boolean) : void
      {
         var bHScrollBar:Boolean = false;
         var vm:EdgeMetrics = viewMetrics;
         if(Boolean(horizontalScrollBar) && Boolean(horizontalScrollBar.visible))
         {
            vm.bottom -= horizontalScrollBar.minHeight;
         }
         if(Boolean(verticalScrollBar) && Boolean(verticalScrollBar.visible))
         {
            vm.right -= verticalScrollBar.minWidth;
         }
         if(Boolean(verticalScrollBar && verticalScrollBar.visible) && Boolean(horizontalScrollBar) && Boolean(horizontalScrollBar.visible))
         {
            vm.right += verticalScrollBar.minWidth;
         }
         listContent.scrollRect = new Rectangle(0,0,unscaledWidth - vm.left - vm.right,listContent.height);
      }
      
      override protected function finishKeySelection() : void
      {
         if(isCellSelectionMode())
         {
            finishCellKeySelection();
         }
         else
         {
            super.finishKeySelection();
         }
      }
      
      private function measureHeaderHeights(subHeaderInfos:Array, depth:uint) : Number
      {
         var i:int = 0;
         var currentGroupHeight:Number = NaN;
         var maxRowHeight:Number = 0;
         var padding:int = cachedPaddingTop + cachedPaddingBottom;
         var n:int = int(subHeaderInfos.length);
         for(i = 0; i < n; i++)
         {
            currentGroupHeight = _explicitHeaderHeight ? _headerHeight : subHeaderInfos[i].headerItem.getExplicitOrMeasuredHeight() + padding;
            if(Boolean(subHeaderInfos[i].visibleChildren))
            {
               currentGroupHeight += measureHeaderHeights(subHeaderInfos[i].visibleChildren,depth + 1);
            }
            maxRowHeight = Math.max(maxRowHeight,currentGroupHeight);
         }
         if(!headerRowInfo[depth])
         {
            headerRowInfo[depth] = new ListRowInfo(0,0,uid);
         }
         headerRowInfo[depth].height = Math.max(headerRowInfo[depth].height,maxRowHeight);
         return headerRowInfo[depth].height;
      }
      
      private function updateMovingColumnIndex() : void
      {
         var n:int = 0;
         var i:int = 0;
         movingColumnIndex = -1;
         if(Boolean(movingColumn))
         {
            n = Boolean(orderedHeadersList) ? int(orderedHeadersList.length) : 0;
            for(i = 0; i < n; i++)
            {
               if(orderedHeadersList[i].column == movingColumn)
               {
                  movingColumnIndex = i;
                  break;
               }
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removeChildItem(parent:Object, child:Object, index:Number) : Boolean
      {
         return IHierarchicalCollectionView(dataProvider).removeChildAt(parent,index);
      }
      
      protected function applyCellSelectionEffect(indicator:Sprite, uid:String, columnIndex:int, itemRenderer:IListItemRenderer) : void
      {
         var selectionDuration:Number = NaN;
         var selectionEasingFunction:Function = null;
         selectionDuration = Number(getStyle("selectionDuration"));
         if(selectionDuration != 0)
         {
            indicator.alpha = 0;
            if(!cellSelectionTweens[uid])
            {
               cellSelectionTweens[uid] = {};
            }
            cellSelectionTweens[uid][columnIndex.toString()] = new Tween(indicator,0,1,selectionDuration,5);
            cellSelectionTweens[uid][columnIndex.toString()].addEventListener(TweenEvent.TWEEN_UPDATE,selectionTween_updateHandler);
            cellSelectionTweens[uid][columnIndex.toString()].addEventListener(TweenEvent.TWEEN_END,selectionTween_endHandler);
            cellSelectionTweens[uid][columnIndex.toString()].setTweenHandlers(onSelectionTweenUpdate,onSelectionTweenUpdate);
            selectionEasingFunction = getStyle("selectionEasingFunction") as Function;
            if(selectionEasingFunction != null)
            {
               cellSelectionTweens[uid][columnIndex.toString()].easingFunction = selectionEasingFunction;
            }
         }
      }
      
      override protected function selectItem(item:IListItemRenderer, shiftKey:Boolean, ctrlKey:Boolean, transition:Boolean = true) : Boolean
      {
         if(isCellSelectionMode() && !selectedHeaderInfo)
         {
            return selectCellItem(item,shiftKey,ctrlKey,transition);
         }
         return super.selectItem(item,shiftKey,ctrlKey,transition);
      }
      
      public function set groupItemRenderer(value:IFactory) : void
      {
         _groupItemRenderer = value;
         invalidateSize();
         invalidateDisplayList();
         itemsSizeChanged = true;
         rendererChanged = true;
         dispatchEvent(new Event("itemRendererChanged"));
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setSelectedCells(value:Array) : void
      {
         var isFirstCell:Boolean = false;
         var n:int = 0;
         var i:int = 0;
         var visibleCoords:Object = null;
         var visibleRowIndex:int = 0;
         var visibleColIndex:int = 0;
         var listItem:IListItemRenderer = null;
         isFirstCell = true;
         n = int(value.length);
         for(i = 0; i < n; i++)
         {
            if(!isCellAlreadySelected(value[i]))
            {
               visibleCoords = absoluteToVisibleIndices(value[i].rowIndex,value[i].columnIndex);
               visibleRowIndex = int(visibleCoords.rowIndex);
               visibleColIndex = int(visibleCoords.columnIndex);
               if(Boolean(listItems[visibleRowIndex]) && Boolean(listItems[visibleRowIndex][visibleColIndex]))
               {
                  listItem = listItems[visibleRowIndex][visibleColIndex];
                  if(isFirstCell)
                  {
                     selectCellItem(listItem,false,false);
                     isFirstCell = false;
                  }
                  else
                  {
                     selectCellItem(listItem,false,true);
                  }
               }
               else
               {
                  addToSelectedCells(value[i].rowIndex,value[i].columnIndex);
                  pendingCellSelection.addItem(value[i]);
                  cellsWaitingToBeDisplayed = true;
               }
            }
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getRenderer(c:AdvancedDataGridColumn, itemData:Object, forDragProxy:Boolean = false) : IListItemRenderer
      {
         var renderer:IListItemRenderer = null;
         var factory:IFactory = null;
         var adgDescription:AdvancedDataGridRendererDescription = null;
         if(rendererProviders.length != 0)
         {
            adgDescription = getRendererDescription(itemData,c,forDragProxy);
         }
         if(Boolean(adgDescription) && Boolean(adgDescription.renderer))
         {
            if(Boolean(freeItemRenderersTable[c]) && Boolean(freeItemRenderersTable[c][adgDescription.renderer]) && Boolean(freeItemRenderersTable[c][adgDescription.renderer].length))
            {
               renderer = freeItemRenderersTable[c][adgDescription.renderer].pop();
            }
            else
            {
               renderer = adgDescription.renderer.newInstance();
               itemRendererToFactoryMap[renderer] = adgDescription.renderer;
            }
            rendererDescriptionMap[renderer] = adgDescription;
            return renderer;
         }
         return super.getRenderer(c,itemData,forDragProxy);
      }
      
      public function set rendererProviders(value:Array) : void
      {
         _rendererProviders = value;
         invalidateSize();
         invalidateDisplayList();
         itemsSizeChanged = true;
         rendererChanged = true;
      }
      
      protected function clearSelectedCells(transition:Boolean = false) : void
      {
         var uniqueID:String = null;
         var columnIndexString:String = null;
         var data:Object = null;
         var item:IListItemRenderer = null;
         for(uniqueID in cellSelectionData)
         {
            for(columnIndexString in cellSelectionData[uniqueID])
            {
               data = cellSelectionData[uniqueID][columnIndexString].data;
               removeCellSelectionData(uniqueID,int(columnIndexString));
               if(Boolean(visibleCellRenderers[itemToUID(data)]))
               {
                  item = visibleCellRenderers[itemToUID(data)][columnIndexString];
               }
               if(Boolean(item))
               {
                  drawCellItem(item,false,uniqueID == highlightUID && highlightColumnIndex == int(columnIndexString),false,transition);
               }
            }
         }
         _selectedCells = [];
         clearCellSelectionData();
         _selectedIndex = -1;
         selectedItem = null;
         caretIndex = -1;
         anchorIndex = -1;
         caretBookmark = null;
         anchorBookmark = null;
      }
      
      protected function clearCellSelectionData() : void
      {
         cellSelectionData = {};
         firstCellSelectionData = null;
      }
      
      protected function applyUserStylesForItemRenderer(givenItemRenderer:IListItemRenderer) : void
      {
         var styleName:String = null;
         var newStyles:Object = null;
         if(!givenItemRenderer)
         {
            return;
         }
         if(!(givenItemRenderer is IStyleClient && givenItemRenderer is IDataRenderer && givenItemRenderer is DisplayObject))
         {
            return;
         }
         var itemRenderer:IStyleClient = givenItemRenderer as IStyleClient;
         var column:AdvancedDataGridColumn = columnMap[DisplayObject(itemRenderer).name];
         if(!oldStyles)
         {
            oldStyles = new Dictionary(true);
         }
         if(Boolean(oldStyles[itemRenderer]))
         {
            for(styleName in oldStyles[itemRenderer])
            {
               itemRenderer.setStyle(styleName,oldStyles[itemRenderer][styleName]);
            }
            delete oldStyles[itemRenderer];
         }
         if(styleFunction != null)
         {
            newStyles = styleFunction(IDataRenderer(itemRenderer).data,column);
            if(Boolean(newStyles))
            {
               for(styleName in newStyles)
               {
                  if(!oldStyles[itemRenderer])
                  {
                     oldStyles[itemRenderer] = {};
                  }
                  oldStyles[itemRenderer][styleName] = itemRenderer.getStyle(styleName);
                  itemRenderer.setStyle(styleName,newStyles[styleName]);
               }
            }
         }
         if(Boolean(column) && column.styleFunction != null)
         {
            newStyles = column.styleFunction(IDataRenderer(itemRenderer).data,column);
            if(Boolean(newStyles))
            {
               for(styleName in newStyles)
               {
                  if(!oldStyles[itemRenderer])
                  {
                     oldStyles[itemRenderer] = {};
                  }
                  if(!oldStyles[itemRenderer][styleName])
                  {
                     oldStyles[itemRenderer][styleName] = itemRenderer.getStyle(styleName);
                  }
                  itemRenderer.setStyle(styleName,newStyles[styleName]);
               }
            }
         }
      }
      
      public function get hierarchicalCollectionView() : IHierarchicalCollectionView
      {
         return IHierarchicalCollectionView(_hierarchicalCollectionView);
      }
      
      override protected function makeRowsAndColumns(left:Number, top:Number, right:Number, bottom:Number, firstCol:int, firstRow:int, byCount:Boolean = false, rowsNeeded:uint = 0) : Point
      {
         if(!visibleColumns || visibleColumns.length == 0)
         {
            visibleCellRenderers = {};
         }
         return super.makeRowsAndColumns(left,top,right,bottom,firstCol,firstRow,byCount,rowsNeeded);
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
            if(Boolean(visibleData[uid]) && Boolean(IHierarchicalCollectionView(collection).openNodes[uid]))
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
      
      override public function set verticalScrollPosition(value:Number) : void
      {
         var oldAnchorColumnIndex:int = 0;
         var oldSelectedColumnIndex:int = 0;
         oldAnchorColumnIndex = anchorColumnIndex;
         var oldCaretColumnIndex:int = caretColumnIndex;
         oldSelectedColumnIndex = selectedColumnIndex;
         super.verticalScrollPosition = value;
         anchorColumnIndex = oldAnchorColumnIndex;
         caretColumnIndex = oldCaretColumnIndex;
         selectedColumnIndex = oldSelectedColumnIndex;
         if(rendererProviders.length != 0)
         {
            drawVerticalSeparators();
         }
         if(!variableRowHeight && groupRowHeight != -1 && groupRowHeight != rowHeight)
         {
            drawHorizontalSeparators();
         }
         if(cellsWaitingToBeDisplayed)
         {
            processCellsWaitingToBeDisplayed();
         }
      }
      
      override public function calculateDropIndex(event:DragEvent = null) : int
      {
         if(Boolean(event))
         {
            if(_rootModel is IHierarchicalData)
            {
               if(Boolean(event))
               {
                  updateDropData(event);
               }
               return _dropData.rowIndex;
            }
         }
         return super.calculateDropIndex(event);
      }
      
      protected function processCellsWaitingToBeDisplayed() : void
      {
         var i:int = 0;
         var visibleCoords:Object = null;
         var visibleRowIndex:int = 0;
         var visibleColIndex:int = 0;
         var listItem:IListItemRenderer = null;
         var pendingCellsDisplayed:Array = [];
         var n:int = int(pendingCellSelection.length);
         for(i = 0; i < n; i++)
         {
            visibleCoords = absoluteToVisibleIndices(pendingCellSelection[i].rowIndex,pendingCellSelection[i].columnIndex);
            visibleRowIndex = int(visibleCoords.rowIndex);
            visibleColIndex = int(visibleCoords.columnIndex);
            if(Boolean(listItems[visibleRowIndex]) && Boolean(listItems[visibleRowIndex][visibleColIndex]))
            {
               listItem = listItems[visibleRowIndex][visibleColIndex];
               selectCellItem(listItem,false,true);
               pendingCellsDisplayed.push(i);
            }
         }
         pendingCellsDisplayed.sort(Array.NUMERIC | Array.DESCENDING);
         n = int(pendingCellsDisplayed.length);
         for(i = 0; i < n; i++)
         {
            pendingCellSelection.removeItemAt(pendingCellsDisplayed[i]);
         }
         if(pendingCellSelection.length == 0)
         {
            cellsWaitingToBeDisplayed = false;
         }
      }
      
      override protected function setupRenderer(itemData:Object, uid:String, insertItems:Boolean = false) : void
      {
         var item:IListItemRenderer = null;
         var adgDescription:AdvancedDataGridRendererDescription = null;
         var savedColNum:int = currentColNum;
         super.setupRenderer(itemData,uid,insertItems);
         if(rendererProviders.length == 0)
         {
            return;
         }
         var itemCount:int = int(listItems[currentRowNum].length);
         var count:int = 0;
         var optimumColumns:Array = getOptimumColumns();
         for(var i:int = 0; i < itemCount; i++)
         {
            item = listItems[currentRowNum][i];
            adgDescription = rendererDescriptionMap[item];
            if(Boolean(adgDescription) && Boolean(adgDescription.renderer))
            {
               if(adgDescription.columnSpan == 0)
               {
                  count = Math.max(count - 1,optimumColumns.length - i);
               }
               else
               {
                  count = Math.max(count - 1,adgDescription.columnSpan - 1);
               }
            }
            else if(count > 0)
            {
               item.visible = false;
               count--;
            }
         }
      }
      
      override protected function mouseDownHandler(event:MouseEvent) : void
      {
         if(!tween)
         {
            super.mouseDownHandler(event);
            updateSelectedCells();
         }
      }
      
      override protected function itemRendererToIndices(item:IListItemRenderer) : Point
      {
         var pt:Point = null;
         if(isHeaderItemRenderer(item))
         {
            return null;
         }
         pt = super.itemRendererToIndices(item);
         if(Boolean(pt) && Boolean(getOptimumColumns() != visibleColumns) && pt.x >= lockedColumnCount)
         {
            pt.x -= horizontalScrollPosition;
         }
         return pt;
      }
      
      private function columnGroupRendererChanged(c:AdvancedDataGridColumnGroup) : void
      {
         var i:int = 0;
         var n:int = Boolean(c.children) ? int(c.children.length) : 0;
         if(n > 0)
         {
            columnRendererChanged(c);
            for(i = 0; i < n; i++)
            {
               if(c.children[i] is AdvancedDataGridColumnGroup)
               {
                  columnGroupRendererChanged(c.children[i]);
               }
            }
         }
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         if(Boolean(itemEditorInstance) || event.target != event.currentTarget)
         {
            return;
         }
         if(isOpening)
         {
            event.stopImmediatePropagation();
            return;
         }
         if(_rootModel is IHierarchicalData)
         {
            if(treeNavigationHandler(event))
            {
               return;
            }
         }
         if(isCellSelectionMode() && headerIndex == -1 && event.keyCode != Keyboard.ESCAPE)
         {
            cellNavigationHandler(event);
         }
         else
         {
            super.keyDownHandler(event);
         }
         if(isRowSelectionMode())
         {
            updateSelectedCells();
         }
      }
      
      override protected function hasHeaderItemsCreated(index:int = -1) : Boolean
      {
         if(!columnGrouping)
         {
            return super.hasHeaderItemsCreated(index);
         }
         if(index == -1)
         {
            return Boolean(visibleHeaderInfos) && Boolean(visibleHeaderInfos[0].headerItem);
         }
         var headerInfo:AdvancedDataGridHeaderInfo = getHeaderInfo(getOptimumColumns()[index]);
         return Boolean(headerInfo) && Boolean(headerInfo.headerItem);
      }
      
      protected function addCellSelectionData(uid:String, columnIndex:int, selectionData:AdvancedDataGridBaseSelectionData) : void
      {
         if(firstCellSelectionData != null)
         {
            firstCellSelectionData.prevSelectionData = selectionData;
         }
         selectionData.nextSelectionData = firstCellSelectionData;
         firstCellSelectionData = selectionData;
         if(!cellSelectionData[uid])
         {
            cellSelectionData[uid] = {};
         }
         cellSelectionData[uid][columnIndex.toString()] = selectionData;
      }
      
      public function expandChildrenOf(item:Object, open:Boolean) : void
      {
         var i:int = 0;
         var childItems:Object = null;
         var childItem:Object = null;
         if(iterator == null)
         {
            return;
         }
         if(isBranch(item))
         {
            dispatchAdvancedDataGridEvent(AdvancedDataGridEvent.ITEM_OPENING,item,null,null,open,false,true);
            i = 0;
            if(item != null && _rootModel.canHaveChildren(item) && _rootModel.hasChildren(item))
            {
               childItems = getChildren(item,iterator.view);
            }
            if(Boolean(childItems))
            {
               childItem = childItems[i];
               while(Boolean(childItem))
               {
                  if(isBranch(childItem))
                  {
                     expandChildrenOf(childItem,open);
                  }
                  try
                  {
                     childItem = childItems[i++];
                  }
                  catch(e:RangeError)
                  {
                     childItem = null;
                  }
               }
            }
         }
      }
      
      override protected function adjustAfterRemove(items:Array, location:int, emitEvent:Boolean) : Boolean
      {
         var n:int = 0;
         var i:int = 0;
         var uid:String = null;
         var j:String = null;
         var indicesLength:int = 0;
         var length:int = 0;
         var requiresValueCommit:Boolean = emitEvent;
         if(isCellSelectionMode())
         {
            n = int(items.length);
            for(i = 0; i < n; i++)
            {
               uid = UIDUtil.getUID(items[i]);
               if(Boolean(cellSelectionData[uid]))
               {
                  for(j in cellSelectionData[uid])
                  {
                     removeCellIndicators(uid,int(j));
                     removeCellSelectionData(uid,int(j));
                     requiresValueCommit = true;
                  }
               }
            }
         }
         else
         {
            indicesLength = int(selectedItems.length);
            length = int(items.length);
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
         }
         return requiresValueCommit;
      }
      
      private function getLockedContent() : Sprite
      {
         var locked:Sprite = Sprite(listContent.getChildByName("lockedContent"));
         if(!locked)
         {
            locked = new UIComponent();
            locked.name = "lockedContent";
            locked.cacheAsBitmap = true;
            locked.mouseEnabled = false;
            listContent.addChild(locked);
         }
         listContent.setChildIndex(locked,listContent.numChildren - 1);
         return locked;
      }
      
      override public function createItemEditor(colIndex:int, rowIndex:int) : void
      {
         var col:AdvancedDataGridColumn = null;
         if(_rootModel is IHierarchicalData && colIndex == treeColumnIndex)
         {
            col = displayableColumns[colIndex];
            if(col.editorXOffset == 0 || col.editorWidthOffset == 0)
            {
               col.editorXOffset = 12;
               col.editorWidthOffset = -12;
            }
         }
         super.createItemEditor(colIndex,rowIndex);
      }
      
      override public function get lockedRowCount() : int
      {
         if(_rootModel is IHierarchicalData)
         {
            return 0;
         }
         return super.lockedRowCount;
      }
      
      protected function atLeastOneProperty(o:Object) : Boolean
      {
         var p:String = null;
         var variable:XML = null;
         var _loc4_:int = 0;
         var _loc5_:* = o;
         for(p in _loc5_)
         {
            return true;
         }
         _loc4_ = 0;
         _loc5_ = describeType(data).variable;
         for each(variable in _loc5_)
         {
            return true;
         }
         return false;
      }
      
      override protected function updateDisplayOfItemRenderer(r:IListItemRenderer) : void
      {
         applyUserStylesForItemRenderer(r);
         super.updateDisplayOfItemRenderer(r);
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
      
      private function findHeaderRenderer(pt:Point) : IListItemRenderer
      {
         var headerItem:IListItemRenderer = null;
         var x:Number = NaN;
         var n:int = 0;
         var i:int = 0;
         var xMatched:Boolean = false;
         var array:Array = visibleHeaderInfos;
         while(!xMatched)
         {
            n = Boolean(array) ? int(array.length) : 0;
            for(i = 0; i < n; i++)
            {
               headerItem = array[i]["headerItem"];
               x = Number(headerItem.x);
               if(array[i].actualColNum >= lockedColumnCount)
               {
                  x = getAdjustedXPos(headerItem.x);
               }
               if(pt.x >= x && pt.x < x + headerItem.getExplicitOrMeasuredWidth())
               {
                  xMatched = true;
                  if(pt.y > headerItem.y - cachedPaddingTop && pt.y <= headerItem.y + headerItem.height + cachedPaddingBottom)
                  {
                     return headerItem;
                  }
                  if(Boolean(array[i].visibleChildren) && array[i].visibleChildren.length > 0)
                  {
                     array = array[i].visibleChildren;
                     break;
                  }
                  return null;
               }
            }
            if(!xMatched)
            {
               return null;
            }
            xMatched = false;
         }
         return null;
      }
      
      override protected function initializeHeaderInfo(groupedColumns:Array) : Array
      {
         if(!columnGrouping)
         {
            return super.initializeHeaderInfo(groupedColumns);
         }
         return initializeGroupedHeaderInfo(groupedColumns,null,0,null);
      }
      
      override protected function keyUpHandler(event:KeyboardEvent) : void
      {
         if(isKeyPressed && columnGrouping)
         {
            isKeyPressed = false;
            if(selectedHeaderInfo != null)
            {
               selectColumnHeader(selectedHeaderInfo.column.colNum);
            }
         }
         else
         {
            super.keyUpHandler(event);
         }
      }
      
      override protected function clearIndicators() : void
      {
         if(isCellSelectionMode())
         {
            clearCellIndicators();
         }
         super.clearIndicators();
      }
      
      override protected function getPossibleDropPositions(c:AdvancedDataGridColumn) : Array
      {
         var headerInfo:AdvancedDataGridHeaderInfo = null;
         if(columnGrouping && c != null)
         {
            headerInfo = getHeaderInfo(c);
            if(Boolean(headerInfo && headerInfo.parent) && Boolean(headerInfo.parent.visibleChildren) && headerInfo.parent.visibleChildren.length > 0)
            {
               return headerInfo.parent.visibleChildren;
            }
            return visibleHeaderInfos;
         }
         return super.getPossibleDropPositions(c);
      }
      
      override protected function calculateHeaderHeight() : Number
      {
         if(!columnGrouping)
         {
            return super.calculateHeaderHeight();
         }
         isMeasuringHeader = true;
         createHeaders(0,0);
         isMeasuringHeader = false;
         return headerHeight;
      }
      
      [Inspectable(category="General")]
      public function get treeColumn() : AdvancedDataGridColumn
      {
         if(Boolean(_treeColumn))
         {
            return _treeColumn;
         }
         return null;
      }
      
      private function createHeaderItems(subHeaderInfos:Array) : Number
      {
         var i:int = 0;
         var c:AdvancedDataGridColumn = null;
         var rowData:AdvancedDataGridListData = null;
         var item:IListItemRenderer = null;
         var childrenWidth:Number = NaN;
         var w:Number = 0;
         var n:int = int(subHeaderInfos.length);
         for(i = 0; i < n; i++)
         {
            if(Boolean(subHeaderInfos[i].visibleChildren))
            {
               childrenWidth = createHeaderItems(subHeaderInfos[i].visibleChildren);
            }
            c = subHeaderInfos[i].column;
            if(horizontalScrollPolicy != ScrollPolicy.OFF && c == displayableColumns[displayableColumns.length - 1])
            {
               lastColumnWidth = (isNaN(c.explicitWidth) ? c.preferredWidth : c.explicitWidth) + getLastColumnResidualWidth();
            }
            item = getHeaderRenderer(c);
            rowData = AdvancedDataGridListData(makeListData(c,uid,-1,c.colNum,c));
            rowMap[item.name] = rowData;
            if(item is IDropInListItemRenderer)
            {
               IDropInListItemRenderer(item).listData = rowData;
            }
            item.data = c;
            item.styleName = c;
            if(!isMeasuringHeader)
            {
               addRendererToContentArea(item,c);
            }
            headerItemsList.push(item);
            subHeaderInfos[i].headerItem = item;
            if(Boolean(subHeaderInfos[i].visibleChildren))
            {
               item.explicitWidth = childrenWidth;
               c.width = childrenWidth;
            }
            else if(!isNaN(lastColumnWidth) && c == displayableColumns[displayableColumns.length - 1])
            {
               item.explicitWidth = lastColumnWidth;
            }
            else
            {
               item.explicitWidth = c.width;
            }
            UIComponentGlobals.layoutManager.validateClient(item,true);
            if(!isNaN(lastColumnWidth) && c == displayableColumns[displayableColumns.length - 1])
            {
               w += lastColumnWidth;
            }
            else
            {
               w += c.width;
            }
         }
         return w;
      }
      
      public function get groupedColumns() : Array
      {
         return _groupedColumns;
      }
      
      override protected function mouseOutHandler(event:MouseEvent) : void
      {
         var item:IListItemRenderer = null;
         var colNum:int = 0;
         if(event.target == listContent.getChildByName("headerBG"))
         {
            return;
         }
         if(Boolean(tween))
         {
            return;
         }
         if(!sortExpertMode)
         {
            item = mouseEventToItemRenderer(event);
            if(Boolean(item) && Boolean(item is IDropInListItemRenderer) && isHeaderItemRenderer(item))
            {
               colNum = int(IDropInListItemRenderer(item).listData.columnIndex);
               delete visualSortInfo[colNum];
               delete visualSortInfo["HEADERPART" + colNum];
               invalidateRenderer(item);
            }
         }
         super.mouseOutHandler(event);
      }
      
      protected function get treeColumnIndex() : int
      {
         if(Boolean(_treeColumn))
         {
            return _treeColumn.colNum;
         }
         return 0;
      }
      
      private function getLastColumnResidualWidth() : Number
      {
         var i:int = 0;
         var n:int = displayableColumns.length - 1;
         var displayWidth:int = unscaledWidth - viewMetrics.right - viewMetrics.left;
         var totalWidth:Number = 0;
         var numLockCols:int = Math.max(0,lockedColumnCount);
         if(numLockCols > 0 && numLockCols < visibleColumns.length)
         {
            for(i = 0; i < numLockCols; i++)
            {
               displayWidth -= displayableColumns[i].width;
            }
         }
         if(n >= 0)
         {
            totalWidth = isNaN(displayableColumns[n].explicitWidth) ? Number(displayableColumns[n].preferredWidth) : Number(displayableColumns[n].explicitWidth);
         }
         for(i = n - 1; i >= numLockCols; i--)
         {
            if(totalWidth + displayableColumns[i].width > displayWidth)
            {
               break;
            }
            totalWidth += displayableColumns[i].width;
         }
         return displayWidth - totalWidth;
      }
      
      [Inspectable(enumeration="flat,tree",defaultValue="tree")]
      public function get designViewDataType() : String
      {
         return _designViewDataType;
      }
      
      private function addItemsToTarget(event:DragEvent, items:Array) : void
      {
         var obj:Object = null;
         var item:Object = null;
         var className:String = getQualifiedClassName(event.relatedObject);
         var classType:Class = getDefinitionByName(className) as Class;
         obj = new classType();
         if(!(obj is AdvancedDataGrid))
         {
            return;
         }
         var targetADG:Object = event.relatedObject;
         if(!targetADG.collection)
         {
            item = items.shift();
            targetADG.dataProvider = new HierarchicalData(item);
            targetADG.validateNow();
         }
         else if(targetADG.collection.length == 0)
         {
            obj = items.shift();
            targetADG.addChildItem(targetADG._dropData.parent,obj,targetADG._dropData.index);
         }
         var n:int = int(items.length);
         for(var i:int = n - 1; i >= 0; i--)
         {
            targetADG.addChildItem(targetADG._dropData.parent,items[i],targetADG._dropData.index);
         }
      }
      
      [Inspectable(category="Data")]
      [Bindable("groupLabelFunctionChanged")]
      public function get groupLabelFunction() : Function
      {
         return _groupLabelFunction;
      }
      
      override protected function selectColumnHeader(columnNumber:int) : void
      {
         if(!columnGrouping || selectedHeaderInfo == null)
         {
            super.selectColumnHeader(columnNumber);
         }
         else
         {
            selectColumnGroupHeader(selectedHeaderInfo);
         }
      }
      
      override protected function isDataEditable(data:Object) : Boolean
      {
         if(Boolean(_rootModel) && _rootModel is IGroupingCollection)
         {
            if(_rootModel.hasChildren(data))
            {
               return editable.indexOf("group") != -1;
            }
            if(data is SummaryObject)
            {
               return editable.indexOf("summary") != -1;
            }
         }
         return editable.indexOf("item") != -1;
      }
      
      override public function set horizontalScrollPosition(value:Number) : void
      {
         var oldAnchorColumnIndex:int = anchorColumnIndex;
         var oldCaretColumnIndex:int = caretColumnIndex;
         var oldSelectedColumnIndex:int = selectedColumnIndex;
         super.horizontalScrollPosition = value;
         anchorColumnIndex = oldAnchorColumnIndex;
         caretColumnIndex = oldCaretColumnIndex;
         selectedColumnIndex = oldSelectedColumnIndex;
         if(cellsWaitingToBeDisplayed)
         {
            processCellsWaitingToBeDisplayed();
         }
      }
      
      override protected function dragEnterHandler(event:DragEvent) : void
      {
         if(isCellSelectionMode())
         {
            return;
         }
         if(!(_rootModel is IHierarchicalData) && Boolean(event.dragSource.hasFormat("items")))
         {
            super.dragEnterHandler(event);
            return;
         }
         if(event.isDefaultPrevented())
         {
            return;
         }
         if((!_rootModel || _rootModel is IHierarchicalData) && Boolean(event.dragSource.hasFormat("treeDataGridItems")))
         {
            DragManager.acceptDragDrop(this);
            DragManager.showFeedback(event.ctrlKey ? DragManager.COPY : DragManager.MOVE);
            showDropFeedback(event);
            return;
         }
         hideDropFeedback(event);
         DragManager.showFeedback(DragManager.NONE);
      }
      
      public function expandAll() : void
      {
         if(dataProvider is IHierarchicalCollectionView && Boolean(iterator))
         {
            iterator.seek(CursorBookmark.FIRST);
            while(!iterator.afterLast)
            {
               expandChildrenOf(iterator.current,true);
               iterator.moveNext();
            }
            iterator.seek(CursorBookmark.FIRST,verticalScrollPosition);
         }
      }
      
      protected function selectCellItem(item:IListItemRenderer, shiftKey:Boolean, ctrlKey:Boolean, transition:Boolean = true) : Boolean
      {
         var data:Object;
         var selectionChange:Boolean = false;
         var placeHolder:CursorBookmark = null;
         var pt:Point = null;
         var index:int = 0;
         var columnIndex:int = 0;
         var uid:String = null;
         var numSelected:int = 0;
         var curSelectionData:AdvancedDataGridBaseSelectionData = null;
         var oldCaretIndex:int = 0;
         var oldCaretColumnIndex:int = 0;
         var oldAnchorBookmark:CursorBookmark = null;
         var oldAnchorIndex:int = 0;
         var oldAnchorColumnIndex:int = 0;
         if(!selectable || !item || !itemRendererToIndices(item))
         {
            return false;
         }
         if(isHeaderItemRenderer(item))
         {
            return false;
         }
         selectionChange = false;
         placeHolder = iterator.bookmark;
         pt = itemRendererToIndices(item);
         if(pt.x < 0)
         {
            return false;
         }
         index = pt.y;
         columnIndex = displayToAbsoluteColumnIndex(pt.x);
         uid = itemToUID(item.data);
         data = item.data;
         if(selectionMode == SINGLE_CELL || selectionMode == MULTIPLE_CELLS && !ctrlKey && !shiftKey)
         {
            numSelected = 0;
            if(selectionMode == MULTIPLE_CELLS)
            {
               curSelectionData = firstCellSelectionData;
               if(curSelectionData != null)
               {
                  numSelected++;
                  if(Boolean(curSelectionData.nextSelectionData))
                  {
                     numSelected++;
                  }
               }
            }
            if(Boolean(ctrlKey) && Boolean(cellSelectionData[uid]) && Boolean(cellSelectionData[uid][columnIndex]))
            {
               selectionChange = true;
               oldCaretIndex = caretIndex;
               oldCaretColumnIndex = caretColumnIndex;
               clearSelectedCells();
               caretIndex = oldCaretIndex;
               caretColumnIndex = oldCaretColumnIndex;
            }
            else if(_selectedIndex != index || selectedColumnIndex != columnIndex || selectionMode == MULTIPLE_CELLS && numSelected != 1 || selectionMode == SINGLE_CELL)
            {
               selectionChange = true;
               clearSelectedCells();
               addCellSelectionData(uid,columnIndex,new AdvancedDataGridBaseSelectionData(item.data,index,columnIndex,false));
               addToSelectedCells(index,columnIndex);
               drawCellItem(item,true,uid == highlightUID && columnIndex == highlightColumnIndex,true,transition);
               selectedColumnIndex = columnIndex;
               _selectedIndex = pt.y;
               iterator.seek(CursorBookmark.CURRENT,_selectedIndex - verticalScrollPosition);
               anchorColumnIndex = caretColumnIndex = selectedColumnIndex;
               anchorIndex = caretIndex = _selectedIndex;
               anchorBookmark = caretBookmark = iterator.bookmark;
               iterator.seek(placeHolder,0);
            }
         }
         else if(shiftKey && selectionMode == MULTIPLE_CELLS)
         {
            if(Boolean(anchorBookmark))
            {
               oldAnchorBookmark = anchorBookmark;
               oldAnchorIndex = anchorIndex;
               oldAnchorColumnIndex = anchorColumnIndex;
               clearSelectedCells();
               caretIndex = index;
               caretColumnIndex = columnIndex;
               caretBookmark = iterator.bookmark;
               anchorIndex = oldAnchorIndex;
               anchorBookmark = oldAnchorBookmark;
               anchorColumnIndex = oldAnchorColumnIndex;
               try
               {
                  iterator.seek(anchorBookmark,0);
               }
               catch(e:ItemPendingError)
               {
                  e.addResponder(new ItemResponder(cellSelectionPendingResultHandler,cellSelectionPendingFailureHandler,new AdvancedDataGridBaseSelectionPending(index,anchorIndex,columnIndex,anchorColumnIndex,item.data,transition,placeHolder,CursorBookmark.CURRENT,0)));
                  iteratorValid = false;
               }
               shiftCellSelectionLoop(index,anchorIndex,columnIndex,anchorColumnIndex,item.data,transition,placeHolder);
               selectionChange = true;
            }
         }
         else if(ctrlKey && selectionMode == MULTIPLE_CELLS)
         {
            if(Boolean(cellSelectionData[uid]) && Boolean(cellSelectionData[uid][columnIndex.toString()]))
            {
               removeCellSelectionData(uid,columnIndex);
               drawCellItem(visibleCellRenderers[uid][columnIndex.toString()],false,uid == highlightUID && columnIndex == highlightColumnIndex,true,transition);
               removeFromSelectedCells(index,columnIndex);
            }
            else
            {
               addCellSelectionData(uid,columnIndex,new AdvancedDataGridBaseSelectionData(item.data,index,columnIndex,false));
               drawCellItem(visibleCellRenderers[uid][columnIndex.toString()],true,uid == highlightUID && columnIndex == highlightColumnIndex,true,transition);
               addToSelectedCells(index,columnIndex);
               _selectedIndex = index;
               selectedColumnIndex = columnIndex;
            }
            iterator.seek(CursorBookmark.CURRENT,index - verticalScrollPosition);
            caretIndex = index;
            caretColumnIndex = columnIndex;
            caretBookmark = iterator.bookmark;
            anchorIndex = index;
            anchorColumnIndex = columnIndex;
            anchorBookmark = iterator.bookmark;
            iterator.seek(placeHolder,0);
            selectionChange = true;
         }
         return selectionChange;
      }
      
      protected function treeNavigationHandler(event:KeyboardEvent) : Boolean
      {
         var evt:ListEvent = null;
         var pt:Point = null;
         var item:Object = null;
         var treeItemRenderer:IListItemRenderer = null;
         var renderer:IListItemRenderer = null;
         var o:Boolean = false;
         var dI:int = 0;
         var children:ICollectionView = null;
         var cursor:IViewCursor = null;
         var visibleCoords:Object = absoluteToVisibleIndices(caretIndex,caretColumnIndex != -1 ? caretColumnIndex : 0);
         var visibleRowIndex:int = int(visibleCoords.rowIndex);
         var visibleColIndex:int = int(visibleCoords.columnIndex);
         if(Boolean(listItems[visibleRowIndex]) && Boolean(listItems[visibleRowIndex][visibleColIndex]))
         {
            item = listItems[visibleRowIndex][visibleColIndex].data;
         }
         if(!item)
         {
            return false;
         }
         if(Boolean(listItems[visibleRowIndex]))
         {
            treeItemRenderer = listItems[visibleRowIndex][treeColumnIndex];
         }
         if(event.ctrlKey && event.shiftKey && event.keyCode == Keyboard.SPACE)
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
               dispatchAdvancedDataGridEvent(AdvancedDataGridEvent.ITEM_OPENING,item,treeItemRenderer,event,o,true,true);
            }
            event.stopImmediatePropagation();
         }
         else if(event.ctrlKey && event.shiftKey && event.keyCode == Keyboard.LEFT)
         {
            if(isItemOpen(item))
            {
               dispatchAdvancedDataGridEvent(AdvancedDataGridEvent.ITEM_OPENING,item,treeItemRenderer,event,false,true,true);
            }
            else
            {
               selectedItem = getParentItem(item);
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
            event.stopImmediatePropagation();
         }
         else if(event.ctrlKey && event.shiftKey && event.keyCode == Keyboard.RIGHT)
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
                        selectedItem = cursor.current;
                     }
                  }
                  else
                  {
                     selectedItem = null;
                  }
                  if(caretIndex != selectedIndex)
                  {
                     caretIndex = getItemIndex(selectedItem);
                  }
                  evt = new ListEvent(ListEvent.CHANGE);
                  evt.itemRenderer = indexToItemRenderer(selectedIndex);
                  pt = itemRendererToIndices(evt.itemRenderer);
                  if(Boolean(pt))
                  {
                     evt.rowIndex = pt.y;
                     evt.columnIndex = pt.x;
                  }
                  dispatchEvent(evt);
               }
               else
               {
                  dispatchAdvancedDataGridEvent(AdvancedDataGridEvent.ITEM_OPENING,item,treeItemRenderer,event,true,true,true);
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
                  dispatchAdvancedDataGridEvent(AdvancedDataGridEvent.ITEM_OPENING,item,treeItemRenderer,event,true,true,true);
               }
            }
         }
         else
         {
            if(event.keyCode != Keyboard.NUMPAD_SUBTRACT)
            {
               return false;
            }
            if(isItemOpen(item))
            {
               dispatchAdvancedDataGridEvent(AdvancedDataGridEvent.ITEM_OPENING,item,treeItemRenderer,event,false,true,true);
            }
         }
         return true;
      }
      
      private function updateHeadersList(headerInfos:Array) : void
      {
         var headerInfo:AdvancedDataGridHeaderInfo = null;
         var n:int = Boolean(headerInfos) ? int(headerInfos.length) : 0;
         var totalColumnSpan:int = 0;
         for(var i:int = 0; i < n; i++)
         {
            headerInfo = headerInfos[i];
            orderedHeadersList.push(headerInfo);
            if(Boolean(headerInfo.visibleChildren) && headerInfo.visibleChildren.length > 0)
            {
               updateHeadersList(headerInfo.visibleChildren);
            }
         }
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
      
      override protected function addDragData(ds:Object) : void
      {
         if(_rootModel is IHierarchicalData)
         {
            ds.addHandler(collapseSelectedItems,"treeDataGridItems");
         }
         else
         {
            super.addDragData(ds);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getItemDepth(item:Object, offset:int) : int
      {
         if(!collection)
         {
            return 0;
         }
         if(!iterator)
         {
            iterator = collection.createCursor();
         }
         return getDepth(item);
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
      
      private function setDesignViewSort() : void
      {
         if(collection == null)
         {
            return;
         }
         var sort:Sort = new Sort();
         sort.fields = [];
         var oddDescending:Boolean = false;
         for(var colNum:int = 0; colNum < columns.length; colNum++)
         {
            sort.fields.push(new SortField(columns[colNum].dataField,false,oddDescending,false));
            oddDescending = !oddDescending;
         }
         if(Boolean(collection))
         {
            collection.sort = sort;
         }
      }
      
      public function expandItem(item:Object, open:Boolean, animate:Boolean = false, dispatchEvent:Boolean = false, cause:Event = null) : void
      {
         var i:int = 0;
         var newRowIndex:int = 0;
         var rowData:BaseListData = null;
         var tmpMask:DisplayObject = null;
         var tmpRowInfo:Object = null;
         var n:int = 0;
         var eventArr:Array = null;
         var renderer:IListItemRenderer = null;
         var paddingLeft:Number = NaN;
         var xx:Number = NaN;
         var ww:Number = NaN;
         var yy:Number = NaN;
         var hh:Number = NaN;
         var delta:int = 0;
         var maxDist:Number = NaN;
         var c:AdvancedDataGridColumn = null;
         var optimumColumns:Array = null;
         var oE:Function = null;
         var di:IDropInListItemRenderer = null;
         var advancedDataGridListData:AdvancedDataGridListData = null;
         var data:Object = null;
         var referenceRowInfo:ListRowInfo = null;
         var more:Boolean = false;
         var valid:Boolean = false;
         var startY:Number = NaN;
         var maskY:Number = NaN;
         var maskX:Number = NaN;
         var cellMaskY:Number = NaN;
         var cellMaskX:Number = NaN;
         var cellRow:int = 0;
         var tempArray:Array = null;
         var lastColumn:int = 0;
         var indicator:Object = null;
         var cellColumn:int = 0;
         var cellLastColumn:int = 0;
         var cellUID:String = null;
         var cellIndicator:Object = null;
         var itemRenderer:IListItemRenderer = null;
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
         listSubContent.allowItemSizeChangeNotification = false;
         var bSelected:Boolean = false;
         var bHighlight:Boolean = false;
         var bCaret:Boolean = false;
         var uid:String = itemToUID(item);
         if(!isBranch(item) || isItemOpen(item) == open || isOpening)
         {
            return;
         }
         if(Boolean(itemEditorInstance))
         {
            endEdit(ListEventReason.OTHER);
         }
         oldLength = collectionLength;
         var bookmark:CursorBookmark = iterator.bookmark;
         var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,false,true,CollectionEventKind.EXPAND);
         event.items = [item];
         if(open)
         {
            IHierarchicalCollectionView(collection).openNode(item);
            rowsTweened = Math.abs(oldLength - collection.length);
         }
         else
         {
            IHierarchicalCollectionView(collection).closeNode(item);
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
            var rC:int = int(listItems.length);
            var col:int = treeColumnIndex;
            var rowsToMove:int = rowsTweened;
            var dur:Number = Number(getStyle("openDuration"));
            if(animate && rowIndex < rC && rowsToMove > 0 && rowsToMove < 20 && dur != 0)
            {
               if(Boolean(tween))
               {
                  tween.endTween();
               }
               renderer = listItems[rowIndex - 1][col];
               if(renderer is IDropInListItemRenderer)
               {
                  di = IDropInListItemRenderer(renderer);
                  advancedDataGridListData = AdvancedDataGridListData(di.listData);
                  advancedDataGridListData = AdvancedDataGridListData(makeListData(advancedDataGridListData.item,advancedDataGridListData.uid,advancedDataGridListData.rowIndex,col,visibleColumns[col]));
                  di.listData = advancedDataGridListData;
                  renderer.data = renderer.data;
               }
               opening = open;
               isOpening = true;
               maskList = [];
               rowList = [];
               paddingLeft = 0;
               xx = paddingLeft;
               ww = 0;
               yy = 0;
               hh = 0;
               delta = rowIndex;
               maxDist = 0;
               optimumColumns = getOptimumColumns();
               if(open)
               {
                  newRowIndex = rowIndex;
                  maxDist = listContent.height - rowInfo[rowIndex].y;
                  iterator.seek(CursorBookmark.CURRENT,delta);
                  i = 0;
                  while(i < rowsToMove && yy < maxDist)
                  {
                     data = iterator.current;
                     xx = paddingLeft;
                     currentRowNum = rowIndex + i;
                     hh = 0;
                     currentColNum = 0;
                     uid = itemToUID(data);
                     setupRenderer(data,uid,true);
                     bSelected = selectedData[uid] != null || Boolean(cellSelectionData[uid]) && Boolean(cellSelectionData[uid][currentColNum.toString()]);
                     bHighlight = highlightUID == uid;
                     bCaret = caretUID == uid;
                     currentItemTop = yy;
                     hh = layoutRow(true,xx,hh);
                     tmpRowInfo = new ListRowInfo(yy,hh,uid,data);
                     yy += hh;
                     rowInfo.splice(rowIndex + i,0,tmpRowInfo);
                     iterator.moveNext();
                     i++;
                  }
                  rowsTweened = i;
                  referenceRowInfo = rowInfo[rowIndex + rowsTweened];
                  for(i = 0; i < rowsTweened; i++)
                  {
                     xx = paddingLeft;
                     rowInfo[rowIndex + i].y -= yy - referenceRowInfo.y;
                     for(col = 0; col < optimumColumns.length; col++)
                     {
                        renderer = listItems[rowIndex + i][col];
                        renderer.move(renderer.x,renderer.y - (yy - referenceRowInfo.y));
                        tmpMask = makeMask();
                        if(col < lockedColumnCount)
                        {
                           tmpMask.x = xx;
                        }
                        else
                        {
                           tmpMask.x = getAdjustedXPos(xx);
                        }
                        tmpMask.y = referenceRowInfo.y;
                        tmpMask.width = renderer.width;
                        tmpMask.height = yy;
                        listItems[rowIndex + i][col].mask = tmpMask;
                        xx += optimumColumns[col].width;
                     }
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
                     xx = paddingLeft;
                     tempArray = [];
                     for(col = 0; col < optimumColumns.length; col++)
                     {
                        tempArray.push({"item":listItems[i][col]});
                        tmpMask = makeMask();
                        if(col < lockedColumnCount)
                        {
                           tmpMask.x = xx;
                        }
                        else
                        {
                           tmpMask.x = getAdjustedXPos(xx);
                        }
                        tmpMask.y = listItems[rowIndex][col].y;
                        tmpMask.width = listItems[i][col].width;
                        tmpMask.height = maxDist;
                        listItems[i][col].mask = tmpMask;
                        xx += optimumColumns[col].width;
                     }
                     if(tempArray.length != 0)
                     {
                        rowList.push(tempArray);
                     }
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
                     xx = paddingLeft;
                     if(valid)
                     {
                        currentRowNum = rC - rowsToMove + i;
                        currentColNum = 0;
                        uid = itemToUID(data);
                        setupRenderer(data,uid,true);
                        bSelected = selectedData[uid] != null;
                        bHighlight = highlightUID == uid;
                        bCaret = caretUID == uid;
                        currentItemTop = yy;
                        hh = layoutRow(true,xx,hh);
                     }
                     else
                     {
                        hh = rowHeight;
                     }
                     tmpRowInfo = new ListRowInfo(yy,hh,uid,data);
                     rowInfo.push(tmpRowInfo);
                     yy += hh;
                     if(more)
                     {
                        more = Boolean(iterator.moveNext());
                     }
                     i++;
                  }
                  maskY = rowList[0][0].item.y - getStyle("paddingTop");
                  maskX = rowList[0][0].item.x - getStyle("paddingLeft");
                  for(i = 0; i < rowList.length; i++)
                  {
                     lastColumn = rowList[i].length - 1;
                     indicator = selectionIndicators[itemToUID(rowList[i][lastColumn].item.data)];
                     if(Boolean(indicator))
                     {
                        tmpMask = makeMask();
                        tmpMask.x = maskX;
                        tmpMask.y = maskY;
                        tmpMask.width = rowList[i][lastColumn].item.x + rowList[i][lastColumn].item.width + getStyle("paddingLeft") + getStyle("paddingRight");
                        tmpMask.height = rowList[i][lastColumn].item.y + rowList[i][lastColumn].item.height + getStyle("paddingTop") + getStyle("paddingBottom") - maskY;
                        selectionIndicators[itemToUID(rowList[i][lastColumn].item.data)].mask = tmpMask;
                     }
                  }
                  cellMaskY = rowList[0][0].item.y - getStyle("paddingTop");
                  cellMaskX = rowList[0][0].item.x - getStyle("paddingLeft");
                  for(cellRow = 0; cellRow < rowList.length; cellRow++)
                  {
                     for(cellColumn = 0; cellColumn < rowList[cellRow].length; cellColumn++)
                     {
                        cellLastColumn = rowList[cellRow].length - 1;
                        cellUID = itemToUID(rowList[cellRow][cellColumn].item.data);
                        if(cellUID in cellSelectionIndicators)
                        {
                           cellIndicator = cellSelectionIndicators[cellUID][cellColumn];
                           if(Boolean(cellIndicator))
                           {
                              tmpMask = makeMask();
                              tmpMask.x = maskX;
                              tmpMask.y = maskY;
                              tmpMask.width = rowList[cellRow][cellLastColumn].item.x + rowList[cellRow][cellLastColumn].item.width + getStyle("paddingLeft") + getStyle("paddingRight");
                              tmpMask.height = rowList[cellRow][cellLastColumn].item.y + rowList[cellRow][cellLastColumn].item.height + getStyle("paddingTop") + getStyle("paddingBottom") - maskY;
                              cellIndicator.mask = tmpMask;
                           }
                        }
                     }
                  }
               }
               iterator.seek(bookmark,0);
               rC = int(rowList.length);
               for(i = 0; i < rC; i++)
               {
                  for(col = 0; col < rowList[i].length; col++)
                  {
                     rowList[i][col].itemOldY = rowList[i][col].item.y;
                  }
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
                  itemRenderer = Boolean(eventItemRenderer) ? eventItemRenderer : visibleData[itemToUID(item)];
                  dispatchAdvancedDataGridEvent(open ? AdvancedDataGridEvent.ITEM_OPEN : AdvancedDataGridEvent.ITEM_CLOSE,item,itemRenderer,lastUserInteraction);
                  lastUserInteraction = null;
                  eventItemRenderer = null;
               }
               itemsSizeChanged = true;
               invalidateDisplayList();
            }
            if(!wordWrap && Boolean(initialized))
            {
               super.maxHorizontalScrollPosition = _userMaxHorizontalScrollPosition > 0 ? _userMaxHorizontalScrollPosition + getIndent() : Number(super.maxHorizontalScrollPosition);
            }
            listContent.allowItemSizeChangeNotification = variableRowHeight;
            listSubContent.allowItemSizeChangeNotification = variableRowHeight;
            return;
         }
         eventArr = open ? buildUpCollectionEvents(true) : buildUpCollectionEvents(false);
         for(i = 0; i < eventArr.length; i++)
         {
            collection.dispatchEvent(eventArr[i]);
         }
         if(dispatchEvent)
         {
            dispatchAdvancedDataGridEvent(open ? AdvancedDataGridEvent.ITEM_OPEN : AdvancedDataGridEvent.ITEM_CLOSE,item,visibleData[itemToUID(item)],lastUserInteraction);
            lastUserInteraction = null;
         }
      }
      
      override protected function isDraggingAllowed(draggedColumn:AdvancedDataGridColumn) : Boolean
      {
         var parentInfo:AdvancedDataGridHeaderInfo = null;
         if(columnGrouping)
         {
            parentInfo = getHeaderInfo(draggedColumn).parent;
            if(Boolean(parentInfo) && (parentInfo.column as AdvancedDataGridColumnGroup).childrenDragEnabled == false)
            {
               return false;
            }
         }
         return true;
      }
      
      public function set displayDisclosureIcon(value:Boolean) : void
      {
         if(value != _displayDisclosureIcon)
         {
            _displayDisclosureIcon = value;
            itemsSizeChanged = true;
            invalidateDisplayList();
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getHeaderInfo(col:AdvancedDataGridColumn) : AdvancedDataGridHeaderInfo
      {
         if(columnGrouping)
         {
            return columnsToInfo[itemToUID(col)];
         }
         return super.getHeaderInfo(col);
      }
      
      public function getParentItem(item:Object) : *
      {
         if(item == null)
         {
            return null;
         }
         if(Boolean(item) && Boolean(collection))
         {
            return IHierarchicalCollectionView(collection).getParentItem(item);
         }
         return null;
      }
      
      override protected function selectData(uid:String, data:Object, index:int, selectedBookmark:CursorBookmark) : void
      {
         var columnIndex:int = 0;
         if(isCellSelectionMode())
         {
            columnIndex = selectedColumnIndex;
            if(!cellSelectionData[uid] || !cellSelectionData[uid][columnIndex])
            {
               if(Boolean(cellSelectionIndicators[uid]) && Boolean(cellSelectionIndicators[uid][columnIndex]))
               {
                  selectCellItem(cellSelectionData[uid][columnIndex],false,false);
               }
               else
               {
                  clearSelectedCells();
                  addCellSelectionData(uid,columnIndex,new AdvancedDataGridBaseSelectionData(data,index,columnIndex,false));
                  selectedColumnIndex = caretColumnIndex = anchorColumnIndex = columnIndex;
                  _selectedIndex = caretIndex = anchorIndex = index;
                  caretBookmark = anchorBookmark = selectedBookmark;
               }
            }
         }
         else
         {
            super.selectData(uid,data,index,selectedBookmark);
         }
      }
      
      override public function getFieldSortInfo(column:AdvancedDataGridColumn) : SortInfo
      {
         var headerInfo:AdvancedDataGridHeaderInfo = null;
         var n:int = 0;
         var i:int = 0;
         var uid:String = null;
         if(!sortExpertMode)
         {
            if(Boolean(visualSortInfo[column.colNum]))
            {
               return visualSortInfo[column.colNum];
            }
         }
         headerInfo = getHeaderInfo(column);
         if(Boolean(columnGrouping && column && collection) && Boolean(collection.sort) && headerInfo.internalLabelFunction != null)
         {
            n = int(collection.sort.fields.length);
            for(i = 0; i < n; i++)
            {
               uid = itemToUID(column);
               if(Boolean(uid) && collection.sort.fields[i].name == uid)
               {
                  return new SortInfo(i + 1,collection.sort.fields[i].descending);
               }
            }
            return null;
         }
         return super.getFieldSortInfo(column);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function addChildItem(parent:Object, child:Object, index:Number) : Boolean
      {
         return IHierarchicalCollectionView(dataProvider).addChildAt(parent,child,index);
      }
      
      [Inspectable(category="Data")]
      public function set hierarchicalCollectionView(value:IHierarchicalCollectionView) : void
      {
         _hierarchicalCollectionView = value;
         dataProviderChanged = true;
         invalidateProperties();
      }
      
      private function getItemIndex(item:Object) : int
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
         return i;
      }
      
      override protected function drawVisibleItem(uid:String, selected:Boolean = false, highlighted:Boolean = false, caret:Boolean = false, transition:Boolean = false) : void
      {
         var columnIndex:int = 0;
         var bSelectCell:Boolean = false;
         var bHighlightCell:Boolean = false;
         var bCaretCell:Boolean = false;
         if(isCellSelectionMode())
         {
            if(Boolean(visibleCellRenderers[uid]))
            {
               for(columnIndex = 0; columnIndex < _columns.length; columnIndex++)
               {
                  bSelectCell = Boolean(cellSelectionData) && Boolean(cellSelectionData[uid]) && Boolean(cellSelectionData[uid][columnIndex.toString()]);
                  bHighlightCell = highlightUID == uid && highlightColumnIndex == columnIndex;
                  bCaretCell = caretUID == uid && caretColumnIndex == columnIndex;
                  drawCellItem(visibleCellRenderers[uid][columnIndex.toString()],bSelectCell,bHighlightCell,bCaretCell);
               }
            }
         }
         super.drawVisibleItem(uid,selected,highlighted,caret,transition);
      }
      
      private function setDesignViewData() : void
      {
         var r:int = 0;
         var sampleDataRow:Object = null;
         var colNum:int = 0;
         var col:AdvancedDataGridColumn = null;
         var branchName:String = null;
         var branchCounter:int = 0;
         var childrenString:String = null;
         designViewDataFlag = true;
         var sampleDataProvider:Array = [];
         var counter:int = 1;
         var numberOfRows:int = 10;
         if(!columns || columns.length == 0)
         {
            return;
         }
         if(designViewDataType == designViewDataFlatType)
         {
            for(r = 0; r < numberOfRows; r++)
            {
               sampleDataRow = {};
               for(colNum = 0; colNum < columns.length; colNum++)
               {
                  col = columns[colNum];
                  if(col.dataField != null)
                  {
                     sampleDataRow[col.dataField] = counter;
                  }
                  counter++;
               }
               sampleDataProvider.push(sampleDataRow);
            }
            dataProvider = sampleDataProvider;
         }
         else if(designViewDataType == designViewDataTreeType)
         {
            branchName = columns[0].dataField || "";
            branchCounter = 1;
            for(r = 0; r < numberOfRows; r++)
            {
               childrenString = "children";
               sampleDataRow = {};
               sampleDataRow[childrenString] = [{}];
               sampleDataRow[branchName] = resourceManager.getString("datamanagement","Branch",[branchCounter]);
               for(colNum = 0; colNum < columns.length; colNum++)
               {
                  col = columns[colNum];
                  if(col.dataField != null)
                  {
                     sampleDataRow[childrenString][0][col.dataField] = counter;
                  }
                  counter++;
               }
               sampleDataProvider.push(sampleDataRow);
               branchCounter++;
            }
            dataProvider = new HierarchicalData(sampleDataProvider);
         }
      }
      
      private function getOpenChildrenStack(item:Object, stack:Array) : Array
      {
         var cursor:IViewCursor;
         var children:ICollectionView;
         var curr:Object = null;
         if(item == null)
         {
            return stack;
         }
         children = getChildren(item,iterator.view);
         if(!children)
         {
            return [];
         }
         cursor = children.createCursor();
         while(!cursor.afterLast)
         {
            curr = cursor.current;
            stack.push(curr);
            if(isBranch(curr) && isItemOpen(curr))
            {
               getOpenChildrenStack(curr,stack);
            }
            try
            {
               cursor.moveNext();
            }
            catch(e:ItemPendingError)
            {
               break;
            }
         }
         return stack;
      }
      
      override protected function createHeaders(left:Number, top:Number) : void
      {
         var creatingHeaders:Boolean = false;
         var residualWidth:Number = NaN;
         var lastColIndex:int = 0;
         var lastCol:AdvancedDataGridColumn = null;
         var w:Number = NaN;
         var item:IListItemRenderer = null;
         var i:int = 0;
         var visibleHeaderInfo:AdvancedDataGridHeaderInfo = null;
         var padding:int = 0;
         var currentItemHeight:Number = NaN;
         var n:int = 0;
         if(!columnGrouping)
         {
            creatingHeaders = false;
            if(horizontalScrollPolicy != ScrollPolicy.OFF && getOptimumColumns() != visibleColumns)
            {
               if(!headerItems[0] || !headerItems[0][0] || top < headerItems[0][0].y + headerItems[0][0].height)
               {
                  creatingHeaders = true;
               }
            }
            super.createHeaders(left,top);
            if(creatingHeaders)
            {
               creatingHeaders = false;
               residualWidth = getLastColumnResidualWidth();
               lastColIndex = displayableColumns.length - 1;
               lastCol = displayableColumns[lastColIndex];
               w = isNaN(lastCol.explicitWidth) ? lastCol.preferredWidth : lastCol.explicitWidth;
               item = headerItems[0][lastColIndex];
               if(Boolean(item))
               {
                  item.explicitWidth = w + residualWidth;
                  UIComponentGlobals.layoutManager.validateClient(item,true);
                  item.setActualSize(w + residualWidth,item.height);
               }
            }
         }
         else if(Boolean(visibleHeaderInfos) && (!visibleHeaderInfos[0].headerItem || top < visibleHeaderInfos[0].headerItem.y + visibleHeaderInfos[0].headerItem.height))
         {
            purgeHeaderRenderers();
            headerItemsList = [];
            lastColumnWidth = NaN;
            createHeaderItems(visibleHeaderInfos);
            headerRowInfo = [];
            measureHeaderHeights(visibleHeaderInfos,0);
            padding = cachedPaddingTop + cachedPaddingBottom;
            currentItemHeight = 0;
            n = int(orderedHeadersList.length);
            for(i = 0; i < n; i++)
            {
               visibleHeaderInfo = orderedHeadersList[i];
               if(visibleHeaderInfo.visible)
               {
                  currentItemHeight = headerRowInfo[visibleHeaderInfo.depth].height - padding;
                  if(Boolean(visibleHeaderInfo.visibleChildren))
                  {
                     currentItemHeight -= headerRowInfo[visibleHeaderInfo.depth + 1].height;
                  }
                  if(horizontalScrollPolicy != ScrollPolicy.OFF && !isNaN(lastColumnWidth) && visibleHeaderInfo.column == displayableColumns[displayableColumns.length - 1])
                  {
                     visibleHeaderInfo.headerItem.setActualSize(lastColumnWidth,currentItemHeight);
                  }
                  else
                  {
                     visibleHeaderInfo.headerItem.setActualSize(visibleHeaderInfo.column.width,currentItemHeight);
                  }
                  visibleHeaderInfo.headerItem.visible = headerVisible;
               }
            }
            lastColumnWidth = NaN;
            layoutHeaders(visibleHeaderInfos,left,top,0);
            currentItemTop = headerVisible ? Number(headerRowInfo[0].height) : 0;
            _headerHeight = !_explicitHeaderHeight ? Number(headerRowInfo[0].height) : _headerHeight;
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getHeaderInfoAt(colIndex:int) : AdvancedDataGridHeaderInfo
      {
         if(columnGrouping)
         {
            return columnsToInfo[itemToUID(columns[colIndex])];
         }
         return super.getHeaderInfoAt(colIndex);
      }
      
      public function set selectedCells(value:Array) : void
      {
         clearSelectedCells();
         _temporary_selectedCells = value;
         clearPendingCells();
         selectedCellsChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      public function collapseAll() : void
      {
         var item:* = undefined;
         var oldValue:int = 0;
         if(dataProvider is IHierarchicalCollectionView && Boolean(iterator))
         {
            clearSelected();
            for each(item in IHierarchicalCollectionView(collection).openNodes)
            {
               dispatchAdvancedDataGridEvent(AdvancedDataGridEvent.ITEM_CLOSE,item,visibleData[itemToUID(item)]);
            }
            oldValue = verticalScrollPosition;
            verticalScrollPosition = 0;
            IHierarchicalCollectionView(collection).openNodes = {};
            verticalScrollPosition = oldValue >= collection.length ? collection.length - 1 : oldValue;
            iterator.seek(CursorBookmark.FIRST,verticalScrollPosition);
         }
      }
      
      protected function removeCellSelectionData(uid:String, columnIndex:int) : void
      {
         var curSelectionData:AdvancedDataGridBaseSelectionData = null;
         if(!cellSelectionData[uid])
         {
            return;
         }
         curSelectionData = cellSelectionData[uid][columnIndex.toString()];
         if(firstCellSelectionData == curSelectionData)
         {
            firstCellSelectionData = curSelectionData.nextSelectionData;
         }
         if(curSelectionData.prevSelectionData != null)
         {
            curSelectionData.prevSelectionData.nextSelectionData = curSelectionData.nextSelectionData;
         }
         if(curSelectionData.nextSelectionData != null)
         {
            curSelectionData.nextSelectionData.prevSelectionData = curSelectionData.prevSelectionData;
         }
         delete cellSelectionData[uid][columnIndex.toString()];
         if(!atLeastOneProperty(cellSelectionData[uid]))
         {
            delete cellSelectionData[uid];
         }
      }
      
      protected function removeCellIndicators(uid:String, columnIndex:int) : void
      {
         if(Boolean(cellSelectionTweens[uid]) && Boolean(cellSelectionTweens[uid][columnIndex.toString()]))
         {
            cellSelectionTweens[uid][columnIndex.toString()].removeEventListener(TweenEvent.TWEEN_UPDATE,selectionTween_updateHandler);
            cellSelectionTweens[uid][columnIndex.toString()].removeEventListener(TweenEvent.TWEEN_END,selectionTween_endHandler);
            if(cellSelectionIndicators[uid][columnIndex.toString()].alpha < 1)
            {
               Tween.removeTween(cellSelectionTweens[uid][columnIndex.toString()]);
            }
            delete cellSelectionTweens[uid][columnIndex.toString()];
            if(!atLeastOneProperty(cellSelectionTweens[uid]))
            {
               delete cellSelectionTweens[uid];
            }
         }
         if(Boolean(cellSelectionIndicators[uid]) && Boolean(cellSelectionIndicators[uid][columnIndex.toString()]))
         {
            cellSelectionIndicators[uid][columnIndex.toString()].parent.removeChild(cellSelectionIndicators[uid][columnIndex.toString()]);
            delete cellSelectionIndicators[uid][columnIndex.toString()];
            if(!atLeastOneProperty(cellSelectionIndicators[uid]))
            {
               delete cellSelectionIndicators[uid];
            }
         }
         if(uid == highlightUID && columnIndex == highlightColumnIndex)
         {
            lastHighlightItemRenderer = highlightItemRenderer;
            highlightItemRenderer = null;
            highlightUID = null;
            if(Boolean(highlightIndicator))
            {
               Sprite(highlightIndicator).graphics.clear();
            }
         }
         if(uid == caretUID && columnIndex == caretColumnIndex)
         {
            caretItemRenderer = null;
            caretUID = null;
            if(Boolean(caretIndicator))
            {
               Sprite(caretIndicator).graphics.clear();
            }
         }
      }
      
      protected function clearCellIndicators() : void
      {
         var uid:String = null;
         var columnIndexString:String = null;
         for(uid in cellSelectionIndicators)
         {
            for(columnIndexString in cellSelectionIndicators[uid])
            {
               removeCellIndicators(uid,int(columnIndexString));
            }
         }
         cellSelectionTweens = {};
         cellSelectionIndicators = {};
         visibleCellRenderers = {};
      }
      
      override protected function isHeaderItemRenderer(item:IListItemRenderer) : Boolean
      {
         var n:int = 0;
         var i:int = 0;
         n = !orderedHeadersList ? 0 : int(orderedHeadersList.length);
         for(i = 0; i < n; i++)
         {
            if(UIDUtil.getUID(orderedHeadersList[i].headerItem) == UIDUtil.getUID(item))
            {
               return true;
            }
         }
         return false;
      }
      
      override protected function moveIndicators(uid:String, offset:int, absolute:Boolean) : void
      {
         var columnIndexString:String = null;
         if(!uid)
         {
            return;
         }
         if(!absolute && offset == 0)
         {
            return;
         }
         if(isCellSelectionMode())
         {
            if(Boolean(cellSelectionIndicators[uid]))
            {
               for(columnIndexString in cellSelectionIndicators[uid])
               {
                  if(absolute)
                  {
                     cellSelectionIndicators[uid][columnIndexString].y = offset;
                  }
                  else
                  {
                     cellSelectionIndicators[uid][columnIndexString].y += offset;
                  }
               }
            }
         }
         else
         {
            super.moveIndicators(uid,offset,absolute);
         }
      }
      
      [Inspectable(category="General",enumeration="true,false",defaultValue="false")]
      public function get displayItemsExpanded() : Boolean
      {
         return _displayItemsExpanded;
      }
      
      override protected function mouseWheelHandler(event:MouseEvent) : void
      {
         if(!tween)
         {
            super.mouseWheelHandler(event);
         }
      }
      
      protected function initListData(item:Object, adgListData:AdvancedDataGridListData) : void
      {
         if(item == null)
         {
            return;
         }
         var open:Boolean = isItemOpen(item);
         var branch:Boolean = isBranch(item);
         var uid:String = itemToUID(item);
         if(displayDisclosureIcon)
         {
            adgListData.disclosureIcon = getStyle(open ? "disclosureOpenIcon" : "disclosureClosedIcon");
         }
         adgListData.open = open;
         adgListData.hasChildren = _rootModel.hasChildren(item);
         if(itemPending)
         {
            adgListData.depth = 1;
         }
         else
         {
            adgListData.depth = getItemDepth(item,adgListData.rowIndex);
         }
         adgListData.indent = (adgListData.depth - 1) * getStyle("indentation");
         adgListData.item = item;
         if(groupIconFunction != null && isBranch(item))
         {
            if(groupIconFunction(item,adgListData.depth) != null)
            {
               adgListData.icon = groupIconFunction(item,adgListData.depth);
            }
            else
            {
               adgListData.icon = itemToIcon(item);
            }
         }
         else
         {
            adgListData.icon = itemToIcon(item);
         }
      }
      
      private function layoutHeaders(subHeaderInfos:Array, rowX:Number, rowY:Number, depth:int) : void
      {
         var i:int = 0;
         var currentItemHeight:Number = NaN;
         var w:Number = rowX;
         var padding:int = cachedPaddingTop + cachedPaddingBottom;
         headerRowInfo[depth].y = rowY;
         var n:int = int(subHeaderInfos.length);
         for(i = 0; i < n; i++)
         {
            subHeaderInfos[i].headerItem.move(w,rowY + cachedPaddingTop);
            currentItemHeight = Number(subHeaderInfos[i].headerItem.height);
            if(Boolean(subHeaderInfos[i].visibleChildren))
            {
               layoutHeaders(subHeaderInfos[i].visibleChildren,w,rowY + currentItemHeight + padding,depth + 1);
            }
            w += subHeaderInfos[i].headerItem.getExplicitOrMeasuredWidth();
         }
      }
      
      private function rowToCell(item:*, index:int, array:Array) : Object
      {
         return {
            "rowIndex":item,
            "columnIndex":-1
         };
      }
      
      override protected function unselectColumnHeader(columnNumber:int, completely:Boolean = false) : void
      {
         var s:Sprite = null;
         s = Sprite(selectionLayer.getChildByName("headerKeyboardSelection"));
         if(!s)
         {
            s = Sprite(movingSelectionLayer.getChildByName("headerKeyboardSelection"));
         }
         if(Boolean(s))
         {
            s.parent.removeChild(s);
         }
         selectedHeaderInfo = null;
         if(completely)
         {
            caretIndex = 0;
            isPressed = false;
            if(isCellSelectionMode())
            {
               caretColumnIndex = columnNumber;
               selectItem(listItems[caretIndex][absoluteToVisibleColumnIndex(columnNumber)],false,false);
            }
            else
            {
               selectItem(listItems[caretIndex][0],false,false);
            }
         }
      }
      
      protected function drawCellItem(item:IListItemRenderer, selected:Boolean = false, highlighted:Boolean = false, caret:Boolean = false, transition:Boolean = false) : void
      {
         var pt:Point = null;
         var columnIndex:int = 0;
         var rowData:BaseListData = null;
         var o:Sprite = null;
         var g:Graphics = null;
         var itemXPos:Number = NaN;
         var rowIndex:int = 0;
         var optimumColumns:Array = null;
         var i:int = 0;
         var newIndicator:Boolean = false;
         var r:IListItemRenderer = null;
         if(!item || isHeaderItemRenderer(item))
         {
            return;
         }
         pt = itemRendererToIndices(item);
         if(!pt)
         {
            return;
         }
         var index:int = pt.y;
         columnIndex = displayToAbsoluteColumnIndex(pt.x);
         rowData = rowMap[item.name];
         itemXPos = Number(item.x);
         if(highlighted && (!highlightItemRenderer || highlightUID != rowData.uid && columnIndex != highlightColumnIndex))
         {
            if(!highlightIndicator)
            {
               o = new SpriteAsset();
               highlightIndicator = o;
            }
            o = highlightIndicator;
            addIndicatorToSelectionLayer(o,pt.x);
            drawHighlightIndicator(o,itemXPos,rowInfo[rowData.rowIndex].y,item.width,rowInfo[rowData.rowIndex].height,getStyle("rollOverColor"),item);
            highlightItemRenderer = item;
            highlightUID = rowData.uid;
            highlightColumnIndex = columnIndex;
         }
         else if(Boolean(!highlighted) && Boolean(highlightItemRenderer) && (Boolean(rowData && highlightUID == rowData.uid) && Boolean(highlightColumnIndex == columnIndex)))
         {
            if(Boolean(highlightIndicator))
            {
               Sprite(highlightIndicator).graphics.clear();
            }
            lastHighlightItemRenderer = highlightItemRenderer;
            highlightItemRenderer = null;
            highlightUID = null;
            highlightColumnIndex = -1;
         }
         if(selected)
         {
            if(!cellSelectionIndicators[rowData.uid])
            {
               cellSelectionIndicators[rowData.uid] = {};
            }
            newIndicator = false;
            if(!cellSelectionIndicators[rowData.uid][columnIndex.toString()])
            {
               o = new SpriteAsset();
               o.mouseEnabled = false;
               cellSelectionIndicators[rowData.uid][columnIndex.toString()] = o;
               newIndicator = true;
            }
            o = cellSelectionIndicators[rowData.uid][columnIndex.toString()];
            addIndicatorToSelectionLayer(o,pt.x);
            drawSelectionIndicator(o,itemXPos,rowInfo[rowData.rowIndex].y,item.width,rowInfo[rowData.rowIndex].height,enabled ? uint(getStyle("selectionColor")) : uint(getStyle("selectionDisabledColor")),item);
            if(newIndicator)
            {
               if(transition)
               {
                  applyCellSelectionEffect(o,rowData.uid,columnIndex,item);
               }
            }
         }
         else if(!selected)
         {
            if(Boolean(rowData) && Boolean(cellSelectionIndicators[rowData.uid]) && Boolean(cellSelectionIndicators[rowData.uid][columnIndex.toString()]))
            {
               o = cellSelectionIndicators[rowData.uid][columnIndex.toString()];
               if(Boolean(o.parent))
               {
                  o.parent.removeChild(o);
               }
               delete cellSelectionIndicators[rowData.uid][columnIndex.toString()];
               if(!atLeastOneProperty(cellSelectionIndicators[rowData.uid]))
               {
                  delete cellSelectionIndicators[rowData.uid];
               }
            }
         }
         if(caret)
         {
            if(showCaret)
            {
               if(!caretIndicator)
               {
                  o = new SpriteAsset();
                  o.mouseEnabled = false;
                  caretIndicator = o;
               }
               o = caretIndicator;
               addIndicatorToSelectionLayer(o,pt.x);
               drawCaretIndicator(o,itemXPos,rowInfo[rowData.rowIndex].y,item.width,rowInfo[rowData.rowIndex].height,getStyle("selectionColor"),item);
               caretItemRenderer = item;
               caretUID = rowData.uid;
               caretColumnIndex = columnIndex;
            }
         }
         else if(Boolean(!caret && caretItemRenderer) && Boolean(caretUID == rowData.uid) && caretColumnIndex == columnIndex)
         {
            if(Boolean(caretIndicator))
            {
               Sprite(caretIndicator).graphics.clear();
            }
            caretItemRenderer = null;
            caretUID = null;
         }
         if(item is IFlexDisplayObject)
         {
            if(item is IInvalidating)
            {
               IInvalidating(item).invalidateDisplayList();
               IInvalidating(item).validateNow();
            }
         }
         else if(item is IUITextField)
         {
            IUITextField(item).validateNow();
         }
         rowIndex = int(rowMap[item.name].rowIndex);
         optimumColumns = getOptimumColumns();
         for(i = 0; i < optimumColumns.length; i++)
         {
            r = listItems[rowIndex][i];
            updateDisplayOfItemRenderer(r);
         }
      }
      
      private function removeOldHeaders() : void
      {
         var item:IListItemRenderer = null;
         var headerRow:Array = null;
         var i:int = 0;
         if(columnGrouping)
         {
            if(Boolean(headerItems) && Boolean(headerItems.length))
            {
               while(Boolean(headerItems.length))
               {
                  headerRow = headerItems.pop();
                  while(Boolean(headerRow.length))
                  {
                     item = IListItemRenderer(headerRow.pop());
                     item.parent.removeChild(DisplayObject(item));
                  }
               }
            }
         }
         else
         {
            if(Boolean(headerItemsList) && Boolean(headerItemsList.length))
            {
               while(Boolean(headerItemsList.length))
               {
                  item = headerItemsList.pop();
                  item.parent.removeChild(DisplayObject(item));
               }
            }
            if(Boolean(_groupedColumns))
            {
               for(i = 0; i < _groupedColumns.length; i++)
               {
                  if(_groupedColumns[i] is AdvancedDataGridColumnGroup)
                  {
                     columnGroupRendererChanged(AdvancedDataGridColumnGroup(_groupedColumns[i]));
                  }
               }
            }
         }
      }
      
      override protected function addRendererToContentArea(item:IListItemRenderer, column:AdvancedDataGridColumn) : void
      {
         var headerInfo:AdvancedDataGridHeaderInfo = null;
         if(columnGrouping && item.data is AdvancedDataGridColumn)
         {
            headerInfo = getHeaderInfo(item.data as AdvancedDataGridColumn);
            if(Boolean(headerInfo) && headerInfo.columnSpan + headerInfo.actualColNum <= lockedColumnCount)
            {
               listContent.addChild(DisplayObject(item));
            }
            else
            {
               listSubContent.addChild(DisplayObject(item));
            }
         }
         else
         {
            super.addRendererToContentArea(item,column);
         }
      }
      
      protected function clearPendingCells() : void
      {
         cellsWaitingToBeDisplayed = false;
         pendingCellSelection.removeAll();
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function shiftColumns(oldIndex:int, newIndex:int, trigger:Event = null) : void
      {
         var headerInfo:AdvancedDataGridHeaderInfo = null;
         var groupInfos:Array = null;
         var groupColumns:Array = null;
         var k:int = 0;
         var queue:Array = null;
         var pointer:int = 0;
         var i:int = 0;
         var increment:int = 0;
         var incr:int = 0;
         var newColumns:Array = null;
         var n:int = 0;
         var newLockedColCount:int = 0;
         var icEvent:IndexChangedEvent = null;
         var j:int = 0;
         var c:AdvancedDataGridColumn = null;
         var cInfo:AdvancedDataGridHeaderInfo = null;
         if(newIndex >= 0 && oldIndex != newIndex)
         {
            if(!columnGrouping)
            {
               super.shiftColumns(oldIndex,newIndex,trigger);
            }
            else
            {
               headerInfo = getHeaderInfo(movingColumn);
               updateMovingColumnIndex();
               groupInfos = Boolean(headerInfo.parent) ? headerInfo.parent.children : headerInfos;
               groupColumns = headerInfo.parent == null ? groupedColumns : (headerInfo.parent.column as AdvancedDataGridColumnGroup).children;
               queue = [];
               pointer = 0;
               if(newIndex >= 0 && oldIndex != newIndex)
               {
                  incr = oldIndex < newIndex ? 1 : -1;
                  for(i = oldIndex; i != newIndex; i += incr)
                  {
                     j = i + incr;
                     c = groupColumns[i];
                     groupColumns[i] = groupColumns[j];
                     groupColumns[j] = c;
                     groupInfos[i].actualColNum += groupInfos[j].columnSpan * incr;
                     groupInfos[j].actualColNum -= groupInfos[i].columnSpan * incr;
                     if(Boolean(groupInfos[i].children) && groupInfos[i].children.length > 0)
                     {
                        increment = groupInfos[j].columnSpan * incr;
                        for(k = 0; k < groupInfos[i].children.length; k++)
                        {
                           queue.push(groupInfos[i].children[k]);
                        }
                        while(Boolean(queue[pointer]))
                        {
                           headerInfo = queue[pointer++];
                           headerInfo.actualColNum += increment;
                           if(Boolean(headerInfo) && Boolean(headerInfo.children))
                           {
                              for(k = 0; k < headerInfo.children.length; k++)
                              {
                                 queue.push(headerInfo.children[k]);
                              }
                           }
                        }
                     }
                     if(Boolean(groupInfos[j].children) && groupInfos[j].children.length > 0)
                     {
                        queue = [];
                        pointer = 0;
                        increment = groupInfos[i].columnSpan * incr;
                        for(k = 0; k < groupInfos[j].children.length; k++)
                        {
                           queue.push(groupInfos[j].children[k]);
                        }
                        while(Boolean(queue[pointer]))
                        {
                           headerInfo = queue[pointer++];
                           headerInfo.actualColNum -= increment;
                           if(Boolean(headerInfo) && Boolean(headerInfo.children))
                           {
                              for(k = 0; k < headerInfo.children.length; k++)
                              {
                                 queue.push(headerInfo.children[k]);
                              }
                           }
                        }
                     }
                     cInfo = groupInfos[i];
                     groupInfos[i] = groupInfos[j];
                     groupInfos[j] = cInfo;
                     groupInfos[i].index -= incr;
                     groupInfos[j].index += incr;
                  }
                  newColumns = getLeafColumns(groupedColumns);
                  _columns = [];
                  n = int(newColumns.length);
                  for(i = 0; i < n; i++)
                  {
                     _columns[i] = newColumns[i];
                     _columns[i].colNum = i;
                  }
                  visibleHeaderInfos = updateVisibleHeaders();
                  updateHeaderSearchList();
                  createDisplayableColumns();
                  newLockedColCount = getAdjustedLockedCount(_lockedColumnCountVal);
                  if(lockedColumnCount != newLockedColCount)
                  {
                     lockedColumnCountChanged = true;
                     super.lockedColumnCount = newLockedColCount;
                  }
                  columnsInvalid = true;
                  itemsSizeChanged = true;
                  invalidateDisplayList();
                  icEvent = new IndexChangedEvent(IndexChangedEvent.HEADER_SHIFT);
                  icEvent.oldIndex = oldIndex;
                  icEvent.newIndex = newIndex;
                  icEvent.triggerEvent = trigger;
                  dispatchEvent(icEvent);
               }
            }
            if(isCellSelectionMode())
            {
               clearSelectedCells();
            }
         }
      }
      
      protected function getDepth(item:Object) : int
      {
         if(_rootModel is IHierarchicalData && collection is IHierarchicalCollectionView)
         {
            return IHierarchicalCollectionView(dataProvider).getNodeDepth(item);
         }
         return -1;
      }
      
      private function scrollColumnGroupIfNeeded(h1:AdvancedDataGridHeaderInfo, h2:AdvancedDataGridHeaderInfo) : void
      {
         if(!isColumnFullyVisible(displayableColumns[h2.actualColNum].colNum))
         {
            scrollToViewColumn(displayableColumns[h2.actualColNum].colNum,displayableColumns[h1.actualColNum].colNum);
         }
      }
      
      override protected function mouseUpHandler(event:MouseEvent) : void
      {
         if(!tween)
         {
            super.mouseUpHandler(event);
         }
      }
      
      protected function selectColumnGroupHeader(headerInfo:AdvancedDataGridHeaderInfo) : void
      {
         var parentLayer:Sprite = null;
         var otherLayer:Sprite = null;
         var s:Sprite = null;
         var r:IListItemRenderer = headerInfo.headerItem;
         if(headerInfo.actualColNum < lockedColumnCount)
         {
            parentLayer = selectionLayer;
            otherLayer = movingSelectionLayer;
         }
         else
         {
            parentLayer = movingSelectionLayer;
            otherLayer = selectionLayer;
         }
         s = Sprite(parentLayer.getChildByName("headerKeyboardSelection"));
         if(!s)
         {
            s = Sprite(otherLayer.getChildByName("headerKeyboardSelection"));
         }
         if(!s)
         {
            s = new FlexSprite();
            s.name = "headerKeyboardSelection";
         }
         if(s.parent != parentLayer)
         {
            parentLayer.addChild(s);
         }
         var g:Graphics = s.graphics;
         g.clear();
         g.beginFill(isPressed || isKeyPressed ? uint(getStyle("selectionColor")) : uint(getStyle("rollOverColor")));
         g.drawRect(0,0,r.width,r.height + cachedPaddingTop + cachedPaddingBottom - 0.5);
         g.endFill();
         s.x = r.x;
         s.y = r.y - cachedPaddingTop;
         caretIndex = -1;
         isPressed = false;
         selectItem(headerInfo.headerItem,false,false);
      }
      
      override protected function createChildren() : void
      {
         var g:Graphics = null;
         super.createChildren();
         if(!movingSelectionLayer)
         {
            movingSelectionLayer = new FlexSprite();
            movingSelectionLayer.name = "movingSelectionLayer";
            movingSelectionLayer.mouseEnabled = false;
            listSubContent.addChild(movingSelectionLayer);
            g = movingSelectionLayer.graphics;
            g.beginFill(0,0);
            g.drawRect(0,0,10,10);
            g.endFill();
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function dispatchAdvancedDataGridEvent(type:String, item:Object, renderer:IListItemRenderer, trigger:Event = null, opening:Boolean = true, animate:Boolean = true, dispatch:Boolean = true) : void
      {
         var event:AdvancedDataGridEvent = null;
         if(type == AdvancedDataGridEvent.ITEM_OPENING)
         {
            event = new AdvancedDataGridEvent(AdvancedDataGridEvent.ITEM_OPENING,false,true);
            event.opening = opening;
            event.animate = animate;
            event.dispatchEvent = dispatch;
         }
         if(!event)
         {
            event = new AdvancedDataGridEvent(type);
         }
         event.item = item;
         event.itemRenderer = renderer;
         event.triggerEvent = trigger;
         dispatchEvent(event);
      }
      
      public function get rendererProviders() : Array
      {
         return _rendererProviders;
      }
      
      public function set groupIconFunction(value:Function) : void
      {
         _groupIconFunction = value;
         itemsSizeChanged = true;
         invalidateDisplayList();
         dispatchEvent(new Event("groupIconFunctionChanged"));
      }
      
      [Inspectable(category="Data")]
      public function get groupItemRenderer() : IFactory
      {
         return _groupItemRenderer;
      }
      
      protected function addIndicatorToSelectionLayer(o:Sprite, columnIndex:int) : void
      {
         if(columnIndex < lockedColumnCount)
         {
            if(o.parent != selectionLayer)
            {
               selectionLayer.addChild(DisplayObject(o));
            }
            else
            {
               o.parent.setChildIndex(DisplayObject(o),o.parent.numChildren - 1);
            }
         }
         else if(o.parent != movingSelectionLayer)
         {
            movingSelectionLayer.addChild(DisplayObject(o));
         }
         else
         {
            o.parent.setChildIndex(DisplayObject(o),o.parent.numChildren - 1);
         }
      }
      
      public function set treeColumn(value:AdvancedDataGridColumn) : void
      {
         if(value != _treeColumn)
         {
            _treeColumn = value;
            purgeItemRenderers();
            freeItemRenderersTable = new Dictionary(false);
            itemsSizeChanged = true;
            invalidateDisplayList();
         }
      }
      
      private function initializeGroupedHeaderInfo(groupedColumns:Array, parent:AdvancedDataGridHeaderInfo, depth:int, parentInternalLabelFunction:Function = null) : Array
      {
         var i:int;
         var headerInfo:AdvancedDataGridHeaderInfo = null;
         var uid:String = null;
         var childInternalLabelFunction:Function = null;
         var headerInfos:Array = [];
         for(i = 0; i < groupedColumns.length; i++)
         {
            headerInfo = new AdvancedDataGridHeaderInfo(groupedColumns[i],parent,i,depth);
            uid = itemToUID(groupedColumns[i]);
            columnsToInfo[uid] = headerInfo;
            groupedColumns[i].owner = this;
            headerInfo.internalLabelFunction = parentInternalLabelFunction;
            if(Boolean(selectedHeaderInfo) && selectedHeaderInfo.column == groupedColumns[i])
            {
               selectedHeaderInfo = headerInfo;
            }
            if(Boolean(groupedColumns[i] is AdvancedDataGridColumnGroup) && Boolean(groupedColumns[i].children) && groupedColumns[i].children.length > 0)
            {
               if(Boolean(groupedColumns[i].dataField) || Boolean(groupedColumns[i].labelFunction) || parentInternalLabelFunction != null)
               {
                  if(parentInternalLabelFunction == null)
                  {
                     childInternalLabelFunction = function(data:Object, c:AdvancedDataGridColumn):*
                     {
                        var parentInfo:* = getHeaderInfo(c).parent;
                        var parentColumn:* = parentInfo.column as AdvancedDataGridColumnGroup;
                        return parentColumn.itemToData(data);
                     };
                  }
                  else
                  {
                     childInternalLabelFunction = function(data:Object, c:AdvancedDataGridColumn):*
                     {
                        var parentInfo:* = getHeaderInfo(c).parent;
                        var parentColumn:* = parentInfo.column as AdvancedDataGridColumnGroup;
                        var dataFromParent:* = parentInfo.internalLabelFunction(data,parentInfo.column);
                        return parentColumn.itemToData(dataFromParent);
                     };
                  }
               }
               headerInfo.children = initializeGroupedHeaderInfo(groupedColumns[i].children,headerInfo,depth + 1,childInternalLabelFunction);
            }
            headerInfos.push(headerInfo);
         }
         return headerInfos;
      }
      
      override protected function layoutItemEditor() : void
      {
         var indent:int = 0;
         if(_rootModel is IHierarchicalData)
         {
            indent = int(rowMap[editedItemRenderer.name].indent);
            itemEditorInstance.move(itemEditorInstance.x + indent,itemEditorInstance.y);
            itemEditorInstance.setActualSize(itemEditorInstance.width - indent,itemEditorInstance.height);
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function clearHighlight(item:IListItemRenderer) : void
      {
         var uid:String = null;
         var c:AdvancedDataGridColumn = null;
         var columnIndex:int = 0;
         if(isCellSelectionMode())
         {
            uid = itemToUID(item.data);
            c = columnMap[item.name];
            if(Boolean(c))
            {
               columnIndex = c.colNum;
               drawCellItem(item,Boolean(cellSelectionData[uid]) && Boolean(cellSelectionData[uid][columnIndex]),false,caretUID == uid && caretColumnIndex == columnIndex);
            }
         }
         super.clearHighlight(item);
      }
      
      override protected function mouseDoubleClickHandler(event:MouseEvent) : void
      {
         if(!tween)
         {
            super.mouseDoubleClickHandler(event);
         }
      }
      
      override protected function drawRowBackgrounds() : void
      {
         var i:int;
         var actualRow:int;
         var n:int;
         var depthColors:Boolean;
         var rowBGs:Sprite;
         var curRow:int;
         var colors:Array = null;
         var color:Object = null;
         var d:int = 0;
         colors = getStyle("depthColors");
         if(!(_rootModel is IHierarchicalData) || !colors)
         {
            super.drawRowBackgrounds();
            return;
         }
         rowBGs = Sprite(listContent.getChildByName("rowBGs"));
         if(!rowBGs)
         {
            rowBGs = new FlexSprite();
            rowBGs.mouseEnabled = false;
            rowBGs.name = "rowBGs";
            listContent.addChildAt(rowBGs,0);
         }
         depthColors = false;
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
            return;
         }
         StyleManager.getColorNames(colors);
         curRow = 0;
         i = 0;
         actualRow = verticalScrollPosition;
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
                     drawRowBackground(rowBGs,i++,rowInfo[curRow].y,rowInfo[curRow].height,colors[d - 1],curRow);
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
         while(rowBGs.numChildren > i)
         {
            rowBGs.removeChildAt(rowBGs.numChildren - 1);
         }
      }
      
      private function updateDropData(event:DragEvent) : void
      {
         var parent:Object = null;
         var index:int = 0;
         var rowCount:int = int(rowInfo.length);
         var rowNum:int = 0;
         var yy:int = rowInfo[rowNum].height + (headerVisible ? headerHeight : 0);
         var pt:Point = globalToLocal(new Point(event.stageX,event.stageY));
         while(Boolean(rowInfo[rowNum]) && pt.y > yy)
         {
            if(rowNum != rowInfo.length - 1)
            {
               rowNum++;
            }
            yy += rowInfo[rowNum].height;
         }
         var yOffset:Number = pt.y - rowInfo[rowNum].y;
         var rowHeight:Number = Number(rowInfo[rowNum].height);
         rowNum += verticalScrollPosition;
         var emptyFolder:Boolean = false;
         var numItems:int = Boolean(collection) ? int(collection.length) : 0;
         var topItem:Object = rowNum > _verticalScrollPosition && rowNum < numItems ? listItems[rowNum - _verticalScrollPosition - 1][0].data : null;
         var bottomItem:Object = rowNum < numItems ? listItems[rowNum - _verticalScrollPosition][0].data : null;
         var topParent:Object = Boolean(collection) ? getParentItem(topItem) : null;
         var bottomParent:Object = Boolean(collection) ? getParentItem(bottomItem) : null;
         if(yOffset > rowHeight * 0.5 && isItemOpen(bottomItem) && _rootModel.canHaveChildren(bottomItem) && !_rootModel.hasChildren(bottomItem))
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
               index = int(collection.length);
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
      
      override protected function columnDraggingMouseUpHandler(event:Event) : void
      {
         if(!columnGrouping)
         {
            super.columnDraggingMouseUpHandler(event);
            return;
         }
         if(!movingColumn)
         {
            return;
         }
         var headerInfo:AdvancedDataGridHeaderInfo = getHeaderInfo(movingColumn);
         var origIndex:int = headerInfo.index;
         var dropPositions:Array = getPossibleDropPositions(movingColumn);
         var n:int = int(dropPositions.length);
         if(dropColumnIndex >= 0)
         {
            if(dropColumnIndex >= n)
            {
               dropColumnIndex = n - 1;
            }
            else if(origIndex < dropColumnIndex)
            {
               --dropColumnIndex;
            }
            dropColumnIndex = dropPositions[dropColumnIndex].index;
         }
         shiftColumns(origIndex,dropColumnIndex,event);
         unsetColumnDragParameters();
      }
      
      override public function showDropFeedback(event:DragEvent) : void
      {
         var depth:int = 0;
         if(!(_rootModel is IHierarchicalData))
         {
            super.showDropFeedback(event);
            return;
         }
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
            indent = int(getStyle("indentation"));
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
      
      protected function finishCellKeySelection() : void
      {
         var uid:String = null;
         var rowCount:int = 0;
         var listItem:IListItemRenderer = null;
         var bSelChanged:Boolean = false;
         var columnIndex:int = 0;
         var visibleCoords:Object = null;
         var visibleRowIndex:int = 0;
         var visibleColIndex:int = 0;
         var oldCaretIndex:int = 0;
         var caretCoords:Object = null;
         var evt:ListEvent = null;
         var pt:Point = null;
         rowCount = int(listItems.length);
         var partialRow:int = rowInfo[rowCount - 1].y + rowInfo[rowCount - 1].height > listContent.height ? 1 : 0;
         bSelChanged = false;
         columnIndex = caretColumnIndex;
         if(bSelectItem && caretIndex - verticalScrollPosition >= 0)
         {
            if(caretIndex - verticalScrollPosition > listItems.length - 1)
            {
               caretIndex = listItems.length - 1 + verticalScrollPosition;
            }
            visibleCoords = absoluteToVisibleIndices(caretIndex,caretColumnIndex);
            visibleRowIndex = int(visibleCoords.rowIndex);
            visibleColIndex = int(visibleCoords.columnIndex);
            if(visibleRowIndex >= 0 && visibleColIndex >= 0)
            {
               listItem = listItems[visibleRowIndex][visibleColIndex];
            }
            while(Boolean(listItem) && !listItem.visible)
            {
               if(!(Boolean(listItems[visibleRowIndex]) && Boolean(listItems[visibleRowIndex][visibleColIndex - 1])))
               {
                  break;
               }
               listItem = listItems[visibleRowIndex][visibleColIndex];
               visibleColIndex--;
               columnIndex--;
            }
            if(Boolean(listItem))
            {
               uid = itemToUID(listItem.data);
               if(Boolean(visibleCellRenderers[uid]))
               {
                  listItem = visibleCellRenderers[uid][columnIndex.toString()];
               }
               if(bShiftKey)
               {
                  selectCellItem(listItem,bShiftKey,bCtrlKey);
                  bSelChanged = true;
               }
               else if(bCtrlKey)
               {
                  if(lastKey == Keyboard.SPACE)
                  {
                     selectCellItem(listItem,bShiftKey,bCtrlKey,true);
                  }
                  else
                  {
                     drawCellItem(listItem,Boolean(cellSelectionData[uid]) && cellSelectionData[uid][columnIndex.toString()] != null,uid == highlightUID && caretColumnIndex == highlightColumnIndex,true);
                     bSelChanged = true;
                  }
               }
               else
               {
                  oldCaretIndex = caretIndex;
                  clearSelectedCells();
                  caretIndex = oldCaretIndex;
                  anchorIndex = caretIndex;
                  _selectedIndex = caretIndex;
                  selectedColumnIndex = caretColumnIndex;
                  anchorColumnIndex = caretColumnIndex;
                  selectCellItem(listItem,bShiftKey,bCtrlKey,false);
                  bSelChanged = true;
               }
            }
         }
         if(!bSelectItem && caretColumnIndex - horizontalScrollPosition >= 0)
         {
            if(caretColumnIndex - horizontalScrollPosition > _columns.length - 1)
            {
               caretColumnIndex = _columns.length - 1 + horizontalScrollPosition;
            }
            if(caretIndex - verticalScrollPosition >= 0)
            {
               caretCoords = absoluteToVisibleIndices(caretIndex,caretColumnIndex);
               listItem = listItems[caretCoords.rowIndex][caretCoords.columnIndex];
            }
            if(Boolean(listItem))
            {
               uid = itemToUID(listItem.data);
               if(Boolean(visibleCellRenderers[uid]))
               {
                  listItem = visibleCellRenderers[uid][columnIndex.toString()];
               }
               if(bShiftKey)
               {
                  selectCellItem(listItem,bShiftKey,bCtrlKey);
                  bSelChanged = true;
               }
               else if(bCtrlKey)
               {
                  drawCellItem(listItem,Boolean(cellSelectionData[uid]) && cellSelectionData[uid][columnIndex.toString()] != null,uid == highlightUID && caretColumnIndex == highlightColumnIndex,true);
               }
               else
               {
                  oldCaretIndex = caretIndex;
                  clearSelectedCells();
                  caretIndex = oldCaretIndex;
                  anchorIndex = caretIndex;
                  _selectedIndex = caretIndex;
                  selectCellItem(listItem,bShiftKey,bCtrlKey,false);
                  bSelChanged = true;
               }
            }
         }
         if(bSelChanged)
         {
            evt = new ListEvent(ListEvent.CHANGE);
            evt.itemRenderer = listItem;
            pt = itemRendererToIndices(listItem);
            if(Boolean(pt))
            {
               evt.rowIndex = pt.y;
               evt.columnIndex = displayToAbsoluteColumnIndex(pt.x);
            }
            dispatchEvent(evt);
         }
      }
      
      protected function updateSelectedCells() : void
      {
         switch(selectionMode)
         {
            case NONE:
               if(Boolean(_selectedCells))
               {
                  _selectedCells = null;
               }
               break;
            case SINGLE_ROW:
               _selectedCells = [{
                  "rowIndex":selectedIndex,
                  "columnIndex":-1
               }];
               break;
            case MULTIPLE_ROWS:
               _selectedCells = selectedIndices.map(rowToCell);
         }
      }
      
      override protected function createDisplayableColumns() : void
      {
         var i:int = 0;
         var n:int = 0;
         if(!columnGrouping)
         {
            super.createDisplayableColumns();
         }
         else
         {
            displayableColumns = [];
            n = int(_columns.length);
            for(i = 0; i < n; i++)
            {
               if(getHeaderInfo(_columns[i]).visible)
               {
                  displayableColumns.push(_columns[i]);
               }
            }
         }
      }
      
      public function set groupedColumns(value:Array) : void
      {
         var i:int = 0;
         if(validateGroupedColumns(value))
         {
            if(Boolean(_groupedColumns))
            {
               for(i = 0; i < _groupedColumns.length; i++)
               {
                  if(_groupedColumns[i] is AdvancedDataGridColumnGroup)
                  {
                     columnGroupRendererChanged(AdvancedDataGridColumnGroup(_groupedColumns[i]));
                  }
               }
            }
            _groupedColumns = value;
            groupedColumnsChanged = true;
            invalidateProperties();
         }
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
                  index = int(collection.getItemIndex(item));
                  removed = collection.removeItemAt(index);
                  break;
               }
            }
         }
         return collection.source;
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
               rowsAdded.push(item);
               try
               {
                  cursor.moveNext();
               }
               catch(e:ItemPendingError)
               {
                  break;
               }
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
            ce.location = itemIndex;
            ce.items = rowsRemoved;
            retVal.push(ce);
         }
         return retVal;
      }
      
      override protected function editorKeyDownHandler(event:KeyboardEvent) : void
      {
         if(event.keyCode == Keyboard.F2)
         {
            endEdit(AdvancedDataGridEventReason.OTHER);
            setFocus();
            invalidateDisplayList();
         }
         super.editorKeyDownHandler(event);
      }
      
      override protected function headerReleaseHandler(event:AdvancedDataGridEvent) : void
      {
         var adgEvent:AdvancedDataGridEvent = null;
         if(event.isDefaultPrevented())
         {
            return;
         }
         if(Boolean(itemEditorInstance))
         {
            endEdit(AdvancedDataGridEventReason.OTHER);
         }
         if(sortExpertMode)
         {
            super.headerReleaseHandler(event);
            return;
         }
         adgEvent = new AdvancedDataGridEvent(AdvancedDataGridEvent.SORT,false,true);
         adgEvent.columnIndex = event.columnIndex;
         adgEvent.dataField = event.dataField;
         adgEvent.triggerEvent = event.triggerEvent;
         adgEvent.multiColumnSort = false;
         if(!collection || !collection.sort || !collection.sort.fields || !collection.sort.fields.length)
         {
            dispatchEvent(adgEvent);
            return;
         }
         if(event.headerPart == HEADER_TEXT_PART)
         {
            dispatchEvent(adgEvent);
         }
         else if(event.headerPart == HEADER_ICON_PART)
         {
            adgEvent.multiColumnSort = true;
            dispatchEvent(adgEvent);
         }
      }
      
      public function set designViewDataType(value:String) : void
      {
         _designViewDataType = value;
         designViewDataTypeChanged = true;
      }
      
      private function validateGroupedColumns(groupedColumns:Array) : Boolean
      {
         var k:int = 0;
         var c:AdvancedDataGridColumn = null;
         var uid:String = null;
         var cGroup:AdvancedDataGridColumnGroup = null;
         var dict:Dictionary = new Dictionary();
         var queue:Array = [];
         var valid:Boolean = true;
         for(k = 0; k < groupedColumns.length; k++)
         {
            queue.push(groupedColumns[k]);
         }
         while(queue.length > 0 && valid)
         {
            c = queue.shift();
            uid = itemToUID(c);
            if(dict[uid] != null)
            {
               valid = false;
               throw new Error(resourceManager.getString("datamanagement","repeatColumnsNotAllowed"));
            }
            dict[uid] = c;
            if(c is AdvancedDataGridColumnGroup)
            {
               cGroup = AdvancedDataGridColumnGroup(c);
               if(Boolean(cGroup.children))
               {
                  for(k = 0; k < cGroup.children.length; k++)
                  {
                     queue.push(cGroup.children[k]);
                  }
               }
            }
         }
         return valid;
      }
      
      public function isItemOpen(item:Object) : Boolean
      {
         var uid:String = itemToUID(item);
         return IHierarchicalCollectionView(collection).openNodes[uid] != null;
      }
      
      public function set groupLabelFunction(value:Function) : void
      {
         _groupLabelFunction = value;
         itemsSizeChanged = true;
         invalidateDisplayList();
         dispatchEvent(new Event("groupLabelFunctionChanged"));
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
         else if(parent != null && _rootModel.canHaveChildren(parent) && _rootModel.hasChildren(parent))
         {
            children = getChildren(parent,iterator.view);
            if(children.contains(child))
            {
               while(index < children.length)
               {
                  if(child === children[index])
                  {
                     break;
                  }
                  index++;
               }
            }
         }
         return index;
      }
      
      override protected function getRowHeight(itemData:Object = null) : Number
      {
         if(groupRowHeight > 0 && dataProvider is IHierarchicalCollectionView && _rootModel.hasChildren(itemData))
         {
            return groupRowHeight;
         }
         return super.getRowHeight();
      }
      
      override protected function mouseEventToItemRenderer(event:MouseEvent) : IListItemRenderer
      {
         var r:IListItemRenderer = null;
         var pt:Point = null;
         var ww:Number = NaN;
         if(!columnGrouping)
         {
            return super.mouseEventToItemRenderer(event);
         }
         if(event.target == highlightIndicator || event.target == listContent)
         {
            pt = new Point(event.stageX,event.stageY);
            pt = listContent.globalToLocal(pt);
            ww = 0;
            r = findHeaderRenderer(pt);
         }
         if(!r)
         {
            r = super.mouseEventToItemRenderer(event);
         }
         if(event.target == listContent && isHeaderItemRenderer(r))
         {
            return null;
         }
         return r == itemEditorInstance ? null : r;
      }
      
      [Inspectable(category="General")]
      public function get displayDisclosureIcon() : Boolean
      {
         return _displayDisclosureIcon;
      }
      
      private function getLeafColumns(groupedColumns:Array) : Array
      {
         var prefix:Array = null;
         var postfix:Array = null;
         var i:int = 0;
         while(i < groupedColumns.length)
         {
            if(Boolean(groupedColumns[i] is AdvancedDataGridColumnGroup) && Boolean(groupedColumns[i].children) && groupedColumns[i].children.length > 0)
            {
               prefix = groupedColumns.slice(0,i);
               postfix = groupedColumns.slice(i + 1);
               prefix = prefix.concat(getLeafColumns(groupedColumns[i].children));
               groupedColumns = prefix.concat(postfix);
               i = int(prefix.length);
            }
            else
            {
               i++;
            }
         }
         return groupedColumns;
      }
      
      override protected function getNumColumns() : int
      {
         var optimumColumns:Array = null;
         if(columnGrouping)
         {
            optimumColumns = getOptimumColumns();
            if(!optimumColumns)
            {
               return 0;
            }
            return optimumColumns.length;
         }
         return super.getNumColumns();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function onTweenEnd(value:Object) : void
      {
         var i:int = 0;
         var renderer:* = undefined;
         var dilir:IDropInListItemRenderer = null;
         var itemUID:* = undefined;
         var indicator:Object = null;
         var cellColumnString:String = null;
         var eventArr:Array = null;
         var firstDeletedRow:int = 0;
         var mask:DisplayObject = null;
         var itemRenderer:IListItemRenderer = null;
         UIComponent.resumeBackgroundProcessing();
         onTweenUpdate(value);
         var rC:int = int(listItems.length);
         var col:int = 0;
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
                  for(col = 0; col < listItems[i].length; col++)
                  {
                     renderer = listItems[i][col];
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
                        if(isCellSelectionMode())
                        {
                           if(Boolean(cellSelectionIndicators[itemUID]))
                           {
                              for(cellColumnString in cellSelectionIndicators[itemUID])
                              {
                                 indicator = cellSelectionIndicators[itemUID][cellColumnString];
                                 if(Boolean(indicator))
                                 {
                                    mask = indicator.mask;
                                    if(Boolean(mask))
                                    {
                                       listContent.removeChild(mask);
                                       indicator.mask = null;
                                    }
                                 }
                              }
                              removeCellIndicators(itemUID,int(cellColumnString));
                           }
                        }
                        delete rowMap[renderer.name];
                        if(firstDeletedRow < 0)
                        {
                           firstDeletedRow = i;
                        }
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
               for(col = 0; col < rowList[i].length; col++)
               {
                  mask = rowList[i][col].item.mask;
                  if(Boolean(mask))
                  {
                     listContent.removeChild(mask);
                     rowList[i][col].item.mask = null;
                  }
                  addToFreeItemRenderers(rowList[i][col].item);
                  itemUID = itemToUID(rowList[i][col].item.data);
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
                  if(isCellSelectionMode())
                  {
                     if(Boolean(cellSelectionIndicators[itemUID]))
                     {
                        for(cellColumnString in cellSelectionIndicators[itemUID])
                        {
                           indicator = cellSelectionIndicators[itemUID][cellColumnString];
                           if(Boolean(indicator))
                           {
                              mask = indicator.mask;
                              if(Boolean(mask))
                              {
                                 listContent.removeChild(mask);
                                 indicator.mask = null;
                              }
                           }
                           removeCellIndicators(itemUID,int(cellColumnString));
                        }
                     }
                  }
                  delete rowMap[rowList[i][col].item.name];
               }
            }
            for(i = rowIndex; i < rC; i++)
            {
               if(Boolean(listItems[i].length))
               {
                  for(col = 0; col < listItems[i].length; col++)
                  {
                     renderer = listItems[i][col];
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
         }
         if(Boolean(eventAfterTween))
         {
            itemRenderer = Boolean(eventItemRenderer) ? eventItemRenderer : visibleData[itemToUID(eventAfterTween)];
            dispatchAdvancedDataGridEvent(isItemOpen(eventAfterTween) ? AdvancedDataGridEvent.ITEM_OPEN : AdvancedDataGridEvent.ITEM_CLOSE,eventAfterTween,itemRenderer,lastUserInteraction);
            lastUserInteraction = null;
            eventAfterTween = false;
            itemRenderer = null;
         }
         itemsSizeChanged = true;
         invalidateDisplayList();
         tween = null;
         configureScrollBars();
      }
      
      private function getVisibleChildrenCount(item:Object) : int
      {
         var children:Object = null;
         var n:int = 0;
         var i:int = 0;
         var count:int = 0;
         if(item == null)
         {
            return count;
         }
         var uid:String = itemToUID(item);
         if(Boolean(IHierarchicalCollectionView(collection).openNodes[uid]) && Boolean(_rootModel.canHaveChildren(item)) && _rootModel.hasChildren(item))
         {
            children = getChildren(item,iterator.view);
         }
         if(children != null)
         {
            n = int(children.length);
            for(i = 0; i < n; i++)
            {
               count++;
               uid = itemToUID(children[i]);
               if(Boolean(IHierarchicalCollectionView(collection).openNodes[uid]))
               {
                  count += getVisibleChildrenCount(children[i]);
               }
            }
         }
         return count;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getChildren(item:Object, view:Object) : ICollectionView
      {
         return IHierarchicalCollectionView(collection).getChildren(item);
      }
      
      [Inspectable(category="Data",arrayType="Object")]
      public function get selectedCells() : Array
      {
         if(Boolean(_selectedCells))
         {
            return _selectedCells.slice();
         }
         return null;
      }
      
      protected function isBranch(item:Object) : Boolean
      {
         if(Boolean(_rootModel) && item != null)
         {
            return _rootModel.canHaveChildren(item);
         }
         return false;
      }
      
      override public function set dataProvider(value:Object) : void
      {
         if(Boolean(itemEditorInstance))
         {
            endEdit(AdvancedDataGridEventReason.OTHER);
         }
         if(isCellSelectionMode())
         {
            clearCellSelectionData();
         }
         if(Boolean(_rootModel))
         {
            _rootModel.removeEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler);
         }
         if(value is IHierarchicalData)
         {
            _rootModel = value as IHierarchicalData;
         }
         else if(value is IHierarchicalCollectionView)
         {
            _rootModel = IHierarchicalCollectionView(value).source;
            hierarchicalCollectionInstance = IHierarchicalCollectionView(value);
         }
         else
         {
            _rootModel = null;
            hierarchicalCollectionInstance = null;
            super.dataProvider = value;
         }
         if(Boolean(_rootModel))
         {
            _rootModel.addEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler);
         }
         dataProviderChanged = true;
         invalidateProperties();
      }
      
      private function cellSelectionPendingResultHandler(data:Object, info:AdvancedDataGridBaseSelectionPending) : void
      {
         iterator.seek(info.bookmark,info.offset);
         shiftCellSelectionLoop(info.index,info.anchorIndex,info.columnIndex,info.anchorColumnIndex,info.stopData,info.transition,info.placeHolder);
      }
      
      override protected function makeListData(data:Object, uid:String, rowNum:int, columnNum:int, column:AdvancedDataGridColumn) : BaseListData
      {
         var label:String = null;
         var advancedDataGridListData:AdvancedDataGridListData = null;
         if(data is AdvancedDataGridColumnGroup)
         {
            return new AdvancedDataGridListData(column.headerText != null ? column.headerText : "",data.dataField,-1,uid,this,rowNum);
         }
         if(!(data is AdvancedDataGridColumn))
         {
            if(Boolean(groupItemRenderer) && Boolean(isBranch(data)) && column.colNum == treeColumnIndex)
            {
               if(groupLabelFunction != null)
               {
                  label = groupLabelFunction(data,column);
               }
               else if(groupLabelField != null && data.hasOwnProperty(groupLabelField))
               {
                  label = data[groupLabelField];
               }
               if(Boolean(label))
               {
                  advancedDataGridListData = new AdvancedDataGridListData(label,column.dataField,columnNum,uid,this,rowNum);
               }
            }
         }
         if(!advancedDataGridListData)
         {
            advancedDataGridListData = super.makeListData(data,uid,rowNum,columnNum,column) as AdvancedDataGridListData;
         }
         if(Boolean(iterator && iterator is HierarchicalCollectionViewCursor) && Boolean(columnNum == treeColumnIndex) && !(data is AdvancedDataGridColumn))
         {
            initListData(data,advancedDataGridListData);
         }
         else
         {
            advancedDataGridListData.item = data;
         }
         return advancedDataGridListData;
      }
      
      override protected function dragDropHandler(event:DragEvent) : void
      {
         var items:Array = null;
         var index:int = 0;
         var parent:* = undefined;
         var parentItem:* = undefined;
         var dropParentStack:Array = null;
         var i:int = 0;
         if(isCellSelectionMode())
         {
            return;
         }
         if(!(_rootModel is IHierarchicalData) && Boolean(event.dragSource.hasFormat("items")))
         {
            super.dragDropHandler(event);
            return;
         }
         if(event.isDefaultPrevented())
         {
            return;
         }
         hideDropFeedback(event);
         if((!_rootModel || _rootModel is IHierarchicalData) && Boolean(event.dragSource.hasFormat("treeDataGridItems")))
         {
            if(event.action == DragManager.MOVE && dragMoveEnabled)
            {
               items = event.dragSource.dataForFormat("treeDataGridItems") as Array;
               if(event.dragInitiator == this)
               {
                  calculateDropIndex(event);
                  dropParentStack = getParentStack(_dropData.parent);
                  dropParentStack.unshift(_dropData.parent);
                  loop0:
                  for(i = 0; i < items.length; )
                  {
                     parent = getParentItem(items[i]);
                     index = getChildIndexInParent(parent,items[i]);
                     var _loc8_:int = 0;
                     var _loc9_:* = dropParentStack;
                     do
                     {
                        for each(parentItem in _loc9_)
                        {
                        }
                        removeChildItem(parent,items[i],index);
                        if(parent == _dropData.parent && index < _dropData.index)
                        {
                           addChildItem(_dropData.parent,items[i],_dropData.index - i - 1);
                        }
                        else
                        {
                           addChildItem(_dropData.parent,items[i],_dropData.index);
                        }
                        i++;
                        continue loop0;
                     }
                     while(items[i] != parentItem);
                     return;
                  }
               }
            }
         }
      }
      
      override protected function headerNavigationHandler(event:KeyboardEvent) : void
      {
         var newSelectedHeaderInfo:AdvancedDataGridHeaderInfo = null;
         var siblings:Array = null;
         var advancedDataGridEvent:AdvancedDataGridEvent = null;
         if(!columnGrouping || headerIndex == -1 || selectedHeaderInfo == null)
         {
            super.headerNavigationHandler(event);
         }
         else
         {
            if(headerIndex == -1 || selectedHeaderInfo == null)
            {
               return;
            }
            if(event.keyCode == Keyboard.UP)
            {
               if(selectedHeaderInfo.parent != null)
               {
                  newSelectedHeaderInfo = selectedHeaderInfo.parent;
                  unselectColumnHeader(headerIndex);
                  selectedHeaderInfo = newSelectedHeaderInfo;
                  headerIndex = newSelectedHeaderInfo.index;
                  selectColumnGroupHeader(newSelectedHeaderInfo);
               }
            }
            else if(event.keyCode == Keyboard.DOWN)
            {
               if(selectedHeaderInfo.visibleChildren == null || selectedHeaderInfo.visibleChildren.length == 0)
               {
                  unselectColumnHeader(selectedHeaderInfo.column.colNum,true);
                  headerIndex = -1;
               }
               else
               {
                  newSelectedHeaderInfo = selectedHeaderInfo.visibleChildren[0];
                  unselectColumnHeader(headerIndex);
                  selectedHeaderInfo = newSelectedHeaderInfo;
                  headerIndex = 0;
                  selectColumnGroupHeader(newSelectedHeaderInfo);
               }
            }
            else if(event.keyCode == Keyboard.LEFT)
            {
               siblings = selectedHeaderInfo.parent != null ? selectedHeaderInfo.parent.visibleChildren : visibleHeaderInfos;
               if(selectedHeaderInfo.visibleIndex > 0)
               {
                  newSelectedHeaderInfo = siblings[selectedHeaderInfo.visibleIndex - 1];
                  scrollColumnGroupIfNeeded(selectedHeaderInfo,newSelectedHeaderInfo);
                  unselectColumnHeader(headerIndex);
                  selectedHeaderInfo = newSelectedHeaderInfo;
                  headerIndex = newSelectedHeaderInfo.visibleIndex;
                  selectColumnGroupHeader(newSelectedHeaderInfo);
               }
            }
            else if(event.keyCode == Keyboard.RIGHT)
            {
               siblings = selectedHeaderInfo.parent != null ? selectedHeaderInfo.parent.visibleChildren : visibleHeaderInfos;
               if(selectedHeaderInfo.visibleIndex < siblings.length - 1)
               {
                  newSelectedHeaderInfo = siblings[selectedHeaderInfo.visibleIndex + 1];
                  scrollColumnGroupIfNeeded(selectedHeaderInfo,newSelectedHeaderInfo);
                  unselectColumnHeader(headerIndex);
                  selectedHeaderInfo = newSelectedHeaderInfo;
                  headerIndex = newSelectedHeaderInfo.visibleIndex;
                  selectColumnGroupHeader(newSelectedHeaderInfo);
               }
            }
            else if(event.keyCode == Keyboard.SPACE)
            {
               if(sortableColumns && selectedHeaderInfo.column.colNum != -1 && !isNaN(selectedHeaderInfo.column.colNum) && Boolean(columns[selectedHeaderInfo.column.colNum].sortable))
               {
                  isKeyPressed = true;
                  selectColumnHeader(selectedHeaderInfo.column.colNum);
                  advancedDataGridEvent = new AdvancedDataGridEvent(AdvancedDataGridEvent.SORT,false,true);
                  advancedDataGridEvent.multiColumnSort = event.ctrlKey;
                  advancedDataGridEvent.removeColumnFromSort = event.shiftKey;
                  advancedDataGridEvent.columnIndex = selectedHeaderInfo.column.colNum;
                  advancedDataGridEvent.dataField = selectedHeaderInfo.column.dataField;
                  dispatchEvent(advancedDataGridEvent);
               }
            }
            else if(event.shiftKey && (event.keyCode == Keyboard.PAGE_UP || event.keyCode == Keyboard.PAGE_DOWN))
            {
               moveSelectionHorizontally(event.keyCode,event.shiftKey,event.ctrlKey);
            }
            event.stopPropagation();
         }
      }
      
      override protected function collectionChangeHandler(event:Event) : void
      {
         var ceEvent:CollectionEvent = null;
         var ce:CollectionEvent = null;
         var n:int = 0;
         var i:int = 0;
         if(event is CollectionEvent)
         {
            ceEvent = CollectionEvent(event);
            if(ceEvent.kind == CollectionEventKind.RESET)
            {
               if(_rootModel is IGroupingCollection && Boolean(IGroupingCollection(_rootModel).grouping))
               {
                  groupLabelField = IGroupingCollection(_rootModel).grouping.label;
               }
               if(displayItemsExpanded)
               {
                  expandAll();
               }
            }
         }
         super.collectionChangeHandler(event);
         if(event is CollectionEvent)
         {
            ce = CollectionEvent(event);
            if(ce.kind == CollectionEventKind.ADD)
            {
               if(_displayItemsExpanded)
               {
                  n = int(ce.items.length);
                  for(i = 0; i < n; i++)
                  {
                     expandChildrenOf(ce.items[i],true);
                  }
               }
            }
         }
      }
      
      public function setDesignView() : void
      {
         designViewDataType = dataType;
         designViewDataTypeChanged = true;
         invalidateProperties();
      }
      
      protected function cellNavigationHandler(event:KeyboardEvent) : void
      {
         var validKeys:Array = null;
         var isValidKey:Boolean = false;
         var i:int = 0;
         var bUpdateVerticalScrollPosition:Boolean = false;
         var newVerticalScrollPosition:Number = NaN;
         var newHorizontalScrollPosition:Number = NaN;
         var maxPosition:int = 0;
         var rowCount:int = 0;
         var partialRow:int = 0;
         var newCaretColumnIndex:int = 0;
         var oldCaretColumnIndex:int = 0;
         var newData:Object = null;
         var advancedDataGridEvent:AdvancedDataGridEvent = null;
         var visibleCoords:Object = null;
         var visibleRowIndex:int = 0;
         var visibleColIndex:int = 0;
         var se:ScrollEvent = null;
         validKeys = [Keyboard.UP,Keyboard.DOWN,Keyboard.LEFT,Keyboard.RIGHT,Keyboard.SPACE,Keyboard.HOME,Keyboard.END,Keyboard.PAGE_UP,Keyboard.PAGE_DOWN,Keyboard.F2];
         isValidKey = false;
         for(i = 0; i < validKeys.length; i++)
         {
            if(event.keyCode == validKeys[i])
            {
               isValidKey = true;
               break;
            }
         }
         if(!isValidKey)
         {
            if(findKey(event.keyCode))
            {
               event.stopPropagation();
            }
            return;
         }
         var bUpdateHorizontalScrollPosition:Boolean = false;
         bUpdateVerticalScrollPosition = false;
         rowCount = int(listItems.length);
         if(rowCount == 0)
         {
            return;
         }
         partialRow = 0;
         if(rowInfo[rowCount - 1].y + rowInfo[rowCount - 1].height > listContent.height)
         {
            partialRow++;
         }
         showCaret = true;
         bSelectItem = false;
         switch(event.keyCode)
         {
            case Keyboard.UP:
               if(caretIndex == 0 && selectedIndex == 0 && headerVisible && !event.ctrlKey && !event.shiftKey)
               {
                  oldCaretColumnIndex = caretColumnIndex;
                  clearSelectedCells();
                  moveFocusToHeader(oldCaretColumnIndex);
               }
               else if(caretIndex > 0)
               {
                  if(visibleColumns.length > 0 && visibleColumns[0].colNum > caretColumnIndex)
                  {
                     caretColumnIndex = visibleColumns[0].colNum;
                  }
                  --caretIndex;
                  bUpdateVerticalScrollPosition = true;
                  bSelectItem = true;
               }
               break;
            case Keyboard.DOWN:
               if(caretIndex < collection.length - 1)
               {
                  ++caretIndex;
                  if(caretIndex == 0)
                  {
                     caretColumnIndex = 0;
                  }
                  else if(visibleColumns.length > 0 && visibleColumns[0].colNum > caretColumnIndex)
                  {
                     caretColumnIndex = visibleColumns[0].colNum;
                  }
                  bUpdateVerticalScrollPosition = true;
                  bSelectItem = true;
               }
               else if(caretIndex == collection.length - 1 && Boolean(partialRow))
               {
                  if(verticalScrollPosition < maxVerticalScrollPosition)
                  {
                     newVerticalScrollPosition = verticalScrollPosition + 1;
                  }
               }
               break;
            case Keyboard.LEFT:
               newCaretColumnIndex = viewDisplayableColumnAtOffset(caretColumnIndex,-1,caretIndex);
               if(newCaretColumnIndex != -1)
               {
                  caretColumnIndex = newCaretColumnIndex;
                  bSelectItem = true;
               }
               break;
            case Keyboard.RIGHT:
               newCaretColumnIndex = viewDisplayableColumnAtOffset(caretColumnIndex,1,caretIndex);
               if(newCaretColumnIndex != -1)
               {
                  caretColumnIndex = newCaretColumnIndex;
                  bSelectItem = true;
               }
               break;
            case Keyboard.SPACE:
               bSelectItem = event.ctrlKey;
               break;
            case Keyboard.HOME:
            case Keyboard.END:
            case Keyboard.PAGE_UP:
            case Keyboard.PAGE_DOWN:
               moveSelectionVertically(event.keyCode,event.shiftKey,event.ctrlKey);
               break;
            case Keyboard.F2:
               if(caretColumnIndex != -1)
               {
                  newData = rowNumberToData(caretIndex);
                  if(Boolean(newData) && isDataEditable(newData))
                  {
                     advancedDataGridEvent = new AdvancedDataGridEvent(AdvancedDataGridEvent.ITEM_EDIT_BEGINNING,false,true);
                     advancedDataGridEvent.columnIndex = caretColumnIndex;
                     advancedDataGridEvent.dataField = columns[caretColumnIndex].dataField;
                     advancedDataGridEvent.rowIndex = caretIndex;
                     visibleCoords = absoluteToVisibleIndices(caretIndex,caretColumnIndex);
                     visibleRowIndex = int(visibleCoords.rowIndex);
                     visibleColIndex = int(visibleCoords.columnIndex);
                     advancedDataGridEvent.itemRenderer = listItems[visibleRowIndex][visibleColIndex];
                     dispatchEvent(advancedDataGridEvent);
                  }
               }
         }
         event.stopPropagation();
         if(bUpdateVerticalScrollPosition)
         {
            if(caretIndex < lockedRowCount)
            {
               newVerticalScrollPosition = 0;
            }
            else if(caretIndex < verticalScrollPosition + lockedRowCount)
            {
               newVerticalScrollPosition = caretIndex - lockedRowCount;
            }
            else if(caretIndex >= verticalScrollPosition + rowCount - partialRow)
            {
               newVerticalScrollPosition = Math.min(maxVerticalScrollPosition,caretIndex - rowCount + partialRow + 1);
            }
            if(!isNaN(newVerticalScrollPosition))
            {
               if(verticalScrollPosition != newVerticalScrollPosition)
               {
                  se = new ScrollEvent(ScrollEvent.SCROLL);
                  se.detail = ScrollEventDetail.THUMB_POSITION;
                  se.direction = ScrollEventDirection.VERTICAL;
                  se.delta = newVerticalScrollPosition - verticalScrollPosition;
                  se.position = newVerticalScrollPosition;
                  verticalScrollPosition = newVerticalScrollPosition;
                  dispatchEvent(se);
               }
               if(!iteratorValid)
               {
                  keySelectionPending = true;
                  return;
               }
            }
         }
         bShiftKey = event.shiftKey;
         bCtrlKey = event.ctrlKey;
         lastKey = event.keyCode;
         finishCellKeySelection();
      }
      
      [Inspectable(category="Data")]
      [Bindable("groupIconFunctionChanged")]
      public function get groupIconFunction() : Function
      {
         return _groupIconFunction;
      }
      
      override protected function initializeAccessibility() : void
      {
         if(AdvancedDataGrid.createAccessibilityImplementation != null)
         {
            AdvancedDataGrid.createAccessibilityImplementation(this);
         }
      }
      
      private function getAdjustedLockedCount(index:int) : int
      {
         if(Boolean(visibleHeaderInfos))
         {
            index = Math.min(index,visibleHeaderInfos.length);
            if(Boolean(visibleHeaderInfos[index - 1]))
            {
               return visibleHeaderInfos[index - 1].actualColNum + visibleHeaderInfos[index - 1].columnSpan;
            }
         }
         return 0;
      }
      
      private function getIndent() : Number
      {
         var p:String = null;
         var depth:Number = 0;
         for(p in IHierarchicalCollectionView(collection).openNodes)
         {
            depth = Math.max(getItemDepth(IHierarchicalCollectionView(collection).openNodes[p],0),depth);
         }
         return depth * getStyle("indentation");
      }
      
      override protected function setVisibleDataItem(uid:String, item:IListItemRenderer) : void
      {
         if(isCellSelectionMode())
         {
            if(Boolean(uid))
            {
               if(!visibleCellRenderers[uid])
               {
                  visibleCellRenderers[uid] = {};
               }
               visibleCellRenderers[uid][indexToColNum(currentColNum).toString()] = item;
            }
         }
         super.setVisibleDataItem(uid,item);
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
      
      private function shiftCellSelectionLoop(stopIndex:int, anchorIndex:int, stopColumnIndex:int, anchorColumnIndex:int, stopData:Object, transition:Boolean, placeHolder:CursorBookmark) : void
      {
         var incr:Boolean = false;
         var columnIncr:Boolean = false;
         var data:Object = null;
         var uid:String = null;
         var index:int = 0;
         var columnIndex:* = undefined;
         incr = anchorIndex < stopIndex;
         columnIncr = anchorColumnIndex < stopColumnIndex;
         index = anchorIndex;
         try
         {
            do
            {
               data = iterator.current;
               uid = itemToUID(data);
               columnIndex = anchorColumnIndex;
               while(true)
               {
                  if(Boolean(visibleCellRenderers[uid]) && Boolean(visibleCellRenderers[uid][columnIndex.toString()]) && Boolean(visibleCellRenderers[uid][columnIndex.toString()].visible))
                  {
                     addCellSelectionData(uid,columnIndex,new AdvancedDataGridBaseSelectionData(data,index,columnIndex,false));
                     addToSelectedCells(index,columnIndex);
                     drawCellItem(visibleCellRenderers[uid][columnIndex.toString()],true,uid == highlightUID && columnIndex == highlightColumnIndex,false,transition);
                  }
                  if(!(columnIndex != stopColumnIndex && columnIndex != -1))
                  {
                     break;
                  }
                  if(columnIncr)
                  {
                     columnIndex = viewDisplayableColumnAtOffset(columnIndex,1,-1,false);
                  }
                  else
                  {
                     columnIndex = viewDisplayableColumnAtOffset(columnIndex,-1,-1,false);
                  }
               }
               if(data == stopData)
               {
                  if(Boolean(visibleCellRenderers[uid]) && Boolean(visibleCellRenderers[uid][columnIndex.toString()]))
                  {
                     drawCellItem(visibleCellRenderers[uid][columnIndex.toString()],true,uid == highlightUID && columnIndex == highlightColumnIndex,true,transition);
                  }
                  break;
               }
               if(incr)
               {
                  index++;
               }
               else
               {
                  index--;
               }
            }
            while(incr ? Boolean(iterator.moveNext()) : Boolean(iterator.movePrevious()));
         }
         catch(e:ItemPendingError)
         {
            e.addResponder(new ItemResponder(cellSelectionPendingResultHandler,cellSelectionPendingFailureHandler,new AdvancedDataGridBaseSelectionPending(index,anchorIndex,columnIndex,anchorColumnIndex,data,transition,placeHolder,CursorBookmark.CURRENT,0)));
            iteratorValid = false;
         }
         try
         {
            iterator.seek(placeHolder,0);
            iteratorValid = true;
         }
         catch(e2:ItemPendingError)
         {
            lastSeekPending = new ListBaseSeekPending(placeHolder,0);
            e2.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
         }
      }
      
      private function cellSelectionPendingFailureHandler(data:Object, info:AdvancedDataGridBaseSelectionPending) : void
      {
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function onTweenUpdate(value:Object) : void
      {
         var renderer:IFlexDisplayObject = null;
         var n:int = 0;
         var i:int = 0;
         var deltaY:Number = NaN;
         var lastY:Number = NaN;
         var columnIndexString:String = null;
         var cellSelectionUID:String = null;
         var s:Sprite = null;
         var col:int = 0;
         var doOnce:Boolean = false;
         n = int(listItems.length);
         for(i = rowIndex; i < n; i++)
         {
            if(Boolean(listItems[i].length))
            {
               for(col = 0; col < listItems[i].length; col++)
               {
                  renderer = IFlexDisplayObject(listItems[i][col]);
                  lastY = Number(renderer.y);
                  renderer.move(renderer.x,rowInfo[i].itemOldY + value);
                  deltaY = renderer.y - lastY;
               }
            }
            rowInfo[i].y += deltaY;
            s = selectionIndicators[rowInfo[i].uid];
            if(Boolean(s))
            {
               s.y += deltaY;
            }
            if(isCellSelectionMode())
            {
               cellSelectionUID = rowInfo[i].uid;
               if(Boolean(cellSelectionIndicators[cellSelectionUID]))
               {
                  for(columnIndexString in cellSelectionIndicators[cellSelectionUID])
                  {
                     cellSelectionIndicators[cellSelectionUID][columnIndexString].y += deltaY;
                  }
               }
            }
         }
         n = int(rowList.length);
         for(i = 0; i < n; i++)
         {
            doOnce = true;
            for(col = 0; col < rowList[i].length; col++)
            {
               s = null;
               renderer = IFlexDisplayObject(rowList[i][col].item);
               if(rowMap[renderer.name] != null)
               {
                  s = selectionIndicators[BaseListData(rowMap[renderer.name]).uid];
               }
               lastY = Number(renderer.y);
               renderer.move(renderer.x,rowList[i][col].itemOldY + value);
               deltaY = renderer.y - lastY;
               if(doOnce && Boolean(s))
               {
                  s.y += deltaY;
                  doOnce = false;
               }
            }
            if(isCellSelectionMode())
            {
               cellSelectionUID = BaseListData(rowMap[renderer.name]).uid;
               if(Boolean(cellSelectionIndicators[cellSelectionUID]))
               {
                  for(columnIndexString in cellSelectionIndicators[cellSelectionUID])
                  {
                     cellSelectionIndicators[cellSelectionUID][columnIndexString].y += deltaY;
                  }
               }
            }
         }
      }
      
      override protected function createHeaderSeparators(n:int, separators:Array, headerLines:UIComponent) : void
      {
         var separatorAffordance:Number = NaN;
         var optimumColumns:Array = null;
         var offset:int = 0;
         var i:int = 0;
         var headerItemIndex:int = 0;
         var sep:UIComponent = null;
         var sepSkin:IFlexDisplayObject = null;
         var leftHeaderInfo:AdvancedDataGridHeaderInfo = null;
         var leftHeaderItem:IListItemRenderer = null;
         var posX:Number = NaN;
         var rightHeaderInfo:AdvancedDataGridHeaderInfo = null;
         var lineHeight:Number = NaN;
         var leftParent:AdvancedDataGridHeaderInfo = null;
         var rightParent:AdvancedDataGridHeaderInfo = null;
         var padding:int = 0;
         if(!columnGrouping)
         {
            super.createHeaderSeparators(n,separators,headerLines);
         }
         else
         {
            separatorAffordance = 3;
            optimumColumns = getOptimumColumns();
            offset = lockedColumnCount > 0 && separators != lockedSeparators ? int(lockedColumnCount - 1) : 0;
            for(i = 0; i < n; i++)
            {
               headerItemIndex = i + offset;
               sep = getSeparator(i,separators,headerLines);
               sepSkin = IFlexDisplayObject(sep.getChildAt(0));
               leftHeaderInfo = getHeaderInfo(optimumColumns[headerItemIndex]);
               leftHeaderItem = leftHeaderInfo.headerItem;
               if(!leftHeaderInfo || !leftHeaderInfo.visible || !leftHeaderItem)
               {
                  sep.visible = false;
               }
               else
               {
                  sep.visible = true;
                  posX = leftHeaderItem.x + optimumColumns[headerItemIndex].width - Math.round(sep.measuredWidth / 2 + 0.5);
                  if(i > 0)
                  {
                     posX = Math.max(posX,separators[i - 1].x + Math.round(sep.measuredWidth / 2 + 0.5));
                  }
                  sep.x = posX;
                  rightHeaderInfo = getHeaderInfo(optimumColumns[headerItemIndex + 1]);
                  leftParent = leftHeaderInfo;
                  rightParent = rightHeaderInfo;
                  padding = cachedPaddingBottom + cachedPaddingTop;
                  while(leftParent != rightParent && leftParent.parent != null && rightParent.parent != null)
                  {
                     if(leftParent.depth > rightParent.depth)
                     {
                        leftParent = leftParent.parent;
                     }
                     else if(leftParent.depth < rightParent.depth)
                     {
                        rightParent = rightParent.parent;
                     }
                     else
                     {
                        leftParent = leftParent.parent;
                        rightParent = rightParent.parent;
                     }
                  }
                  sep.y = 0;
                  lineHeight = leftHeaderItem.y + leftHeaderItem.height + padding;
                  if(leftParent == rightParent && Boolean(leftParent))
                  {
                     sep.y = leftParent.headerItem.y + leftParent.headerItem.height + cachedPaddingBottom;
                     lineHeight = leftHeaderItem.y + leftHeaderItem.height - leftParent.headerItem.y - leftParent.headerItem.height;
                  }
                  sepSkin.setActualSize(sepSkin.measuredWidth,lineHeight);
                  sep.graphics.clear();
                  sep.graphics.beginFill(16777215,0);
                  sep.graphics.drawRect(-separatorAffordance,0,sepSkin.measuredWidth + separatorAffordance,lineHeight);
                  sep.graphics.endFill();
               }
            }
         }
      }
      
      [Inspectable(category="General",arrayType="mx.controls.advancedDataGridClasses.AdvancedDataGridColumn")]
      override public function set columns(value:Array) : void
      {
         _columnsValue = value;
         columnsChanged = true;
         generatedColumns = false;
         invalidateProperties();
      }
      
      [Inspectable(category="Data",defaultValue="null")]
      [Bindable("collectionChange")]
      override public function get dataProvider() : Object
      {
         if(Boolean(super.dataProvider))
         {
            return super.dataProvider;
         }
         return null;
      }
      
      override protected function updateHeaderSearchList() : void
      {
         orderedHeadersList = [];
         updateHeadersList(visibleHeaderInfos);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getWidthOfItem(item:IListItemRenderer, col:AdvancedDataGridColumn, visibleColumnIndex:int) : Number
      {
         var i:int = 0;
         var end:int = 0;
         var lastColIndex:int = 0;
         var tmpWidth:Number = NaN;
         var optimumColumns:Array = null;
         var residualWidth:Number = NaN;
         var lastCol:AdvancedDataGridColumn = null;
         var ww:Number = 0;
         var adgDescription:AdvancedDataGridRendererDescription = rendererDescriptionMap[item] as AdvancedDataGridRendererDescription;
         if(Boolean(adgDescription) && Boolean(adgDescription.renderer))
         {
            if(adgDescription.columnSpan == 0)
            {
               end = int(_columns.length);
               if(visibleColumnIndex < lockedColumnCount)
               {
                  end = lockedColumnCount;
               }
               tmpWidth = 0;
               for(i = visibleColumnIndex; i < end; i++)
               {
                  tmpWidth += AdvancedDataGridColumn(_columns[i]).width;
               }
               ww = tmpWidth;
            }
            else
            {
               ww = 0;
               end = visibleColumnIndex + adgDescription.columnSpan;
               if(visibleColumnIndex < lockedColumnCount && end > lockedColumnCount)
               {
                  end = lockedColumnCount;
               }
               if(end > displayableColumns.length)
               {
                  end = int(displayableColumns.length);
               }
               optimumColumns = getOptimumColumns();
               for(i = visibleColumnIndex; i < end; i++)
               {
                  ww += super.getWidthOfItem(item,optimumColumns[i],visibleColumnIndex);
               }
            }
            lastColIndex = displayableColumns.length - 1;
            if(horizontalScrollPolicy != ScrollPolicy.OFF && lastColIndex >= visibleColumnIndex && lastColIndex < end)
            {
               residualWidth = getLastColumnResidualWidth();
               lastCol = displayableColumns[lastColIndex];
               ww -= lastCol.width;
               ww += (isNaN(lastCol.explicitWidth) ? lastCol.preferredWidth : lastCol.explicitWidth) + getLastColumnResidualWidth();
            }
            return ww;
         }
         if(horizontalScrollPolicy != ScrollPolicy.OFF && col == displayableColumns[displayableColumns.length - 1])
         {
            return (isNaN(col.explicitWidth) ? col.preferredWidth : col.explicitWidth) + getLastColumnResidualWidth();
         }
         return super.getWidthOfItem(item,col,visibleColumnIndex);
      }
      
      protected function createHeaderHorizontalSeparators(subHeaderInfos:Array, seperators:Array, headerLines:UIComponent) : void
      {
         var sep:UIComponent = null;
         var sepSkin:IFlexDisplayObject = null;
         var w:Number = NaN;
         var depth:int = 0;
         var n:int = int(subHeaderInfos.length);
         for(var i:int = 0; i < n; i++)
         {
            if(Boolean(subHeaderInfos[i].visible) && Boolean(subHeaderInfos[i].visibleChildren) && subHeaderInfos[i].visibleChildren.length > 0)
            {
               sep = getHorizontalSeparator(numSeparators,seperators,headerLines);
               sepSkin = IFlexDisplayObject(sep.getChildAt(0));
               if(!subHeaderInfos[i].headerItem)
               {
                  sep.visible = false;
               }
               ++numSeparators;
               sep.visible = true;
               w = Number(subHeaderInfos[i].column.width);
               sepSkin.setActualSize(w,2);
               sep.x = subHeaderInfos[i].headerItem.x;
               depth = int(subHeaderInfos[i].depth);
               sep.y = headerRowInfo[depth].y + (headerRowInfo[depth].height - headerRowInfo[depth + 1].height) - 2;
               createHeaderHorizontalSeparators(subHeaderInfos[i].children,seperators,headerLines);
            }
         }
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         if(styleProp == "sortFontFamily" || styleProp == "sortFontSize" || styleProp == "sortFontStyle" || styleProp == "sortFontWeight")
         {
            itemsSizeChanged = true;
            rendererChanged = true;
            invalidateProperties();
            invalidateDisplayList();
         }
      }
      
      public function set groupRowHeight(value:Number) : void
      {
         _groupRowHeight = value;
         invalidateSize();
         invalidateDisplayList();
         itemsSizeChanged = true;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function expandItemHandler(event:AdvancedDataGridEvent) : void
      {
         if(event.isDefaultPrevented())
         {
            return;
         }
         if(event.type == AdvancedDataGridEvent.ITEM_OPENING)
         {
            eventItemRenderer = event.itemRenderer;
            expandItem(event.item,event.opening,event.animate,event.dispatchEvent,event.triggerEvent);
         }
      }
      
      private function isCellAlreadySelected(givenCell:Object) : Boolean
      {
         var n:int = 0;
         var i:int = 0;
         if(!selectedCells || !selectedCells.length)
         {
            return false;
         }
         n = int(selectedCells.length);
         for(i = 0; i < n; i++)
         {
            if(selectedCells[i].rowIndex == givenCell.rowIndex && selectedCells[i].columnIndex == givenCell.columnIndex)
            {
               return true;
            }
         }
         return false;
      }
      
      protected function updateVisibleHeaderInfos(headerInfos:Array = null, parentVisible:Boolean = true, actualColNum:int = 0) : Object
      {
         var i:int = 0;
         var visibleHeaderInfos:Array = null;
         var headerInfo:AdvancedDataGridHeaderInfo = null;
         var children:Object = null;
         var n:int = Boolean(headerInfos) ? int(headerInfos.length) : 0;
         var k:int = 0;
         var totalColumnSpan:int = 0;
         for(i = 0; i < n; i++)
         {
            headerInfo = headerInfos[i];
            if(!parentVisible)
            {
               headerInfo.visible = false;
            }
            else
            {
               headerInfo.visible = headerInfo.column.visible;
            }
            if(headerInfos[i].visible == false)
            {
               headerInfo.visibleIndex = NaN;
               headerInfo.actualColNum = NaN;
               headerInfo.columnSpan = 0;
               updateVisibleHeaderInfos(headerInfo.children,false);
            }
            else if(Boolean(headerInfos[i].children) && headerInfos[i].children.length > 0)
            {
               children = updateVisibleHeaderInfos(headerInfos[i].children,true,actualColNum);
               headerInfo.visibleChildren = children.infos;
               if(headerInfo.visibleChildren == null)
               {
                  headerInfo.visible = false;
                  headerInfo.actualColNum = NaN;
                  headerInfo.columnSpan = 0;
               }
               else
               {
                  if(!visibleHeaderInfos)
                  {
                     visibleHeaderInfos = [];
                  }
                  visibleHeaderInfos.push(headerInfo);
                  headerInfo.visibleIndex = k++;
                  headerInfo.actualColNum = actualColNum;
                  headerInfo.columnSpan = children.colSpan;
               }
            }
            else
            {
               if(!visibleHeaderInfos)
               {
                  visibleHeaderInfos = [];
               }
               headerInfo.visibleIndex = k++;
               visibleHeaderInfos.push(headerInfo);
               headerInfo.actualColNum = actualColNum;
               headerInfo.columnSpan = 1;
            }
            totalColumnSpan += headerInfo.columnSpan;
            actualColNum += headerInfo.columnSpan;
         }
         return {
            "infos":visibleHeaderInfos,
            "colSpan":totalColumnSpan
         };
      }
      
      protected function clearHeaderHorizontalSeparators() : void
      {
         if(!horizontalSeparators)
         {
            return;
         }
         var lines:Sprite = Sprite(listSubContent.getChildByName("lines"));
         var headerHorizontalLines:Sprite = Sprite(lines.getChildByName("headerHorizontalLines"));
         while(Boolean(headerHorizontalLines.numChildren))
         {
            headerHorizontalLines.removeChildAt(headerHorizontalLines.numChildren - 1);
            horizontalSeparators.pop();
         }
         var lockedContent:Sprite = getLockedContent();
         var lockedHeaderHorizontalLines:Sprite = Sprite(lockedContent.getChildByName("lockedHeaderheaderHorizontalLines"));
         if(Boolean(lockedHeaderHorizontalLines))
         {
            while(Boolean(lockedHeaderHorizontalLines.numChildren))
            {
               lockedHeaderHorizontalLines.removeChildAt(lockedHeaderHorizontalLines.numChildren - 1);
               horizontalLockedSeparators.pop();
            }
         }
      }
      
      [Bindable("firstVisibleItemChanged")]
      public function get firstVisibleItem() : Object
      {
         return listItems[0][0].data;
      }
      
      private function updateCompleteHandler(event:FlexEvent) : void
      {
         if(UIComponentGlobals.designTime)
         {
            if(!dataProvider || dataProvider is ArrayCollection && !ArrayCollection(dataProvider).length)
            {
               setDesignViewData();
            }
            if(Boolean(designViewDataType == designViewDataTreeType && dataProvider) && Boolean(dataProvider is IHierarchicalCollectionView) && (designViewDataFlag || !atLeastOneProperty(IHierarchicalCollectionView(collection).openNodes)))
            {
               IHierarchicalCollectionView(collection).openNodes = IHierarchicalCollectionView(dataProvider).createCursor().current;
               invalidateProperties();
               invalidateDisplayList();
               designViewDataFlag = false;
            }
            if(designViewDataTypeChanged)
            {
               designViewDataTypeChanged = false;
               setDesignViewSort();
            }
         }
      }
      
      override protected function purgeHeaderRenderers() : void
      {
         var item:IListItemRenderer = null;
         if(!columnGrouping)
         {
            super.purgeHeaderRenderers();
         }
         else if(Boolean(headerItemsList) && Boolean(headerItemsList.length))
         {
            while(Boolean(headerItemsList.length))
            {
               item = headerItemsList.pop();
               addHeaderToFreeItemRenderers(item,item.data as AdvancedDataGridColumn);
            }
         }
      }
      
      override protected function commitProperties() : void
      {
         var tmpCollection:Object = null;
         if(dataProviderChanged)
         {
            dataProviderChanged = false;
            if(Boolean(hierarchicalCollectionInstance))
            {
               super.dataProvider = hierarchicalCollectionInstance;
               hierarchicalCollectionInstance.addEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler,false,EventPriority.DEFAULT_HANDLER,true);
            }
            else if(_rootModel is IHierarchicalData)
            {
               hierarchicalCollectionView.source = _rootModel;
               super.dataProvider = hierarchicalCollectionView;
               hierarchicalCollectionView.addEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler,false,EventPriority.DEFAULT_HANDLER,true);
            }
         }
         if(_rootModel is IGroupingCollection && Boolean(IGroupingCollection(_rootModel).grouping))
         {
            groupLabelField = IGroupingCollection(_rootModel).grouping.label;
         }
         if(groupedColumnsChanged || columnsChanged)
         {
            anchorColumnIndex = -1;
            highlightColumnIndex = -1;
            selectedColumnIndex = -1;
         }
         if(groupedColumnsChanged)
         {
            columnGrouping = true;
            columnsChanged = false;
            removeOldHeaders();
            columnsToInfo = new Dictionary();
            headerInfos = initializeHeaderInfo(_groupedColumns);
            headerInfoInitialized = true;
            if(lockedColumnCount > 0)
            {
               lockedColumnCountChanged = true;
            }
            super.columns = getLeafColumns(_groupedColumns.slice(0));
         }
         else if(columnsChanged)
         {
            columnGrouping = false;
            columnsChanged = false;
            removeOldHeaders();
            super.columns = _columnsValue;
         }
         if(displayItemsExpandedChanged)
         {
            displayItemsExpandedChanged = false;
            if(displayItemsExpanded)
            {
               expandAll();
            }
         }
         super.commitProperties();
         if(lockedColumnCountChanged)
         {
            if(columnGrouping)
            {
               super.lockedColumnCount = getAdjustedLockedCount(_lockedColumnCountVal);
            }
            else
            {
               super.lockedColumnCount = _lockedColumnCountVal;
            }
         }
         if(groupedColumnsChanged)
         {
            groupedColumnsChanged = false;
            headerInfoInitialized = false;
         }
         if(selectedCellsChanged)
         {
            setSelectedCells(_temporary_selectedCells);
            selectedCellsChanged = false;
            _temporary_selectedCells = null;
         }
         if(anchorColumnIndex != -1 && columns[anchorColumnIndex].visible == false)
         {
            anchorColumnIndex = -1;
         }
         if(highlightColumnIndex != -1 && columns[highlightColumnIndex].visible == false)
         {
            highlightColumnIndex = -1;
         }
         if(selectedColumnIndex != -1 && columns[selectedColumnIndex].visible == false)
         {
            selectedColumnIndex = -1;
         }
      }
      
      override protected function sortHandler(event:AdvancedDataGridEvent) : void
      {
         var columnNumber:int = 0;
         var headerInfo:AdvancedDataGridHeaderInfo = null;
         if(event.isDefaultPrevented())
         {
            return;
         }
         if(!sortableColumns || isNaN(event.columnIndex) || event.columnIndex == -1 || !columns[event.columnIndex].sortable)
         {
            return;
         }
         if(columnGrouping)
         {
            columnNumber = event.columnIndex;
            if(isNaN(columnNumber) || columnNumber == -1)
            {
               return;
            }
            headerInfo = getHeaderInfo(columns[columnNumber]);
            if(headerInfo.internalLabelFunction != null)
            {
               event.dataField = null;
            }
         }
         if(columnGrouping && selectedHeaderInfo != null)
         {
            selectedHeaderInfo = getHeaderInfo(columns[event.columnIndex]);
         }
         super.sortHandler(event);
         if(isRowSelectionMode())
         {
            updateSelectedCells();
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set movingColumnIndex(index:int) : void
      {
         _movingColumnIndex = index;
         if(Boolean(index >= 0 && orderedHeadersList) && Boolean(index < orderedHeadersList.length) && Boolean(orderedHeadersList[index]))
         {
            movingColumn = orderedHeadersList[index].column;
         }
      }
      
      override protected function updateVisibleHeaders() : Array
      {
         if(!columnGrouping)
         {
            return super.updateVisibleHeaders();
         }
         return updateVisibleHeaderInfos(headerInfos).infos;
      }
      
      override public function set lockedColumnCount(value:int) : void
      {
         _lockedColumnCountVal = value;
         lockedColumnCountChanged = true;
         invalidateProperties();
      }
      
      override protected function clearAllSelection() : void
      {
         if(isCellSelectionMode())
         {
            clearSelectedCells();
            clearCellIndicators();
         }
         super.clearAllSelection();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removeFromSelectedCells(rowIndex:int, columnIndex:int) : void
      {
         var cellToRemove:int = 0;
         var i:int = 0;
         cellToRemove = -1;
         if(Boolean(_selectedCells))
         {
            for(i = 0; i < _selectedCells.length; i++)
            {
               if(_selectedCells[i].rowIndex == rowIndex && _selectedCells[i].columnIndex == columnIndex)
               {
                  cellToRemove = i;
                  break;
               }
            }
            if(cellToRemove != -1)
            {
               _selectedCells.splice(cellToRemove,1);
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function addToSelectedCells(rowIndex:int, columnIndex:int) : void
      {
         var newCell:Object = null;
         var newSelectedCells:Array = null;
         newCell = {
            "rowIndex":rowIndex,
            "columnIndex":columnIndex
         };
         if(isCellAlreadySelected(newCell))
         {
            return;
         }
         newSelectedCells = _selectedCells;
         if(!newSelectedCells)
         {
            newSelectedCells = [];
         }
         newSelectedCells.unshift(newCell);
         _selectedCells = newSelectedCells;
      }
      
      [Inspectable(category="Data")]
      public function get groupRowHeight() : Number
      {
         return _groupRowHeight;
      }
      
      override protected function getOptimumColumns() : Array
      {
         if(rendererProviders.length > 0 && horizontalScrollPolicy != ScrollPolicy.OFF || columnGrouping)
         {
            return displayableColumns;
         }
         return super.getOptimumColumns();
      }
      
      override protected function mouseClickHandler(event:MouseEvent) : void
      {
         if(!tween)
         {
            super.mouseClickHandler(event);
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getMeasuringRenderer(c:AdvancedDataGridColumn, forHeader:Boolean, data:Object) : IListItemRenderer
      {
         var adgDescription:AdvancedDataGridRendererDescription = null;
         var factory:IFactory = null;
         var item:IListItemRenderer = null;
         if(!forHeader)
         {
            if(rendererProviders.length != 0)
            {
               adgDescription = getRendererDescription(data,c,false);
               if(Boolean(adgDescription) && Boolean(adgDescription.renderer))
               {
                  factory = adgDescription.renderer;
                  item = measuringObjects[factory];
                  if(!item)
                  {
                     item = adgDescription.renderer.newInstance();
                     item.visible = false;
                     item.styleName = c;
                     listContent.addChild(DisplayObject(item));
                     measuringObjects[factory] = item;
                  }
                  return item;
               }
            }
         }
         return super.getMeasuringRenderer(c,forHeader,data);
      }
      
      override protected function drawVerticalLine(s:Sprite, colIndex:int, color:uint, x:Number) : void
      {
         var item:IListItemRenderer = null;
         var i:int = 0;
         var j:int = 0;
         var g:Graphics = s.graphics;
         if(lockedColumnCount > 0 && colIndex == lockedColumnCount - 1)
         {
            g.lineStyle(1,0,100);
         }
         else
         {
            g.lineStyle(1,color,100);
         }
         var tempY:Number = 0;
         if(headerVisible)
         {
            tempY = Number(headerRowInfo[0].height);
         }
         if(rendererProviders.length != 0)
         {
            for(i = 0; i < listItems.length; i++)
            {
               if(listItems[i].length != 0)
               {
                  item = listItems[i][colIndex] as IListItemRenderer;
                  tempY = rowInfo[i].y + rowInfo[i].height;
                  if(item.visible)
                  {
                     if(item.x + item.width <= x)
                     {
                        g.moveTo(x,rowInfo[i].y);
                        g.lineTo(x,tempY);
                     }
                  }
                  else
                  {
                     for(j = colIndex - 1; j >= 0; j--)
                     {
                        item = listItems[i][j] as IListItemRenderer;
                        if(item.visible)
                        {
                           if(item.x + item.width <= x)
                           {
                              g.moveTo(x,rowInfo[i].y);
                              g.lineTo(x,tempY);
                           }
                           break;
                        }
                     }
                  }
               }
            }
         }
         g.moveTo(x,tempY);
         g.lineTo(x,listContent.height);
      }
      
      override protected function removeIndicators(uid:String) : void
      {
         var columnIndexString:String = null;
         if(isCellSelectionMode())
         {
            for(columnIndexString in cellSelectionIndicators[uid])
            {
               removeCellIndicators(uid,int(columnIndexString));
            }
            for(columnIndexString in visibleCellRenderers[uid])
            {
               delete visibleCellRenderers[uid][columnIndexString];
            }
            delete visibleCellRenderers[uid];
         }
         super.removeIndicators(uid);
      }
      
      override protected function mouseOverHandler(event:MouseEvent) : void
      {
         var item:IListItemRenderer = null;
         var dropInItem:IDropInListItemRenderer = null;
         var colNum:int = 0;
         var headerPart:String = null;
         var sequenceNumber:int = 0;
         var descending:Boolean = false;
         var sortInfo:SortInfo = null;
         var evt:ListEvent = null;
         var pt:Point = null;
         var columnIndex:int = 0;
         var uid:String = null;
         if(Boolean(tween))
         {
            return;
         }
         if(Boolean(movingColumn))
         {
            return;
         }
         if(!enabled || !selectable)
         {
            return;
         }
         item = mouseEventToItemRenderer(event);
         if(!sortExpertMode)
         {
            if(Boolean(item))
            {
               dropInItem = item as IDropInListItemRenderer;
            }
            else
            {
               visualSortInfo = new Dictionary();
            }
            if(Boolean(dropInItem) && Boolean(dropInItem.listData))
            {
               colNum = int(dropInItem.listData.columnIndex);
            }
            if(Boolean(dropInItem && isHeaderItemRenderer(item) && sortableColumns) && Boolean(colNum != -1) && Boolean(columns[colNum].sortable) && Object(item).hasOwnProperty("mouseEventToHeaderPart"))
            {
               headerPart = Object(item).mouseEventToHeaderPart(event);
               if(!visualSortInfo[colNum] || visualSortInfo["HEADERPART" + colNum] != headerPart)
               {
                  if(headerPart == HEADER_TEXT_PART)
                  {
                     visualSortInfo[colNum] = new SortInfo(1,false,SortInfo.PROPOSEDSORT);
                     invalidateRenderer(item);
                     visualSortInfo["HEADERPART" + colNum] = headerPart;
                  }
                  else if(headerPart == HEADER_ICON_PART)
                  {
                     sortInfo = getFieldSortInfo(columns[colNum]);
                     if(Boolean(sortInfo))
                     {
                        sequenceNumber = sortInfo.sequenceNumber;
                        descending = sortInfo.descending;
                     }
                     else if(Boolean(collection && collection.sort) && Boolean(collection.sort.fields) && Boolean(collection.sort.fields.length))
                     {
                        sequenceNumber = collection.sort.fields.length + 1;
                        descending = false;
                     }
                     else
                     {
                        sequenceNumber = 1;
                        descending = false;
                     }
                     visualSortInfo[colNum] = new SortInfo(sequenceNumber,descending,SortInfo.PROPOSEDSORT);
                     invalidateRenderer(item);
                     visualSortInfo["HEADERPART" + colNum] = headerPart;
                  }
               }
            }
         }
         if(Boolean(item) && Boolean(!isHeaderItemRenderer(item)) && isCellSelectionMode())
         {
            pt = itemRendererToIndices(item);
            if(!pt)
            {
               return;
            }
            isPressed = event.buttonDown;
            columnIndex = displayToAbsoluteColumnIndex(pt.x);
            if(!isPressed || allowDragSelection)
            {
               if(Boolean(getStyle("useRollOver")) && item.data != null)
               {
                  if(allowDragSelection)
                  {
                     bSelectOnRelease = true;
                  }
                  uid = itemToUID(item.data);
                  if(Boolean(visibleCellRenderers[uid]))
                  {
                     drawCellItem(visibleCellRenderers[uid][columnIndex.toString()],Boolean(cellSelectionData[uid]) && Boolean(cellSelectionData[uid][columnIndex.toString()]),true,uid == caretUID && columnIndex == caretColumnIndex);
                  }
                  if(Boolean(pt))
                  {
                     evt = new ListEvent(ListEvent.ITEM_ROLL_OVER);
                     evt.columnIndex = pt.x;
                     evt.rowIndex = pt.y;
                     evt.itemRenderer = item;
                     dispatchEvent(evt);
                  }
               }
            }
            else
            {
               if(DragManager.isDragging)
               {
                  return;
               }
               if(allowDragSelection || menuSelectionMode)
               {
                  if(selectCellItem(item,event.shiftKey,event.ctrlKey))
                  {
                     evt = new ListEvent(ListEvent.CHANGE);
                     evt.itemRenderer = item;
                     if(Boolean(pt))
                     {
                        evt.columnIndex = pt.x;
                        evt.rowIndex = pt.y;
                     }
                     dispatchEvent(evt);
                  }
               }
            }
         }
         else
         {
            super.mouseOverHandler(event);
         }
      }
      
      protected function getHorizontalSeparator(i:int, seperators:Array, headerLines:UIComponent) : UIComponent
      {
         var sep:UIComponent = null;
         var sepSkin:IFlexDisplayObject = null;
         var headerSeparatorClass:Class = getStyle("headerHorizontalSeparatorSkin");
         if(i < headerLines.numChildren)
         {
            sep = UIComponent(headerLines.getChildAt(i));
            sepSkin = IFlexDisplayObject(sep.getChildAt(0));
         }
         else
         {
            sep = new UIComponent();
            headerLines.addChild(sep);
         }
         if(Boolean(sepSkin))
         {
            if(sepSkin is headerSeparatorClass)
            {
               sepSkin = IFlexDisplayObject(sep.getChildAt(0));
            }
            else
            {
               sep.removeChildAt(0);
               sepSkin = null;
            }
         }
         if(!sepSkin)
         {
            sepSkin = new headerSeparatorClass();
            if(sepSkin is ISimpleStyleClient)
            {
               ISimpleStyleClient(sepSkin).styleName = this;
            }
            sep.addChild(DisplayObject(sepSkin));
         }
         seperators.push(sep);
         return sep;
      }
      
      public function set displayItemsExpanded(value:Boolean) : void
      {
         if(value != _displayItemsExpanded)
         {
            _displayItemsExpanded = value;
            if(_displayItemsExpanded)
            {
               displayItemsExpandedChanged = true;
               invalidateProperties();
            }
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         if(Boolean(tween))
         {
            tween.endTween();
         }
         if(cellsWaitingToBeDisplayed)
         {
            processCellsWaitingToBeDisplayed();
         }
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(headerVisible && columnGrouping)
         {
            drawHeaderHorizontalSeparators();
         }
         else
         {
            clearHeaderHorizontalSeparators();
         }
         if(Boolean(collection))
         {
            collectionLength = collection.length;
         }
         if(columnGrouping && Boolean(selectedHeaderInfo))
         {
            selectColumnGroupHeader(selectedHeaderInfo);
         }
         else if(!columnGrouping && headerIndex != -1)
         {
            selectedHeaderInfo = getHeaderInfo(columns[headerIndex]);
            selectColumnHeader(headerIndex);
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
         if(isCellSelectionMode())
         {
            return;
         }
         if(!(_rootModel is IHierarchicalData) && Boolean(event.dragSource.hasFormat("items")))
         {
            super.dragCompleteHandler(event);
            return;
         }
         isPressed = false;
         if(event.isDefaultPrevented())
         {
            return;
         }
         if((!_rootModel || _rootModel is IHierarchicalData) && Boolean(event.dragSource.hasFormat("treeDataGridItems")))
         {
            if(event.action == DragManager.MOVE && dragMoveEnabled)
            {
               if(event.relatedObject != this)
               {
                  items = event.dragSource.dataForFormat("treeDataGridItems") as Array;
                  for(i = 0; i < items.length; i++)
                  {
                     parent = getParentItem(items[i]);
                     index = getChildIndexInParent(parent,items[i]);
                     removeChildItem(parent,items[i],index);
                  }
                  addItemsToTarget(event,items);
               }
               clearSelected(false);
            }
            else if(event.action == DragManager.COPY)
            {
               if(event.relatedObject != this)
               {
                  items = event.dragSource.dataForFormat("treeDataGridItems") as Array;
                  addItemsToTarget(event,items);
               }
               clearSelected(false);
            }
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function columnItemRendererFactory(c:AdvancedDataGridColumn, forHeader:Boolean, itemData:Object) : IFactory
      {
         var factory:IFactory = null;
         if(!forHeader)
         {
            if(_rootModel is IHierarchicalData && c.colNum == treeColumnIndex)
            {
               if(!isBranch(itemData) && Boolean(c.itemRenderer))
               {
                  factory = c.itemRenderer;
               }
               else if(Boolean(groupItemRenderer))
               {
                  factory = groupItemRenderer;
               }
            }
         }
         if(!factory)
         {
            factory = super.columnItemRendererFactory(c,forHeader,itemData);
         }
         return factory;
      }
   }
}

