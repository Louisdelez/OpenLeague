package mx.controls
{
   import flash.events.KeyboardEvent;
   import flash.filesystem.File;
   import mx.controls.fileSystemClasses.FileSystemControlHelper;
   import mx.core.ScrollPolicy;
   import mx.events.ListEvent;
   
   [ResourceBundle("aircontrols")]
   [IconFile("FileSystemList.png")]
   [Style(name="fileIcon",type="Class",format="EmbeddedFile",inherit="no")]
   [Style(name="directoryIcon",type="Class",format="EmbeddedFile",inherit="no")]
   [Event(name="fileChoose",type="mx.events.FileEvent")]
   [Event(name="directoryChanging",type="mx.events.FileEvent")]
   [Event(name="directoryChange",type="mx.events.FileEvent")]
   public class FileSystemList extends List
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.6.0.12937";
      
      public static const COMPUTER:File = FileSystemControlHelper.COMPUTER;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var helper:FileSystemControlHelper;
      
      public function FileSystemList()
      {
         super();
         helper = new FileSystemControlHelper(this,false);
         doubleClickEnabled = true;
         horizontalScrollPolicy = ScrollPolicy.AUTO;
         iconFunction = helper.fileIconFunction;
         labelFunction = helper.fileLabelFunction;
         showDataTips = true;
         addEventListener(ListEvent.ITEM_DOUBLE_CLICK,itemDoubleClickHandler);
         directory = COMPUTER;
      }
      
      public function set selectedPath(value:String) : void
      {
         helper.selectedPath = value;
      }
      
      override protected function itemToUID(data:Object) : String
      {
         return helper.itemToUID(data);
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         helper.styleChanged(styleProp);
      }
      
      public function resetHistory(dir:File) : void
      {
         helper.resetHistory(dir);
      }
      
      protected function itemDoubleClickHandler(event:ListEvent) : void
      {
         helper.itemDoubleClickHandler(event);
      }
      
      public function get showHidden() : Boolean
      {
         return helper.showHidden;
      }
      
      public function get enumerationMode() : String
      {
         return helper.enumerationMode;
      }
      
      public function navigateDown() : void
      {
         helper.navigateDown();
      }
      
      public function navigateTo(directory:File) : void
      {
         helper.navigateTo(directory);
      }
      
      public function clear() : void
      {
         helper.clear();
      }
      
      public function set showHidden(value:Boolean) : void
      {
         helper.showHidden = value;
      }
      
      [Bindable("historyChanged")]
      public function get forwardHistory() : Array
      {
         return helper.forwardHistory;
      }
      
      override protected function commitProperties() : void
      {
         helper.commitProperties();
         super.commitProperties();
      }
      
      public function get nameCompareFunction() : Function
      {
         return helper.nameCompareFunction;
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
      
      public function findIndex(nativePath:String) : int
      {
         return helper.findIndex(nativePath);
      }
      
      public function set directory(value:File) : void
      {
         helper.directory = value;
      }
      
      public function get extensions() : Array
      {
         return helper.extensions;
      }
      
      public function get showIcons() : Boolean
      {
         return helper.showIcons;
      }
      
      override protected function measure() : void
      {
         super.measure();
         var text:String = resourceManager.getString("aircontrols","fileSystemList_measuredText");
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
      public function get canNavigateDown() : Boolean
      {
         return helper.canNavigateDown;
      }
      
      [Bindable("historyChanged")]
      public function get canNavigateForward() : Boolean
      {
         return helper.canNavigateForward;
      }
      
      public function set selectedPaths(value:Array) : void
      {
         helper.selectedPaths = value;
      }
      
      [Bindable("directoryChanged")]
      [Bindable("change")]
      public function get selectedPath() : String
      {
         return helper.selectedPath;
      }
      
      [Bindable("historyChanged")]
      public function get canNavigateBack() : Boolean
      {
         return helper.canNavigateBack;
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         if(helper.handleKeyDown(event))
         {
            return;
         }
         super.keyDownHandler(event);
      }
      
      public function refresh() : void
      {
         helper.refresh();
      }
      
      public function set nameCompareFunction(value:Function) : void
      {
         helper.nameCompareFunction = value;
      }
      
      public function findItem(nativePath:String) : File
      {
         return helper.findItem(nativePath);
      }
      
      [Bindable("historyChanged")]
      public function get backHistory() : Array
      {
         return helper.backHistory;
      }
      
      public function set extensions(value:Array) : void
      {
         helper.extensions = value;
      }
      
      public function get filterFunction() : Function
      {
         return helper.filterFunction;
      }
      
      public function get showExtensions() : Boolean
      {
         return helper.showExtensions;
      }
      
      [Bindable("directoryChanged")]
      public function get directory() : File
      {
         return helper.directory;
      }
      
      public function navigateForward(index:int = 0) : void
      {
         helper.navigateForward(index);
      }
      
      public function navigateBack(index:int = 0) : void
      {
         helper.navigateBack(index);
      }
      
      public function set showIcons(value:Boolean) : void
      {
         helper.showIcons = value;
      }
      
      public function navigateUp() : void
      {
         helper.navigateUp();
      }
      
      override public function itemToDataTip(data:Object) : String
      {
         return helper.fileLabelFunction(File(data));
      }
      
      [Bindable("directoryChanged")]
      public function get canNavigateUp() : Boolean
      {
         return helper.canNavigateUp;
      }
   }
}

