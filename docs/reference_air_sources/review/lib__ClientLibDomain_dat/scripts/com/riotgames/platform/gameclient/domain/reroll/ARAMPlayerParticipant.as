package com.riotgames.platform.gameclient.domain.reroll
{
   import com.riotgames.platform.gameclient.domain.PlayerParticipant;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.reroll.pojo.AramPlayerParticipant")]
   public class ARAMPlayerParticipant extends PlayerParticipant
   {
      
      private var _1569714645_pointSummary:PointSummary;
      
      public function ARAMPlayerParticipant()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get _pointSummary() : PointSummary
      {
         return this._1569714645_pointSummary;
      }
      
      public function get pointSummary() : PointSummary
      {
         return this._pointSummary;
      }
      
      public function set _pointSummary(param1:PointSummary) : void
      {
         var _loc2_:Object = this._1569714645_pointSummary;
         if(_loc2_ !== param1)
         {
            this._1569714645_pointSummary = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_pointSummary",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set pointSummary(param1:PointSummary) : void
      {
         var _loc2_:Object = this.pointSummary;
         if(_loc2_ !== param1)
         {
            this._621770762pointSummary = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pointSummary",_loc2_,param1));
         }
      }
      
      private function set _621770762pointSummary(param1:PointSummary) : void
      {
         this._pointSummary = param1;
      }
   }
}

