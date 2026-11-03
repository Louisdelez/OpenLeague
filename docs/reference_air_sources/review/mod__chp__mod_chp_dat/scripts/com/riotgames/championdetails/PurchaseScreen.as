package com.riotgames.championdetails
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.purchaseScreen.PurchaseScreenAsset;
   import blix.components.button.ButtonX;
   import blix.components.button.LabelButtonX;
   import blix.components.text.Text;
   import blix.components.timeline.StatefulView;
   import blix.context.ApplicationContext;
   import blix.context.Context;
   import blix.layout.LayoutContainer;
   import blix.layout.algorithms.HorizontalLayout;
   import blix.layout.bindLayoutContainerToSizer;
   import blix.layout.vo.HorizontalAlign;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.greensock.TweenLite;
   import com.greensock.easing.Sine;
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.provider.IInventory;
   import com.riotgames.platform.common.provider.IInventoryProvider;
   import com.riotgames.platform.common.provider.IStoreProvider;
   import com.riotgames.platform.common.provider.StoreProviderProxy;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.store.model.Catalog;
   import com.riotgames.store.model.CatalogResult;
   import com.riotgames.store.model.CurrencyTypesEnum;
   import com.riotgames.store.model.InventoryTypesEnum;
   import com.riotgames.store.model.PurchaseItemParams;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.text.TextFormat;
   import mx.resources.IResourceManager;
   
   public class PurchaseScreen extends StatefulView
   {
      
      private static const CHAMPION_DETAILS_RESOURCE_ID:String = Main.CHAMPION_DETAILS_RESOURCE_ID;
      
      private var _purchaseComplete:Signal = new Signal();
      
      private var _catalog:Catalog;
      
      private var itemCard:ItemCard;
      
      private var currentRpText:Text;
      
      private var currentIpText:Text;
      
      private var rpCostText:Text;
      
      private var ipCostText:Text;
      
      private var rpBalanceText:Text;
      
      private var ipBalanceText:Text;
      
      private var isBusy:Boolean;
      
      private var purchaseItemTitle:Text;
      
      private var unlockWithRpLabel:Text;
      
      private var unlockWithIpLabel:Text;
      
      private var rpCostLabel:Text;
      
      private var ipCostLabel:Text;
      
      private var rpBalanceLabelText:Text;
      
      private var ipBalanceLabelText:Text;
      
      private var currentRpLabel:Text;
      
      private var currentIpLabel:Text;
      
      private var cdpContext:IChampionDetailsContext;
      
      private var catalogResult:CatalogResult;
      
      private var currencyType:String;
      
      private var unlockWithRpButton:LabelButtonX;
      
      private var unlockWithIpButton:LabelButtonX;
      
      private var ipPurchase:StatefulView;
      
      private var rpPurchase:StatefulView;
      
      private var purchaseCardsLayout:LayoutContainer;
      
      private var purchaseCardsSizer:SpriteProxy;
      
      private var purchaseRpButton:LabelButtonX;
      
      private var purchaseItemParams:PurchaseItemParams;
      
      private var purchasingLabel:Text;
      
      private var confirmTitleText:Text;
      
      private var confirmContentText:Text;
      
      private var confirmDoneButton:LabelButtonX;
      
      private var inventory:IInventory;
      
      private var resourceManager:IResourceManager;
      
      public function PurchaseScreen(param1:Context)
      {
         super(param1);
         ProviderLookup.getProvider(IInventoryProvider,this.onInventoryProvider);
         setAlpha(0);
         setVisible(false);
         this.cdpContext = getFirstContext(IChampionDetailsContext);
         this.cdpContext.getCatalogResultChanged().add(this.catalogResultChangedHandler);
         this.catalogResultChangedHandler();
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this.resourceManager = getDependency(IResourceManager);
         this.resourceManager.addEventListener(Event.CHANGE,this.onResourceManagerChange);
      }
      
      private function onInventoryProvider(param1:IInventoryProvider) : void
      {
         this.inventory = param1.getInventory();
         this.inventory.addEventListener("riotPointsChanged",this.refreshTotals);
         this.inventory.addEventListener("influencePointsChanged",this.refreshTotals);
         this.refreshTotals();
      }
      
      override public function getTransitionsEnabled() : Boolean
      {
         return this.cdpContext.getConfig().useTransitions;
      }
      
      private function catalogResultChangedHandler() : void
      {
         this.catalogResult = this.cdpContext.getCatalogResult();
         if(this.catalogResult != null)
         {
            this.refreshTotals();
         }
         this.refreshButtonsEnabled();
      }
      
      public function getPurchaseComplete() : ISignal
      {
         return this._purchaseComplete;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:PurchaseScreenAsset = new PurchaseScreenAsset();
         this.purchaseItemTitle = new Text(this);
         this.purchaseItemTitle.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseScreen.purchaseItemTitle"));
         setTimelineChild(_loc1_.purchaseItemTitle.textField,this.purchaseItemTitle);
         this.itemCard = new ItemCard(this);
         setTimelineChild(_loc1_.itemCard,this.itemCard);
         this.currentRpText = new Text(this);
         setTimelineChild(_loc1_.purchaseMathHolder.rpPurchase.currentText,this.currentRpText);
         this.currentIpText = new Text(this);
         setTimelineChild(_loc1_.purchaseMathHolder.ipPurchase.currentText,this.currentIpText);
         this.rpCostText = new Text(this);
         setTimelineChild(_loc1_.purchaseMathHolder.rpPurchase.costText,this.rpCostText);
         this.ipCostText = new Text(this);
         setTimelineChild(_loc1_.purchaseMathHolder.ipPurchase.costText,this.ipCostText);
         this.unlockWithRpLabel = new Text(this);
         this.unlockWithRpLabel.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseScreen.unlockWithRpLabel"));
         setTimelineChild(_loc1_.purchaseMathHolder.rpPurchase.unlockWithLabel,this.unlockWithRpLabel);
         this.unlockWithIpLabel = new Text(this);
         this.unlockWithIpLabel.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseScreen.unlockWithIpLabel"));
         setTimelineChild(_loc1_.purchaseMathHolder.ipPurchase.unlockWithLabel,this.unlockWithIpLabel);
         this.rpCostLabel = new Text(this);
         this.rpCostLabel.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseScreen.costLabel"));
         setTimelineChild(_loc1_.purchaseMathHolder.rpPurchase.costLabelText,this.rpCostLabel);
         this.ipCostLabel = new Text(this);
         this.ipCostLabel.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseScreen.costLabel"));
         setTimelineChild(_loc1_.purchaseMathHolder.ipPurchase.costLabelText,this.ipCostLabel);
         this.unlockWithRpButton = new LabelButtonX(this);
         this.unlockWithRpButton.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseScreen.unlock"));
         this.unlockWithRpButton.addEventListener(MouseEvent.CLICK,this.unlockWithRpButtonHandler);
         setTimelineChild(_loc1_.purchaseMathHolder.rpPurchase.unlockWithButton,this.unlockWithRpButton);
         this.unlockWithIpButton = new LabelButtonX(this);
         this.unlockWithIpButton.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseScreen.unlock"));
         this.unlockWithIpButton.addEventListener(MouseEvent.CLICK,this.unlockWithIpButtonHandler);
         setTimelineChild(_loc1_.purchaseMathHolder.ipPurchase.unlockWithButton,this.unlockWithIpButton);
         this.purchaseRpButton = new LabelButtonX(this);
         this.purchaseRpButton.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseScreen.purchaseRP"));
         this.purchaseRpButton.addEventListener(MouseEvent.CLICK,this.purchaseRpButtonHandler);
         setTimelineChild(_loc1_.purchaseRpButton,this.purchaseRpButton);
         this.rpBalanceLabelText = new Text(this);
         this.rpBalanceLabelText.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseScreen.balance"));
         setTimelineChild(_loc1_.purchaseMathHolder.rpPurchase.balanceLabelText,this.rpBalanceLabelText);
         this.rpBalanceText = new Text(this);
         setTimelineChild(_loc1_.purchaseMathHolder.rpPurchase.balanceText,this.rpBalanceText);
         this.ipBalanceLabelText = new Text(this);
         this.ipBalanceLabelText.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseScreen.balance"));
         setTimelineChild(_loc1_.purchaseMathHolder.ipPurchase.balanceLabelText,this.ipBalanceLabelText);
         this.ipBalanceText = new Text(this);
         setTimelineChild(_loc1_.purchaseMathHolder.ipPurchase.balanceText,this.ipBalanceText);
         this.currentRpLabel = new Text(this);
         this.currentRpLabel.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseScreen.currentRP"));
         setTimelineChild(_loc1_.purchaseMathHolder.rpPurchase.currentLabelText,this.currentRpLabel);
         this.currentIpLabel = new Text(this);
         this.currentIpLabel.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseScreen.currentIP"));
         setTimelineChild(_loc1_.purchaseMathHolder.ipPurchase.currentLabelText,this.currentIpLabel);
         var _loc2_:ButtonX = new ButtonX(this);
         _loc2_.addEventListener(MouseEvent.CLICK,this.closeClickHandler);
         setTimelineChild(_loc1_.closeButton,_loc2_);
         var _loc3_:SpriteProxy = _loc1_.modalBlock.create(this);
         _loc3_.addEventListener(MouseEvent.CLICK,this.closeClickHandler);
         this.purchaseCardsSizer = _loc1_.purchaseMathHolder.purchaseCardsSizer.create(this);
         this.rpPurchase = new StatefulView(this);
         this.rpPurchase.setCurrentState("rp");
         setTimelineChild(_loc1_.purchaseMathHolder.rpPurchase,this.rpPurchase);
         this.ipPurchase = new StatefulView(this);
         this.ipPurchase.setCurrentState("ip");
         setTimelineChild(_loc1_.purchaseMathHolder.ipPurchase,this.ipPurchase);
         this.purchaseCardsLayout = new LayoutContainer(this);
         bindLayoutContainerToSizer(this.purchaseCardsLayout,this.purchaseCardsSizer);
         var _loc4_:HorizontalLayout = new HorizontalLayout();
         _loc4_.setHorizontalAlign(HorizontalAlign.CENTER);
         _loc4_.setGap(75);
         this.purchaseCardsLayout.setLayoutAlgorithm(_loc4_);
         this.purchaseCardsLayout.addElement(this.rpPurchase);
         this.purchaseCardsLayout.addElement(this.ipPurchase);
         this.purchasingLabel = new Text(this);
         this.purchasingLabel.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseScreen.unlocking"));
         setTimelineChild(_loc1_.purchaseProcessHolder.label,this.purchasingLabel);
         this.confirmTitleText = new Text(this);
         setTimelineChild(_loc1_.confirmPanel.confirmTitle,this.confirmTitleText);
         this.confirmContentText = new Text(this);
         setTimelineChild(_loc1_.confirmPanel.confirmContent,this.confirmContentText);
         this.confirmDoneButton = new LabelButtonX(this);
         setTimelineChild(_loc1_.doneButton,this.confirmDoneButton);
         this.confirmDoneButton.addEventListener(MouseEvent.CLICK,this.closeClickHandler);
         this.confirmDoneButton.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseConfirm.done"));
      }
      
      override public function setCurrentState(param1:String) : void
      {
         super.setCurrentState(param1);
         this.refreshButtonsEnabled();
      }
      
      private function unlockWithRpButtonHandler(param1:MouseEvent) : void
      {
         this.unlock(CurrencyTypesEnum.RP);
      }
      
      private function unlockWithIpButtonHandler(param1:MouseEvent) : void
      {
         this.unlock(CurrencyTypesEnum.IP);
      }
      
      private function purchaseRpButtonHandler(param1:MouseEvent) : void
      {
         var _loc2_:ApplicationContext = getFirstContext(ApplicationContext);
         this.cdpContext.trackEvent("Click Purchase RP","CDP_Item" + this._catalog.item.id + "PurchaseScreen_ PurchaseRP");
         var _loc3_:IStoreProvider = StoreProviderProxy.instance;
         _loc3_.getStoreUrlReadyChanged().add(this.storeUrlReadyChangedHandler);
         _loc3_.refreshStoreUrl();
      }
      
      private function storeUrlReadyChangedHandler() : void
      {
         var _loc1_:IStoreProvider = StoreProviderProxy.instance;
         var _loc2_:String = _loc1_.getCurrentStoreUrl("store/points/purchase");
         _logger.logInfo("Opening purchase RP URL: " + _loc2_);
         if(AppConfig.instance.internalBrowserAction != null)
         {
            AppConfig.instance.internalBrowserAction.addMaxAndCenter(_loc2_,false,["paypal.com"]);
         }
      }
      
      private function unlock(param1:String) : void
      {
         if(this.isBusy)
         {
            return;
         }
         this.setCurrentState("purchasing");
         var _loc2_:IChampionDetailsContext = getFirstContext(IChampionDetailsContext);
         _loc2_.trackEvent("Click Purchase Flow Unlock " + param1,"CDP_PurchaseFlow" + param1 + "_Item" + this._catalog.item.id);
         this.isBusy = true;
         this.currencyType = param1;
         _logger.logInfo("Unlock with ip pressed");
         this.purchaseItemParams = new PurchaseItemParams();
         this.purchaseItemParams.currencyType = param1;
         this.purchaseItemParams.catalog = this._catalog;
         _loc2_.getServices().storeCatalogDao.purchaseItem(this.purchaseItemParams,this.purchaseItemSuccessHandler,this.purchaseItemFailedHandler);
      }
      
      private function closeClickHandler(param1:MouseEvent) : void
      {
         this.cdpContext.trackEvent("Close Purchase Screen","CDP_PurchaseScreen_Item" + this._catalog.item.id + "_CloseButton");
         this.hide();
      }
      
      private function purchaseItemFailedHandler(param1:Error) : void
      {
         this.cdpContext.displayUserError(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseScreen.failure"));
         this.setCurrentState("purchase");
         this.isBusy = false;
         _logger.logWarn(param1.message);
      }
      
      private function purchaseItemSuccessHandler(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Catalog = null;
         this.isBusy = false;
         this._catalog.item.isOwned = true;
         if(this._catalog.item.inventoryType == InventoryTypesEnum.CHAMPION)
         {
            for each(_loc3_ in this.catalogResult.getSkinsForChampion(this._catalog))
            {
               _loc3_.item.championOwned = true;
            }
         }
         if(this.currencyType == CurrencyTypesEnum.IP)
         {
            this.inventory.influencePoints -= this._catalog.item.ipCost;
            _loc2_ = int(this._catalog.item.ipCost);
         }
         else
         {
            this.inventory.riotPoints -= this._catalog.item.rpCost;
            _loc2_ = int(this._catalog.item.rpCost);
         }
         this.cdpContext.trackEvent("PurchaseFrom_" + this.cdpContext.getConfig().entryPoint,this._catalog.item.inventoryType + "_" + this._catalog.item.id,_loc2_);
         _logger.logInfo("Purchase item success");
         this.setCurrentState("purchaseConfirmation");
         this._purchaseComplete.dispatch(this,this.purchaseItemParams);
      }
      
      public function setCatalog(param1:Catalog) : void
      {
         if(this._catalog == param1)
         {
            return;
         }
         if(this._catalog != null)
         {
            this.ipPurchase.setVisible(false);
            this.rpCostText.setText("");
            this.ipCostText.setText("");
         }
         this._catalog = param1;
         this.itemCard.setCatalog(this._catalog);
         if(this._catalog != null)
         {
            this.rpCostText.setText("-" + this._catalog.item.rpCost.toString());
            this.ipCostText.setText("-" + this._catalog.item.ipCost.toString());
            this.ipPurchase.setVisible(this._catalog.item.ipCost > 0);
            this.refreshTotals();
            switch(this._catalog.item.inventoryType)
            {
               case InventoryTypesEnum.CHAMPION:
                  this.confirmTitleText.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseConfirm.championTitle"));
                  this.confirmContentText.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseConfirm.championContent"));
                  break;
               case InventoryTypesEnum.CHAMPION_SKIN:
                  this.confirmTitleText.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseConfirm.skinTitle"));
                  this.confirmContentText.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseConfirm.skinContent"));
            }
         }
      }
      
      private function refreshTotals(param1:Event = null) : void
      {
         if(!this.inventory || !this._catalog)
         {
            return;
         }
         this.currentRpText.setText(this.inventory.riotPoints.toString());
         this.currentIpText.setText(this.inventory.influencePoints.toString());
         var _loc2_:TextFormat = new TextFormat();
         _loc2_.color = 16777215;
         var _loc3_:TextFormat = new TextFormat();
         _loc3_.color = 15597568;
         this.rpBalanceText.setText("" + (this.inventory.riotPoints - this._catalog.item.rpCost));
         this.ipBalanceText.setText("" + (this.inventory.influencePoints - this._catalog.item.ipCost));
         if(this.inventory.riotPoints - this._catalog.item.rpCost >= 0)
         {
            this.rpBalanceText.setTextFormat(_loc2_);
         }
         else
         {
            this.rpBalanceText.setTextFormat(_loc3_);
         }
         if(this.inventory.influencePoints - this._catalog.item.ipCost >= 0)
         {
            this.ipBalanceText.setTextFormat(_loc2_);
         }
         else
         {
            this.ipBalanceText.setTextFormat(_loc3_);
         }
         this.refreshButtonsEnabled();
      }
      
      private function refreshButtonsEnabled() : void
      {
         if(!this._catalog || !this.inventory || getCurrentState() != "purchase")
         {
            this.unlockWithRpButton.setEnabled(false);
            this.unlockWithIpButton.setEnabled(false);
            this.purchaseRpButton.setEnabled(false);
         }
         else
         {
            this.unlockWithRpButton.setEnabled(this.inventory.riotPoints - this._catalog.item.rpCost >= 0);
            this.unlockWithIpButton.setEnabled(this.inventory.influencePoints - this._catalog.item.ipCost >= 0);
            this.purchaseRpButton.setEnabled(true);
         }
         this.refreshPurchaseRPButtonVisible();
      }
      
      private function refreshPurchaseRPButtonVisible() : void
      {
         if(this.cdpContext.getConfig().entryPoint != ChampionDetailEntryPointsEnum.CHAMPION_SELECT)
         {
            this.purchaseRpButton.setVisible(true);
         }
         else
         {
            this.purchaseRpButton.setVisible(false);
         }
      }
      
      public function setImage(param1:URLRequest) : void
      {
         this.itemCard.setImage(param1);
      }
      
      public function show() : void
      {
         setVisible(true);
         this.setCurrentState("purchase");
         TweenLite.to(assetProxy,0.25 * this.useTransitions,{
            "alpha":1,
            "ease":Sine.easeOut
         });
      }
      
      public function hide() : void
      {
         TweenLite.to(assetProxy,0.25 * this.useTransitions,{
            "alpha":0,
            "ease":Sine.easeIn,
            "onComplete":setVisible,
            "onCompleteParams":[false]
         });
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         return super.updateLayout(param1,param2);
      }
      
      private function get useTransitions() : int
      {
         return this.cdpContext.getConfig().useTransitions ? 1 : 0;
      }
      
      private function onResourceManagerChange(param1:Event) : void
      {
         this.purchaseItemTitle.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseScreen.purchaseItemTitle"));
         this.unlockWithRpLabel.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseScreen.unlockWithRpLabel"));
         this.unlockWithIpLabel.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseScreen.unlockWithIpLabel"));
         this.rpCostLabel.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseScreen.costLabel"));
         this.ipCostLabel.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseScreen.costLabel"));
         this.unlockWithRpButton.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseScreen.unlock"));
         this.unlockWithIpButton.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseScreen.unlock"));
         this.purchaseRpButton.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseScreen.purchaseRP"));
         this.rpBalanceLabelText.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseScreen.balance"));
         this.ipBalanceLabelText.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseScreen.balance"));
         this.currentRpLabel.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseScreen.currentRP"));
         this.currentIpLabel.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseScreen.currentIP"));
         this.purchasingLabel.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseScreen.unlocking"));
         this.confirmDoneButton.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseConfirm.done"));
         if(this._catalog)
         {
            switch(this._catalog.item.inventoryType)
            {
               case InventoryTypesEnum.CHAMPION:
                  this.confirmTitleText.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseConfirm.championTitle"));
                  this.confirmContentText.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseConfirm.championContent"));
                  break;
               case InventoryTypesEnum.CHAMPION_SKIN:
                  this.confirmTitleText.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseConfirm.skinTitle"));
                  this.confirmContentText.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"purchaseConfirm.skinContent"));
            }
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

