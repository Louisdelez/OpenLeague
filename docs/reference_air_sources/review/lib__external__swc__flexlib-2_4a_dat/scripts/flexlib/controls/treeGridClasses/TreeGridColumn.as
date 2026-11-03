package flexlib.controls.treeGridClasses
{
   import mx.controls.dataGridClasses.DataGridColumn;
   import mx.core.ClassFactory;
   
   public class TreeGridColumn extends DataGridColumn
   {
      
      public function TreeGridColumn()
      {
         super();
         itemRenderer = new ClassFactory(TreeGridItemRenderer);
      }
   }
}

