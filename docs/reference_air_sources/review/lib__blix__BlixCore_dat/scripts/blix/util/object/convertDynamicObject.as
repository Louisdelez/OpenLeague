package blix.util.object
{
   import blix.util.date.parseDate;
   import blix.util.string.parseBool;
   import blix.util.string.strToCamelCase;
   import blix.util.type.describeType;
   import flash.utils.getDefinitionByName;
   
   public function convertDynamicObject(param1:Object, param2:Object) : void
   {
      var typeXml:XML = null;
      var properties:XMLList = null;
      var clazz:Class = null;
      var all:String = null;
      var n:String = null;
      var prop:XMLList = null;
      var className:String = null;
      var value:* = undefined;
      var parsedValue:* = undefined;
      var vKey:String = null;
      var isVector:Boolean = false;
      var index:int = 0;
      var vector:* = undefined;
      var elementType:String = null;
      var elementClass:Class = null;
      var item:* = undefined;
      var newElement:* = undefined;
      var dynamicObject:Object = param1;
      var strongObject:Object = param2;
      typeXml = describeType(strongObject.constructor);
      properties = typeXml.factory.children().(name() == "accessor" && @access == "readwrite" || name() == "variable");
      for(all in dynamicObject)
      {
         n = strToCamelCase(all);
         prop = properties.(@name == n);
         className = prop.@type;
         if(strongObject.hasOwnProperty(n))
         {
            value = dynamicObject[all];
            if(typeof value != "object")
            {
               switch(className)
               {
                  case "Boolean":
                     parsedValue = parseBool(value);
                     break;
                  case "int":
                  case "uint":
                     parsedValue = parseInt(value);
                     break;
                  case "Number":
                     parsedValue = parseFloat(value);
                     break;
                  case "Date":
                     parsedValue = parseDate(value);
                     break;
                  case "String":
                  default:
                     parsedValue = String(value);
               }
               strongObject[n] = parsedValue;
            }
            else if(strongObject.hasOwnProperty(n))
            {
               vKey = "__AS3__.vec::Vector.<";
               isVector = className.indexOf(vKey) === 0;
               if(isVector)
               {
                  index = className.indexOf(vKey);
                  clazz = getDefinitionByName(className) as Class;
                  vector = new clazz();
                  elementType = className.substring(vKey.length,className.length - 1);
                  elementClass = getDefinitionByName(elementType) as Class;
                  for each(item in value)
                  {
                     newElement = new elementClass();
                     blix.util.object.convertDynamicObject(item,newElement);
                     vector.push(newElement);
                  }
                  strongObject[n] = vector;
               }
               else
               {
                  clazz = getDefinitionByName(className) as Class;
                  strongObject[n] = new clazz();
                  blix.util.object.convertDynamicObject(value,strongObject[n]);
               }
            }
         }
      }
   }
}

