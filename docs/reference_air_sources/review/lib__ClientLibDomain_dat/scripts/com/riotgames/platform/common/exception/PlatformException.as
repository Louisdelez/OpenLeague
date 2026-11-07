package com.riotgames.platform.common.exception
{
   [RemoteClass(alias="com.riotgames.platform.messaging.PlatformException")]
   public class PlatformException
   {
      
      public var errorCode:String;
      
      public var substitutionArguments:Array;
      
      public var rootCauseClassname:String;
      
      public function PlatformException()
      {
         super();
      }
   }
}

