package com.riotgames.championdetails.abilities
{
   import blix.assets.proxy.ContentScroller;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.context.Context;
   import blix.util.keyboard.addKeyListener;
   import blix.util.string.padNumber;
   import com.riotgames.championdetails.IChampionDetailsContext;
   import com.riotgames.championdetails.IParallaxScreen;
   import com.riotgames.championdetails.ParallaxItem;
   import com.riotgames.championdetails.ScreenSize;
   import com.riotgames.championdetails.model.ChampionAbility;
   import com.riotgames.championdetails.model.ChampionInfo;
   import com.riotgames.common.fadeOut;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   
   public class AbilitiesScreen extends SpriteProxy implements IParallaxScreen
   {
      
      private static const ABILITY_TAUNT:String = "taunt";
      
      private static const ABILITY_JOKE:String = "joke";
      
      private static const ABILITY_DANCE:String = "dance";
      
      private static const ABILITY_LAUGH:String = "laugh";
      
      private var cdpContext:IChampionDetailsContext;
      
      private var _parallaxDescriptors:Vector.<ParallaxItem> = new Vector.<ParallaxItem>();
      
      private var _selectedAbility:ChampionAbility;
      
      private var _currentSecret:String;
      
      private var _championInfo:ChampionInfo;
      
      private var abilityTitle:TextFieldProxy;
      
      private var abilityDescription:TextFieldProxy;
      
      private var videoPlayer:AbilitiesVideoPlayer;
      
      private var abilityButtons:Vector.<AbilityButton>;
      
      private var _enabled:Boolean;
      
      public function AbilitiesScreen(param1:Context, param2:Sprite = null)
      {
         super(param1,param2);
         setOpaqueBackground(0);
         this.cdpContext = getFirstContext(IChampionDetailsContext);
         addKeyListener(this,this.keyDownHandler);
      }
      
      override protected function createChildren() : void
      {
         var _loc3_:AbilityButton = null;
         super.createChildren();
         var _loc1_:ContentScroller = new ContentScroller();
         this.abilityTitle = _loc1_.abilityTitle.create(this);
         this.abilityDescription = _loc1_.abilityDescription.create(this);
         this.abilityButtons = new Vector.<AbilityButton>(5,true);
         var _loc2_:uint = 0;
         while(_loc2_ < 5)
         {
            _loc3_ = new AbilityButton(this);
            setTimelineChildByName("ability" + _loc2_,_loc3_);
            _loc3_.addEventListener(MouseEvent.CLICK,this.abilityClickedHandler);
            this.abilityButtons[_loc2_] = _loc3_;
            _loc2_++;
         }
         this.videoPlayer = new AbilitiesVideoPlayer(this);
         this.videoPlayer.model.getIsPlayingChanged().add(this.trackVideoPlayingHandler);
         setTimelineChild(_loc1_.video,this.videoPlayer);
      }
      
      public function setChampionInfo(param1:ChampionInfo) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:AbilityButton = null;
         if(this._championInfo != null)
         {
            this.setSelectedAbility(null);
         }
         this._championInfo = param1;
         if(this._championInfo)
         {
            _loc2_ = 0;
            while(_loc2_ < 5)
            {
               _loc3_ = this.abilityButtons[_loc2_];
               _loc3_.setModel(this._championInfo.abilities[_loc2_]);
               _loc2_++;
            }
            this.setSelectedAbility(this._championInfo.abilities[1]);
         }
      }
      
      private function abilityClickedHandler(param1:MouseEvent) : void
      {
         this.setSelectedAbility((param1.currentTarget as AbilityButton).getModel());
      }
      
      public function getSelectedAbility(param1:int) : ChampionAbility
      {
         return this._selectedAbility;
      }
      
      public function setSelectedAbility(param1:ChampionAbility) : void
      {
         var _loc2_:AbilityButton = null;
         var _loc3_:AbilityButton = null;
         if(this._selectedAbility == param1)
         {
            return;
         }
         if(this._selectedAbility != null)
         {
            _loc2_ = this.abilityButtons[this._selectedAbility.rank - 1];
            _loc2_.setSelected(false);
         }
         this._selectedAbility = param1;
         if(this._selectedAbility != null)
         {
            _loc3_ = this.abilityButtons[this._selectedAbility.rank - 1];
            _loc3_.setSelected(true);
            if(this.cdpContext.getConfig().useTransitions)
            {
               fadeOut(this.abilityTitle.getAsset());
               fadeOut(this.abilityDescription.getAsset());
            }
            this.abilityTitle.setText(this._selectedAbility.name);
            this.abilityDescription.setHtmlText("<font face=\'ApplicationFont1\'>" + this._selectedAbility.description + "</font>");
            this.videoPlayer.model.setVideoUrl(this.cdpContext.getConfig().videosPath + padNumber(this._selectedAbility.championId,4) + "_" + padNumber(this._selectedAbility.rank,2) + ".mp4");
            this.videoPlayer.setStillImagePath(this.cdpContext.getConfig().videoStillsPath + padNumber(this._selectedAbility.championId,4) + "_" + padNumber(this._selectedAbility.rank,2) + ".jpg");
            this.cdpContext.trackEvent("Select Champion Ability","CDP_Champion" + this._championInfo.id + "_Ability" + this._selectedAbility.rank);
         }
      }
      
      public function selectSecretAbility(param1:String) : void
      {
         var _loc2_:AbilityButton = null;
         if(this._currentSecret == param1)
         {
            return;
         }
         if(this._selectedAbility != null)
         {
            _loc2_ = this.abilityButtons[this._selectedAbility.rank - 1];
            _loc2_.setSelected(false);
            if(this.cdpContext.getConfig().useTransitions)
            {
               fadeOut(this.abilityTitle.getAsset());
               fadeOut(this.abilityDescription.getAsset());
            }
         }
         this._selectedAbility = null;
         this.abilityTitle.setText(param1.charAt(0).toUpperCase() + param1.substr(1));
         this.abilityDescription.setText("");
         this.videoPlayer.model.setVideoUrl(this.cdpContext.getConfig().videosPath + padNumber(this._championInfo.id,4) + "_" + param1 + ".mp4");
         this.videoPlayer.model.play();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         return new Rectangle(0,0,ScreenSize.WIDTH,ScreenSize.HEIGHT);
      }
      
      private function keyDownHandler(param1:KeyboardEvent) : void
      {
         if(!this._enabled || this._championInfo == null)
         {
            return;
         }
         if(param1.ctrlKey)
         {
            switch(param1.keyCode)
            {
               case Keyboard.NUMBER_1:
                  this.selectSecretAbility(ABILITY_JOKE);
                  return;
               case Keyboard.NUMBER_2:
                  this.selectSecretAbility(ABILITY_TAUNT);
                  return;
               case Keyboard.NUMBER_3:
                  this.selectSecretAbility(ABILITY_DANCE);
                  return;
               case Keyboard.NUMBER_4:
                  this.selectSecretAbility(ABILITY_LAUGH);
                  return;
            }
         }
         switch(param1.keyCode)
         {
            case Keyboard.Q:
               this.setSelectedAbility(this._championInfo.abilities[1]);
               this.videoPlayer.model.play();
               break;
            case Keyboard.W:
               this.setSelectedAbility(this._championInfo.abilities[2]);
               this.videoPlayer.model.play();
               break;
            case Keyboard.E:
               this.setSelectedAbility(this._championInfo.abilities[3]);
               this.videoPlayer.model.play();
               break;
            case Keyboard.R:
               this.setSelectedAbility(this._championInfo.abilities[4]);
               this.videoPlayer.model.play();
               break;
            case Keyboard.SPACE:
               if(!this.videoPlayer.getDisabled())
               {
                  if(this.videoPlayer.model.getIsPlaying())
                  {
                     this.videoPlayer.model.pause();
                  }
                  else
                  {
                     this.videoPlayer.model.play();
                  }
               }
         }
      }
      
      public function getParallaxDescriptors() : Vector.<ParallaxItem>
      {
         return this._parallaxDescriptors;
      }
      
      public function getParallaxPosition() : Point
      {
         return new Point(0,ScreenSize.HEIGHT);
      }
      
      public function buildUp() : void
      {
         this._enabled = true;
      }
      
      public function tearDown() : void
      {
         this.videoPlayer.model.pause();
         this._enabled = false;
      }
      
      public function trackVideoPlayingHandler() : void
      {
      }
   }
}

