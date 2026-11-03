package com.riotgames.landing.featuredgames
{
   import blix.assets.proxy.FeaturedGamesSlider.TeamOneAsset;
   import blix.assets.proxy.SpriteProxy;
   import blix.context.IContext;
   import com.riotgames.landing.FeaturedGamesPlayer;
   
   public class TeamThumbs extends SpriteProxy
   {
      
      private var thumbs:Vector.<PlayerThumb>;
      
      private var _data:Vector.<FeaturedGamesPlayer>;
      
      public function TeamThumbs(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:TeamOneAsset = new TeamOneAsset();
         var _loc2_:PlayerThumb = new PlayerThumb(this);
         setTimelineChild(_loc1_.player1ThumbAsset,_loc2_);
         var _loc3_:PlayerThumb = new PlayerThumb(this);
         setTimelineChild(_loc1_.player2ThumbAsset,_loc3_);
         var _loc4_:PlayerThumb = new PlayerThumb(this);
         setTimelineChild(_loc1_.player3ThumbAsset,_loc4_);
         var _loc5_:PlayerThumb = new PlayerThumb(this);
         setTimelineChild(_loc1_.player4ThumbAsset,_loc5_);
         var _loc6_:PlayerThumb = new PlayerThumb(this);
         setTimelineChild(_loc1_.player5ThumbAsset,_loc6_);
         this.thumbs = new Vector.<PlayerThumb>(5);
         this.thumbs[0] = _loc2_;
         this.thumbs[1] = _loc3_;
         this.thumbs[2] = _loc4_;
         this.thumbs[3] = _loc5_;
         this.thumbs[4] = _loc6_;
      }
      
      public function setTeamPlayers(param1:Vector.<FeaturedGamesPlayer>, param2:Number) : void
      {
         var _loc3_:PlayerThumb = null;
         var _loc4_:int = 0;
         var _loc5_:FeaturedGamesPlayer = null;
         var _loc6_:PlayerThumb = null;
         if(this._data == param1)
         {
            return;
         }
         if(this._data != null)
         {
            for each(_loc3_ in this.thumbs)
            {
               _loc3_.unloadImage();
            }
         }
         this._data = param1;
         if(this._data != null)
         {
            _loc4_ = 0;
            for each(_loc5_ in this._data)
            {
               if(_loc4_ < this.thumbs.length && _loc5_.teamId == param2)
               {
                  _loc6_ = this.thumbs[_loc4_];
                  if(_loc6_)
                  {
                     _loc6_.loadImage(_loc5_.championIconPath);
                  }
                  _loc4_++;
               }
            }
         }
      }
   }
}

