package mx.rpc.wsdl
{
   [ExcludeClass]
   public class WSDLPortType
   {
      
      private var _operations:Object;
      
      private var _name:String;
      
      public function WSDLPortType(name:String)
      {
         super();
         _name = name;
         _operations = {};
      }
      
      public function getOperation(name:String) : WSDLOperation
      {
         return _operations[name];
      }
      
      public function addOperation(operation:WSDLOperation) : void
      {
         _operations[operation.name] = operation;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function operations() : Object
      {
         return _operations;
      }
   }
}

