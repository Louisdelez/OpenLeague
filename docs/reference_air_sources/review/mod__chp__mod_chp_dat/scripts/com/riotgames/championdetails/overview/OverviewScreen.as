package com.riotgames.championdetails.overview
{
   import blix.assets.proxy.ContentScroller;
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.context.Context;
   import com.riotgames.championdetails.IChampionDetailsContext;
   import com.riotgames.championdetails.IParallaxScreen;
   import com.riotgames.championdetails.ParallaxItem;
   import com.riotgames.championdetails.ScreenSize;
   import com.riotgames.championdetails.model.ChampionInfo;
   import com.riotgames.championdetails.model.ChampionSkin;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class OverviewScreen extends SpriteProxy implements IParallaxScreen
   {
      
      private var cdpContext:IChampionDetailsContext;
      
      private var skinSelector:SkinSelector;
      
      private var _parallaxDescriptors:Vector.<ParallaxItem> = new Vector.<ParallaxItem>();
      
      private var overviewBackground:OverviewBackground;
      
      private var _championInfo:ChampionInfo;
      
      private var overviewAbilitiesAndStats:OverviewAbilitiesAndStats;
      
      private var nameText:TextFieldProxy;
      
      private var descriptionText:TextFieldProxy;
      
      public function OverviewScreen(param1:Context, param2:Sprite = null)
      {
         super(param1,param2);
         setOpaqueBackground(0);
         this.cdpContext = getFirstContext(IChampionDetailsContext);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:ContentScroller = new ContentScroller();
         this.skinSelector = new SkinSelector(this);
         setTimelineChild(_loc1_.skinSelector,this.skinSelector);
         this.addDepth(this.skinSelector,1.4);
         this.skinSelector.getSkinChanged().add(this.skinChangedHandler);
         this.overviewBackground = new OverviewBackground(this);
         setTimelineChild(_loc1_.overviewBackground,this.overviewBackground);
         this.addDepth(_loc1_.overviewBackground.create(this),0.7);
         this.overviewAbilitiesAndStats = new OverviewAbilitiesAndStats(this);
         setTimelineChild(_loc1_.overviewAbilitiesAndStats,this.overviewAbilitiesAndStats);
         this.nameText = _loc1_.nameText.create(this);
         this.descriptionText = _loc1_.descriptionText.create(this);
         this.addDepth(this.overviewAbilitiesAndStats,1.2);
      }
      
      protected function abilityClickedHandler(param1:MouseEvent) : void
      {
      }
      
      private function skinChangedHandler(param1:ChampionSkin) : void
      {
         if(param1 != null)
         {
            this.cdpContext.trackEvent("Select Skin","CDP_Champion" + this._championInfo.id + "_Skin" + param1.id);
         }
         this.overviewBackground.selectSkin(param1);
      }
      
      private function addDepth(param1:DisplayObjectProxy, param2:Number) : void
      {
         var _loc3_:ParallaxItem = new ParallaxItem(param1);
         _loc3_.setDepth(param2);
         this._parallaxDescriptors[this._parallaxDescriptors.length] = _loc3_;
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         return new Rectangle(0,0,ScreenSize.WIDTH,ScreenSize.HEIGHT);
      }
      
      public function getChampionInfo() : ChampionInfo
      {
         return this._championInfo;
      }
      
      public function setChampionInfo(param1:ChampionInfo) : void
      {
         if(this._championInfo != null)
         {
            this.nameText.setText("");
            this.descriptionText.setText("");
         }
         this._championInfo = param1;
         this.skinSelector.setChampionInfo(this._championInfo);
         this.overviewBackground.setChampionInfo(this._championInfo);
         this.overviewAbilitiesAndStats.setChampionInfo(this._championInfo);
         if(this._championInfo != null)
         {
            this.nameText.setText(this._championInfo.displayName);
            this.descriptionText.setText(this._championInfo.title);
         }
      }
      
      public function getParallaxPosition() : Point
      {
         return new Point(0,0);
      }
      
      public function getParallaxDescriptors() : Vector.<ParallaxItem>
      {
         return this._parallaxDescriptors;
      }
      
      public function buildUp() : void
      {
         this.skinSelector.setEnabled(true);
      }
      
      public function tearDown() : void
      {
         this.skinSelector.setEnabled(false);
      }
   }
}

