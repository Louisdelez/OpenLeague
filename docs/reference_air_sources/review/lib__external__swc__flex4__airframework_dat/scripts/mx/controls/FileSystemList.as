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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public static const COMPUTER:File = FileSystemControlHelper.COMPUTER;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var helper:FileSystemControlHelper;
      
      public function FileSystemList()
      {
         super();
         this.helper = new FileSystemControlHelper(this,false);
         doubleClickEnabled = true;
         horizontalScrollPolicy = ScrollPolicy.AUTO;
         iconFunction = this.helper.fileIconFunction;
         labelFunction = this.helper.fileLabelFunction;
         showDataTips = true;
         addEventListener(ListEvent.ITEM_DOUBLE_CLICK,this.itemDoubleClickHandler);
         this.directory = COMPUTER;
      }
      
      [Bindable("historyChanged")]
      public function get backHistory() : Array
      {
         return this.helper.backHistory;
      }
      
      [Bindable("historyChanged")]
      public function get canNavigateBack() : Boolean
      {
         return this.helper.canNavigateBack;
      }
      
      [Bindable("directoryChanged")]
      [Bindable("change")]
      public function get canNavigateDown() : Boolean
      {
         return this.helper.canNavigateDown;
      }
      
      [Bindable("historyChanged")]
      public function get canNavigateForward() : Boolean
      {
         return this.helper.canNavigateForward;
      }
      
      [Bindable("directoryChanged")]
      public function get canNavigateUp() : Boolean
      {
         return this.helper.canNavigateUp;
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
      
      [Bindable("historyChanged")]
      public function get forwardHistory() : Array
      {
         return this.helper.forwardHistory;
      }
      
      public function get nameCompareFunction() : Function
      {
         return this.helper.nameCompareFunction;
      }
      
      public function set nameCompareFunction(value:Function) : void
      {
         this.helper.nameCompareFunction = value;
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
         var text:String = resourceManager.getString("aircontrols","fileSystemList_measuredText");
         measuredWidth = measureText(text).width;
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
      
      override public function itemToDataTip(data:Object) : String
      {
         return this.helper.fileLabelFunction(File(data));
      }
      
      public function findIndex(nativePath:String) : int
      {
         return this.helper.findIndex(nativePath);
      }
      
      public function findItem(nativePath:String) : File
      {
         return this.helper.findItem(nativePath);
      }
      
      public function navigateDown() : void
      {
         this.helper.navigateDown();
      }
      
      public function navigateUp() : void
      {
         this.helper.navigateUp();
      }
      
      public function navigateBack(index:int = 0) : void
      {
         this.helper.navigateBack(index);
      }
      
      public function navigateForward(index:int = 0) : void
      {
         this.helper.navigateForward(index);
      }
      
      public function navigateTo(directory:File) : void
      {
         this.helper.navigateTo(directory);
      }
      
      public function refresh() : void
      {
         this.helper.refresh();
      }
      
      public function clear() : void
      {
         this.helper.clear();
      }
      
      public function resetHistory(dir:File) : void
      {
         this.helper.resetHistory(dir);
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         if(this.helper.handleKeyDown(event))
         {
            return;
         }
         super.keyDownHandler(event);
      }
      
      protected function itemDoubleClickHandler(event:ListEvent) : void
      {
         this.helper.itemDoubleClickHandler(event);
      }
   }
}

