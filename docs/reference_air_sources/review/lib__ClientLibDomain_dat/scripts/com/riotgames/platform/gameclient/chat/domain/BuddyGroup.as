package com.riotgames.platform.gameclient.chat.domain
{
   import mx.collections.ArrayCollection;
   
   [ArrayElementType("com.riotgames.platform.gameclient.chat.domain.Buddy")]
   public class BuddyGroup extends ArrayCollection
   {
      
      private var _label:String;
      
      public function BuddyGroup()
      {
         super();
      }
      
      public function setLabel(param1:String) : void
      {
         this._label = param1;
      }
      
      public function getLabel() : String
      {
         return this._label;
      }
   }
}

