package com.riotgames.platform.common.exception
{
   [RemoteClass(alias="com.riotgames.platform.messaging.UnexpectedServiceException")]
   public class UnexpectedServiceException
   {
      
      public var message:String;
      
      public var rootCauseClassname:String;
      
      public var stackTraceString:String;
      
      public function UnexpectedServiceException()
      {
         super();
      }
   }
}

