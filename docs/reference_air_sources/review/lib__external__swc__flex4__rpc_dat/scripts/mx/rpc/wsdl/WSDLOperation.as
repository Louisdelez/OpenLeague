package mx.rpc.wsdl
{
   import mx.rpc.soap.SOAPConstants;
   import mx.rpc.xml.SchemaManager;
   
   [ExcludeClass]
   public class WSDLOperation
   {
      
      public var inputMessage:WSDLMessage;
      
      public var namespaces:Object;
      
      public var outputMessage:WSDLMessage;
      
      [Inspectable(enumeration="document,rpc",category="General")]
      public var style:String;
      
      private var _faultsMap:Object;
      
      private var _name:String;
      
      private var _soapAction:String;
      
      private var _soapConstants:SOAPConstants;
      
      private var _schemaManager:SchemaManager;
      
      private var _wsdlConstants:WSDLConstants;
      
      public function WSDLOperation(name:String)
      {
         super();
         this._name = name;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get schemaManager() : SchemaManager
      {
         return this._schemaManager;
      }
      
      public function set schemaManager(manager:SchemaManager) : void
      {
         this._schemaManager = manager;
      }
      
      [Inspectable(defaultValue="",category="General")]
      public function get soapAction() : String
      {
         if(this._soapAction == null)
         {
            this._soapAction = "";
         }
         return this._soapAction;
      }
      
      public function set soapAction(value:String) : void
      {
         this._soapAction = value;
      }
      
      public function get soapConstants() : SOAPConstants
      {
         if(this._soapConstants == null)
         {
            this._soapConstants = SOAPConstants.getConstants(null);
         }
         return this._soapConstants;
      }
      
      public function set soapConstants(value:SOAPConstants) : void
      {
         this._soapConstants = value;
      }
      
      public function get wsdlConstants() : WSDLConstants
      {
         if(this._wsdlConstants == null)
         {
            this._wsdlConstants = WSDLConstants.getConstants(null);
         }
         return this._wsdlConstants;
      }
      
      public function set wsdlConstants(value:WSDLConstants) : void
      {
         this._wsdlConstants = value;
      }
      
      public function addFault(fault:WSDLMessage) : void
      {
         if(this._faultsMap == null)
         {
            this._faultsMap = {};
         }
         this._faultsMap[fault.name] = fault;
      }
      
      public function getFault(name:String) : WSDLMessage
      {
         var fault:WSDLMessage = null;
         if(this._faultsMap != null)
         {
            fault = this._faultsMap[name];
         }
         return fault;
      }
   }
}

