package com.riotgames.platform.gameclient.kudos
{
   public class KudosChampSelectBadges
   {
      
      [Embed(source="/../../ClientAssets/imageEmbeds/championSelect/cs_lead.png")]
      public static var GreatLeaderBadge:Class = KudosChampSelectBadges_GreatLeaderBadge;
      
      [Embed(source="/../../ClientAssets/imageEmbeds/championSelect/cs_ment.png")]
      public static var GreatMentorBadge:Class = KudosChampSelectBadges_GreatMentorBadge;
      
      [Embed(source="/../../ClientAssets/imageEmbeds/championSelect/cs_teammate.png")]
      public static var GreatTeammateBadge:Class = KudosChampSelectBadges_GreatTeammateBadge;
      
      [Embed(source="/../../ClientAssets/imageEmbeds/championSelect/cs_hon.png")]
      public static var HonorableOpponentBadge:Class = KudosChampSelectBadges_HonorableOpponentBadge;
      
      public function KudosChampSelectBadges()
      {
         super();
      }
   }
}

