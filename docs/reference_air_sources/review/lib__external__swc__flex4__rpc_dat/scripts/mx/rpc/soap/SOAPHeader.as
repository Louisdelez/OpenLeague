package mx.rpc.soap
{
   public class SOAPHeader
   {
      
      public var content:Object;
      
      public var qname:QName;
      
      public var xmlType:QName;
      
      public var mustUnderstand:Boolean;
      
      public var role:String;
      
      public function SOAPHeader(qname:QName, content:Object)
      {
         super();
         this.qname = qname;
         this.content = content;
      }
      
      public function toString() : String
      {
         return this.qname + ", " + this.content + ", " + this.role;
      }
   }
}

