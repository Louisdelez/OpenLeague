package com.riotgames.platform.proxy
{
   import flash.system.ApplicationDomain;
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;
   
   public class ProxyFactory
   {
      
      public function ProxyFactory()
      {
         super();
      }
      
      public static function hasProxy(param1:Class, param2:ApplicationDomain = null) : Boolean
      {
         if(param2 == null)
         {
            param2 = ApplicationDomain.currentDomain;
         }
         var _loc3_:String = getQualifiedClassName(param1);
         return param2.hasDefinition(_loc3_ + "_proxy");
      }
      
      public static function createProxy(param1:Class, param2:ApplicationDomain = null) : *
      {
         var className:String;
         var describeTypeXml:XML = null;
         var proxyClass:Class = null;
         var clazz:Class = param1;
         var applicationDomain:ApplicationDomain = param2;
         if(applicationDomain == null)
         {
            applicationDomain = ApplicationDomain.currentDomain;
         }
         className = getQualifiedClassName(clazz);
         if(!applicationDomain.hasDefinition(className + "_proxy"))
         {
            describeTypeXml = describeType(clazz);
            if(describeTypeXml.factory.metadata.(@name == "GenerateProxy").length() == 0)
            {
               throw new Error("Attempted to create a proxy for: " + className + " which did not have the metadata GenerateProxy.");
            }
            throw new Error("Could not find the proxy for: " + className + ". Make sure the generate-proxies ant target is set up correctly.");
         }
         proxyClass = applicationDomain.getDefinition(className + "_proxy") as Class;
         return new proxyClass();
      }
   }
}

