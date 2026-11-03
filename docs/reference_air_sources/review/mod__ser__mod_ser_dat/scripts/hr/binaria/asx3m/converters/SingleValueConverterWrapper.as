package hr.binaria.asx3m.converters
{
   import hr.binaria.asx3m.io.IHierarchicalStreamReader;
   import hr.binaria.asx3m.io.IHierarchicalStreamWriter;
   
   public class SingleValueConverterWrapper implements IConverter, ISingleValueConverter
   {
      
      private var wrapped:ISingleValueConverter;
      
      public function SingleValueConverterWrapper(param1:ISingleValueConverter)
      {
         super();
         this.wrapped = param1;
      }
      
      public function canConvert(param1:Class) : Boolean
      {
         return wrapped.canConvert(param1);
      }
      
      public function toString(param1:Object) : String
      {
         return wrapped.toString(param1);
      }
      
      public function unmarshal(param1:IHierarchicalStreamReader, param2:IUnmarshallingContext) : Object
      {
         return fromString(param1.getValue());
      }
      
      public function fromString(param1:String) : Object
      {
         return wrapped.fromString(param1);
      }
      
      public function marshal(param1:Object, param2:IHierarchicalStreamWriter, param3:IMarshallingContext) : void
      {
         param2.setValue(toString(param1));
      }
   }
}

