package blix.assets.proxy
{
   import blix.IDestructible;
   import flash.display.DisplayObject;
   
   public class TimelineChildBindingLeaf implements IDestructible
   {
      
      public var parent:TimelineChildBindingBranch;
      
      protected var _children:Vector.<IDisplayChild> = new Vector.<IDisplayChild>();
      
      protected var _displayObject:DisplayObject;
      
      public function TimelineChildBindingLeaf()
      {
         super();
      }
      
      public function getDisplayObject() : DisplayObject
      {
         return this._displayObject;
      }
      
      public function setDisplayObject(param1:DisplayObject) : void
      {
         var _loc2_:IDisplayChild = null;
         if(this._displayObject == param1)
         {
            return;
         }
         this._displayObject = param1;
         for each(_loc2_ in this._children)
         {
            _loc2_.setAsset(this._displayObject);
         }
      }
      
      public function getChildren() : Vector.<IDisplayChild>
      {
         return this._children;
      }
      
      public function addChild(param1:IDisplayChild) : Boolean
      {
         if(this._children.indexOf(param1) != -1)
         {
            return false;
         }
         this._children[this._children.length] = param1;
         if(this._displayObject != null)
         {
            param1.setAsset(this._displayObject);
         }
         return true;
      }
      
      public function removeChild(param1:IDisplayChild) : Boolean
      {
         var _loc2_:int = this._children.indexOf(param1);
         if(_loc2_ == -1)
         {
            return false;
         }
         this._children.splice(_loc2_,1);
         return true;
      }
      
      public function destroyAllChildren() : void
      {
         var _loc1_:IDisplayChild = null;
         for each(_loc1_ in this._children)
         {
            if(_loc1_ is IDestructible)
            {
               (_loc1_ as IDestructible).destroy();
            }
         }
         this._children.length = 0;
      }
      
      public function destroy() : void
      {
         this.setDisplayObject(null);
         this._children.length = 0;
         this.parent = null;
      }
   }
}

