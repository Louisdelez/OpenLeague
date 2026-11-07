package mx.core
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   
   [ExcludeClass]
   public class ContainerRawChildrenList implements IChildList
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var owner:Container;
      
      public function ContainerRawChildrenList(owner:Container)
      {
         super();
         this.owner = owner;
      }
      
      public function get numChildren() : int
      {
         return this.owner.$numChildren;
      }
      
      public function addChild(child:DisplayObject) : DisplayObject
      {
         return this.owner.rawChildren_addChild(child);
      }
      
      public function addChildAt(child:DisplayObject, index:int) : DisplayObject
      {
         return this.owner.rawChildren_addChildAt(child,index);
      }
      
      public function removeChild(child:DisplayObject) : DisplayObject
      {
         return this.owner.rawChildren_removeChild(child);
      }
      
      public function removeChildAt(index:int) : DisplayObject
      {
         return this.owner.rawChildren_removeChildAt(index);
      }
      
      public function getChildAt(index:int) : DisplayObject
      {
         return this.owner.rawChildren_getChildAt(index);
      }
      
      public function getChildByName(name:String) : DisplayObject
      {
         return this.owner.rawChildren_getChildByName(name);
      }
      
      public function getChildIndex(child:DisplayObject) : int
      {
         return this.owner.rawChildren_getChildIndex(child);
      }
      
      public function setChildIndex(child:DisplayObject, newIndex:int) : void
      {
         this.owner.rawChildren_setChildIndex(child,newIndex);
      }
      
      public function getObjectsUnderPoint(point:Point) : Array
      {
         return this.owner.rawChildren_getObjectsUnderPoint(point);
      }
      
      public function contains(child:DisplayObject) : Boolean
      {
         return this.owner.rawChildren_contains(child);
      }
   }
}

