package mx.controls
{
   import flash.display.DisplayObject;
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.collections.errors.ItemPendingError;
   import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
   import mx.controls.advancedDataGridClasses.AdvancedDataGridColumnGroup;
   import mx.controls.advancedDataGridClasses.AdvancedDataGridHeaderInfo;
   import mx.controls.advancedDataGridClasses.AdvancedDataGridListData;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.controls.olapDataGridClasses.OLAPDataGridGroupRenderer;
   import mx.controls.olapDataGridClasses.OLAPDataGridHeaderRenderer;
   import mx.controls.olapDataGridClasses.OLAPDataGridHeaderRendererProvider;
   import mx.controls.olapDataGridClasses.OLAPDataGridItemRendererProvider;
   import mx.controls.olapDataGridClasses.OLAPDataGridRendererProvider;
   import mx.core.ClassFactory;
   import mx.core.FlexShape;
   import mx.core.IDataRenderer;
   import mx.core.IFactory;
   import mx.core.IFlexDisplayObject;
   import mx.core.UIComponent;
   import mx.formatters.Formatter;
   import mx.olap.IOLAPAxisPosition;
   import mx.olap.IOLAPCell;
   import mx.olap.IOLAPHierarchy;
   import mx.olap.IOLAPLevel;
   import mx.olap.IOLAPMember;
   import mx.olap.IOLAPResult;
   import mx.styles.ISimpleStyleClient;
   import mx.styles.IStyleClient;
   import mx.styles.StyleManager;
   
   [Style(name="columnAxisHeaderStyleName",type="String",inherit="no")]
   [Style(name="rowAxisHeaderStyleName",type="String",inherit="no")]
   [Exclude(name="headerDragProxyStyleName",kind="style")]
   [Exclude(name="sortFontWeight",kind="style")]
   [Exclude(name="sortFontStyle",kind="style")]
   [Exclude(name="sortFontSize",kind="style")]
   [Exclude(name="sortFontFamily",kind="style")]
   [Exclude(name="openEasingFunction",kind="style")]
   [Exclude(name="openDuration",kind="style")]
   [Exclude(name="headerStyleName",kind="style")]
   [Exclude(name="headerSortSeparatorSkin",kind="style")]
   [Exclude(name="folderOpenIcon",kind="style")]
   [Exclude(name="folderClosedIcon",kind="style")]
   [Exclude(name="depthColors",kind="style")]
   [Exclude(name="defaultLeafIcon",kind="style")]
   [Exclude(name="columnDropIndicatorSkin",kind="style")]
   [Exclude(name="itemOpening",kind="event")]
   [Exclude(name="itemOpen",kind="event")]
   [Exclude(name="itemEditEnd",kind="event")]
   [Exclude(name="itemEditBeginning",kind="event")]
   [Exclude(name="itemEditBegin",kind="event")]
   [Exclude(name="itemClose",kind="event")]
   [Exclude(name="headerShift",kind="event")]
   [Exclude(name="headerRelease",kind="event")]
   [Exclude(name="headerDropOutside",kind="event")]
   [Exclude(name="headerDragOutside",kind="event")]
   [Exclude(name="dragOver",kind="event")]
   [Exclude(name="dragExit",kind="event")]
   [Exclude(name="dragEnter",kind="event")]
   [Exclude(name="dragDrop",kind="event")]
   [Exclude(name="dragComplete",kind="event")]
   [Exclude(name="updateVisibleHeaders",kind="method")]
   [Exclude(name="updateHeaderSearchList",kind="method")]
   [Exclude(name="treeNavigationHandler",kind="method")]
   [Exclude(name="removeSortField",kind="method")]
   [Exclude(name="placeSortArrow",kind="method")]
   [Exclude(name="headerReleaseHandler",kind="method")]
   [Exclude(name="findSortField",kind="method")]
   [Exclude(name="expandItemHandler",kind="method")]
   [Exclude(name="dragStartHandler",kind="method")]
   [Exclude(name="dragScroll",kind="method")]
   [Exclude(name="dragOverHandler",kind="method")]
   [Exclude(name="dragExitHandler",kind="method")]
   [Exclude(name="dragEnterHandler",kind="method")]
   [Exclude(name="dragDropHandler",kind="method")]
   [Exclude(name="dragCompleteHandler",kind="method")]
   [Exclude(name="addSortField",kind="method")]
   [Exclude(name="addDragData",kind="method")]
   [Exclude(name="stopDrag",kind="method")]
   [Exclude(name="startDrag",kind="method")]
   [Exclude(name="showDropFeedback",kind="method")]
   [Exclude(name="hideDropFeedback",kind="method")]
   [Exclude(name="getFieldSortInfo",kind="method")]
   [Exclude(name="setItemIcon",kind="method")]
   [Exclude(name="isItemOpen",kind="method")]
   [Exclude(name="getParentItem",kind="method")]
   [Exclude(name="expandItem",kind="method")]
   [Exclude(name="expandChildrenOf",kind="method")]
   [Exclude(name="expandAll",kind="method")]
   [Exclude(name="destroyItemEditor",kind="method")]
   [Exclude(name="createItemEditor",kind="method")]
   [Exclude(name="collapseAll",kind="method")]
   [Exclude(name="calculateDropIndex",kind="method")]
   [Exclude(name="selectedHeaderInfo",kind="property")]
   [Exclude(name="orderedHeadersList",kind="property")]
   [Exclude(name="lastDropIndex",kind="property")]
   [Exclude(name="headerInfoInitialized",kind="property")]
   [Exclude(name="dragImageOffsets",kind="property")]
   [Exclude(name="dragImage",kind="property")]
   [Exclude(name="_columns",kind="property")]
   [Exclude(name="sortItemRenderer",kind="property")]
   [Exclude(name="sortExpertMode",kind="property")]
   [Exclude(name="sortableColumns",kind="property")]
   [Exclude(name="showRoot",kind="property")]
   [Exclude(name="showHeaders",kind="property")]
   [Exclude(name="rendererProviders",kind="property")]
   [Exclude(name="openItems",kind="property")]
   [Exclude(name="lookAheadDuration",kind="property")]
   [Exclude(name="lockedColumnCount",kind="property")]
   [Exclude(name="labelFunction",kind="property")]
   [Exclude(name="itemIcons",kind="property")]
   [Exclude(name="itemEditorInstance",kind="property")]
   [Exclude(name="hierarchicalCollectionView",kind="property")]
   [Exclude(name="hasRoot",kind="property")]
   [Exclude(name="groupLabelFunction",kind="property")]
   [Exclude(name="groupIconFunction",kind="property")]
   [Exclude(name="groupedColumns",kind="property")]
   [Exclude(name="editedItemRenderer",kind="property")]
   [Exclude(name="editedItemPosition",kind="property")]
   [Exclude(name="editable",kind="property")]
   [Exclude(name="dropTarget",kind="property")]
   [Exclude(name="dropEnabled",kind="property")]
   [Exclude(name="dragMoveEnabled",kind="property")]
   [Exclude(name="draggableColumns",kind="property")]
   [Exclude(name="dragEnabled",kind="property")]
   [Exclude(name="displayItemsExpanded",kind="property")]
   [Exclude(name="displayDisclosureIcon",kind="property")]
   [Exclude(name="columnWidth",kind="property")]
   [Exclude(name="columns",kind="property")]
   [Exclude(name="allowDragSelection",kind="property")]
   public class OLAPDataGrid extends AdvancedDataGrid
   {
      
      public static const COLUMN_AXIS:int = 0;
      
      public static const ROW_AXIS:int = 1;
      
      public static const SLICER_AXIS:int = 2;
      
      public static const OLAP_MEMBER:int = 0;
      
      public static const OLAP_LEVEL:int = 1;
      
      public static const OLAP_HIERARCHY:int = 2;
      
      public static const OLAP_DIMENSION:int = 3;
      
      private var currentRowLabels:Array;
      
      private var isMeasuring:Boolean;
      
      private var columnNames:Dictionary;
      
      private var cachedMinRowIndents:Array;
      
      private var olapData:IOLAPResult;
      
      private var columnAxis:IList;
      
      private var rowAxis:IList;
      
      private var _itemRendererProvidersUnSorted:Array = [];
      
      private var _headerRendererProvidersUnSorted:Array = [];
      
      public var defaultCellString:String = "NaN";
      
      private var cellRenderersMap:Array;
      
      private var numHeaderCols:int = 0;
      
      private var itemRendererProvidersChanged:Boolean = false;
      
      private var headerRendererProvidersChanged:Boolean = false;
      
      private var _headerRendererProviders:Array = [];
      
      private var _itemRendererProviders:Array = [];
      
      private var headerRenderersMap:Array;
      
      private var slicerAxis:IList;
      
      private var olapElements:Array;
      
      private var rowHeadersMap:Dictionary;
      
      private var oldStyles:Dictionary;
      
      private var dataProviderChanged:Boolean = false;
      
      private var hierarchiesHeaderColumn:AdvancedDataGridColumnGroup;
      
      public function OLAPDataGrid()
      {
         super();
         groupItemRenderer = new ClassFactory(OLAPDataGridGroupRenderer);
         olapElements = [];
         olapElements.push(OLAPDataGrid.OLAP_MEMBER);
         olapElements.push(OLAPDataGrid.OLAP_LEVEL);
         olapElements.push(OLAPDataGrid.OLAP_HIERARCHY);
         olapElements.push(OLAPDataGrid.OLAP_DIMENSION);
         olapElements = olapElements.sort();
         draggableColumns = false;
         sortableColumns = false;
         sortExpertMode = true;
      }
      
      protected function drawRowHeaderHorizontalLine(s:Sprite, rowIndex:int, color:uint, y:Number) : void
      {
         var i:int = 0;
         var g:Graphics = s.graphics;
         g.lineStyle(0,color);
         var offset:Number = 0;
         var lastPixel:int = offset;
         if(Boolean(listItems[rowIndex + 1]) && !listItems[rowIndex + 1][0])
         {
            for(i = 0; i < numHeaderCols; i++)
            {
               g.moveTo(lastPixel,y);
               lastPixel += columns[i].width;
               g.lineTo(lastPixel,y);
            }
         }
         else
         {
            for(i = 0; i < numHeaderCols; i++)
            {
               g.moveTo(lastPixel,y);
               lastPixel += columns[i].width;
               if(Boolean(listItems[rowIndex + 1]) && Boolean(listItems[rowIndex + 1][i]) && Boolean(listItems[rowIndex + 1][i].visible))
               {
                  g.lineTo(lastPixel,y);
               }
            }
         }
      }
      
      override protected function createHeaders(left:Number, top:Number) : void
      {
         applyNewAxisStyles(OLAPDataGrid.ROW_AXIS);
         super.createHeaders(left,top);
         applyNewAxisStyles(OLAPDataGrid.COLUMN_AXIS);
      }
      
      override protected function makeListData(data:Object, uid:String, rowNum:int, columnNum:int, column:AdvancedDataGridColumn) : BaseListData
      {
         var adgListData:AdvancedDataGridListData = null;
         var m:IOLAPMember = null;
         var label:String = null;
         var absoluteRowNum:int = 0;
         var absoluteColNum:int = 0;
         var cell:IOLAPCell = null;
         var colPosn:IOLAPAxisPosition = null;
         var listData:AdvancedDataGridListData = null;
         if(!(data is AdvancedDataGridColumn))
         {
            if(Boolean(groupItemRenderer) && column.colNum < numHeaderCols)
            {
               m = IOLAPMember(data.members.getItemAt(column.colNum));
               label = Boolean(m) ? m.displayName : " ";
               adgListData = new AdvancedDataGridListData(label,column.dataField,columnNum,uid,this,rowNum);
               if(!isMeasuring)
               {
                  adgListData.indent = getIndent(IOLAPAxisPosition(data),m,columnNum);
               }
               return adgListData;
            }
            if(column.colNum >= numHeaderCols)
            {
               absoluteRowNum = rowNum;
               if(rowNum >= lockedRowCount)
               {
                  absoluteRowNum += Math.max(0,verticalScrollPosition);
               }
               absoluteColNum = column.colNum - numHeaderCols;
               cell = olapData.getCell(absoluteRowNum,absoluteColNum);
               label = Boolean(cell) && !isNaN(cell.value) ? String(cell.value) : defaultCellString;
               colPosn = IOLAPAxisPosition(columnAxis.getItemAt(absoluteColNum));
               if(data is IOLAPAxisPosition)
               {
                  label = getFormattedCellValue(label,IOLAPAxisPosition(data),colPosn);
               }
               else
               {
                  label = getFormattedCellValue(label,null,colPosn);
               }
               return new AdvancedDataGridListData(label,column.dataField,columnNum,uid,this,rowNum);
            }
         }
         return super.makeListData(data,uid,rowNum,columnNum,column) as AdvancedDataGridListData;
      }
      
      private function generateCols() : AdvancedDataGridColumnGroup
      {
         columnNames = new Dictionary();
         var root:AdvancedDataGridColumnGroup = new AdvancedDataGridColumnGroup();
         root.children = generateGroup(0);
         hierarchiesHeaderColumn = root;
         root.headerRenderer = new ClassFactory(OLAPDataGridHeaderRenderer);
         return root;
      }
      
      protected function getCellRendererInfo(row:IOLAPAxisPosition, column:IOLAPAxisPosition) : OLAPDataGridItemRendererProvider
      {
         var itemInfo:OLAPDataGridItemRendererProvider = null;
         var member:IOLAPMember = null;
         var m:int = numHeaderCols - 1;
         while(m >= 0)
         {
            member = IOLAPMember(row.members.getItemAt(m));
            itemInfo = OLAPDataGridItemRendererProvider(getRendererInfo(member,false));
            if(Boolean(itemInfo))
            {
               return itemInfo;
            }
            m--;
         }
         m = 0;
         while(m < column.members.length)
         {
            member = IOLAPMember(column.members.getItemAt(m));
            itemInfo = OLAPDataGridItemRendererProvider(getRendererInfo(member,false));
            if(Boolean(itemInfo))
            {
               return itemInfo;
            }
            m++;
         }
         return null;
      }
      
      private function generateGroup(start:int, end:int = -1) : Array
      {
         var currentData:IList = null;
         var k:int = 0;
         var parent:AdvancedDataGridColumnGroup = null;
         var c:AdvancedDataGridColumn = null;
         if(end == -1 || end > columnAxis.length)
         {
            end = int(columnAxis.length);
         }
         if(end < start)
         {
            return [];
         }
         var root:AdvancedDataGridColumnGroup = new AdvancedDataGridColumnGroup();
         var currentGroupObjects:Array = [];
         var currentGroups:Array = [];
         for(var i:int = start; i < end; i++)
         {
            currentData = IOLAPAxisPosition(columnAxis.getItemAt(i)).members;
            k = 0;
            while(k < currentData.length && currentData[k] == currentGroupObjects[k])
            {
               k++;
            }
            if(k > 0 && k == currentData.length)
            {
               k--;
            }
            currentGroupObjects.splice(k);
            currentGroups.splice(k);
            while(k < currentData.length)
            {
               parent = k > 0 ? currentGroups[k - 1] : root;
               if(k == currentData.length - 1)
               {
                  c = new AdvancedDataGridColumn(currentData.getItemAt(k).displayName);
               }
               else
               {
                  c = new AdvancedDataGridColumnGroup(currentData.getItemAt(k).displayName);
                  AdvancedDataGridColumnGroup(c).children = [];
               }
               columnNames[c] = currentData.getItemAt(k);
               currentGroups.push(c);
               currentGroupObjects.push(currentData[k]);
               parent.children.push(c);
               k++;
            }
         }
         return root.children;
      }
      
      private function applyFormatting(data:String, formatter:Formatter) : String
      {
         var label:String = null;
         if(formatter != null && data != null)
         {
            label = formatter.format(data);
            if(Boolean(formatter.error))
            {
               return null;
            }
            return label;
         }
         return data;
      }
      
      private function getRendererInfo(m:IOLAPMember, forHeader:Boolean) : OLAPDataGridRendererProvider
      {
         var map:Array = null;
         var prop:String = null;
         if(forHeader)
         {
            map = headerRenderersMap;
         }
         else
         {
            map = cellRenderersMap;
         }
         if(!map)
         {
            return null;
         }
         var index:int = -1;
         for(var i:int = 0; i < olapElements.length; i++)
         {
            if(olapElements[i] == OLAPDataGrid.OLAP_MEMBER)
            {
               prop = m.uniqueName;
            }
            else if(olapElements[i] == OLAPDataGrid.OLAP_LEVEL)
            {
               prop = m.level.uniqueName;
            }
            else if(olapElements[i] == OLAPDataGrid.OLAP_HIERARCHY)
            {
               prop = m.hierarchy.uniqueName;
            }
            else if(olapElements[i] == OLAPDataGrid.OLAP_DIMENSION)
            {
               prop = m.dimension.uniqueName;
            }
            if(map[olapElements[i]][prop] != null)
            {
               index = int(map[olapElements[i]][prop]);
               if(forHeader)
               {
                  return headerRendererProviders[index];
               }
               return itemRendererProviders[index];
            }
         }
         return null;
      }
      
      public function set itemRendererProviders(value:Array) : void
      {
         var i:int = 0;
         _itemRendererProviders = value.sort(compareFunction);
         cellRenderersMap = [];
         for(i = 0; i < olapElements.length; i++)
         {
            cellRenderersMap[olapElements[i]] = new Dictionary(true);
         }
         for(i = 0; i < _itemRendererProviders.length; i++)
         {
            if(Boolean(value[i].renderer))
            {
               itemsSizeChanged = true;
               rendererChanged = true;
            }
            cellRenderersMap[value[i].type][value[i].uniqueName] = i;
         }
         _itemRendererProvidersUnSorted = value;
         itemRendererProvidersChanged = true;
         invalidateDisplayList();
      }
      
      public function get headerRendererProviders() : Array
      {
         return _headerRendererProvidersUnSorted;
      }
      
      override protected function drawHorizontalLine(s:Sprite, rowIndex:int, color:uint, y:Number) : void
      {
         var g:Graphics = s.graphics;
         var offset:Number = 0;
         for(var i:int = 0; i < numHeaderCols; i++)
         {
            offset += columns[i].width;
         }
         if(lockedRowCount > 0 && rowIndex == lockedRowCount - 1)
         {
            g.lineStyle(1,0);
         }
         else
         {
            g.lineStyle(1,color);
         }
         g.moveTo(offset,y);
         g.lineTo(unscaledWidth - viewMetrics.left - viewMetrics.right,y);
      }
      
      override protected function drawHighlightIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer) : void
      {
         var offset:Number = NaN;
         var g:Graphics = null;
         if(isRowSelectionMode())
         {
            offset = getRowHeadersWidth();
            width = unscaledWidth - viewMetrics.left - viewMetrics.right - offset;
            g = Sprite(indicator).graphics;
            g.clear();
            g.beginFill(color);
            g.drawRect(0,0,width,height);
            g.endFill();
            indicator.x = offset;
            indicator.y = y;
         }
         else
         {
            super.drawHighlightIndicator(indicator,x,y,width,height,color,itemRenderer);
         }
      }
      
      override public function set draggableColumns(value:Boolean) : void
      {
         super.draggableColumns = false;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function rowHeaderWordWrap(m:IOLAPMember) : Boolean
      {
         var info:OLAPDataGridHeaderRendererProvider = OLAPDataGridHeaderRendererProvider(getRendererInfo(m,true));
         return Boolean(info) && Boolean(info.headerWordWrap);
      }
      
      public function set headerRendererProviders(value:Array) : void
      {
         var i:int = 0;
         _headerRendererProviders = value.sort(compareFunction);
         headerRenderersMap = [];
         for(i = 0; i < olapElements.length; i++)
         {
            headerRenderersMap[olapElements[i]] = new Dictionary(true);
         }
         for(i = 0; i < _headerRendererProviders.length; i++)
         {
            if(Boolean(value[i].renderer))
            {
               itemsSizeChanged = true;
               rendererChanged = true;
            }
            headerRenderersMap[value[i].type][value[i].uniqueName] = i;
         }
         _headerRendererProvidersUnSorted = value;
         headerRendererProvidersChanged = true;
         invalidateDisplayList();
      }
      
      override protected function drawCaretIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer) : void
      {
         var offset:Number = NaN;
         var g:Graphics = null;
         if(isRowSelectionMode())
         {
            offset = getRowHeadersWidth();
            width = unscaledWidth - viewMetrics.left - viewMetrics.right - offset;
            g = Sprite(indicator).graphics;
            g.clear();
            g.lineStyle(1,color,1);
            g.drawRect(0,0,width - 1,height - 1);
            indicator.x = offset;
            indicator.y = y;
         }
         else
         {
            super.drawCaretIndicator(indicator,x,y,width,height,color,itemRenderer);
         }
      }
      
      protected function getIndent(position:IOLAPAxisPosition, m:IOLAPMember, mIndex:int) : int
      {
         var currentLevel:int = 0;
         var last:Array = null;
         var l:IOLAPLevel = null;
         var lastLevel:int = 0;
         var indent:int = 0;
         var uid:String = itemToUID(position);
         if(Boolean(rowHeadersMap[uid]) && Boolean(rowHeadersMap[uid][mIndex]))
         {
            indent = int(rowHeadersMap[uid][mIndex].indent);
         }
         else
         {
            if(currentRowNum > 0)
            {
               last = listItems[currentRowNum - 1];
               if(mIndex < last.length)
               {
                  l = last[mIndex].data.members.getItemAt(mIndex).level;
                  lastLevel = Boolean(l) ? l.depth : 0;
                  currentLevel = Boolean(m.level) ? m.level.depth : 0;
                  if(currentLevel == lastLevel)
                  {
                     indent = int(last[mIndex].listData.indent);
                  }
                  else if(currentLevel > lastLevel)
                  {
                     indent = last[mIndex].listData.indent + (currentLevel - lastLevel) * getStyle("indentation");
                  }
                  else if(lastLevel > currentLevel)
                  {
                     indent = last[mIndex].listData.indent + (currentLevel - lastLevel) * getStyle("indentation");
                     indent = indent >= 0 ? indent : int(last[mIndex].listData.indent);
                  }
               }
            }
            else
            {
               currentLevel = Boolean(m.level) ? m.level.depth : 0;
               if(Boolean(cachedMinRowIndents) && mIndex < cachedMinRowIndents.length)
               {
                  indent = Math.max(0,(currentLevel - cachedMinRowIndents[mIndex]) * getStyle("indentation"));
               }
            }
            if(!rowHeadersMap[uid])
            {
               rowHeadersMap[uid] = [];
            }
            if(!rowHeadersMap[uid][mIndex])
            {
               rowHeadersMap[uid][mIndex] = new OLAPRowHeaderInfo();
            }
            rowHeadersMap[uid][mIndex].indent = indent;
         }
         return indent;
      }
      
      protected function drawRowHeaderBackground(headerBG:UIComponent) : void
      {
         var tot:Number = unscaledHeight - viewMetrics.top - viewMetrics.bottom;
         var hh:Number = 0;
         if(headerVisible)
         {
            hh = Boolean(headerRowInfo.length) ? Number(headerRowInfo[0].height) : headerHeight;
            tot -= hh;
         }
         var g:Graphics = headerBG.graphics;
         g.clear();
         var colors:Array = getStyle("headerColors");
         StyleManager.getColorNames(colors);
         colors = [colors[0],colors[0],colors[1]];
         var ratios:Array = [0,60,255];
         var alphas:Array = [1,1,1];
         var ww:Number = 0;
         for(var i:int = 0; i < numHeaderCols; i++)
         {
            ww += columns[i].width;
         }
         var matrix:Matrix = new Matrix();
         matrix.createGradientBox(ww,tot + 1,0,0,0);
         g.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,matrix);
         g.lineStyle(0,0,0);
         g.moveTo(0,hh - 0.5);
         g.lineTo(0,tot + hh);
         g.lineTo(ww - 0.5,tot + hh);
         g.lineStyle(0,getStyle("borderColor"),100);
         g.lineTo(ww - 0.5,hh - 0.5);
         g.endFill();
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getRenderer(c:AdvancedDataGridColumn, itemData:Object, forDragProxy:Boolean = false) : IListItemRenderer
      {
         var r:IListItemRenderer = null;
         var member:IOLAPMember = null;
         var info:OLAPDataGridHeaderRendererProvider = null;
         var column:IOLAPAxisPosition = null;
         var row:IOLAPAxisPosition = null;
         var itemInfo:OLAPDataGridItemRendererProvider = null;
         if(c.colNum < numHeaderCols)
         {
            member = IOLAPMember(itemData.members.getItemAt(c.colNum));
            info = OLAPDataGridHeaderRendererProvider(getRendererInfo(member,true));
            if(Boolean(info))
            {
               if(Boolean(info.renderer))
               {
                  r = info.renderer.newInstance();
               }
               else
               {
                  r = super.getRenderer(c,itemData);
               }
               if(Boolean(info.styleName))
               {
                  r.styleName = info.styleName;
               }
               return r;
            }
         }
         else
         {
            column = IOLAPAxisPosition(columnAxis.getItemAt(c.colNum - numHeaderCols));
            row = itemData is IOLAPAxisPosition ? IOLAPAxisPosition(itemData) : null;
            itemInfo = getCellRendererInfo(row,column);
            if(Boolean(itemInfo))
            {
               if(Boolean(itemInfo.renderer))
               {
                  r = itemInfo.renderer.newInstance();
               }
               else
               {
                  r = super.getRenderer(c,itemData);
               }
               if(Boolean(itemInfo.styleName))
               {
                  r.styleName = itemInfo.styleName;
               }
               return r;
            }
         }
         r = super.getRenderer(c,itemData,forDragProxy);
         r.styleName = c;
         return r;
      }
      
      override protected function viewDisplayableColumnAtOffset(columnIndex:int, offset:int, rowIndex:int = -1, scroll:Boolean = true) : int
      {
         var displayColumnIndex:int = absoluteToDisplayColumnIndex(columnIndex);
         if(displayColumnIndex == numHeaderCols && offset < 0)
         {
            return -1;
         }
         return super.viewDisplayableColumnAtOffset(columnIndex,offset,rowIndex,scroll);
      }
      
      override public function get dataProvider() : Object
      {
         return olapData;
      }
      
      private function getRowHeadersWidth() : Number
      {
         var offset:Number = 0;
         for(var i:int = 0; i < numHeaderCols; i++)
         {
            offset += columns[i].width;
         }
         return offset;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         if(styleProp == "rowAxisHeaderStyleName")
         {
            applyNewAxisStyles(OLAPDataGrid.ROW_AXIS);
         }
         else if(styleProp == "columnAxisHeaderStyleName")
         {
            applyNewAxisStyles(OLAPDataGrid.COLUMN_AXIS);
         }
         super.styleChanged(styleProp);
      }
      
      override protected function drawRowBackground(s:Sprite, rowIndex:int, y:Number, height:Number, color:uint, dataIndex:int) : void
      {
         var background:Shape = null;
         if(rowIndex < s.numChildren)
         {
            background = Shape(s.getChildAt(rowIndex));
         }
         else
         {
            background = new FlexShape();
            background.name = "background";
            s.addChild(background);
         }
         background.y = y;
         background.x = getRowHeadersWidth();
         height = Math.min(height,listContent.height - y);
         var g:Graphics = background.graphics;
         g.clear();
         g.beginFill(color,getStyle("backgroundAlpha"));
         g.drawRect(0,0,unscaledWidth - viewMetrics.left - viewMetrics.right,height);
         g.endFill();
      }
      
      override protected function drawSelectionIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer) : void
      {
         var offset:Number = NaN;
         var g:Graphics = null;
         if(isRowSelectionMode())
         {
            offset = getRowHeadersWidth();
            width = unscaledWidth - viewMetrics.left - viewMetrics.right - offset;
            g = Sprite(indicator).graphics;
            g.clear();
            g.beginFill(color);
            g.drawRect(0,0,width,height);
            g.endFill();
            indicator.x = offset;
            indicator.y = y;
         }
         else
         {
            super.drawSelectionIndicator(indicator,x,y,width,height,color,itemRenderer);
         }
      }
      
      override protected function commitProperties() : void
      {
         var hasRowAxis:Boolean = false;
         var hasColumnAxis:Boolean = false;
         var rowAxisHeaderCols:Array = null;
         var colAxisHeaderCols:Array = null;
         var firstRow:IList = null;
         var i:int = 0;
         var hierarchy:IOLAPHierarchy = null;
         var c:AdvancedDataGridColumn = null;
         var dummyRow:Object = null;
         if(dataProviderChanged)
         {
            dataProviderChanged = false;
            hasRowAxis = false;
            hasColumnAxis = false;
            if(Boolean(olapData))
            {
               rowAxis = olapData.getAxis(OLAPDataGrid.ROW_AXIS).positions;
               columnAxis = olapData.getAxis(OLAPDataGrid.COLUMN_AXIS).positions;
               if(Boolean(olapData.getAxis(OLAPDataGrid.SLICER_AXIS)))
               {
                  slicerAxis = olapData.getAxis(OLAPDataGrid.SLICER_AXIS).positions;
               }
               hasRowAxis = Boolean(rowAxis) && Boolean(rowAxis.length);
               hasColumnAxis = Boolean(columnAxis) && Boolean(columnAxis.length);
            }
            if(!hasColumnAxis)
            {
               numHeaderCols = 0;
               groupedColumns = [];
               lockedColumnCount = 0;
               super.dataProvider = null;
            }
            else
            {
               rowAxisHeaderCols = [];
               if(hasRowAxis)
               {
                  firstRow = IOLAPAxisPosition(rowAxis.getItemAt(0)).members;
                  numHeaderCols = firstRow.length;
                  cachedMinRowIndents = [];
                  for(i = 0; i < firstRow.length; i++)
                  {
                     hierarchy = firstRow.getItemAt(i).hierarchy;
                     c = new AdvancedDataGridColumn(hierarchy.displayName);
                     c.setStyle("fontWeight","bold");
                     c.setStyle("verticalAlign","center");
                     rowAxisHeaderCols.push(c);
                     cachedMinRowIndents.push(firstRow.getItemAt(i).level.depth);
                  }
                  lockedColumnCount = numHeaderCols;
               }
               else
               {
                  dummyRow = {};
                  numHeaderCols = 0;
                  lockedColumnCount = 0;
                  dummyRow.members = new ArrayCollection([]);
                  rowAxis = new ArrayCollection([dummyRow]);
               }
               colAxisHeaderCols = [generateCols()];
               groupedColumns = rowAxisHeaderCols.concat(colAxisHeaderCols);
               currentRowLabels = [];
               rowHeadersMap = new Dictionary(true);
               if(Boolean(headerRendererProviders) && Boolean(headerRendererProviders.length > 0) || Boolean(itemRendererProviders) && Boolean(itemRendererProviders.length > 0))
               {
                  headerRendererProvidersChanged = true;
                  itemRendererProvidersChanged = true;
                  invalidateDisplayList();
               }
               super.dataProvider = rowAxis;
            }
         }
         super.commitProperties();
      }
      
      override protected function applyUserStylesForItemRenderer(givenItemRenderer:IListItemRenderer) : void
      {
         var rowPosn:IOLAPAxisPosition = null;
         var styleName:String = null;
         var newStyles:Object = null;
         if(!givenItemRenderer)
         {
            return;
         }
         if(!(givenItemRenderer is IStyleClient && givenItemRenderer is IDataRenderer && givenItemRenderer is DisplayObject && givenItemRenderer is IDropInListItemRenderer))
         {
            return;
         }
         var listData:BaseListData = IDropInListItemRenderer(givenItemRenderer).listData;
         if(listData.columnIndex < numHeaderCols)
         {
            return;
         }
         var itemRenderer:IStyleClient = givenItemRenderer as IStyleClient;
         var label:String = listData.label;
         var cellValue:Number = Number(label);
         var absoluteRowNum:int = int(listData.rowIndex);
         if(absoluteRowNum >= lockedRowCount)
         {
            absoluteRowNum += Math.max(0,verticalScrollPosition) + Math.max(0,lockedRowCount);
         }
         if(absoluteRowNum < rowAxis.length && rowAxis.getItemAt(absoluteRowNum) is IOLAPAxisPosition)
         {
            rowPosn = IOLAPAxisPosition(rowAxis.getItemAt(absoluteRowNum));
         }
         else
         {
            rowPosn = null;
         }
         var absoluteColNum:int = listData.columnIndex - numHeaderCols;
         var colPosn:IOLAPAxisPosition = IOLAPAxisPosition(columnAxis.getItemAt(absoluteColNum));
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
            newStyles = styleFunction(rowPosn,colPosn,cellValue);
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
      }
      
      public function get itemRendererProviders() : Array
      {
         return _itemRendererProvidersUnSorted;
      }
      
      protected function getFormattedCellValue(label:String, row:IOLAPAxisPosition, col:IOLAPAxisPosition) : String
      {
         var itemInfo:OLAPDataGridItemRendererProvider = getCellRendererInfo(row,col);
         if(Boolean(itemInfo) && Boolean(itemInfo.formatter))
         {
            return applyFormatting(label,itemInfo.formatter);
         }
         return label;
      }
      
      private function applyRenderer() : void
      {
         var i:int = 0;
         var c:AdvancedDataGridColumn = null;
         var info:OLAPDataGridHeaderRendererProvider = null;
         var n:int = Boolean(orderedHeadersList) ? int(orderedHeadersList.length) : 0;
         for(i = numHeaderCols + 1; i < n; i++)
         {
            c = orderedHeadersList[i].column;
            if(headerRendererProvidersChanged)
            {
               info = OLAPDataGridHeaderRendererProvider(getRendererInfo(IOLAPMember(columnNames[c]),true));
               if(Boolean(info))
               {
                  if(Boolean(info.renderer))
                  {
                     c.headerRenderer = info.renderer;
                  }
                  if(Boolean(info.headerWordWrap))
                  {
                     c.headerWordWrap = info.headerWordWrap;
                  }
                  if(Boolean(info.styleName))
                  {
                     c.setStyle("headerStyleName",info.styleName);
                  }
               }
            }
         }
      }
      
      override public function set styleFunction(value:Function) : void
      {
         super.styleFunction = value;
      }
      
      override public function set sortExpertMode(value:Boolean) : void
      {
         super.sortExpertMode = true;
      }
      
      private function drawRowHeaderHorizontalSeparators() : void
      {
         var lines:Sprite = Sprite(listContent.getChildByName("lockedContent"));
         if(!lines)
         {
            lines = new UIComponent();
            lines.name = "lockedContent";
            lines.cacheAsBitmap = true;
            lines.mouseEnabled = false;
            listSubContent.addChild(lines);
            listSubContent.setChildIndex(lines,listContent.numChildren - 1);
         }
         var linesBody:Sprite = Sprite(lines.getChildByName("horizontalRowHeaderLines"));
         if(!linesBody)
         {
            linesBody = new UIComponent();
            linesBody.name = "horizontalRowHeaderLines";
            lines.addChild(linesBody);
         }
         linesBody.graphics.clear();
         var lineCol:uint = uint(getStyle("horizontalGridLineColor"));
         for(var i:int = 0; i < listItems.length; i++)
         {
            drawRowHeaderHorizontalLine(linesBody,i,lineCol,rowInfo[i].y + rowInfo[i].height);
         }
      }
      
      override public function set verticalScrollPosition(value:Number) : void
      {
         super.verticalScrollPosition = value;
         if(Boolean(getStyle("horizontalGridLines")))
         {
            drawRowHeaderHorizontalSeparators();
         }
      }
      
      private function compareFunction(a:OLAPDataGridRendererProvider, b:OLAPDataGridRendererProvider) : int
      {
         if(a.type > b.type)
         {
            return -1;
         }
         if(a.type < b.type)
         {
            return 1;
         }
         return 0;
      }
      
      private function applyNewAxisStyles(axisNum:int) : void
      {
         var styleVal:* = undefined;
         var r:IStyleClient = null;
         var styleVal2:* = undefined;
         var i:int = 0;
         var styleValue:* = undefined;
         if(axisNum == OLAPDataGrid.COLUMN_AXIS)
         {
            styleVal = getStyle("columnAxisHeaderStyleName");
            if(Boolean(styleVal))
            {
               r = orderedHeadersList[numHeaderCols].headerItem as IStyleClient;
               if(Boolean(r))
               {
                  styleVal2 = r.getStyle("axisHeaderStyleName");
                  if(styleVal2 != styleVal)
                  {
                     r.setStyle("axisHeaderStyleName",styleVal);
                  }
               }
            }
         }
         else if(axisNum == OLAPDataGrid.ROW_AXIS)
         {
            if(Boolean(getStyle("rowAxisHeaderStyleName")))
            {
               styleValue = getStyle("rowAxisHeaderStyleName");
               for(i = 0; i < numHeaderCols; i++)
               {
                  orderedHeadersList[i].column.setStyle("headerStyleName",styleValue);
               }
            }
         }
      }
      
      override protected function itemRendererToIndices(item:IListItemRenderer) : Point
      {
         var pt:Point = null;
         var columnIndex:int = 0;
         if(Boolean(item) && Boolean(!isHeaderItemRenderer(item)) && isCellSelectionMode())
         {
            pt = super.itemRendererToIndices(item);
            columnIndex = displayToAbsoluteColumnIndex(pt.x);
            if(columnIndex < numHeaderCols)
            {
               return null;
            }
         }
         return super.itemRendererToIndices(item);
      }
      
      override protected function getHeaderRenderer(c:AdvancedDataGridColumn) : IListItemRenderer
      {
         var firstColumn:IList = null;
         var numHeaderRows:int = 0;
         var factories:Array = null;
         var hierarchies:Array = null;
         var i:int = 0;
         var r:IListItemRenderer = super.getHeaderRenderer(c);
         if(c == hierarchiesHeaderColumn && columnAxis.length > 0)
         {
            firstColumn = IOLAPAxisPosition(columnAxis.getItemAt(0)).members;
            numHeaderRows = int(firstColumn.length);
            factories = [];
            hierarchies = [];
            for(i = 0; i < numHeaderRows; i++)
            {
               hierarchies.push(firstColumn.getItemAt(i).hierarchy);
               factories.push(headerRenderer);
            }
            OLAPDataGridHeaderRenderer(r).factories = factories;
            OLAPDataGridHeaderRenderer(r).dataProvider = hierarchies;
         }
         return r;
      }
      
      override protected function setupRenderer(itemData:Object, uid:String, insertItems:Boolean = false) : void
      {
         var i:int = 0;
         super.setupRenderer(itemData,uid,insertItems);
         var currentData:IList = itemData.members;
         if(!rowHeadersMap[uid])
         {
            rowHeadersMap[uid] = [];
         }
         if(!rowHeadersMap[uid][0] || !rowHeadersMap[uid][0].initialized)
         {
            while(i < currentRowLabels.length && currentData.getItemAt(i).name == currentRowLabels[i].member.name)
            {
               if(!rowHeadersMap[uid][i])
               {
                  rowHeadersMap[uid][i] = new OLAPRowHeaderInfo();
               }
               rowHeadersMap[uid][i].visible = false;
               rowHeadersMap[uid][i].renderer = currentRowLabels[i].renderer;
               rowHeadersMap[uid][i].initialized = true;
               listItems[currentRowNum][i].visible = false;
               i++;
            }
            currentRowLabels.splice(i);
            while(i < currentData.length)
            {
               if(!rowHeadersMap[uid][i])
               {
                  rowHeadersMap[uid][i] = new OLAPRowHeaderInfo();
               }
               rowHeadersMap[uid][i].visible = true;
               rowHeadersMap[uid][i].renderer = listItems[currentRowNum][i];
               rowHeadersMap[uid][i].initialized = true;
               listItems[currentRowNum][i].visible = true;
               currentRowLabels.push({
                  "member":currentData.getItemAt(i),
                  "renderer":listItems[currentRowNum][i]
               });
               i++;
            }
         }
         else
         {
            for(i = 0; i < currentData.length; i++)
            {
               listItems[currentRowNum][i].visible = rowHeadersMap[uid][i].visible;
            }
         }
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         if(!(headerVisible && selectedIndex == 0 && caretIndex == 0 && event.keyCode == Keyboard.UP && !event.ctrlKey && !event.shiftKey || event.keyCode == Keyboard.UP && caretIndex == 0 && selectedIndex == -1))
         {
            super.keyDownHandler(event);
         }
      }
      
      private function seekColumn(seekPosition:int) : Object
      {
         var value:Object = null;
         try
         {
            value = columnAxis.getItemAt(seekPosition);
         }
         catch(e:ItemPendingError)
         {
         }
         return value;
      }
      
      override protected function mouseOverHandler(event:MouseEvent) : void
      {
         var hh:Number = Boolean(headerRowInfo.length) ? Number(headerRowInfo[0].height) : headerHeight;
         var pt:Point = new Point(event.stageX,event.stageY);
         pt = listContent.globalToLocal(pt);
         if(pt.y < hh)
         {
            return;
         }
         super.mouseOverHandler(event);
      }
      
      override protected function drawLinesAndColumnBackgrounds() : void
      {
         super.drawLinesAndColumnBackgrounds();
         if(Boolean(getStyle("horizontalGridLines")))
         {
            drawRowHeaderHorizontalSeparators();
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setupRendererFromData(c:AdvancedDataGridColumn, item:IListItemRenderer, data:Object) : void
      {
         isMeasuring = true;
         super.setupRendererFromData(c,item,data);
         isMeasuring = false;
      }
      
      override protected function drawVerticalLine(s:Sprite, colIndex:int, color:uint, x:Number) : void
      {
         var g:Graphics = s.graphics;
         if(lockedColumnCount > 0 && colIndex == lockedColumnCount - 1)
         {
            g.lineStyle(1,color,100);
         }
         else
         {
            super.drawVerticalLine(s,colIndex,color,x);
         }
      }
      
      override public function set dataProvider(value:Object) : void
      {
         if(!value || value != null && value is IOLAPResult)
         {
            olapData = IOLAPResult(value);
            dataProviderChanged = true;
            invalidateProperties();
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var headerBGSkinClass:Class = null;
         var headerBGSkin:IFlexDisplayObject = null;
         if(headerRendererProvidersChanged || itemRendererProvidersChanged)
         {
            applyRenderer();
            headerRendererProvidersChanged = false;
            itemRendererProvidersChanged = false;
         }
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var headerBG:UIComponent = UIComponent(listContent.getChildByName("rowHeaderBG"));
         if(!headerBG)
         {
            headerBG = new UIComponent();
            headerBG.name = "rowHeaderBG";
            listContent.addChildAt(DisplayObject(headerBG),listContent.getChildIndex(selectionLayer));
            headerBGSkinClass = getStyle("headerBackgroundSkin");
            headerBGSkin = new headerBGSkinClass();
            if(headerBGSkin is ISimpleStyleClient)
            {
               ISimpleStyleClient(headerBGSkin).styleName = this;
            }
            headerBG.addChild(DisplayObject(headerBGSkin));
         }
         headerBG.visible = true;
         drawRowHeaderBackground(headerBG);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function columnToAxisPosition(c:AdvancedDataGridColumn) : Object
      {
         var headerInfo:AdvancedDataGridHeaderInfo = getHeaderInfo(c);
         var position:IOLAPAxisPosition = IOLAPAxisPosition(seekColumn(headerInfo.actualColNum - numHeaderCols));
         var m:IOLAPMember = position.members[headerInfo.depth];
         return {
            "member":m,
            "position":position,
            "positionIndex":headerInfo.actualColNum,
            "memberIndex":headerInfo.depth
         };
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function columnItemRendererFactory(c:AdvancedDataGridColumn, forHeader:Boolean, itemData:Object) : IFactory
      {
         var factory:IFactory = null;
         var headerInfo:AdvancedDataGridHeaderInfo = null;
         if(!forHeader && c.colNum < numHeaderCols)
         {
            if(Boolean(c.itemRenderer))
            {
               factory = c.itemRenderer;
            }
            else
            {
               factory = groupItemRenderer;
            }
         }
         else if(forHeader)
         {
            if(Boolean(c.headerRenderer))
            {
               factory = c.headerRenderer;
            }
            else
            {
               headerInfo = getHeaderInfo(c);
               if(Boolean(headerInfo) && headerInfo.actualColNum >= numHeaderCols)
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

import mx.controls.listClasses.IListItemRenderer;

class OLAPRowHeaderInfo
{
   
   public var visible:Boolean;
   
   public var renderer:IListItemRenderer;
   
   public var initialized:Boolean;
   
   public var indent:int;
   
   public function OLAPRowHeaderInfo()
   {
      super();
   }
}
