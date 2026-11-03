package blix.assets.proxy
{
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   
   public class champPanel extends InstanceMapping
   {
      
      public var champWonText:TextFieldMapping;
      
      public var champLostText:TextFieldMapping;
      
      public var champWinPercentText:TextFieldMapping;
      
      public var champTotalKillsText:TextFieldMapping;
      
      public var champAverageKillsText:TextFieldMapping;
      
      public var champTotalDeathsText:TextFieldMapping;
      
      public var champAverageDeathsText:TextFieldMapping;
      
      public var champTotalAssistsText:TextFieldMapping;
      
      public var champAverageAssistsText:TextFieldMapping;
      
      public var champAchievementText:TextFieldMapping;
      
      public var achievementIcons:reward_group;
      
      public function champPanel(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.champWonText = new TextFieldMapping("champWonText",this);
         this.champLostText = new TextFieldMapping("champLostText",this);
         this.champWinPercentText = new TextFieldMapping("champWinPercentText",this);
         this.champTotalKillsText = new TextFieldMapping("champTotalKillsText",this);
         this.champAverageKillsText = new TextFieldMapping("champAverageKillsText",this);
         this.champTotalDeathsText = new TextFieldMapping("champTotalDeathsText",this);
         this.champAverageDeathsText = new TextFieldMapping("champAverageDeathsText",this);
         this.champTotalAssistsText = new TextFieldMapping("champTotalAssistsText",this);
         this.champAverageAssistsText = new TextFieldMapping("champAverageAssistsText",this);
         this.champAchievementText = new TextFieldMapping("champAchievementText",this);
         this.achievementIcons = new reward_group("achievementIcons",this);
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

