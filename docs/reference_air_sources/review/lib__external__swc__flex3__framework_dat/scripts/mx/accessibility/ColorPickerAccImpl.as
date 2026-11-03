package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import mx.collections.CursorBookmark;
   import mx.collections.IViewCursor;
   import mx.controls.ColorPicker;
   import mx.controls.ComboBase;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.DropdownEvent;
   
   use namespace mx_internal;
   
   public class ColorPickerAccImpl extends ComboBaseAccImpl
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static const EVENT_OBJECT_VALUECHANGE:uint = 32782;
      
      private static const EVENT_OBJECT_SELECTION:uint = 32774;
      
      private static const STATE_SYSTEM_FOCUSED:uint = 4;
      
      private static const STATE_SYSTEM_SELECTABLE:uint = 2097152;
      
      private static const STATE_SYSTEM_SELECTED:uint = 2;
      
      public function ColorPickerAccImpl(master:UIComponent)
      {
         super(master);
         master.accessibilityProperties.description = "Color Picker";
         Accessibility.updateProperties();
         ColorPicker(master).addEventListener(DropdownEvent.OPEN,openHandler);
         ColorPicker(master).addEventListener(DropdownEvent.CLOSE,closeHandler);
      }
      
      mx_internal static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new ColorPickerAccImpl(component);
      }
      
      public static function enableAccessibility() : void
      {
         ColorPicker.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      private function openHandler(event:Event) : void
      {
         ColorPicker(master).dropdown.addEventListener("change",dropdown_changeHandler);
      }
      
      override protected function getName(childID:uint) : String
      {
         var str:String = null;
         var x:String = null;
         if(childID == 0)
         {
            return "";
         }
         var colorPicker:ColorPicker = ColorPicker(master);
         var iterator:IViewCursor = colorPicker.collectionIterator;
         iterator.seek(CursorBookmark.FIRST,childID - 1);
         var item:Object = iterator.current;
         if(typeof item != "object")
         {
            str = item.toString(16);
            return formatColorString(str);
         }
         return !item.label ? item.data : item.label;
      }
      
      private function closeHandler(event:Event) : void
      {
         ColorPicker(master).dropdown.removeEventListener("change",dropdown_changeHandler);
      }
      
      override protected function eventHandler(event:Event) : void
      {
         var index:int = 0;
         $eventHandler(event);
         switch(event.type)
         {
            case "childChange":
               index = ComboBase(master).selectedIndex;
               Accessibility.sendEvent(master,ColorPicker(master).dropdown.focusedIndex + 1,EVENT_OBJECT_SELECTION);
               Accessibility.sendEvent(master,0,EVENT_OBJECT_VALUECHANGE,true);
               break;
            case "valueCommit":
               Accessibility.sendEvent(master,0,EVENT_OBJECT_VALUECHANGE);
         }
      }
      
      override public function get_accValue(childID:uint) : String
      {
         if(ColorPicker(master).showingDropdown)
         {
            return Boolean(ColorPicker(master).dropdown) ? ColorPicker(master).dropdown.textInput.text : null;
         }
         return ColorPicker(master).selectedColor.toString(16);
      }
      
      override public function get_accState(childID:uint) : uint
      {
         var accState:uint = getState(childID);
         if(childID > 0)
         {
            accState |= STATE_SYSTEM_SELECTABLE;
            accState |= STATE_SYSTEM_SELECTED | STATE_SYSTEM_FOCUSED;
         }
         return accState;
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat(["childChange"]);
      }
      
      private function dropdown_changeHandler(event:Event) : void
      {
         master.dispatchEvent(new Event("childChange"));
      }
      
      private function formatColorString(color:String) : String
      {
         var str2:String = "";
         var n:int = color.length;
         for(var i:uint = 0; i < n; i++)
         {
            str2 += color.charAt(i) + " ";
         }
         return str2;
      }
      
      override public function getChildIDArray() : Array
      {
         var n:int = Boolean(ColorPicker(master).dropdown) ? ColorPicker(master).dropdown.length : 0;
         return createChildIDArray(n);
      }
   }
}

