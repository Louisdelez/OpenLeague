package com.riotgames.championdetails.overview
{
   import blix.assets.proxy.SpriteProxy;
   import blix.context.Context;
   import blix.layout.LayoutContainer;
   import blix.layout.algorithms.CoverFlowLayout;
   import blix.model.TextModel;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.util.keyboard.addKeyListener;
   import com.greensock.TweenLite;
   import com.greensock.easing.Sine;
   import com.riotgames.championdetails.HardCodedCrap;
   import com.riotgames.championdetails.IChampionDetailsContext;
   import com.riotgames.championdetails.Main;
   import com.riotgames.championdetails.model.ChampionInfo;
   import com.riotgames.championdetails.model.ChampionSkin;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import mx.resources.IResourceManager;
   
   public class SkinSelector extends SpriteProxy
   {
      
      private static const CHAMPION_DETAILS_RESOURCE_ID:String = Main.CHAMPION_DETAILS_RESOURCE_ID;
      
      private var _skinChanged:Signal = new Signal();
      
      private var _championInfo:ChampionInfo;
      
      private var skinCards:Vector.<SkinCard> = new Vector.<SkinCard>();
      
      private var skinsLayout:LayoutContainer;
      
      private var coverFlowLayout:CoverFlowLayout;
      
      private var _currentSkinCard:SkinCard;
      
      private var cdpContext:IChampionDetailsContext;
      
      private var _enabled:Boolean;
      
      private var _fromLayoutPosition:Number = 0;
      
      private var _toSkinIndex:Number = 0;
      
      private var _skinTweenPercent:Number = 0;
      
      private var resourceManager:IResourceManager;
      
      public function SkinSelector(param1:Context)
      {
         super(param1);
         this.cdpContext = getFirstContext(IChampionDetailsContext);
         addKeyListener(this,this.keyDownHandler);
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this.resourceManager = getDependency(IResourceManager);
         this.resourceManager.addEventListener(Event.CHANGE,this.onResourceManagerChange);
      }
      
      private function keyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc4_:SkinCard = null;
         if(!this._enabled || !this._currentSkinCard)
         {
            return;
         }
         var _loc2_:int = this.getCurrentSkinCardIndex();
         var _loc3_:int = -1;
         if(param1.keyCode == Keyboard.LEFT)
         {
            while(--_loc2_ >= 0)
            {
               if(this.skinCards[_loc2_].getIncludeInLayout())
               {
                  _loc3_ = _loc2_;
                  break;
               }
            }
         }
         else
         {
            if(param1.keyCode != Keyboard.RIGHT)
            {
               return;
            }
            while(++_loc2_ < this.skinCards.length)
            {
               if(this.skinCards[_loc2_].getIncludeInLayout())
               {
                  _loc3_ = _loc2_;
                  break;
               }
            }
         }
         if(_loc3_ != -1)
         {
            _loc4_ = this.skinCards[_loc3_];
            this.setCurrentSkinCard(_loc4_);
         }
      }
      
      public function setEnabled(param1:Boolean) : void
      {
         this._enabled = param1;
      }
      
      public function getSkinChanged() : ISignal
      {
         return this._skinChanged;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.skinsLayout = new LayoutContainer(this);
         this.coverFlowLayout = new CoverFlowLayout();
         this.coverFlowLayout.setPerspectiveProjection = true;
         this.coverFlowLayout.perspectiveProjectionTarget = this;
         this.coverFlowLayout.setZGap(60);
         this.skinsLayout.setLayoutAlgorithm(this.coverFlowLayout);
         this.skinsLayout.getLayoutInvalidated().add(invalidateLayout);
      }
      
      public function setChampionInfo(param1:ChampionInfo) : void
      {
         var _loc2_:ChampionSkin = null;
         var _loc3_:SkinCard = null;
         this._championInfo = param1;
         this.setCurrentSkinCard(null);
         this.createSkinsCards();
         if(this.skinCards.length > 0)
         {
            _logger.logInfo("Selecting Skin " + this.cdpContext.getConfig());
            _loc2_ = this._championInfo.getSkinById(this.cdpContext.getConfig().initialSkinId);
            if(_loc2_)
            {
               _loc3_ = this.getSkinCard(_loc2_);
               this.setCurrentSkinCard(_loc3_);
            }
            else
            {
               this.setCurrentSkinCard(this.skinCards[0]);
            }
         }
      }
      
      private function getSkinCard(param1:ChampionSkin) : SkinCard
      {
         var _loc2_:SkinCard = null;
         for each(_loc2_ in this.skinCards)
         {
            if(_loc2_.getSkin() == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function createSkinsCards() : void
      {
         var _loc1_:SkinCard = null;
         var _loc2_:ChampionSkin = null;
         var _loc3_:SkinCard = null;
         var _loc4_:String = null;
         var _loc5_:UltimateSkinCard = null;
         for each(_loc1_ in this.skinCards)
         {
            removeChild(_loc1_);
            _loc1_.destroy();
         }
         this.skinsLayout.removeAllElements();
         this.skinCards.length = 0;
         if(this._championInfo == null)
         {
            return;
         }
         for each(_loc2_ in this._championInfo.skins)
         {
            _loc4_ = this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,_loc2_.id + ".featuresText");
            if(_loc2_.id == HardCodedCrap.PF_EZREAL_SKIN)
            {
               _loc5_ = new UltimateSkinCard(this);
               _loc5_.setFeaturesText(new TextModel(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"pulsefireEz.featuresText")));
               _loc3_ = _loc5_;
            }
            else if(_loc4_ != null)
            {
               _loc5_ = new UltimateSkinCard(this);
               _loc5_.setFeaturesText(new TextModel(_loc4_));
               _loc3_ = _loc5_;
            }
            else
            {
               _loc3_ = new SkinCard(this);
            }
            _loc3_.setName("SkinCard_" + _loc2_.id);
            _loc3_.addEventListener(MouseEvent.CLICK,this.skinCardClickHandler);
            _loc3_.setSkin(_loc2_);
            addChild(_loc3_);
            this.skinsLayout.addElement(_loc3_);
            this.skinCards[this.skinCards.length] = _loc3_;
         }
      }
      
      private function skinCardClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:SkinCard = param1.currentTarget as SkinCard;
         this.setCurrentSkinCard(_loc2_);
      }
      
      private function getCurrentSkinCardIndex() : int
      {
         return this.skinCards.indexOf(this._currentSkinCard);
      }
      
      private function setCurrentSkinCard(param1:SkinCard) : void
      {
         if(this._currentSkinCard == param1)
         {
            return;
         }
         if(this._currentSkinCard != null)
         {
            this._currentSkinCard.setSelected(false);
         }
         this._currentSkinCard = param1;
         if(this._currentSkinCard != null)
         {
            this._skinChanged.dispatch(param1.getSkin());
            this._toSkinIndex = this.skinCards.indexOf(this._currentSkinCard);
            this._fromLayoutPosition = this.coverFlowLayout.getCurrentPosition();
            this._skinTweenPercent = 0;
            TweenLite.killTweensOf(this);
            TweenLite.to(this,0.5 * this.useTransitions,{
               "skinTweenPercent":1,
               "ease":Sine.easeInOut,
               "onComplete":this.currentSkinTransitionComplete,
               "onCompleteParams":[this._currentSkinCard]
            });
         }
         else
         {
            this._skinChanged.dispatch(null);
         }
      }
      
      public function get skinTweenPercent() : Number
      {
         return this._skinTweenPercent;
      }
      
      public function set skinTweenPercent(param1:Number) : void
      {
         this._skinTweenPercent = param1;
         invalidateLayout();
      }
      
      protected function currentSkinTransitionComplete(param1:SkinCard) : void
      {
         if(this._currentSkinCard != param1)
         {
            return;
         }
         this._currentSkinCard.setSelected(true);
      }
      
      private function get useTransitions() : int
      {
         return this.cdpContext.getConfig().useTransitions ? 1 : 0;
      }
      
      private function getLayoutPosition(param1:Number) : Number
      {
         var _loc5_:SkinCard = null;
         if(!this.skinCards)
         {
            return 0;
         }
         var _loc2_:Number = param1;
         var _loc3_:uint = this.skinCards.length;
         var _loc4_:uint = 0;
         while(_loc4_ <= param1 && _loc4_ < _loc3_)
         {
            _loc5_ = this.skinCards[_loc4_];
            if(!_loc5_.getIncludeInLayout())
            {
               _loc2_--;
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      private function onResourceManagerChange(param1:Event) : void
      {
         var _loc2_:SkinCard = null;
         var _loc3_:String = null;
         for each(_loc2_ in this.skinCards)
         {
            _loc3_ = this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,_loc2_.getSkin().id + ".featuresText");
            if(_loc2_.getSkin().id == HardCodedCrap.PF_EZREAL_SKIN)
            {
               (_loc2_ as UltimateSkinCard).setFeaturesText(new TextModel(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"pulsefireEz.featuresText")));
               break;
            }
            if(_loc3_ != null)
            {
               (_loc2_ as UltimateSkinCard).setFeaturesText(new TextModel(_loc3_));
               break;
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
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Number = this._fromLayoutPosition;
         var _loc4_:Number = this.getLayoutPosition(this._toSkinIndex);
         this.coverFlowLayout.setCurrentPosition((_loc4_ - _loc3_) * this._skinTweenPercent + _loc3_);
         this.skinsLayout.setExplicitSize(NaN,NaN);
         return super.updateLayout(param1,param2);
      }
   }
}

