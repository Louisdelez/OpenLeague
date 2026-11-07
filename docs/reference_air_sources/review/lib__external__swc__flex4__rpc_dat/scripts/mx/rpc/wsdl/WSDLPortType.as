package mx.rpc.wsdl
{
   [ExcludeClass]
   public class WSDLPortType
   {
      
      private var _name:String;
      
      private var _operations:Object;
      
      public function WSDLPortType(name:String)
      {
         super();
         this._name = name;
         this._operations = {};
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function operations() : Object
      {
         return this._operations;
      }
      
      public function addOperation(operation:WSDLOperation) : void
      {
         this._operations[operation.name] = operation;
      }
      
      public function getOperation(name:String) : WSDLOperation
      {
         return this._operations[name];
      }
   }
}

