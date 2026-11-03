package com.riotgames.pvpnet.spells
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.list.DataGroup;
   import blix.components.list.RendererFactory;
   import blix.components.list.SelectionBehavior;
   import blix.context.IContext;
   import blix.ds.IListX;
   import blix.ds.ListView;
   import blix.layout.algorithms.VirtualizedTileLayout;
   import blix.signals.ISignal;
   import com.riotgames.platform.common.provider.IInventoryProvider;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.game.variants.GameFlowVariantFactory;
   import com.riotgames.rust.data.ListAdapter;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import mx.collections.ArrayCollection;
   
   public class SpellSelector extends SpriteProxy
   {
      
      private var spellGridSizer:SpriteProxy;
      
      private var spellGrid:DataGroup;
      
      private var selectionBehavior:SelectionBehavior;
      
      private var rendererFactory:RendererFactory;
      
      public function SpellSelector(param1:IContext)
      {
         super(param1);
         ProviderLookup.getProvider(IInventoryProvider,this.getInventoryProviderHandler);
      }
      
      private function getInventoryProviderHandler(param1:IInventoryProvider) : void
      {
         var _loc2_:IListX = new ListAdapter(this.getSpellsToShow(param1));
         var _loc3_:ListView = new ListView(_loc2_);
         _loc3_.sortWithCompare(this.spellSortCompare);
         this.spellGrid.setDataProvider(_loc3_);
         this.selectionBehavior.setDataProvider(_loc3_);
         this.selectionBehavior.setSelectedItem(_loc3_[0]);
      }
      
      private function getSpellsToShow(param1:IInventoryProvider) : ArrayCollection
      {
         var _loc3_:String = null;
         var _loc4_:ArrayCollection = null;
         var _loc5_:ArrayCollection = null;
         var _loc6_:Spell = null;
         var _loc2_:Dictionary = new Dictionary();
         for each(_loc3_ in param1.getInventory().knownGameModesForSpells)
         {
            _loc2_[_loc3_] = GameFlowVariantFactory.instance.getVariant(null,_loc3_).showsAssociatedSpellsInProfile();
         }
         _loc4_ = new ArrayCollection();
         _loc5_ = param1.getInventoryController().getActiveSpells();
         for each(_loc6_ in _loc5_)
         {
            for each(_loc3_ in _loc6_.gameModes)
            {
               if(_loc2_[_loc3_])
               {
                  _loc4_.addItem(_loc6_);
                  break;
               }
            }
         }
         return _loc4_;
      }
      
      private function spellSortCompare(param1:Spell, param2:Spell) : int
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(param1 == param2)
         {
            return 0;
         }
         if(param2.minLevel == param1.minLevel)
         {
            _loc3_ = RiotResourceLoader.getSpellResourceString("name",param1.name,param1.name + "*");
            _loc4_ = RiotResourceLoader.getSpellResourceString("name",param2.name,param2.name + "*");
            if(_loc4_.toLocaleLowerCase() > _loc3_.toLocaleLowerCase())
            {
               return -1;
            }
            return 1;
         }
         if(param2.minLevel > param1.minLevel)
         {
            return -1;
         }
         return 1;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.spellGridSizer = new SpriteProxy(this);
         this.spellGridSizer.getLayoutInvalidated().add(invalidateLayout);
         setTimelineChildByName("spellGridSizer",this.spellGridSizer);
         this.spellGrid = new DataGroup(this);
         var _loc1_:VirtualizedTileLayout = new VirtualizedTileLayout();
         _loc1_.setCols(4);
         this.spellGrid.setLayoutAlgorithm(_loc1_);
         this.rendererFactory = new RendererFactory(SpellRenderer,[this]);
         this.spellGrid.setRendererFactory(this.rendererFactory);
         addChild(this.spellGrid);
         this.selectionBehavior = new SelectionBehavior(this.rendererFactory);
         this.selectionBehavior.allowMultipleSelection = false;
      }
      
      public function getSelectedSpell() : Spell
      {
         return Spell(this.selectionBehavior.getSelectedItem());
      }
      
      public function getSelectedSpellChanged() : ISignal
      {
         return this.selectionBehavior.getSelectedItemsChanged();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this.spellGrid.setExplicitSize(this.spellGridSizer.getWidth(),this.spellGridSizer.getHeight());
         this.spellGrid.setExplicitPosition(this.spellGridSizer.getX(),this.spellGridSizer.getY());
         return super.updateLayout(param1,param2);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.rendererFactory.destroy();
         this.selectionBehavior.destroy();
      }
   }
}

