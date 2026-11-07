package mx.rpc.xml
{
   [ExcludeClass]
   public class SchemaDatatypes
   {
      
      private static var constantsCache:Object;
      
      public var hexBinaryQName:QName;
      
      public var unsignedIntQName:QName;
      
      public var NMTOKENSQName:QName;
      
      public var nonPositiveIntegerQName:QName;
      
      public var integerQName:QName;
      
      public var stringQName:QName;
      
      public var anyAtomicTypeQName:QName;
      
      public var unsignedLongQName:QName;
      
      public var tokenQName:QName;
      
      public var languageQName:QName;
      
      public var IDQName:QName;
      
      public var NMTOKENQName:QName;
      
      public var nonNegativeIntegerQName:QName;
      
      public var doubleQName:QName;
      
      public var base64BinaryQName:QName;
      
      public var booleanQName:QName;
      
      public var unsignedShortQName:QName;
      
      public var dayTimeDurationQName:QName;
      
      public var gYearMonthQName:QName;
      
      public var anySimpleTypeQName:QName;
      
      public var durationQName:QName;
      
      public var IDREF:QName;
      
      public var byteQName:QName;
      
      public var QNameQName:QName;
      
      public var shortQName:QName;
      
      public var dateQName:QName;
      
      public var longQName:QName;
      
      public var normalizedStringQName:QName;
      
      public var positiveIntegerQName:QName;
      
      public var anyURIQName:QName;
      
      public var floatQName:QName;
      
      public var NCNameQName:QName;
      
      public var timeInstantQName:QName;
      
      public var NameQName:QName;
      
      public var gYearQName:QName;
      
      public var NOTATIONQName:QName;
      
      public var dateTimeQName:QName;
      
      public var gMonthQName:QName;
      
      public var decimalQName:QName;
      
      public var timeQName:QName;
      
      public var negativeIntegerQName:QName;
      
      public var gMonthDayQName:QName;
      
      public var IDREFS:QName;
      
      public var ENTITY:QName;
      
      public var yearMonthDurationQName:QName;
      
      public var gDayQName:QName;
      
      public var intQName:QName;
      
      public var ENTITIES:QName;
      
      public var precisionDecimal:QName;
      
      public var anyTypeQName:QName;
      
      public var unsignedByteQName:QName;
      
      public function SchemaDatatypes(xsdURI:String = null)
      {
         super();
         if(xsdURI == null || xsdURI == "")
         {
            xsdURI = SchemaConstants.XSD_URI_2001;
         }
         anyTypeQName = new QName(xsdURI,"anyType");
         anySimpleTypeQName = new QName(xsdURI,"anySimpleType");
         anyAtomicTypeQName = new QName(xsdURI,"anyAtomicType");
         stringQName = new QName(xsdURI,"string");
         booleanQName = new QName(xsdURI,"boolean");
         decimalQName = new QName(xsdURI,"decimal");
         precisionDecimal = new QName(xsdURI,"precisionDecimal");
         floatQName = new QName(xsdURI,"float");
         doubleQName = new QName(xsdURI,"double");
         durationQName = new QName(xsdURI,"duration");
         dateTimeQName = new QName(xsdURI,"dateTime");
         timeQName = new QName(xsdURI,"time");
         dateQName = new QName(xsdURI,"date");
         gYearMonthQName = new QName(xsdURI,"gYearMonth");
         gYearQName = new QName(xsdURI,"gYear");
         gMonthDayQName = new QName(xsdURI,"gMonthDay");
         gDayQName = new QName(xsdURI,"gDay");
         gMonthQName = new QName(xsdURI,"gMonth");
         hexBinaryQName = new QName(xsdURI,"hexBinary");
         base64BinaryQName = new QName(xsdURI,"base64Binary");
         anyURIQName = new QName(xsdURI,"anyURI");
         QNameQName = new QName(xsdURI,"QName");
         NOTATIONQName = new QName(xsdURI,"NOTATION");
         normalizedStringQName = new QName(xsdURI,"normalizedString");
         tokenQName = new QName(xsdURI,"token");
         languageQName = new QName(xsdURI,"language");
         NMTOKENQName = new QName(xsdURI,"NMTOKEN");
         NMTOKENSQName = new QName(xsdURI,"NMTOKENS");
         NameQName = new QName(xsdURI,"Name");
         NCNameQName = new QName(xsdURI,"NCName");
         IDQName = new QName(xsdURI,"ID");
         IDREF = new QName(xsdURI,"IDREF");
         IDREFS = new QName(xsdURI,"IDREFS");
         ENTITY = new QName(xsdURI,"ENTITY");
         ENTITIES = new QName(xsdURI,"ENTITIES");
         integerQName = new QName(xsdURI,"integer");
         nonPositiveIntegerQName = new QName(xsdURI,"nonPositiveInteger");
         negativeIntegerQName = new QName(xsdURI,"negativeInteger");
         longQName = new QName(xsdURI,"long");
         intQName = new QName(xsdURI,"int");
         shortQName = new QName(xsdURI,"short");
         byteQName = new QName(xsdURI,"byte");
         nonNegativeIntegerQName = new QName(xsdURI,"nonNegativeInteger");
         unsignedLongQName = new QName(xsdURI,"unsignedLong");
         unsignedIntQName = new QName(xsdURI,"unsignedInt");
         unsignedShortQName = new QName(xsdURI,"unsignedShort");
         unsignedByteQName = new QName(xsdURI,"unsignedByte");
         positiveIntegerQName = new QName(xsdURI,"positiveInteger");
         yearMonthDurationQName = new QName(xsdURI,"yearMonthDuration");
         dayTimeDurationQName = new QName(xsdURI,"dayTimeDuration");
         if(xsdURI == SchemaConstants.XSD_URI_1999)
         {
            timeInstantQName = new QName(xsdURI,"timeInstant");
         }
      }
      
      public static function getConstants(xsdURI:String = null) : SchemaDatatypes
      {
         if(constantsCache == null)
         {
            constantsCache = {};
         }
         if(xsdURI == null || xsdURI == "")
         {
            xsdURI = SchemaConstants.XSD_URI_2001;
         }
         var constants:SchemaDatatypes = constantsCache[xsdURI];
         if(constants == null)
         {
            constants = new SchemaDatatypes(xsdURI);
            constantsCache[xsdURI] = constants;
         }
         return constants;
      }
   }
}

