package mx.rpc.wsdl
{
   [ExcludeClass]
   public class WSDLPort
   {
      
      private var _binding:WSDLBinding;
      
      private var _name:String;
      
      private var _service:WSDLService;
      
      private var _endpointURI:String;
      
      public function WSDLPort(name:String, service:WSDLService)
      {
         super();
         _name = name;
         _service = service;
      }
      
      public function get binding() : WSDLBinding
      {
         return _binding;
      }
      
      public function set binding(value:WSDLBinding) : void
      {
         _binding = value;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function toString() : String
      {
         return "WSDLPort name=" + _name + ", endpointURI=" + _endpointURI + ", binding=" + _binding;
      }
      
      public function set endpointURI(value:String) : void
      {
         _endpointURI = value;
      }
      
      public function get service() : WSDLService
      {
         return _service;
      }
      
      public function get endpointURI() : String
      {
         return _endpointURI;
      }
   }
}

