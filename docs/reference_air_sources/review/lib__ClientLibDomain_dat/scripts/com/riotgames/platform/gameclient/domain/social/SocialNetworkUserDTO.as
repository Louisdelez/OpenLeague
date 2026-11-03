package com.riotgames.platform.gameclient.domain.social
{
   import mx.collections.ArrayCollection;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.SocialNetworkUserDTO")]
   public class SocialNetworkUserDTO
   {
      
      public var summoners:ArrayCollection;
      
      public var hashedNetworkUserId:String;
      
      public var realName:String;
      
      public var invitedTime:Number;
      
      public var networkUserId:String;
      
      public var network:String;
      
      public function SocialNetworkUserDTO()
      {
         super();
      }
   }
}

