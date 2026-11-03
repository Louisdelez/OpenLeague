package mx.rpc.wsdl
{
   [ExcludeClass]
   public class WSDLService
   {
      
      private var _defaultPort:WSDLPort;
      
      private var _name:String;
      
      private var _ports:Object;
      
      public function WSDLService(name:String)
      {
         super();
         this._name = name;
         this._ports = {};
      }
      
      public function get defaultPort() : WSDLPort
      {
         return this._defaultPort;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get ports() : Object
      {
         return this._ports;
      }
      
      public function addPort(port:WSDLPort) : void
      {
         this._ports[port.name] = port;
         if(this._defaultPort == null)
         {
            this._defaultPort = port;
         }
      }
      
      public function getPort(name:String) : WSDLPort
      {
         return this._ports[name];
      }
   }
}

