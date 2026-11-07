package com.riotgames.championdetails.tips
{
   import blix.assets.proxy.ContentScroller;
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.text.Text;
   import blix.context.Context;
   import blix.util.string.strReplace;
   import com.riotgames.championdetails.IChampionDetailsContext;
   import com.riotgames.championdetails.IParallaxScreen;
   import com.riotgames.championdetails.Main;
   import com.riotgames.championdetails.ParallaxItem;
   import com.riotgames.championdetails.ScreenSize;
   import com.riotgames.championdetails.model.ChampionInfo;
   import com.riotgames.platform.gameclient.configurations.PlayerInventoryConfig;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import mx.resources.IResourceManager;
   
   public class TipsScreen extends SpriteProxy implements IParallaxScreen
   {
      
      private static const CHAMPION_DETAILS_RESOURCE_ID:String = Main.CHAMPION_DETAILS_RESOURCE_ID;
      
      private var _parallaxDescriptors:Vector.<ParallaxItem> = new Vector.<ParallaxItem>();
      
      private var tipsTitle:Text;
      
      private var tipsContent:Text;
      
      private var opposingTipsTitle:Text;
      
      private var opposingTipsContent:Text;
      
      private var recommendedItemsTitle:Text;
      
      private var classicItemsPane:SpriteProxy;
      
      private var classicItemsTitle:Text;
      
      private var dominionItemsPane:SpriteProxy;
      
      private var dominionItemsTitle:Text;
      
      private var classicItemButtons:Vector.<ItemButton>;
      
      private var dominionItemButtons:Vector.<ItemButton>;
      
      private var cdpContext:IChampionDetailsContext;
      
      private var _model:ChampionInfo;
      
      private var resourceManager:IResourceManager;
      
      public function TipsScreen(param1:Context, param2:Sprite = null)
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
         var _loc3_:ItemButton = null;
         var _loc4_:uint = 0;
         super.createChildren();
         var _loc1_:ContentScroller = new ContentScroller();
         var _loc2_:SpriteProxy = _loc1_.tipsPane.create(this);
         this.addDepth(_loc2_,1.6);
         this.tipsTitle = new Text(this);
         setTimelineChild(_loc1_.tipsPane.title,this.tipsTitle);
         this.tipsContent = new Text(this);
         setTimelineChild(_loc1_.tipsPane.content,this.tipsContent);
         this.opposingTipsTitle = new Text(this);
         setTimelineChild(_loc1_.tipsPane.opposingTitle,this.opposingTipsTitle);
         this.opposingTipsContent = new Text(this);
         setTimelineChild(_loc1_.tipsPane.opposingContent,this.opposingTipsContent);
         this.recommendedItemsTitle = new Text(this);
         setTimelineChild(_loc1_.recommendedItemTitle,this.recommendedItemsTitle);
         this.addDepth(this.recommendedItemsTitle,1.3);
         this.classicItemsPane = _loc1_.classicItemsPane.create(this);
         this.addDepth(this.classicItemsPane,1.5);
         this.classicItemsTitle = new Text(this);
         setTimelineChild(_loc1_.classicItemsPane.title,this.classicItemsTitle);
         this.dominionItemsPane = _loc1_.dominionItemsPane.create(this);
         this.addDepth(this.dominionItemsPane,1.5);
         this.dominionItemsTitle = new Text(this);
         setTimelineChild(_loc1_.dominionItemsPane.title,this.dominionItemsTitle);
         this.classicItemButtons = new Vector.<ItemButton>(7,true);
         var _loc5_:int = int(DynamicClientConfigManager.getConfiguration(PlayerInventoryConfig.NAMESPACE,PlayerInventoryConfig.NUM_ITEMS,PlayerInventoryConfig.numItemsDefault).getInt());
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc3_ = new ItemButton(this);
            setTimelineChildByName("classicItemsPane.item" + _loc4_,_loc3_);
            this.classicItemButtons[_loc4_] = _loc3_;
            _loc4_++;
         }
         this.dominionItemButtons = new Vector.<ItemButton>(7,true);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc3_ = new ItemButton(this);
            setTimelineChildByName("dominionItemsPane.item" + _loc4_,_loc3_);
            this.dominionItemButtons[_loc4_] = _loc3_;
            _loc4_++;
         }
      }
      
      public function setModel(param1:ChampionInfo) : void
      {
         var textDecorators:Vector.<Function> = null;
         var model:ChampionInfo = param1;
         if(this._model == model)
         {
            return;
         }
         if(this._model != null)
         {
            this.tipsTitle.setText("");
            this.tipsContent.setText("");
            this.opposingTipsTitle.setText("");
            this.opposingTipsContent.setText("");
         }
         this._model = model;
         if(this._model != null)
         {
            this.tipsTitle.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"tipsScreen.tipsTitle"));
            textDecorators = new Vector.<Function>(1,true);
            textDecorators[0] = function(param1:String):String
            {
               return strReplace(param1,"{0}",_model.displayName);
            };
            this.tipsTitle.setTextDecorators(textDecorators);
            this.tipsContent.setHtmlText("<font face=\'ApplicationFont1\'>" + this.convertAsterisksToLi(this._model.tips) + "</font>");
            this.opposingTipsTitle.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"tipsScreen.opposingTipsTitle"));
            this.opposingTipsTitle.setTextDecorators(textDecorators);
            this.opposingTipsContent.setHtmlText("<font face=\'ApplicationFont1\'>" + this.convertAsterisksToLi(this._model.opponentTips) + "</font>");
            this.recommendedItemsTitle.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"tipsScreen.recommendedItemsTitle"));
            this.classicItemsTitle.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"tipsScreen.classicModeTitle"));
            this.dominionItemsTitle.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"tipsScreen.dominionModeTitle"));
         }
      }
      
      private function addDepth(param1:DisplayObjectProxy, param2:Number) : void
      {
         var _loc3_:ParallaxItem = new ParallaxItem(param1);
         _loc3_.setDepth(param2);
         this._parallaxDescriptors[this._parallaxDescriptors.length] = _loc3_;
      }
      
      public function getParallaxPosition() : Point
      {
         return new Point(0,ScreenSize.HEIGHT * 3);
      }
      
      public function getParallaxDescriptors() : Vector.<ParallaxItem>
      {
         return this._parallaxDescriptors;
      }
      
      public function buildUp() : void
      {
      }
      
      public function tearDown() : void
      {
      }
      
      protected function convertAsterisksToLi(param1:String) : String
      {
         if(param1)
         {
            param1 = param1.replace("*","<textformat blockindent=\'-15\'><li>") + "</li></textformat>";
            param1 = param1.replace(/\*/g,"</li><textformat leading=\'-5\'><font size=\'1\'>&nbsp;</font></textformat><li>");
         }
         return param1;
      }
      
      private function onResourceManagerChange(param1:Event) : void
      {
         if(this._model)
         {
            this.tipsTitle.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"tipsScreen.tipsTitle"));
            this.opposingTipsTitle.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"tipsScreen.opposingTipsTitle"));
            this.recommendedItemsTitle.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"tipsScreen.recommendedItemsTitle"));
            this.classicItemsTitle.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"tipsScreen.classicModeTitle"));
            this.dominionItemsTitle.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"tipsScreen.dominionModeTitle"));
         }
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

