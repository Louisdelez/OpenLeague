package spark.globalization.supportClasses
{
   [ExcludeClass]
   internal final class FormatPattern
   {
      
      public var pattern:String;
      
      public var locales:Object;
      
      public function FormatPattern(pattern:String, locales:Array)
      {
         super();
         this.pattern = pattern;
         this.locales = new Object();
         for(var i:int = 0; i < locales.length; i++)
         {
            this.locales[locales[i]] = true;
         }
      }
   }
}

