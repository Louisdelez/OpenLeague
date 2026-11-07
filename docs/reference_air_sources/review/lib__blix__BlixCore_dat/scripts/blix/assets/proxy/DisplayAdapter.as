package blix.assets.proxy
{
   import blix.IDestructible;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.utils.Dictionary;
   
   public class DisplayAdapter implements IDestructible
   {
      
      private var parent:DisplayObjectContainerProxy;
      
      private var childDict:Dictionary = new Dictionary(true);
      
      public function DisplayAdapter(param1:*)
      {
         super();
         if(param1 is DisplayObjectContainerProxy)
         {
            this.parent = param1 as DisplayObjectContainerProxy;
         }
         else
         {
            if(!(param1 is DisplayObjectContainer))
            {
               throw new ArgumentError("DisplayAdapter took an unknown parameter");
            }
            this.parent = new DisplayObjectContainerProxy(null,param1 as DisplayObjectContainer);
         }
      }
      
      public function addChild(param1:*) : void
      {
         var _loc2_:IDisplayChild = null;
         if(param1 is IDisplayChild)
         {
            _loc2_ = param1 as IDisplayChild;
         }
         else
         {
            if(!(param1 is DisplayObject))
            {
               throw new ArgumentError("child is an unsupported type.");
            }
            _loc2_ = new SimpleChild(param1 as DisplayObject);
         }
         this.childDict[param1] = _loc2_;
         this.parent.addChild(_loc2_);
      }
      
      public function removeChild(param1:*) : Boolean
      {
         if(!(param1 in this.childDict))
         {
            return false;
         }
         var _loc2_:IDisplayChild = this.childDict[param1];
         delete this.childDict[param1];
         return this.parent.removeChild(_loc2_);
      }
      
      public function destroy() : void
      {
         this.childDict = null;
         this.parent.destroy();
      }
   }
}

