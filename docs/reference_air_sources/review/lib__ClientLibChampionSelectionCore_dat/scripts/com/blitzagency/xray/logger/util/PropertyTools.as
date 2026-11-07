package com.blitzagency.xray.logger.util
{
   import flash.utils.*;
   
   public class PropertyTools
   {
      
      public function PropertyTools()
      {
         super();
      }
      
      private static function getVariables() : void
      {
      }
      
      public static function getProperties(obj:Object) : Array
      {
         var ary:Array = null;
         var xmlDoc:XML = null;
         var item:XML = null;
         var name:String = null;
         var type:String = null;
         var value:Object = null;
         ary = [];
         try
         {
            xmlDoc = describeType(obj);
            for each(item in xmlDoc.variable)
            {
               name = item.@name.toString();
               type = item.@type.toString();
               value = obj[name] != null ? obj[name] : "";
               ary.push({
                  "name":name,
                  "type":type,
                  "value":value
               });
            }
         }
         catch(e:Error)
         {
         }
         return ary;
      }
      
      private static function getMethods() : void
      {
      }
   }
}

