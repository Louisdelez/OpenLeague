package mx.controls
{
   import mx.controls.listClasses.TileBase;
   import mx.controls.listClasses.TileListItemRenderer;
   import mx.core.ClassFactory;
   import mx.core.ScrollPolicy;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [Effect(name="itemsChangeEffect",event="itemsChange")]
   [IconFile("TileList.png")]
   [DefaultTriggerEvent("change")]
   [DefaultProperty("dataProvider")]
   [DefaultBindingProperty(source="selectedItem",destination="dataProvider")]
   public class TileList extends TileBase
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function TileList()
      {
         super();
         mx_internal::_horizontalScrollPolicy = ScrollPolicy.AUTO;
         itemRenderer = new ClassFactory(TileListItemRenderer);
      }
   }
}

