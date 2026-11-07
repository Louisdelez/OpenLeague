package spark.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import mx.accessibility.AccConst;
   import mx.accessibility.AccImpl;
   import mx.core.UIComponent;
   import spark.components.List;
   import spark.components.supportClasses.ListBase;
   import spark.events.IndexChangeEvent;
   
   public class ListBaseAccImpl extends AccImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function ListBaseAccImpl(master:UIComponent)
      {
         super(master);
         role = AccConst.ROLE_SYSTEM_LIST;
      }
      
      public static function enableAccessibility() : void
      {
         ListBase.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new ListBaseAccImpl(component);
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat(["change","caretChange"]);
      }
      
      override public function get_accName(childID:uint) : String
      {
         if(childID == 0)
         {
            return super.get_accName(childID);
         }
         var accName:String = this.getName(childID);
         return accName != null && accName != "" ? accName : null;
      }
      
      override public function get_accRole(childID:uint) : uint
      {
         return childID == 0 ? uint(role) : uint(AccConst.ROLE_SYSTEM_LISTITEM);
      }
      
      override public function get_accState(childID:uint) : uint
      {
         var index:uint = 0;
         var isInvisible:Boolean = false;
         var accState:uint = uint(getState(childID));
         if(childID > 0)
         {
            index = childID - 1;
            isInvisible = false;
            if(isInvisible)
            {
               accState |= AccConst.STATE_SYSTEM_OFFSCREEN | AccConst.STATE_SYSTEM_INVISIBLE;
            }
            else
            {
               if(master is List)
               {
                  accState |= AccConst.STATE_SYSTEM_SELECTABLE;
               }
               if(ListBase(master).isItemIndexSelected(index))
               {
                  accState |= AccConst.STATE_SYSTEM_SELECTED;
               }
               if(index == ListBase(master).caretIndex)
               {
                  accState |= AccConst.STATE_SYSTEM_FOCUSED;
               }
            }
         }
         else if(master is List && List(master).allowMultipleSelection)
         {
            accState |= AccConst.STATE_SYSTEM_MULTISELECTABLE;
         }
         return accState;
      }
      
      override public function get_accDefaultAction(childID:uint) : String
      {
         if(childID == 0)
         {
            return null;
         }
         return "Double Click";
      }
      
      override public function accDoDefaultAction(childID:uint) : void
      {
         if(childID > 0)
         {
            ListBase(master).selectedIndex = childID - 1;
         }
      }
      
      override public function getChildIDArray() : Array
      {
         var n:int = Boolean(ListBase(master).dataProvider) ? int(ListBase(master).dataProvider.length) : 0;
         return createChildIDArray(n);
      }
      
      override public function accLocation(childID:uint) : *
      {
         var listBase:ListBase = ListBase(master);
         var index:uint = childID - 1;
         var isInvisible:Boolean = false;
         if(isInvisible)
         {
            return null;
         }
         return this.getItemAt(index);
      }
      
      override public function get_accSelection() : Array
      {
         var accSelection:Array = [];
         var selectedIndices:Array = [];
         if(master is List && List(master).allowMultipleSelection)
         {
            selectedIndices.concat(List(master).selectedIndices);
         }
         else
         {
            selectedIndices.concat(ListBase(master).selectedIndex);
         }
         var n:int = int(selectedIndices.length);
         for(var i:int = 0; i < n; i++)
         {
            accSelection[i] = selectedIndices[i] + 1;
         }
         return accSelection;
      }
      
      override public function get_accFocus() : uint
      {
         var index:uint = ListBase(master).caretIndex;
         return index >= 0 ? uint(index + 1) : 0;
      }
      
      override public function accSelect(selFlag:uint, childID:uint) : void
      {
         var listBase:ListBase = ListBase(master);
         var index:uint = childID - 1;
         if(index >= 0 && index < listBase.dataProvider.length)
         {
            listBase.selectedIndex = index;
         }
      }
      
      override protected function getName(childID:uint) : String
      {
         if(childID == 0)
         {
            return "";
         }
         var listBase:ListBase = ListBase(master);
         var index:uint = childID - 1;
         if(index < 0 || index >= listBase.dataProvider.length)
         {
            return "";
         }
         return listBase.itemToLabel(listBase.dataProvider.getItemAt(index));
      }
      
      override protected function eventHandler(event:Event) : void
      {
         var index:uint = 0;
         var childID:uint = 0;
         $eventHandler(event);
         switch(event.type)
         {
            case "change":
               index = uint(IndexChangeEvent(event).newIndex);
               if(index >= 0)
               {
                  childID = index + 1;
                  Accessibility.sendEvent(master,childID,AccConst.EVENT_OBJECT_SELECTION);
               }
               break;
            case "caretChange":
               index = uint(IndexChangeEvent(event).newIndex);
               childID = index + 1;
               Accessibility.sendEvent(master,childID,AccConst.EVENT_OBJECT_FOCUS);
         }
      }
      
      private function getItemAt(index:int) : Object
      {
         if(Boolean(ListBase(master).dataGroup))
         {
            return ListBase(master).dataGroup.getElementAt(index);
         }
         return master;
      }
   }
}

