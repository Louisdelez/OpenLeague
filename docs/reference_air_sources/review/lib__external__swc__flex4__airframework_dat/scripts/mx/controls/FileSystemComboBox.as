package mx.controls
{
   import flash.events.Event;
   import flash.filesystem.File;
   import flash.text.TextLineMetrics;
   import mx.collections.CursorBookmark;
   import mx.controls.fileSystemClasses.FileSystemComboBoxRenderer;
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public static const COMPUTER:File = FileSystemControlHelper.COMPUTER;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var helper:FileSystemControlHelper;
      
      private var _directory:File;
      
      private var directoryChanged:Boolean = false;
      
      private var _indent:int = 8;
      
      private var _showIcons:Boolean = true;
      
      public function FileSystemComboBox()
      {
         super();
         this.helper = new FileSystemControlHelper(this,false);
         itemRenderer = new ClassFactory(FileSystemComboBoxRenderer);
         labelFunction = this.helper.fileLabelFunction;
         rowCount = 10;
         addEventListener(Event.CHANGE,this.changeHandler);
         this.directory = COMPUTER;
      }
      
      [Bindable("directoryChanged")]
      public function get directory() : File
      {
         return this._directory;
      }
      
      public function set directory(value:File) : void
      {
         this._directory = value;
         this.directoryChanged = true;
         invalidateProperties();
         dispatchEvent(new Event("directoryChanged"));
      }
      
      public function get indent() : int
      {
         return this._indent;
      }
      
      public function set indent(value:int) : void
      {
         this._indent = value;
      }
      
      public function get showIcons() : Boolean
      {
         return this._showIcons;
      }
      
      public function set showIcons(value:Boolean) : void
      {
         this._showIcons = value;
      }
      
      override protected function commitProperties() : void
      {
         var event:FileEvent = null;
         super.commitProperties();
         if(this.directoryChanged)
         {
            dataProvider = this.getParentChain(this._directory);
            selectedItem = this._directory;
            event = new FileEvent(FileEvent.DIRECTORY_CHANGE);
            event.file = this._directory;
            dispatchEvent(event);
            this.directoryChanged = false;
         }
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
            lineMetrics.width += i * this.indent;
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
      
      private function getParentChain(file:File) : Array
      {
         if(this.helper.isComputer(file))
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
         this.directory = File(selectedItem);
      }
   }
}

