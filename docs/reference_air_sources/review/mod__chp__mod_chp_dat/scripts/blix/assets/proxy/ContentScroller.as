package blix.assets.proxy
{
   import blix.assets.proxy.abilities.AbilitiesVideoAsset;
   import blix.assets.proxy.abilities.AbilityIconAsset;
   import blix.assets.proxy.lore.Gem;
   import blix.assets.proxy.lore.LoreLighting;
   import blix.assets.proxy.lore.LoreText;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   import blix.assets.proxy.overview.OverviewBackground;
   import blix.assets.proxy.overview.abilitiesAndStats.OverviewAbilitiesAndStatsAsset;
   import blix.assets.proxy.overview.skinChooser.SkinChooserAsset;
   import blix.assets.proxy.tipsScreen.TipsScreenAsset;
   import blix.assets.proxy.tipsScreen.classicItemsHolder;
   import blix.assets.proxy.tipsScreen.dominionItemsHolder;
   
   public class ContentScroller extends InstanceMapping
   {
      
      public var tipsPane:TipsScreenAsset;
      
      public var classicItemsPane:classicItemsHolder;
      
      public var dominionItemsPane:dominionItemsHolder;
      
      public var recommendedItemTitle:TextFieldMapping;
      
      public var loreColorDodge:LoreLighting;
      
      public var loreSoftLight:LoreLighting;
      
      public var gem:Gem;
      
      public var video:AbilitiesVideoAsset;
      
      public var ability0:AbilityIconAsset;
      
      public var ability1:AbilityIconAsset;
      
      public var ability2:AbilityIconAsset;
      
      public var ability3:AbilityIconAsset;
      
      public var ability4:AbilityIconAsset;
      
      public var abilityTitle:TextFieldMapping;
      
      public var abilityDescription:TextFieldMapping;
      
      public var loreText:LoreText;
      
      public var nameText:TextFieldMapping;
      
      public var descriptionText:TextFieldMapping;
      
      public var overviewAbilitiesAndStats:OverviewAbilitiesAndStatsAsset;
      
      public var skinSelector:SkinChooserAsset;
      
      public var overviewBackground:OverviewBackground;
      
      public function ContentScroller(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.tipsPane = new TipsScreenAsset("tipsPane",this);
         this.classicItemsPane = new classicItemsHolder("classicItemsPane",this);
         this.dominionItemsPane = new dominionItemsHolder("dominionItemsPane",this);
         this.recommendedItemTitle = new TextFieldMapping("recommendedItemTitle",this);
         this.loreColorDodge = new LoreLighting("loreColorDodge",this);
         this.loreSoftLight = new LoreLighting("loreSoftLight",this);
         this.gem = new Gem("gem",this);
         this.video = new AbilitiesVideoAsset("video",this);
         this.ability0 = new AbilityIconAsset("ability0",this);
         this.ability1 = new AbilityIconAsset("ability1",this);
         this.ability2 = new AbilityIconAsset("ability2",this);
         this.ability3 = new AbilityIconAsset("ability3",this);
         this.ability4 = new AbilityIconAsset("ability4",this);
         this.abilityTitle = new TextFieldMapping("abilityTitle",this);
         this.abilityDescription = new TextFieldMapping("abilityDescription",this);
         this.loreText = new LoreText("loreText",this);
         this.nameText = new TextFieldMapping("nameText",this);
         this.descriptionText = new TextFieldMapping("descriptionText",this);
         this.overviewAbilitiesAndStats = new OverviewAbilitiesAndStatsAsset("overviewAbilitiesAndStats",this);
         this.skinSelector = new SkinChooserAsset("skinSelector",this);
         this.overviewBackground = new OverviewBackground("overviewBackground",this);
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

