package spark.globalization
{
   import flash.globalization.LastOperationStatus;
   
   public final class LastOperationStatus
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public static const NO_ERROR:String = flash.globalization.LastOperationStatus.NO_ERROR;
      
      public static const USING_FALLBACK_WARNING:String = flash.globalization.LastOperationStatus.USING_FALLBACK_WARNING;
      
      public static const USING_DEFAULT_WARNING:String = flash.globalization.LastOperationStatus.USING_DEFAULT_WARNING;
      
      public static const PARSE_ERROR:String = flash.globalization.LastOperationStatus.PARSE_ERROR;
      
      public static const UNSUPPORTED_ERROR:String = flash.globalization.LastOperationStatus.UNSUPPORTED_ERROR;
      
      public static const ERROR_CODE_UNKNOWN:String = flash.globalization.LastOperationStatus.ERROR_CODE_UNKNOWN;
      
      public static const PATTERN_SYNTAX_ERROR:String = flash.globalization.LastOperationStatus.PATTERN_SYNTAX_ERROR;
      
      public static const MEMORY_ALLOCATION_ERROR:String = flash.globalization.LastOperationStatus.MEMORY_ALLOCATION_ERROR;
      
      public static const ILLEGAL_ARGUMENT_ERROR:String = flash.globalization.LastOperationStatus.ILLEGAL_ARGUMENT_ERROR;
      
      public static const BUFFER_OVERFLOW_ERROR:String = flash.globalization.LastOperationStatus.BUFFER_OVERFLOW_ERROR;
      
      public static const INVALID_ATTR_VALUE:String = flash.globalization.LastOperationStatus.INVALID_ATTR_VALUE;
      
      public static const NUMBER_OVERFLOW_ERROR:String = flash.globalization.LastOperationStatus.NUMBER_OVERFLOW_ERROR;
      
      public static const INVALID_CHAR_FOUND:String = flash.globalization.LastOperationStatus.INVALID_CHAR_FOUND;
      
      public static const TRUNCATED_CHAR_FOUND:String = flash.globalization.LastOperationStatus.TRUNCATED_CHAR_FOUND;
      
      public static const INDEX_OUT_OF_BOUNDS_ERROR:String = flash.globalization.LastOperationStatus.INDEX_OUT_OF_BOUNDS_ERROR;
      
      public static const PLATFORM_API_FAILED:String = flash.globalization.LastOperationStatus.PLATFORM_API_FAILED;
      
      public static const UNEXPECTED_TOKEN:String = flash.globalization.LastOperationStatus.UNEXPECTED_TOKEN;
      
      public static const LOCALE_UNDEFINED_ERROR:String = "localeUndefinedError";
      
      public function LastOperationStatus()
      {
         super();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function isError(lastOperationStatus:String) : Boolean
      {
         switch(lastOperationStatus)
         {
            case NO_ERROR:
            case USING_FALLBACK_WARNING:
            case USING_DEFAULT_WARNING:
               return false;
            default:
               return true;
         }
      }
   }
}

