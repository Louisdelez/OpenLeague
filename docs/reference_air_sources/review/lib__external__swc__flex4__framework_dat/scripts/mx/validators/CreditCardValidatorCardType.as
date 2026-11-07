package mx.validators
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public final class CreditCardValidatorCardType
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      public static const MASTER_CARD:String = "MasterCard";
      
      public static const VISA:String = "Visa";
      
      public static const AMERICAN_EXPRESS:String = "American Express";
      
      public static const DISCOVER:String = "Discover";
      
      public static const DINERS_CLUB:String = "Diners Club";
      
      public function CreditCardValidatorCardType()
      {
         super();
      }
   }
}

