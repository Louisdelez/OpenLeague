package mx.core
{
   use namespace mx_internal;
   
   public class DeferredInstanceFromFunction implements ITransientDeferredInstance
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var generator:Function;
      
      private var instance:Object = null;
      
      private var destructor:Function;
      
      public function DeferredInstanceFromFunction(generator:Function, destructor:Function = null)
      {
         super();
         this.generator = generator;
         this.destructor = destructor;
      }
      
      public function getInstance() : Object
      {
         if(!this.instance)
         {
            this.instance = this.generator();
         }
         return this.instance;
      }
      
      public function reset() : void
      {
         this.instance = null;
         if(this.destructor != null)
         {
            this.destructor();
         }
      }
   }
}

