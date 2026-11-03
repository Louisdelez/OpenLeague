package mx.rpc.http.mxml
{
   import mx.core.IMXMLObject;
   import mx.rpc.http.HTTPMultiService;
   import mx.rpc.mxml.IMXMLSupport;
   
   [ResourceBundle("rpc")]
   public dynamic class HTTPMultiService extends mx.rpc.http.HTTPMultiService implements IMXMLSupport, IMXMLObject
   {
      
      private var id:String;
      
      private var document:Object;
      
      public function HTTPMultiService(rootURL:String = null, destination:String = null)
      {
         super(rootURL,destination);
      }
      
      public function initialized(document:Object, id:String) : void
      {
         this.id = id;
         this.document = document;
         initialize();
      }
   }
}

