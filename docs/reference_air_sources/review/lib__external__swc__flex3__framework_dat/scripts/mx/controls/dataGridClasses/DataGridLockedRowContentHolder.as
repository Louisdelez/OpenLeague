package mx.controls.dataGridClasses
{
   import mx.controls.listClasses.ListBase;
   import mx.controls.listClasses.ListBaseContentHolder;
   
   public class DataGridLockedRowContentHolder extends ListBaseContentHolder
   {
      
      public function DataGridLockedRowContentHolder(parentList:ListBase)
      {
         super(parentList);
         if(Boolean(parentList.dataProvider))
         {
            iterator = parentList.dataProvider.createCursor();
         }
      }
      
      override public function get measuredHeight() : Number
      {
         var rc:Number = rowInfo.length;
         if(rc == 0)
         {
            return 0;
         }
         return rowInfo[rc - 1].y + rowInfo[rc - 1].height;
      }
   }
}

