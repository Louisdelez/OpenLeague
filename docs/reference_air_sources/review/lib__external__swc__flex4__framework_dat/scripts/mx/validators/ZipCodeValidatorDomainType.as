package mx.validators
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public final class ZipCodeValidatorDomainType
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      public static const US_OR_CANADA:String = "US or Canada";
      
      public static const US_ONLY:String = "US Only";
      
      public static const CANADA_ONLY:String = "Canada Only";
      
      public function ZipCodeValidatorDomainType()
      {
         super();
      }
   }
}

