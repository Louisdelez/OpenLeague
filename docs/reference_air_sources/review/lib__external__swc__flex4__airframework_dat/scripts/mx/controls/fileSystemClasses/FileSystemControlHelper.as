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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      initClass();
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var owner:Object;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var hierarchical:Boolean;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      private var _directory:File;
      
      private var directoryChanged:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var directoryEnumeration:DirectoryEnumeration = new DirectoryEnumeration();
      
      private var _enumerationMode:String = FileSystemEnumerationMode.DIRECTORIES_FIRST;
      
      private var enumerationModeChanged:Boolean = false;
      
      private var _extensions:Array;
      
      private var extensionsChanged:Boolean = false;
      
      private var _filterFunction:Function;
      
      private var filterFunctionChanged:Boolean = false;
      
      public var history:Array;
      
      public var historyIndex:int;
      
      private var _nativePathToIndexMap:Object;
      
      private var _itemArray:Array;
      
      private var _nameCompareFunction:Function;
      
      private var nameCompareFunctionChanged:Boolean = false;
      
      private var pendingOpenPaths:Array;
      
      private var pendingSelectedPaths:Array;
      
      private var _showExtensions:Boolean = true;
      
      private var _showHidden:Boolean = false;
      
      private var showHiddenChanged:Boolean = false;
      
      private var _showIcons:Boolean = true;
      
      public function FileSystemControlHelper(owner:Object, hierarchical:Boolean)
      {
         super();
         this.owner = owner;
         this.hierarchical = hierarchical;
         owner.addEventListener(FlexEvent.UPDATE_COMPLETE,this.updateCompleteHandler);
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
      
      private static function fileSystemIsCaseInsensitive() : Boolean
      {
         var os:String = Capabilities.os.substring(0,3);
         return os == "Win" || os == "Mac";
      }
      
      public function get backHistory() : Array
      {
         return this.historyIndex > 0 ? this.history.slice(0,this.historyIndex).reverse() : [];
      }
      
      public function get canNavigateBack() : Boolean
      {
         return this.historyIndex > 0;
      }
      
      public function get canNavigateDown() : Boolean
      {
         var selectedFile:File = File(this.owner.selectedItem);
         return Boolean(selectedFile) && Boolean(selectedFile.isDirectory);
      }
      
      public function get canNavigateForward() : Boolean
      {
         return this.historyIndex < this.history.length - 1;
      }
      
      public function get canNavigateUp() : Boolean
      {
         return !this.isComputer(this.directory);
      }
      
      public function get directory() : File
      {
         return this._directory;
      }
      
      public function set directory(value:File) : void
      {
         if(!value || !this.isComputer(value) && (!value.exists || !value.isDirectory))
         {
            throw new Error("No such directory: " + value.nativePath);
         }
         this.resetHistory(value);
         this.setDirectory(value);
      }
      
      public function get enumerationMode() : String
      {
         return this._enumerationMode;
      }
      
      public function set enumerationMode(value:String) : void
      {
         this._enumerationMode = value;
         this.enumerationModeChanged = true;
         this.owner.invalidateProperties();
      }
      
      public function get extensions() : Array
      {
         return this._extensions;
      }
      
      public function set extensions(value:Array) : void
      {
         this._extensions = value;
         this.extensionsChanged = true;
         this.owner.invalidateProperties();
      }
      
      public function get filterFunction() : Function
      {
         return this._filterFunction;
      }
      
      public function set filterFunction(value:Function) : void
      {
         this._filterFunction = value;
         this.filterFunctionChanged = true;
         this.owner.invalidateProperties();
      }
      
      [Bindable("historyChanged")]
      public function get forwardHistory() : Array
      {
         return this.historyIndex < this.history.length - 1 ? this.history.slice(this.historyIndex + 1) : [];
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get nativePathToIndexMap() : Object
      {
         if(!this._nativePathToIndexMap)
         {
            this.rebuildEnumerationInfo();
         }
         return this._nativePathToIndexMap;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get itemArray() : Array
      {
         if(!this._itemArray)
         {
            this.rebuildEnumerationInfo();
         }
         return this._itemArray;
      }
      
      public function get nameCompareFunction() : Function
      {
         return this._nameCompareFunction;
      }
      
      public function set nameCompareFunction(value:Function) : void
      {
         this._nameCompareFunction = value;
         this.nameCompareFunctionChanged = true;
         this.owner.invalidateProperties();
      }
      
      public function get openPaths() : Array
      {
         return Boolean(this.pendingOpenPaths) ? this.pendingOpenPaths : this.getOpenPaths();
      }
      
      public function set openPaths(value:Array) : void
      {
         this.pendingOpenPaths = value;
         this.owner.invalidateProperties();
      }
      
      public function get selectedPath() : String
      {
         return this.selectedPaths[0];
      }
      
      public function set selectedPath(value:String) : void
      {
         this.selectedPaths = [value];
      }
      
      public function get selectedPaths() : Array
      {
         return Boolean(this.pendingSelectedPaths) ? this.pendingSelectedPaths : this.getSelectedPaths();
      }
      
      public function set selectedPaths(value:Array) : void
      {
         this.pendingSelectedPaths = value;
         this.owner.invalidateProperties();
      }
      
      public function get showExtensions() : Boolean
      {
         return this._showExtensions;
      }
      
      public function set showExtensions(value:Boolean) : void
      {
         this._showExtensions = value;
         this.owner.invalidateList();
      }
      
      public function get showHidden() : Boolean
      {
         return this._showHidden;
      }
      
      public function set showHidden(value:Boolean) : void
      {
         this._showHidden = value;
         this.showHiddenChanged = true;
         this.owner.invalidateProperties();
      }
      
      public function get showIcons() : Boolean
      {
         return this._showIcons;
      }
      
      public function set showIcons(value:Boolean) : void
      {
         this._showIcons = value;
         this.owner.invalidateList();
      }
      
      public function commitProperties() : void
      {
         var event:FileEvent = null;
         if(this.enumerationModeChanged || this.extensionsChanged || this.filterFunctionChanged || this.nameCompareFunctionChanged || this.showHiddenChanged)
         {
            this.directoryEnumeration.enumerationMode = this.enumerationMode;
            this.directoryEnumeration.extensions = this.extensions;
            this.directoryEnumeration.filterFunction = this.filterFunction;
            this.directoryEnumeration.nameCompareFunction = this.nameCompareFunction;
            this.directoryEnumeration.showHidden = this.showHidden;
            this.directoryEnumeration.refresh();
            this.owner.dataProvider = this.directoryEnumeration.collection;
            this.itemsChanged();
            this.extensionsChanged = false;
            this.enumerationModeChanged = false;
            this.filterFunctionChanged = false;
            this.nameCompareFunctionChanged = false;
            this.showHiddenChanged = false;
         }
         if(this.directoryChanged)
         {
            this.fill();
            event = new FileEvent(FileEvent.DIRECTORY_CHANGE);
            event.file = this.directory;
            this.owner.dispatchEvent(event);
            this.directoryChanged = false;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function fill() : void
      {
         this.setDataProvider(this.isComputer(this.directory) ? this.getRootDirectories() : this.directory.getDirectoryListing());
      }
      
      public function styleChanged(styleProp:String) : void
      {
         if(styleProp == "fileIcon" || styleProp == "directoryIcon")
         {
            this.owner.invalidateList();
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setDirectory(value:File) : void
      {
         this._directory = value;
         this.directoryChanged = true;
         this.owner.dataProvider = null;
         if(this.hierarchical)
         {
            this.owner.dataDescriptor.reset();
         }
         this.owner.invalidateProperties();
         this.owner.dispatchEvent(new Event("directoryChanged"));
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setDataProvider(value:Array) : void
      {
         this.directoryEnumeration.enumerationMode = this.enumerationMode;
         this.directoryEnumeration.extensions = this.extensions;
         this.directoryEnumeration.filterFunction = this.filterFunction;
         this.directoryEnumeration.nameCompareFunction = this.nameCompareFunction;
         this.directoryEnumeration.showHidden = this.showHidden;
         this.directoryEnumeration.source = value;
         this.owner.dataProvider = this.directoryEnumeration.collection;
         this.itemsChanged();
      }
      
      public function itemToUID(data:Object) : String
      {
         return Boolean(data) ? File(data).nativePath : "null";
      }
      
      public function isComputer(f:File) : Boolean
      {
         if(Capabilities.os.substr(0,3) == "Win")
         {
            return f.nativePath.substring(0,6) == "root$:";
         }
         return f.nativePath == "/Computer";
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
      
      public function fileIconFunction(item:File) : Class
      {
         if(!this.showIcons)
         {
            return null;
         }
         return this.owner.getStyle(item.isDirectory ? "directoryIcon" : "fileIcon");
      }
      
      public function fileLabelFunction(item:File, column:DataGridColumn = null) : String
      {
         var index:int = 0;
         if(this.isComputer(item))
         {
            return this.resourceManager.getString("aircontrols","computer");
         }
         var label:String = item.name;
         if(label == "")
         {
            label = item.nativePath;
         }
         if(!item.isDirectory && !this.showExtensions)
         {
            index = label.lastIndexOf(".");
            if(index != -1)
            {
               label = label.substring(0,index);
            }
         }
         return label;
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
         var value:* = this.nativePathToIndexMap[nativePath];
         return value === undefined ? -1 : int(value);
      }
      
      public function findItem(nativePath:String) : File
      {
         var index:int = this.findIndex(nativePath);
         if(index == -1)
         {
            return null;
         }
         return this.itemArray[index];
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function itemsChanged() : void
      {
         this._itemArray = null;
         this._nativePathToIndexMap = null;
      }
      
      private function rebuildEnumerationInfo() : void
      {
         this._itemArray = [];
         this._nativePathToIndexMap = {};
         this.enumerateItems(this.addItemToEnumerationInfo);
      }
      
      private function addItemToEnumerationInfo(index:int, item:File) : void
      {
         var nativePath:String = item.nativePath;
         if(fileSystemIsCaseInsensitive())
         {
            nativePath = nativePath.toLowerCase();
         }
         this._itemArray.push(item);
         this._nativePathToIndexMap[nativePath] = index;
      }
      
      private function enumerateItems(itemCallback:Function) : int
      {
         return this.enumerate(ArrayCollection(this.owner.dataProvider),0,itemCallback);
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
            if(this.hierarchical && Boolean(item.isDirectory) && Boolean(this.owner.isItemOpen(item)))
            {
               childItems = this.owner.dataDescriptor.getChildren(item);
               index = this.enumerate(childItems,index,itemCallback);
            }
         }
         return index;
      }
      
      public function navigateDown() : void
      {
         if(this.canNavigateDown)
         {
            this.navigateTo(File(this.owner.selectedItem));
         }
      }
      
      public function navigateUp() : void
      {
         if(this.canNavigateUp)
         {
            this.navigateTo(Boolean(this.directory.parent) ? this.directory.parent : COMPUTER);
         }
      }
      
      public function navigateBack(index:int = 0) : void
      {
         if(this.canNavigateBack)
         {
            this.navigateBy(-1 - index);
         }
      }
      
      public function navigateForward(index:int = 0) : void
      {
         if(this.canNavigateForward)
         {
            this.navigateBy(1 + index);
         }
      }
      
      private function navigateBy(n:int) : void
      {
         this.historyIndex += n;
         if(this.historyIndex < 0)
         {
            this.historyIndex = 0;
         }
         else if(this.historyIndex > this.history.length - 1)
         {
            this.historyIndex = this.history.length - 1;
         }
         this.setDirectory(this.history[this.historyIndex]);
         this.owner.dispatchEvent(new Event("historyChanged"));
      }
      
      public function navigateTo(directory:File) : void
      {
         this.setDirectory(directory);
         this.pushHistory(directory);
      }
      
      public function refresh() : void
      {
         var openPaths:Array = null;
         var selectedPaths:Array = null;
         var firstVisiblePath:String = null;
         var oldHorizontalScrollPosition:int = 0;
         if(this.hierarchical)
         {
            openPaths = this.getOpenPaths();
         }
         selectedPaths = this.getSelectedPaths();
         firstVisiblePath = this.getFirstVisiblePath();
         oldHorizontalScrollPosition = int(this.owner.horizontalScrollPosition);
         this.fill();
         if(this.hierarchical)
         {
            this.owner.validateNow();
         }
         if(this.hierarchical)
         {
            this.setOpenPaths(openPaths);
         }
         this.setSelectedPaths(selectedPaths);
         if(this.setFirstVisiblePath(firstVisiblePath))
         {
            this.owner.horizontalScrollPosition = oldHorizontalScrollPosition;
         }
      }
      
      private function getOpenPaths() : Array
      {
         var openPaths:Array = [];
         var n:int = int(this.owner.openItems.length);
         for(var i:int = 0; i < n; i++)
         {
            openPaths.push(File(this.owner.openItems[i]).nativePath);
         }
         return openPaths;
      }
      
      private function getSelectedPaths() : Array
      {
         var selectedPaths:Array = [];
         var n:int = int(this.owner.selectedItems.length);
         for(var i:int = 0; i < n; i++)
         {
            selectedPaths.push(File(this.owner.selectedItems[i]).nativePath);
         }
         return selectedPaths;
      }
      
      private function getFirstVisiblePath() : String
      {
         if(this.owner.dataProvider == null || this.owner.dataProvider.length == 0)
         {
            return null;
         }
         var index:int = int(this.owner.verticalScrollPosition);
         var item:File = this.itemArray[index];
         return Boolean(item) ? item.nativePath : null;
      }
      
      private function setOpenPaths(openPaths:Array) : void
      {
         var n:int = int(openPaths.length);
         for(var i:int = 0; i < n; i++)
         {
            this.owner.openSubdirectory(openPaths[i]);
         }
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
            index = this.findIndex(path);
            if(index != -1)
            {
               indices.push(index);
            }
         }
         this.owner.selectedIndices = indices;
      }
      
      private function setFirstVisiblePath(path:String) : Boolean
      {
         if(path == null)
         {
            return false;
         }
         var index:int = this.findIndex(path);
         if(index == -1)
         {
            return false;
         }
         this.owner.verticalScrollPosition = index;
         return true;
      }
      
      public function clear() : void
      {
         this.owner.dataProvider = null;
         this.itemsChanged();
      }
      
      public function resetHistory(directory:File) : void
      {
         this.history = [directory];
         this.historyIndex = 0;
         this.owner.dispatchEvent(new Event("historyChanged"));
      }
      
      private function pushHistory(directory:File) : void
      {
         ++this.historyIndex;
         this.history.splice(this.historyIndex);
         this.history.push(directory);
         this.owner.dispatchEvent(new Event("historyChanged"));
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function dispatchDirectoryChangingEvent(newDirectory:File) : Boolean
      {
         var event:FileEvent = new FileEvent(FileEvent.DIRECTORY_CHANGING,false,true);
         event.file = newDirectory;
         this.owner.dispatchEvent(event);
         return !event.isDefaultPrevented();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function dispatchFileChooseEvent(file:File) : void
      {
         var event:FileEvent = new FileEvent(FileEvent.FILE_CHOOSE);
         event.file = file;
         this.owner.dispatchEvent(event);
      }
      
      private function getBackDirectory() : File
      {
         return this.historyIndex == 0 ? null : this.history[this.historyIndex - 1];
      }
      
      private function getForwardDirectory() : File
      {
         return this.historyIndex == this.history.length - 1 ? null : this.history[this.historyIndex + 1];
      }
      
      private function updateCompleteHandler(event:FlexEvent) : void
      {
         if(this.pendingOpenPaths != null)
         {
            this.setOpenPaths(this.pendingOpenPaths);
            this.pendingOpenPaths = null;
         }
         if(this.pendingSelectedPaths != null)
         {
            this.setSelectedPaths(this.pendingSelectedPaths);
            this.pendingSelectedPaths = null;
         }
      }
      
      public function itemDoubleClickHandler(event:ListEvent) : void
      {
         var selectedFile:File = File(this.owner.selectedItem);
         if(selectedFile.isDirectory)
         {
            if(this.dispatchDirectoryChangingEvent(selectedFile))
            {
               this.navigateDown();
            }
         }
         else
         {
            this.dispatchFileChooseEvent(selectedFile);
         }
      }
      
      public function handleKeyDown(event:KeyboardEvent) : Boolean
      {
         var selectedFile:File = null;
         switch(event.keyCode)
         {
            case Keyboard.ENTER:
               selectedFile = File(this.owner.selectedItem);
               if(this.canNavigateDown && this.dispatchDirectoryChangingEvent(selectedFile))
               {
                  this.navigateDown();
               }
               else
               {
                  this.dispatchFileChooseEvent(selectedFile);
               }
               return true;
            case Keyboard.BACKSPACE:
               if(this.canNavigateUp && this.dispatchDirectoryChangingEvent(this.directory.parent))
               {
                  this.navigateUp();
               }
               return true;
            default:
               return false;
         }
      }
   }
}

