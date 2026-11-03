package mx.rpc.remoting.mxml
{
   import mx.rpc.mxml.IMXMLSupport;
   import mx.rpc.remoting.Operation;
   import mx.rpc.remoting.RemoteObject;
   
   [ResourceBundle("rpc")]
   public class Operation extends mx.rpc.remoting.Operation implements IMXMLSupport
   {
      
      public function Operation(remoteObject:mx.rpc.remoting.RemoteObject = null, name:String = null)
      {
         super(remoteObject,name);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getNetmonId() : String
      {
         return remoteObject.id;
      }
   }
}

