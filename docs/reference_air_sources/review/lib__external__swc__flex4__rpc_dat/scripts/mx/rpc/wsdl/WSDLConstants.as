package mx.rpc.wsdl
{
   import mx.utils.URLUtil;
   
   [ExcludeClass]
   public class WSDLConstants
   {
      
      private static var constantsCache:Object;
      
      public static const SOAP_HTTP_URI:String = "http://schemas.xmlsoap.org/soap/http/";
      
      public static const MODE_IN:int = 0;
      
      public static const MODE_OUT:int = 1;
      
      public static const MODE_FAULT:int = 2;
      
      public static const MODE_HEADER:int = 3;
      
      public static const WSDL_URI:String = "http://schemas.xmlsoap.org/wsdl/";
      
      public static const WSDL_SOAP_URI:String = "http://schemas.xmlsoap.org/wsdl/soap/";
      
      public static const WSDL_SOAP12_URI:String = "http://schemas.xmlsoap.org/wsdl/soap12/";
      
      public static const WSDL_HTTP_URI:String = "http://schemas.xmlsoap.org/wsdl/http/";
      
      public static const WSDL20_URI:String = "http://www.w3.org/2006/01/wsdl";
      
      public static const WSDL20_SOAP_URI:String = "http://www.w3.org/2006/01/wsdl/soap";
      
      public static const WSDL20_SOAP12_URI:String = "http://www.w3.org/2006/01/wsdl/soap";
      
      public static const WSDL20_HTTP_URI:String = "http://www.w3.org/2006/01/wsdl/http";
      
      public static const WSDL_PREFIX:String = "wsdl";
      
      public static const WSDL_SOAP_PREFIX:String = "wsoap";
      
      public static const DEFAULT_STYLE:String = "document";
      
      public static const DEFAULT_WSDL_VERSION:String = "1.1";
      
      public var definitionsQName:QName;
      
      public var typesQName:QName;
      
      public var messageQName:QName;
      
      public var portTypeQName:QName;
      
      public var bindingQName:QName;
      
      public var serviceQName:QName;
      
      public var importQName:QName;
      
      public var documentationQName:QName;
      
      public var portQName:QName;
      
      public var operationQName:QName;
      
      public var inputQName:QName;
      
      public var outputQName:QName;
      
      public var partQName:QName;
      
      public var faultQName:QName;
      
      public var wsdlArrayTypeQName:QName;
      
      public var soapAddressQName:QName;
      
      public var soapBindingQName:QName;
      
      public var soapOperationQName:QName;
      
      public var soapBodyQName:QName;
      
      public var soapFaultQName:QName;
      
      public var soapHeaderQName:QName;
      
      public var soapHeaderFaultQName:QName;
      
      private var _soapNS:Namespace;
      
      private var _wsdlNS:Namespace;
      
      public function WSDLConstants(wsdlNS:Namespace = null, soapNS:Namespace = null)
      {
         super();
         if(wsdlNS == null)
         {
            wsdlNS = new Namespace(WSDL_PREFIX,WSDL_URI);
         }
         if(soapNS == null)
         {
            soapNS = new Namespace(WSDL_SOAP_PREFIX,WSDL_SOAP_URI);
         }
         this._wsdlNS = wsdlNS;
         this._soapNS = soapNS;
         this.definitionsQName = new QName(this.wsdlURI,"definitions");
         this.importQName = new QName(this.wsdlURI,"import");
         this.typesQName = new QName(this.wsdlURI,"types");
         this.messageQName = new QName(this.wsdlURI,"message");
         this.portTypeQName = new QName(this.wsdlURI,"portType");
         this.bindingQName = new QName(this.wsdlURI,"binding");
         this.serviceQName = new QName(this.wsdlURI,"service");
         this.documentationQName = new QName(this.wsdlURI,"documentation");
         this.portQName = new QName(this.wsdlURI,"port");
         this.operationQName = new QName(this.wsdlURI,"operation");
         this.inputQName = new QName(this.wsdlURI,"input");
         this.outputQName = new QName(this.wsdlURI,"output");
         this.partQName = new QName(this.wsdlURI,"part");
         this.faultQName = new QName(this.wsdlURI,"fault");
         this.wsdlArrayTypeQName = new QName(this.wsdlURI,"arrayType");
         this.soapAddressQName = new QName(this.soapURI,"address");
         this.soapBindingQName = new QName(this.soapURI,"binding");
         this.soapOperationQName = new QName(this.soapURI,"operation");
         this.soapBodyQName = new QName(this.soapURI,"body");
         this.soapFaultQName = new QName(this.soapURI,"fault");
         this.soapHeaderQName = new QName(this.soapURI,"header");
         this.soapHeaderFaultQName = new QName(this.soapURI,"headerfault");
      }
      
      public static function getConstants(xml:XML) : WSDLConstants
      {
         var wsdlNS:Namespace = null;
         var soapNS:Namespace = null;
         var nsArray:Array = null;
         var ns:Namespace = null;
         if(xml != null)
         {
            nsArray = xml.inScopeNamespaces();
            for each(ns in nsArray)
            {
               if(URLUtil.urisEqual(ns.uri,WSDL_URI))
               {
                  wsdlNS = ns;
               }
               else if(URLUtil.urisEqual(ns.uri,WSDL20_URI))
               {
                  wsdlNS = ns;
               }
               if(URLUtil.urisEqual(ns.uri,WSDL_SOAP_URI))
               {
                  soapNS = ns;
               }
               else if(URLUtil.urisEqual(ns.uri,WSDL20_SOAP_URI))
               {
                  soapNS = ns;
               }
               else if(URLUtil.urisEqual(ns.uri,WSDL20_SOAP12_URI))
               {
                  soapNS = ns;
               }
            }
         }
         if(wsdlNS == null)
         {
            wsdlNS = new Namespace(WSDL_PREFIX,WSDL_URI);
         }
         if(soapNS == null)
         {
            soapNS = new Namespace(WSDL_SOAP_PREFIX,WSDL_SOAP_URI);
         }
         if(constantsCache == null)
         {
            constantsCache = {};
         }
         var constants:WSDLConstants = constantsCache[wsdlNS.uri];
         if(constants == null)
         {
            constants = new WSDLConstants(wsdlNS,soapNS);
            constantsCache[wsdlNS.uri] = constants;
         }
         return constants;
      }
      
      public function get soapURI() : String
      {
         return this.soapNamespace.uri;
      }
      
      public function get wsdlURI() : String
      {
         return this.wsdlNamespace.uri;
      }
      
      public function get soapNamespace() : Namespace
      {
         return this._soapNS;
      }
      
      public function get wsdlNamespace() : Namespace
      {
         return this._wsdlNS;
      }
   }
}

