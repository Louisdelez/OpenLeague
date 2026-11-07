package blix.factory
{
   import blix.IDestructible;
   
   public class ClassPool implements IPool, IDestructible
   {
      
      private var instances:Array = [];
      
      private var classFactory:ClassFactory;
      
      public function ClassPool(param1:Class, param2:Array = null)
      {
         super();
         this.classFactory = new ClassFactory(param1,param2);
      }
      
      public function returnInstance(param1:*) : void
      {
         if(param1 == null)
         {
            return;
         }
         this.instances.push(param1);
      }
      
      public function getInstance() : *
      {
         var _loc1_:* = undefined;
         if(Boolean(this.instances.length))
         {
            _loc1_ = this.instances.pop();
         }
         else
         {
            _loc1_ = this.classFactory.getInstance();
         }
         return _loc1_;
      }
      
      public function destroy() : void
      {
         var _loc1_:* = undefined;
         for each(_loc1_ in this.instances)
         {
            if(_loc1_ is IDestructible)
            {
               (_loc1_ as IDestructible).destroy();
            }
         }
         this.instances.length = 0;
      }
   }
}

