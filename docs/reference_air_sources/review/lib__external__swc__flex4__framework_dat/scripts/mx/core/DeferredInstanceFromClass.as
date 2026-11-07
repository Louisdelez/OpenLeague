package mx.core
{
   use namespace mx_internal;
   
   public class DeferredInstanceFromClass implements ITransientDeferredInstance
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var generator:Class;
      
      private var instance:Object = null;
      
      public function DeferredInstanceFromClass(generator:Class)
      {
         super();
         this.generator = generator;
      }
      
      public function getInstance() : Object
      {
         if(!this.instance)
         {
            this.instance = new this.generator();
         }
         return this.instance;
      }
      
      public function reset() : void
      {
         this.instance = null;
      }
   }
}

