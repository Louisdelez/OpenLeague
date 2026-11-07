package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import mx.controls.ComboBase;
   import mx.core.UIComponent;
   
   public class ComboBaseAccImpl extends AccImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function ComboBaseAccImpl(master:UIComponent)
      {
         super(master);
         role = AccConst.ROLE_SYSTEM_COMBOBOX;
      }
      
      public static function enableAccessibility() : void
      {
         ComboBase.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new ComboBaseAccImpl(component);
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat(["change","valueCommit"]);
      }
      
      override public function get_accRole(childID:uint) : uint
      {
         return childID == 0 ? uint(role) : uint(AccConst.ROLE_SYSTEM_LISTITEM);
      }
      
      override public function get_accValue(childID:uint) : String
      {
         if(childID == 0)
         {
            return ComboBase(master).text;
         }
         return null;
      }
      
      override public function get_accState(childID:uint) : uint
      {
         var accState:uint = uint(getState(childID));
         if(childID > 0)
         {
            accState |= AccConst.STATE_SYSTEM_SELECTABLE;
            if(ComboBase(master).selectedIndex == childID - 1)
            {
               accState |= AccConst.STATE_SYSTEM_SELECTED | AccConst.STATE_SYSTEM_FOCUSED;
            }
         }
         return accState;
      }
      
      override public function getChildIDArray() : Array
      {
         var n:int = Boolean(ComboBase(master).dataProvider) ? int(ComboBase(master).dataProvider.length) : 0;
         return createChildIDArray(n);
      }
      
      override protected function eventHandler(event:Event) : void
      {
         var index:int = 0;
         var childID:uint = 0;
         $eventHandler(event);
         switch(event.type)
         {
            case "change":
               index = ComboBase(master).selectedIndex;
               if(index >= 0)
               {
                  childID = index + 1;
                  Accessibility.sendEvent(master,childID,AccConst.EVENT_OBJECT_SELECTION);
                  Accessibility.sendEvent(master,0,AccConst.EVENT_OBJECT_VALUECHANGE);
               }
               break;
            case "valueCommit":
               Accessibility.sendEvent(master,0,AccConst.EVENT_OBJECT_VALUECHANGE);
         }
      }
   }
}

