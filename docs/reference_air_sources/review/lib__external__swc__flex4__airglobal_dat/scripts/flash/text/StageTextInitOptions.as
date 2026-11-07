package flash.text
{
   [API("675")]
   [native(cls="StageTextInitOptionsClass",instance="StageTextInitOptionsObject",methods="auto")]
   public class StageTextInitOptions
   {
      
      public function StageTextInitOptions(multiline:Boolean = false)
      {
         super();
         this.multiline = multiline;
      }
      
      public native function set multiline(param1:Boolean) : *;
      
      public native function get multiline() : Boolean;
   }
}

