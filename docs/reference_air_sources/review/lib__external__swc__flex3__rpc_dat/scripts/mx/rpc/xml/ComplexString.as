package mx.rpc.xml
{
   [ExcludeClass]
   internal dynamic class ComplexString
   {
      
      public var value:String;
      
      public function ComplexString(val:String)
      {
         super();
         value = val;
      }
      
      public function valueOf() : Object
      {
         return SimpleXMLDecoder.simpleType(value);
      }
      
      public function toString() : String
      {
         return value;
      }
   }
}

