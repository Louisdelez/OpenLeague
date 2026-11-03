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
      
      public var documentationQName:QName;
      
      public var minInclusiveQName:QName;
      
      public var enumerationTypeQName:QName;
      
      public var keyQName:QName;
      
      public var appinfoQName:QName;
      
      public var anyQName:QName;
      
      public var typeAttrQName:QName;
      
      public var choiceQName:QName;
      
      public var maxInclusiveQName:QName;
      
      public var redefineQName:QName;
      
      public var anyTypeQName:QName;
      
      public var attributeGroupQName:QName;
      
      private var _xsiNS:Namespace;
      
      public var extensionQName:QName;
      
      public var listQName:QName;
      
      public var selectorQName:QName;
      
      public var patternQName:QName;
      
      public var minLengthQName:QName;
      
      public var keyrefQName:QName;
      
      public var restrictionQName:QName;
      
      public var annotationQName:QName;
      
      public var nilQName:QName;
      
      public var complexTypeQName:QName;
      
      public var fieldQName:QName;
      
      public var unionQName:QName;
      
      public var uniqueQName:QName;
      
      public var schemaQName:QName;
      
      public var nameQName:QName;
      
      public var maxLengthQName:QName;
      
      public var includeQName:QName;
      
      public var lengthQName:QName;
      
      public var sequenceQName:QName;
      
      public var groupQName:QName;
      
      private var _xsdNS:Namespace;
      
      public var attributeQName:QName;
      
      public var elementTypeQName:QName;
      
      public var anyAttributeQName:QName;
      
      public var simpleTypeQName:QName;
      
      public var complexContentQName:QName;
      
      public var importQName:QName;
      
      public var allQName:QName;
      
      public var simpleContentQName:QName;
      
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
         _xsdNS = xsdNS;
         _xsiNS = xsiNS;
         allQName = new QName(xsdURI,"all");
         annotationQName = new QName(xsdURI,"annotation");
         anyQName = new QName(xsdURI,"any");
         anyTypeQName = new QName(xsdURI,"anyType");
         anyAttributeQName = new QName(xsdURI,"anyAttribute");
         appinfoQName = new QName(xsdURI,"appinfo");
         attributeQName = new QName(xsdURI,"attribute");
         attributeGroupQName = new QName(xsdURI,"attributeGroup");
         choiceQName = new QName(xsdURI,"choice");
         complexContentQName = new QName(xsdURI,"complexContent");
         complexTypeQName = new QName(xsdURI,"complexType");
         documentationQName = new QName(xsdURI,"documentation");
         elementTypeQName = new QName(xsdURI,"element");
         enumerationTypeQName = new QName(xsdURI,"enumeration");
         extensionQName = new QName(xsdURI,"extension");
         fieldQName = new QName(xsdURI,"field");
         groupQName = new QName(xsdURI,"group");
         importQName = new QName(xsdURI,"import");
         includeQName = new QName(xsdURI,"include");
         keyQName = new QName(xsdURI,"key");
         keyrefQName = new QName(xsdURI,"keyref");
         lengthQName = new QName(xsdURI,"length");
         listQName = new QName(xsdURI,"list");
         maxInclusiveQName = new QName(xsdURI,"maxInclusive");
         maxLengthQName = new QName(xsdURI,"maxLength");
         minInclusiveQName = new QName(xsdURI,"minInclusive");
         minLengthQName = new QName(xsdURI,"minLength");
         nameQName = new QName(xsdURI,"name");
         patternQName = new QName(xsdURI,"pattern");
         redefineQName = new QName(xsdURI,"redefine");
         restrictionQName = new QName(xsdURI,"restriction");
         schemaQName = new QName(xsdURI,"schema");
         selectorQName = new QName(xsdURI,"selector");
         sequenceQName = new QName(xsdURI,"sequence");
         simpleContentQName = new QName(xsdURI,"simpleContent");
         simpleTypeQName = new QName(xsdURI,"simpleType");
         unionQName = new QName(xsdURI,"union");
         uniqueQName = new QName(xsdURI,"unique");
         var nilStr:String = "nil";
         if(xsdURI == SchemaConstants.XSD_URI_1999)
         {
            nilStr = "null";
         }
         nilQName = new QName(xsiURI,nilStr);
         typeAttrQName = new QName(xsiURI,"type");
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
      
      public function get xsdNamespace() : Namespace
      {
         return _xsdNS;
      }
      
      public function getXSDToken(type:QName) : String
      {
         return xsdNamespace.prefix + ":" + type.localName;
      }
      
      public function get xsiNamespace() : Namespace
      {
         return _xsiNS;
      }
      
      public function get xsiURI() : String
      {
         return xsiNamespace.uri;
      }
      
      public function getXSIToken(type:QName) : String
      {
         return xsiNamespace.prefix + ":" + type.localName;
      }
      
      public function get xsdURI() : String
      {
         return xsdNamespace.uri;
      }
      
      public function getQName(localName:String) : QName
      {
         if(localName == "type")
         {
            return typeAttrQName;
         }
         return new QName(xsdURI,localName);
      }
   }
}

