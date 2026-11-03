package hr.binaria.asx3m.mapper
{
   import hr.binaria.asx3m.converters.ISingleValueConverter;
   
   public interface IMapper
   {
      
      function getConverterFromItemType(param1:String, param2:Class, param3:Class) : ISingleValueConverter;
      
      function aliasForAttribute(param1:Class, param2:String) : String;
      
      function getItemTypeForItemFieldName(param1:Class, param2:String) : Class;
      
      function shouldSerializeMember(param1:Class, param2:String) : Boolean;
      
      function getConverterFromAttribute(param1:Class, param2:String) : ISingleValueConverter;
      
      function defaultImplementationOf(param1:Class) : Class;
      
      function lookupMapperOfType(param1:Class) : IMapper;
      
      function attributeForAlias(param1:Class, param2:String) : String;
      
      function isImmutableValueType(param1:Class) : Boolean;
      
      function serializedClass(param1:Class) : String;
      
      function realMember(param1:Class, param2:String) : String;
      
      function realClass(param1:String) : Class;
      
      function getFieldNameForItemTypeAndName(param1:Class, param2:Class, param3:String) : String;
      
      function serializedMember(param1:Class, param2:String) : String;
   }
}

