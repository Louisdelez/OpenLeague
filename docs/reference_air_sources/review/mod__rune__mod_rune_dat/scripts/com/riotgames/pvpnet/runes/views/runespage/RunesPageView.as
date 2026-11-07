package com.riotgames.pvpnet.runes.views.runespage
{
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.IToolTipManager;
   import blix.context.IContext;
   import com.greensock.TweenLite;
   import com.greensock.easing.Sine;
   import com.riotgames.platform.common.provider.IRuneBookController;
   import com.riotgames.pvpnet.runes.viewcontroller.RuneCombinerViewController;
   import com.riotgames.pvpnet.runes.viewcontroller.RunesTransportationController;
   import com.riotgames.pvpnet.runes.viewcontroller.RunesViewController;
   import com.riotgames.pvpnet.tracking.trackers.runes.IRunesTracker;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class RunesPageView extends StatefulView
   {
      
      private var runesWorkspace:RuneAreasContainer;
      
      private var rM:IResourceManager = ResourceManager.getInstance();
      
      private var runesViewController:RunesViewController;
      
      private var runeCombinerViewController:RuneCombinerViewController;
      
      private var runesTransportationController:RunesTransportationController;
      
      private var runeBookController:IRuneBookController;
      
      private var toolTipManager:IToolTipManager;
      
      private var _runesTracker:IRunesTracker;
      
      public function RunesPageView(param1:IContext)
      {
         super(param1);
         setLinkage("RunesPage");
         setCurrentState("normal");
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.runesViewController = getDependency(RunesViewController);
         this.runesTransportationController = getDependency(RunesTransportationController);
         this.toolTipManager = getDependency(IToolTipManager);
         this.runeCombinerViewController = getDependency(RuneCombinerViewController);
         this.runeBookController = getDependency(IRuneBookController);
         this._runesTracker = getDependency(IRunesTracker);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.runesWorkspace = new RuneAreasContainer(this);
         setTimelineChildByName("runesWorkspace",this.runesWorkspace);
         this.runesViewController.getCurrentRuneBookPageChanged().add(this.onCurrentRuneBookpageChanged);
         this.onCurrentRuneBookpageChanged();
      }
      
      private function onCurrentRuneBookpageChanged() : void
      {
         this.fadeRunes();
      }
      
      private function fadeRunes() : void
      {
         this.runesWorkspace.setAlpha(0);
         TweenLite.to(this.runesWorkspace.getSetterProxy(),1,{
            "alpha":1,
            "ease":Sine.easeOut
         });
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.runesViewController.getCurrentRuneBookPageChanged().remove(this.onCurrentRuneBookpageChanged);
      }
   }
}

