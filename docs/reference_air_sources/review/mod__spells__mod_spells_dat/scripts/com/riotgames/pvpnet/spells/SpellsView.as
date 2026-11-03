package com.riotgames.pvpnet.spells
{
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.domain.SummonerLevel;
   import com.riotgames.platform.module.RiotModuleInfo;
   import com.riotgames.rust.module.RiotModuleView;
   import flash.display.MovieClip;
   import flash.net.URLRequest;
   
   public class SpellsView extends RiotModuleView
   {
      
      private var _moduleInfo:RiotModuleInfo;
      
      private var _assetsUrlRequest:URLRequest;
      
      private var _spellsController:SpellsController;
      
      private var spellSelector:SpellSelector;
      
      private var spellDetailsView:SpellDetailsView;
      
      public function SpellsView(param1:IContext, param2:RiotModuleInfo)
      {
         super(param1,new MovieClip());
         this._moduleInfo = param2;
         setLinkage("Main");
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this._spellsController = new SpellsController();
         registerDependency(SpellsController,this._spellsController);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.spellSelector = new SpellSelector(this);
         this.spellSelector.getSelectedSpellChanged().add(this.selectedItemChangedHandler);
         setTimelineChildByName("spellSelector",this.spellSelector);
         this.spellDetailsView = new SpellDetailsView(this);
         setTimelineChildByName("spellDetailsView",this.spellDetailsView);
         this.selectedItemChangedHandler();
      }
      
      private function selectedItemChangedHandler() : void
      {
         this.spellDetailsView.setModel(this.spellSelector.getSelectedSpell());
      }
      
      public function show() : void
      {
         this._assetsUrlRequest = getThemeAssetUrl(this._moduleInfo.getPath(),"SpellsAssets.swf");
         loadAssets(this._assetsUrlRequest);
      }
      
      public function hide() : void
      {
         unloadAssets(this._assetsUrlRequest);
      }
      
      public function setSummonerLevel(param1:SummonerLevel) : void
      {
         this._spellsController.summonerLevel = param1;
      }
   }
}

