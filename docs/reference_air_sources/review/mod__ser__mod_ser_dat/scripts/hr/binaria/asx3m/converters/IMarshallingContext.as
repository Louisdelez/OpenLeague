package hr.binaria.asx3m.converters
{
   public interface IMarshallingContext extends IDataHolder
   {
      
      function convertAnother(param1:Object, param2:IConverter) : void;
   }
}

