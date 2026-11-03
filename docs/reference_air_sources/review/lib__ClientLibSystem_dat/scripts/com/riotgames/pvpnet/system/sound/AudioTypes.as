package com.riotgames.pvpnet.system.sound
{
   public class AudioTypes
   {
      
      public static const LOGIN_LORE:String = "login_lore";
      
      public static const LOGIN_MUSIC:String = "login_music";
      
      public static const LAYERED_MUSIC:String = "layered_music";
      
      public static const MUSIC:String = "music";
      
      public static const SFX:String = "sfx";
      
      public function AudioTypes()
      {
         super();
      }
      
      public static function isTypeExclusivePlayMusic(param1:String) : Boolean
      {
         if(param1 == LOGIN_MUSIC || param1 == MUSIC)
         {
            return true;
         }
         return false;
      }
   }
}

