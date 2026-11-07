package mx.core
{
   use namespace mx_internal;
   
   public class DeferredInstanceFromClass implements IDeferredInstance
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var generator:Class;
      
      private var instance:Object = null;
      
      public function DeferredInstanceFromClass(generator:Class)
      {
         super();
         this.generator = generator;
      }
      
      public function getInstance() : Object
      {
         if(!instance)
         {
            instance = new generator();
         }
         return instance;
      }
   }
}

