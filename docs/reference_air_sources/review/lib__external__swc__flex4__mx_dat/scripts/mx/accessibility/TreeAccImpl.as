package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import mx.collections.CursorBookmark;
   import mx.collections.IViewCursor;
   import mx.controls.Tree;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.UIComponent;
   import mx.events.TreeEvent;
   
   public class TreeAccImpl extends AccImpl
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function TreeAccImpl(master:UIComponent)
      {
         super(master);
         role = AccConst.ROLE_SYSTEM_OUTLINE;
      }
      
      public static function enableAccessibility() : void
      {
         Tree.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityImplementation = new TreeAccImpl(component);
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat(["change",TreeEvent.ITEM_OPEN,TreeEvent.ITEM_CLOSE]);
      }
      
      override public function get_accRole(childID:uint) : uint
      {
         return childID == 0 ? uint(role) : uint(AccConst.ROLE_SYSTEM_OUTLINEITEM);
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
            item = this.getItemAt(index);
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
      
      override public function get_accState(childID:uint) : uint
      {
         var tree:Tree = null;
         var index:int = 0;
         var item:Object = null;
         var renderer:IListItemRenderer = null;
         var accState:uint = uint(getState(childID));
         if(childID > 0)
         {
            tree = Tree(master);
            index = childID - 1;
            if(index < tree.verticalScrollPosition || index >= tree.verticalScrollPosition + tree.rowCount)
            {
               accState |= AccConst.STATE_SYSTEM_INVISIBLE;
            }
            else
            {
               accState |= AccConst.STATE_SYSTEM_SELECTABLE;
               item = this.getItemAt(index);
               if(Boolean(item) && tree.dataDescriptor.isBranch(item,tree.dataProvider))
               {
                  if(tree.isItemOpen(item))
                  {
                     accState |= AccConst.STATE_SYSTEM_EXPANDED;
                  }
                  else
                  {
                     accState |= AccConst.STATE_SYSTEM_COLLAPSED;
                  }
               }
               renderer = tree.itemToItemRenderer(item);
               if(renderer != null && tree.isItemSelected(renderer.data))
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
         var tree:Tree = Tree(master);
         var item:Object = this.getItemAt(childID - 1);
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
      
      override public function accDoDefaultAction(childID:uint) : void
      {
         var tree:Tree = Tree(master);
         if(childID == 0 || !tree.enabled)
         {
            return;
         }
         var item:Object = this.getItemAt(childID - 1);
         if(!item)
         {
            return;
         }
         if(tree.dataDescriptor.isBranch(item,tree.dataProvider))
         {
            tree.expandItem(item,!tree.isItemOpen(item));
         }
      }
      
      override public function getChildIDArray() : Array
      {
         var n:int = Boolean(Tree(master).dataProvider) ? Tree(master).collectionLength : 0;
         return createChildIDArray(n);
      }
      
      override public function accLocation(childID:uint) : *
      {
         var tree:Tree = Tree(master);
         var index:int = childID - 1;
         if(index < tree.verticalScrollPosition || index >= tree.verticalScrollPosition + tree.rowCount)
         {
            return null;
         }
         return tree.itemToItemRenderer(this.getItemAt(index));
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
         var item:Object = this.getItemAt(childID - 1);
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
      
      private function getItemAt(index:int) : Object
      {
         var iterator:IViewCursor = Tree(master).collectionIterator;
         iterator.seek(CursorBookmark.FIRST,index);
         return iterator.current;
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
                  Accessibility.sendEvent(master,childID,AccConst.EVENT_OBJECT_FOCUS);
                  Accessibility.sendEvent(master,childID,AccConst.EVENT_OBJECT_SELECTION);
               }
               break;
            case TreeEvent.ITEM_OPEN:
            case TreeEvent.ITEM_CLOSE:
               if(index >= 0)
               {
                  Accessibility.sendEvent(master,childID,AccConst.EVENT_OBJECT_STATECHANGE);
               }
         }
      }
   }
}

