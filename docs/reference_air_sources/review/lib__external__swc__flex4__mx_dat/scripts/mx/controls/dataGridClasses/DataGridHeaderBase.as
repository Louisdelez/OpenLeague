package mx.controls.dataGridClasses
{
   import flash.display.Sprite;
   import mx.core.UIComponent;
   
   public class DataGridHeaderBase extends UIComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var selectionLayer:Sprite;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var visibleColumns:Array;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var headerItemsChanged:Boolean = false;
      
      public function DataGridHeaderBase()
      {
         super();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function clearSelectionLayer() : void
      {
      }
   }
}

