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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.6.0.12937";
      
      public static const COMPUTER:File = FileSystemControlHelper.COMPUTER;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var helper:FileSystemControlHelper;
      
      public function FileSystemTree()
      {
         super();
         helper = new FileSystemControlHelper(this,true);
         dataDescriptor = new FileSystemTreeDataDescriptor();
         doubleClickEnabled = true;
         horizontalScrollPolicy = ScrollPolicy.AUTO;
         iconFunction = helper.fileIconFunction;
         labelFunction = helper.fileLabelFunction;
         addEventListener(TreeEvent.ITEM_OPENING,itemOpeningHandler);
         addEventListener(ListEvent.ITEM_DOUBLE_CLICK,itemDoubleClickHandler);
         directory = COMPUTER;
      }
      
      private function closeSelectedSubdirectory() : void
      {
         var item:File = File(selectedItem);
         if(Boolean(item) && Boolean(item.exists) && Boolean(item.isDirectory))
         {
            closeItem(item);
         }
      }
      
      override protected function itemToUID(data:Object) : String
      {
         return helper.itemToUID(data);
      }
      
      private function itemDoubleClickHandler(event:ListEvent) : void
      {
         var item:File = File(selectedItem);
         if(item.isDirectory)
         {
            if(!isItemOpen(item))
            {
               if(dispatchDirectoryOpeningEvent(item))
               {
                  openSelectedSubdirectory();
               }
            }
            else if(dispatchDirectoryClosingEvent(item))
            {
               closeSelectedSubdirectory();
            }
         }
         else
         {
            helper.dispatchFileChooseEvent(item);
         }
      }
      
      public function get showHidden() : Boolean
      {
         return helper.showHidden;
      }
      
      public function set openPaths(value:Array) : void
      {
         helper.openPaths = value;
      }
      
      public function get enumerationMode() : String
      {
         return helper.enumerationMode;
      }
      
      public function set showHidden(value:Boolean) : void
      {
         helper.showHidden = value;
      }
      
      [Bindable("directoryChanged")]
      [Bindable("change")]
      public function get selectedPaths() : Array
      {
         return helper.selectedPaths;
      }
      
      public function set enumerationMode(value:String) : void
      {
         helper.enumerationMode = value;
      }
      
      public function openSubdirectory(nativePath:String) : void
      {
         var item:File = new File(nativePath);
         if(!item.exists || !item.isDirectory)
         {
            return;
         }
         var savedOpenDuration:Number = getStyle("openDuration");
         setStyle("openDuration",0);
         var parentPaths:Array = getParentPaths(item);
         var n:int = int(parentPaths.length);
         for(var i:int = 0; i < n; i++)
         {
            item = findItem(parentPaths[i]);
            if(Boolean(item))
            {
               openItem(item,false);
            }
         }
         setStyle("openDuration",savedOpenDuration);
         invalidateList();
      }
      
      private function dispatchDirectoryClosingEvent(directory:File) : Boolean
      {
         var event:FileEvent = new FileEvent(FileEvent.DIRECTORY_CLOSING,false,true);
         event.file = directory;
         dispatchEvent(event);
         return !event.isDefaultPrevented();
      }
      
      public function findIndex(nativePath:String) : int
      {
         return helper.findIndex(nativePath);
      }
      
      public function get extensions() : Array
      {
         return helper.extensions;
      }
      
      public function get showIcons() : Boolean
      {
         return helper.showIcons;
      }
      
      public function set nameCompareFunction(value:Function) : void
      {
         helper.nameCompareFunction = value;
      }
      
      public function set selectedPaths(value:Array) : void
      {
         helper.selectedPaths = value;
      }
      
      public function set extensions(value:Array) : void
      {
         helper.extensions = value;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function closeItem(item:File) : void
      {
         expandItem(item,false,true);
         fixSelectionAfterClose(item);
         helper.itemsChanged();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function insertChildItems(subdirectory:File, childItems:Array) : void
      {
         var childCollection:ArrayCollection = new ArrayCollection(childItems);
         childCollection.filterFunction = helper.directoryEnumeration.fileFilterFunction;
         childCollection.sort = new Sort();
         childCollection.sort.compareFunction = helper.directoryEnumeration.fileCompareFunction;
         childCollection.refresh();
         FileSystemTreeDataDescriptor(dataDescriptor).setChildren(subdirectory,childCollection);
         expandItem(subdirectory,true,true);
         helper.itemsChanged();
      }
      
      private function getParentPaths(file:File) : Array
      {
         var a:Array = [];
         for(var f:File = file; f != null; f = f.parent)
         {
            if(f.nativePath == directory.nativePath)
            {
               break;
            }
            a.unshift(f.nativePath);
         }
         return a;
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
      
      public function set showIcons(value:Boolean) : void
      {
         helper.showIcons = value;
      }
      
      public function set selectedPath(value:String) : void
      {
         helper.selectedPath = value;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         helper.styleChanged(styleProp);
      }
      
      public function get openPaths() : Array
      {
         return helper.openPaths;
      }
      
      public function closeSubdirectory(nativePath:String) : void
      {
         var item:File = findItem(nativePath);
         if(Boolean(item) && Boolean(item.isDirectory))
         {
            closeItem(item);
         }
      }
      
      override protected function commitProperties() : void
      {
         helper.commitProperties();
         super.commitProperties();
      }
      
      private function modificationDateHasChanged(item:File) : Boolean
      {
         var item2:File = new File(item.nativePath);
         return item.modificationDate != item2.modificationDate;
      }
      
      private function itemOpeningHandler(event:TreeEvent) : void
      {
         event.preventDefault();
         var item:File = File(event.item);
         if(event.opening)
         {
            if(dispatchDirectoryOpeningEvent(item))
            {
               openItem(item,true);
            }
         }
         else if(dispatchDirectoryClosingEvent(item))
         {
            closeItem(item);
         }
      }
      
      public function clear() : void
      {
         helper.clear();
      }
      
      public function get nameCompareFunction() : Function
      {
         return helper.nameCompareFunction;
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
      
      private function dispatchDirectoryOpeningEvent(directory:File) : Boolean
      {
         var event:FileEvent = new FileEvent(FileEvent.DIRECTORY_OPENING,false,true);
         event.file = directory;
         dispatchEvent(event);
         return !event.isDefaultPrevented();
      }
      
      private function openSelectedSubdirectory() : void
      {
         var item:File = File(selectedItem);
         if(Boolean(item) && Boolean(item.exists) && Boolean(item.isDirectory))
         {
            openItem(item,true);
         }
      }
      
      public function set directory(value:File) : void
      {
         helper.directory = value;
      }
      
      override protected function measure() : void
      {
         super.measure();
         var text:String = resourceManager.getString("aircontrols","fileSystemTree_measuredText");
         measuredWidth = measureText(text).width;
      }
      
      public function set filterFunction(value:Function) : void
      {
         helper.filterFunction = value;
      }
      
      public function set showExtensions(value:Boolean) : void
      {
         helper.showExtensions = value;
      }
      
      [Bindable("directoryChanged")]
      [Bindable("change")]
      public function get selectedPath() : String
      {
         return helper.selectedPath;
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         var selectedFile:File = null;
         if(event.keyCode == Keyboard.ENTER)
         {
            selectedFile = File(selectedItem);
            if(Boolean(selectedFile) && !selectedFile.isDirectory)
            {
               helper.dispatchFileChooseEvent(selectedFile);
            }
            return;
         }
         super.keyDownHandler(event);
      }
      
      public function refresh() : void
      {
         helper.refresh();
      }
      
      public function findItem(nativePath:String) : File
      {
         return helper.findItem(nativePath);
      }
      
      [Bindable("directoryChanged")]
      public function get directory() : File
      {
         return helper.directory;
      }
      
      public function get filterFunction() : Function
      {
         return helper.filterFunction;
      }
      
      public function get showExtensions() : Boolean
      {
         return helper.showExtensions;
      }
      
      private function directoryListingHandler(event:FileListEvent) : void
      {
         insertChildItems(File(event.target),event.files);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function openItem(item:File, async:Boolean = true) : void
      {
         if(isItemOpen(item))
         {
            return;
         }
         var children:ArrayCollection = ArrayCollection(dataDescriptor.getChildren(item));
         if(!children || modificationDateHasChanged(item))
         {
            if(async)
            {
               item.addEventListener(FileListEvent.DIRECTORY_LISTING,directoryListingHandler);
               item.getDirectoryListingAsync();
            }
            else
            {
               insertChildItems(item,item.getDirectoryListing());
            }
         }
         else
         {
            expandItem(item,true,true);
            helper.itemsChanged();
         }
         invalidateList();
      }
   }
}

