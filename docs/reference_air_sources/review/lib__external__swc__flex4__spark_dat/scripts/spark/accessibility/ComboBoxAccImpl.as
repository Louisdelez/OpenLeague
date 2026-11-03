package spark.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import mx.accessibility.AccConst;
   import mx.core.UIComponent;
   import spark.components.ComboBox;
   import spark.components.TextInput;
   import spark.events.IndexChangeEvent;
   import spark.events.SkinPartEvent;
   
   public class ComboBoxAccImpl extends DropDownListBaseAccImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function ComboBoxAccImpl(master:UIComponent)
      {
         super(master);
         var textInput:TextInput = ComboBox(master).textInput;
         if(Boolean(textInput))
         {
            textInput.addEventListener(Event.CHANGE,this.textInputChangeHandler);
         }
      }
      
      public static function enableAccessibility() : void
      {
         ComboBox.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new ComboBoxAccImpl(component);
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat([FocusEvent.FOCUS_IN,SkinPartEvent.PART_ADDED,SkinPartEvent.PART_REMOVED]);
      }
      
      override public function get_accName(childID:uint) : String
      {
         if(childID <= 1)
         {
            return super.get_accName(0);
         }
         return super.get_accName(childID - 1);
      }
      
      override public function get_accRole(childID:uint) : uint
      {
         if(childID == 1)
         {
            return AccConst.ROLE_SYSTEM_TEXT;
         }
         if(childID == 0)
         {
            return super.get_accRole(0);
         }
         return super.get_accRole(childID - 1);
      }
      
      override public function get_accState(childID:uint) : uint
      {
         if(childID > 1)
         {
            return super.get_accState(childID - 1);
         }
         var accState:uint = super.get_accState(0);
         if(Boolean(master.getFocus()) && Boolean(master.owns(master.getFocus())))
         {
            accState |= AccConst.STATE_SYSTEM_FOCUSED;
         }
         if(childID == 1)
         {
            accState &= ~AccConst.STATE_SYSTEM_COLLAPSED;
         }
         return accState;
      }
      
      override public function get_accDefaultAction(childID:uint) : String
      {
         if(childID <= 1)
         {
            return null;
         }
         return super.get_accDefaultAction(childID - 1);
      }
      
      override public function accDoDefaultAction(childID:uint) : void
      {
         if(childID > 1)
         {
            super.accDoDefaultAction(childID - 1);
         }
      }
      
      override public function getChildIDArray() : Array
      {
         var childIDArray:Array = super.getChildIDArray();
         childIDArray[childIDArray.length] = childIDArray.length + 1;
         return childIDArray;
      }
      
      override public function get_accFocus() : uint
      {
         var index:uint = super.get_accFocus();
         if(ComboBox(master).isDropDownOpen)
         {
            return index > 0 ? uint(index + 1) : 0;
         }
         if(Boolean(master.getFocus()) && Boolean(master.owns(master.getFocus())))
         {
            return 1;
         }
         return 0;
      }
      
      override public function accLocation(childID:uint) : *
      {
         if(childID == 0)
         {
            return super.accLocation(0);
         }
         if(childID == 1)
         {
            return ComboBox(master).textInput;
         }
         return super.accLocation(childID - 1);
      }
      
      override public function accSelect(selFlag:uint, childID:uint) : void
      {
         if(childID > 1)
         {
            super.accSelect(selFlag,childID - 1);
         }
         else if(childID <= 1 && Boolean(ComboBox(master).textInput))
         {
            ComboBox(master).setFocus();
         }
      }
      
      override public function get_accValue(childID:uint) : String
      {
         var comboBox:ComboBox = ComboBox(master);
         if(childID <= 1)
         {
            return comboBox.selectedIndex == -1 ? comboBox.textInput.text : comboBox.selectedItem;
         }
         return null;
      }
      
      override protected function eventHandler(event:Event) : void
      {
         var textInput:TextInput = null;
         var sIndex:uint = 0;
         var index:uint = 0;
         var childID:uint = 0;
         switch(event.type)
         {
            case "open":
               Accessibility.sendEvent(master,0,AccConst.EVENT_OBJECT_STATECHANGE);
               sIndex = uint(ComboBox(master).selectedIndex);
               if(sIndex >= 0)
               {
                  Accessibility.sendEvent(master,sIndex + 2,AccConst.EVENT_OBJECT_FOCUS);
               }
               break;
            case "focusIn":
               Accessibility.sendEvent(master,0,AccConst.EVENT_OBJECT_FOCUS);
               if(master.getFocus() == master && Boolean(ComboBox(master).textInput))
               {
                  ComboBox(master).textInput.setFocus();
               }
               break;
            case "caretChange":
               index = uint(IndexChangeEvent(event).newIndex);
               childID = index + 2;
               Accessibility.sendEvent(master,0,AccConst.EVENT_OBJECT_VALUECHANGE);
               Accessibility.sendEvent(master,1,AccConst.EVENT_OBJECT_VALUECHANGE);
               if(ComboBox(master).isDropDownOpen && index >= 0 && index < ComboBox(master).dataProvider.length)
               {
                  Accessibility.sendEvent(master,childID,AccConst.EVENT_OBJECT_FOCUS);
               }
               break;
            case "change":
               index = uint(IndexChangeEvent(event).newIndex);
               if(index >= 0 && ComboBox(master).isDropDownOpen)
               {
                  childID = index + 2;
                  Accessibility.sendEvent(master,childID,AccConst.EVENT_OBJECT_SELECTION);
               }
               break;
            case "close":
               if(Boolean(master.getFocus()) && Boolean(master.owns(master.getFocus())) && Boolean(ComboBox(master).textInput))
               {
                  ComboBox(master).textInput.textDisplay.setFocus();
                  ComboBox(master).textInput.selectRange(0,0);
                  Accessibility.sendEvent(master,1,AccConst.EVENT_OBJECT_FOCUS);
               }
               break;
            case SkinPartEvent.PART_ADDED:
               textInput = ComboBox(master).textInput;
               if(SkinPartEvent(event).instance == textInput)
               {
                  textInput.addEventListener(Event.CHANGE,this.textInputChangeHandler);
               }
               break;
            case SkinPartEvent.PART_REMOVED:
               textInput = ComboBox(master).textInput;
               if(SkinPartEvent(event).instance == textInput)
               {
                  textInput.removeEventListener(Event.CHANGE,this.textInputChangeHandler);
               }
               break;
            default:
               super.eventHandler(event);
         }
      }
      
      private function textInputChangeHandler(event:Event) : void
      {
         Accessibility.sendEvent(master,0,AccConst.EVENT_OBJECT_VALUECHANGE);
      }
   }
}

