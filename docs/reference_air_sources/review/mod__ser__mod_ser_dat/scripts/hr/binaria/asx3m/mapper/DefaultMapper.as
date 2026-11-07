package hr.binaria.asx3m.mapper
{
   import flash.utils.getDefinitionByName;
   import hr.binaria.asx3m.converters.ISingleValueConverter;
   import system.Reflection;
   
   public class DefaultMapper implements IMapper
   {
      
      public function DefaultMapper()
      {
         super();
      }
      
      public function getConverterFromItemType(param1:String, param2:Class, param3:Class) : ISingleValueConverter
      {
         return null;
      }
      
      public function serializedMember(param1:Class, param2:String) : String
      {
         return param2;
      }
      
      public function getConverterFromAttribute(param1:Class, param2:String) : ISingleValueConverter
      {
         return null;
      }
      
      public function realClass(param1:String) : Class
      {
         var elementName:String = param1;
         var realClass:Class = null;
         try
         {
            elementName = convertToFlexClassName(elementName);
            realClass = getDefinitionByName(elementName) as Class;
         }
         catch(e:ReferenceError)
         {
         }
         return realClass;
      }
      
      public function defaultImplementationOf(param1:Class) : Class
      {
         return param1;
      }
      
      public function attributeForAlias(param1:Class, param2:String) : String
      {
         return param2;
      }
      
      public function getItemTypeForItemFieldName(param1:Class, param2:String) : Class
      {
         return null;
      }
      
      public function realMember(param1:Class, param2:String) : String
      {
         return param2;
      }
      
      public function getFieldNameForItemTypeAndName(param1:Class, param2:Class, param3:String) : String
      {
         return null;
      }
      
      public function serializedClass(param1:Class) : String
      {
         return Reflection.getClassName(param1,true).replace(/::/,".");
      }
      
      public function aliasForAttribute(param1:Class, param2:String) : String
      {
         return param2;
      }
      
      public function lookupMapperOfType(param1:Class) : IMapper
      {
         return null;
      }
      
      public function shouldSerializeMember(param1:Class, param2:String) : Boolean
      {
         return true;
      }
      
      public function lookupName(param1:Class) : String
      {
         return serializedClass(param1);
      }
      
      public function lookupType(param1:String) : Class
      {
         return realClass(param1);
      }
      
      public function isImmutableValueType(param1:Class) : Boolean
      {
         return false;
      }
      
      private function convertToFlexClassName(param1:String) : String
      {
         var _loc2_:int = 0;
         if(param1.indexOf(".") != -1 && param1.indexOf("::") == -1)
         {
            _loc2_ = param1.lastIndexOf(".");
            param1 = param1.substring(0,_loc2_) + "::" + param1.substring(_loc2_ + 1,param1.length);
         }
         return param1;
      }
   }
}

