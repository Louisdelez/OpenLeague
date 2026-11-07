package spark.accessibility
{
   import mx.accessibility.AccConst;
   import mx.core.UIComponent;
   import spark.components.TabBar;
   
   public class TabBarAccImpl extends ButtonBarBaseAccImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function TabBarAccImpl(master:UIComponent)
      {
         super(master);
         role = AccConst.ROLE_SYSTEM_PAGETABLIST;
      }
      
      public static function enableAccessibility() : void
      {
         TabBar.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new TabBarAccImpl(component);
      }
      
      override public function get_accRole(childID:uint) : uint
      {
         return childID == 0 ? uint(role) : uint(AccConst.ROLE_SYSTEM_PAGETAB);
      }
      
      override public function get_accDefaultAction(childID:uint) : String
      {
         if(childID == 0)
         {
            return null;
         }
         return "Switch";
      }
   }
}

