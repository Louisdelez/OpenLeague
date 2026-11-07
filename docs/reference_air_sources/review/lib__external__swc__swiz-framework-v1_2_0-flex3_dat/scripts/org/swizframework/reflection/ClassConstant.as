package org.swizframework.reflection
{
   import flash.system.ApplicationDomain;
   import flash.utils.getQualifiedClassName;
   
   public class ClassConstant
   {
      
      protected static const CLASS_CONSTANT_PATTERN:RegExp = /([^.]+)\.([A-Z0-9_*]+)$/;
      
      protected static const CLASS_PACKAGE_CONSTANT_PATTERN:RegExp = /^(.*)\.([^.]+)\.([A-Z0-9_*]+)$/;
      
      public function ClassConstant()
      {
         super();
      }
      
      public static function isClassConstant(value:String) : Boolean
      {
         return CLASS_CONSTANT_PATTERN.exec(value);
      }
      
      public static function getClassName(constant:String) : String
      {
         var match:Object = CLASS_CONSTANT_PATTERN.exec(constant);
         if(Boolean(match))
         {
            return match[1] as String;
         }
         return null;
      }
      
      public static function getConstantName(constant:String) : String
      {
         var match:Object = CLASS_CONSTANT_PATTERN.exec(constant);
         if(Boolean(match))
         {
            return match[2] as String;
         }
         return null;
      }
      
      public static function getConstantValue(domain:ApplicationDomain, definition:Class, constantName:String, constantType:String = "String") : *
      {
         var descriptor:TypeDescriptor = null;
         var node:XMLList = null;
         var variableNode:XMLList = null;
         var nodeType:String = null;
         descriptor = TypeCache.getTypeDescriptor(definition,domain);
         node = descriptor.description.constant.(@name == constantName);
         variableNode = descriptor.description.variable.(@name == constantName);
         if(node.length() == 0)
         {
            throw new Error(getQualifiedClassName(definition) + " has no constant named " + constantName + ".");
         }
         nodeType = node.@type;
         if(nodeType != constantType)
         {
            throw new Error(getQualifiedClassName(definition) + "." + constantName + " is not typed " + constantType + " but instead is typed as " + nodeType + ".");
         }
         return definition[constantName];
      }
      
      public static function getClass(domain:ApplicationDomain, constant:String, packageNames:Array = null) : Class
      {
         var className:String = null;
         var constantName:String = null;
         var packageMatch:Object = null;
         var packageName:String = null;
         var match:Object = CLASS_CONSTANT_PATTERN.exec(constant);
         if(Boolean(match))
         {
            className = match[1] as String;
            constantName = match[2] as String;
            packageMatch = CLASS_PACKAGE_CONSTANT_PATTERN.exec(constant);
            if(Boolean(packageMatch))
            {
               packageName = packageMatch[1] as String;
               return getClassDefinition(domain,packageName + "." + className);
            }
            return findClassDefinition(domain,className,packageNames);
         }
         return null;
      }
      
      protected static function findClassDefinition(domain:ApplicationDomain, className:String, packageNames:Array) : Class
      {
         var packageName:String = null;
         var definition:Class = null;
         for each(packageName in packageNames)
         {
            definition = getClassDefinition(domain,packageName + "." + className);
            if(definition != null)
            {
               return definition;
            }
         }
         return null;
      }
      
      protected static function getClassDefinition(domain:ApplicationDomain, name:String) : Class
      {
         try
         {
            return domain.getDefinition(name) as Class;
         }
         catch(e:ReferenceError)
         {
         }
         return null;
      }
   }
}

