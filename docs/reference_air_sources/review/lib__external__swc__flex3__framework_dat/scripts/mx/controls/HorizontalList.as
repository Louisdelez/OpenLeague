package mx.controls
{
   import mx.controls.listClasses.TileBase;
   import mx.controls.listClasses.TileBaseDirection;
   import mx.core.ScrollPolicy;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [IconFile("HorizontalList.png")]
   [DefaultTriggerEvent("change")]
   [DefaultProperty("dataProvider")]
   [DefaultBindingProperty(source="selectedItem",destination="dataProvider")]
   [Exclude(name="variableRowHeight",kind="property")]
   [Exclude(name="maxRows",kind="property")]
   [Exclude(name="maxColumns",kind="property")]
   [Exclude(name="direction",kind="property")]
   public class HorizontalList extends TileBase
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function HorizontalList()
      {
         super();
         mx_internal::_horizontalScrollPolicy = ScrollPolicy.AUTO;
         mx_internal::_verticalScrollPolicy = ScrollPolicy.OFF;
         direction = TileBaseDirection.VERTICAL;
         maxRows = 1;
         defaultRowCount = 1;
      }
   }
}

