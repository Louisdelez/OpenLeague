package mx.controls.dataGridClasses
{
   import mx.controls.listClasses.MXItemRenderer;
   
   [Exclude(name="listData",kind="property")]
   public class MXDataGridItemRenderer extends MXItemRenderer
   {
      
      public function MXDataGridItemRenderer()
      {
         super();
      }
      
      [Bindable("dataChange")]
      public function get dataGridListData() : DataGridListData
      {
         return listData as DataGridListData;
      }
   }
}

