package mx.rpc.soap
{
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import mx.rpc.soap.types.ApacheDocumentType;
   import mx.rpc.soap.types.DataSetType;
   import mx.rpc.soap.types.ICustomSOAPType;
   import mx.rpc.soap.types.MapType;
   import mx.rpc.soap.types.QueryBeanType;
   import mx.rpc.soap.types.RowSetType;
   import mx.rpc.soap.types.SOAPArrayType;
   import mx.utils.URLUtil;
   
   [ExcludeClass]
   public class SOAPConstants
   {
      
      private static var constantsCache:Object;
      
      private static var customTypesInitialized:Boolean;
      
      private static var typeMap:Object = {};
      
      public static const queryBeanQName:QName = new QName(COLD_FUSION_URI,"QueryBean");
      
      public static const rowSetQName:QName = new QName(APACHE_SOAP_URI,"RowSet");
      
      public static const mapQName:QName = new QName(APACHE_SOAP_URI,"Map");
      
      public static const documentQName:QName = new QName(APACHE_SOAP_URI,"Document");
      
      public static const msdataURI:String = "urn:schemas-microsoft-com:xml-msdata";
      
      public static const diffgramQName:QName = new QName("urn:schemas-microsoft-com:xml-diffgram-v1","diffgram");
      
      public static const SOAP_ENVELOPE_URI:String = "http://schemas.xmlsoap.org/soap/envelope/";
      
      public static const SOAP12_ENVELOPE_URI:String = "http://www.w3.org/2002/12/soap-envelope";
      
      public static const XML_DECLARATION:String = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";
      
      public static const SOAP_ENCODING_URI:String = "http://schemas.xmlsoap.org/soap/encoding/";
      
      public static const SOAP12_ENCODING_URI:String = "http://www.w3.org/2002/12/soap-encoding";
      
      public static const SOAP_CONTENT_TYPE:String = "text/xml; charset=utf-8";
      
      public static const SOAP12_CONTENT_TYPE:String = "application/soap+xml; charset=utf-8";
      
      public static const RPC_STYLE:String = "rpc";
      
      public static const DOC_STYLE:String = "document";
      
      public static const WRAPPED_STYLE:String = "wrapped";
      
      public static const USE_ENCODED:String = "encoded";
      
      public static const USE_LITERAL:String = "literal";
      
      public static const DEFAULT_OPERATION_STYLE:String = "document";
      
      public static const DEFAULT_USE:String = "literal";
      
      public static const SOAP_ENV_PREFIX:String = "SOAP-ENV";
      
      public static const SOAP_ENC_PREFIX:String = "SOAP-ENC";
      
      public static const COLD_FUSION_URI:String = "http://rpc.xml.coldfusion";
      
      public static const APACHE_SOAP_URI:String = "http://xml.apache.org/xml-soap";
      
      public var envelopeQName:QName;
      
      public var headerQName:QName;
      
      public var bodyQName:QName;
      
      public var faultQName:QName;
      
      public var actorQName:QName;
      
      public var mustUnderstandQName:QName;
      
      public var soapencArrayQName:QName;
      
      public var soapencArrayTypeQName:QName;
      
      public var soapencRefQName:QName;
      
      public var soapoffsetQName:QName;
      
      public var soapBase64QName:QName;
      
      private var _contentType:String;
      
      private var _envelopeNS:Namespace;
      
      private var _encodingNS:Namespace;
      
      public function SOAPConstants(envelopeNS:Namespace = null, encodingNS:Namespace = null)
      {
         super();
         if(envelopeNS == null)
         {
            envelopeNS = new Namespace(SOAP_ENV_PREFIX,SOAP_ENVELOPE_URI);
         }
         if(encodingNS == null)
         {
            encodingNS = new Namespace(SOAP_ENC_PREFIX,SOAP_ENCODING_URI);
         }
         this._envelopeNS = envelopeNS;
         this._encodingNS = encodingNS;
         this.envelopeQName = new QName(this.envelopeURI,"Envelope");
         this.headerQName = new QName(this.envelopeURI,"Header");
         this.bodyQName = new QName(this.envelopeURI,"Body");
         this.faultQName = new QName(this.envelopeURI,"Fault");
         this.actorQName = new QName(this.envelopeURI,"actor");
         this.mustUnderstandQName = new QName(this.envelopeURI,"mustUnderstand");
         this.soapencArrayQName = new QName(this.encodingURI,"Array");
         this.soapencArrayTypeQName = new QName(this.encodingURI,"arrayType");
         this.soapencRefQName = new QName(this.encodingURI,"multiRef");
         this.soapoffsetQName = new QName(this.encodingURI,"offset");
         this.soapBase64QName = new QName(this.encodingURI,"base64");
         if(!customTypesInitialized)
         {
            initCustomSOAPTypes();
         }
         registerCustomSOAPType(this.soapencArrayQName,SOAPArrayType);
         registerCustomSOAPType(this.soapencArrayTypeQName,SOAPArrayType);
      }
      
      public static function getConstants(xml:XML = null) : SOAPConstants
      {
         var envelopeNS:Namespace = null;
         var encodingNS:Namespace = null;
         var nsArray:Array = null;
         var ns:Namespace = null;
         if(xml != null)
         {
            nsArray = xml.namespaceDeclarations();
            for each(ns in nsArray)
            {
               if(URLUtil.urisEqual(ns.uri,SOAP_ENVELOPE_URI) || URLUtil.urisEqual(ns.uri,SOAP12_ENVELOPE_URI))
               {
                  envelopeNS = ns;
               }
               else if(URLUtil.urisEqual(ns.uri,SOAP_ENCODING_URI) || URLUtil.urisEqual(ns.uri,SOAP12_ENCODING_URI))
               {
                  encodingNS = ns;
               }
            }
         }
         if(envelopeNS == null)
         {
            envelopeNS = new Namespace(SOAP_ENV_PREFIX,SOAP_ENVELOPE_URI);
         }
         if(encodingNS == null)
         {
            encodingNS = new Namespace(SOAP_ENC_PREFIX,SOAP_ENCODING_URI);
         }
         if(constantsCache == null)
         {
            constantsCache = {};
         }
         var constants:SOAPConstants = constantsCache[envelopeNS.uri];
         if(constants == null)
         {
            constants = new SOAPConstants(envelopeNS,encodingNS);
            constantsCache[envelopeNS.uri] = constants;
         }
         return constants;
      }
      
      public static function isSOAPEncodedType(type:QName) : Boolean
      {
         var uri:String = type != null ? type.uri : null;
         if(uri != null)
         {
            if(URLUtil.urisEqual(uri,SOAPConstants.SOAP_ENCODING_URI) || URLUtil.urisEqual(uri,SOAPConstants.SOAP12_ENCODING_URI))
            {
               return true;
            }
         }
         return false;
      }
      
      public static function getCustomSOAPType(type:QName) : ICustomSOAPType
      {
         var soapType:ICustomSOAPType = null;
         var key:String = null;
         var definitionName:String = null;
         var c:Class = null;
         if(type != null)
         {
            key = getKey(type);
            definitionName = typeMap[key] as String;
            if(definitionName != null)
            {
               try
               {
                  c = getDefinitionByName(definitionName) as Class;
                  soapType = new c() as ICustomSOAPType;
               }
               catch(e:Error)
               {
               }
            }
         }
         return soapType;
      }
      
      public static function registerCustomSOAPType(type:QName, definition:*) : void
      {
         var definitionName:String = null;
         var key:String = getKey(type);
         if(definition is String)
         {
            definitionName = definition as String;
         }
         else
         {
            definitionName = getQualifiedClassName(definition);
         }
         typeMap[key] = definitionName;
      }
      
      public static function unregisterCustomSOAPType(type:QName) : void
      {
         var key:String = null;
         if(type != null)
         {
            key = getKey(type);
            delete typeMap[key];
         }
      }
      
      private static function getKey(type:QName) : String
      {
         var key:String = null;
         if(type.uri == null || type.uri == "")
         {
            key = type.localName;
         }
         else
         {
            key = type.toString();
         }
         return key;
      }
      
      private static function initCustomSOAPTypes() : void
      {
         registerCustomSOAPType(queryBeanQName,QueryBeanType);
         registerCustomSOAPType(mapQName,MapType);
         registerCustomSOAPType(rowSetQName,RowSetType);
         registerCustomSOAPType(documentQName,ApacheDocumentType);
         registerCustomSOAPType(diffgramQName,DataSetType);
         customTypesInitialized = true;
      }
      
      public function get contentType() : String
      {
         return this._contentType;
      }
      
      public function get encodingURI() : String
      {
         return this.encodingNamespace.uri;
      }
      
      public function get encodingNamespace() : Namespace
      {
         return this._encodingNS;
      }
      
      public function get envelopeURI() : String
      {
         return this.envelopeNamespace.uri;
      }
      
      public function get envelopeNamespace() : Namespace
      {
         return this._envelopeNS;
      }
      
      public function getSOAPEncodingToken(type:QName) : String
      {
         return this.encodingNamespace.prefix + ":" + type.localName;
      }
   }
}

