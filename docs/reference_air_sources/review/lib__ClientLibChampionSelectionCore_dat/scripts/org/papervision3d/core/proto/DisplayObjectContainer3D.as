package org.papervision3d.core.proto
{
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import org.papervision3d.Papervision3D;
   import org.papervision3d.materials.MaterialsList;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class DisplayObjectContainer3D extends EventDispatcher
   {
      
      protected var _children:Dictionary;
      
      public var root:DisplayObjectContainer3D;
      
      private var _childrenTotal:int;
      
      protected var _childrenByName:Object;
      
      public function DisplayObjectContainer3D()
      {
         super();
         this._children = new Dictionary(false);
         this._childrenByName = new Dictionary(true);
         this._childrenTotal = 0;
      }
      
      public function getChildByName(name:String) : DisplayObject3D
      {
         return this._childrenByName[name];
      }
      
      public function addCollada(filename:String, materials:MaterialsList = null, scale:Number = 1) : void
      {
         Papervision3D.log("The addCollada() method has been deprecated. Use addChildren( new Collada( filename ) )");
      }
      
      public function removeChildByName(name:String) : DisplayObject3D
      {
         return removeChild(getChildByName(name));
      }
      
      public function get numChildren() : int
      {
         return this._childrenTotal;
      }
      
      override public function toString() : String
      {
         return childrenList();
      }
      
      public function addChildren(parent:DisplayObject3D) : DisplayObjectContainer3D
      {
         var child:DisplayObject3D = null;
         for each(child in parent.children)
         {
            parent.removeChild(child);
            this.addChild(child);
         }
         return this;
      }
      
      public function removeChild(child:DisplayObject3D) : DisplayObject3D
      {
         if(Boolean(child))
         {
            delete this._childrenByName[this._children[child]];
            delete this._children[child];
            child.parent = null;
            child.root = null;
            return child;
         }
         return null;
      }
      
      public function addChild(child:DisplayObject3D, name:String = null) : DisplayObject3D
      {
         name = name || child.name || String(child.id);
         this._children[child] = name;
         this._childrenByName[name] = child;
         ++this._childrenTotal;
         child.parent = this;
         child.root = this.root;
         return child;
      }
      
      public function childrenList() : String
      {
         var list:String = null;
         var name:String = null;
         list = "";
         for(name in this._children)
         {
            list += name + "\n";
         }
         return list;
      }
      
      public function get children() : Object
      {
         return this._childrenByName;
      }
   }
}

