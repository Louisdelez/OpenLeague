package mx.accessibility
{
   import mx.containers.Panel;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class PanelAccImpl extends AccImpl
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function PanelAccImpl(master:UIComponent)
      {
         super(master);
         role = 20;
      }
      
      public static function enableAccessibility() : void
      {
         Panel.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      mx_internal static function createAccessibilityImplementation(component:UIComponent) : void
      {
         var titleBar:UIComponent = Panel(component).getTitleBar();
         titleBar.accessibilityImplementation = new PanelAccImpl(component);
      }
      
      override protected function getName(childID:uint) : String
      {
         return Panel(master).title;
      }
      
      override public function get_accState(childID:uint) : uint
      {
         return getState(childID);
      }
   }
}

