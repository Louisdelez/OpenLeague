package com.riotgames.pvpnet.cap.championselection.classic.views
{
   import com.riotgames.platform.common.components.AnimatedTileList;
   import com.riotgames.platform.gameclient.controllers.game.event.ItemSelectEvent;
   import com.riotgames.pvpnet.championselection.views.ChampionSelectRenderer;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import mx.binding.utils.BindingUtils;
   import mx.collections.ArrayCollection;
   import mx.core.ClassFactory;
   import mx.core.Container;
   import mx.effects.DefaultTileListEffect;
   
   public class CapChampionGrid extends Container
   {
      
      private var _lastRolledOver:ChampionSelectRenderer;
      
      private var _animatedTileList:AnimatedTileList;
      
      private var _dataProvider:ArrayCollection;
      
      private var _tileListEffect:DefaultTileListEffect;
      
      private var _dataProviderDelta:Boolean = false;
      
      public function CapChampionGrid()
      {
         super();
      }
      
      private function onItemRolledOver(param1:ItemSelectEvent) : void
      {
         this._lastRolledOver = param1.target as ChampionSelectRenderer;
      }
      
      protected function getTileListAnimation(param1:Boolean) : DefaultTileListEffect
      {
         if(param1)
         {
            return this._tileListEffect;
         }
         return null;
      }
      
      public function hide() : void
      {
         if(this._lastRolledOver)
         {
            this._lastRolledOver.borderOverlay.currentState = ChampionSelectRenderer.BUTTON_STATE_UP;
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         if(this._tileListEffect)
         {
            measuredWidth = this._animatedTileList.getExplicitOrMeasuredWidth();
            measuredHeight = this._animatedTileList.getExplicitOrMeasuredHeight();
         }
      }
      
      public function set tileListAnimation(param1:Boolean) : void
      {
         this._animatedTileList.setStyle("itemsChangeEffect",this.getTileListAnimation(param1));
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this._dataProviderDelta)
         {
            this._animatedTileList.dataProvider = this._dataProvider;
            this._dataProviderDelta = false;
         }
      }
      
      public function set dataProvider(param1:ArrayCollection) : void
      {
         this._dataProviderDelta = this._dataProvider != param1;
         this._dataProvider = param1;
         if(this._dataProviderDelta)
         {
            invalidateProperties();
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         if(this._animatedTileList)
         {
            this._animatedTileList.setActualSize(param1,param2);
            this._animatedTileList.move(0,0);
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._tileListEffect = new DefaultTileListEffect();
         this._tileListEffect.fadeOutDuration = 300;
         this._tileListEffect.fadeInDuration = 300;
         this._tileListEffect.moveDuration = 300;
         this._animatedTileList = new AnimatedTileList();
         this._animatedTileList.interactiveRenderers = true;
         this._animatedTileList.setStyle("backgroundAlpha",0);
         this._animatedTileList.setStyle("paddingLeft",12);
         this._animatedTileList.setStyle("paddingRight",6);
         this._animatedTileList.setStyle("paddingTop",12);
         this._animatedTileList.setStyle("paddingBottom",12);
         this._animatedTileList.addEventListener(ItemSelectEvent.ROLL_OVER,this.onItemRolledOver,false,0,true);
         this._animatedTileList.tileWidth = 69;
         this._animatedTileList.tileHeight = 65;
         this._animatedTileList.itemRenderer = new ClassFactory(ChampionSelectRenderer);
         this._animatedTileList.setStyle("scrollBarStyle","blueGlassScrollBar");
         this._animatedTileList.setVisible(true);
         BindingUtils.bindProperty(this,"tileListAnimation",UserPreferencesManager.userPrefs,"enableAnimations");
         addChild(this._animatedTileList);
      }
   }
}

