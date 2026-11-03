package com.riotgames.util.logging
{
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public function getLogger(param1:Object) : ILogger
   {
      return Log.getLogger(getQualifiedClassName(param1).replace(/::/,"."));
   }
}

