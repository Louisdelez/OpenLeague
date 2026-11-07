package spark.components.gridClasses
{
   import spark.collections.SortField;
   
   [ExcludeClass]
   public class GridSortField extends SortField
   {
      
      public var dataFieldPath:String;
      
      public function GridSortField(name:String = null, descending:Boolean = false, numeric:Object = null)
      {
         super(name,descending,numeric);
      }
   }
}

