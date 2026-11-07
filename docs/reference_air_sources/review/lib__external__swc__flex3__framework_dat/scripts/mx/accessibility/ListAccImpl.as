package mx.accessibility
{
   import mx.controls.List;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class ListAccImpl extends ListBaseAccImpl
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function ListAccImpl(master:UIComponent)
      {
         super(master);
      }
      
      public static function enableAccessibility() : void
      {
         List.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      mx_internal static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new ListAccImpl(component);
      }
   }
}

