package mx.controls.advancedDataGridClasses
{
   import flash.events.Event;
   
   [DefaultProperty("children")]
   public class AdvancedDataGridColumnGroup extends AdvancedDataGridColumn
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _width:Number = 100;
      
      public var childrenDragEnabled:Boolean = true;
      
      public var children:Array = [];
      
      public function AdvancedDataGridColumnGroup(columnName:String = null)
      {
         super(columnName);
      }
      
      override protected function copyProperties(col:AdvancedDataGridColumn) : void
      {
         super.copyProperties(col);
         AdvancedDataGridColumnGroup(col).childrenDragEnabled = childrenDragEnabled;
      }
      
      override public function clone() : AdvancedDataGridColumn
      {
         var col:AdvancedDataGridColumnGroup = new AdvancedDataGridColumnGroup();
         copyProperties(col);
         for(var i:int = 0; i < children.length; i++)
         {
            col.children[i] = children[i].clone();
         }
         return col;
      }
      
      override public function get width() : Number
      {
         if(Boolean(this.children) && this.children.length > 0)
         {
            return _width;
         }
         return super.width;
      }
      
      public function itemToData(data:Object) : *
      {
         if(!data)
         {
            return null;
         }
         if(labelFunction != null)
         {
            data = labelFunction(data,this);
            return data;
         }
         if(typeof data == "object" || typeof data == "xml")
         {
            try
            {
               if(dataField != null)
               {
                  data = data[dataField];
               }
            }
            catch(e:Error)
            {
               data = null;
            }
         }
         return data;
      }
      
      override public function set width(value:Number) : void
      {
         if(Boolean(this.children) && this.children.length > 0)
         {
            _width = value;
            dispatchEvent(new Event("widthChanged"));
         }
         else
         {
            super.width = value;
         }
      }
   }
}

