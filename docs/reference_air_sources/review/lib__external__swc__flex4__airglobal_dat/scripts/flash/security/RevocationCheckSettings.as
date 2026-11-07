package flash.security
{
   public final class RevocationCheckSettings
   {
      
      public static const NEVER:String = "never";
      
      public static const BEST_EFFORT:String = "bestEffort";
      
      public static const REQUIRED_IF_AVAILABLE:String = "requiredIfInfoAvailable";
      
      public static const ALWAYS_REQUIRED:String = "alwaysRequired";
      
      public function RevocationCheckSettings()
      {
         super();
      }
   }
}

