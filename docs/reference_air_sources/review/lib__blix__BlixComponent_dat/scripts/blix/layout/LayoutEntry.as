package blix.layout
{
   import blix.view.ILayoutData;
   import blix.view.ILayoutElement;
   
   public class LayoutEntry
   {
      
      public var element:ILayoutElement;
      
      public var data:ILayoutData;
      
      public function LayoutEntry(param1:ILayoutElement, param2:ILayoutData)
      {
         super();
         this.element = param1;
         this.data = param2;
      }
   }
}

