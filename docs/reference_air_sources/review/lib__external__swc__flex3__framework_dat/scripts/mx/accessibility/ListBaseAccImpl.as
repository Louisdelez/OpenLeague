package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import mx.collections.CursorBookmark;
   import mx.collections.IViewCursor;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.controls.listClasses.ListBase;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class ListBaseAccImpl extends AccImpl
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static const ROLE_SYSTEM_LISTITEM:uint = 34;
      
      private static const STATE_SYSTEM_FOCUSED:uint = 4;
      
      private static const STATE_SYSTEM_INVISIBLE:uint = 32768;
      
      private static const STATE_SYSTEM_OFFSCREEN:uint = 65536;
      
      private static const STATE_SYSTEM_SELECTABLE:uint = 2097152;
      
      private static const STATE_SYSTEM_SELECTED:uint = 2;
      
      private static const EVENT_OBJECT_FOCUS:uint = 32773;
      
      private static const EVENT_OBJECT_SELECTION:uint = 32774;
      
      public function ListBaseAccImpl(master:UIComponent)
      {
         super(master);
         role = 33;
      }
      
      public static function enableAccessibility() : void
      {
         ListBase.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      mx_internal static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new ListBaseAccImpl(component);
      }
      
      override public function get_accFocus() : uint
      {
         var index:uint = uint(ListBase(master).selectedIndex);
         return index >= 0 ? uint(index + 1) : 0;
      }
      
      override protected function getName(childID:uint) : String
      {
         if(childID == 0)
         {
            return "";
         }
         var listBase:ListBase = ListBase(master);
         var item:Object = getItemAt(childID - 1);
         return listBase.itemToLabel(item);
      }
      
      private function getItemAt(index:int) : Object
      {
         var iterator:IViewCursor = ListBase(master).collectionIterator;
         iterator.seek(CursorBookmark.FIRST,index);
         return iterator.current;
      }
      
      override public function accDoDefaultAction(childID:uint) : void
      {
         if(childID > 0)
         {
            ListBase(master).selectedIndex = childID - 1;
         }
      }
      
      override public function get_accRole(childID:uint) : uint
      {
         return childID == 0 ? role : ROLE_SYSTEM_LISTITEM;
      }
      
      override protected function eventHandler(event:Event) : void
      {
         var index:uint = 0;
         var childID:uint = 0;
         $eventHandler(event);
         switch(event.type)
         {
            case "change":
               index = uint(ListBase(master).selectedIndex);
               if(index >= 0)
               {
                  childID = index + 1;
                  Accessibility.sendEvent(master,childID,EVENT_OBJECT_FOCUS);
                  Accessibility.sendEvent(master,childID,EVENT_OBJECT_SELECTION);
               }
         }
      }
      
      override public function get_accSelection() : Array
      {
         var accSelection:Array = [];
         var selectedIndices:Array = ListBase(master).selectedIndices;
         var n:int = int(selectedIndices.length);
         for(var i:int = 0; i < n; i++)
         {
            accSelection[i] = selectedIndices[i] + 1;
         }
         return accSelection;
      }
      
      override public function accLocation(childID:uint) : *
      {
         var listBase:ListBase = ListBase(master);
         var index:uint = childID - 1;
         if(index < listBase.verticalScrollPosition || index >= listBase.verticalScrollPosition + listBase.rowCount)
         {
            return null;
         }
         var item:Object = getItemAt(index);
         return listBase.itemToItemRenderer(item);
      }
      
      override public function getChildIDArray() : Array
      {
         var n:int = Boolean(ListBase(master).dataProvider) ? int(ListBase(master).dataProvider.length) : 0;
         return createChildIDArray(n);
      }
      
      override public function get_accState(childID:uint) : uint
      {
         var listBase:ListBase = null;
         var index:uint = 0;
         var item:Object = null;
         var renderer:IListItemRenderer = null;
         var accState:uint = getState(childID);
         if(childID > 0)
         {
            listBase = ListBase(master);
            index = childID - 1;
            if(index < listBase.verticalScrollPosition || index >= listBase.verticalScrollPosition + listBase.rowCount)
            {
               accState |= STATE_SYSTEM_OFFSCREEN | STATE_SYSTEM_INVISIBLE;
            }
            else
            {
               accState |= STATE_SYSTEM_SELECTABLE;
               item = getItemAt(index);
               renderer = listBase.itemToItemRenderer(item);
               if(renderer != null && listBase.isItemSelected(renderer.data))
               {
                  accState |= STATE_SYSTEM_SELECTED | STATE_SYSTEM_FOCUSED;
               }
            }
         }
         return accState;
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat(["change"]);
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
      
      override public function get_accDefaultAction(childID:uint) : String
      {
         if(childID == 0)
         {
            return null;
         }
         return "Double Click";
      }
   }
}

