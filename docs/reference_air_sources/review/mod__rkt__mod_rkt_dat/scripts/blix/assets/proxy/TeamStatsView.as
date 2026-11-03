package blix.assets.proxy
{
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   import blix.context.Context;
   
   public class TeamStatsView extends InstanceMapping
   {
      
      public static const LINKAGE:String = "ts.TeamStatsView";
      
      public var teamLostText:TextFieldMapping;
      
      public var teamWonText:TextFieldMapping;
      
      public var teamTotalKillsText:TextFieldMapping;
      
      public var teamAverageKillsText:TextFieldMapping;
      
      public var teamTotalDeathsText:TextFieldMapping;
      
      public var teamAverageDeathsText:TextFieldMapping;
      
      public var teamDoubleKillsText:TextFieldMapping;
      
      public var teamTripleKillsText:TextFieldMapping;
      
      public var teamQuadraKillsText:TextFieldMapping;
      
      public var teamPentaKillsText:TextFieldMapping;
      
      public var teamTotalAssistsText:TextFieldMapping;
      
      public var teamAverageAssistsText:TextFieldMapping;
      
      public var champPanel:blix.assets.proxy.champPanel;
      
      public var statsInfoIcon:blix.assets.proxy.statsInfoIcon;
      
      public var champBar0:AnimatedChampBar;
      
      public var champBar1:AnimatedChampBar;
      
      public var champBar2:AnimatedChampBar;
      
      public var champBar3:AnimatedChampBar;
      
      public var champBar4:AnimatedChampBar;
      
      public var noGamesPlayedText:TextFieldMapping;
      
      public var queueDropdown:blix.assets.proxy.queueDropdown;
      
      public var background_elements:landingBG_left;
      
      public function TeamStatsView(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.teamLostText = new TextFieldMapping("teamLostText",this);
         this.teamWonText = new TextFieldMapping("teamWonText",this);
         this.teamTotalKillsText = new TextFieldMapping("teamTotalKillsText",this);
         this.teamAverageKillsText = new TextFieldMapping("teamAverageKillsText",this);
         this.teamTotalDeathsText = new TextFieldMapping("teamTotalDeathsText",this);
         this.teamAverageDeathsText = new TextFieldMapping("teamAverageDeathsText",this);
         this.teamDoubleKillsText = new TextFieldMapping("teamDoubleKillsText",this);
         this.teamTripleKillsText = new TextFieldMapping("teamTripleKillsText",this);
         this.teamQuadraKillsText = new TextFieldMapping("teamQuadraKillsText",this);
         this.teamPentaKillsText = new TextFieldMapping("teamPentaKillsText",this);
         this.teamTotalAssistsText = new TextFieldMapping("teamTotalAssistsText",this);
         this.teamAverageAssistsText = new TextFieldMapping("teamAverageAssistsText",this);
         this.champPanel = new blix.assets.proxy.champPanel("champPanel",this);
         this.statsInfoIcon = new blix.assets.proxy.statsInfoIcon("statsInfoIcon",this);
         this.champBar0 = new AnimatedChampBar("champBar0",this);
         this.champBar1 = new AnimatedChampBar("champBar1",this);
         this.champBar2 = new AnimatedChampBar("champBar2",this);
         this.champBar3 = new AnimatedChampBar("champBar3",this);
         this.champBar4 = new AnimatedChampBar("champBar4",this);
         this.noGamesPlayedText = new TextFieldMapping("noGamesPlayedText",this);
         this.queueDropdown = new blix.assets.proxy.queueDropdown("queueDropdown",this);
         this.background_elements = new landingBG_left("background_elements",this);
      }
      
      public static function create(param1:Context) : MovieClipProxy
      {
         var _loc2_:MovieClipProxy = new MovieClipProxy(param1);
         _loc2_.setLinkage(LINKAGE);
         return _loc2_;
      }
      
      public function clone(param1:Context) : MovieClipProxy
      {
         return TeamStatsView.create(param1);
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

