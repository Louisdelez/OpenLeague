package com.riotgames.pvpnet.runes.views.runesbook
{
   import blix.context.IContext;
   import blix.ds.IListX;
   import blix.layout.LayoutContainerView;
   import blix.layout.algorithms.VerticalLayout;
   import blix.layout.vo.Padding;
   import com.riotgames.platform.gameclient.domain.Rune;
   import com.riotgames.platform.gameclient.domain.RuneSlot;
   import com.riotgames.platform.gameclient.domain.RuneType;
   import com.riotgames.pvpnet.runes.viewcontroller.RuneViewModel;
   import com.riotgames.pvpnet.runes.viewcontroller.RunesTransportationController;
   import com.riotgames.pvpnet.runes.viewcontroller.RunesViewController;
   import com.riotgames.pvpnet.tracking.trackers.runes.IRunesTracker;
   import flash.desktop.NativeDragManager;
   import flash.events.NativeDragEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class RunesAccordionView extends LayoutContainerView
   {
      
      private var marksListButton:RunesListButton;
      
      private var sealsListButton:RunesListButton;
      
      private var glyphsListButton:RunesListButton;
      
      private var quintsListButton:RunesListButton;
      
      private var marksBin:RuneBin;
      
      private var sealsBin:RuneBin;
      
      private var glyphsBin:RuneBin;
      
      private var quintsBin:RuneBin;
      
      private var runesTransportationController:RunesTransportationController;
      
      private var runesViewController:RunesViewController;
      
      private var _runesTracker:IRunesTracker;
      
      private var runeModel:RuneViewModel;
      
      public function RunesAccordionView(param1:IContext)
      {
         super(param1);
         var _loc2_:VerticalLayout = new VerticalLayout();
         _loc2_.setPadding(new Padding(1,1,1,1));
         _loc2_.setGap(0);
         setLayoutAlgorithm(_loc2_);
         this.watchRuneBookController();
         addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,this.onNativeDragEnter);
         addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,this.onNativeDragDrop);
      }
      
      private function onNativeDragDrop(param1:NativeDragEvent) : void
      {
         var _loc2_:RuneSlot = null;
         var _loc3_:Rune = null;
         if(param1.clipboard.hasFormat(RuneSlot.DATA_FORMAT))
         {
            _loc2_ = param1.clipboard.getData(RuneSlot.DATA_FORMAT) as RuneSlot;
            if(_loc2_)
            {
               this._runesTracker.incrementRunes_UserDragAndDropToRemoveTotal_Count_InASession();
               this.runesTransportationController.removeRuneFromSlot(_loc2_);
            }
         }
         else if(param1.clipboard.hasFormat(Rune.DATA_FORMAT))
         {
            _loc3_ = param1.clipboard.getData(Rune.DATA_FORMAT) as Rune;
            if(_loc3_)
            {
               this.runesTransportationController.removeRuneFromCombiner(_loc3_);
            }
         }
      }
      
      private function onNativeDragEnter(param1:NativeDragEvent) : void
      {
         if(Boolean(param1.clipboard.hasFormat(RuneSlot.DATA_FORMAT)) || Boolean(param1.clipboard.hasFormat(Rune.DATA_FORMAT)))
         {
            NativeDragManager.acceptDragDrop(getInteractiveAsset());
         }
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.runeModel = getDependency(RuneViewModel);
         this.runesTransportationController = getDependency(RunesTransportationController);
         this._runesTracker = getDependency(IRunesTracker);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         this.marksBin = new RuneBin(this);
         this.marksListButton = new RunesListButton(this,this.marksBin);
         this.marksListButton.setListType(RuneType.RED_RUNE);
         this.marksListButton.setWeight(1);
         this.marksListButton.setTitle(_loc1_.getString("resources","runebook_runeInventory_red"));
         setTimelineChildByName("marksListButton",this.marksListButton);
         addElement(this.marksListButton);
         setTimelineChildByName("marksBin",this.marksBin);
         addElement(this.marksBin);
         this.sealsBin = new RuneBin(this);
         this.sealsListButton = new RunesListButton(this,this.sealsBin);
         this.sealsListButton.setListType(RuneType.YELLOW_RUNE);
         this.sealsListButton.setWeight(1);
         this.sealsListButton.setTitle(_loc1_.getString("resources","runebook_runeInventory_yellow"));
         setTimelineChildByName("sealsListButton",this.sealsListButton);
         addElement(this.sealsListButton);
         setTimelineChildByName("sealsBin",this.sealsBin);
         addElement(this.sealsBin);
         this.glyphsBin = new RuneBin(this);
         this.glyphsListButton = new RunesListButton(this,this.glyphsBin);
         this.glyphsListButton.setListType(RuneType.BLUE_RUNE);
         this.glyphsListButton.setWeight(1);
         this.glyphsListButton.setTitle(_loc1_.getString("resources","runebook_runeInventory_blue"));
         setTimelineChildByName("glyphsListButton",this.glyphsListButton);
         addElement(this.glyphsListButton);
         setTimelineChildByName("glyphsBin",this.glyphsBin);
         addElement(this.glyphsBin);
         this.quintsBin = new RuneBin(this);
         this.quintsListButton = new RunesListButton(this,this.quintsBin);
         this.quintsListButton.setListType(RuneType.BLACK_RUNE);
         this.quintsListButton.setWeight(1);
         this.quintsListButton.setTitle(_loc1_.getString("resources","runebook_runeInventory_black"));
         setTimelineChildByName("quintsListButton",this.quintsListButton);
         addElement(this.quintsListButton);
         setTimelineChildByName("quintsBin",this.quintsBin);
         addElement(this.quintsBin);
      }
      
      private function watchRuneBookController() : void
      {
         this.handleGlyphsChanged(this.runeModel.getGlyphs());
         this.handleMarksChanged(this.runeModel.getMarks());
         this.handleSealsChanged(this.runeModel.getSeals());
         this.handleQuintsChanged(this.runeModel.getQuints());
         this.runeModel.getGlyphsChanged().add(this.handleGlyphsChanged);
         this.runeModel.getMarksChanged().add(this.handleMarksChanged);
         this.runeModel.getSealsChanged().add(this.handleSealsChanged);
         this.runeModel.getQuintsChanged().add(this.handleQuintsChanged);
      }
      
      private function handleGlyphsChanged(param1:IListX) : void
      {
         this.glyphsListButton.setRunes(param1);
         this.glyphsBin.setRunes(param1);
      }
      
      private function handleMarksChanged(param1:IListX) : void
      {
         this.marksListButton.setRunes(param1);
         this.marksBin.setRunes(param1);
      }
      
      private function handleSealsChanged(param1:IListX) : void
      {
         this.sealsListButton.setRunes(param1);
         this.sealsBin.setRunes(param1);
      }
      
      private function handleQuintsChanged(param1:IListX) : void
      {
         this.quintsListButton.setRunes(param1);
         this.quintsBin.setRunes(param1);
      }
   }
}

