package mx.rpc.xml
{
   [ExcludeClass]
   public class SchemaDatatypes
   {
      
      private static var constantsCache:Object;
      
      public var anyTypeQName:QName;
      
      public var anySimpleTypeQName:QName;
      
      public var anyAtomicTypeQName:QName;
      
      public var stringQName:QName;
      
      public var booleanQName:QName;
      
      public var decimalQName:QName;
      
      public var precisionDecimal:QName;
      
      public var floatQName:QName;
      
      public var doubleQName:QName;
      
      public var durationQName:QName;
      
      public var dateTimeQName:QName;
      
      public var timeQName:QName;
      
      public var dateQName:QName;
      
      public var gYearMonthQName:QName;
      
      public var gYearQName:QName;
      
      public var gMonthDayQName:QName;
      
      public var gDayQName:QName;
      
      public var gMonthQName:QName;
      
      public var hexBinaryQName:QName;
      
      public var base64BinaryQName:QName;
      
      public var anyURIQName:QName;
      
      public var QNameQName:QName;
      
      public var NOTATIONQName:QName;
      
      public var normalizedStringQName:QName;
      
      public var tokenQName:QName;
      
      public var languageQName:QName;
      
      public var NMTOKENQName:QName;
      
      public var NMTOKENSQName:QName;
      
      public var NameQName:QName;
      
      public var NCNameQName:QName;
      
      public var IDQName:QName;
      
      public var IDREF:QName;
      
      public var IDREFS:QName;
      
      public var ENTITY:QName;
      
      public var ENTITIES:QName;
      
      public var integerQName:QName;
      
      public var nonPositiveIntegerQName:QName;
      
      public var negativeIntegerQName:QName;
      
      public var longQName:QName;
      
      public var intQName:QName;
      
      public var shortQName:QName;
      
      public var byteQName:QName;
      
      public var nonNegativeIntegerQName:QName;
      
      public var unsignedLongQName:QName;
      
      public var unsignedIntQName:QName;
      
      public var unsignedShortQName:QName;
      
      public var unsignedByteQName:QName;
      
      public var positiveIntegerQName:QName;
      
      public var yearMonthDurationQName:QName;
      
      public var dayTimeDurationQName:QName;
      
      public var timeInstantQName:QName;
      
      public function SchemaDatatypes(xsdURI:String = null)
      {
         super();
         if(xsdURI == null || xsdURI == "")
         {
            xsdURI = SchemaConstants.XSD_URI_2001;
         }
         this.anyTypeQName = new QName(xsdURI,"anyType");
         this.anySimpleTypeQName = new QName(xsdURI,"anySimpleType");
         this.anyAtomicTypeQName = new QName(xsdURI,"anyAtomicType");
         this.stringQName = new QName(xsdURI,"string");
         this.booleanQName = new QName(xsdURI,"boolean");
         this.decimalQName = new QName(xsdURI,"decimal");
         this.precisionDecimal = new QName(xsdURI,"precisionDecimal");
         this.floatQName = new QName(xsdURI,"float");
         this.doubleQName = new QName(xsdURI,"double");
         this.durationQName = new QName(xsdURI,"duration");
         this.dateTimeQName = new QName(xsdURI,"dateTime");
         this.timeQName = new QName(xsdURI,"time");
         this.dateQName = new QName(xsdURI,"date");
         this.gYearMonthQName = new QName(xsdURI,"gYearMonth");
         this.gYearQName = new QName(xsdURI,"gYear");
         this.gMonthDayQName = new QName(xsdURI,"gMonthDay");
         this.gDayQName = new QName(xsdURI,"gDay");
         this.gMonthQName = new QName(xsdURI,"gMonth");
         this.hexBinaryQName = new QName(xsdURI,"hexBinary");
         this.base64BinaryQName = new QName(xsdURI,"base64Binary");
         this.anyURIQName = new QName(xsdURI,"anyURI");
         this.QNameQName = new QName(xsdURI,"QName");
         this.NOTATIONQName = new QName(xsdURI,"NOTATION");
         this.normalizedStringQName = new QName(xsdURI,"normalizedString");
         this.tokenQName = new QName(xsdURI,"token");
         this.languageQName = new QName(xsdURI,"language");
         this.NMTOKENQName = new QName(xsdURI,"NMTOKEN");
         this.NMTOKENSQName = new QName(xsdURI,"NMTOKENS");
         this.NameQName = new QName(xsdURI,"Name");
         this.NCNameQName = new QName(xsdURI,"NCName");
         this.IDQName = new QName(xsdURI,"ID");
         this.IDREF = new QName(xsdURI,"IDREF");
         this.IDREFS = new QName(xsdURI,"IDREFS");
         this.ENTITY = new QName(xsdURI,"ENTITY");
         this.ENTITIES = new QName(xsdURI,"ENTITIES");
         this.integerQName = new QName(xsdURI,"integer");
         this.nonPositiveIntegerQName = new QName(xsdURI,"nonPositiveInteger");
         this.negativeIntegerQName = new QName(xsdURI,"negativeInteger");
         this.longQName = new QName(xsdURI,"long");
         this.intQName = new QName(xsdURI,"int");
         this.shortQName = new QName(xsdURI,"short");
         this.byteQName = new QName(xsdURI,"byte");
         this.nonNegativeIntegerQName = new QName(xsdURI,"nonNegativeInteger");
         this.unsignedLongQName = new QName(xsdURI,"unsignedLong");
         this.unsignedIntQName = new QName(xsdURI,"unsignedInt");
         this.unsignedShortQName = new QName(xsdURI,"unsignedShort");
         this.unsignedByteQName = new QName(xsdURI,"unsignedByte");
         this.positiveIntegerQName = new QName(xsdURI,"positiveInteger");
         this.yearMonthDurationQName = new QName(xsdURI,"yearMonthDuration");
         this.dayTimeDurationQName = new QName(xsdURI,"dayTimeDuration");
         if(xsdURI == SchemaConstants.XSD_URI_1999)
         {
            this.timeInstantQName = new QName(xsdURI,"timeInstant");
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

