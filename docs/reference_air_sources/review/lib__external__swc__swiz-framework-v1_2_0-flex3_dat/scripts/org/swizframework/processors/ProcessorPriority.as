package org.swizframework.processors
{
   public final class ProcessorPriority
   {
      
      public static const AUTO_PROXY:int = 900;
      
      public static const PRE_DESTROY:int = 800;
      
      public static const INJECT:int = 700;
      
      public static const EVENT_HANDLER:int = 600;
      
      public static const DISPATCHER:int = 500;
      
      public static const DEFAULT:int = 400;
      
      public static const SWIZ_INTERFACE:int = 300;
      
      public static const POST_CONSTRUCT:int = 200;
      
      public function ProcessorPriority()
      {
         super();
      }
   }
}

