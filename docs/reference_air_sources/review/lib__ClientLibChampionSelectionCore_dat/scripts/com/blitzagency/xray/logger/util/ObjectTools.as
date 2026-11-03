package com.blitzagency.xray.logger.util
{
   import com.blitzagency.xray.logger.XrayLog;
   import flash.utils.*;
   
   public class ObjectTools
   {
      
      private static var log:XrayLog = new XrayLog();
      
      public function ObjectTools()
      {
         super();
      }
      
      public static function getImmediateClassPath(obj:Object) : String
      {
         var className:String = null;
         var superClassName:String = null;
         className = getQualifiedClassName(obj);
         superClassName = getQualifiedSuperclassName(obj);
         className = className.indexOf("::") > -1 ? className.split("::").join(".") : className;
         if(superClassName == null)
         {
            return className;
         }
         superClassName = superClassName.indexOf("::") > -1 ? superClassName.split("::").join(".") : superClassName;
         return superClassName + "." + className;
      }
      
      public static function getFullClassPath(obj:Object) : String
      {
         var xmlDoc:XML = null;
         var ary:Array = null;
         var className:String = null;
         var item:XML = null;
         var extClass:String = null;
         xmlDoc = describeType(obj);
         ary = [];
         className = getQualifiedClassName(obj);
         className = className.indexOf("::") > -1 ? className.split("::").join(".") : className;
         ary.push(className);
         for each(item in xmlDoc.extendsClass)
         {
            extClass = item.@type.toString().indexOf("::") > -1 ? item.@type.toString().split("::")[1] : item.@type.toString();
            ary.push(extClass);
         }
         return ary.join(".");
      }
      
      public function resolveBaseType(obj:Object) : String
      {
         return "";
      }
   }
}

