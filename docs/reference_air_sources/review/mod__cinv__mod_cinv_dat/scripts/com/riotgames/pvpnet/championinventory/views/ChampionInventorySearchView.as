package com.riotgames.pvpnet.championinventory.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.domain.IChampionFilter;
   import com.riotgames.rust.components.text.InputTextFieldProxy;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class ChampionInventorySearchView extends SpriteProxy
   {
      
      private var _searchBarTextInput:InputTextFieldProxy;
      
      private var _filterObject:IChampionFilter;
      
      private var _isSearching:Boolean;
      
      public function ChampionInventorySearchView(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         this._searchBarTextInput = new InputTextFieldProxy(this);
         setTimelineChildByName("searchBarTextInput",this._searchBarTextInput);
         this._searchBarTextInput.setHintText(_loc1_.getString("resources","championFilter_searchText"));
         this._searchBarTextInput.addEventListener(Event.CHANGE,this.handleSearchBarChange);
         this._searchBarTextInput.addEventListener(FocusEvent.FOCUS_IN,this.handleSearchBarFocusIn);
         this._searchBarTextInput.addEventListener(FocusEvent.FOCUS_OUT,this.handleSearchBarFocusOut);
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this._filterObject = getDependency(IChampionFilter);
      }
      
      private function handleSearchBarFocusIn(param1:FocusEvent) : void
      {
         this._isSearching = true;
      }
      
      private function handleSearchBarFocusOut(param1:FocusEvent) : void
      {
         this._isSearching = false;
      }
      
      private function handleSearchBarChange(param1:Event) : void
      {
         if(!this._isSearching)
         {
            return;
         }
         this._filterObject.setFilterString(this._searchBarTextInput.getText().toLowerCase());
      }
   }
}

