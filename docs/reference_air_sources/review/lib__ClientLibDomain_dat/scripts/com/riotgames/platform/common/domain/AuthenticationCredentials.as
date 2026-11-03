package com.riotgames.platform.common.domain
{
   [RemoteClass(alias="com.riotgames.platform.login.AuthenticationCredentials")]
   public class AuthenticationCredentials
   {
      
      public var locale:String;
      
      public var macAddress:String;
      
      public var oldPassword:String;
      
      public var domain:String;
      
      public var clientVersion:String;
      
      public var operatingSystem:String;
      
      public var authToken:String;
      
      public var partnerCredentials:String;
      
      public var password:String;
      
      public var username:String;
      
      public var securityAnswer:String;
      
      public function AuthenticationCredentials()
      {
         super();
      }
   }
}

