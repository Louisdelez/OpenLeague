package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.containers.Panel;
   import mx.containers.TitleWindow;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class TitleWindowAccImpl extends PanelAccImpl
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static const STATE_SYSTEM_MOVEABLE:uint = 262144;
      
      private static const EVENT_OBJECT_CREATE:uint = 32768;
      
      private static const EVENT_OBJECT_DESTROY:uint = 32769;
      
      private static const EVENT_OBJECT_LOCATIONCHANGE:uint = 32779;
      
      public function TitleWindowAccImpl(master:UIComponent)
      {
         super(master);
         Panel(master).getTitleBar().addEventListener(MouseEvent.MOUSE_UP,eventHandler);
         Panel(master).closeButton.addEventListener(MouseEvent.MOUSE_UP,eventHandler);
      }
      
      mx_internal static function createAccessibilityImplementation(component:UIComponent) : void
      {
         var titleBar:UIComponent = TitleWindow(component).getTitleBar();
         titleBar.accessibilityImplementation = new TitleWindowAccImpl(component);
         Accessibility.sendEvent(titleBar,0,EVENT_OBJECT_CREATE);
         Accessibility.updateProperties();
      }
      
      public static function enableAccessibility() : void
      {
         TitleWindow.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      override protected function eventHandler(event:Event) : void
      {
         $eventHandler(event);
         switch(event.type)
         {
            case MouseEvent.MOUSE_UP:
               if(event.target == Panel(master).getTitleBar())
               {
                  Accessibility.sendEvent(Panel(master).getTitleBar(),0,EVENT_OBJECT_LOCATIONCHANGE,true);
               }
               if(event.target == Panel(master).closeButton)
               {
                  Accessibility.sendEvent(Panel(master).getTitleBar(),0,EVENT_OBJECT_DESTROY,true);
               }
               Accessibility.updateProperties();
         }
      }
      
      override public function get_accState(childID:uint) : uint
      {
         var accState:uint = getState(childID);
         return uint(accState | STATE_SYSTEM_MOVEABLE);
      }
   }
}

