package mx.rpc.soap
{
   public class SOAPHeader
   {
      
      public var xmlType:QName;
      
      public var role:String;
      
      public var mustUnderstand:Boolean;
      
      public var content:Object;
      
      public var qname:QName;
      
      public function SOAPHeader(qname:QName, content:Object)
      {
         super();
         this.qname = qname;
         this.content = content;
      }
      
      public function toString() : String
      {
         return qname + ", " + content + ", " + role;
      }
   }
}

