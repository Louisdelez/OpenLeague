package mx.controls.fileSystemClasses
{
   import flash.display.DisplayObject;
   import flash.filesystem.File;
   import mx.controls.FileSystemComboBox;
   import mx.controls.listClasses.ListItemRenderer;
   
   [ExcludeClass]
   public class FileSystemComboBoxRenderer extends ListItemRenderer
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
         var delta:Number = comboBox.indent * this.getNestLevel(File(data));
         if(Boolean(icon))
         {
            icon.x += delta;
         }
         label.x += delta;
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
   }
}

