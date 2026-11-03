package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.containers.Panel;
   import mx.containers.TitleWindow;
   import mx.core.UIComponent;
   
   public class TitleWindowAccImpl extends PanelAccImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function TitleWindowAccImpl(master:UIComponent)
      {
         super(master);
         Panel(master).getTitleBar().addEventListener(MouseEvent.MOUSE_UP,this.eventHandler);
         Panel(master).closeButton.addEventListener(MouseEvent.MOUSE_UP,this.eventHandler);
      }
      
      public static function enableAccessibility() : void
      {
         TitleWindow.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         var titleBar:UIComponent = TitleWindow(component).getTitleBar();
         titleBar.accessibilityImplementation = new TitleWindowAccImpl(component);
         Accessibility.sendEvent(titleBar,0,AccConst.EVENT_OBJECT_CREATE);
         Accessibility.updateProperties();
      }
      
      override public function get_accState(childID:uint) : uint
      {
         var accState:uint = uint(getState(childID));
         return uint(accState | AccConst.STATE_SYSTEM_MOVEABLE);
      }
      
      override protected function eventHandler(event:Event) : void
      {
         $eventHandler(event);
         switch(event.type)
         {
            case MouseEvent.MOUSE_UP:
               if(event.target == Panel(master).getTitleBar())
               {
                  Accessibility.sendEvent(Panel(master).getTitleBar(),0,AccConst.EVENT_OBJECT_LOCATIONCHANGE,true);
               }
               if(event.target == Panel(master).closeButton)
               {
                  Accessibility.sendEvent(Panel(master).getTitleBar(),0,AccConst.EVENT_OBJECT_DESTROY,true);
               }
               Accessibility.updateProperties();
         }
      }
   }
}

