package com.riotgames.pvpnet.system.logging
{
   import flash.filesystem.File;
   import mx.logging.targets.TraceTarget;
   
   public class LogTargetFactory
   {
      
      public function LogTargetFactory()
      {
         super();
      }
      
      public function getTraceTarget() : TraceTarget
      {
         return new TraceTarget();
      }
      
      public function getFileTarget(param1:File, param2:String) : FileTarget
      {
         return new FileTarget(param1,param2);
      }
   }
}

