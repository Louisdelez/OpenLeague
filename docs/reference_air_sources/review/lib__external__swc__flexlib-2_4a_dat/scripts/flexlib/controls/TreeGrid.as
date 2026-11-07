package flexlib.controls
{
   import flash.events.Event;
   import flash.xml.XMLNode;
   import flexlib.controls.treeGridClasses.TreeGridListData;
   import mx.collections.ArrayCollection;
   import mx.collections.ICollectionView;
   import mx.collections.IViewCursor;
   import mx.collections.ListCollectionView;
   import mx.collections.XMLListCollection;
   import mx.controls.DataGrid;
   import mx.controls.dataGridClasses.DataGridColumn;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.controls.treeClasses.DefaultDataDescriptor;
   import mx.controls.treeClasses.ITreeDataDescriptor;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   
   [Style(name="verticalTrunks",type="String",enumeration="none,normal,dotted",inherit="no")]
   [Style(name="indentation",type="Number",inherit="no")]
   [Style(name="defaultLeafIcon",type="Class",format="EmbeddedFile",inherit="no")]
   [Style(name="folderClosedIcon",type="Class",format="EmbeddedFile",inherit="no")]
   [Style(name="folderOpenIcon",type="Class",format="EmbeddedFile",inherit="no")]
   [Style(name="disclosureClosedIcon",type="Class",format="EmbeddedFile",inherit="no")]
   [Style(name="disclosureOpenIcon",type="Class",format="EmbeddedFile",inherit="no")]
   public class TreeGrid extends DataGrid
   {
      
      private var _dataDescriptor:ITreeDataDescriptor = new DefaultDataDescriptor();
      
      private var _displayedModel:ArrayCollection = new ArrayCollection();
      
      private var _hasRoot:Boolean = false;
      
      private var _rootModel:ICollectionView;
      
      private var _openItems:Object = {};
      
      private var dataProviderChanged:Boolean = false;
      
      private var _showRoot:Boolean = true;
      
      public var itemIcons:Object;
      
      private var showRootChanged:Boolean = false;
      
      private var openItemsChanged:Boolean = false;
      
      public function TreeGrid()
      {
         super();
         setStyle("indentation",18);
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
      
      private function searchForCurrentDepth(value:Object, item:Object, depth:int = 1) : int
      {
         var i:int = 0;
         var result:int = 0;
         if(value == item)
         {
            return depth;
         }
         if(value == null || _dataDescriptor.getChildren(value) == null)
         {
            return -1;
         }
         depth++;
         for(i = 0; i < _dataDescriptor.getChildren(value).length; i++)
         {
            result = searchForCurrentDepth(_dataDescriptor.getChildren(value)[i],item,depth);
            if(result != -1)
            {
               return result;
            }
         }
         return -1;
      }
      
      override protected function makeListData(data:Object, uid:String, rowNum:int, columnNum:int, column:DataGridColumn) : BaseListData
      {
         var treeGridListData:TreeGridListData = null;
         if(data is DataGridColumn)
         {
            treeGridListData = new TreeGridListData(column.headerText != null ? column.headerText : column.dataField,column.dataField,columnNum,uid,this,rowNum);
         }
         else
         {
            treeGridListData = new TreeGridListData(column.itemToLabel(data),column.dataField,columnNum,uid,this,rowNum);
            initListData(data,treeGridListData);
         }
         return treeGridListData;
      }
      
      public function get showRoot() : Boolean
      {
         return _showRoot;
      }
      
      override protected function commitProperties() : void
      {
         var tmpCollection:ICollectionView = null;
         var row:Object = null;
         var rootItem:* = undefined;
         var event:CollectionEvent = null;
         if(showRootChanged)
         {
            if(!_hasRoot)
            {
               showRootChanged = false;
            }
         }
         if(dataProviderChanged || showRootChanged)
         {
            _displayedModel = new ArrayCollection();
            dataProviderChanged = false;
            showRootChanged = false;
            if(!openItemsChanged)
            {
               _openItems = {};
            }
            if(Boolean(_rootModel) && Boolean(!_showRoot) && _hasRoot)
            {
               rootItem = _rootModel.createCursor().current;
               if(rootItem != null && Boolean(_dataDescriptor.isBranch(rootItem,_rootModel)) && Boolean(_dataDescriptor.hasChildren(rootItem,_rootModel)))
               {
                  tmpCollection = getChildren(rootItem,_rootModel);
                  for each(row in tmpCollection)
                  {
                     _displayedModel.addItem(row);
                  }
               }
            }
            else if(_hasRoot)
            {
               if(_rootModel != null && _rootModel.length > 0)
               {
                  _displayedModel.addItem(_rootModel[0]);
               }
            }
            else
            {
               for each(row in _rootModel)
               {
                  _displayedModel.addItem(row);
               }
            }
            super.dataProvider = _displayedModel;
         }
         if(openItemsChanged)
         {
            openItemsChanged = false;
            event = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            event.kind = CollectionEventKind.RESET;
            collection.dispatchEvent(event);
         }
         super.commitProperties();
      }
      
      public function get hasRoot() : Boolean
      {
         return _hasRoot;
      }
      
      public function get dataDescriptor() : ITreeDataDescriptor
      {
         return ITreeDataDescriptor(_dataDescriptor);
      }
      
      public function closeItemAt(rowNum:Number, item:Object = null, closeItem:Boolean = true) : void
      {
         var uid:String = null;
         var i:int = 0;
         if(item == null)
         {
            item = ListCollectionView(_displayedModel).getItemAt(rowNum);
         }
         if(closeItem)
         {
            uid = itemToUID(item);
            delete _openItems[uid];
         }
         if(Boolean(_dataDescriptor.getChildren(item)))
         {
            for(i = 0; i < _dataDescriptor.getChildren(item).length; i++)
            {
               if(isItemOpen(_dataDescriptor.getChildren(item)[i]))
               {
                  closeItemAt(rowNum,_dataDescriptor.getChildren(item)[i],false);
               }
               ListCollectionView(_displayedModel).removeItemAt(rowNum + 1);
            }
         }
      }
      
      private function getItemIndex(item:Object) : int
      {
         var cursor:IViewCursor = null;
         var i:int = 0;
         cursor = collection.createCursor();
         i = 0;
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
      
      public function set showRoot(value:Boolean) : void
      {
         if(_showRoot != value)
         {
            _showRoot = value;
            showRootChanged = true;
            invalidateProperties();
         }
      }
      
      public function isItemOpen(item:Object) : Boolean
      {
         var uid:String = null;
         uid = itemToUID(item);
         return _openItems[uid] != null;
      }
      
      private function getChildren(item:Object, view:Object) : ICollectionView
      {
         var children:ICollectionView = null;
         return _dataDescriptor.getChildren(item,view);
      }
      
      public function closeAllItems() : void
      {
         var i:int = 0;
         for(i = 0; i < ICollectionView(_displayedModel).length; i++)
         {
            this.closeItemAt(i);
         }
      }
      
      protected function getItemDepth(item:Object, offset:int) : int
      {
         var depth:int = 0;
         var i:int = 0;
         if(hasRoot)
         {
            depth = searchForCurrentDepth(dataProvider[0],item);
         }
         else
         {
            i = 0;
            do
            {
               depth = searchForCurrentDepth(dataProvider[i++],item);
            }
            while(depth == -1);
         }
         if(depth == -1)
         {
            throw new Error("item not found");
         }
         return depth;
      }
      
      [Inspectable(category="Data")]
      public function set dataDescriptor(value:ITreeDataDescriptor) : void
      {
         _dataDescriptor = value;
      }
      
      public function openItemAt(rowNum:Number, item:Object = null) : void
      {
         var uid:String = null;
         var i:int = 0;
         uid = itemToUID(item);
         _openItems[uid] = item;
         this.selectedIndex = -1;
         if(item == null)
         {
            item = ListCollectionView(_displayedModel).getItemAt(rowNum);
         }
         for(i = 0; i < _dataDescriptor.getChildren(item).length; i++)
         {
            ListCollectionView(_displayedModel).addItemAt(_dataDescriptor.getChildren(item)[i],rowNum + i + 1);
         }
         for(i = 0; i < _dataDescriptor.getChildren(item).length; i++)
         {
            if(isItemOpen(_dataDescriptor.getChildren(item)[i]))
            {
               openItemAt(rowNum + i + 1,_dataDescriptor.getChildren(item)[i]);
            }
         }
      }
      
      protected function isLastItem(listData:TreeGridListData) : Boolean
      {
         return false;
      }
      
      public function dispatchTreeEvent(type:String, listData:TreeGridListData, renderer:IListItemRenderer, trigger:Event = null, opening:Boolean = true, dispatch:Boolean = true) : void
      {
         if(opening)
         {
            openItemAt(getItemIndex(listData.item),listData.item);
         }
         else
         {
            closeItemAt(getItemIndex(listData.item),listData.item);
         }
      }
      
      override public function itemToIcon(item:Object) : Class
      {
         var icon:* = undefined;
         var open:Boolean = false;
         var branch:Boolean = false;
         var uid:String = null;
         var iconClass:Class = null;
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
      
      protected function initListData(item:Object, treeListData:TreeGridListData) : void
      {
         var open:Boolean = false;
         var branch:Boolean = false;
         var uid:String = null;
         if(item == null)
         {
            return;
         }
         open = isItemOpen(item);
         branch = isBranch(item);
         uid = itemToUID(item);
         treeListData.disclosureIcon = getStyle(open ? "disclosureOpenIcon" : "disclosureClosedIcon");
         treeListData.open = open;
         treeListData.hasChildren = branch;
         treeListData.depth = getItemDepth(item,treeListData.rowIndex);
         treeListData.indent = (treeListData.depth - (_showRoot ? 1 : 2)) * getStyle("indentation");
         treeListData.indentationGap = getStyle("indentation");
         treeListData.item = item;
         treeListData.icon = itemToIcon(item);
         treeListData.trunk = getStyle("verticalTrunks");
         if(Boolean(treeListData.trunk))
         {
            treeListData.trunkOffsetTop = getStyle("paddingTop");
            treeListData.trunkOffsetBottom = getStyle("paddingBottom");
            treeListData.hasSibling = !isLastItem(treeListData);
         }
      }
      
      public function set openItems(value:Object) : void
      {
         var item:* = undefined;
         if(value != null)
         {
            for each(item in value)
            {
               _openItems[itemToUID(item)] = item;
            }
            openItemsChanged = true;
            invalidateProperties();
         }
      }
      
      public function isBranch(item:Object) : Boolean
      {
         if(item != null)
         {
            return _dataDescriptor.isBranch(item,iterator.view);
         }
         return false;
      }
      
      [Inspectable(category="Data",defaultValue="undefined")]
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
      
      public function get openItems() : Object
      {
         var openItemsArray:Array = null;
         var item:* = undefined;
         openItemsArray = [];
         for each(item in _openItems)
         {
            openItemsArray.push(item);
         }
         return openItemsArray;
      }
      
      override public function get dataProvider() : Object
      {
         return _rootModel;
      }
   }
}

