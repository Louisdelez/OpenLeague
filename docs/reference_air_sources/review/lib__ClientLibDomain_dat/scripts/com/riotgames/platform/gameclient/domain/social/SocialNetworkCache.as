package com.riotgames.platform.gameclient.domain.social
{
   import mx.collections.ArrayCollection;
   
   public class SocialNetworkCache
   {
      
      private var _contacts:ArrayCollection;
      
      public function SocialNetworkCache()
      {
         super();
      }
      
      public function set contacts(param1:ArrayCollection) : void
      {
         this._contacts = param1;
      }
      
      public function getInviteTimes() : Array
      {
         var _loc2_:Object = null;
         var _loc3_:SocialNetworkContact = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this._contacts)
         {
            _loc3_ = _loc2_ as SocialNetworkContact;
            _loc1_.push(_loc3_.invited);
         }
         return _loc1_;
      }
      
      public function get contacts() : ArrayCollection
      {
         return this._contacts;
      }
      
      public function getContactIds() : Array
      {
         var _loc2_:Object = null;
         var _loc3_:SocialNetworkContact = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this._contacts)
         {
            _loc3_ = _loc2_ as SocialNetworkContact;
            _loc1_.push(_loc3_.networkId);
         }
         return _loc1_;
      }
   }
}

