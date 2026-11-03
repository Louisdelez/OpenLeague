package blix.util.type
{
   import flash.utils.Proxy;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public function getType(param1:Object) : Class
   {
      if(param1 is Class)
      {
         return param1 as Class;
      }
      if(param1 is Proxy)
      {
         return getDefinitionByName(getQualifiedClassName(param1)) as Class;
      }
      if(param1 != null)
      {
         return param1.constructor as Class;
      }
      return null;
   }
}

