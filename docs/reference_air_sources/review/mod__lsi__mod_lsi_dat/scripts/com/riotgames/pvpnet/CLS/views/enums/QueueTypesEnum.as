package com.riotgames.pvpnet.CLS.views.enums
{
   public class QueueTypesEnum
   {
      
      public static const QUEUES:Object = {
         "RANKED_SOLO_1x1":uint(2),
         "RANKED_SOLO_5x5":uint(2),
         "RANKED_TEAM_3x3":uint(1),
         "RANKED_TEAM_5x5":uint(0)
      };
      
      public static const QUEUES_LABEL:Object = {
         "RANKED_SOLO_1x1":"rvd1v1",
         "RANKED_SOLO_5x5":"rvd1v1",
         "RANKED_TEAM_3x3":"rvd3v3",
         "RANKED_TEAM_5x5":"rvd5v5"
      };
      
      public static const INT_TO_QUEUES:Object = {
         0:"RANKED_TEAM_5x5",
         1:"RANKED_TEAM_3x3",
         2:"RANKED_SOLO_5x5",
         3:"RANKED_SOLO_1x1"
      };
      
      public static const QUEUE_TYPE_5V5:uint = 0;
      
      public static const QUEUE_TYPE_3V3:uint = 1;
      
      public static const QUEUE_TYPE_SOLO:uint = 2;
      
      public static const QUEUE_TYPE_TOTAL:uint = 3;
      
      public function QueueTypesEnum()
      {
         super();
      }
   }
}

