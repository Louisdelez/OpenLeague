package com.riotgames.championdetails.overview
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.assets.proxy.overview.abilitiesAndStats.OverviewAbilitiesAndStatsAsset;
   import blix.components.text.Text;
   import blix.components.tooltip.assignToolTip;
   import blix.components.tooltip.unassignToolTip;
   import blix.context.Context;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.greensock.TweenLite;
   import com.greensock.easing.Sine;
   import com.riotgames.championdetails.IChampionDetailsContext;
   import com.riotgames.championdetails.Main;
   import com.riotgames.championdetails.abilities.AbilityButton;
   import com.riotgames.championdetails.model.ChampionAbility;
   import com.riotgames.championdetails.model.ChampionInfo;
   import com.riotgames.championdetails.tooltip.DescriptiveToolTip;
   import com.riotgames.championdetails.tooltip.DescriptiveToolTipModel;
   import com.riotgames.championdetails.tooltip.TweenedToolTipHandler;
   import flash.display.Sprite;
   import flash.events.Event;
   import mx.resources.IResourceManager;
   
   public class OverviewAbilitiesAndStats extends SpriteProxy
   {
      
      private static const CHAMPION_DETAILS_RESOURCE_ID:String = Main.CHAMPION_DETAILS_RESOURCE_ID;
      
      private var abilityButtons:Vector.<AbilityButton>;
      
      private var _championInfo:ChampionInfo;
      
      private var attackBar:SpriteProxy;
      
      private var attackIcon:SpriteProxy;
      
      private var defenseBar:SpriteProxy;
      
      private var healthIcon:SpriteProxy;
      
      private var abilityPowerBar:SpriteProxy;
      
      private var abilityPowerIcon:SpriteProxy;
      
      private var difficultyBar:SpriteProxy;
      
      private var difficultyIcon:SpriteProxy;
      
      private var tagsText:TextFieldProxy;
      
      private var abilitiesLabel:Text;
      
      private var statsLabel:Text;
      
      private var attributesLabel:Text;
      
      private var customToolTip:DescriptiveToolTip;
      
      private var cdpContext:IChampionDetailsContext;
      
      private var resourceManager:IResourceManager;
      
      public function OverviewAbilitiesAndStats(param1:Context, param2:Sprite = null)
      {
         super(param1,param2);
         this.cdpContext = getFirstContext(IChampionDetailsContext);
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this.resourceManager = getDependency(IResourceManager);
         this.resourceManager.addEventListener(Event.CHANGE,this.onResourceManagerChange);
      }
      
      override protected function createChildren() : void
      {
         var _loc3_:AbilityButton = null;
         super.createChildren();
         var _loc1_:OverviewAbilitiesAndStatsAsset = new OverviewAbilitiesAndStatsAsset();
         this.abilityButtons = new Vector.<AbilityButton>(5,true);
         var _loc2_:uint = 0;
         while(_loc2_ < 5)
         {
            _loc3_ = new AbilityButton(this);
            _loc3_.setUseHandCursor(false);
            _loc3_.setButtonMode(false);
            setTimelineChildByName("overviewAbility" + _loc2_,_loc3_);
            this.abilityButtons[_loc2_] = _loc3_;
            _loc2_++;
         }
         this.attackBar = _loc1_.attackBar.create(this);
         this.attackBar.setTransformBehavior(new ScalingTransformBehavior());
         this.attackBar.setScaleX(0.01);
         this.attackIcon = _loc1_.attackIcon.create(this);
         assignToolTip(this.attackIcon,this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"attackPower"));
         assignToolTip(this.attackBar,this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"attackPower"));
         this.defenseBar = _loc1_.healthBar.create(this);
         this.defenseBar.setTransformBehavior(new ScalingTransformBehavior());
         this.defenseBar.setScaleX(0.01);
         this.healthIcon = _loc1_.healthIcon.create(this);
         assignToolTip(this.healthIcon,this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"defensePower"));
         assignToolTip(this.defenseBar,this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"defensePower"));
         this.abilityPowerBar = _loc1_.abilityPowerBar.create(this);
         this.abilityPowerBar.setTransformBehavior(new ScalingTransformBehavior());
         this.abilityPowerBar.setScaleX(0.01);
         this.abilityPowerIcon = _loc1_.abilityPowerIcon.create(this);
         assignToolTip(this.abilityPowerIcon,this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"abilityPower"));
         assignToolTip(this.abilityPowerBar,this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"abilityPower"));
         this.difficultyBar = _loc1_.difficultyBar.create(this);
         this.difficultyBar.setTransformBehavior(new ScalingTransformBehavior());
         this.difficultyBar.setScaleX(0.01);
         this.difficultyIcon = _loc1_.difficultyIcon.create(this);
         assignToolTip(this.difficultyIcon,this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"difficulty"));
         assignToolTip(this.difficultyBar,this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"difficulty"));
         this.tagsText = _loc1_.tagsText.create(this);
         this.tagsText.setHeight(40);
         this.abilitiesLabel = new Text(this);
         this.abilitiesLabel.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"overview.abilities"));
         setTimelineChild(_loc1_.abilitiesLabel,this.abilitiesLabel);
         this.statsLabel = new Text(this);
         this.statsLabel.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"overview.stats"));
         setTimelineChild(_loc1_.statsLabel,this.statsLabel);
         this.attributesLabel = new Text(this);
         this.attributesLabel.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"overview.attributes"));
         setTimelineChild(_loc1_.attributesLabel,this.attributesLabel);
         setAlpha(0);
         this.customToolTip = new DescriptiveToolTip(this);
      }
      
      public function setChampionInfo(param1:ChampionInfo) : void
      {
         var _loc2_:AbilityButton = null;
         var _loc3_:uint = 0;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:ChampionAbility = null;
         var _loc9_:DescriptiveToolTipModel = null;
         if(this._championInfo != null)
         {
            for each(_loc2_ in this.abilityButtons)
            {
               _loc2_.setModel(null);
               unassignToolTip(_loc2_);
            }
         }
         this._championInfo = param1;
         setAlpha(0);
         this.attackBar.setScaleX(0.01);
         this.defenseBar.setScaleX(0.01);
         this.abilityPowerBar.setScaleX(0.01);
         this.difficultyBar.setScaleX(0.01);
         if(this._championInfo != null)
         {
            _loc3_ = 0;
            while(_loc3_ < 5)
            {
               _loc8_ = this._championInfo.abilities[_loc3_];
               _loc2_ = this.abilityButtons[_loc3_];
               _loc2_.setModel(_loc8_);
               _loc9_ = new DescriptiveToolTipModel(_loc8_.name,"",_loc8_.cost,_loc8_.description);
               assignToolTip(_loc2_,_loc9_,new TweenedToolTipHandler(this.customToolTip,1,0));
               _loc3_++;
            }
            _loc4_ = 0.15;
            _loc5_ = this.useTransitions;
            TweenLite.to(getSetterProxy(),1.5 * _loc5_,{
               "alpha":1,
               "ease":Sine.easeOut
            });
            TweenLite.to(this.attackBar.getSetterProxy(),0.5 * _loc5_,{
               "scaleX":this._championInfo.ratingAttack / 10,
               "ease":Sine.easeOut,
               "delay":1
            });
            TweenLite.to(this.defenseBar.getSetterProxy(),0.5 * _loc5_,{
               "scaleX":this._championInfo.ratingDefense / 10,
               "ease":Sine.easeOut,
               "delay":1 + _loc4_
            });
            TweenLite.to(this.abilityPowerBar.getSetterProxy(),0.5 * _loc5_,{
               "scaleX":this._championInfo.ratingMagic / 10,
               "ease":Sine.easeOut,
               "delay":1 + _loc4_ * 2
            });
            TweenLite.to(this.difficultyBar.getSetterProxy(),0.5 * _loc5_,{
               "scaleX":this._championInfo.ratingDifficulty / 10,
               "ease":Sine.easeOut,
               "delay":1 + _loc4_ * 3
            });
            _loc6_ = this._championInfo.getTagsStr();
            if(this._championInfo.secondaryTags.length > 0)
            {
               _loc7_ = this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"overview.secondaryRoles",[this._championInfo.getSecondaryTagsStr()]);
            }
            else
            {
               _loc7_ = "";
            }
            this.tagsText.setText(_loc6_ + "\n" + _loc7_);
         }
         invalidateLayout();
      }
      
      private function get useTransitions() : int
      {
         return this.cdpContext.getConfig().useTransitions ? 1 : 0;
      }
      
      private function onResourceManagerChange(param1:Event) : void
      {
         unassignToolTip(this.attackBar);
         unassignToolTip(this.attackIcon);
         unassignToolTip(this.defenseBar);
         unassignToolTip(this.healthIcon);
         unassignToolTip(this.abilityPowerBar);
         unassignToolTip(this.abilityPowerIcon);
         assignToolTip(this.attackBar,this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"attackPower"));
         assignToolTip(this.attackIcon,this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"attackPower"));
         assignToolTip(this.defenseBar,this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"defensePower"));
         assignToolTip(this.healthIcon,this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"defensePower"));
         assignToolTip(this.abilityPowerIcon,this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"abilityPower"));
         assignToolTip(this.abilityPowerBar,this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"abilityPower"));
         assignToolTip(this.difficultyBar,this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"difficulty"));
         assignToolTip(this.difficultyIcon,this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"difficulty"));
         this.abilitiesLabel.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"overview.abilities"));
         this.statsLabel.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"overview.stats"));
         this.attributesLabel.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"overview.attributes"));
      }
      
      override public function destroy() : void
      {
         if(this.resourceManager)
         {
            this.resourceManager.removeEventListener(Event.CHANGE,this.onResourceManagerChange);
            this.resourceManager = null;
         }
         super.destroy();
      }
   }
}

