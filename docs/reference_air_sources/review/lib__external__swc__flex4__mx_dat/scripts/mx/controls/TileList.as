package mx.controls
{
   import mx.controls.listClasses.TileBase;
   import mx.controls.listClasses.TileListItemRenderer;
   import mx.core.ClassFactory;
   import mx.core.ScrollPolicy;
   
   [Alternative(replacement="spark.components.List",since="4.0")]
   [Effect(name="itemsChangeEffect",event="itemsChange")]
   [IconFile("TileList.png")]
   [DefaultTriggerEvent("change")]
   [DefaultProperty("dataProvider")]
   [DefaultBindingProperty(source="selectedItem",destination="dataProvider")]
   public class TileList extends TileBase
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function TileList()
      {
         super();
         _horizontalScrollPolicy = ScrollPolicy.AUTO;
         itemRenderer = new ClassFactory(TileListItemRenderer);
      }
   }
}

