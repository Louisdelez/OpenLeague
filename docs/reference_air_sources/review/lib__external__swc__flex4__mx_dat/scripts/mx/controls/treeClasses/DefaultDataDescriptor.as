package mx.controls.treeClasses
{
   import flash.utils.Dictionary;
   import mx.collections.ArrayCollection;
   import mx.collections.CursorBookmark;
   import mx.collections.ICollectionView;
   import mx.collections.IList;
   import mx.collections.IViewCursor;
   import mx.collections.XMLListCollection;
   import mx.controls.menuClasses.IMenuDataDescriptor;
   
   public class DefaultDataDescriptor implements ITreeDataDescriptor2, IMenuDataDescriptor
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var ChildCollectionCache:Dictionary = new Dictionary(true);
      
      public function DefaultDataDescriptor()
      {
         super();
      }
      
      public function getChildren(node:Object, model:Object = null) : ICollectionView
      {
         var children:* = undefined;
         var childrenCollection:ICollectionView = null;
         var oldArrayCollection:ArrayCollection = null;
         var oldXMLCollection:XMLListCollection = null;
         var p:* = undefined;
         var childArray:Array = null;
         if(node == null)
         {
            return null;
         }
         if(node is XML)
         {
            children = node.*;
         }
         else if(node is Object)
         {
            try
            {
               children = node.children;
            }
            catch(e:Error)
            {
            }
         }
         if(children == undefined && !(children is XMLList))
         {
            return null;
         }
         if(children is ICollectionView)
         {
            childrenCollection = ICollectionView(children);
         }
         else if(children is Array)
         {
            oldArrayCollection = this.ChildCollectionCache[node];
            if(!oldArrayCollection)
            {
               childrenCollection = new ArrayCollection(children);
               this.ChildCollectionCache[node] = childrenCollection;
            }
            else
            {
               childrenCollection = oldArrayCollection;
               ArrayCollection(childrenCollection).dispatchResetEvent = false;
               ArrayCollection(childrenCollection).source = children;
            }
         }
         else if(children is XMLList)
         {
            oldXMLCollection = this.ChildCollectionCache[node];
            if(!oldXMLCollection)
            {
               for(p in this.ChildCollectionCache)
               {
                  if(p === node)
                  {
                     oldXMLCollection = this.ChildCollectionCache[p];
                     break;
                  }
               }
            }
            if(!oldXMLCollection)
            {
               childrenCollection = new XMLListCollection(children);
               this.ChildCollectionCache[node] = childrenCollection;
            }
            else
            {
               childrenCollection = oldXMLCollection;
               XMLListCollection(childrenCollection).dispatchResetEvent = false;
               XMLListCollection(childrenCollection).source = children;
            }
         }
         else
         {
            childArray = new Array(children);
            if(childArray != null)
            {
               childrenCollection = new ArrayCollection(childArray);
            }
         }
         return childrenCollection;
      }
      
      public function hasChildren(node:Object, model:Object = null) : Boolean
      {
         if(node == null)
         {
            return false;
         }
         var children:ICollectionView = this.getChildren(node,model);
         try
         {
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
      
      public function isBranch(node:Object, model:Object = null) : Boolean
      {
         var childList:XMLList = null;
         var branchFlag:XMLList = null;
         if(node == null)
         {
            return false;
         }
         var branch:Boolean = false;
         if(node is XML)
         {
            childList = node.children();
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
               if(node.children != undefined)
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
      
      public function getData(node:Object, model:Object = null) : Object
      {
         return Object(node);
      }
      
      public function addChildAt(parent:Object, newChild:Object, index:int, model:Object = null) : Boolean
      {
         var cursor:IViewCursor = null;
         var children:ICollectionView = null;
         var temp:XMLList = null;
         if(!parent)
         {
            try
            {
               if(index > model.length)
               {
                  index = int(model.length);
               }
               if(model is IList)
               {
                  IList(model).addItemAt(newChild,index);
               }
               else
               {
                  cursor = model.createCursor();
                  cursor.seek(CursorBookmark.FIRST,index);
                  cursor.insert(newChild);
               }
               return true;
            }
            catch(e:Error)
            {
            }
         }
         else
         {
            children = ICollectionView(this.getChildren(parent,model));
            if(!children)
            {
               if(parent is XML)
               {
                  temp = new XMLList();
                  XML(parent).appendChild(temp);
                  children = new XMLListCollection(parent.children());
               }
               else if(parent is Object)
               {
                  parent.children = new ArrayCollection();
                  children = parent.children;
               }
            }
            try
            {
               if(index > children.length)
               {
                  index = int(children.length);
               }
               if(children is IList)
               {
                  IList(children).addItemAt(newChild,index);
               }
               else
               {
                  cursor = children.createCursor();
                  cursor.seek(CursorBookmark.FIRST,index);
                  cursor.insert(newChild);
               }
               return true;
            }
            catch(e:Error)
            {
            }
         }
         return false;
      }
      
      public function removeChildAt(parent:Object, child:Object, index:int, model:Object = null) : Boolean
      {
         var cursor:IViewCursor = null;
         var children:ICollectionView = null;
         if(!parent)
         {
            try
            {
               if(index > model.length)
               {
                  index = int(model.length);
               }
               if(model is IList)
               {
                  model.removeItemAt(index);
               }
               else
               {
                  cursor = model.createCursor();
                  cursor.seek(CursorBookmark.FIRST,index);
                  cursor.remove();
               }
               return true;
            }
            catch(e:Error)
            {
            }
         }
         else
         {
            children = ICollectionView(this.getChildren(parent,model));
            try
            {
               if(index > children.length)
               {
                  index = int(children.length);
               }
               if(children is IList)
               {
                  IList(children).removeItemAt(index);
               }
               else
               {
                  cursor = children.createCursor();
                  cursor.seek(CursorBookmark.FIRST,index);
                  cursor.remove();
               }
               return true;
            }
            catch(e:Error)
            {
            }
         }
         return false;
      }
      
      public function getType(node:Object) : String
      {
         if(node is XML)
         {
            return String(node.@type);
         }
         if(node is Object)
         {
            try
            {
               return String(node.type);
            }
            catch(e:Error)
            {
            }
         }
         return "";
      }
      
      public function isEnabled(node:Object) : Boolean
      {
         var enabled:* = undefined;
         if(node is XML)
         {
            enabled = node.@enabled;
            if(enabled[0] == false)
            {
               return false;
            }
         }
         else if(node is Object)
         {
            try
            {
               return "false" != String(node.enabled);
            }
            catch(e:Error)
            {
            }
         }
         return true;
      }
      
      public function setEnabled(node:Object, value:Boolean) : void
      {
         if(node is XML)
         {
            node.@enabled = value;
         }
         else if(node is Object)
         {
            try
            {
               node.enabled = value;
            }
            catch(e:Error)
            {
            }
         }
      }
      
      public function isToggled(node:Object) : Boolean
      {
         var toggled:* = undefined;
         if(node is XML)
         {
            toggled = node.@toggled;
            if(toggled[0] == true)
            {
               return true;
            }
         }
         else if(node is Object)
         {
            try
            {
               return Boolean(node.toggled);
            }
            catch(e:Error)
            {
            }
         }
         return false;
      }
      
      public function setToggled(node:Object, value:Boolean) : void
      {
         if(node is XML)
         {
            node.@toggled = value;
         }
         else if(node is Object)
         {
            try
            {
               node.toggled = value;
            }
            catch(e:Error)
            {
            }
         }
      }
      
      public function getGroupName(node:Object) : String
      {
         if(node is XML)
         {
            return node.@groupName;
         }
         if(node is Object)
         {
            try
            {
               return node.groupName;
            }
            catch(e:Error)
            {
            }
         }
         return "";
      }
      
      public function getHierarchicalCollectionAdaptor(hierarchicalData:ICollectionView, uidFunction:Function, openItems:Object, model:Object = null) : ICollectionView
      {
         return new HierarchicalCollectionView(hierarchicalData,this,uidFunction,openItems);
      }
      
      public function getNodeDepth(node:Object, iterator:IViewCursor, model:Object = null) : int
      {
         if(node == iterator.current)
         {
            return HierarchicalViewCursor(iterator).currentDepth;
         }
         return -1;
      }
      
      public function getParent(node:Object, collection:ICollectionView, model:Object = null) : Object
      {
         return HierarchicalCollectionView(collection).getParentItem(node);
      }
   }
}

