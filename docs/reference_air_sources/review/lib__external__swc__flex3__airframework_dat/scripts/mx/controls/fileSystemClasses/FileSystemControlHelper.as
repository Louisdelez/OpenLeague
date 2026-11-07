package mx.controls.fileSystemClasses
{
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.filesystem.File;
   import flash.system.Capabilities;
   import flash.ui.Keyboard;
   import mx.collections.ArrayCollection;
   import mx.controls.FileSystemEnumerationMode;
   import mx.controls.dataGridClasses.DataGridColumn;
   import mx.events.FileEvent;
   import mx.events.FlexEvent;
   import mx.events.ListEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.utils.DirectoryEnumeration;
   
   [ExcludeClass]
   public class FileSystemControlHelper
   {
      
      public static var COMPUTER:File;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.6.0.12937";
      
      initClass();
      
      private var extensionsChanged:Boolean = false;
      
      private var _showExtensions:Boolean = true;
      
      private var _nameCompareFunction:Function;
      
      private var filterFunctionChanged:Boolean = false;
      
      private var _enumerationMode:String = FileSystemEnumerationMode.DIRECTORIES_FIRST;
      
      private var nameCompareFunctionChanged:Boolean = false;
      
      private var directoryChanged:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var hierarchical:Boolean;
      
      private var _itemArray:Array;
      
      private var _filterFunction:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var directoryEnumeration:DirectoryEnumeration = new DirectoryEnumeration();
      
      public var history:Array;
      
      public var historyIndex:int;
      
      private var _nativePathToIndexMap:Object;
      
      private var _showIcons:Boolean = true;
      
      private var _showHidden:Boolean = false;
      
      private var _extensions:Array;
      
      private var showHiddenChanged:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var owner:Object;
      
      private var pendingSelectedPaths:Array;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      private var enumerationModeChanged:Boolean = false;
      
      private var pendingOpenPaths:Array;
      
      private var _directory:File;
      
      public function FileSystemControlHelper(owner:Object, hierarchical:Boolean)
      {
         super();
         this.owner = owner;
         this.hierarchical = hierarchical;
         owner.addEventListener(FlexEvent.UPDATE_COMPLETE,updateCompleteHandler);
      }
      
      private static function fileSystemIsCaseInsensitive() : Boolean
      {
         var os:String = Capabilities.os.substring(0,3);
         return os == "Win" || os == "Mac";
      }
      
      private static function initClass() : void
      {
         if(Capabilities.os.substring(0,3) == "Win")
         {
            COMPUTER = new File("root$:\\Computer");
         }
         else
         {
            COMPUTER = new File("/Computer");
         }
      }
      
      public function getParentChain(file:File) : Array
      {
         if(!file)
         {
            return [];
         }
         var a:Array = [];
         for(var f:File = file; f != null; f = f.parent)
         {
            a.unshift(f);
         }
         return a;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get itemArray() : Array
      {
         if(!_itemArray)
         {
            rebuildEnumerationInfo();
         }
         return _itemArray;
      }
      
      public function fileIconFunction(item:File) : Class
      {
         if(!showIcons)
         {
            return null;
         }
         return owner.getStyle(item.isDirectory ? "directoryIcon" : "fileIcon");
      }
      
      [Bindable("historyChanged")]
      public function get forwardHistory() : Array
      {
         return historyIndex < history.length - 1 ? history.slice(historyIndex + 1) : [];
      }
      
      public function set enumerationMode(value:String) : void
      {
         _enumerationMode = value;
         enumerationModeChanged = true;
         owner.invalidateProperties();
      }
      
      public function get showHidden() : Boolean
      {
         return _showHidden;
      }
      
      public function get selectedPaths() : Array
      {
         return Boolean(pendingSelectedPaths) ? pendingSelectedPaths : getSelectedPaths();
      }
      
      public function get extensions() : Array
      {
         return _extensions;
      }
      
      public function set showHidden(value:Boolean) : void
      {
         _showHidden = value;
         showHiddenChanged = true;
         owner.invalidateProperties();
      }
      
      private function pushHistory(directory:File) : void
      {
         ++historyIndex;
         history.splice(historyIndex);
         history.push(directory);
         owner.dispatchEvent(new Event("historyChanged"));
      }
      
      public function navigateForward(index:int = 0) : void
      {
         if(canNavigateForward)
         {
            navigateBy(1 + index);
         }
      }
      
      public function get canNavigateForward() : Boolean
      {
         return historyIndex < history.length - 1;
      }
      
      public function set extensions(value:Array) : void
      {
         _extensions = value;
         extensionsChanged = true;
         owner.invalidateProperties();
      }
      
      public function get showIcons() : Boolean
      {
         return _showIcons;
      }
      
      public function set selectedPaths(value:Array) : void
      {
         pendingSelectedPaths = value;
         owner.invalidateProperties();
      }
      
      private function getOpenPaths() : Array
      {
         var openPaths:Array = [];
         var n:int = int(owner.openItems.length);
         for(var i:int = 0; i < n; i++)
         {
            openPaths.push(File(owner.openItems[i]).nativePath);
         }
         return openPaths;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setDirectory(value:File) : void
      {
         _directory = value;
         directoryChanged = true;
         owner.dataProvider = null;
         if(hierarchical)
         {
            owner.dataDescriptor.reset();
         }
         owner.invalidateProperties();
         owner.dispatchEvent(new Event("directoryChanged"));
      }
      
      public function set showIcons(value:Boolean) : void
      {
         _showIcons = value;
         owner.invalidateList();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setDataProvider(value:Array) : void
      {
         directoryEnumeration.enumerationMode = enumerationMode;
         directoryEnumeration.extensions = extensions;
         directoryEnumeration.filterFunction = filterFunction;
         directoryEnumeration.nameCompareFunction = nameCompareFunction;
         directoryEnumeration.showHidden = showHidden;
         directoryEnumeration.source = value;
         owner.dataProvider = directoryEnumeration.collection;
         itemsChanged();
      }
      
      public function resetHistory(directory:File) : void
      {
         history = [directory];
         historyIndex = 0;
         owner.dispatchEvent(new Event("historyChanged"));
      }
      
      public function clear() : void
      {
         owner.dataProvider = null;
         itemsChanged();
      }
      
      private function getRootDirectories() : Array
      {
         var f:File = null;
         var a:Array = [];
         for each(f in File.getRootDirectories())
         {
            if(f.isDirectory)
            {
               a.push(f);
            }
         }
         return a;
      }
      
      public function handleKeyDown(event:KeyboardEvent) : Boolean
      {
         var selectedFile:File = null;
         switch(event.keyCode)
         {
            case Keyboard.ENTER:
               selectedFile = File(owner.selectedItem);
               if(canNavigateDown && dispatchDirectoryChangingEvent(selectedFile))
               {
                  navigateDown();
               }
               else
               {
                  dispatchFileChooseEvent(selectedFile);
               }
               return true;
            case Keyboard.BACKSPACE:
               if(canNavigateUp && dispatchDirectoryChangingEvent(directory.parent))
               {
                  navigateUp();
               }
               return true;
            default:
               return false;
         }
      }
      
      private function getSelectedPaths() : Array
      {
         var selectedPaths:Array = [];
         var n:int = int(owner.selectedItems.length);
         for(var i:int = 0; i < n; i++)
         {
            selectedPaths.push(File(owner.selectedItems[i]).nativePath);
         }
         return selectedPaths;
      }
      
      public function get selectedPath() : String
      {
         return selectedPaths[0];
      }
      
      private function enumerate(items:ArrayCollection, index:int, itemCallback:Function) : int
      {
         var item:File = null;
         var childItems:ArrayCollection = null;
         var n:int = int(items.length);
         for(var i:int = 0; i < n; i++)
         {
            item = File(items.getItemAt(i));
            itemCallback(index,item);
            index++;
            if(hierarchical && Boolean(item.isDirectory) && Boolean(owner.isItemOpen(item)))
            {
               childItems = owner.dataDescriptor.getChildren(item);
               index = enumerate(childItems,index,itemCallback);
            }
         }
         return index;
      }
      
      public function isComputer(f:File) : Boolean
      {
         if(Capabilities.os.substr(0,3) == "Win")
         {
            return f.nativePath.substring(0,6) == "root$:";
         }
         return f.nativePath == "/Computer";
      }
      
      private function setFirstVisiblePath(path:String) : Boolean
      {
         if(path == null)
         {
            return false;
         }
         var index:int = findIndex(path);
         if(index == -1)
         {
            return false;
         }
         owner.verticalScrollPosition = index;
         return true;
      }
      
      public function findItem(nativePath:String) : File
      {
         var index:int = findIndex(nativePath);
         if(index == -1)
         {
            return null;
         }
         return itemArray[index];
      }
      
      public function get directory() : File
      {
         return _directory;
      }
      
      public function get filterFunction() : Function
      {
         return _filterFunction;
      }
      
      private function getFirstVisiblePath() : String
      {
         if(owner.dataProvider == null || owner.dataProvider.length == 0)
         {
            return null;
         }
         var index:int = int(owner.verticalScrollPosition);
         var item:File = itemArray[index];
         return Boolean(item) ? item.nativePath : null;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function fill() : void
      {
         setDataProvider(isComputer(directory) ? getRootDirectories() : directory.getDirectoryListing());
      }
      
      public function itemDoubleClickHandler(event:ListEvent) : void
      {
         var selectedFile:File = File(owner.selectedItem);
         if(selectedFile.isDirectory)
         {
            if(dispatchDirectoryChangingEvent(selectedFile))
            {
               navigateDown();
            }
         }
         else
         {
            dispatchFileChooseEvent(selectedFile);
         }
      }
      
      public function set openPaths(value:Array) : void
      {
         pendingOpenPaths = value;
         owner.invalidateProperties();
      }
      
      public function get enumerationMode() : String
      {
         return _enumerationMode;
      }
      
      private function getBackDirectory() : File
      {
         return historyIndex == 0 ? null : history[historyIndex - 1];
      }
      
      public function itemToUID(data:Object) : String
      {
         return Boolean(data) ? File(data).nativePath : "null";
      }
      
      public function findIndex(nativePath:String) : int
      {
         if(!nativePath)
         {
            return -1;
         }
         if(fileSystemIsCaseInsensitive())
         {
            nativePath = nativePath.toLowerCase();
         }
         var value:* = nativePathToIndexMap[nativePath];
         return value === undefined ? -1 : int(value);
      }
      
      public function get canNavigateDown() : Boolean
      {
         var selectedFile:File = File(owner.selectedItem);
         return Boolean(selectedFile) && Boolean(selectedFile.isDirectory);
      }
      
      public function set nameCompareFunction(value:Function) : void
      {
         _nameCompareFunction = value;
         nameCompareFunctionChanged = true;
         owner.invalidateProperties();
      }
      
      private function navigateBy(n:int) : void
      {
         historyIndex += n;
         if(historyIndex < 0)
         {
            historyIndex = 0;
         }
         else if(historyIndex > history.length - 1)
         {
            historyIndex = history.length - 1;
         }
         setDirectory(history[historyIndex]);
         owner.dispatchEvent(new Event("historyChanged"));
      }
      
      public function get backHistory() : Array
      {
         return historyIndex > 0 ? history.slice(0,historyIndex).reverse() : [];
      }
      
      private function setOpenPaths(openPaths:Array) : void
      {
         var n:int = int(openPaths.length);
         for(var i:int = 0; i < n; i++)
         {
            owner.openSubdirectory(openPaths[i]);
         }
      }
      
      private function addItemToEnumerationInfo(index:int, item:File) : void
      {
         var nativePath:String = item.nativePath;
         if(fileSystemIsCaseInsensitive())
         {
            nativePath = nativePath.toLowerCase();
         }
         _itemArray.push(item);
         _nativePathToIndexMap[nativePath] = index;
      }
      
      private function getForwardDirectory() : File
      {
         return historyIndex == history.length - 1 ? null : history[historyIndex + 1];
      }
      
      public function set selectedPath(value:String) : void
      {
         selectedPaths = [value];
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get nativePathToIndexMap() : Object
      {
         if(!_nativePathToIndexMap)
         {
            rebuildEnumerationInfo();
         }
         return _nativePathToIndexMap;
      }
      
      public function navigateDown() : void
      {
         if(canNavigateDown)
         {
            navigateTo(File(owner.selectedItem));
         }
      }
      
      public function styleChanged(styleProp:String) : void
      {
         if(styleProp == "fileIcon" || styleProp == "directoryIcon")
         {
            owner.invalidateList();
         }
      }
      
      public function get openPaths() : Array
      {
         return Boolean(pendingOpenPaths) ? pendingOpenPaths : getOpenPaths();
      }
      
      private function updateCompleteHandler(event:FlexEvent) : void
      {
         if(pendingOpenPaths != null)
         {
            setOpenPaths(pendingOpenPaths);
            pendingOpenPaths = null;
         }
         if(pendingSelectedPaths != null)
         {
            setSelectedPaths(pendingSelectedPaths);
            pendingSelectedPaths = null;
         }
      }
      
      private function enumerateItems(itemCallback:Function) : int
      {
         return enumerate(ArrayCollection(owner.dataProvider),0,itemCallback);
      }
      
      public function navigateTo(directory:File) : void
      {
         setDirectory(directory);
         pushHistory(directory);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function dispatchFileChooseEvent(file:File) : void
      {
         var event:FileEvent = new FileEvent(FileEvent.FILE_CHOOSE);
         event.file = file;
         owner.dispatchEvent(event);
      }
      
      public function fileLabelFunction(item:File, column:DataGridColumn = null) : String
      {
         var index:int = 0;
         if(isComputer(item))
         {
            return resourceManager.getString("aircontrols","computer");
         }
         var label:String = item.name;
         if(label == "")
         {
            label = item.nativePath;
         }
         if(!item.isDirectory && !showExtensions)
         {
            index = label.lastIndexOf(".");
            if(index != -1)
            {
               label = label.substring(0,index);
            }
         }
         return label;
      }
      
      public function commitProperties() : void
      {
         var event:FileEvent = null;
         if(enumerationModeChanged || extensionsChanged || filterFunctionChanged || nameCompareFunctionChanged || showHiddenChanged)
         {
            directoryEnumeration.enumerationMode = enumerationMode;
            directoryEnumeration.extensions = extensions;
            directoryEnumeration.filterFunction = filterFunction;
            directoryEnumeration.nameCompareFunction = nameCompareFunction;
            directoryEnumeration.showHidden = showHidden;
            directoryEnumeration.refresh();
            owner.dataProvider = directoryEnumeration.collection;
            itemsChanged();
            extensionsChanged = false;
            enumerationModeChanged = false;
            filterFunctionChanged = false;
            nameCompareFunctionChanged = false;
            showHiddenChanged = false;
         }
         if(directoryChanged)
         {
            fill();
            event = new FileEvent(FileEvent.DIRECTORY_CHANGE);
            event.file = directory;
            owner.dispatchEvent(event);
            directoryChanged = false;
         }
      }
      
      public function get nameCompareFunction() : Function
      {
         return _nameCompareFunction;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function itemsChanged() : void
      {
         _itemArray = null;
         _nativePathToIndexMap = null;
      }
      
      private function setSelectedPaths(selectedPaths:Array) : void
      {
         var path:String = null;
         var index:int = 0;
         var indices:Array = [];
         var n:int = int(selectedPaths.length);
         for(var i:int = 0; i < n; i++)
         {
            path = selectedPaths[i];
            index = findIndex(path);
            if(index != -1)
            {
               indices.push(index);
            }
         }
         owner.selectedIndices = indices;
      }
      
      public function set directory(value:File) : void
      {
         if(!value || !isComputer(value) && (!value.exists || !value.isDirectory))
         {
            throw new Error("No such directory: " + value.nativePath);
         }
         resetHistory(value);
         setDirectory(value);
      }
      
      public function refresh() : void
      {
         var openPaths:Array = null;
         var selectedPaths:Array = null;
         var firstVisiblePath:String = null;
         var oldHorizontalScrollPosition:int = 0;
         if(hierarchical)
         {
            openPaths = getOpenPaths();
         }
         selectedPaths = getSelectedPaths();
         firstVisiblePath = getFirstVisiblePath();
         oldHorizontalScrollPosition = int(owner.horizontalScrollPosition);
         fill();
         if(hierarchical)
         {
            owner.validateNow();
         }
         if(hierarchical)
         {
            setOpenPaths(openPaths);
         }
         setSelectedPaths(selectedPaths);
         if(setFirstVisiblePath(firstVisiblePath))
         {
            owner.horizontalScrollPosition = oldHorizontalScrollPosition;
         }
      }
      
      public function set filterFunction(value:Function) : void
      {
         _filterFunction = value;
         filterFunctionChanged = true;
         owner.invalidateProperties();
      }
      
      public function set showExtensions(value:Boolean) : void
      {
         _showExtensions = value;
         owner.invalidateList();
      }
      
      public function get canNavigateUp() : Boolean
      {
         return !isComputer(directory);
      }
      
      public function get canNavigateBack() : Boolean
      {
         return historyIndex > 0;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function dispatchDirectoryChangingEvent(newDirectory:File) : Boolean
      {
         var event:FileEvent = new FileEvent(FileEvent.DIRECTORY_CHANGING,false,true);
         event.file = newDirectory;
         owner.dispatchEvent(event);
         return !event.isDefaultPrevented();
      }
      
      public function navigateUp() : void
      {
         if(canNavigateUp)
         {
            navigateTo(Boolean(directory.parent) ? directory.parent : COMPUTER);
         }
      }
      
      public function get showExtensions() : Boolean
      {
         return _showExtensions;
      }
      
      public function navigateBack(index:int = 0) : void
      {
         if(canNavigateBack)
         {
            navigateBy(-1 - index);
         }
      }
      
      private function rebuildEnumerationInfo() : void
      {
         _itemArray = [];
         _nativePathToIndexMap = {};
         enumerateItems(addItemToEnumerationInfo);
      }
   }
}

