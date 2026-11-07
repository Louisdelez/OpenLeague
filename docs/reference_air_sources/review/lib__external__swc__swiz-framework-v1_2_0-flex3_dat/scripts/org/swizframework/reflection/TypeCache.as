package org.swizframework.reflection
{
   import flash.system.ApplicationDomain;
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;
   
   public class TypeCache
   {
      
      protected static var typeDescriptors:Dictionary;
      
      public function TypeCache()
      {
         super();
      }
      
      public static function getTypeDescriptor(target:Object, domain:ApplicationDomain) : TypeDescriptor
      {
         typeDescriptors = typeDescriptors || new Dictionary();
         var className:String = getQualifiedClassName(target);
         if(typeDescriptors[className] != null)
         {
            return typeDescriptors[className];
         }
         return typeDescriptors[className] = new TypeDescriptor().fromXML(describeType(domain.getDefinition(className)),domain);
      }
      
      public static function flushDomain(domain:ApplicationDomain) : void
      {
         var key:Object = null;
         for(key in typeDescriptors)
         {
            if(TypeDescriptor(typeDescriptors[key]).domain == domain)
            {
               delete typeDescriptors[key];
            }
         }
      }
   }
}

