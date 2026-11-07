package com.riotgames.pvpnet.championinventory.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.Models.SearchTagData;
   import com.riotgames.platform.gameclient.domain.IChampionFilter;
   import com.riotgames.pvpnet.championinventory.model.ChampionAvailabilityStatus;
   import com.riotgames.pvpnet.championinventory.model.ChampionInventoryViewModel;
   import com.riotgames.rust.components.dropdown.Dropdown;
   import com.riotgames.rust.components.list.renderer.DefaultListItem;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class ChampionInventoryFilterView extends SpriteProxy
   {
      
      private var rolesDropdown:Dropdown;
      
      private var availabilityDropdown:Dropdown;
      
      private var rM:IResourceManager = ResourceManager.getInstance();
      
      private var filterObject:IChampionFilter;
      
      private var viewModel:ChampionInventoryViewModel;
      
      public function ChampionInventoryFilterView(param1:IContext)
      {
         super(param1);
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this.filterObject = getDependency(IChampionFilter);
         this.viewModel = getDependency(ChampionInventoryViewModel);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:TextFieldProxy = new TextFieldProxy(this);
         setTimelineChildByName("rolesLabel",_loc1_);
         _loc1_.setText(this.rM.getString("resources","championFilter_roles"));
         var _loc2_:TextFieldProxy = new TextFieldProxy(this);
         setTimelineChildByName("availabilityLabel",_loc2_);
         _loc2_.setText(this.rM.getString("resources","championFilter_availability"));
         this.rolesDropdown = new ChampionInventoryDropdown(this);
         this.rolesDropdown.listLinkage = "championinventory.roles.DropdownList";
         this.rolesDropdown.listRendererLinkage = "ChampionInventoryDropdownRenderer";
         this.rolesDropdown.listRenderer = DefaultListItem;
         this.rolesDropdown.labelField = "searchTagDisplayName";
         this.rolesDropdown.data = this.viewModel.getRoles().toArray();
         this.rolesDropdown.selectedIndex = 0;
         this.rolesDropdown.selectionChanged.add(this.onRoleDropdownChanged);
         setTimelineChildByName("rolesDropdown",this.rolesDropdown);
         this.availabilityDropdown = new ChampionInventoryDropdown(this);
         this.availabilityDropdown.listLinkage = "championinventory.availability.DropdownList";
         this.availabilityDropdown.listRendererLinkage = "ChampionInventoryDropdownRenderer";
         this.availabilityDropdown.listRenderer = DefaultListItem;
         this.availabilityDropdown.labelField = "label";
         this.availabilityDropdown.data = this.viewModel.getOwnedStates().toArray();
         this.availabilityDropdown.selectedIndex = 0;
         this.availabilityDropdown.selectionChanged.add(this.onAvailabilityDropdownChanged);
         setTimelineChildByName("availabilityDropdown",this.availabilityDropdown);
      }
      
      private function onRoleDropdownChanged() : void
      {
         var _loc1_:SearchTagData = this.rolesDropdown.data[this.rolesDropdown.selectedIndex] as SearchTagData;
         if(_loc1_)
         {
            this.filterObject.setTagState(_loc1_,true);
         }
      }
      
      private function onAvailabilityDropdownChanged() : void
      {
         var _loc1_:ChampionAvailabilityStatus = this.availabilityDropdown.data[this.availabilityDropdown.selectedIndex] as ChampionAvailabilityStatus;
         if(_loc1_)
         {
            this.filterObject.setOwnedState(_loc1_.getFilterType());
         }
      }
   }
}

