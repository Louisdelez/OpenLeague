package blix.layout.data
{
   import blix.view.ILayoutData;
   
   public interface IConstraintLayoutData extends ILayoutData
   {
      
      function getTop() : Number;
      
      function getRight() : Number;
      
      function getBottom() : Number;
      
      function getLeft() : Number;
      
      function getHorizontalCenter() : Number;
      
      function getVerticalCenter() : Number;
   }
}

