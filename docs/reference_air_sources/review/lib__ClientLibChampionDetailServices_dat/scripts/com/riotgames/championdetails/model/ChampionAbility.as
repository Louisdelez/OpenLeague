package com.riotgames.championdetails.model
{
   public class ChampionAbility
   {
      
      public var championId:int;
      
      public var cooldown:String;
      
      public var _cost:String;
      
      private var _description:String;
      
      public var effect:String;
      
      public var iconPath:String;
      
      public var videoPath:String;
      
      public var id:uint;
      
      public var name:String;
      
      public var range:String;
      
      public var rank:int;
      
      public var hotkey:String;
      
      public function ChampionAbility()
      {
         super();
      }
      
      public function get description() : String
      {
         return this._description;
      }
      
      public function set description(param1:String) : void
      {
         if(param1 != null)
         {
            this._description = param1.replace(/[\[\(]\s*[\]\)]/g,"");
         }
      }
      
      public function get cost() : String
      {
         return this._cost;
      }
      
      public function set cost(param1:String) : void
      {
         if(param1 != null)
         {
            this._cost = param1.replace(/[\[\(]\s*[\]\)]/g,"").replace(new RegExp("\\b0/(\\d+/\\d+/\\d+/\\d+)","g"),"$1");
         }
      }
   }
}

