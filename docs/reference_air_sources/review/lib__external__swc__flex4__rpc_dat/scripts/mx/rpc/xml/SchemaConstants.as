package mx.rpc.xml
{
   import mx.utils.URLUtil;
   
   [ExcludeClass]
   public class SchemaConstants
   {
      
      private static var constantsCache:Object;
      
      public static const MODE_TYPE:int = 0;
      
      public static const MODE_ELEMENT:int = 1;
      
      public static const XSD_URI_1999:String = "http://www.w3.org/1999/XMLSchema";
      
      public static const XSD_URI_2000:String = "http://www.w3.org/2000/10/XMLSchema";
      
      public static const XSD_URI_2001:String = "http://www.w3.org/2001/XMLSchema";
      
      public static const XSI_URI_1999:String = "http://www.w3.org/1999/XMLSchema-instance";
      
      public static const XSI_URI_2000:String = "http://www.w3.org/2000/10/XMLSchema-instance";
      
      public static const XSI_URI_2001:String = "http://www.w3.org/2001/XMLSchema-instance";
      
      public static const XML_SCHEMA_PREFIX:String = "xsd";
      
      public static const XML_SCHEMA_INSTANCE_PREFIX:String = "xsi";
      
      public static const XML_SCHEMA_URI:String = "http://www.w3.org/2001/XMLSchema";
      
      public static const XML_SCHEMA_INSTANCE_URI:String = "http://www.w3.org/2001/XMLSchema-instance";
      
      public var allQName:QName;
      
      public var anyTypeQName:QName;
      
      public var annotationQName:QName;
      
      public var anyQName:QName;
      
      public var anyAttributeQName:QName;
      
      public var appinfoQName:QName;
      
      public var attributeQName:QName;
      
      public var attributeGroupQName:QName;
      
      public var choiceQName:QName;
      
      public var complexContentQName:QName;
      
      public var complexTypeQName:QName;
      
      public var documentationQName:QName;
      
      public var elementTypeQName:QName;
      
      public var enumerationTypeQName:QName;
      
      public var extensionQName:QName;
      
      public var fieldQName:QName;
      
      public var groupQName:QName;
      
      public var importQName:QName;
      
      public var includeQName:QName;
      
      public var keyQName:QName;
      
      public var keyrefQName:QName;
      
      public var lengthQName:QName;
      
      public var listQName:QName;
      
      public var maxInclusiveQName:QName;
      
      public var maxLengthQName:QName;
      
      public var minInclusiveQName:QName;
      
      public var minLengthQName:QName;
      
      public var nameQName:QName;
      
      public var patternQName:QName;
      
      public var redefineQName:QName;
      
      public var restrictionQName:QName;
      
      public var schemaQName:QName;
      
      public var selectorQName:QName;
      
      public var sequenceQName:QName;
      
      public var simpleContentQName:QName;
      
      public var simpleTypeQName:QName;
      
      public var unionQName:QName;
      
      public var uniqueQName:QName;
      
      public var nilQName:QName;
      
      public var typeAttrQName:QName;
      
      private var _xsdNS:Namespace;
      
      private var _xsiNS:Namespace;
      
      public function SchemaConstants(xsdNS:Namespace = null, xsiNS:Namespace = null)
      {
         super();
         if(xsdNS == null)
         {
            xsdNS = new Namespace(XML_SCHEMA_PREFIX,XSD_URI_2001);
         }
         if(xsiNS == null)
         {
            xsiNS = new Namespace(XML_SCHEMA_INSTANCE_PREFIX,XSI_URI_2001);
         }
         this._xsdNS = xsdNS;
         this._xsiNS = xsiNS;
         this.allQName = new QName(this.xsdURI,"all");
         this.annotationQName = new QName(this.xsdURI,"annotation");
         this.anyQName = new QName(this.xsdURI,"any");
         this.anyTypeQName = new QName(this.xsdURI,"anyType");
         this.anyAttributeQName = new QName(this.xsdURI,"anyAttribute");
         this.appinfoQName = new QName(this.xsdURI,"appinfo");
         this.attributeQName = new QName(this.xsdURI,"attribute");
         this.attributeGroupQName = new QName(this.xsdURI,"attributeGroup");
         this.choiceQName = new QName(this.xsdURI,"choice");
         this.complexContentQName = new QName(this.xsdURI,"complexContent");
         this.complexTypeQName = new QName(this.xsdURI,"complexType");
         this.documentationQName = new QName(this.xsdURI,"documentation");
         this.elementTypeQName = new QName(this.xsdURI,"element");
         this.enumerationTypeQName = new QName(this.xsdURI,"enumeration");
         this.extensionQName = new QName(this.xsdURI,"extension");
         this.fieldQName = new QName(this.xsdURI,"field");
         this.groupQName = new QName(this.xsdURI,"group");
         this.importQName = new QName(this.xsdURI,"import");
         this.includeQName = new QName(this.xsdURI,"include");
         this.keyQName = new QName(this.xsdURI,"key");
         this.keyrefQName = new QName(this.xsdURI,"keyref");
         this.lengthQName = new QName(this.xsdURI,"length");
         this.listQName = new QName(this.xsdURI,"list");
         this.maxInclusiveQName = new QName(this.xsdURI,"maxInclusive");
         this.maxLengthQName = new QName(this.xsdURI,"maxLength");
         this.minInclusiveQName = new QName(this.xsdURI,"minInclusive");
         this.minLengthQName = new QName(this.xsdURI,"minLength");
         this.nameQName = new QName(this.xsdURI,"name");
         this.patternQName = new QName(this.xsdURI,"pattern");
         this.redefineQName = new QName(this.xsdURI,"redefine");
         this.restrictionQName = new QName(this.xsdURI,"restriction");
         this.schemaQName = new QName(this.xsdURI,"schema");
         this.selectorQName = new QName(this.xsdURI,"selector");
         this.sequenceQName = new QName(this.xsdURI,"sequence");
         this.simpleContentQName = new QName(this.xsdURI,"simpleContent");
         this.simpleTypeQName = new QName(this.xsdURI,"simpleType");
         this.unionQName = new QName(this.xsdURI,"union");
         this.uniqueQName = new QName(this.xsdURI,"unique");
         var nilStr:String = "nil";
         if(this.xsdURI == SchemaConstants.XSD_URI_1999)
         {
            nilStr = "null";
         }
         this.nilQName = new QName(this.xsiURI,nilStr);
         this.typeAttrQName = new QName(this.xsiURI,"type");
      }
      
      public static function getConstants(xml:XML = null) : SchemaConstants
      {
         var xsdNS:Namespace = null;
         var xsiNS:Namespace = null;
         var nsArray:Array = null;
         var ns:Namespace = null;
         if(xml != null)
         {
            nsArray = xml.namespaceDeclarations();
            for each(ns in nsArray)
            {
               if(URLUtil.urisEqual(ns.uri,XSD_URI_1999))
               {
                  xsdNS = ns;
               }
               else if(URLUtil.urisEqual(ns.uri,XSD_URI_2000))
               {
                  xsdNS = ns;
               }
               else if(URLUtil.urisEqual(ns.uri,XSD_URI_2001))
               {
                  xsdNS = ns;
               }
               else if(URLUtil.urisEqual(ns.uri,XSI_URI_1999))
               {
                  xsiNS = ns;
               }
               else if(URLUtil.urisEqual(ns.uri,XSI_URI_2000))
               {
                  xsiNS = ns;
               }
               else if(URLUtil.urisEqual(ns.uri,XSI_URI_2001))
               {
                  xsiNS = ns;
               }
            }
         }
         if(xsdNS == null)
         {
            xsdNS = new Namespace(XML_SCHEMA_PREFIX,XSD_URI_2001);
         }
         if(xsiNS == null)
         {
            xsiNS = new Namespace(XML_SCHEMA_INSTANCE_PREFIX,XSI_URI_2001);
         }
         if(constantsCache == null)
         {
            constantsCache = {};
         }
         var constants:SchemaConstants = constantsCache[xsdNS.uri];
         if(constants == null)
         {
            constants = new SchemaConstants(xsdNS,xsiNS);
            constantsCache[xsdNS.uri] = constants;
         }
         return constants;
      }
      
      public function get xsdURI() : String
      {
         return this.xsdNamespace.uri;
      }
      
      public function get xsdNamespace() : Namespace
      {
         return this._xsdNS;
      }
      
      public function get xsiURI() : String
      {
         return this.xsiNamespace.uri;
      }
      
      public function get xsiNamespace() : Namespace
      {
         return this._xsiNS;
      }
      
      public function getXSDToken(type:QName) : String
      {
         return this.xsdNamespace.prefix + ":" + type.localName;
      }
      
      public function getXSIToken(type:QName) : String
      {
         return this.xsiNamespace.prefix + ":" + type.localName;
      }
      
      public function getQName(localName:String) : QName
      {
         if(localName == "type")
         {
            return this.typeAttrQName;
         }
         return new QName(this.xsdURI,localName);
      }
   }
}

