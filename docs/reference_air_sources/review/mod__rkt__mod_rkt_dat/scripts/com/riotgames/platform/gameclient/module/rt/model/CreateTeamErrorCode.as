package com.riotgames.platform.gameclient.module.rt.model
{
   public class CreateTeamErrorCode
   {
      
      public static const TAG_ALREADY_TAKEN:String = "EXISTING_TEAM_TAG";
      
      public static const NAME_ALREADY_TAKEN:String = "EXISTING_TEAM_NAME";
      
      public static const INVALID_TEAM_TAG_USED_BY_OTHER_NAME:String = "INVALID_TEAM_TAG_USED_BY_OTHER_NAME";
      
      public static const INVALID_TEAM_NAME_USED_BY_OTHER_TAG:String = "INVALID_TEAM_NAME_USED_BY_OTHER_TAG";
      
      public static const PLAYER_CANT_CREATE_TEAM:String = "PLAYER_CANNOT_CREATE_TEAM";
      
      public static const INVALID_TEAM_NAME_FILTER:String = "INVALID_TEAM_NAME_FILTER";
      
      public static const INVALID_TEAM_NAME_LENGTH:String = "INVALID_TEAM_NAME_LENGTH";
      
      public static const INVALID_TEAM_NAME_CHARACTERS:String = "INVALID_TEAM_NAME_CHARACTERS";
      
      public static const INVALID_TEAM_TAG_FILTER:String = "INVALID_TEAM_TAG_FILTER";
      
      public static const INVALID_TEAM_TAG_CHARACTERS:String = "INVALID_TEAM_TAG_CHARACTERS";
      
      public static const INVALID_TEAM_TAG_LENGTH:String = "INVALID_TEAM_TAG_LENGTH";
      
      public function CreateTeamErrorCode()
      {
         super();
         throw "Do not create an instance of this class!";
      }
   }
}

