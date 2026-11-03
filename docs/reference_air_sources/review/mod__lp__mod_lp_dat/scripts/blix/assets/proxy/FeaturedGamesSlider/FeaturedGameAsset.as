package blix.assets.proxy.FeaturedGamesSlider
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.MovieClipProxy;
   import blix.assets.proxy.bg_scroll;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   
   public class FeaturedGameAsset extends InstanceMapping
   {
      
      public var summonerNamesAsset:SummonerNamesAsset;
      
      public var teamTwoSmallAsset:TeamTwoSmallAsset;
      
      public var teamOneSmallAsset:TeamOneSmallAsset;
      
      public var teamOneAsset:TeamOneAsset;
      
      public var teamTwoAsset:TeamTwoAsset;
      
      public var gameTimeAsset:TextFieldMapping;
      
      public var queueTypeAsset:TextFieldMapping;
      
      public var titleAsset:TextFieldMapping;
      
      public var backgroundAsset:bg_scroll;
      
      public function FeaturedGameAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.summonerNamesAsset = new SummonerNamesAsset("summonerNamesAsset",this);
         this.teamTwoSmallAsset = new TeamTwoSmallAsset("teamTwoSmallAsset",this);
         this.teamOneSmallAsset = new TeamOneSmallAsset("teamOneSmallAsset",this);
         this.teamOneAsset = new TeamOneAsset("teamOneAsset",this);
         this.teamTwoAsset = new TeamTwoAsset("teamTwoAsset",this);
         this.gameTimeAsset = new TextFieldMapping("gameTimeAsset",this);
         this.queueTypeAsset = new TextFieldMapping("queueTypeAsset",this);
         this.titleAsset = new TextFieldMapping("titleAsset",this);
         this.backgroundAsset = new bg_scroll("backgroundAsset",this);
      }
      
      public function create(param1:DisplayObjectContainerProxy) : MovieClipProxy
      {
         var _loc2_:String = getName();
         var _loc3_:MovieClipProxy = new MovieClipProxy(param1);
         param1.setTimelineChildByName(_loc2_,_loc3_);
         return _loc3_;
      }
   }
}

