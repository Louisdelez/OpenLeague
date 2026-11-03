package blix.util.type
{
   import flash.utils.*;
   
   public function isType(param1:Object, param2:Class) : Boolean
   {
      var inheritance:XMLList;
      var value:Object = param1;
      var type:Class = param2;
      if(!(value is Class))
      {
         return value is type;
      }
      if(value == type)
      {
         return true;
      }
      inheritance = blix.util.type.describeType(value).factory.*.(localName() == "extendsClass" || localName() == "implementsInterface");
      return Boolean(inheritance.(@type == getQualifiedClassName(type)).length() > 0);
   }
}

