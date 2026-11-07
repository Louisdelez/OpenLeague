package mx.controls
{
   import flash.events.KeyboardEvent;
   import flash.filesystem.File;
   import mx.controls.dataGridClasses.DataGridColumn;
   import mx.controls.fileSystemClasses.FileSystemControlHelper;
   import mx.controls.fileSystemClasses.FileSystemDataGridNameColumnRenderer;
   import mx.core.ClassFactory;
   import mx.core.ScrollPolicy;
   import mx.events.ListEvent;
   import mx.formatters.DateFormatter;
   
   [ResourceBundle("aircontrols")]
   [IconFile("FileSystemDataGrid.png")]
   [Style(name="fileIcon",type="Class",format="EmbeddedFile",inherit="no")]
   [Style(name="directoryIcon",type="Class",format="EmbeddedFile",inherit="no")]
   [Event(name="fileChoose",type="mx.events.FileEvent")]
   [Event(name="directoryChanging",type="mx.events.FileEvent")]
   [Event(name="directoryChange",type="mx.events.FileEvent")]
   public class FileSystemDataGrid extends DataGrid
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public static const COMPUTER:File = FileSystemControlHelper.COMPUTER;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var helper:FileSystemControlHelper;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var dateFormatter:DateFormatter = new DateFormatter();
      
      public var creationDateColumn:DataGridColumn;
      
      private var _dateFormatString:String;
      
      private var dateFormatStringOverride:String;
      
      public var modificationDateColumn:DataGridColumn;
      
      public var nameColumn:DataGridColumn;
      
      public var sizeColumn:DataGridColumn;
      
      private var _sizeDisplayMode:String = "kilobytes";
      
      public var typeColumn:DataGridColumn;
      
      public function FileSystemDataGrid()
      {
         super();
         this.helper = new FileSystemControlHelper(this,false);
         doubleClickEnabled = true;
         horizontalScrollPolicy = ScrollPolicy.AUTO;
         iconFunction = this.helper.fileIconFunction;
         addEventListener(ListEvent.ITEM_DOUBLE_CLICK,this.itemDoubleClickHandler);
         this.dateFormatter.formatString = this.dateFormatString;
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
      
      public function get dateFormatString() : String
      {
         return this._dateFormatString;
      }
      
      public function set dateFormatString(value:String) : void
      {
         this.dateFormatStringOverride = value;
         this._dateFormatString = value != null ? value : resourceManager.getString("aircontrols","fileSystemDataGrid_dateFormatString");
         this.dateFormatter.formatString = this._dateFormatString != null ? this._dateFormatString : "";
         invalidateList();
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
      
      public function get sizeDisplayMode() : String
      {
         return this._sizeDisplayMode;
      }
      
      public function set sizeDisplayMode(value:String) : void
      {
         this._sizeDisplayMode = value;
         invalidateList();
      }
      
      override protected function childrenCreated() : void
      {
         var measuredText:String = null;
         super.childrenCreated();
         this.nameColumn = new CustomDataGridColumn();
         this.nameColumn.headerText = resourceManager.getString("aircontrols","fileSystemDataGrid_nameColumnHeader");
         this.nameColumn.itemRenderer = new ClassFactory(FileSystemDataGridNameColumnRenderer);
         this.nameColumn.labelFunction = this.helper.fileLabelFunction;
         this.nameColumn.sortCompareFunction = this.nameSortCompareFunction;
         measuredText = resourceManager.getString("aircontrols","fileSystemDataGrid_nameColumnMeasuredText");
         this.nameColumn.width = this.determineWidthToDisplay(measuredText);
         this.typeColumn = new CustomDataGridColumn();
         this.typeColumn.headerText = resourceManager.getString("aircontrols","fileSystemDataGrid_typeColumnHeader");
         this.typeColumn.labelFunction = this.typeLabelFunction;
         this.typeColumn.sortCompareFunction = this.typeSortCompareFunction;
         measuredText = resourceManager.getString("aircontrols","fileSystemDataGrid_typeColumnMeasuredText");
         this.typeColumn.width = this.determineWidthToDisplay(measuredText);
         this.sizeColumn = new CustomDataGridColumn();
         this.sizeColumn.headerText = resourceManager.getString("aircontrols","fileSystemDataGrid_sizeColumnHeader");
         this.sizeColumn.labelFunction = this.sizeLabelFunction;
         this.sizeColumn.setStyle("textAlign","right");
         this.sizeColumn.sortCompareFunction = this.sizeSortCompareFunction;
         measuredText = resourceManager.getString("aircontrols","fileSystemDataGrid_sizeColumnMeasuredText");
         this.sizeColumn.width = this.determineWidthToDisplay(measuredText);
         this.creationDateColumn = new CustomDataGridColumn();
         this.creationDateColumn.headerText = resourceManager.getString("aircontrols","fileSystemDataGrid_creationDateColumnHeader");
         this.creationDateColumn.labelFunction = this.creationDateLabelFunction;
         measuredText = resourceManager.getString("aircontrols","fileSystemDataGrid_creationDateColumnMeasuredText");
         this.creationDateColumn.width = this.determineWidthToDisplay(measuredText);
         this.modificationDateColumn = new CustomDataGridColumn();
         this.modificationDateColumn.headerText = resourceManager.getString("aircontrols","fileSystemDataGrid_modificationDateColumnHeader");
         this.modificationDateColumn.labelFunction = this.modificationDateLabelFunction;
         measuredText = resourceManager.getString("aircontrols","fileSystemDataGrid_modificationDateColumnMeasuredText");
         this.modificationDateColumn.width = this.determineWidthToDisplay(measuredText);
         if(!columns || columns.length == 0)
         {
            columns = [this.nameColumn,this.typeColumn,this.sizeColumn,this.creationDateColumn,this.modificationDateColumn];
         }
      }
      
      override protected function commitProperties() : void
      {
         this.helper.commitProperties();
         super.commitProperties();
      }
      
      override protected function measure() : void
      {
         super.measure();
         measuredWidth += 16;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         this.helper.styleChanged(styleProp);
      }
      
      override protected function resourcesChanged() : void
      {
         var measuredText:String = null;
         super.resourcesChanged();
         if(Boolean(this.nameColumn))
         {
            this.nameColumn.headerText = resourceManager.getString("aircontrols","fileSystemDataGrid_nameColumnHeader");
            measuredText = resourceManager.getString("aircontrols","fileSystemDataGrid_nameColumnMeasuredText");
            this.nameColumn.width = this.determineWidthToDisplay(measuredText);
         }
         if(Boolean(this.typeColumn))
         {
            this.typeColumn.headerText = resourceManager.getString("aircontrols","fileSystemDataGrid_typeColumnHeader");
            measuredText = resourceManager.getString("aircontrols","fileSystemDataGrid_typeColumnMeasuredText");
            this.typeColumn.width = this.determineWidthToDisplay(measuredText);
         }
         if(Boolean(this.sizeColumn))
         {
            this.sizeColumn.headerText = resourceManager.getString("aircontrols","fileSystemDataGrid_sizeColumnHeader");
            measuredText = resourceManager.getString("aircontrols","fileSystemDataGrid_sizeColumnMeasuredText");
            this.sizeColumn.width = this.determineWidthToDisplay(measuredText);
         }
         if(Boolean(this.creationDateColumn))
         {
            this.creationDateColumn.headerText = resourceManager.getString("aircontrols","fileSystemDataGrid_creationDateColumnHeader");
            measuredText = resourceManager.getString("aircontrols","fileSystemDataGrid_creationDateColumnMeasuredText");
            this.creationDateColumn.width = this.determineWidthToDisplay(measuredText);
         }
         if(Boolean(this.modificationDateColumn))
         {
            this.modificationDateColumn.headerText = resourceManager.getString("aircontrols","fileSystemDataGrid_modificationDateColumnHeader");
            measuredText = resourceManager.getString("aircontrols","fileSystemDataGrid_modificationDateColumnMeasuredText");
            this.modificationDateColumn.width = this.determineWidthToDisplay(measuredText);
         }
         this.dateFormatString = this.dateFormatStringOverride;
         invalidateList();
         invalidateSize();
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
      
      private function nameSortCompareFunction(item1:File, item2:File) : int
      {
         return this.helper.directoryEnumeration.fileCompareFunction(item1,item2);
      }
      
      private function typeLabelFunction(item:File, column:DataGridColumn = null) : String
      {
         if(item.isDirectory)
         {
            return resourceManager.getString("aircontrols","fileSystemDataGrid_typeFolder");
         }
         var extension:String = item.extension;
         if(!extension || extension == "")
         {
            return resourceManager.getString("aircontrols","fileSystemDataGrid_typeFileWithoutExtension");
         }
         return resourceManager.getString("aircontrols","fileSystemDataGrid_typeFileWithExtension",[extension.toUpperCase()]);
      }
      
      private function typeSortCompareFunction(item1:File, item2:File) : int
      {
         var typeLabel1:String = this.typeLabelFunction(item1,null).toUpperCase();
         var typeLabel2:String = this.typeLabelFunction(item2,null).toUpperCase();
         if(typeLabel1 < typeLabel2)
         {
            return -1;
         }
         if(typeLabel1 > typeLabel2)
         {
            return 1;
         }
         return 0;
      }
      
      private function sizeLabelFunction(item:File, column:DataGridColumn = null) : String
      {
         var label:String = null;
         var kb:int = 0;
         if(!item.exists)
         {
            return "";
         }
         try
         {
            if(item.isDirectory)
            {
               label = resourceManager.getString("aircontrols","fileSystemDataGrid_sizeFolder");
            }
            else if(this.sizeDisplayMode == FileSystemSizeDisplayMode.KILOBYTES)
            {
               kb = Math.ceil(item.size / 1024);
               label = resourceManager.getString("aircontrols","fileSystemDataGrid_sizeKilobytes",[kb]);
            }
            else if(this.sizeDisplayMode == FileSystemSizeDisplayMode.BYTES)
            {
               label = resourceManager.getString("aircontrols","fileSystemDataGrid_sizeBytes",[item.size]);
            }
         }
         catch(e:Error)
         {
            label = resourceManager.getString("aircontrols","fileSystemDataGrid_sizeFolder");
         }
         return label;
      }
      
      private function sizeSortCompareFunction(item1:File, item2:File) : int
      {
         var size1:Number = NaN;
         var size2:Number = NaN;
         try
         {
            size1 = item1.isDirectory ? 0 : Number(item1.size);
         }
         catch(e1:Error)
         {
            size1 = 0;
         }
         try
         {
            size2 = item2.isDirectory ? 0 : Number(item2.size);
         }
         catch(e2:Error)
         {
            size2 = 0;
         }
         if(size1 < size2)
         {
            return -1;
         }
         if(size1 > size2)
         {
            return 1;
         }
         return 0;
      }
      
      private function creationDateLabelFunction(item:File, column:DataGridColumn = null) : String
      {
         if(!item.exists)
         {
            return "";
         }
         return this.dateFormatter.format(item.creationDate);
      }
      
      private function modificationDateLabelFunction(item:File, column:DataGridColumn = null) : String
      {
         if(!item.exists)
         {
            return "";
         }
         return this.dateFormatter.format(item.modificationDate);
      }
      
      private function determineWidthToDisplay(s:String) : Number
      {
         return measureText(s).width + 13;
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

import mx.controls.dataGridClasses.DataGridColumn;

class CustomDataGridColumn extends DataGridColumn
{
   
   public function CustomDataGridColumn(columnName:String = null)
   {
      super(columnName);
   }
   
   override public function itemToDataTip(data:Object) : String
   {
      return labelFunction(data);
   }
}
