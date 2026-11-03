package flash.sampler
{
   [native(cls="ScriptSamplerClass",methods="auto",construct="none")]
   public final class ScriptSampler
   {
      
      public function ScriptSampler()
      {
         super();
      }
      
      public static native function getType(param1:Number) : String;
      
      public static native function getSize(param1:Number) : Number;
      
      public static native function getMembers(param1:Number) : Vector.<ScriptMember>;
      
      public static native function getInvocationCount(param1:Number) : Number;
      
      public static native function getName(param1:Number) : String;
      
      public static native function getFilename(param1:Number) : String;
   }
}

