package com.riotgames.platform.gameclient.domain
{
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.PublicSummoner")]
   public class PublicSummoner extends BaseSummoner
   {
      
      private var _830060173summonerAssociatedTalents:ArrayCollection;
      
      private var _1545882922summonerLevel:Number;
      
      public function PublicSummoner()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerAssociatedTalents() : ArrayCollection
      {
         return this._830060173summonerAssociatedTalents;
      }
      
      public function set summonerAssociatedTalents(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._830060173summonerAssociatedTalents;
         if(_loc2_ !== param1)
         {
            this._830060173summonerAssociatedTalents = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerAssociatedTalents",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerLevel() : Number
      {
         return this._1545882922summonerLevel;
      }
      
      public function set summonerLevel(param1:Number) : void
      {
         var _loc2_:Object = this._1545882922summonerLevel;
         if(_loc2_ !== param1)
         {
            this._1545882922summonerLevel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerLevel",_loc2_,param1));
         }
      }
   }
}

