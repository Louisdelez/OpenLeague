package mx.collections
{
   import flash.events.EventDispatcher;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   
   public class HierarchicalData extends EventDispatcher implements IHierarchicalData
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _source:Object;
      
      private var _childrenField:String = "children";
      
      public function HierarchicalData(value:Object = null)
      {
         super();
         source = value;
      }
      
      public function get childrenField() : String
      {
         return _childrenField;
      }
      
      public function getData(node:Object) : Object
      {
         return Object(node);
      }
      
      public function getChildren(node:Object) : Object
      {
         var children:* = undefined;
         if(node == null)
         {
            return null;
         }
         if(node is XML)
         {
            children = childrenField == "children" ? node.* : node.child(childrenField).*;
         }
         else if(node is Object)
         {
            try
            {
               children = node[childrenField];
            }
            catch(e:Error)
            {
            }
         }
         if(children === undefined)
         {
            return null;
         }
         return children;
      }
      
      public function set childrenField(value:String) : void
      {
         _childrenField = value;
      }
      
      public function canHaveChildren(node:Object) : Boolean
      {
         var branch:Boolean;
         var childList:XMLList = null;
         var branchFlag:XMLList = null;
         if(node == null)
         {
            return false;
         }
         branch = false;
         if(node is XML)
         {
            childList = childrenField == "children" ? node.children() : node.child(childrenField).children();
            branchFlag = node.@isBranch;
            if(branchFlag.length() == 1)
            {
               if(branchFlag[0] == "true")
               {
                  branch = true;
               }
            }
            else if(childList.length() != 0)
            {
               branch = true;
            }
         }
         else if(node is Object)
         {
            try
            {
               if(node[childrenField] != undefined)
               {
                  branch = true;
               }
            }
            catch(e:Error)
            {
            }
         }
         return branch;
      }
      
      public function hasChildren(node:Object) : Boolean
      {
         var children:Object;
         if(node == null)
         {
            return false;
         }
         children = getChildren(node);
         try
         {
            if(children is XMLList || children is XML)
            {
               if(children.length() > 0)
               {
                  return true;
               }
            }
            if(children.length > 0)
            {
               return true;
            }
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function get source() : Object
      {
         return _source;
      }
      
      public function set source(value:Object) : void
      {
         _source = value;
         var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
         event.kind = CollectionEventKind.RESET;
         dispatchEvent(event);
      }
      
      public function getRoot() : Object
      {
         return source;
      }
   }
}

