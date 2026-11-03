package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import mx.collections.CursorBookmark;
   import mx.collections.IViewCursor;
   import mx.controls.Tree;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.TreeEvent;
   
   use namespace mx_internal;
   
   public class TreeAccImpl extends AccImpl
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static const ROLE_SYSTEM_OUTLINEITEM:uint = 36;
      
      private static const STATE_SYSTEM_COLLAPSED:uint = 1024;
      
      private static const STATE_SYSTEM_EXPANDED:uint = 512;
      
      private static const STATE_SYSTEM_FOCUSED:uint = 4;
      
      private static const STATE_SYSTEM_INVISIBLE:uint = 32768;
      
      private static const STATE_SYSTEM_SELECTABLE:uint = 2097152;
      
      private static const STATE_SYSTEM_SELECTED:uint = 2;
      
      private static const EVENT_OBJECT_FOCUS:uint = 32773;
      
      private static const EVENT_OBJECT_SELECTION:uint = 32774;
      
      private static const EVENT_OBJECT_STATECHANGE:uint = 32778;
      
      public function TreeAccImpl(master:UIComponent)
      {
         super(master);
         role = 35;
      }
      
      mx_internal static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new TreeAccImpl(component);
      }
      
      public static function enableAccessibility() : void
      {
         Tree.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      override public function get_accFocus() : uint
      {
         var index:int = Tree(master).selectedIndex;
         return index >= 0 ? uint(index + 1) : 0;
      }
      
      override protected function getName(childID:uint) : String
      {
         if(childID == 0)
         {
            return "";
         }
         var tree:Tree = Tree(master);
         var item:Object = getItemAt(childID - 1);
         var name:String = "";
         if(!item)
         {
            return name;
         }
         if(Boolean(tree.itemToLabel(item)))
         {
            name = tree.itemToLabel(item);
         }
         return name;
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat(["change",TreeEvent.ITEM_OPEN,TreeEvent.ITEM_CLOSE]);
      }
      
      override public function get_accState(childID:uint) : uint
      {
         var tree:Tree = null;
         var index:int = 0;
         var item:Object = null;
         var renderer:IListItemRenderer = null;
         var accState:uint = getState(childID);
         if(childID > 0)
         {
            tree = Tree(master);
            index = childID - 1;
            if(index < tree.verticalScrollPosition || index >= tree.verticalScrollPosition + tree.rowCount)
            {
               accState |= STATE_SYSTEM_INVISIBLE;
            }
            else
            {
               accState |= STATE_SYSTEM_SELECTABLE;
               item = getItemAt(index);
               if(Boolean(item) && tree.dataDescriptor.isBranch(item,tree.dataProvider))
               {
                  if(tree.isItemOpen(item))
                  {
                     accState |= STATE_SYSTEM_EXPANDED;
                  }
                  else
                  {
                     accState |= STATE_SYSTEM_COLLAPSED;
                  }
               }
               renderer = tree.itemToItemRenderer(item);
               if(renderer != null && tree.isItemSelected(renderer.data))
               {
                  accState |= STATE_SYSTEM_SELECTED | STATE_SYSTEM_FOCUSED;
               }
            }
         }
         return accState;
      }
      
      override public function accDoDefaultAction(childID:uint) : void
      {
         var tree:Tree = Tree(master);
         if(childID == 0 || !tree.enabled)
         {
            return;
         }
         var item:Object = getItemAt(childID - 1);
         if(!item)
         {
            return;
         }
         if(tree.dataDescriptor.isBranch(item,tree.dataProvider))
         {
            tree.expandItem(item,!tree.isItemOpen(item));
         }
      }
      
      override public function get_accRole(childID:uint) : uint
      {
         return childID == 0 ? role : ROLE_SYSTEM_OUTLINEITEM;
      }
      
      override protected function eventHandler(event:Event) : void
      {
         $eventHandler(event);
         var index:int = Tree(master).selectedIndex;
         var childID:uint = index + 1;
         switch(event.type)
         {
            case "change":
               if(index >= 0)
               {
                  Accessibility.sendEvent(master,childID,EVENT_OBJECT_FOCUS);
                  Accessibility.sendEvent(master,childID,EVENT_OBJECT_SELECTION);
               }
               break;
            case TreeEvent.ITEM_OPEN:
            case TreeEvent.ITEM_CLOSE:
               if(index >= 0)
               {
                  Accessibility.sendEvent(master,childID,EVENT_OBJECT_STATECHANGE);
               }
         }
      }
      
      override public function accLocation(childID:uint) : *
      {
         var tree:Tree = Tree(master);
         var index:int = childID - 1;
         if(index < tree.verticalScrollPosition || index >= tree.verticalScrollPosition + tree.rowCount)
         {
            return null;
         }
         return tree.itemToItemRenderer(getItemAt(index));
      }
      
      override public function getChildIDArray() : Array
      {
         var n:int = Boolean(Tree(master).dataProvider) ? Tree(master).collectionLength : 0;
         return createChildIDArray(n);
      }
      
      override public function get_accValue(childID:uint) : String
      {
         var accValue:String = null;
         var index:int = 0;
         var item:Object = null;
         var tree:Tree = null;
         var depth:int = 0;
         if(childID != 0)
         {
            index = childID - 1;
            item = getItemAt(index);
            if(!item)
            {
               return accValue;
            }
            tree = Tree(master);
            depth = tree.getItemDepth(item,index - tree.verticalScrollPosition);
            accValue = String(depth - 1);
         }
         return accValue;
      }
      
      private function getItemAt(index:int) : Object
      {
         var iterator:IViewCursor = Tree(master).collectionIterator;
         iterator.seek(CursorBookmark.FIRST,index);
         return iterator.current;
      }
      
      override public function get_accDefaultAction(childID:uint) : String
      {
         if(childID == 0)
         {
            return null;
         }
         var tree:Tree = Tree(master);
         var item:Object = getItemAt(childID - 1);
         if(!item)
         {
            return null;
         }
         if(tree.dataDescriptor.isBranch(item,tree.dataProvider))
         {
            return tree.isItemOpen(item) ? "Collapse" : "Expand";
         }
         return null;
      }
   }
}

