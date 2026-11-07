package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import mx.collections.CursorBookmark;
   import mx.collections.IViewCursor;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.controls.listClasses.ListBase;
   import mx.core.UIComponent;
   
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
         return super.eventsToHandle.concat(["change"]);
      }
      
      override public function get_accRole(childID:uint) : uint
      {
         return childID == 0 ? uint(role) : uint(AccConst.ROLE_SYSTEM_LISTITEM);
      }
      
      override public function get_accState(childID:uint) : uint
      {
         var listBase:ListBase = null;
         var index:uint = 0;
         var item:Object = null;
         var renderer:IListItemRenderer = null;
         var accState:uint = uint(getState(childID));
         if(childID > 0)
         {
            listBase = ListBase(master);
            index = childID - 1;
            if(index < listBase.verticalScrollPosition || index >= listBase.verticalScrollPosition + listBase.rowCount)
            {
               accState |= AccConst.STATE_SYSTEM_OFFSCREEN | AccConst.STATE_SYSTEM_INVISIBLE;
            }
            else
            {
               accState |= AccConst.STATE_SYSTEM_SELECTABLE;
               item = this.getItemAt(index);
               renderer = listBase.itemToItemRenderer(item);
               if(renderer != null && listBase.isItemSelected(renderer.data))
               {
                  accState |= AccConst.STATE_SYSTEM_SELECTED | AccConst.STATE_SYSTEM_FOCUSED;
               }
            }
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
         if(index < listBase.verticalScrollPosition || index >= listBase.verticalScrollPosition + listBase.rowCount)
         {
            return null;
         }
         var item:Object = this.getItemAt(index);
         return listBase.itemToItemRenderer(item);
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
      
      override public function get_accFocus() : uint
      {
         var index:uint = uint(ListBase(master).selectedIndex);
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
         var item:Object = this.getItemAt(childID - 1);
         return listBase.itemToLabel(item);
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
                  Accessibility.sendEvent(master,childID,AccConst.EVENT_OBJECT_FOCUS);
                  Accessibility.sendEvent(master,childID,AccConst.EVENT_OBJECT_SELECTION);
               }
         }
      }
      
      private function getItemAt(index:int) : Object
      {
         var iterator:IViewCursor = ListBase(master).collectionIterator;
         iterator.seek(CursorBookmark.FIRST,index);
         return iterator.current;
      }
   }
}

