package com.riotgames.championdetails
{
   import blix.assets.proxy.MainAsset;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.button.LabelButtonX;
   import blix.components.loader.LoaderX;
   import blix.components.text.Text;
   import blix.components.tooltip.assignToolTip;
   import blix.components.tooltip.unassignToolTip;
   import blix.context.Context;
   import blix.signals.Signal;
   import blix.util.keyboard.addKeyListener;
   import blix.util.math.clamp;
   import com.greensock.TweenLite;
   import com.greensock.easing.Cubic;
   import com.riotgames.championdetails.abilities.AbilitiesScreen;
   import com.riotgames.championdetails.lore.LoreScreen;
   import com.riotgames.championdetails.model.ChampionInfo;
   import com.riotgames.championdetails.overview.OverviewScreen;
   import com.riotgames.championdetails.tips.TipsScreen;
   import com.riotgames.platform.common.provider.IStoreProvider;
   import com.riotgames.platform.common.provider.StoreProviderProxy;
   import com.riotgames.store.model.Catalog;
   import com.riotgames.store.model.CatalogResult;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.ui.Keyboard;
   import mx.resources.IResourceManager;
   
   public class ChampionDetails extends SpriteProxy implements IPurchaseContext
   {
      
      private static const CHAMPION_DETAILS_RESOURCE_ID:String = Main.CHAMPION_DETAILS_RESOURCE_ID;
      
      private var scrollAreaWidth:Number;
      
      private var scrollAreaHeight:Number;
      
      private var _horizontalScrollPosition:Number = 0;
      
      private var _verticalScrollPosition:Number = 0;
      
      public var purchaseScreen:PurchaseScreen;
      
      private var contentScroller:SpriteProxy;
      
      private var overviewScreen:OverviewScreen;
      
      private var loreScreen:LoreScreen;
      
      private var tipsScreen:TipsScreen;
      
      private var abilitiesScreen:AbilitiesScreen;
      
      private var screens:Vector.<IParallaxScreen> = new Vector.<IParallaxScreen>();
      
      private var _currentScreen:IParallaxScreen;
      
      private var _currentScreenChanged:Signal = new Signal();
      
      private var _currentScreenIndex:Number;
      
      private var titleText:TextFieldProxy;
      
      private var iconLoader:LoaderX;
      
      private var overviewButton:LabelButtonX;
      
      private var abilitiesButton:LabelButtonX;
      
      private var loreButton:LabelButtonX;
      
      private var tipsButton:LabelButtonX;
      
      private var unlockArea:UnlockArea;
      
      private var ownedClip:SpriteProxy;
      
      private var championOwnedText:Text;
      
      private var _catalog:Catalog;
      
      private var cdpContext:IChampionDetailsContext;
      
      private var _championInfo:ChampionInfo;
      
      private var selectedButton:LabelButtonX;
      
      public var errorDialog:ErrorDialog;
      
      private var _transitionsEnabled:Boolean = true;
      
      private var resourceManager:IResourceManager;
      
      public function ChampionDetails(param1:Context)
      {
         super(param1);
         this.cdpContext = getFirstContext(IChampionDetailsContext);
         this.cdpContext.getCatalogResultChanged().add(this.refreshCurrentCatalog);
         this.scrollAreaWidth = 1215;
         this.scrollAreaHeight = 717;
         setOpaqueBackground(0);
         var _loc2_:IStoreProvider = StoreProviderProxy.instance;
         _loc2_.getStoreUrlReadyChanged().add(this.refreshUnlockButton);
         this.cdpContext.getCatalogResultChanged().add(this.refreshUnlockButton);
         addKeyListener(this,this.keyDownHandler);
         this._currentScreenChanged.add(this.currentScreenChangedHandler);
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this.resourceManager = getDependency(IResourceManager);
         this.resourceManager.addEventListener(Event.CHANGE,this.onResourceManagerChange);
      }
      
      private function keyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc2_:int = 0;
         if(param1.keyCode == Keyboard.DOWN || param1.keyCode == Keyboard.PAGE_DOWN)
         {
            _loc2_ = 1;
         }
         else if(param1.keyCode == Keyboard.UP || param1.keyCode == Keyboard.PAGE_UP)
         {
            _loc2_ = -1;
         }
         else if(param1.keyCode == Keyboard.HOME)
         {
            _loc2_ = -100;
         }
         else
         {
            if(param1.keyCode != Keyboard.END)
            {
               return;
            }
            _loc2_ = 100;
         }
         var _loc3_:int = this.screens.indexOf(this._currentScreen);
         if(_loc3_ == -1)
         {
            return;
         }
         var _loc4_:int = int(clamp(_loc3_ + _loc2_,0,this.screens.length - 1));
         this.setCurrentScreen(this.screens[_loc4_]);
      }
      
      override protected function createChildren() : void
      {
         var _loc4_:IParallaxScreen = null;
         var _loc5_:ParallaxItem = null;
         super.createChildren();
         var _loc1_:MainAsset = new MainAsset();
         this.errorDialog = new ErrorDialog(this);
         setTimelineChild(_loc1_.errorDialog,this.errorDialog);
         this.contentScroller = _loc1_.contentScroller.create(this);
         this.contentScroller.setOpaqueBackground(0);
         var _loc2_:ButtonX = new ButtonX(this);
         _loc2_.addEventListener(MouseEvent.CLICK,this.closeClickHandler);
         setTimelineChild(_loc1_.closeButton,_loc2_);
         this.titleText = _loc1_.sideBar.titleText.create(this);
         this.overviewButton = new LabelButtonX(this);
         this.overviewButton.addEventListener(MouseEvent.CLICK,this.overviewClickedHandler);
         this.overviewButton.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"menu.overview"));
         setTimelineChild(_loc1_.sideBar.overviewButton,this.overviewButton);
         this.loreButton = new LabelButtonX(this);
         this.loreButton.addEventListener(MouseEvent.CLICK,this.loreClickedHandler);
         this.loreButton.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"menu.lore"));
         setTimelineChild(_loc1_.sideBar.loreButton,this.loreButton);
         this.tipsButton = new LabelButtonX(this);
         this.tipsButton.addEventListener(MouseEvent.CLICK,this.tipsClickedHandler);
         this.tipsButton.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"menu.tips"));
         setTimelineChild(_loc1_.sideBar.tipsButton,this.tipsButton);
         this.abilitiesButton = new LabelButtonX(this);
         this.abilitiesButton.addEventListener(MouseEvent.CLICK,this.abilitiesClickedHandler);
         this.abilitiesButton.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"menu.abilities"));
         setTimelineChild(_loc1_.sideBar.abilitiesButton,this.abilitiesButton);
         this.overviewScreen = new OverviewScreen(this);
         setTimelineChild(_loc1_.contentScroller,this.overviewScreen);
         this.screens[this.screens.length] = this.overviewScreen;
         this.abilitiesScreen = new AbilitiesScreen(this);
         setTimelineChild(_loc1_.contentScroller,this.abilitiesScreen);
         this.screens[this.screens.length] = this.abilitiesScreen;
         this.loreScreen = new LoreScreen(this);
         setTimelineChild(_loc1_.contentScroller,this.loreScreen);
         this.screens[this.screens.length] = this.loreScreen;
         this.tipsScreen = new TipsScreen(this);
         setTimelineChild(_loc1_.contentScroller,this.tipsScreen);
         this.screens[this.screens.length] = this.tipsScreen;
         var _loc3_:SpriteProxy = _loc1_.sideBar.iconHolder.create(this);
         this.iconLoader = new LoaderX(this);
         _loc3_.addChild(this.iconLoader);
         this.ownedClip = _loc1_.ownedClip.create(this);
         this.ownedClip.setVisible(false);
         this.championOwnedText = new Text(this);
         setTimelineChild(_loc1_.ownedClip.championOwned,this.championOwnedText);
         this.championOwnedText.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"championOwned"));
         this.unlockArea = new UnlockArea(this);
         this.unlockArea.unlockButton.addEventListener(MouseEvent.CLICK,this.unlockClickHandler);
         this.unlockArea.setVisible(false);
         setTimelineChild(_loc1_.unlockArea,this.unlockArea);
         this.purchaseScreen = new PurchaseScreen(this);
         setTimelineChild(_loc1_.purchaseScreen,this.purchaseScreen);
         for each(_loc4_ in this.screens)
         {
            for each(_loc5_ in _loc4_.getParallaxDescriptors())
            {
               _loc5_.targetCoordSpace = this.contentScroller;
            }
         }
      }
      
      private function closeClickHandler(param1:MouseEvent) : void
      {
         this.cdpContext.close();
      }
      
      public function getChampionInfo() : ChampionInfo
      {
         return this._championInfo;
      }
      
      public function setChampionInfo(param1:ChampionInfo) : void
      {
         var _loc2_:IChampionDetailsContext = null;
         var _loc3_:String = null;
         if(param1 == this._championInfo)
         {
            return;
         }
         this.verticalScrollPosition = 0;
         if(this._championInfo != null)
         {
            this.iconLoader.unload();
            this.titleText.setText("");
         }
         this._championInfo = param1;
         this.overviewScreen.setChampionInfo(this._championInfo);
         this.loreScreen.setChampionInfo(this._championInfo);
         this.abilitiesScreen.setChampionInfo(this._championInfo);
         this.tipsScreen.setModel(this._championInfo);
         this._transitionsEnabled = false;
         this.setCurrentScreen(this.overviewScreen);
         this._transitionsEnabled = true;
         if(this._championInfo != null)
         {
            this.titleText.setText(this._championInfo.displayName);
            _loc2_ = getFirstContext(IChampionDetailsContext);
            _loc3_ = _loc2_.getConfig().championAssetsPath + this._championInfo.iconPath;
            this.iconLoader.load(new URLRequest(_loc3_));
            this.refreshCurrentCatalog();
         }
      }
      
      private function refreshCurrentCatalog() : void
      {
         if(this._championInfo == null)
         {
            return;
         }
         var _loc1_:CatalogResult = this.cdpContext.getCatalogResult();
         if(_loc1_ != null)
         {
            this.setCatalog(_loc1_.getCatalogByItemId("champions_" + this._championInfo.id));
         }
      }
      
      public function setCatalog(param1:Catalog) : void
      {
         if(this._catalog == param1)
         {
            return;
         }
         this._catalog = param1;
         this.unlockArea.setCatalog(this._catalog);
         this.refreshUnlockButton();
         this.purchaseScreen.hide();
         this.errorDialog.close();
      }
      
      public function refreshCatalogDisplay() : void
      {
         this.refreshUnlockButton();
      }
      
      private function refreshUnlockButton() : void
      {
         var _loc2_:Boolean = false;
         var _loc1_:IStoreProvider = StoreProviderProxy.instance;
         this.ownedClip.setVisible(false);
         this.unlockArea.setVisible(false);
         this.unlockArea.unlockButton.setEnabled(false);
         unassignToolTip(this.unlockArea);
         if(this._catalog != null && this._catalog.item != null && Boolean(this._catalog.item.active))
         {
            _loc2_ = this._catalog.item.isOwned == true;
            this.ownedClip.setVisible(_loc2_);
            this.unlockArea.setVisible(!_loc2_ && this.cdpContext.getConfig().entryPoint != ChampionDetailEntryPointsEnum.CHAMPION_SELECT);
            if(_loc1_.getIsStoreAvailable())
            {
               this.unlockArea.unlockButton.setEnabled(true);
               unassignToolTip(this.unlockArea);
            }
            else
            {
               assignToolTip(this.unlockArea,this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"storeIsUnavailable"));
            }
         }
         else if(!_loc1_.getIsStoreAvailable())
         {
            this.unlockArea.setVisible(true);
            assignToolTip(this.unlockArea,this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"storeIsUnavailable"));
         }
         else
         {
            this.unlockArea.setVisible(true);
            assignToolTip(this.unlockArea,this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"skinSelector.unavailable"));
         }
      }
      
      private function overviewClickedHandler(param1:MouseEvent) : void
      {
         if(this._championInfo == null)
         {
            return;
         }
         this.cdpContext.trackEvent("PageView CDP Overview Page","CDP_Champion" + this._championInfo.id.toString() + "_Overview");
         this.setCurrentScreen(this.overviewScreen);
      }
      
      private function abilitiesClickedHandler(param1:MouseEvent) : void
      {
         if(this._championInfo == null)
         {
            return;
         }
         this.cdpContext.trackEvent("PageView CDP Abilities Page","CDP_Champion" + this._championInfo.id.toString() + "_Abilities");
         this.setCurrentScreen(this.abilitiesScreen);
      }
      
      private function loreClickedHandler(param1:MouseEvent) : void
      {
         if(this._championInfo == null)
         {
            return;
         }
         this.cdpContext.trackEvent("PageView CDP Lore Page","CDP_Champion" + this._championInfo.id.toString() + "_Lore");
         this.setCurrentScreen(this.loreScreen);
      }
      
      private function tipsClickedHandler(param1:MouseEvent) : void
      {
         if(this._championInfo == null)
         {
            return;
         }
         this.cdpContext.trackEvent("PageView CDP Tips Page","CDP_Champion" + this._championInfo.id.toString() + "_Tips");
         this.setCurrentScreen(this.tipsScreen);
      }
      
      private function setCurrentScreen(param1:IParallaxScreen) : void
      {
         if(this._currentScreen == param1)
         {
            return;
         }
         if(this._currentScreen != null)
         {
            this._currentScreen.tearDown();
            this._currentScreenIndex = -1;
         }
         this._currentScreen = param1;
         if(this.selectedButton != null)
         {
            this.selectedButton.setSelected(false);
            this.selectedButton = null;
         }
         switch(param1)
         {
            case this.overviewScreen:
               this.selectedButton = this.overviewButton;
               break;
            case this.abilitiesScreen:
               this.selectedButton = this.abilitiesButton;
               break;
            case this.loreScreen:
               this.selectedButton = this.loreButton;
               break;
            case this.tipsScreen:
               this.selectedButton = this.tipsButton;
         }
         if(this.selectedButton != null)
         {
            this.selectedButton.setSelected(true);
         }
         if(this._currentScreen != null)
         {
            this._currentScreenIndex = this.screens.indexOf(this._currentScreen);
         }
         this._currentScreenChanged.dispatch();
      }
      
      private function currentScreenChangedHandler() : void
      {
         TweenLite.killTweensOf(this);
         var _loc1_:Number = this._currentScreen.getParallaxPosition().y;
         if(_loc1_ != this.verticalScrollPosition)
         {
            TweenLite.to(this,1 * this.useTransitions,{
               "verticalScrollPosition":_loc1_,
               "ease":Cubic.easeInOut,
               "onComplete":this.scrollCompleteHandler
            });
         }
         else
         {
            this.scrollCompleteHandler();
         }
      }
      
      private function scrollCompleteHandler() : void
      {
         this._currentScreen.buildUp();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc5_:IParallaxScreen = null;
         var _loc6_:Point = null;
         var _loc7_:ParallaxItem = null;
         this.contentScroller.setScrollRect(new Rectangle(this._horizontalScrollPosition,this._verticalScrollPosition,this.scrollAreaWidth,this.scrollAreaHeight));
         var _loc3_:uint = Math.min(this.screens.length,this._currentScreenIndex + 1);
         var _loc4_:uint = Math.max(0,this._currentScreenIndex - 1);
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this.screens[_loc4_];
            _loc6_ = new Point(-this._horizontalScrollPosition,-this._verticalScrollPosition + _loc4_ * this.scrollAreaHeight);
            for each(_loc7_ in _loc5_.getParallaxDescriptors())
            {
               _loc7_.shift(_loc6_);
            }
            _loc4_++;
         }
         return new Rectangle(0,0,this.scrollAreaWidth,this.scrollAreaHeight);
      }
      
      public function get horizontalScrollPosition() : Number
      {
         return this._horizontalScrollPosition;
      }
      
      public function set horizontalScrollPosition(param1:Number) : void
      {
         this._horizontalScrollPosition = param1;
         layoutIsValidFlag = false;
         validate();
      }
      
      public function get verticalScrollPosition() : Number
      {
         return this._verticalScrollPosition;
      }
      
      public function set verticalScrollPosition(param1:Number) : void
      {
         this._verticalScrollPosition = param1;
         layoutIsValidFlag = false;
         validate();
      }
      
      private function unlockClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:IChampionDetailsContext = null;
         var _loc3_:URLRequest = null;
         if(this._championInfo != null)
         {
            _loc2_ = getFirstContext(IChampionDetailsContext);
            _loc2_.trackEvent("Click CDP Unlock Champion","CDP_Champion" + this._championInfo.id + "_Unlock");
            _loc3_ = new URLRequest(_loc2_.getConfig().championAssetsPath + this._championInfo.portraitPath);
            this.openPurchaseScreen(this._catalog,_loc3_);
         }
      }
      
      public function openPurchaseScreen(param1:Catalog, param2:URLRequest) : void
      {
         if(param1 != null && param2 != null)
         {
            this.purchaseScreen.setCatalog(param1);
            this.purchaseScreen.setImage(param2);
            this.purchaseScreen.show();
         }
      }
      
      private function get useTransitions() : int
      {
         return this._transitionsEnabled && this.cdpContext.getConfig().useTransitions ? 1 : 0;
      }
      
      private function onResourceManagerChange(param1:Event) : void
      {
         this.overviewButton.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"menu.overview"));
         this.loreButton.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"menu.lore"));
         this.tipsButton.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"menu.tips"));
         this.abilitiesButton.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"menu.abilities"));
         this.championOwnedText.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"championOwned"));
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

