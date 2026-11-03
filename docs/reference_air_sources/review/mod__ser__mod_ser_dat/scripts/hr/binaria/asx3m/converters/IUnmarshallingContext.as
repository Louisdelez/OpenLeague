package hr.binaria.asx3m.converters
{
   public interface IUnmarshallingContext extends IDataHolder
   {
      
      function convertAnother(param1:Object, param2:Class, param3:IConverter) : Object;
      
      function getRequiredType() : Class;
      
      function currentObject() : Object;
   }
}

