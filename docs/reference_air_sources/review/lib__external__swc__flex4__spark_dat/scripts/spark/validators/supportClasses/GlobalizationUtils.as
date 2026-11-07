package spark.validators.supportClasses
{
   import flash.globalization.NationalDigitsType;
   
   public class GlobalizationUtils
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const ASCII_SPACE:uint = 32;
      
      private static const ASCII_ZERO:uint = 48;
      
      private static const NO_BREAK_SPACE:uint = 160;
      
      private static const UNICODE_OGHAM_SPACE_MARK:uint = 5760;
      
      private static const UNICODE_MONGOLIAN_VOWEL_SEPARATOR:uint = 6158;
      
      private static const UNICODE_SPACE_START:uint = 8192;
      
      private static const UNICODE_SPACE_END:uint = 8203;
      
      private static const UNICODE_NARROW_NOBREAK_SPACE:uint = 8239;
      
      private static const UNICODE_MEDIUM_MATHEMATICAL_SPACE:uint = 8287;
      
      private static const UNICODE_IDEOGRAPHIC_SPACE:uint = 12288;
      
      private static const UNICODE_ZEROWIDTH_NOBREAK_SPACE:uint = 65279;
      
      private static const UNICODE_HIGH_SURROGATE_FRONT:uint = 55296;
      
      private static const UNICODE_HIGH_SURROGATE_BACK:uint = 56319;
      
      private static const UNICODE_LOW_SURROGATE_FRONT:uint = 56320;
      
      private static const UNICODE_LOW_SURROGATE_BACK:uint = 57343;
      
      private static const UNICODE_DIGITS:Array = new Array(ASCII_ZERO,NationalDigitsType.ARABIC_INDIC,NationalDigitsType.BALINESE,NationalDigitsType.BENGALI,NationalDigitsType.CHAM,NationalDigitsType.DEVANAGARI,NationalDigitsType.EUROPEAN,NationalDigitsType.EXTENDED_ARABIC_INDIC,NationalDigitsType.FULL_WIDTH,NationalDigitsType.GUJARATI,NationalDigitsType.GURMUKHI,NationalDigitsType.KANNADA,NationalDigitsType.KAYAH_LI,NationalDigitsType.KHMER,NationalDigitsType.LAO,NationalDigitsType.LEPCHA,NationalDigitsType.LIMBU,NationalDigitsType.MALAYALAM,NationalDigitsType.MONGOLIAN,NationalDigitsType.MYANMAR,NationalDigitsType.MYANMAR_SHAN,NationalDigitsType.NEW_TAI_LUE,NationalDigitsType.NKO,NationalDigitsType.OL_CHIKI,NationalDigitsType.ORIYA,NationalDigitsType.OSMANYA,NationalDigitsType.SAURASHTRA,NationalDigitsType.SUNDANESE,NationalDigitsType.TAMIL,NationalDigitsType.TELUGU,NationalDigitsType.THAI,NationalDigitsType.TIBETAN,NationalDigitsType.VAI);
      
      public function GlobalizationUtils()
      {
         super();
      }
      
      public static function isDigit(ccode:uint) : Boolean
      {
         for(var i:int = 0; i < UNICODE_DIGITS.length; i++)
         {
            if(ccode >= UNICODE_DIGITS[i] && ccode <= UNICODE_DIGITS[i] + 9)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function isLeadingSurrogate(ccode:uint) : Boolean
      {
         return ccode >= UNICODE_HIGH_SURROGATE_FRONT && ccode <= UNICODE_HIGH_SURROGATE_BACK;
      }
      
      public static function isTrailingSurrogate(ccode:uint) : Boolean
      {
         return ccode >= UNICODE_LOW_SURROGATE_FRONT && ccode <= UNICODE_LOW_SURROGATE_BACK;
      }
      
      public static function isWhiteSpace(ccode:uint) : Boolean
      {
         if(ccode == ASCII_SPACE || ccode == NO_BREAK_SPACE || ccode == 9)
         {
            return true;
         }
         if(ccode >= UNICODE_SPACE_START && ccode <= UNICODE_SPACE_END)
         {
            return true;
         }
         if(ccode == UNICODE_NARROW_NOBREAK_SPACE || ccode == UNICODE_MEDIUM_MATHEMATICAL_SPACE)
         {
            return true;
         }
         if(ccode == UNICODE_IDEOGRAPHIC_SPACE || ccode == UNICODE_ZEROWIDTH_NOBREAK_SPACE)
         {
            return true;
         }
         if(ccode == UNICODE_OGHAM_SPACE_MARK || ccode == UNICODE_MONGOLIAN_VOWEL_SEPARATOR)
         {
            return true;
         }
         return false;
      }
      
      public static function trim(input:String) : String
      {
         if(!input)
         {
            return null;
         }
         var len:int = input.length;
         for(var i:int = 0; i < len; i++)
         {
            if(!isWhiteSpace(input.charCodeAt(i)))
            {
               break;
            }
         }
         for(var j:int = len - 1; j >= 0; j--)
         {
            if(!isWhiteSpace(input.charCodeAt(j)))
            {
               break;
            }
         }
         return input.substring(i,j + 1);
      }
      
      public static function surrogateToUTF32(c0:uint, c1:uint) : uint
      {
         var out:uint = 0;
         var tmp:int = c0 & 0xFFFF;
         if(tmp < UNICODE_HIGH_SURROGATE_FRONT || tmp > UNICODE_LOW_SURROGATE_BACK)
         {
            out = uint(tmp);
         }
         else
         {
            out = uint(tmp - 55232 << 10);
            out += c1 & 0x03FF;
         }
         return out;
      }
   }
}

