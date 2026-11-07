package com.riotgames.championdetails.overview
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.assets.proxy.overview.skinChooser.SkinCardAsset;
   import blix.components.button.LabelButtonX;
   import blix.components.loader.ImageX;
   import blix.components.text.Text;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.layout.LayoutContainer;
   import blix.layout.algorithms.HorizontalLayout;
   import blix.layout.vo.HorizontalAlign;
   import blix.layout.vo.VerticalAlign;
   import com.greensock.TweenLite;
   import com.riotgames.championdetails.IChampionDetailsContext;
   import com.riotgames.championdetails.IPurchaseContext;
   import com.riotgames.championdetails.Main;
   import com.riotgames.championdetails.model.ChampionSkin;
   import com.riotgames.store.model.Catalog;
   import com.riotgames.store.model.CatalogResult;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.text.TextFieldAutoSize;
   import mx.resources.IResourceManager;
   
   public class SkinCard extends StatefulView
   {
      
      private static const CHAMPION_DETAILS_RESOURCE_ID:String = Main.CHAMPION_DETAILS_RESOURCE_ID;
      
      private var image:ImageX;
      
      private var title:Text;
      
      private var unlockButton:LabelButtonX;
      
      private var skinCardFrame:StatefulView;
      
      private var unavailableText:Text;
      
      private var ownedText:Text;
      
      private var rpIcon:SpriteProxy;
      
      private var rpCostText:TextFieldProxy;
      
      private var ipIcon:SpriteProxy;
      
      private var ipCostText:TextFieldProxy;
      
      private var map:SkinCardAsset = new SkinCardAsset();
      
      private var _skin:ChampionSkin;
      
      private var _catalog:Catalog;
      
      private var cdpContext:IChampionDetailsContext;
      
      private var costLayout:LayoutContainer;
      
      private var imageSizer:SpriteProxy;
      
      private var _selected:Boolean;
      
      private var requiresChampionText:Text;
      
      private var requiresChampionBox:SpriteProxy;
      
      private var pricePosition:SpriteProxy;
      
      private var resourceManager:IResourceManager;
      
      public function SkinCard(param1:IContext)
      {
         super(param1);
         setUseHandCursor(true);
         setButtonMode(true);
         setLinkage(SkinCardAsset.LINKAGE);
         this.cdpContext = getFirstContext(IChampionDetailsContext);
         this.cdpContext.getCatalogResultChanged().add(this.catalogResultChangedHandler);
         if(this.cdpContext.getCatalogResult() != null)
         {
            this.catalogResultChangedHandler();
         }
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this.resourceManager = getDependency(IResourceManager);
         this.resourceManager.addEventListener(Event.CHANGE,this.onResourceManagerChange);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.skinCardFrame = new StatefulView(this);
         setTimelineChild(this.map.frame,this.skinCardFrame);
         this.skinCardFrame.getLayoutInvalidated().add(invalidateLayout);
         this.skinCardFrame.setAlpha(0);
         this.skinCardFrame.setMouseChildren(false);
         this.imageSizer = this.map.imageSizer.create(this);
         this.imageSizer.getLayoutInvalidated().add(invalidateLayout);
         this.image = new ImageX(this);
         this.image.setHorizontalAlign(HorizontalAlign.CENTER);
         this.image.getLayoutInvalidated().add(invalidateLayout);
         setTimelineChild(this.map.imageHolder,this.image);
         this.unlockButton = new LabelButtonX(this);
         this.unlockButton.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"skinSelector.unlock"));
         this.unlockButton.addEventListener(MouseEvent.CLICK,this.unlockClickedHandler);
         setTimelineChild(this.map.frame.unlockButton,this.unlockButton);
         this.unavailableText = new Text(this);
         this.unavailableText.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"skinSelector.unavailable"));
         setTimelineChild(this.map.frame.unavailableText,this.unavailableText);
         this.requiresChampionText = new Text(this);
         this.requiresChampionText.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"skinSelector.requiresChampion"));
         setTimelineChild(this.map.frame.requiresChampion.text,this.requiresChampionText);
         this.requiresChampionBox = this.map.frame.requiresChampion.create(this);
         this.ownedText = new Text(this);
         this.ownedText.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"skinSelector.owned"));
         setTimelineChild(this.map.frame.ownedText,this.ownedText);
         this.title = new Text(this);
         this.title.setAutoSize(TextFieldAutoSize.CENTER);
         this.title.getLayoutInvalidated().add(invalidateLayout);
         setTimelineChild(this.map.frame.title,this.title);
         this.pricePosition = this.map.frame.pricePosition.create(this);
         this.pricePosition.getLayoutInvalidated().add(invalidateLayout);
         this.costLayout = new LayoutContainer(this);
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.setGap(1);
         _loc1_.setVerticalAlign(VerticalAlign.MIDDLE);
         _loc1_.setHorizontalAlign(HorizontalAlign.CENTER);
         this.costLayout.setLayoutAlgorithm(_loc1_);
         this.rpIcon = this.map.frame.rpIcon.create(this);
         this.costLayout.addElement(this.rpIcon);
         this.rpCostText = this.map.frame.rpCostText.create(this);
         this.rpCostText.setAutoSize(TextFieldAutoSize.LEFT);
         this.costLayout.addElement(this.rpCostText);
         this.ipIcon = this.map.frame.ipIcon.create(this);
         this.costLayout.addElement(this.ipIcon);
         this.ipCostText = this.map.frame.ipCostText.create(this);
         this.ipCostText.setAutoSize(TextFieldAutoSize.LEFT);
         this.costLayout.addElement(this.ipCostText);
      }
      
      private function unlockClickedHandler(param1:MouseEvent) : void
      {
         if(this._skin == null)
         {
            return;
         }
         this.cdpContext.trackEvent("Click Unlock Skin","CPD_Champion" + this._skin.championId + "_Skin" + this._skin.id + "_Unlock");
         var _loc2_:IPurchaseContext = getFirstContext(IPurchaseContext);
         _loc2_.openPurchaseScreen(this._catalog,this.getPortrait());
      }
      
      public function setSelected(param1:Boolean) : void
      {
         if(this._selected == param1)
         {
            return;
         }
         this._selected = param1;
         setUseHandCursor(!param1);
         setButtonMode(!param1);
         if(param1)
         {
            TweenLite.to(this.skinCardFrame.getSetterProxy(),0.5 * this.useTransitions,{
               "alpha":1,
               "onComplete":this.skinCardFrame.setMouseChildren,
               "onCompleteParams":[true]
            });
         }
         else
         {
            TweenLite.to(this.skinCardFrame.getSetterProxy(),0.5 * this.useTransitions,{
               "alpha":0,
               "onComplete":this.skinCardFrame.setMouseChildren,
               "onCompleteParams":[false]
            });
         }
      }
      
      public function getSkin() : ChampionSkin
      {
         return this._skin;
      }
      
      public function setSkin(param1:ChampionSkin) : void
      {
         var _loc2_:IChampionDetailsContext = null;
         this._skin = param1;
         if(this._skin != null)
         {
            _loc2_ = getFirstContext(IChampionDetailsContext);
            this.image.load(new URLRequest(_loc2_.getConfig().championAssetsPath + this._skin.portraitPath));
            if(this.getIsClassic())
            {
               this.title.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"skinSelector.classic"));
               this.requiresChampionBox.setVisible(false);
            }
            else
            {
               this.title.setTextModel(null);
               this.title.setText(this.formatText(this._skin.displayName));
            }
            this.refreshSkinCardVisibility();
            this.refreshCatalog();
         }
      }
      
      private function formatText(param1:String) : String
      {
         if(!param1)
         {
            return "";
         }
         return param1.replace("\\n","\n");
      }
      
      protected function getPortrait() : URLRequest
      {
         return new URLRequest(this.cdpContext.getConfig().championAssetsPath + this._skin.portraitPath);
      }
      
      private function catalogResultChangedHandler() : void
      {
         this.refreshCatalog();
      }
      
      private function refreshCatalog() : void
      {
         var _loc1_:CatalogResult = this.cdpContext.getCatalogResult();
         if(_loc1_ == null || this._skin == null)
         {
            return;
         }
         this._catalog = _loc1_.getCatalogByItemId(this._skin.getFullId());
         this.refreshSkinCardState();
         this.refreshSkinCardVisibility();
      }
      
      protected function getIsClassic() : Boolean
      {
         return this._skin.rank == 0;
      }
      
      private function refreshSkinCardState() : void
      {
         if(this.cdpContext.getCatalogResult() == null)
         {
            return;
         }
         var _loc1_:Boolean = Boolean(this.cdpContext.getCatalogResult().rentalStatus);
         if(_loc1_)
         {
            this.skinCardFrame.setCurrentState("normal");
         }
         else if(this._catalog == null)
         {
            if(this.getIsClassic())
            {
               this.skinCardFrame.setCurrentState("normal");
            }
            else
            {
               this.skinCardFrame.setCurrentState("unpurchasable");
            }
         }
         else if(this._catalog.item.isOwned)
         {
            this.skinCardFrame.setCurrentState("owned");
         }
         else if(!this._catalog.item.active)
         {
            this.skinCardFrame.setCurrentState("unpurchasable");
         }
         else if(!this._catalog.item.championOwned)
         {
            this.skinCardFrame.setCurrentState("requiresChampion");
         }
         else
         {
            this.rpCostText.setText(this._catalog.item.rpCost.toString());
            this.ipCostText.setText(this._catalog.item.ipCost.toString());
            this.ipIcon.setVisible(this._catalog.item.ipCost > 0);
            this.ipCostText.setVisible(this._catalog.item.ipCost > 0);
            this.skinCardFrame.setCurrentState("purchasable");
         }
      }
      
      private function refreshSkinCardVisibility() : void
      {
         var _loc1_:Boolean = false;
         if(Boolean(this._catalog) && (Boolean(this._catalog.item.active) || Boolean(this._catalog.item.isOwned)))
         {
            _loc1_ = true;
         }
         else if(this.getIsClassic())
         {
            _loc1_ = true;
         }
         else if(this.cdpContext.getConfig().validSkins != null)
         {
            _loc1_ = this.cdpContext.getConfig().validSkins.indexOf(this.getSkin().id) >= 0;
         }
         else
         {
            _loc1_ = true;
         }
         setVisible(_loc1_);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this.title.setExplicitPosition(NaN,-this.title.getHeight());
         var _loc3_:Number = Number(this.imageSizer.getWidth());
         var _loc4_:Number = Number(this.imageSizer.getHeight());
         this.image.setExplicitSize(_loc3_,_loc4_);
         this.costLayout.setExplicitSize(_loc3_,NaN);
         this.costLayout.setExplicitPosition(this.pricePosition.getX(),this.pricePosition.getY());
         return new Rectangle(0,0,_loc3_,_loc4_);
      }
      
      private function get useTransitions() : int
      {
         return this.cdpContext.getConfig().useTransitions ? 1 : 0;
      }
      
      private function onResourceManagerChange(param1:Event) : void
      {
         this.unlockButton.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"skinSelector.unlock"));
         this.unavailableText.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"skinSelector.unavailable"));
         this.requiresChampionText.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"skinSelector.requiresChampion"));
         this.ownedText.setText(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"skinSelector.owned"));
         this.setSkin(this._skin);
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

