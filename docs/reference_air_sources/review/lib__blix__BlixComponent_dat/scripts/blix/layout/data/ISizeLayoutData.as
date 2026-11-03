package blix.layout.data
{
   import blix.layout.vo.Size;
   import blix.view.ILayoutData;
   
   public interface ISizeLayoutData extends ILayoutData
   {
      
      function getVerticalAlign() : uint;
      
      function getHorizontalAlign() : uint;
      
      function getWidthInfo(param1:Number) : Size;
      
      function getHeightInfo(param1:Number) : Size;
   }
}

