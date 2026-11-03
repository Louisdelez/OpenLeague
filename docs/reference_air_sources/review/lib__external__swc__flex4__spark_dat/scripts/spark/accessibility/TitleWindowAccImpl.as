package spark.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.display.Sprite;
   import flash.events.Event;
   import mx.accessibility.AccConst;
   import mx.core.UIComponent;
   import mx.events.CloseEvent;
   import spark.components.TitleWindow;
   import spark.events.TitleWindowBoundsEvent;
   
   public class TitleWindowAccImpl extends PanelAccImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function TitleWindowAccImpl(master:UIComponent)
      {
         super(master);
         role = AccConst.ROLE_SYSTEM_PANE;
      }
      
      public static function enableAccessibility() : void
      {
         TitleWindow.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         var accImpl:TitleWindowAccImpl = new TitleWindowAccImpl(component);
         var accImplSprite:Sprite = accImpl.attach();
         Accessibility.sendEvent(accImplSprite,0,AccConst.EVENT_OBJECT_CREATE);
         Accessibility.updateProperties();
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat([TitleWindowBoundsEvent.WINDOW_MOVE_END,CloseEvent.CLOSE]);
      }
      
      override public function get_accState(childID:uint) : uint
      {
         var accState:uint = uint(getState(childID));
         return uint(accState | AccConst.STATE_SYSTEM_MOVEABLE);
      }
      
      override protected function eventHandler(event:Event) : void
      {
         super.eventHandler(event);
         switch(event.type)
         {
            case TitleWindowBoundsEvent.WINDOW_MOVE_END:
               Accessibility.sendEvent(accImplSprite,0,AccConst.EVENT_OBJECT_LOCATIONCHANGE,true);
               Accessibility.updateProperties();
               break;
            case CloseEvent.CLOSE:
               Accessibility.sendEvent(accImplSprite,0,AccConst.EVENT_OBJECT_DESTROY,true);
               Accessibility.updateProperties();
         }
      }
   }
}

