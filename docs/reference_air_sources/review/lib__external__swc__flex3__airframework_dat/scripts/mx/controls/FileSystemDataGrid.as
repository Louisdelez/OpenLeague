package mx.controls
{
   import flash.events.KeyboardEvent;
   import flash.filesystem.File;
   import mx.controls.dataGridClasses.DataGridColumn;
   import mx.controls.fileSystemClasses.FileSystemControlHelper;
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.6.0.12937";
      
      public static const COMPUTER:File = FileSystemControlHelper.COMPUTER;
      
      private var _sizeDisplayMode:String = "kilobytes";
      
      private var _dateFormatString:String;
      
      private var dateFormatStringOverride:String;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var helper:FileSystemControlHelper;
      
      public var typeColumn:DataGridColumn;
      
      public var sizeColumn:DataGridColumn;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var dateFormatter:DateFormatter = new DateFormatter();
      
      public var nameColumn:DataGridColumn;
      
      public var creationDateColumn:DataGridColumn;
      
      public var modificationDateColumn:DataGridColumn;
      
      public function FileSystemDataGrid()
      {
         super();
         helper = new FileSystemControlHelper(this,false);
         doubleClickEnabled = true;
         horizontalScrollPolicy = ScrollPolicy.AUTO;
         iconFunction = helper.fileIconFunction;
         addEventListener(ListEvent.ITEM_DOUBLE_CLICK,itemDoubleClickHandler);
         dateFormatter.formatString = dateFormatString;
         directory = COMPUTER;
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         if(helper.handleKeyDown(event))
         {
            return;
         }
         super.keyDownHandler(event);
      }
      
      protected function itemDoubleClickHandler(event:ListEvent) : void
      {
         helper.itemDoubleClickHandler(event);
      }
      
      public function get showHidden() : Boolean
      {
         return helper.showHidden;
      }
      
      public function set sizeDisplayMode(value:String) : void
      {
         _sizeDisplayMode = value;
         invalidateList();
      }
      
      override protected function itemToUID(data:Object) : String
      {
         return helper.itemToUID(data);
      }
      
      public function get enumerationMode() : String
      {
         return helper.enumerationMode;
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
      
      public function navigateBack(index:int = 0) : void
      {
         helper.navigateBack(index);
      }
      
      [Bindable("directoryChanged")]
      [Bindable("change")]
      public function get selectedPaths() : Array
      {
         return helper.selectedPaths;
      }
      
      public function get extensions() : Array
      {
         return helper.extensions;
      }
      
      public function findIndex(nativePath:String) : int
      {
         return helper.findIndex(nativePath);
      }
      
      public function set enumerationMode(value:String) : void
      {
         helper.enumerationMode = value;
      }
      
      public function get showIcons() : Boolean
      {
         return helper.showIcons;
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
      
      [Bindable("directoryChanged")]
      [Bindable("change")]
      public function get canNavigateDown() : Boolean
      {
         return helper.canNavigateDown;
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
      
      private function modificationDateLabelFunction(item:File, column:DataGridColumn = null) : String
      {
         if(!item.exists)
         {
            return "";
         }
         return dateFormatter.format(item.modificationDate);
      }
      
      [Bindable("historyChanged")]
      public function get canNavigateForward() : Boolean
      {
         return helper.canNavigateForward;
      }
      
      public function navigateForward(index:int = 0) : void
      {
         helper.navigateForward(index);
      }
      
      [Bindable("historyChanged")]
      public function get backHistory() : Array
      {
         return helper.backHistory;
      }
      
      public function get dateFormatString() : String
      {
         return _dateFormatString;
      }
      
      public function set showIcons(value:Boolean) : void
      {
         helper.showIcons = value;
      }
      
      private function creationDateLabelFunction(item:File, column:DataGridColumn = null) : String
      {
         if(!item.exists)
         {
            return "";
         }
         return dateFormatter.format(item.creationDate);
      }
      
      public function navigateDown() : void
      {
         helper.navigateDown();
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
      
      public function set selectedPath(value:String) : void
      {
         helper.selectedPath = value;
      }
      
      override protected function commitProperties() : void
      {
         helper.commitProperties();
         super.commitProperties();
      }
      
      public function get sizeDisplayMode() : String
      {
         return _sizeDisplayMode;
      }
      
      public function navigateTo(directory:File) : void
      {
         helper.navigateTo(directory);
      }
      
      public function clear() : void
      {
         helper.clear();
      }
      
      override protected function resourcesChanged() : void
      {
         var measuredText:String = null;
         super.resourcesChanged();
         if(Boolean(nameColumn))
         {
            nameColumn.headerText = resourceManager.getString("aircontrols","fileSystemDataGrid_nameColumnHeader");
            measuredText = resourceManager.getString("aircontrols","fileSystemDataGrid_nameColumnMeasuredText");
            nameColumn.width = determineWidthToDisplay(measuredText);
         }
         if(Boolean(typeColumn))
         {
            typeColumn.headerText = resourceManager.getString("aircontrols","fileSystemDataGrid_typeColumnHeader");
            measuredText = resourceManager.getString("aircontrols","fileSystemDataGrid_typeColumnMeasuredText");
            typeColumn.width = determineWidthToDisplay(measuredText);
         }
         if(Boolean(sizeColumn))
         {
            sizeColumn.headerText = resourceManager.getString("aircontrols","fileSystemDataGrid_sizeColumnHeader");
            measuredText = resourceManager.getString("aircontrols","fileSystemDataGrid_sizeColumnMeasuredText");
            sizeColumn.width = determineWidthToDisplay(measuredText);
         }
         if(Boolean(creationDateColumn))
         {
            creationDateColumn.headerText = resourceManager.getString("aircontrols","fileSystemDataGrid_creationDateColumnHeader");
            measuredText = resourceManager.getString("aircontrols","fileSystemDataGrid_creationDateColumnMeasuredText");
            creationDateColumn.width = determineWidthToDisplay(measuredText);
         }
         if(Boolean(modificationDateColumn))
         {
            modificationDateColumn.headerText = resourceManager.getString("aircontrols","fileSystemDataGrid_modificationDateColumnHeader");
            measuredText = resourceManager.getString("aircontrols","fileSystemDataGrid_modificationDateColumnMeasuredText");
            modificationDateColumn.width = determineWidthToDisplay(measuredText);
         }
         dateFormatString = dateFormatStringOverride;
         invalidateList();
         invalidateSize();
      }
      
      public function get nameCompareFunction() : Function
      {
         return helper.nameCompareFunction;
      }
      
      private function nameSortCompareFunction(item1:File, item2:File) : int
      {
         return helper.directoryEnumeration.fileCompareFunction(item1,item2);
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
      
      public function set directory(value:File) : void
      {
         helper.directory = value;
      }
      
      private function typeSortCompareFunction(item1:File, item2:File) : int
      {
         var typeLabel1:String = typeLabelFunction(item1,null).toUpperCase();
         var typeLabel2:String = typeLabelFunction(item2,null).toUpperCase();
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
      
      override protected function measure() : void
      {
         super.measure();
         measuredWidth += 16;
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
      
      [Bindable("historyChanged")]
      public function get canNavigateBack() : Boolean
      {
         return helper.canNavigateBack;
      }
      
      override protected function childrenCreated() : void
      {
         var measuredText:String = null;
         super.childrenCreated();
         nameColumn = new CustomDataGridColumn();
         nameColumn.headerText = resourceManager.getString("aircontrols","fileSystemDataGrid_nameColumnHeader");
         nameColumn.itemRenderer = new ClassFactory(NameColumnRenderer);
         nameColumn.labelFunction = helper.fileLabelFunction;
         nameColumn.sortCompareFunction = nameSortCompareFunction;
         measuredText = resourceManager.getString("aircontrols","fileSystemDataGrid_nameColumnMeasuredText");
         nameColumn.width = determineWidthToDisplay(measuredText);
         typeColumn = new CustomDataGridColumn();
         typeColumn.headerText = resourceManager.getString("aircontrols","fileSystemDataGrid_typeColumnHeader");
         typeColumn.labelFunction = typeLabelFunction;
         typeColumn.sortCompareFunction = typeSortCompareFunction;
         measuredText = resourceManager.getString("aircontrols","fileSystemDataGrid_typeColumnMeasuredText");
         typeColumn.width = determineWidthToDisplay(measuredText);
         sizeColumn = new CustomDataGridColumn();
         sizeColumn.headerText = resourceManager.getString("aircontrols","fileSystemDataGrid_sizeColumnHeader");
         sizeColumn.labelFunction = sizeLabelFunction;
         sizeColumn.setStyle("textAlign","right");
         sizeColumn.sortCompareFunction = sizeSortCompareFunction;
         measuredText = resourceManager.getString("aircontrols","fileSystemDataGrid_sizeColumnMeasuredText");
         sizeColumn.width = determineWidthToDisplay(measuredText);
         creationDateColumn = new CustomDataGridColumn();
         creationDateColumn.headerText = resourceManager.getString("aircontrols","fileSystemDataGrid_creationDateColumnHeader");
         creationDateColumn.labelFunction = creationDateLabelFunction;
         measuredText = resourceManager.getString("aircontrols","fileSystemDataGrid_creationDateColumnMeasuredText");
         creationDateColumn.width = determineWidthToDisplay(measuredText);
         modificationDateColumn = new CustomDataGridColumn();
         modificationDateColumn.headerText = resourceManager.getString("aircontrols","fileSystemDataGrid_modificationDateColumnHeader");
         modificationDateColumn.labelFunction = modificationDateLabelFunction;
         measuredText = resourceManager.getString("aircontrols","fileSystemDataGrid_modificationDateColumnMeasuredText");
         modificationDateColumn.width = determineWidthToDisplay(measuredText);
         if(!columns || columns.length == 0)
         {
            columns = [nameColumn,typeColumn,sizeColumn,creationDateColumn,modificationDateColumn];
         }
      }
      
      public function refresh() : void
      {
         helper.refresh();
      }
      
      [Bindable("directoryChanged")]
      public function get canNavigateUp() : Boolean
      {
         return helper.canNavigateUp;
      }
      
      public function set dateFormatString(value:String) : void
      {
         dateFormatStringOverride = value;
         _dateFormatString = value != null ? value : resourceManager.getString("aircontrols","fileSystemDataGrid_dateFormatString");
         dateFormatter.formatString = _dateFormatString != null ? _dateFormatString : "";
         invalidateList();
      }
      
      [Bindable("directoryChanged")]
      public function get directory() : File
      {
         return helper.directory;
      }
      
      public function set filterFunction(value:Function) : void
      {
         helper.filterFunction = value;
      }
      
      public function get filterFunction() : Function
      {
         return helper.filterFunction;
      }
      
      public function get showExtensions() : Boolean
      {
         return helper.showExtensions;
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
            else if(sizeDisplayMode == FileSystemSizeDisplayMode.KILOBYTES)
            {
               kb = Math.ceil(item.size / 1024);
               label = resourceManager.getString("aircontrols","fileSystemDataGrid_sizeKilobytes",[kb]);
            }
            else if(sizeDisplayMode == FileSystemSizeDisplayMode.BYTES)
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
      
      public function findItem(nativePath:String) : File
      {
         return helper.findItem(nativePath);
      }
      
      private function determineWidthToDisplay(s:String) : Number
      {
         return measureText(s).width + 13;
      }
      
      public function navigateUp() : void
      {
         helper.navigateUp();
      }
   }
}

import flash.display.DisplayObject;
import flash.filesystem.File;
import mx.controls.FileSystemDataGrid;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.controls.dataGridClasses.DataGridListData;
import mx.controls.listClasses.BaseListData;
import mx.controls.listClasses.IDropInListItemRenderer;
import mx.controls.listClasses.IListItemRenderer;
import mx.controls.listClasses.ListBase;
import mx.core.IDataRenderer;
import mx.core.IFlexDisplayObject;
import mx.core.IUITextField;
import mx.core.UIComponent;
import mx.core.UITextField;
import mx.events.FlexEvent;

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

class NameColumnRenderer extends UIComponent implements IDataRenderer, IDropInListItemRenderer, IListItemRenderer
{
   
   protected var label:IUITextField;
   
   private var _listData:DataGridListData;
   
   private var _data:Object;
   
   private var listOwner:ListBase;
   
   protected var icon:IFlexDisplayObject;
   
   public function NameColumnRenderer()
   {
      super();
   }
   
   override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
   {
      var labelColor:Number = NaN;
      super.updateDisplayList(unscaledWidth,unscaledHeight);
      var startX:Number = 0;
      if(Boolean(icon))
      {
         icon.x = startX;
         startX = icon.x + icon.measuredWidth;
         icon.setActualSize(icon.measuredWidth,icon.measuredHeight);
      }
      label.x = startX;
      label.setActualSize(unscaledWidth - startX,measuredHeight);
      var verticalAlign:String = getStyle("verticalAlign");
      if(verticalAlign == "top")
      {
         label.y = 0;
         if(Boolean(icon))
         {
            icon.y = 0;
         }
      }
      else if(verticalAlign == "bottom")
      {
         label.y = unscaledHeight - label.height + 2;
         if(Boolean(icon))
         {
            icon.y = unscaledHeight - icon.height;
         }
      }
      else
      {
         label.y = (unscaledHeight - label.height) / 2;
         if(Boolean(icon))
         {
            icon.y = (unscaledHeight - icon.height) / 2;
         }
      }
      if(Boolean(data) && Boolean(parent))
      {
         if(!enabled)
         {
            labelColor = Number(getStyle("disabledColor"));
         }
         else if(listOwner.isItemHighlighted(listData.uid))
         {
            labelColor = Number(getStyle("textRollOverColor"));
         }
         else if(listOwner.isItemSelected(listData.uid))
         {
            labelColor = Number(getStyle("textSelectedColor"));
         }
         else
         {
            labelColor = Number(getStyle("color"));
         }
         label.setColor(labelColor);
      }
   }
   
   override protected function measure() : void
   {
      super.measure();
      var w:Number = 0;
      if(Boolean(icon))
      {
         w = Number(icon.measuredWidth);
      }
      if(label.width < 4 || label.height < 4)
      {
         label.width = 4;
         label.height = 16;
      }
      if(isNaN(explicitWidth))
      {
         w += label.getExplicitOrMeasuredWidth();
         measuredWidth = w;
         measuredHeight = label.getExplicitOrMeasuredHeight();
      }
      else
      {
         measuredWidth = explicitWidth;
         label.setActualSize(Math.max(explicitWidth - w,4),label.height);
         measuredHeight = label.getExplicitOrMeasuredHeight();
         if(Boolean(icon) && icon.measuredHeight > measuredHeight)
         {
            measuredHeight = icon.measuredHeight;
         }
      }
   }
   
   [Bindable("dataChange")]
   public function get data() : Object
   {
      return _data;
   }
   
   override protected function commitProperties() : void
   {
      var iconClass:Class = null;
      super.commitProperties();
      if(Boolean(icon))
      {
         removeChild(DisplayObject(icon));
         icon = null;
      }
      if(_data != null)
      {
         listOwner = ListBase(_listData.owner);
         if(FileSystemDataGrid(listOwner).showIcons)
         {
            iconClass = listOwner.getStyle(File(_data).isDirectory ? "directoryIcon" : "fileIcon");
            icon = new iconClass();
            addChild(DisplayObject(icon));
         }
         label.text = Boolean(_listData.label) ? _listData.label : " ";
         label.multiline = listOwner.variableRowHeight;
         label.wordWrap = listOwner.wordWrap;
         if(listOwner.showDataTips)
         {
            if(label.textWidth > label.width || listOwner.dataTipFunction != null)
            {
               toolTip = listOwner.itemToDataTip(_data);
            }
            else
            {
               toolTip = null;
            }
         }
         else
         {
            toolTip = null;
         }
      }
      else
      {
         label.text = " ";
         toolTip = null;
      }
   }
   
   override public function get baselinePosition() : Number
   {
      if(!validateBaselinePosition())
      {
         return NaN;
      }
      return label.y + label.baselinePosition;
   }
   
   [Bindable("dataChange")]
   public function get listData() : BaseListData
   {
      return _listData;
   }
   
   public function set listData(value:BaseListData) : void
   {
      _listData = DataGridListData(value);
      invalidateProperties();
   }
   
   public function set data(value:Object) : void
   {
      _data = value;
      invalidateProperties();
      dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
   }
   
   override protected function createChildren() : void
   {
      super.createChildren();
      if(!label)
      {
         label = IUITextField(createInFontContext(UITextField));
         label.styleName = this;
         addChild(DisplayObject(label));
      }
   }
}
