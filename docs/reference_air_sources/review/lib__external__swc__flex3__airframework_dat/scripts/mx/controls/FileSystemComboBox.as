package mx.controls
{
   import flash.events.Event;
   import flash.filesystem.File;
   import flash.text.TextLineMetrics;
   import mx.collections.CursorBookmark;
   import mx.controls.fileSystemClasses.FileSystemControlHelper;
   import mx.core.ClassFactory;
   import mx.events.FileEvent;
   
   [ResourceBundle("aircontrols")]
   [IconFile("FileSystemComboBox.png")]
   [Style(name="directoryIcon",type="Class",format="EmbeddedFile",inherit="no")]
   [Style(name="computerIcon",type="Class",format="EmbeddedFile",inherit="no")]
   [Event(name="directoryChange",type="mx.events.FileEvent")]
   [Exclude(name="editableUpSkin",kind="style")]
   [Exclude(name="editableOverSkin",kind="style")]
   [Exclude(name="editableDownSkin",kind="style")]
   [Exclude(name="editableDisabledSkin",kind="style")]
   [Exclude(name="editable",kind="property")]
   public class FileSystemComboBox extends ComboBox
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.6.0.12937";
      
      public static const COMPUTER:File = FileSystemControlHelper.COMPUTER;
      
      private var directoryChanged:Boolean = false;
      
      private var _indent:int = 8;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var helper:FileSystemControlHelper;
      
      private var _directory:File;
      
      private var _showIcons:Boolean = true;
      
      public function FileSystemComboBox()
      {
         super();
         helper = new FileSystemControlHelper(this,false);
         itemRenderer = new ClassFactory(FileSystemComboBoxRenderer);
         labelFunction = helper.fileLabelFunction;
         rowCount = 10;
         addEventListener(Event.CHANGE,changeHandler);
         directory = COMPUTER;
      }
      
      public function set showIcons(value:Boolean) : void
      {
         _showIcons = value;
      }
      
      public function get showIcons() : Boolean
      {
         return _showIcons;
      }
      
      private function getParentChain(file:File) : Array
      {
         if(helper.isComputer(file))
         {
            return [file];
         }
         var a:Array = [];
         for(var f:File = file; f != null; f = f.parent)
         {
            a.unshift(f);
         }
         a.unshift(COMPUTER);
         return a;
      }
      
      private function changeHandler(event:Event) : void
      {
         directory = File(selectedItem);
      }
      
      override protected function commitProperties() : void
      {
         var event:FileEvent = null;
         super.commitProperties();
         if(directoryChanged)
         {
            dataProvider = getParentChain(_directory);
            selectedItem = _directory;
            event = new FileEvent(FileEvent.DIRECTORY_CHANGE);
            event.file = _directory;
            dispatchEvent(event);
            directoryChanged = false;
         }
      }
      
      public function get indent() : int
      {
         return _indent;
      }
      
      [Bindable("directoryChanged")]
      public function get directory() : File
      {
         return _directory;
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         invalidateSize();
         invalidateDisplayList();
         selectedIndex = selectedIndex;
      }
      
      override protected function calculatePreferredSizeFromData(count:int) : Object
      {
         var lineMetrics:TextLineMetrics = null;
         var data:Object = null;
         var txt:String = null;
         var maxW:Number = 0;
         var maxH:Number = 0;
         var bookmark:CursorBookmark = Boolean(iterator) ? iterator.bookmark : null;
         iterator.seek(CursorBookmark.FIRST,0);
         var more:Boolean = iterator != null;
         for(var i:int = 0; i < count; i++)
         {
            if(more)
            {
               data = Boolean(iterator) ? iterator.current : null;
            }
            else
            {
               data = null;
            }
            txt = itemToLabel(data);
            lineMetrics = measureText(txt);
            lineMetrics.width += i * indent;
            maxW = Math.max(maxW,lineMetrics.width);
            maxH = Math.max(maxH,lineMetrics.height);
            if(Boolean(iterator))
            {
               iterator.moveNext();
            }
         }
         if(Boolean(prompt))
         {
            lineMetrics = measureText(prompt);
            maxW = Math.max(maxW,lineMetrics.width);
            maxH = Math.max(maxH,lineMetrics.height);
         }
         maxW += getStyle("paddingLeft") + getStyle("paddingRight");
         if(Boolean(iterator))
         {
            iterator.seek(bookmark,0);
         }
         return {
            "width":maxW,
            "height":maxH
         };
      }
      
      public function set indent(value:int) : void
      {
         _indent = value;
      }
      
      public function set directory(value:File) : void
      {
         _directory = value;
         directoryChanged = true;
         invalidateProperties();
         dispatchEvent(new Event("directoryChanged"));
      }
   }
}

import flash.display.DisplayObject;
import flash.filesystem.File;
import mx.controls.FileSystemComboBox;
import mx.controls.listClasses.ListItemRenderer;

class FileSystemComboBoxRenderer extends ListItemRenderer
{
   
   public function FileSystemComboBoxRenderer()
   {
      super();
   }
   
   override protected function commitProperties() : void
   {
      super.commitProperties();
      if(!listData || !data)
      {
         return;
      }
      var comboBox:FileSystemComboBox = FileSystemComboBox(listData.owner.owner);
      if(!comboBox.showIcons)
      {
         return;
      }
      var iconClass:Class = comboBox.getStyle(comboBox.helper.isComputer(File(data)) ? "computerIcon" : "directoryIcon");
      if(Boolean(iconClass))
      {
         icon = new iconClass();
         addChild(DisplayObject(icon));
      }
   }
   
   private function getNestLevel(item:File) : int
   {
      if(!item || !item.exists)
      {
         return 0;
      }
      var nestLevel:int = 0;
      for(var f:File = item; f != null; f = f.parent)
      {
         nestLevel++;
      }
      return nestLevel;
   }
   
   override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
   {
      super.updateDisplayList(unscaledWidth,unscaledHeight);
      if(!listData || !data)
      {
         return;
      }
      var comboBox:FileSystemComboBox = FileSystemComboBox(listData.owner.owner);
      if(comboBox.indent == 0)
      {
         return;
      }
      var delta:Number = comboBox.indent * getNestLevel(File(data));
      if(Boolean(icon))
      {
         icon.x += delta;
      }
      label.x += delta;
   }
}
