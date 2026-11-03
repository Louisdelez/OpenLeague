package mx.rpc.xml
{
   [ExcludeClass]
   internal dynamic class SimpleContent
   {
      
      public var value:*;
      
      public function SimpleContent(val:*)
      {
         super();
         value = val;
      }
      
      public function valueOf() : Object
      {
         return value as Object;
      }
      
      public function toString() : String
      {
         var object:Object = value as Object;
         return object == null ? null : object.toString();
      }
   }
}

