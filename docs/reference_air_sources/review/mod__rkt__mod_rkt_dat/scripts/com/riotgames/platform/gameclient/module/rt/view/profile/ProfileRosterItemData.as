package com.riotgames.platform.gameclient.module.rt.view.profile
{
   import com.riotgames.platform.gameclient.chat.domain.Buddy;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamMemberInfo;
   
   public class ProfileRosterItemData
   {
      
      public var buddy:Buddy;
      
      public var info:TeamMemberInfo;
      
      public function ProfileRosterItemData(param1:TeamMemberInfo)
      {
         super();
         this.info = param1;
      }
   }
}

