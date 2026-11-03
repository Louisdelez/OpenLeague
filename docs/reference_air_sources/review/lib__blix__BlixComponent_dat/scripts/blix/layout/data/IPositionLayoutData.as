package blix.layout.data
{
   import blix.layout.vo.Size;
   import blix.view.ILayoutData;
   
   public interface IPositionLayoutData extends ILayoutData
   {
      
      function getXInfo(param1:Number) : Size;
      
      function getYInfo(param1:Number) : Size;
   }
}

