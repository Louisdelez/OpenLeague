package mx.rpc.xml
{
   import flash.utils.ByteArray;
   import mx.utils.Base64Decoder;
   import mx.utils.Base64Encoder;
   import mx.utils.HexDecoder;
   import mx.utils.HexEncoder;
   
   [ExcludeClass]
   public class SchemaMarshaller
   {
      
      public static var byteArrayAsBase64Binary:Boolean = true;
      
      public static var whitespaceReplacePattern:RegExp = /[\t\r\n]/g;
      
      public static var whitespaceCollapsePattern:RegExp = /[ \t\r\n]+/g;
      
      public static var whitespaceTrimPattern:RegExp = /^[ ]+|[ ]+$/g;
      
      public static const FLOAT_MAX_VALUE:Number = (Math.pow(2,24) - 1) * Math.pow(2,104);
      
      public static const FLOAT_MIN_VALUE:Number = Math.pow(2,-149);
      
      public static const LONG_MAX_VALUE:Number = 9223372036854776000;
      
      public static const LONG_MIN_VALUE:Number = -9223372036854776000;
      
      public static const SHORT_MAX_VALUE:Number = 32767;
      
      public static const SHORT_MIN_VALUE:Number = -32768;
      
      public static const BYTE_MAX_VALUE:Number = 127;
      
      public static const BYTE_MIN_VALUE:Number = -128;
      
      public static const ULONG_MAX_VALUE:Number = 18446744073709552000;
      
      public static const USHORT_MAX_VALUE:Number = 65535;
      
      public static const UBYTE_MAX_VALUE:Number = 255;
      
      private var unmarshallers:Object;
      
      private var constants:SchemaConstants;
      
      private var datatypes:SchemaDatatypes;
      
      private var marshallers:Object;
      
      private var _validating:Boolean;
      
      public function SchemaMarshaller(constants:SchemaConstants, datatypes:SchemaDatatypes)
      {
         super();
         this.constants = constants;
         this.datatypes = datatypes;
         registerMarshallers();
      }
      
      public static function guessSimpleType(value:*) : *
      {
         var localName:String = "string";
         if(value is uint)
         {
            localName = "unsignedInt";
         }
         else if(value is int)
         {
            localName = "int";
         }
         else if(value is Number)
         {
            localName = "double";
         }
         else if(value is Boolean)
         {
            localName = "boolean";
         }
         else if(value is String)
         {
            localName = "string";
         }
         else if(value is ByteArray)
         {
            if(byteArrayAsBase64Binary)
            {
               localName = "base64Binary";
            }
            else
            {
               localName = "hexBinary";
            }
         }
         else if(value is Date)
         {
            localName = "dateTime";
         }
         return localName;
      }
      
      private static function whitespaceCollapse(value:*) : String
      {
         if(value == null)
         {
            return null;
         }
         var s:String = value.toString();
         s = s.replace(whitespaceCollapsePattern," ");
         return s.replace(whitespaceTrimPattern,"");
      }
      
      private static function specialNumber(value:Number) : String
      {
         if(value == Number.NEGATIVE_INFINITY)
         {
            return "-INF";
         }
         if(value == Number.POSITIVE_INFINITY)
         {
            return "INF";
         }
         if(isNaN(value))
         {
            return "NaN";
         }
         return null;
      }
      
      private static function whitespaceReplace(value:*) : String
      {
         if(value == null)
         {
            return null;
         }
         var s:String = value.toString();
         return s.replace(whitespaceReplacePattern," ");
      }
      
      public function unmarshallBoolean(value:*, type:QName = null, restriction:XML = null) : Boolean
      {
         if(value == null)
         {
            return false;
         }
         var bool:String = whitespaceCollapse(value).toLowerCase();
         if(bool == "true" || bool == "1")
         {
            return true;
         }
         return false;
      }
      
      public function marshallDuration(value:*, type:QName = null, restriction:XML = null) : String
      {
         return whitespaceCollapse(value);
      }
      
      private function registerMarshallers() : void
      {
         marshallers = {};
         marshallers[datatypes.booleanQName.localName] = marshallBoolean;
         marshallers[datatypes.anyTypeQName.localName] = marshallAny;
         marshallers[datatypes.anySimpleTypeQName.localName] = marshallAny;
         marshallers[datatypes.anyAtomicTypeQName.localName] = marshallAny;
         marshallers[datatypes.stringQName.localName] = marshallString;
         marshallers[datatypes.booleanQName.localName] = marshallBoolean;
         marshallers[datatypes.decimalQName.localName] = marshallDecimal;
         marshallers[datatypes.precisionDecimal.localName] = marshallDecimal;
         marshallers[datatypes.floatQName.localName] = marshallFloat;
         marshallers[datatypes.doubleQName.localName] = marshallDouble;
         marshallers[datatypes.durationQName.localName] = marshallDuration;
         marshallers[datatypes.dateTimeQName.localName] = marshallDatetime;
         marshallers[datatypes.timeQName.localName] = marshallDatetime;
         marshallers[datatypes.dateQName.localName] = marshallDatetime;
         marshallers[datatypes.gYearMonthQName.localName] = marshallGregorian;
         marshallers[datatypes.gYearQName.localName] = marshallGregorian;
         marshallers[datatypes.gMonthDayQName.localName] = marshallGregorian;
         marshallers[datatypes.gDayQName.localName] = marshallGregorian;
         marshallers[datatypes.gMonthQName.localName] = marshallGregorian;
         marshallers[datatypes.hexBinaryQName.localName] = marshallHexBinary;
         marshallers[datatypes.base64BinaryQName.localName] = marshallBase64Binary;
         marshallers[datatypes.anyURIQName.localName] = marshallString;
         marshallers[datatypes.QNameQName.localName] = marshallString;
         marshallers[datatypes.NOTATIONQName.localName] = marshallString;
         marshallers[datatypes.normalizedStringQName.localName] = marshallString;
         marshallers[datatypes.tokenQName.localName] = marshallString;
         marshallers[datatypes.languageQName.localName] = marshallString;
         marshallers[datatypes.NMTOKENQName.localName] = marshallString;
         marshallers[datatypes.NMTOKENSQName.localName] = marshallString;
         marshallers[datatypes.NameQName.localName] = marshallString;
         marshallers[datatypes.NCNameQName.localName] = marshallString;
         marshallers[datatypes.IDQName.localName] = marshallString;
         marshallers[datatypes.IDREF.localName] = marshallString;
         marshallers[datatypes.IDREFS.localName] = marshallString;
         marshallers[datatypes.ENTITY.localName] = marshallString;
         marshallers[datatypes.ENTITIES.localName] = marshallString;
         marshallers[datatypes.integerQName.localName] = marshallInteger;
         marshallers[datatypes.nonPositiveIntegerQName.localName] = marshallInteger;
         marshallers[datatypes.negativeIntegerQName.localName] = marshallInteger;
         marshallers[datatypes.longQName.localName] = marshallInteger;
         marshallers[datatypes.intQName.localName] = marshallInteger;
         marshallers[datatypes.shortQName.localName] = marshallInteger;
         marshallers[datatypes.byteQName.localName] = marshallInteger;
         marshallers[datatypes.nonNegativeIntegerQName.localName] = marshallInteger;
         marshallers[datatypes.unsignedLongQName.localName] = marshallInteger;
         marshallers[datatypes.unsignedIntQName.localName] = marshallInteger;
         marshallers[datatypes.unsignedShortQName.localName] = marshallInteger;
         marshallers[datatypes.unsignedByteQName.localName] = marshallInteger;
         marshallers[datatypes.positiveIntegerQName.localName] = marshallInteger;
         marshallers[datatypes.yearMonthDurationQName.localName] = marshallDatetime;
         marshallers[datatypes.dayTimeDurationQName.localName] = marshallDatetime;
         if(datatypes.timeInstantQName != null)
         {
            marshallers[datatypes.timeInstantQName.localName] = marshallDatetime;
         }
         unmarshallers = {};
         unmarshallers[datatypes.booleanQName.localName] = unmarshallBoolean;
         unmarshallers[datatypes.anyTypeQName.localName] = unmarshallAny;
         unmarshallers[datatypes.anySimpleTypeQName.localName] = unmarshallAny;
         unmarshallers[datatypes.anyAtomicTypeQName.localName] = unmarshallAny;
         unmarshallers[datatypes.stringQName.localName] = unmarshallString;
         unmarshallers[datatypes.booleanQName.localName] = unmarshallBoolean;
         unmarshallers[datatypes.decimalQName.localName] = unmarshallDecimal;
         unmarshallers[datatypes.precisionDecimal.localName] = unmarshallDecimal;
         unmarshallers[datatypes.floatQName.localName] = unmarshallFloat;
         unmarshallers[datatypes.doubleQName.localName] = unmarshallDouble;
         unmarshallers[datatypes.durationQName.localName] = unmarshallDuration;
         unmarshallers[datatypes.dateTimeQName.localName] = unmarshallDatetime;
         unmarshallers[datatypes.timeQName.localName] = unmarshallDatetime;
         unmarshallers[datatypes.dateQName.localName] = unmarshallDate;
         unmarshallers[datatypes.gYearMonthQName.localName] = unmarshallGregorian;
         unmarshallers[datatypes.gYearQName.localName] = unmarshallGregorian;
         unmarshallers[datatypes.gMonthDayQName.localName] = unmarshallGregorian;
         unmarshallers[datatypes.gDayQName.localName] = unmarshallGregorian;
         unmarshallers[datatypes.gMonthQName.localName] = unmarshallGregorian;
         unmarshallers[datatypes.hexBinaryQName.localName] = unmarshallHexBinary;
         unmarshallers[datatypes.base64BinaryQName.localName] = unmarshallBase64Binary;
         unmarshallers[datatypes.anyURIQName.localName] = unmarshallString;
         unmarshallers[datatypes.QNameQName.localName] = unmarshallString;
         unmarshallers[datatypes.NOTATIONQName.localName] = unmarshallString;
         unmarshallers[datatypes.normalizedStringQName.localName] = unmarshallString;
         unmarshallers[datatypes.tokenQName.localName] = unmarshallString;
         unmarshallers[datatypes.languageQName.localName] = unmarshallString;
         unmarshallers[datatypes.NMTOKENQName.localName] = unmarshallString;
         unmarshallers[datatypes.NMTOKENSQName.localName] = unmarshallString;
         unmarshallers[datatypes.NameQName.localName] = unmarshallString;
         unmarshallers[datatypes.NCNameQName.localName] = unmarshallString;
         unmarshallers[datatypes.IDQName.localName] = unmarshallString;
         unmarshallers[datatypes.IDREF.localName] = unmarshallString;
         unmarshallers[datatypes.IDREFS.localName] = unmarshallString;
         unmarshallers[datatypes.ENTITY.localName] = unmarshallString;
         unmarshallers[datatypes.ENTITIES.localName] = unmarshallString;
         unmarshallers[datatypes.integerQName.localName] = unmarshallInteger;
         unmarshallers[datatypes.nonPositiveIntegerQName.localName] = unmarshallInteger;
         unmarshallers[datatypes.negativeIntegerQName.localName] = unmarshallInteger;
         unmarshallers[datatypes.longQName.localName] = unmarshallInteger;
         unmarshallers[datatypes.intQName.localName] = unmarshallInteger;
         unmarshallers[datatypes.shortQName.localName] = unmarshallInteger;
         unmarshallers[datatypes.byteQName.localName] = unmarshallInteger;
         unmarshallers[datatypes.nonNegativeIntegerQName.localName] = unmarshallInteger;
         unmarshallers[datatypes.unsignedLongQName.localName] = unmarshallInteger;
         unmarshallers[datatypes.unsignedIntQName.localName] = unmarshallInteger;
         unmarshallers[datatypes.unsignedShortQName.localName] = unmarshallInteger;
         unmarshallers[datatypes.unsignedByteQName.localName] = unmarshallInteger;
         unmarshallers[datatypes.positiveIntegerQName.localName] = unmarshallInteger;
         unmarshallers[datatypes.yearMonthDurationQName.localName] = unmarshallDatetime;
         unmarshallers[datatypes.dayTimeDurationQName.localName] = unmarshallDatetime;
         if(datatypes.timeInstantQName != null)
         {
            unmarshallers[datatypes.timeInstantQName.localName] = unmarshallDatetime;
         }
      }
      
      public function unmarshallAny(value:*, type:QName = null, restriction:XML = null) : *
      {
         var result:* = undefined;
         var unmarshaller:Function = null;
         var lowerS:String = null;
         if(value === undefined)
         {
            return undefined;
         }
         if(value == null)
         {
            return null;
         }
         var s:String = whitespaceCollapse(value);
         if(s == "")
         {
            unmarshaller = unmarshallers[datatypes.stringQName.localName];
         }
         else if(isNaN(Number(s)) || s.charAt(0) == "0" || s.charAt(0) == "-" && s.charAt(1) == "0" || s.charAt(s.length - 1) == "E")
         {
            lowerS = s.toLowerCase();
            if(lowerS == "true" || lowerS == "false")
            {
               unmarshaller = unmarshallers[datatypes.booleanQName.localName];
            }
            else
            {
               unmarshaller = unmarshallers[datatypes.stringQName.localName];
            }
         }
         else
         {
            unmarshaller = unmarshallers[datatypes.doubleQName.localName];
         }
         return unmarshaller(value,type,restriction);
      }
      
      public function marshallDouble(value:*, type:QName = null, restriction:XML = null) : String
      {
         var result:String = null;
         var number:Number = Number(value);
         result = specialNumber(number);
         if(result == null)
         {
            result = number.toString();
         }
         return result;
      }
      
      public function unmarshallDatetime(value:*, type:QName = null, restriction:XML = null) : Object
      {
         var date:Date = null;
         var datePart:String = null;
         var timePart:String = null;
         var utc:Boolean = false;
         var offset:Boolean = false;
         var index:int = 0;
         var offsetDirection:int = 0;
         var offsetMillis:Number = NaN;
         var offsetHours:int = 0;
         var offsetMinutes:int = 0;
         var fractionalSecond:Number = NaN;
         var year:uint = 0;
         var month:uint = 0;
         var day:uint = 0;
         var now:Date = null;
         if(value == null)
         {
            return null;
         }
         var rawValue:String = whitespaceCollapse(value);
         var sep:int = rawValue.indexOf("T");
         if(sep != -1)
         {
            datePart = rawValue.substring(0,sep);
            timePart = rawValue.substring(sep + 1);
         }
         else
         {
            timePart = rawValue;
         }
         var hours:int = int(timePart.substring(0,2));
         var minutes:int = int(timePart.substring(3,5));
         var millisStart:int = timePart.indexOf(".",6);
         var seconds:int = int(timePart.substring(6,8));
         var tzIndex:int = timePart.indexOf("Z",8);
         if(tzIndex == -1)
         {
            tzIndex = timePart.indexOf("+",8);
            if(tzIndex != -1)
            {
               offsetDirection = 1;
            }
            else
            {
               tzIndex = timePart.indexOf("-",8);
               if(tzIndex != -1)
               {
                  offsetDirection = -1;
               }
            }
            if(tzIndex != -1)
            {
               index = tzIndex + 1;
               offsetHours = int(timePart.substring(index,index + 2));
               index += 3;
               offsetMinutes = int(timePart.substring(index,index + 2));
               offsetMillis = offsetHours * 3600000 + offsetMinutes * 60000;
               utc = true;
               offset = true;
            }
         }
         else
         {
            utc = true;
         }
         var millis:int = 0;
         if(millisStart != -1)
         {
            if(tzIndex != -1)
            {
               fractionalSecond = Number(timePart.substring(millisStart,tzIndex));
            }
            else
            {
               fractionalSecond = Number(timePart.substring(millisStart));
            }
            millis = int(Math.floor(fractionalSecond * 1000));
         }
         if(datePart != null)
         {
            index = datePart.indexOf("-",1);
            year = uint(datePart.substring(0,index++));
            month = uint(datePart.substring(index,index + 2));
            index += 3;
            day = uint(datePart.substring(index,index + 2));
            if(utc)
            {
               date = new Date(Date.UTC(year,month - 1,day));
            }
            else
            {
               date = new Date(year,month - 1,day);
            }
         }
         else if(utc)
         {
            now = new Date();
            date = new Date(Date.UTC(now.fullYearUTC,now.monthUTC,now.dateUTC));
         }
         else
         {
            date = new Date();
         }
         if(utc)
         {
            date.setUTCHours(hours,minutes,seconds,millis);
            if(offset)
            {
               if(offsetDirection > 0)
               {
                  date.time -= offsetMillis;
               }
               else
               {
                  date.time += offsetMillis;
               }
            }
         }
         else
         {
            date.setHours(hours,minutes,seconds,millis);
         }
         return date;
      }
      
      public function marshall(value:*, type:QName = null, restriction:XML = null) : *
      {
         var result:* = undefined;
         if(type == null)
         {
            type = datatypes.anyTypeQName;
         }
         var marshaller:Function = marshallers[type.localName];
         if(marshaller != null)
         {
            return marshaller(value,type,restriction);
         }
         throw new TypeError("Cannot marshall type \'" + type + "\' to simple content.");
      }
      
      public function marshallInteger(value:*, type:QName = null, restriction:XML = null) : String
      {
         var result:String = null;
         var number:Number = NaN;
         if(value is Number)
         {
            number = value as Number;
         }
         else
         {
            number = Number(whitespaceCollapse(value));
         }
         var min:Number = -Number.MAX_VALUE;
         var max:Number = Number.MAX_VALUE;
         if(type == datatypes.longQName)
         {
            min = LONG_MIN_VALUE;
            max = LONG_MAX_VALUE;
         }
         else if(type == datatypes.intQName)
         {
            min = int.MIN_VALUE;
            max = int.MAX_VALUE;
         }
         else if(type == datatypes.shortQName)
         {
            min = SHORT_MIN_VALUE;
            max = SHORT_MAX_VALUE;
         }
         else if(type == datatypes.byteQName)
         {
            min = BYTE_MIN_VALUE;
            max = BYTE_MAX_VALUE;
         }
         else if(type == datatypes.unsignedLongQName)
         {
            min = 0;
            max = ULONG_MAX_VALUE;
         }
         else if(type == datatypes.unsignedIntQName)
         {
            min = 0;
            max = uint.MAX_VALUE;
         }
         else if(type == datatypes.unsignedShortQName)
         {
            min = 0;
            max = USHORT_MAX_VALUE;
         }
         else if(type == datatypes.unsignedByteQName)
         {
            min = 0;
            max = UBYTE_MAX_VALUE;
         }
         else if(type == datatypes.positiveIntegerQName)
         {
            min = 1;
            max = Number.MAX_VALUE;
         }
         else if(type == datatypes.nonNegativeIntegerQName)
         {
            min = 0;
            max = Number.MAX_VALUE;
         }
         else if(type == datatypes.negativeIntegerQName)
         {
            min = -Number.MAX_VALUE;
            max = -1;
         }
         else if(type == datatypes.nonPositiveIntegerQName)
         {
            min = -Number.MAX_VALUE;
            max = 0;
         }
         else if(type == datatypes.integerQName)
         {
            min = -Number.MAX_VALUE;
            max = Number.MAX_VALUE;
         }
         var integer:Number = Math.floor(number);
         if(integer >= min)
         {
            if(integer > max)
            {
               if(validating)
               {
                  throw new RangeError("The value \'" + value + "\' is too large for " + type.localName);
               }
               return whitespaceCollapse(value);
            }
            return integer.toString();
         }
         if(validating)
         {
            throw new RangeError("The value \'" + value + "\' is too small for " + type.localName);
         }
         return whitespaceCollapse(value);
      }
      
      public function get validating() : Boolean
      {
         return _validating;
      }
      
      public function marshallHexBinary(value:*, type:QName = null, restriction:XML = null) : String
      {
         var valueString:String = null;
         var encoder:HexEncoder = null;
         var ba:ByteArray = value as ByteArray;
         if(ba != null)
         {
            encoder = new HexEncoder();
            encoder.encode(ba);
            return encoder.drain();
         }
         throw new Error("Cannot marshall value as hex binary.");
      }
      
      public function unmarshallGregorian(value:*, type:QName = null, restriction:XML = null) : *
      {
         var rawValue:String = whitespaceCollapse(value);
         var result:* = rawValue;
         if(type == datatypes.gYearQName)
         {
            result = uint(rawValue.substring(0,4));
         }
         else if(type == datatypes.gMonthQName)
         {
            result = uint(rawValue.substring(2,4));
         }
         else if(type == datatypes.gDayQName)
         {
            result = uint(rawValue.substring(3,5));
         }
         return result;
      }
      
      public function unmarshallDouble(value:*, type:QName = null, restriction:XML = null) : Number
      {
         var result:Number = NaN;
         var s:String = null;
         if(value != null)
         {
            s = whitespaceCollapse(value);
            if(s == "INF")
            {
               result = Number.POSITIVE_INFINITY;
            }
            else if(s == "-INF")
            {
               result = Number.NEGATIVE_INFINITY;
            }
            else
            {
               result = Number(s);
            }
         }
         return result;
      }
      
      public function unmarshallDuration(value:*, type:QName = null, restriction:XML = null) : *
      {
         return whitespaceCollapse(value);
      }
      
      public function unmarshallHexBinary(value:*, type:QName = null, restriction:XML = null) : ByteArray
      {
         var data:String = null;
         var decoder:HexDecoder = null;
         if(value != null)
         {
            data = whitespaceCollapse(value);
            decoder = new HexDecoder();
            decoder.decode(data);
            return decoder.drain();
         }
         return null;
      }
      
      public function marshallBase64Binary(value:*, type:QName = null, restriction:XML = null) : String
      {
         var result:String = null;
         var encoder:Base64Encoder = null;
         var ba:ByteArray = value as ByteArray;
         if(ba != null)
         {
            encoder = new Base64Encoder();
            encoder.insertNewLines = false;
            encoder.encodeBytes(ba);
            return encoder.drain();
         }
         return null;
      }
      
      public function unmarshallString(value:*, type:QName = null, restriction:XML = null) : String
      {
         var result:String = null;
         if(value != null)
         {
            result = value.toString();
         }
         return result;
      }
      
      public function marshallDecimal(value:*, type:QName = null, restriction:XML = null) : String
      {
         var result:String = null;
         var number:Number = NaN;
         var str:String = null;
         if(value is Number)
         {
            number = value as Number;
         }
         else
         {
            str = whitespaceCollapse(value);
            number = Number(str);
         }
         result = specialNumber(number);
         if(result != null)
         {
            if(validating)
            {
               throw new Error("Invalid decimal value \'" + value + "\'.");
            }
            result = whitespaceCollapse(value);
         }
         else
         {
            result = number.toString();
         }
         return result;
      }
      
      public function set validating(value:Boolean) : void
      {
         _validating = value;
      }
      
      public function unmarshall(value:*, type:QName = null, restriction:XML = null) : *
      {
         var rawValue:String = null;
         var xml:XML = null;
         var nilAttribute:String = null;
         var list:XMLList = null;
         if(value is XML)
         {
            xml = value as XML;
            if(xml.nodeKind() == "element")
            {
               nilAttribute = xml.attribute(constants.nilQName).toString();
               if(nilAttribute == "true")
               {
                  rawValue = null;
               }
               else
               {
                  rawValue = xml.text().toString();
               }
            }
            else
            {
               rawValue = xml.toString();
            }
         }
         else if(value is XMLList)
         {
            list = value as XMLList;
            rawValue = list.text().toString();
         }
         else if(value != null)
         {
            rawValue = value.toString();
         }
         if(type == null)
         {
            type = datatypes.anyTypeQName;
         }
         var unmarshaller:Function = unmarshallers[type.localName];
         if(unmarshaller != null)
         {
            return unmarshaller(rawValue,type,restriction);
         }
         throw new TypeError("Cannot unmarshall type \'" + type + "\' from XML.");
      }
      
      public function marshallDatetime(value:*, type:QName = null, restriction:XML = null) : String
      {
         var result:String = null;
         var date:Date = null;
         var n:Number = NaN;
         if(value is Number)
         {
            date = new Date();
            date.time = value as Number;
            value = date;
         }
         if(value is Date)
         {
            date = value as Date;
            result = "";
            if(type == datatypes.dateTimeQName || type == datatypes.dateQName)
            {
               result = result.concat(date.getUTCFullYear(),"-");
               n = date.getUTCMonth() + 1;
               if(n < 10)
               {
                  result = result.concat("0");
               }
               result = result.concat(n,"-");
               n = date.getUTCDate();
               if(n < 10)
               {
                  result = result.concat("0");
               }
               result = result.concat(n);
            }
            if(type == datatypes.dateTimeQName)
            {
               result = result.concat("T");
            }
            if(type == datatypes.dateTimeQName || type == datatypes.timeQName)
            {
               n = date.getUTCHours();
               if(n < 10)
               {
                  result = result.concat("0");
               }
               result = result.concat(n,":");
               n = date.getUTCMinutes();
               if(n < 10)
               {
                  result = result.concat("0");
               }
               result = result.concat(n,":");
               n = date.getUTCSeconds();
               if(n < 10)
               {
                  result = result.concat("0");
               }
               result = result.concat(n);
               n = date.getUTCMilliseconds();
               if(n > 0)
               {
                  result = result.concat(".");
                  if(n < 10)
                  {
                     result = result.concat("00");
                  }
                  else if(n < 100)
                  {
                     result = result.concat("0");
                  }
                  result = result.concat(n);
               }
            }
            result = result.concat("Z");
         }
         else if(value is String)
         {
            result = value as String;
         }
         return result;
      }
      
      public function unmarshallDecimal(value:*, type:QName = null, restriction:XML = null) : Number
      {
         return unmarshallDouble(value,type);
      }
      
      public function marshallFloat(value:*, type:QName = null, restriction:XML = null) : String
      {
         var result:String = null;
         var number:Number = NaN;
         var str:String = null;
         if(value is Number)
         {
            number = value as Number;
         }
         else
         {
            str = whitespaceCollapse(value);
            number = Number(str);
         }
         result = specialNumber(number);
         if(result == null)
         {
            if(validating)
            {
               if(number > 0)
               {
                  if(number > FLOAT_MAX_VALUE)
                  {
                     throw new RangeError("The value \'" + value + "\' is too large for a single-precision floating point value.");
                  }
                  if(number < FLOAT_MIN_VALUE)
                  {
                     throw new RangeError("The value \'" + value + "\' is too small for a single-precision floating point value.");
                  }
               }
               else
               {
                  if(-number > FLOAT_MAX_VALUE)
                  {
                     throw new RangeError("The absolute value of \'" + value + "\' is too large for a single-precision floating point value.");
                  }
                  if(-number < FLOAT_MIN_VALUE)
                  {
                     throw new RangeError("The absolute value of \'" + value + "\' is too small for a single-precision floating point value.");
                  }
               }
            }
            result = number.toString();
         }
         return result;
      }
      
      public function unmarshallInteger(value:*, type:QName = null, restriction:XML = null) : Number
      {
         return parseInt(value);
      }
      
      public function unmarshallDate(value:*, type:QName = null, restriction:XML = null) : Object
      {
         var date:Date = null;
         var index:int = 0;
         var year:uint = 0;
         var month:uint = 0;
         var day:uint = 0;
         var offsetDirection:String = null;
         var hours:int = 0;
         var minutes:int = 0;
         var millis:Number = NaN;
         if(value == null)
         {
            return null;
         }
         var datePart:String = whitespaceCollapse(value);
         if(datePart != null)
         {
            index = datePart.indexOf("-",1);
            year = uint(datePart.substring(0,index++));
            month = uint(datePart.substring(index,index + 2));
            index += 3;
            day = uint(datePart.substring(index,index + 2));
            index += 2;
            if(datePart.charAt(index) == "Z")
            {
               date = new Date(Date.UTC(year,month - 1,day));
            }
            else if(datePart.length > 10)
            {
               date = new Date(Date.UTC(year,month - 1,day));
               offsetDirection = datePart.charAt(index++);
               hours = int(datePart.substring(index,index + 2));
               index += 3;
               minutes = int(datePart.substring(index,index + 2));
               millis = hours * 3600000 + minutes * 60000;
               if(offsetDirection == "+")
               {
                  date.time -= millis;
               }
               else
               {
                  date.time += millis;
               }
            }
            else
            {
               date = new Date(year,month - 1,day);
            }
         }
         return date;
      }
      
      public function unmarshallBase64Binary(value:*, type:QName = null, restriction:XML = null) : ByteArray
      {
         if(value == null)
         {
            return null;
         }
         var data:String = whitespaceCollapse(value);
         var decoder:Base64Decoder = new Base64Decoder();
         decoder.decode(data);
         return decoder.drain();
      }
      
      public function marshallGregorian(value:*, type:QName = null, restriction:XML = null) : String
      {
         var date:Date = null;
         var n:Number = NaN;
         var hyphen:int = 0;
         var year:String = null;
         var month:String = null;
         var day:String = null;
         if(value is Date)
         {
            date = value as Date;
         }
         else if(value is Number)
         {
            n = value as Number;
         }
         else
         {
            value = whitespaceCollapse(value);
         }
         var result:String = "";
         if(type == datatypes.gYearMonthQName || type == datatypes.gYearQName)
         {
            if(value is Date)
            {
               n = date.getUTCFullYear();
            }
            else if(value is String)
            {
               year = value as String;
               hyphen = year.indexOf("-",1);
               if(hyphen > 0)
               {
                  year = year.substring(0,hyphen);
               }
               n = parseInt(year);
            }
            if(isNaN(n) || n == 0)
            {
               if(validating)
               {
                  throw new Error("Invalid year supplied for type " + type.localName + " in value " + value);
               }
               return whitespaceCollapse(value);
            }
            year = n.toFixed(0);
            if(year.indexOf("-") == 0)
            {
               while(year.length < 5)
               {
                  year = year.substring(0,1) + "0" + year.substring(1);
               }
            }
            else
            {
               while(year.length < 4)
               {
                  year = "0" + year;
               }
            }
            result = result.concat(year);
            if(type != datatypes.gYearQName)
            {
               result = result.concat("-");
            }
         }
         if(type == datatypes.gYearMonthQName || type == datatypes.gMonthDayQName || type == datatypes.gMonthQName)
         {
            if(type != datatypes.gYearMonthQName)
            {
               result = result.concat("--");
            }
            if(value is Date)
            {
               n = date.getUTCMonth() + 1;
            }
            else
            {
               month = value.toString();
               if(type == datatypes.gMonthDayQName)
               {
                  hyphen = month.indexOf("--",0);
                  if(hyphen != 0)
                  {
                     if(validating)
                     {
                        throw new Error("Invalid month supplied for " + type.localName + " in value " + value + ". The format must be \'--MM-DD\'.");
                     }
                     return whitespaceCollapse(value);
                  }
                  month = month.substring(2,4);
               }
               else if(type == datatypes.gYearMonthQName)
               {
                  hyphen = month.indexOf("-",1);
                  if(hyphen <= 0)
                  {
                     if(validating)
                     {
                        throw new Error("Invalid month supplied for " + type.localName + " in value " + value + ". The format must be \'--CCYY-MM\'.");
                     }
                     return whitespaceCollapse(value);
                  }
                  month = month.substring(hyphen + 1,hyphen + 3);
               }
               else
               {
                  hyphen = month.indexOf("--",0);
                  if(hyphen > 0)
                  {
                     month = month.substring(2,4);
                  }
               }
               n = parseInt(month);
            }
            if(isNaN(n) || n <= 0 || n > 12)
            {
               if(validating)
               {
                  throw new Error("Invalid month supplied for type " + type.localName + " in value " + value);
               }
               return whitespaceCollapse(value);
            }
            n = int(n);
            if(n < 10)
            {
               result = result.concat("0");
            }
            result = result.concat(n);
            if(type == datatypes.gMonthDayQName)
            {
               result = result.concat("-");
            }
         }
         if(type == datatypes.gMonthDayQName || type == datatypes.gDayQName)
         {
            if(type == datatypes.gDayQName)
            {
               result = result.concat("---");
            }
            if(value is Date)
            {
               n = date.getUTCDate();
            }
            else if(value is String)
            {
               day = value as String;
               if(type == datatypes.gMonthDayQName)
               {
                  hyphen = day.indexOf("--",0);
                  if(hyphen != 0)
                  {
                     if(validating)
                     {
                        throw new Error("Invalid day supplied for gMonthDay in value " + value + ". The format must be \'--MM-DD\'.");
                     }
                     return whitespaceCollapse(value);
                  }
                  day = day.substring(5,7);
               }
               else
               {
                  hyphen = day.indexOf("---",0);
                  if(hyphen == 0)
                  {
                     day = day.substring(3,5);
                  }
               }
               n = parseInt(day);
            }
            if(isNaN(n) || n <= 0 || n > 31)
            {
               if(validating)
               {
                  throw new Error("Invalid day supplied for type " + type.localName + " in value " + value);
               }
               return whitespaceCollapse(value);
            }
            n = int(n);
            if(n < 10)
            {
               result = result.concat("0");
            }
            result = result.concat(n);
         }
         return result;
      }
      
      public function marshallBoolean(value:*, type:QName = null, restriction:XML = null) : String
      {
         var result:String = null;
         var s:String = null;
         if(value != null)
         {
            if(value is Boolean)
            {
               result = value as Boolean ? "true" : "false";
            }
            else if(value is Number)
            {
               result = value == 1 ? "true" : "false";
            }
            else if(value is Object)
            {
               s = Object(value).toString();
               if(!(s == "true" || s == "false" || s == "1" || s == "0"))
               {
                  throw new Error("String \'" + value + "\' is not a Boolean.");
               }
               result = s;
            }
         }
         return result;
      }
      
      public function unmarshallFloat(value:*, type:QName = null, restriction:XML = null) : Number
      {
         return unmarshallDouble(value,type,restriction);
      }
      
      public function marshallAny(value:*, type:QName = null, restriction:XML = null) : *
      {
         if(value === undefined)
         {
            return undefined;
         }
         if(value == null)
         {
            return null;
         }
         var localName:String = guessSimpleType(value);
         if(type != null)
         {
            type = new QName(type.uri,localName);
         }
         else
         {
            type = new QName(constants.xsdURI,localName);
         }
         var marshaller:Function = marshallers[type.localName];
         if(marshaller != null)
         {
            return marshaller(value,type);
         }
         throw new TypeError("Cannot marshall type \'" + type + "\' to simple content.");
      }
      
      public function marshallString(value:*, type:QName = null, restriction:XML = null) : String
      {
         if(value != null)
         {
            if(value is XML || value is XMLList)
            {
               return value.toXMLString();
            }
            if(value is Object)
            {
               return Object(value).toString();
            }
         }
         return null;
      }
   }
}

