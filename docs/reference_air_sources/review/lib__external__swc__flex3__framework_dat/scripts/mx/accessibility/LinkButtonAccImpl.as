package mx.accessibility
{
   import mx.controls.LinkButton;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class LinkButtonAccImpl extends ButtonAccImpl
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function LinkButtonAccImpl(master:UIComponent)
      {
         super(master);
         role = 30;
      }
      
      public static function enableAccessibility() : void
      {
         LinkButton.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      mx_internal static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new LinkButtonAccImpl(component);
      }
      
      override public function get_accDefaultAction(childID:uint) : String
      {
         return "Jump";
      }
   }
}

