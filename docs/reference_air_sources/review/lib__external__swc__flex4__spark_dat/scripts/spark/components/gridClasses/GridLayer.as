package spark.components.gridClasses
{
   import spark.components.Grid;
   import spark.components.Group;
   import spark.layouts.supportClasses.LayoutBase;
   
   public class GridLayer extends Group
   {
      
      public function GridLayer()
      {
         super();
         layout = new LayoutBase();
      }
      
      override public function invalidateDisplayList() : void
      {
         var grid:Grid = parent as Grid;
         if(Boolean(grid) && grid.inUpdateDisplayList)
         {
            return;
         }
         if(Boolean(grid))
         {
            grid.invalidateDisplayList();
         }
      }
      
      override public function invalidateSize() : void
      {
         var grid:Grid = parent as Grid;
         if(Boolean(grid) && grid.inUpdateDisplayList)
         {
            return;
         }
         if(Boolean(grid))
         {
            grid.invalidateSize();
         }
      }
   }
}

