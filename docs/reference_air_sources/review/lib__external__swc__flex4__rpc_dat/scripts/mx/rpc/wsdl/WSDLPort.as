package mx.rpc.wsdl
{
   [ExcludeClass]
   public class WSDLPort
   {
      
      private var _binding:WSDLBinding;
      
      private var _endpointURI:String;
      
      private var _name:String;
      
      private var _service:WSDLService;
      
      public function WSDLPort(name:String, service:WSDLService)
      {
         super();
         this._name = name;
         this._service = service;
      }
      
      public function get binding() : WSDLBinding
      {
         return this._binding;
      }
      
      public function set binding(value:WSDLBinding) : void
      {
         this._binding = value;
      }
      
      public function get endpointURI() : String
      {
         return this._endpointURI;
      }
      
      public function set endpointURI(value:String) : void
      {
         this._endpointURI = value;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get service() : WSDLService
      {
         return this._service;
      }
      
      public function toString() : String
      {
         return "WSDLPort name=" + this._name + ", endpointURI=" + this._endpointURI + ", binding=" + this._binding;
      }
   }
}

