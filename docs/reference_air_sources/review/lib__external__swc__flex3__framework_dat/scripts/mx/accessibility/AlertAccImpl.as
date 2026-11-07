package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.accessibility.AccessibilityProperties;
   import flash.events.Event;
   import mx.controls.Alert;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.managers.SystemManager;
   
   use namespace mx_internal;
   
   public class AlertAccImpl extends TitleWindowAccImpl
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function AlertAccImpl(master:UIComponent)
      {
         super(master);
         role = 8;
      }
      
      public static function enableAccessibility() : void
      {
         Alert.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      mx_internal static function createAccessibilityImplementation(component:UIComponent) : void
      {
         var titleBar:UIComponent = Alert(component).getTitleBar();
         var titleBarAccImpl:AlertAccImpl = new AlertAccImpl(component);
         titleBar.accessibilityImplementation = titleBarAccImpl;
      }
      
      override protected function eventHandler(event:Event) : void
      {
         var titleBar:UIComponent = null;
         $eventHandler(event);
         switch(event.type)
         {
            case "close":
               titleBar = Alert(master).getTitleBar();
               SystemManager(master.parent).document.accessibilityProperties.silent = false;
               Accessibility.updateProperties();
               Accessibility.sendEvent(titleBar,0,17);
               Accessibility.sendEvent(titleBar,0,32772);
               Accessibility.sendEvent(titleBar,0,32769);
               Accessibility.sendEvent(titleBar,0,32779);
               Accessibility.sendEvent(titleBar,0,32783);
               Accessibility.sendEvent(titleBar,0,3);
               Accessibility.sendEvent(titleBar,0,3);
               if(Boolean(SystemManager(master.parent).stage.focus))
               {
                  Accessibility.sendEvent(SystemManager(master.parent).stage.focus,0,32773);
               }
               break;
            case "creationComplete":
               if(!SystemManager(master.parent).document.accessibilityProperties)
               {
                  SystemManager(master.parent).document.accessibilityProperties = new AccessibilityProperties();
               }
               SystemManager(master.parent).document.accessibilityProperties.silent = true;
               master.$visible = true;
               titleBar = Alert(master).getTitleBar();
               titleBar.tabIndex = 0;
               Alert(master).alertForm.textField.tabIndex = 0;
               UIComponent(titleBar).$visible = true;
               Accessibility.updateProperties();
               Accessibility.sendEvent(titleBar,0,16);
               Accessibility.sendEvent(titleBar,0,32772);
               Accessibility.sendEvent(titleBar,0,32768);
               Accessibility.sendEvent(titleBar,0,32779);
               Accessibility.sendEvent(titleBar,0,32783);
               Accessibility.sendEvent(titleBar,0,2);
               Accessibility.sendEvent(titleBar,0,3);
               Accessibility.sendEvent(titleBar,0,32773);
               Accessibility.sendEvent(Alert(master).alertForm.defaultButton,0,32773);
         }
      }
      
      override protected function getName(childID:uint) : String
      {
         return Alert(master).title + ", " + Alert(master).text;
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat(["close","creationComplete"]);
      }
   }
}

