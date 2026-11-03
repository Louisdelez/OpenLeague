package com.riotgames.platform.common.exception
{
   import mx.collections.ArrayCollection;
   
   [RemoteClass(alias="com.riotgames.platform.ValidationException")]
   public class ValidationException extends PlatformException
   {
      
      public var invalidFields:ArrayCollection;
      
      public function ValidationException()
      {
         super();
      }
   }
}

