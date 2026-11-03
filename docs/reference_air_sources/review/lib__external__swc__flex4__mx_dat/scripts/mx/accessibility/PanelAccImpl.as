package mx.accessibility
{
   import mx.containers.Panel;
   import mx.core.UIComponent;
   
   public class PanelAccImpl extends AccImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function PanelAccImpl(master:UIComponent)
      {
         super(master);
         role = AccConst.ROLE_SYSTEM_GROUPING;
      }
      
      public static function enableAccessibility() : void
      {
         Panel.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         var titleBar:UIComponent = Panel(component).getTitleBar();
         titleBar.accessibilityImplementation = new PanelAccImpl(component);
      }
      
      override public function get_accState(childID:uint) : uint
      {
         return uint(getState(childID));
      }
      
      override protected function getName(childID:uint) : String
      {
         return Panel(master).title;
      }
   }
}

