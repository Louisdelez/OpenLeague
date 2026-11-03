package mx.accessibility
{
   import mx.controls.LinkButton;
   import mx.core.UIComponent;
   
   public class LinkButtonAccImpl extends ButtonAccImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function LinkButtonAccImpl(master:UIComponent)
      {
         super(master);
         role = AccConst.ROLE_SYSTEM_LINK;
      }
      
      public static function enableAccessibility() : void
      {
         LinkButton.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new LinkButtonAccImpl(component);
      }
      
      override public function get_accDefaultAction(childID:uint) : String
      {
         return "Jump";
      }
   }
}

