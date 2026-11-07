package mx.validators
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class RegExpValidationResult extends ValidationResult
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      public var matchedIndex:int;
      
      public var matchedString:String;
      
      public var matchedSubstrings:Array;
      
      public function RegExpValidationResult(isError:Boolean, subField:String = "", errorCode:String = "", errorMessage:String = "", matchedString:String = "", matchedIndex:int = 0, matchedSubstrings:Array = null)
      {
         super(isError,subField,errorCode,errorMessage);
         this.matchedString = matchedString;
         this.matchedIndex = matchedIndex;
         this.matchedSubstrings = Boolean(matchedSubstrings) ? matchedSubstrings : [];
      }
   }
}

