package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import mx.controls.Alert;
   import mx.core.UIComponent;
   import mx.managers.ISystemManager;
   
   public class AlertAccImpl extends TitleWindowAccImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function AlertAccImpl(master:UIComponent)
      {
         super(master);
         role = AccConst.ROLE_SYSTEM_ALERT;
      }
      
      public static function enableAccessibility() : void
      {
         Alert.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         var titleBar:UIComponent = Alert(component).getTitleBar();
         var titleBarAccImpl:AlertAccImpl = new AlertAccImpl(component);
         titleBar.accessibilityImplementation = titleBarAccImpl;
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat(["close","creationComplete"]);
      }
      
      override protected function getName(childID:uint) : String
      {
         return Alert(master).title + ", " + Alert(master).text;
      }
      
      override protected function eventHandler(event:Event) : void
      {
         var titleBar:UIComponent = null;
         $eventHandler(event);
         var systemManager:ISystemManager = ISystemManager(master.parent);
         switch(event.type)
         {
            case "close":
               titleBar = Alert(master).getTitleBar();
               Accessibility.sendEvent(titleBar,0,AccConst.EVENT_SYSTEM_DIALOGEND);
               Accessibility.sendEvent(titleBar,0,AccConst.EVENT_OBJECT_REORDER);
               Accessibility.sendEvent(titleBar,0,AccConst.EVENT_OBJECT_DESTROY);
               Accessibility.sendEvent(titleBar,0,AccConst.EVENT_OBJECT_LOCATIONCHANGE);
               Accessibility.sendEvent(titleBar,0,AccConst.EVENT_OBJECT_PARENTCHANGE);
               Accessibility.sendEvent(titleBar,0,AccConst.EVENT_OBJECT_HIDE);
               Accessibility.sendEvent(titleBar,0,AccConst.EVENT_SYSTEM_FOREGROUND);
               if(Boolean(systemManager.stage.focus))
               {
                  Accessibility.sendEvent(systemManager.stage.focus,0,AccConst.EVENT_OBJECT_FOCUS);
               }
               break;
            case "creationComplete":
               master.$visible = true;
               titleBar = Alert(master).getTitleBar();
               titleBar.tabIndex = 0;
               Alert(master).alertForm.textField.tabIndex = 0;
               UIComponent(titleBar).$visible = true;
               Accessibility.sendEvent(titleBar,0,AccConst.EVENT_SYSTEM_DIALOGSTART);
               Accessibility.sendEvent(titleBar,0,AccConst.EVENT_OBJECT_REORDER);
               Accessibility.sendEvent(titleBar,0,AccConst.EVENT_OBJECT_CREATE);
               Accessibility.sendEvent(titleBar,0,AccConst.EVENT_OBJECT_LOCATIONCHANGE);
               Accessibility.sendEvent(titleBar,0,AccConst.EVENT_OBJECT_PARENTCHANGE);
               Accessibility.sendEvent(titleBar,0,AccConst.EVENT_OBJECT_SHOW);
               Accessibility.sendEvent(titleBar,0,AccConst.EVENT_SYSTEM_FOREGROUND);
               Accessibility.sendEvent(titleBar,0,AccConst.EVENT_OBJECT_FOCUS);
               Accessibility.sendEvent(Alert(master).alertForm.defaultButton,0,AccConst.EVENT_OBJECT_FOCUS);
         }
      }
   }
}

