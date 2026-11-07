package mx.rpc.xml
{
   [ExcludeClass]
   internal dynamic class SimpleContent
   {
      
      public var value:*;
      
      public function SimpleContent(val:*)
      {
         super();
         this.value = val;
      }
      
      public function toString() : String
      {
         var object:Object = this.value as Object;
         return object == null ? null : object.toString();
      }
      
      public function valueOf() : Object
      {
         return this.value as Object;
      }
   }
}

