package spark.accessibility
{
   import mx.core.UIComponent;
   import spark.components.List;
   
   public class ListAccImpl extends ListBaseAccImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function ListAccImpl(master:UIComponent)
      {
         super(master);
      }
      
      public static function enableAccessibility() : void
      {
         List.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new ListAccImpl(component);
      }
   }
}

