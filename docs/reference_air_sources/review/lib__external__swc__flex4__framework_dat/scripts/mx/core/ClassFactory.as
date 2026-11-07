package mx.core
{
   use namespace mx_internal;
   
   public class ClassFactory implements IFactory
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      public var generator:Class;
      
      public var properties:Object = null;
      
      public function ClassFactory(generator:Class = null)
      {
         super();
         this.generator = generator;
      }
      
      public function newInstance() : *
      {
         var p:String = null;
         var instance:Object = new this.generator();
         if(this.properties != null)
         {
            for(p in this.properties)
            {
               instance[p] = this.properties[p];
            }
         }
         return instance;
      }
   }
}

