package spark.components
{
   import mx.managers.IFocusManagerComponent;
   import spark.components.supportClasses.ButtonBarBase;
   
   [DiscouragedForProfile("mobileDevice")]
   [IconFile("TabBar.png")]
   [AccessibilityClass(implementation="spark.accessibility.TabBarAccImpl")]
   [Style(name="cornerRadius",type="Number",format="Length",inherit="no",theme="spark")]
   public class TabBar extends ButtonBarBase implements IFocusManagerComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var _skinParts:Object = {"dataGroup":false};
      
      public function TabBar()
      {
         super();
         requireSelection = true;
         mouseFocusEnabled = false;
      }
      
      override protected function initializeAccessibility() : void
      {
         if(TabBar.createAccessibilityImplementation != null)
         {
            TabBar.createAccessibilityImplementation(this);
         }
      }
   }
}

