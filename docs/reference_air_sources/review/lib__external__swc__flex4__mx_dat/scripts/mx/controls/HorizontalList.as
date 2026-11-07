package mx.controls
{
   import mx.controls.listClasses.TileBase;
   import mx.controls.listClasses.TileBaseDirection;
   import mx.core.ScrollPolicy;
   
   [Alternative(replacement="spark.components.List",since="4.0")]
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function HorizontalList()
      {
         super();
         _horizontalScrollPolicy = ScrollPolicy.AUTO;
         _verticalScrollPolicy = ScrollPolicy.OFF;
         direction = TileBaseDirection.VERTICAL;
         maxRows = 1;
         defaultRowCount = 1;
      }
   }
}

