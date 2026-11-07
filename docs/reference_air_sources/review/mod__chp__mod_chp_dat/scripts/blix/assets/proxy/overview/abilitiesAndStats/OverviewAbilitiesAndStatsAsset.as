package blix.assets.proxy.overview.abilitiesAndStats
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   
   public class OverviewAbilitiesAndStatsAsset extends InstanceMapping
   {
      
      public var overviewAbility0:OverviewAbilityIconAsset;
      
      public var overviewAbility1:OverviewAbilityIconAsset;
      
      public var overviewAbility2:OverviewAbilityIconAsset;
      
      public var overviewAbility3:OverviewAbilityIconAsset;
      
      public var overviewAbility4:OverviewAbilityIconAsset;
      
      public var attributesLabel:TextFieldMapping;
      
      public var statsLabel:TextFieldMapping;
      
      public var abilitiesLabel:TextFieldMapping;
      
      public var attackIcon:blix.assets.proxy.overview.abilitiesAndStats.attackIcon;
      
      public var healthIcon:blix.assets.proxy.overview.abilitiesAndStats.healthIcon;
      
      public var abilityPowerIcon:blix.assets.proxy.overview.abilitiesAndStats.abilityPowerIcon;
      
      public var difficultyIcon:blix.assets.proxy.overview.abilitiesAndStats.difficultyIcon;
      
      public var attackBar:StatBar;
      
      public var healthBar:StatBarDefense;
      
      public var abilityPowerBar:StatBarAbilityPower;
      
      public var difficultyBar:StatBarDifficulty;
      
      public var tagsText:TextFieldMapping;
      
      public function OverviewAbilitiesAndStatsAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.overviewAbility0 = new OverviewAbilityIconAsset("overviewAbility0",this);
         this.overviewAbility1 = new OverviewAbilityIconAsset("overviewAbility1",this);
         this.overviewAbility2 = new OverviewAbilityIconAsset("overviewAbility2",this);
         this.overviewAbility3 = new OverviewAbilityIconAsset("overviewAbility3",this);
         this.overviewAbility4 = new OverviewAbilityIconAsset("overviewAbility4",this);
         this.attributesLabel = new TextFieldMapping("attributesLabel",this);
         this.statsLabel = new TextFieldMapping("statsLabel",this);
         this.abilitiesLabel = new TextFieldMapping("abilitiesLabel",this);
         this.attackIcon = new blix.assets.proxy.overview.abilitiesAndStats.attackIcon("attackIcon",this);
         this.healthIcon = new blix.assets.proxy.overview.abilitiesAndStats.healthIcon("healthIcon",this);
         this.abilityPowerIcon = new blix.assets.proxy.overview.abilitiesAndStats.abilityPowerIcon("abilityPowerIcon",this);
         this.difficultyIcon = new blix.assets.proxy.overview.abilitiesAndStats.difficultyIcon("difficultyIcon",this);
         this.attackBar = new StatBar("attackBar",this);
         this.healthBar = new StatBarDefense("healthBar",this);
         this.abilityPowerBar = new StatBarAbilityPower("abilityPowerBar",this);
         this.difficultyBar = new StatBarDifficulty("difficultyBar",this);
         this.tagsText = new TextFieldMapping("tagsText",this);
      }
      
      public function create(param1:DisplayObjectContainerProxy) : SpriteProxy
      {
         var _loc2_:String = getName();
         var _loc3_:SpriteProxy = new SpriteProxy(param1);
         param1.setTimelineChildByName(_loc2_,_loc3_);
         return _loc3_;
      }
   }
}

