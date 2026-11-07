package mx.controls.advancedDataGridClasses
{
   import mx.core.IFactory;
   
   public class AdvancedDataGridRendererProvider implements IAdvancedDataGridRendererProvider
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      public var columnSpan:int = 1;
      
      public var renderer:IFactory;
      
      public var rowSpan:int = 1;
      
      public var depth:int = -1;
      
      public var dataField:String;
      
      public var column:AdvancedDataGridColumn;
      
      public var columnIndex:int = -1;
      
      public function AdvancedDataGridRendererProvider()
      {
         super();
      }
      
      public function describeRendererForItem(data:Object, dataDepth:int, column:AdvancedDataGridColumn, description:AdvancedDataGridRendererDescription) : void
      {
         if(checkMatch(data,dataDepth,column))
         {
            description.columnSpan = this.columnSpan;
            description.renderer = this.renderer;
         }
      }
      
      protected function checkMatch(data:Object, dataDepth:int, column:AdvancedDataGridColumn) : Boolean
      {
         var matching:Boolean = true;
         if(Boolean(dataField) && (!data || !data.hasOwnProperty(dataField)))
         {
            matching = false;
         }
         if(columnIndex != -1 && columnIndex != column.colNum)
         {
            matching = false;
         }
         if(depth != -1 && dataDepth != depth)
         {
            matching = false;
         }
         if(Boolean(this.column) && this.column != column)
         {
            matching = false;
         }
         return matching;
      }
   }
}

