package com.riotgames.platform.gameclient.domain.kudos
{
   import com.riotgames.platform.gameclient.notification.ClientNotificationType;
   import com.riotgames.platform.gameclient.notification.IClientNotification;
   import mx.collections.ArrayCollection;
   
   [RemoteClass(alias="com.riotgames.kudos.dto.PendingKudosDTO")]
   public class PendingKudos implements IClientNotification
   {
      
      public static const FRIENDLY:Number = 1;
      
      public static const HELPFUL:Number = 2;
      
      public static const TEAMWORK:Number = 3;
      
      public static const HONORABLE_OPPONENT:Number = 4;
      
      private static const NUM_HONOR_TYPES:Number = 4;
      
      public var pendingCounts:ArrayCollection;
      
      public function PendingKudos()
      {
         super();
      }
      
      public function getHonorTotal() : Number
      {
         return this.getHonorCount(FRIENDLY) + this.getHonorCount(HELPFUL) + this.getHonorCount(TEAMWORK) + this.getHonorCount(HONORABLE_OPPONENT);
      }
      
      public function getHonorCount(param1:Number) : Number
      {
         if(param1 < 1 || param1 > NUM_HONOR_TYPES)
         {
            throw new ArgumentError("Invalid honor type requested");
         }
         return Boolean(this.pendingCounts.source) && param1 < this.pendingCounts.source.length ? Number(this.pendingCounts[param1]) : 0;
      }
      
      public function toString() : String
      {
         if(!this.pendingCounts || !this.pendingCounts.source)
         {
            return "[pendingKudos: null]";
         }
         return "[pendingKudos: " + this.pendingCounts.source.toString() + "]";
      }
      
      public function setHonorCount(param1:Number, param2:Number) : void
      {
         if(param1 < 1 || param1 > NUM_HONOR_TYPES)
         {
            throw new ArgumentError("Invalid honor type requested");
         }
         if(!this.pendingCounts || !this.pendingCounts.source)
         {
            this.pendingCounts = new ArrayCollection([0,0,0,0,0]);
         }
         this.pendingCounts.source[param1] = param2;
      }
      
      public function isValid() : Boolean
      {
         return this.pendingCounts.length == NUM_HONOR_TYPES + 1;
      }
      
      public function get notificationType() : String
      {
         return ClientNotificationType.KUDOS_RECEIVED;
      }
      
      public function getKudosCountsArray() : Array
      {
         return Boolean(this.pendingCounts) ? this.pendingCounts.source : [];
      }
   }
}

