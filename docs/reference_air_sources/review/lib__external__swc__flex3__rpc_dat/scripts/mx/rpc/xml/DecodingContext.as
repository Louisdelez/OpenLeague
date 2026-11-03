package mx.rpc.xml
{
   [ExcludeClass]
   public class DecodingContext
   {
      
      public var laxSequence:Boolean = false;
      
      public var index:int = 0;
      
      public var anyIndex:int = -1;
      
      public var hasContextSiblings:Boolean = false;
      
      public function DecodingContext()
      {
         super();
      }
   }
}

