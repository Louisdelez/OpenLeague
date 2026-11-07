package mx.rpc.wsdl
{
   import mx.rpc.soap.SOAPConstants;
   import mx.rpc.xml.SchemaManager;
   
   [ExcludeClass]
   public class WSDLOperation
   {
      
      private var _soapAction:String;
      
      private var _soapConstants:SOAPConstants;
      
      public var outputMessage:WSDLMessage;
      
      private var _faultsMap:Object;
      
      private var _schemaManager:SchemaManager;
      
      public var inputMessage:WSDLMessage;
      
      private var _wsdlConstants:WSDLConstants;
      
      private var _name:String;
      
      [Inspectable(enumeration="document,rpc",category="General")]
      public var style:String;
      
      public var namespaces:Object;
      
      public function WSDLOperation(name:String)
      {
         super();
         _name = name;
      }
      
      public function addFault(fault:WSDLMessage) : void
      {
         if(_faultsMap == null)
         {
            _faultsMap = {};
         }
         _faultsMap[fault.name] = fault;
      }
      
      public function set soapAction(value:String) : void
      {
         _soapAction = value;
      }
      
      public function get soapConstants() : SOAPConstants
      {
         if(_soapConstants == null)
         {
            _soapConstants = SOAPConstants.getConstants(null);
         }
         return _soapConstants;
      }
      
      public function set soapConstants(value:SOAPConstants) : void
      {
         _soapConstants = value;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function get wsdlConstants() : WSDLConstants
      {
         if(_wsdlConstants == null)
         {
            _wsdlConstants = WSDLConstants.getConstants(null);
         }
         return _wsdlConstants;
      }
      
      public function get schemaManager() : SchemaManager
      {
         return _schemaManager;
      }
      
      public function set wsdlConstants(value:WSDLConstants) : void
      {
         _wsdlConstants = value;
      }
      
      public function set schemaManager(manager:SchemaManager) : void
      {
         _schemaManager = manager;
      }
      
      [Inspectable(defaultValue="",category="General")]
      public function get soapAction() : String
      {
         if(_soapAction == null)
         {
            _soapAction = "";
         }
         return _soapAction;
      }
      
      public function getFault(name:String) : WSDLMessage
      {
         var fault:WSDLMessage = null;
         if(_faultsMap != null)
         {
            fault = _faultsMap[name];
         }
         return fault;
      }
   }
}

