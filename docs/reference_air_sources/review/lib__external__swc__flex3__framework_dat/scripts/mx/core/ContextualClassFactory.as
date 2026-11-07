package mx.core
{
   import flash.utils.getQualifiedClassName;
   
   use namespace mx_internal;
   
   public class ContextualClassFactory extends ClassFactory
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public var moduleFactory:IFlexModuleFactory;
      
      public function ContextualClassFactory(generator:Class = null, moduleFactory:IFlexModuleFactory = null)
      {
         super(generator);
         this.moduleFactory = moduleFactory;
      }
      
      override public function newInstance() : *
      {
         var p:String = null;
         var instance:Object = null;
         if(Boolean(moduleFactory))
         {
            instance = moduleFactory.create(getQualifiedClassName(generator));
         }
         if(!instance)
         {
            instance = super.newInstance();
         }
         if(Boolean(properties))
         {
            for(p in properties)
            {
               instance[p] = properties[p];
            }
         }
         return instance;
      }
   }
}

