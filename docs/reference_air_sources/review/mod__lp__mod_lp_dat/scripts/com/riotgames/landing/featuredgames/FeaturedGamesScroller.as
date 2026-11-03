package com.riotgames.landing.featuredgames
{
   import blix.assets.proxy.FeaturedGamesSlider.FeaturedGamesScrollerAsset;
   import blix.assets.proxy.FeaturedGamesSlider.SlideIndicatorAsset;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.ButtonX;
   import blix.context.IContext;
   import blix.layout.LayoutContainer;
   import blix.layout.algorithms.HorizontalLayout;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.landing.FeaturedGame;
   import com.riotgames.landing.ILandingPageContext;
   import com.riotgames.platform.common.audio.AudioKeys;
   import com.riotgames.pvpnet.component.AudioButton;
   import com.riotgames.pvpnet.component.AudioLabelButton;
   import flash.events.MouseEvent;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class FeaturedGamesScroller extends SpriteProxy
   {
      
      protected static const DELAY:Number = 8000;
      
      protected var _visibleChanged:Signal = new Signal();
      
      private var _userIsInteracting:Boolean = false;
      
      private var _index:int = 0;
      
      private var _rollOutTimeoutId:uint;
      
      private var _nextGameTimeout:uint;
      
      private var _model:FeaturedGamesModel;
      
      private var _callToAction:ButtonX;
      
      private var _featuredGameAsset:FeaturedGameItem;
      
      private var _watchNow:AudioLabelButton;
      
      private var _indicators:Vector.<SlideIndicator> = new Vector.<SlideIndicator>();
      
      private var _indicatorContainerLayout:LayoutContainer;
      
      private var _indicatorContainer:SpriteProxy;
      
      private var _nextGameButton:AudioButton;
      
      private var _prevGameButton:AudioButton;
      
      public function FeaturedGamesScroller(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         var _loc5_:SlideIndicator = null;
         super.createChildren();
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         var _loc2_:FeaturedGamesScrollerAsset = new FeaturedGamesScrollerAsset();
         this._featuredGameAsset = new FeaturedGameItem(this);
         setTimelineChild(_loc2_.featuredGameAsset,this._featuredGameAsset);
         this._watchNow = new AudioLabelButton(this,AudioKeys.SOUND_WATCH_NOW_ROLL_OVER,AudioKeys.SOUND_WATCH_NOW_CLICK);
         this._watchNow.addEventListener(MouseEvent.CLICK,this.callToActionClickHandler);
         this._watchNow.setText(_loc1_.getString("LandingPage","featuredGames.watch_now"));
         this._watchNow.addEventListener(MouseEvent.MOUSE_OVER,this.handleWatchRollOver);
         this._watchNow.addEventListener(MouseEvent.MOUSE_OUT,this.handleRollOut);
         setTimelineChild(_loc2_.watchNowAsset,this._watchNow);
         this._watchNow.setHitArea(_loc2_.watchNowAsset.hitAreaAsset.create(this));
         this._callToAction = new ButtonX(this);
         this._callToAction.addEventListener(MouseEvent.MOUSE_OVER,this.handleRollOver);
         this._callToAction.addEventListener(MouseEvent.MOUSE_OUT,this.handleRollOut);
         this._callToAction.setUseHandCursor(false);
         setTimelineChild(_loc2_.callToActionAsset,this._callToAction);
         this._indicatorContainer = _loc2_.indicatorContainerAsset.create(this);
         this._indicatorContainerLayout = new LayoutContainer(this);
         var _loc3_:HorizontalLayout = new HorizontalLayout();
         _loc3_.setGap(1);
         this._indicatorContainerLayout.setLayoutAlgorithm(_loc3_);
         var _loc4_:int = 0;
         while(_loc4_ < 5)
         {
            _loc5_ = new SlideIndicator(this);
            _loc5_.setLinkage(SlideIndicatorAsset.LINKAGE);
            _loc5_.setTabIndex(_loc4_);
            _loc5_.addEventListener(MouseEvent.CLICK,this.handleIndicatorClicked);
            _loc5_.addEventListener(MouseEvent.MOUSE_OVER,this.handleRollOver);
            _loc5_.addEventListener(MouseEvent.MOUSE_OUT,this.handleRollOut);
            _loc5_.hide(true);
            this._indicatorContainer.addChild(_loc5_);
            this._indicatorContainerLayout.addElement(_loc5_);
            this._indicators.push(_loc5_);
            _loc4_++;
         }
         this._nextGameButton = new AudioButton(this,null,AudioKeys.SOUND_LANDING_PAGE_ARROW_CLICK);
         this._nextGameButton.addEventListener(MouseEvent.CLICK,this.nextGameButtonClickHandler);
         this._nextGameButton.addEventListener(MouseEvent.MOUSE_OVER,this.handleWatchRollOver);
         this._nextGameButton.addEventListener(MouseEvent.MOUSE_OUT,this.handleRollOut);
         setTimelineChild(_loc2_.nextGameAsset,this._nextGameButton);
         this._prevGameButton = new AudioButton(this,null,AudioKeys.SOUND_LANDING_PAGE_ARROW_CLICK);
         this._prevGameButton.addEventListener(MouseEvent.CLICK,this.prevGameButtonClickHandler);
         this._prevGameButton.addEventListener(MouseEvent.MOUSE_OVER,this.handleWatchRollOver);
         this._prevGameButton.addEventListener(MouseEvent.MOUSE_OUT,this.handleRollOut);
         setTimelineChild(_loc2_.prevGameAsset,this._prevGameButton);
         this._featuredGameAsset.nextReadySignal.add(this.readyToLoadNextGame);
         this._featuredGameAsset.showReadySignal.add(this.enableRollOvers);
         this._featuredGameAsset.showReadySignal.add(this.enableNavigationButtons);
      }
      
      public function setModel(param1:FeaturedGamesModel) : void
      {
         var _loc2_:SlideIndicator = null;
         var _loc3_:FeaturedGame = null;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         if(this._model != null)
         {
            this.enableRollOvers(false);
            this.stopNextGameTimer();
            for each(_loc2_ in this._indicators)
            {
               _loc2_.activate();
               _loc2_.hide(true);
            }
            this._model.getPatchWorkChanged().removeAll();
         }
         this._model = param1;
         if(this._model != null)
         {
            if(this._model.featuredGames != null && this._model.featuredGames.length > 0)
            {
               this.setVisible(true);
            }
            else
            {
               this.setVisible(false);
            }
            if(this._model.hasFeaturedGames())
            {
               _loc3_ = this._model.getCurrentFeaturedGame();
               this._featuredGameAsset.setModel(_loc3_);
               _loc4_ = this._model.featuredGames.length;
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  setTimeout(this._indicators[_loc5_].show,_loc5_ * 100);
                  _loc5_++;
               }
               this._indicators[0].deactivate();
               this._nextGameButton.setVisible(this._model.featuredGames.length > 1);
               this._prevGameButton.setVisible(this._model.featuredGames.length > 1);
               if(this._featuredGameAsset.getCurrentState() == this._featuredGameAsset.SHOW_STATE)
               {
                  this.enableRollOvers(true);
               }
               this._model.getPatchWorkChanged().add(this.enableRollOvers);
            }
         }
      }
      
      public function getModel() : FeaturedGamesModel
      {
         return this._model;
      }
      
      public function getVisibleChanged() : ISignal
      {
         return this._visibleChanged;
      }
      
      override public function setVisible(param1:Boolean) : void
      {
         super.setVisible(param1);
         this._visibleChanged.dispatch();
      }
      
      override public function destroy() : void
      {
         this.setVisible(false);
         this.setModel(null);
         this._visibleChanged.removeAll();
         super.destroy();
      }
      
      private function nextGameButtonClickHandler(param1:MouseEvent) : void
      {
         this._index = this._model.getNextIndex();
         this.readyToLoadNextGame();
      }
      
      private function prevGameButtonClickHandler(param1:MouseEvent) : void
      {
         this._index = this._model.getPrevIndex();
         this.readyToLoadNextGame();
      }
      
      private function handleWatchRollOver(param1:MouseEvent) : void
      {
         clearTimeout(this._rollOutTimeoutId);
         this.setActive(true);
      }
      
      private function handleRollOut(param1:MouseEvent) : void
      {
         if(this._watchNow.getEnabled())
         {
            this._watchNow.setCurrentState("up");
         }
         this._rollOutTimeoutId = setTimeout(this.setActive,300,false);
      }
      
      private function setActive(param1:Boolean) : void
      {
         this._rollOutTimeoutId = 0;
         this._userIsInteracting = param1;
         if(!this._userIsInteracting)
         {
            this.startNextGameTimer();
            this._featuredGameAsset.show();
         }
         else
         {
            this.stopNextGameTimer();
            this._featuredGameAsset.showOver();
         }
      }
      
      private function handleRollOver(param1:MouseEvent) : void
      {
         if(this._watchNow.getEnabled())
         {
            this._watchNow.setCurrentState("over2");
         }
         clearTimeout(this._rollOutTimeoutId);
         this.setActive(true);
      }
      
      private function startNextGameTimer() : void
      {
         this.stopNextGameTimer();
         if(Boolean(this._model) && Boolean(this._model.hasFeaturedGames()) && !this._userIsInteracting)
         {
            this._nextGameTimeout = setTimeout(this.nextGame,DELAY);
         }
      }
      
      private function stopNextGameTimer() : void
      {
         if(this._nextGameTimeout)
         {
            clearTimeout(this._nextGameTimeout);
            this._nextGameTimeout = 0;
         }
      }
      
      private function callToActionClickHandler(param1:MouseEvent) : void
      {
         this.stopNextGameTimer();
         this._featuredGameAsset.hide();
         var _loc2_:ILandingPageContext = getFirstContext(ILandingPageContext);
         _logger.logDebug(_loc2_ + " try to join game");
         _loc2_.spectateFeaturedGame(this._model.getCurrentFeaturedGame());
      }
      
      private function enableRollOvers(param1:Boolean = true) : void
      {
         this.enableNavigationButtons(param1);
         this._callToAction.setEnabled(param1);
         this._callToAction.setUseHandCursor(false);
         this._watchNow.setEnabled(param1 && this._model.getReplaysEnabled());
      }
      
      private function enableNavigationButtons(param1:Boolean = true) : void
      {
         this._indicatorContainer.setMouseChildren(param1);
         this._nextGameButton.setEnabled(param1);
         this._prevGameButton.setEnabled(param1);
      }
      
      private function handleIndicatorClicked(param1:MouseEvent) : void
      {
         this._index = (param1.currentTarget as SlideIndicator).getTabIndex();
         this.readyToLoadNextGame();
      }
      
      private function readyToLoadNextGame() : void
      {
         var _loc1_:FeaturedGame = this._model.getFeaturedGameByIndex(this._index);
         this.gotoGame(_loc1_);
      }
      
      private function nextGame() : void
      {
         this.stopNextGameTimer();
         this._index = this._model.getNextIndex();
         this.enableRollOvers(false);
         this._featuredGameAsset.gotoNextState();
      }
      
      private function gotoGame(param1:FeaturedGame) : void
      {
         this._featuredGameAsset.setModel(param1);
         this._index = this._model.currentIndex;
         this.startNextGameTimer();
         this.updateIndicators();
      }
      
      private function updateIndicators() : void
      {
         var _loc1_:SlideIndicator = null;
         for each(_loc1_ in this._indicators)
         {
            _loc1_.activate();
         }
         this._indicators[this._model.currentIndex].deactivate();
      }
   }
}

