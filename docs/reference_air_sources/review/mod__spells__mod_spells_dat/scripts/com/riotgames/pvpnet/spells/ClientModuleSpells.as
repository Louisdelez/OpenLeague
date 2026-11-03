package com.riotgames.pvpnet.spells
{
   import blix.assets.proxy.DisplayAdapter;
   import com.riotgames.platform.gameclient.domain.SummonerLevel;
   import com.riotgames.platform.provider.IProviderModule;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import flash.display.Sprite;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class ClientModuleSpells extends Sprite implements IProviderModule, ISpellsProvider
   {
      
      private var _view:SpellsView;
      
      private var parentAdapter:DisplayAdapter;
      
      public function ClientModuleSpells()
      {
         super();
      }
      
      public function initializeModule(param1:ProviderModuleInfo) : void
      {
         this._view = new SpellsView(null,param1);
         ProviderLookup.publishProvider(ISpellsProvider,this);
      }
      
      public function show(param1:DisplayAdapter, param2:SummonerLevel) : void
      {
         this.parentAdapter = param1;
         param1.addChild(this._view);
         this._view.setSummonerLevel(param2);
         this._view.show();
      }
      
      public function hide() : void
      {
         this._view.hide();
         if(this.parentAdapter)
         {
            this.parentAdapter.removeChild(this._view);
         }
      }
   }
}

