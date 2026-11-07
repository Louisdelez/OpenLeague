package mx.rpc.wsdl
{
   [ExcludeClass]
   public class WSDLService
   {
      
      private var _ports:Object;
      
      private var _defaultPort:WSDLPort;
      
      private var _name:String;
      
      public function WSDLService(name:String)
      {
         super();
         _name = name;
         _ports = {};
      }
      
      public function addPort(port:WSDLPort) : void
      {
         _ports[port.name] = port;
         if(_defaultPort == null)
         {
            _defaultPort = port;
         }
      }
      
      public function get ports() : Object
      {
         return _ports;
      }
      
      public function getPort(name:String) : WSDLPort
      {
         return _ports[name];
      }
      
      public function get defaultPort() : WSDLPort
      {
         return _defaultPort;
      }
      
      public function get name() : String
      {
         return _name;
      }
   }
}

