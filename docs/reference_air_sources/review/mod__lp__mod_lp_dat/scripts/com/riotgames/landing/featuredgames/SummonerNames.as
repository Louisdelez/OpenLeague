package com.riotgames.landing.featuredgames
{
   import blix.assets.proxy.FeaturedGamesSlider.SummonerNamesAsset;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.text.Text;
   import blix.context.IContext;
   import com.riotgames.landing.FeaturedGamesPlayer;
   import flash.utils.Dictionary;
   
   public class SummonerNames extends SpriteProxy
   {
      
      private var playerTextMap:Dictionary;
      
      public function SummonerNames(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         var _loc4_:Text = null;
         super.createChildren();
         var _loc1_:SummonerNamesAsset = new SummonerNamesAsset();
         this.playerTextMap = new Dictionary();
         var _loc2_:int = 101;
         var _loc3_:int = 0;
         while(_loc3_ < 10)
         {
            _loc4_ = new Text(this);
            setTimelineChild(_loc1_["player" + _loc2_ + "Asset"],_loc4_);
            this.playerTextMap[_loc2_] = _loc4_;
            _loc2_++;
            if(_loc3_ == 4)
            {
               _loc2_ = 201;
            }
            _loc3_++;
         }
      }
      
      public function setData(param1:Vector.<FeaturedGamesPlayer>) : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:FeaturedGamesPlayer = null;
         for each(_loc2_ in this.playerTextMap)
         {
            _loc2_.setText("");
         }
         _loc3_ = 1;
         _loc4_ = 1;
         _loc5_ = 0;
         for each(_loc6_ in param1)
         {
            if(!isNaN(_loc6_.teamId))
            {
               if(_loc6_.teamId == 100)
               {
                  _loc5_ = _loc6_.teamId + _loc3_;
                  _loc3_++;
               }
               if(_loc6_.teamId == 200)
               {
                  _loc5_ = _loc6_.teamId + _loc4_;
                  _loc4_++;
               }
               if(this.playerTextMap[_loc5_])
               {
                  this.playerTextMap[_loc5_].setText(_loc6_.summonerName);
               }
            }
         }
      }
   }
}

