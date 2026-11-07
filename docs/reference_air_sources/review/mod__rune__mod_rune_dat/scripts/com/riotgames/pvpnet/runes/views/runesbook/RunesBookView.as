package com.riotgames.pvpnet.runes.views.runesbook
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.CheckBoxX;
   import blix.components.dropdown.DropDown;
   import blix.components.text.Text;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.pvpnet.runes.viewcontroller.RuneFilter;
   import com.riotgames.pvpnet.runes.viewcontroller.RunesViewController;
   import com.riotgames.pvpnet.tracking.trackers.runes.IRunesTracker;
   import com.riotgames.rust.data.ListAdapter;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class RunesBookView extends StatefulView
   {
      
      private var tier1Checkbox:CheckBoxX;
      
      private var tier2Checkbox:CheckBoxX;
      
      private var tier3Checkbox:CheckBoxX;
      
      private var tierTextField:Text;
      
      private var runesScroller:RunesScroller;
      
      private var runesTypeLabel:TextFieldProxy;
      
      private var runeTypeDropdown:DropDown;
      
      private var runesViewController:RunesViewController;
      
      private var _runesTracker:IRunesTracker;
      
      private var _runeFilter:RuneFilter;
      
      public function RunesBookView(param1:IContext)
      {
         super(param1);
         setCurrentState("normal");
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.runesViewController = getDependency(RunesViewController);
         this._runesTracker = getDependency(IRunesTracker);
         this._runeFilter = getDependency(RuneFilter);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         this.tier1Checkbox = new CheckBoxX(this);
         setTimelineChildByName("tier1",this.tier1Checkbox);
         this.tier1Checkbox.setText("1");
         this.tier1Checkbox.setSelected(true);
         this.tier1Checkbox.getSelectedChanged().add(this.onTier1FilterChanged);
         this.tier2Checkbox = new CheckBoxX(this);
         setTimelineChildByName("tier2",this.tier2Checkbox);
         this.tier2Checkbox.setText("2");
         this.tier2Checkbox.setSelected(true);
         this.tier2Checkbox.getSelectedChanged().add(this.onTier2FilterChanged);
         this.tier3Checkbox = new CheckBoxX(this);
         setTimelineChildByName("tier3",this.tier3Checkbox);
         this.tier3Checkbox.setText("3");
         this.tier3Checkbox.setSelected(true);
         this.tier3Checkbox.getSelectedChanged().add(this.onTier3FilterChanged);
         this.tierTextField = new Text(this);
         setTimelineChildByName("tierTextField",this.tierTextField);
         this.tierTextField.setText(_loc1_.getString("resources","runebook_tooltip_tier",[""]));
         this.runesScroller = new RunesScroller(this);
         setTimelineChildByName("runesScroller",this.runesScroller);
         this.runesTypeLabel = new TextFieldProxy(this);
         setTimelineChildByName("runesTypeLabel",this.runesTypeLabel);
         this.runesTypeLabel.setText(_loc1_.getString("resources","runebook_type_label"));
         this.runeTypeDropdown = new DropDown(this);
         this.runeTypeDropdown.setListLinkage("RuneTypeDropDownList");
         setTimelineChildByName("runeTypeDropdown",this.runeTypeDropdown);
         this.runesViewController.getRuneBookControllerInitialized().add(this.onRuneBookControllerInitialized);
         if(this.runesViewController.getCategoryNames())
         {
            this.onRuneBookControllerInitialized();
         }
      }
      
      private function onRuneBookControllerInitialized() : void
      {
         this.runeTypeDropdown.setDataProvider(new ListAdapter(this.runesViewController.getCategoryNames()));
         this.runeTypeDropdown.getSelectionBehavior().setRangeSelected(0,0,true);
         this.runeTypeDropdown.getSelectionBehavior().getSelectedItemsChanged().add(this.onRuneTypeDropdownSelectionChanged);
      }
      
      private function onRuneTypeDropdownSelectionChanged() : void
      {
         this._runesTracker.incrementRunes_CategoryFilterChanged_Count_InASession();
         var _loc1_:int = int(this.runeTypeDropdown.getDataProvider().getItemIndex(this.runeTypeDropdown.getSelectionBehavior().getSelectedItem()));
         this._runeFilter.setRuneCategory(_loc1_);
      }
      
      private function onTier3FilterChanged(param1:CheckBoxX, param2:Boolean) : void
      {
         this._runesTracker.incrementRunes_TierFilterChanged_Count_InASession();
         this._runeFilter.setTier3Shown(param2);
      }
      
      private function onTier2FilterChanged(param1:CheckBoxX, param2:Boolean) : void
      {
         this._runesTracker.incrementRunes_TierFilterChanged_Count_InASession();
         this._runeFilter.setTier2Shown(param2);
      }
      
      private function onTier1FilterChanged(param1:CheckBoxX, param2:Boolean) : void
      {
         this._runesTracker.incrementRunes_TierFilterChanged_Count_InASession();
         this._runeFilter.setTier1Shown(param2);
      }
      
      override public function destroy() : void
      {
         this.runesViewController.getRuneBookControllerInitialized().remove(this.onRuneBookControllerInitialized);
         super.destroy();
      }
   }
}

