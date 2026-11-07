package mx.controls
{
   import flash.events.FileListEvent;
   import flash.events.KeyboardEvent;
   import flash.filesystem.File;
   import flash.ui.Keyboard;
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.controls.fileSystemClasses.FileSystemControlHelper;
   import mx.controls.fileSystemClasses.FileSystemTreeDataDescriptor;
   import mx.core.ScrollPolicy;
   import mx.events.FileEvent;
   import mx.events.ListEvent;
   import mx.events.TreeEvent;
   
   [ResourceBundle("aircontrols")]
   [IconFile("FileSystemTree.png")]
   [Event(name="fileChoose",type="mx.events.FileEvent")]
   [Event(name="directoryOpening",type="mx.events.FileEvent")]
   [Event(name="directoryClosing",type="mx.events.FileEvent")]
   [Event(name="directoryChange",type="mx.events.FileEvent")]
   public class FileSystemTree extends Tree
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public static const COMPUTER:File = FileSystemControlHelper.COMPUTER;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var helper:FileSystemControlHelper;
      
      public function FileSystemTree()
      {
         super();
         this.helper = new FileSystemControlHelper(this,true);
         dataDescriptor = new FileSystemTreeDataDescriptor();
         doubleClickEnabled = true;
         horizontalScrollPolicy = ScrollPolicy.AUTO;
         iconFunction = this.helper.fileIconFunction;
         labelFunction = this.helper.fileLabelFunction;
         addEventListener(TreeEvent.ITEM_OPENING,this.itemOpeningHandler);
         addEventListener(ListEvent.ITEM_DOUBLE_CLICK,this.itemDoubleClickHandler);
         this.directory = COMPUTER;
      }
      
      [Bindable("directoryChanged")]
      public function get directory() : File
      {
         return this.helper.directory;
      }
      
      public function set directory(value:File) : void
      {
         this.helper.directory = value;
      }
      
      public function get enumerationMode() : String
      {
         return this.helper.enumerationMode;
      }
      
      public function set enumerationMode(value:String) : void
      {
         this.helper.enumerationMode = value;
      }
      
      public function get extensions() : Array
      {
         return this.helper.extensions;
      }
      
      public function set extensions(value:Array) : void
      {
         this.helper.extensions = value;
      }
      
      public function get filterFunction() : Function
      {
         return this.helper.filterFunction;
      }
      
      public function set filterFunction(value:Function) : void
      {
         this.helper.filterFunction = value;
      }
      
      public function get nameCompareFunction() : Function
      {
         return this.helper.nameCompareFunction;
      }
      
      public function set nameCompareFunction(value:Function) : void
      {
         this.helper.nameCompareFunction = value;
      }
      
      public function get openPaths() : Array
      {
         return this.helper.openPaths;
      }
      
      public function set openPaths(value:Array) : void
      {
         this.helper.openPaths = value;
      }
      
      [Bindable("directoryChanged")]
      [Bindable("change")]
      public function get selectedPath() : String
      {
         return this.helper.selectedPath;
      }
      
      public function set selectedPath(value:String) : void
      {
         this.helper.selectedPath = value;
      }
      
      [Bindable("directoryChanged")]
      [Bindable("change")]
      public function get selectedPaths() : Array
      {
         return this.helper.selectedPaths;
      }
      
      public function set selectedPaths(value:Array) : void
      {
         this.helper.selectedPaths = value;
      }
      
      public function get showExtensions() : Boolean
      {
         return this.helper.showExtensions;
      }
      
      public function set showExtensions(value:Boolean) : void
      {
         this.helper.showExtensions = value;
      }
      
      public function get showHidden() : Boolean
      {
         return this.helper.showHidden;
      }
      
      public function set showHidden(value:Boolean) : void
      {
         this.helper.showHidden = value;
      }
      
      public function get showIcons() : Boolean
      {
         return this.helper.showIcons;
      }
      
      public function set showIcons(value:Boolean) : void
      {
         this.helper.showIcons = value;
      }
      
      override protected function commitProperties() : void
      {
         this.helper.commitProperties();
         super.commitProperties();
      }
      
      override protected function measure() : void
      {
         super.measure();
         var text:String = resourceManager.getString("aircontrols","fileSystemTree_measuredText");
         measuredWidth = measureText(text).width;
      }
      
      override public function getStyle(styleProp:String) : *
      {
         if(styleProp == "directoryIcon")
         {
            styleProp = "folderClosedIcon";
         }
         else if(styleProp == "fileIcon")
         {
            styleProp = "defaultLeafIcon";
         }
         return super.getStyle(styleProp);
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         this.helper.styleChanged(styleProp);
      }
      
      override protected function itemToUID(data:Object) : String
      {
         return this.helper.itemToUID(data);
      }
      
      public function findIndex(nativePath:String) : int
      {
         return this.helper.findIndex(nativePath);
      }
      
      public function findItem(nativePath:String) : File
      {
         return this.helper.findItem(nativePath);
      }
      
      public function refresh() : void
      {
         this.helper.refresh();
      }
      
      public function clear() : void
      {
         this.helper.clear();
      }
      
      public function openSubdirectory(nativePath:String) : void
      {
         var item:File = new File(nativePath);
         if(!item.exists || !item.isDirectory)
         {
            return;
         }
         var savedOpenDuration:Number = this.getStyle("openDuration");
         setStyle("openDuration",0);
         var parentPaths:Array = this.getParentPaths(item);
         var n:int = int(parentPaths.length);
         for(var i:int = 0; i < n; i++)
         {
            item = this.findItem(parentPaths[i]);
            if(Boolean(item))
            {
               this.openItem(item,false);
            }
         }
         setStyle("openDuration",savedOpenDuration);
         invalidateList();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function openItem(item:File, async:Boolean = true) : void
      {
         if(isItemOpen(item))
         {
            return;
         }
         var children:ArrayCollection = ArrayCollection(dataDescriptor.getChildren(item));
         if(!children || this.modificationDateHasChanged(item))
         {
            if(async)
            {
               item.addEventListener(FileListEvent.DIRECTORY_LISTING,this.directoryListingHandler);
               item.getDirectoryListingAsync();
            }
            else
            {
               this.insertChildItems(item,item.getDirectoryListing());
            }
         }
         else
         {
            expandItem(item,true,true);
            this.helper.itemsChanged();
         }
         invalidateList();
      }
      
      public function closeSubdirectory(nativePath:String) : void
      {
         var item:File = this.findItem(nativePath);
         if(Boolean(item) && Boolean(item.isDirectory))
         {
            this.closeItem(item);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function closeItem(item:File) : void
      {
         expandItem(item,false,true);
         this.fixSelectionAfterClose(item);
         this.helper.itemsChanged();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function fixSelectionAfterClose(item:File) : void
      {
         var selectedPath:String = null;
         var closingPath:String = item.nativePath;
         var newSelectedItems:Array = [];
         var n:int = int(selectedItems.length);
         for(var i:int = 0; i < n; i++)
         {
            selectedPath = selectedItems[i].nativePath;
            if(selectedPath.indexOf(closingPath) == 0)
            {
               newSelectedItems.push(item);
            }
            else
            {
               newSelectedItems.push(selectedItems[i]);
            }
         }
         selectedItems = newSelectedItems;
      }
      
      private function getParentPaths(file:File) : Array
      {
         var a:Array = [];
         for(var f:File = file; f != null; f = f.parent)
         {
            if(f.nativePath == this.directory.nativePath)
            {
               break;
            }
            a.unshift(f.nativePath);
         }
         return a;
      }
      
      private function modificationDateHasChanged(item:File) : Boolean
      {
         var item2:File = new File(item.nativePath);
         return item.modificationDate != item2.modificationDate;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function insertChildItems(subdirectory:File, childItems:Array) : void
      {
         var childCollection:ArrayCollection = new ArrayCollection(childItems);
         childCollection.filterFunction = this.helper.directoryEnumeration.fileFilterFunction;
         childCollection.sort = new Sort();
         childCollection.sort.compareFunction = this.helper.directoryEnumeration.fileCompareFunction;
         childCollection.refresh();
         FileSystemTreeDataDescriptor(dataDescriptor).setChildren(subdirectory,childCollection);
         expandItem(subdirectory,true,true);
         this.helper.itemsChanged();
      }
      
      private function openSelectedSubdirectory() : void
      {
         var item:File = File(selectedItem);
         if(Boolean(item) && Boolean(item.exists) && Boolean(item.isDirectory))
         {
            this.openItem(item,true);
         }
      }
      
      private function closeSelectedSubdirectory() : void
      {
         var item:File = File(selectedItem);
         if(Boolean(item) && Boolean(item.exists) && Boolean(item.isDirectory))
         {
            this.closeItem(item);
         }
      }
      
      private function dispatchDirectoryOpeningEvent(directory:File) : Boolean
      {
         var event:FileEvent = new FileEvent(FileEvent.DIRECTORY_OPENING,false,true);
         event.file = directory;
         dispatchEvent(event);
         return !event.isDefaultPrevented();
      }
      
      private function dispatchDirectoryClosingEvent(directory:File) : Boolean
      {
         var event:FileEvent = new FileEvent(FileEvent.DIRECTORY_CLOSING,false,true);
         event.file = directory;
         dispatchEvent(event);
         return !event.isDefaultPrevented();
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         var selectedFile:File = null;
         if(event.keyCode == Keyboard.ENTER)
         {
            selectedFile = File(selectedItem);
            if(Boolean(selectedFile) && !selectedFile.isDirectory)
            {
               this.helper.dispatchFileChooseEvent(selectedFile);
            }
            return;
         }
         super.keyDownHandler(event);
      }
      
      private function itemOpeningHandler(event:TreeEvent) : void
      {
         event.preventDefault();
         var item:File = File(event.item);
         if(event.opening)
         {
            if(this.dispatchDirectoryOpeningEvent(item))
            {
               this.openItem(item,true);
            }
         }
         else if(this.dispatchDirectoryClosingEvent(item))
         {
            this.closeItem(item);
         }
      }
      
      private function directoryListingHandler(event:FileListEvent) : void
      {
         this.insertChildItems(File(event.target),event.files);
      }
      
      private function itemDoubleClickHandler(event:ListEvent) : void
      {
         var item:File = File(selectedItem);
         if(item.isDirectory)
         {
            if(!isItemOpen(item))
            {
               if(this.dispatchDirectoryOpeningEvent(item))
               {
                  this.openSelectedSubdirectory();
               }
            }
            else if(this.dispatchDirectoryClosingEvent(item))
            {
               this.closeSelectedSubdirectory();
            }
         }
         else
         {
            this.helper.dispatchFileChooseEvent(item);
         }
      }
   }
}

