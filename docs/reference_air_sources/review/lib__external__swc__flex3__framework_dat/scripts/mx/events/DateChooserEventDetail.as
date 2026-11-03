package mx.events
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public final class DateChooserEventDetail
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public static const NEXT_MONTH:String = "nextMonth";
      
      public static const NEXT_YEAR:String = "nextYear";
      
      public static const PREVIOUS_MONTH:String = "previousMonth";
      
      public static const PREVIOUS_YEAR:String = "previousYear";
      
      public function DateChooserEventDetail()
      {
         super();
      }
   }
}

