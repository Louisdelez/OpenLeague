package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import mx.collections.CursorBookmark;
   import mx.collections.IViewCursor;
   import mx.controls.ColorPicker;
   import mx.controls.ComboBase;
   import mx.core.UIComponent;
   import mx.events.DropdownEvent;
   
   public class ColorPickerAccImpl extends ComboBaseAccImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function ColorPickerAccImpl(master:UIComponent)
      {
         super(master);
         master.accessibilityProperties.description = "Color Picker";
         Accessibility.updateProperties();
         ColorPicker(master).addEventListener(DropdownEvent.OPEN,this.openHandler);
         ColorPicker(master).addEventListener(DropdownEvent.CLOSE,this.closeHandler);
      }
      
      public static function enableAccessibility() : void
      {
         ColorPicker.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new ColorPickerAccImpl(component);
      }
      
      private function openHandler(event:Event) : void
      {
         ColorPicker(master).dropdown.addEventListener("change",this.dropdown_changeHandler);
      }
      
      private function closeHandler(event:Event) : void
      {
         ColorPicker(master).dropdown.removeEventListener("change",this.dropdown_changeHandler);
      }
      
      private function dropdown_changeHandler(event:Event) : void
      {
         master.dispatchEvent(new Event("childChange"));
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
            return this.formatColorString(str);
         }
         return !item.label ? item.data : item.label;
      }
      
      override public function get_accState(childID:uint) : uint
      {
         var accState:uint = uint(getState(childID));
         if(childID > 0)
         {
            accState |= AccConst.STATE_SYSTEM_SELECTABLE;
            accState |= AccConst.STATE_SYSTEM_SELECTED | AccConst.STATE_SYSTEM_FOCUSED;
         }
         return accState;
      }
      
      override public function get_accValue(childID:uint) : String
      {
         if(ColorPicker(master).showingDropdown)
         {
            return Boolean(ColorPicker(master).dropdown) ? ColorPicker(master).dropdown.textInput.text : null;
         }
         return ColorPicker(master).selectedColor.toString(16);
      }
      
      override public function getChildIDArray() : Array
      {
         var n:int = Boolean(ColorPicker(master).dropdown) ? ColorPicker(master).dropdown.length : 0;
         return createChildIDArray(n);
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat(["childChange"]);
      }
      
      override protected function eventHandler(event:Event) : void
      {
         var index:int = 0;
         $eventHandler(event);
         switch(event.type)
         {
            case "childChange":
               index = ComboBase(master).selectedIndex;
               Accessibility.sendEvent(master,ColorPicker(master).dropdown.focusedIndex + 1,AccConst.EVENT_OBJECT_SELECTION);
               Accessibility.sendEvent(master,0,AccConst.EVENT_OBJECT_VALUECHANGE,true);
               break;
            case "valueCommit":
               Accessibility.sendEvent(master,0,AccConst.EVENT_OBJECT_VALUECHANGE);
         }
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
   }
}

